Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 332A87B71B9
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 21:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240923AbjJCT1e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 15:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbjJCT1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 15:27:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869E1AB
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 12:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696361209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SMBIdi2ioacPrgcNxZx8em/+qPteSdTdEA8YmTtjejM=;
        b=c3t5XJD4ph89EbD94HolUMuBVdSingk6dVvoJx03xjbA8pAp4G5IYDULgsFsZgvkdmKcIX
        p8/Qx7Cj34qqglgxm5dpwwO0/C5w5OwZj/VUPEGaXzjgvdBwwbbiJIwNumXVTJCBtenghs
        PHvRMQOpnj6X1TFyc1l7Hcj267HvtkA=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-zyf-EgVRNsmmI0H_lUUxTw-1; Tue, 03 Oct 2023 15:26:38 -0400
X-MC-Unique: zyf-EgVRNsmmI0H_lUUxTw-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7a28fff0e21so89340339f.1
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 12:26:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696361197; x=1696965997;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SMBIdi2ioacPrgcNxZx8em/+qPteSdTdEA8YmTtjejM=;
        b=g3B5PEejzpjW3w/dNQc5egesAfUedT3BrM1yq9yEvtFBmoQELuJjxju36hdq7CzSZ+
         WKrElILoHn13mOKOqS6I/wSbVUV9GaZjcRMh+De/KWLxljSvObeRN9gnrtaUiRSeC90+
         q7QV7j2+Hs8JjLEgGc1xjxVY6i31HF1QyaqaV8aP9GouNkbykKe4nAQkH04siCrWH9UV
         OEFFsuC1LZJ3HbU5qmkRR/lTDCh8t0hW3X80jF2LFwyXu3nbecdOSPyIxdRgT0Ccf9Yr
         swY6c3c6wKcmLT+ZdadypdLrPQU2T5dNR+ml/46BbGN5bu57vvVhtIAWCJz2D83RSi38
         wuow==
X-Gm-Message-State: AOJu0YzxEyz5rWXAAXfTPJqIfW0vM/CKf6bnCfAYYjcsCUj5UlROmuDJ
        U/WUfzThRn2xM8kz51ymR4VC1WnVnHtQRwBbEmEPqWiCdPOpmCakxMMcwO+oCXTpCs5BEln9WnN
        PQ1OcFiacbCBw
X-Received: by 2002:a5e:c908:0:b0:791:1e87:b47e with SMTP id z8-20020a5ec908000000b007911e87b47emr370016iol.15.1696361197714;
        Tue, 03 Oct 2023 12:26:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEUIE7D772U4N0qDPompsKRtvx1NT7mfvg4RI/jwspaPsXINk3ViMeEP2EeRC7fwg83oLza4Q==
X-Received: by 2002:a5e:c908:0:b0:791:1e87:b47e with SMTP id z8-20020a5ec908000000b007911e87b47emr370006iol.15.1696361197459;
        Tue, 03 Oct 2023 12:26:37 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id h11-20020a02cd2b000000b0043194542229sm507033jaq.52.2023.10.03.12.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 12:26:36 -0700 (PDT)
Date:   Tue, 3 Oct 2023 13:26:35 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     liulongfang <liulongfang@huawei.com>
Cc:     <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <jonathan.cameron@huawei.com>, <bcreeley@amd.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>
Subject: Re: [PATCH v16 2/2] Documentation: add debugfs description for vfio
Message-ID: <20231003132635.7df44c44.alex.williamson@redhat.com>
In-Reply-To: <20230926093356.56014-3-liulongfang@huawei.com>
References: <20230926093356.56014-1-liulongfang@huawei.com>
        <20230926093356.56014-3-liulongfang@huawei.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 26 Sep 2023 17:33:56 +0800
liulongfang <liulongfang@huawei.com> wrote:

> From: Longfang Liu <liulongfang@huawei.com>
> 
> 1.Add an debugfs document description file to help users understand
> how to use the accelerator live migration driver's debugfs.
> 2.Update the file paths that need to be maintained in MAINTAINERS
> 
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  Documentation/ABI/testing/debugfs-vfio | 25 +++++++++++++++++++++++++
>  MAINTAINERS                            |  1 +
>  2 files changed, 26 insertions(+)
>  create mode 100644 Documentation/ABI/testing/debugfs-vfio
> 
> diff --git a/Documentation/ABI/testing/debugfs-vfio b/Documentation/ABI/testing/debugfs-vfio
> new file mode 100644
> index 000000000000..7959ec5ac445
> --- /dev/null
> +++ b/Documentation/ABI/testing/debugfs-vfio
> @@ -0,0 +1,25 @@
> +What:		/sys/kernel/debug/vfio
> +Date:		Sep 2023
> +KernelVersion:  6.7
> +Contact:	Longfang Liu <liulongfang@huawei.com>
> +Description:	This debugfs file directory is used for debugging
> +		of vfio devices, it's a common directory for all vfio devices.
> +		Vfio core will create a device subdirectory under this
> +		directory.
> +
> +What:		/sys/kernel/debug/vfio/<device>/migration
> +Date:		Sep 2023
> +KernelVersion:  6.7
> +Contact:	Longfang Liu <liulongfang@huawei.com>
> +Description:	This debugfs file directory is used for debugging
> +		of vfio devices that support live migration.
> +		The debugfs of each vfio device that supports live migration
> +		could be created under this directory.
> +
> +What:		/sys/kernel/debug/vfio/<device>/migration/state
> +Date:		Sep 2023
> +KernelVersion:  6.7
> +Contact:	Longfang Liu <liulongfang@huawei.com>
> +Description:	Read the live migration status of the vfio device.
> +		The status of these live migrations includes:
> +		ERROR, RUNNING, STOP, STOP_COPY, RESUMING.

This is another area that's doomed to be out of sync, it's already not
updated for P2P states.  Better to avoid the problem and say something
like "The contents of the state file reflects the migration state
relative to those defined in the vfio_device_mig_state enum".

Also, as suggested last time, October is a more realistic date.  Thanks,

Alex

> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7b1306615fc0..bd01ca674c60 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22304,6 +22304,7 @@ L:	kvm@vger.kernel.org
>  S:	Maintained
>  T:	git https://github.com/awilliam/linux-vfio.git
>  F:	Documentation/ABI/testing/sysfs-devices-vfio-dev
> +F:	Documentation/ABI/testing/debugfs-vfio
>  F:	Documentation/driver-api/vfio.rst
>  F:	drivers/vfio/
>  F:	include/linux/vfio.h

