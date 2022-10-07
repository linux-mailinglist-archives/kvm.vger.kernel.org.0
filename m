Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4901C5F79B2
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 16:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiJGOb6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 10:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiJGObz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 10:31:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B7CFD0CE9
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 07:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665153113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HxEauzp9sdLUt/6pB/n85Z6ivdOEHoUl5EcYQVskSbw=;
        b=QPDbsneq0ppUmH2OkK9SvcQPWHoXQuzPrtPOO50PUduDAhJsOH0SVEHn5DnWvuvNoa9UBH
        R1DH8e+E89mc2qAhkw4oakDfDM0BHinS7PI6mW03WLXG0d6OA2XavjCxfg5tNjfocNEtXT
        pMof/thycWiPC4QfceLkdB4zc/1yrp8=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-634-nNclD37CMEGupXq7xW98Cg-1; Fri, 07 Oct 2022 10:31:52 -0400
X-MC-Unique: nNclD37CMEGupXq7xW98Cg-1
Received: by mail-qk1-f200.google.com with SMTP id h8-20020a05620a284800b006b5c98f09fbso3915239qkp.21
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 07:31:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HxEauzp9sdLUt/6pB/n85Z6ivdOEHoUl5EcYQVskSbw=;
        b=oP5z8Zp982SWgyHqLrGsn7JL6iSf9fmSORpg22TvjbdeKRISBGuZ6ldeOawmeqCBW/
         bzTSeP5ozjvEN011JYcADxTfBDYGGIOFZR0jH84GvYvgw/5izM/RiFs0orBblyuJcqyb
         aftHx+AhZYU+IATz2gLJllkxx2Lwsk/ZU5zYjyQyUNfrFWKiAsOcZE+ofWjp89hfF+rC
         MI/zx0DHgE80u79UvLgyeTYJD+HNkS76NcZOK/qL6FKOYD/fdBchbsu+liwfIXNmyFe/
         wNkd3pljnWXQPqNAlbwQ7shKl8TMLpGUquOD042dUIQ57nDPmSBW29rjJHyLc7LBYtBl
         8iWQ==
X-Gm-Message-State: ACrzQf1l2oMtaXZkYoytCzsOa+nFIS1RnTF4ojSwpiJJlBL0xdJGgQtH
        e95X2xNOnklzj0wU+EM4dZKYiopfhuFEcMUbCnJU1ZKEtpIGMqKpV3hheFT3kKF3FgJ239Qq12a
        ys8i7BzI8btjz
X-Received: by 2002:a37:6942:0:b0:6cf:22d6:a887 with SMTP id e63-20020a376942000000b006cf22d6a887mr3863263qkc.0.1665153111879;
        Fri, 07 Oct 2022 07:31:51 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7et6JpjguAseN/XDUanmE5zbkPsy7bnACNGzAbNBtnH2AIuFYJNa3uHlSqWN3/qSe+3ak+lg==
X-Received: by 2002:a37:6942:0:b0:6cf:22d6:a887 with SMTP id e63-20020a376942000000b006cf22d6a887mr3863243qkc.0.1665153111617;
        Fri, 07 Oct 2022 07:31:51 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id bk5-20020a05620a1a0500b006af3f3b385csm2137607qkb.98.2022.10.07.07.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 07:31:50 -0700 (PDT)
Date:   Fri, 7 Oct 2022 10:31:49 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, catalin.marinas@arm.com, bgardon@google.com,
        shuah@kernel.org, andrew.jones@linux.dev, will@kernel.org,
        dmatlack@google.com, pbonzini@redhat.com, zhenyzha@redhat.com,
        james.morse@arm.com, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev,
        seanjc@google.com, shan.gavin@gmail.com
Subject: Re: [PATCH v5 3/7] KVM: x86: Allow to use bitmap in ring-based dirty
 page tracking
Message-ID: <Y0A4VaSwllsSrVxT@x1n>
References: <20221005004154.83502-1-gshan@redhat.com>
 <20221005004154.83502-4-gshan@redhat.com>
 <Yz86gEbNflDpC8As@x1n>
 <a5e291b9-e862-7c71-3617-1620d5a7d407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a5e291b9-e862-7c71-3617-1620d5a7d407@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 07, 2022 at 07:38:19AM +0800, Gavin Shan wrote:
> Hi Peter,

Hi, Gavin,

