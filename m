Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13DD87A546E
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 22:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjIRUwF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 16:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjIRUwE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 16:52:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BBE8181
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 13:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695070272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=THXh1C50UHURW8uY22mgz6II3159Rek3+k7Hf/FFQlY=;
        b=eFhHpXpii+fRbWRQ7irnBMtbS8fv8aWqmR4VVGnoN7m/pXwryaKhg7XO6uIBx8yhaP0wkR
        x5g6+Bbj5Ki8Nf/bHRCx71wzIevfLefEHUsp9uihx3SX1q/f2z9aeS/95B2C+xT2TA4fFS
        CU87tdB78lG3r90Ic4qde5uR1Ct2ieE=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-93-_bbCNNOiMnCrsF09D15mcA-1; Mon, 18 Sep 2023 16:51:10 -0400
X-MC-Unique: _bbCNNOiMnCrsF09D15mcA-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-79554d73bd6so459769139f.1
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 13:51:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695070269; x=1695675069;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=THXh1C50UHURW8uY22mgz6II3159Rek3+k7Hf/FFQlY=;
        b=su6QMwruFzU0xSE+2rLe8EfdFD91mqwOknp8u9meAd/8dPJD9CHfQ2/Ue3YUnSQP20
         HzK8xTBZo3kV6Aq+tiD7JLz26wMAPvcgjuErxEuDzoYB68aK0OVas428UQoNkJwrVvWf
         9wfy1i45Dv5UVTe/wwr+wcHXmL3sPQsMq8mmNdBC7RGeW12zU4RLKZ8ddNxuiPZNouye
         G4b3KHf/CNrvYTBA/tPbgt8k+q45uD7xmpe5Z1uwVv+QsXSLaN2/SilaUjHa5UyArc13
         a9DXdPZNNmqUPr9+Vm2NirjuFloll6k8fLIDONsMFEheLJEWqqrVX6qjXkGa+ccF2Hml
         avfQ==
X-Gm-Message-State: AOJu0YxNzpi95SR4AylF0OH0ABLmdjbIVijbzQTX9HK2Irv8GEuZOCFO
        Vt4dLc9fDaSnmFHD9hDgTupaHjlUjkWB4g+h0LyDCl17lu7XGGhI+EqUESe3lVAw3tcJmpc2lvn
        UeYOQMQgWT3aW/Vvg1qI+
X-Received: by 2002:a5d:9557:0:b0:790:aedd:3e81 with SMTP id a23-20020a5d9557000000b00790aedd3e81mr11696528ios.8.1695070269174;
        Mon, 18 Sep 2023 13:51:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF9cmrUg9h2SneqkurK+T9MN62PPsrrL+PihFiMIDKne7N6HO9p7OIDQ1ghPfwUwqfSS/Bj8g==
X-Received: by 2002:a5d:9557:0:b0:790:aedd:3e81 with SMTP id a23-20020a5d9557000000b00790aedd3e81mr11696518ios.8.1695070268957;
        Mon, 18 Sep 2023 13:51:08 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id c22-20020a5ea816000000b00786fe5039b8sm3010849ioa.46.2023.09.18.13.51.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 13:51:08 -0700 (PDT)
Date:   Mon, 18 Sep 2023 14:51:06 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     oushixiong <oushixiong@kylinos.cn>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Brett Creeley <brett.creeley@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/pds: Use proper PF device access helper
Message-ID: <20230918145106.6d3c77fb.alex.williamson@redhat.com>
In-Reply-To: <20230914021332.1929155-1-oushixiong@kylinos.cn>
References: <20230914021332.1929155-1-oushixiong@kylinos.cn>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Sep 2023 10:13:32 +0800
oushixiong <oushixiong@kylinos.cn> wrote:

> From: Shixiong Ou <oushixiong@kylinos.cn>
> 
> The pci_physfn() helper exists to support cases where the physfn
> field may not be compiled into the pci_dev structure. We've
> declared this driver dependent on PCI_IOV to avoid this problem,
> but regardless we should follow the precedent not to access this
> field directly.
> 
> Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
> ---
> 
> This patch changes the subject line and commit log, and the previous 
> patch's links is:
> 	https://patchwork.kernel.org/project/kvm/patch/20230911080828.635184-1-oushixiong@kylinos.cn/
> 
>  drivers/vfio/pci/pds/vfio_dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to vfio for-linus branch for v6.6.  Thanks,

Alex

> 
> diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
> index b46174f5eb09..649b18ee394b 100644
> --- a/drivers/vfio/pci/pds/vfio_dev.c
> +++ b/drivers/vfio/pci/pds/vfio_dev.c
> @@ -162,7 +162,7 @@ static int pds_vfio_init_device(struct vfio_device *vdev)
>  	pci_id = PCI_DEVID(pdev->bus->number, pdev->devfn);
>  	dev_dbg(&pdev->dev,
>  		"%s: PF %#04x VF %#04x vf_id %d domain %d pds_vfio %p\n",
> -		__func__, pci_dev_id(pdev->physfn), pci_id, vf_id,
> +		__func__, pci_dev_id(pci_physfn(pdev)), pci_id, vf_id,
>  		pci_domain_nr(pdev->bus), pds_vfio);
>  
>  	return 0;

