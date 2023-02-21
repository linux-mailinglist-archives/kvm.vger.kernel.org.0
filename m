Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADF9669DA26
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 05:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbjBUEkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 23:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbjBUEkK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 23:40:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA8A13DDE
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 20:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676954361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N7+6xIEmebDEUveUUKUY6ZCab4T5sVfNahVp+jcAmc4=;
        b=f1d1iJDXZgo9IziOcro44HC8USn6kseZO5QFf0OAicW+a2GF7RnlwNJ2/vqU/KGSlVp8Ms
        qdcfz+poux6Jx9F9rxDc0zcj7gQywmX8mbxXrH3vKRt8vPhohyZk/kDXF5oZ6L8d1Lp0y5
        wRXSVZekRsugT2oSTf18thNhyv6hroE=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-209-tA62ZFnCMyujCZQXaslcSA-1; Mon, 20 Feb 2023 23:39:20 -0500
X-MC-Unique: tA62ZFnCMyujCZQXaslcSA-1
Received: by mail-il1-f197.google.com with SMTP id 4-20020a056e0211a400b003157534461aso986017ilj.11
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 20:39:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N7+6xIEmebDEUveUUKUY6ZCab4T5sVfNahVp+jcAmc4=;
        b=aD0echwtSma2GCyHKHhXzdiDfobXw8CBneKb/+Bif0itrkDgWA4r/696ZiItcPm3IH
         OyLFUWZ14P77uIjy/Tfxz7nc2rznI4tUBVGElmrkqt+Ark+p1B/tGE/Mzz6u+AmtMZkf
         PX4V54amTOdYMZAvOTVgAFtwiFD9EkNuYmC/FWtqzvkIEHlDKHb+C1BDIDR2n9N7VoRg
         ChySN34cmsg9ksCgnwx1HsT0eDMGYWsTPrZOldYrhAKOuhMRFVqJisNOH4NEM5HdsDtK
         FTlUvfcWbTvVbdpeUbR/Ko6NJRXNGLpI7x0R4nUlT2XRkWjdVM39FoVxBt0E22elvCdd
         SweQ==
X-Gm-Message-State: AO0yUKVQqUtRQ4jzkCZSyt9d2Pa3NieCns47lonZ3QaFhcm1UdXR30l4
        CBK5c/dgdiZHxqJl3Bhm411rsb7r0yDn0i9w7x2n0V1I+mRcmF09CAXp2J6tmMUcum8eI4iP9Tg
        rPocvRbzx2wP3mLHssg==
X-Received: by 2002:a05:6e02:154c:b0:314:fa6:323c with SMTP id j12-20020a056e02154c00b003140fa6323cmr2658611ilu.12.1676954359637;
        Mon, 20 Feb 2023 20:39:19 -0800 (PST)
X-Google-Smtp-Source: AK7set9ZyEM18ZjmojED8UQ8xc1694pgaePa1iijkq0nOWLIOIv1TcqaREBJjZzRmf0qlnAg6C7wvg==
X-Received: by 2002:a05:6e02:154c:b0:314:fa6:323c with SMTP id j12-20020a056e02154c00b003140fa6323cmr2658599ilu.12.1676954359382;
        Mon, 20 Feb 2023 20:39:19 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id q24-20020a02cf18000000b003c41434babdsm619868jar.92.2023.02.20.20.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 20:39:18 -0800 (PST)
Date:   Mon, 20 Feb 2023 21:39:16 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     jgg@nvidia.com, kevin.tian@intel.com, cohuck@redhat.com,
        eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
        mjrosato@linux.ibm.com, chao.p.peng@linux.intel.com,
        yi.y.sun@linux.intel.com, pbonzini@redhat.com
Subject: Re: [PATCH] docs: kvm: vfio: Require call KVM_DEV_VFIO_GROUP_ADD
 before VFIO_GROUP_GET_DEVICE_FD
Message-ID: <20230220213916.212e03a4.alex.williamson@redhat.com>
In-Reply-To: <20230221034114.135386-1-yi.l.liu@intel.com>
References: <20230221034114.135386-1-yi.l.liu@intel.com>
Organization: Red Hat
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

On Mon, 20 Feb 2023 19:41:14 -0800
Yi Liu <yi.l.liu@intel.com> wrote:

> as some vfio_device's open_device op requires kvm pointer and kvm pointer
> set is part of GROUP_ADD.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  Documentation/virt/kvm/devices/vfio.rst | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/devices/vfio.rst b/Documentation/virt/kvm/devices/vfio.rst
> index 2d20dc561069..5722e283f1b5 100644
> --- a/Documentation/virt/kvm/devices/vfio.rst
> +++ b/Documentation/virt/kvm/devices/vfio.rst
> @@ -39,3 +39,8 @@ KVM_DEV_VFIO_GROUP attributes:
>  	- @groupfd is a file descriptor for a VFIO group;
>  	- @tablefd is a file descriptor for a TCE table allocated via
>  	  KVM_CREATE_SPAPR_TCE.
> +
> +::
> +
> +The GROUP_ADD operation above should be invoked before vfio_device's
> +open_device op which is called in the ioctl VFIO_GROUP_GET_DEVICE_FD.

Why only include the reasoning in the commit log and not the docs?
Thanks,

Alex

