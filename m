Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7BE865F683
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 23:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235725AbjAEWKk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 17:10:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235753AbjAEWK0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 17:10:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C7767BF0
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 14:09:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672956575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FHRon4iazglsqJx0za5dkKZ1ECmTBS5D3uCSiao/wBQ=;
        b=Z8nnAsIVsplhS9AxYvOfdZwdwcEPyHOeJ6oIGWrrxmjcU8Bgw0bSKGLVBTbUvDDm+E2FXd
        vlknkPchEfmjJOz1EdXV2LagO5Lt2LMyLnO7IHXD693zGSwAyEYcZuerrWn2eJGO2l607D
        HmgAHUP5Vwhnmw+Svy2b52XkqIjiNLw=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-381-a6ImTjHBOKSo_L14yZSifw-1; Thu, 05 Jan 2023 17:09:33 -0500
X-MC-Unique: a6ImTjHBOKSo_L14yZSifw-1
Received: by mail-il1-f198.google.com with SMTP id z19-20020a921a53000000b0030b90211df1so18954ill.2
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 14:09:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FHRon4iazglsqJx0za5dkKZ1ECmTBS5D3uCSiao/wBQ=;
        b=1yKnkUg0Gi1y0LtXd1qX6FZ0HeETGFMh/+5CCGVA0J6YPEXRdSdvPRMwDd89oeNJjF
         +YQtcIkK3wcxD1ThccrvSaSLMrckosZwmaifLP+MFdu60FB1RXWLftLZ8mkDuuvUAPfM
         maMo4wiq1Vqndb2e6MBoXb6+SaI+DBLmupscPlVtVWnQqJ+F+A8tNOMYi74JtkH0MZ9x
         Q1HsLAMJVdHSSG9sjMv2AfWaMdunQX3fkDgdpBcSXnO2shuH7V6NbFMQHfTYpBELt1RM
         FQSFcb0s/DQ4hnOcC5eblaQUJtrSUafgrqDwkGT0196UM84GUAneizCDDfatJVadKPwr
         JZSg==
X-Gm-Message-State: AFqh2kqG/CfGGxlu30j3DF0OxvFX6KcNPN7bSiUJUjeWM0b7GjcimrpY
        uH6VRh3dIk3LZWS+udW4lURLwPJll+ba03/uuaDjZD9sreiPSDnoO0GRaHZBe/FeKL8WuDATJ0X
        Rlw2zbKvuGaz6
X-Received: by 2002:a5e:a609:0:b0:6e4:2893:2b33 with SMTP id q9-20020a5ea609000000b006e428932b33mr32962714ioi.14.1672956573186;
        Thu, 05 Jan 2023 14:09:33 -0800 (PST)
X-Google-Smtp-Source: AMrXdXs5yKX/wdLm9HEyg87onxVqgfS0N/eR1/PgmgN9uAH7OlTthfhrG0MhtGAnQyZQ6XYAeeVAMA==
X-Received: by 2002:a5e:a609:0:b0:6e4:2893:2b33 with SMTP id q9-20020a5ea609000000b006e428932b33mr32962706ioi.14.1672956572929;
        Thu, 05 Jan 2023 14:09:32 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id w12-20020a5e970c000000b006e3170eeee4sm13692498ioj.6.2023.01.05.14.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 14:09:32 -0800 (PST)
Date:   Thu, 5 Jan 2023 15:09:30 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     jgg@nvidia.com, cohuck@redhat.com, borntraeger@linux.ibm.com,
        jjherne@linux.ibm.com, akrowiak@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, hch@infradead.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kevin Tian <kevin.tian@intel.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 1/1] vfio: remove VFIO_GROUP_NOTIFY_SET_KVM
Message-ID: <20230105150930.6ee65182.alex.williamson@redhat.com>
In-Reply-To: <20220519183311.582380-2-mjrosato@linux.ibm.com>
References: <20220519183311.582380-1-mjrosato@linux.ibm.com>
        <20220519183311.582380-2-mjrosato@linux.ibm.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 19 May 2022 14:33:11 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> Rather than relying on a notifier for associating the KVM with
> the group, let's assume that the association has already been
> made prior to device_open.  The first time a device is opened
> associate the group KVM with the device.
> 
> This fixes a user-triggerable oops in GVT.

It seems this has traded an oops for a deadlock, which still exists
today in both GVT-g and vfio-ap.  These are the only vfio drivers that
care about kvm, so they make use of kvm_{get,put}_kvm(), where the
latter is called by their .close_device() callbacks.

.close_device() is called holding the group->group_lock, or at the time
of this commit group->group_rwsem.  The remaining call chain looks like
this:

kvm_put_kvm
 -> kvm_destroy_vm
  -> kvm_destroy_devices
   -> kvm_vfio_destroy
    -> kvm_vfio_file_set_kvm
     -> vfio_file_set_kvm
      -> group->group_lock/group_rwsem

Any suggestions for a fix?  Thanks,

Alex