> 
> On 10/7/22 4:28 AM, Peter Xu wrote:
> > On Wed, Oct 05, 2022 at 08:41:50AM +0800, Gavin Shan wrote:
> > > -8.29 KVM_CAP_DIRTY_LOG_RING/KVM_CAP_DIRTY_LOG_RING_ACQ_REL
> > > -----------------------------------------------------------
> > > +8.29 KVM_CAP_DIRTY_LOG_{RING, RING_ACQ_REL, RING_ALLOW_BITMAP}
> > > +--------------------------------------------------------------
> > 
> > Shall we make it a standalone cap, just to rely on DIRTY_RING[_ACQ_REL]
> > being enabled first, instead of making the three caps at the same level?
> > 
> > E.g. we can skip creating bitmap for DIRTY_RING[_ACQ_REL] && !_ALLOW_BITMAP
> > (x86).
> > 
> 
> Both KVM_CAP_DIRTY_LOG_RING and KVM_CAP_DIRTY_LONG_RING_ACQ_REL are available
> to x86. So KVM_CAP_DIRTY_LONG_RING_ACQ_REL can be enabled on x86 in theory.
> However, the idea to disallow bitmap for KVM_CAP_DIRTY_LOG_RING (x86) makes
> sense to me. I think you may be suggesting something like below.
> 
> - bool struct kvm::dirty_ring_allow_bitmap
> 
> - In kvm_vm_ioctl_enable_dirty_log_ring(), set 'dirty_ring_allow_bitmap' to
>   true when the capability is KVM_CAP_DIRTY_LONG_RING_ACQ_REL

What I wanted to do is to decouple the ACQ_REL with ALLOW_BITMAP, so mostly
as what you suggested, except..

> 
>   static int kvm_vm_ioctl_enable_dirty_log_ring(struct kvm *kvm, u32 cap, u32 size)
>   {
>     :
>     mutex_lock(&kvm->lock);
> 
>     if (kvm->created_vcpus) {
>        /* We don't allow to change this value after vcpu created */
>        r = -EINVAL;
>     } else {
>        kvm->dirty_ring_size = size;

.. here I'd not set dirty_ring_allow_bitmap at all so I'd drop below line,
instead..

>        kvm->dirty_ring_allow_bitmap = (cap == KVM_CAP_DIRTY_LOG_RING_ACQ_REL);
>        r = 0;
>     }
> 
>     mutex_unlock(&kvm->lock);
>     return r;
>   }
> - In kvm_vm_ioctl_check_extension_generic(), KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP
>   is always flase until KVM_CAP_DIRTY_LOG_RING_ACQ_REL is enabled.
> 
>   static long kvm_vm_ioctl_check_extension_generic(...)
>   {
>     :
>     case KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP:
>         return kvm->dirty_ring_allow_bitmap ? 1 : 0;

... here we always return 1, OTOH in kvm_vm_ioctl_enable_cap_generic():

      case KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP:
           if (kvm->dirty_ring_size)
                return -EINVAL;
           kvm->dirty_ring_allow_bitmap = true;
           return 0;

A side effect of checking dirty_ring_size is then we'll be sure to have no
vcpu created too.  Maybe we should also check no memslot created to make
sure the bitmaps are not created.

Then if the userspace wants to use the bitmap altogether with the ring, it
needs to first detect KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP and enable it
before it enables KVM_CAP_DIRTY_LOG_RING.

One trick on ALLOW_BITMAP is in mark_page_dirty_in_slot() - after we allow
!vcpu case we'll need to make sure it won't accidentally try to set bitmap
for !ALLOW_BITMAP, because in that case the bitmap pointer is NULL so
set_bit_le() will directly crash the kernel.

We could keep the old flavor of having a WARN_ON_ONCE(!vcpu &&
!ALLOW_BITMAP) then return, but since now the userspace can easily trigger
this (e.g. on ARM, a malicious userapp can have DIRTY_RING &&
!ALLOW_BITMAP, then it can simply trigger the gic ioctl to trigger host
warning), I think the better approach is we can kill the process in that
case.  Not sure whether there's anything better we can do.

>   }
> 
> - The suggested dirty_ring_exclusive() is used.
> 
> > > @@ -2060,10 +2060,6 @@ int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
> > >   	unsigned long n;
> > >   	unsigned long any = 0;
> > > -	/* Dirty ring tracking is exclusive to dirty log tracking */
> > > -	if (kvm->dirty_ring_size)
> > > -		return -ENXIO;
> > 
> > Then we can also have one dirty_ring_exclusive(), with something like:
> > 
> > bool dirty_ring_exclusive(struct kvm *kvm)
> > {
> >          return kvm->dirty_ring_size && !kvm->dirty_ring_allow_bitmap;
> > }
> > 
> > Does it make sense?  Thanks,
> > 
> 
> Thanks,
> Gavin
> 

-- 
Peter Xu

