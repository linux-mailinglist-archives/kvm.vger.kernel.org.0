Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14DB55FA8BA
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 01:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiJJXtf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 19:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbiJJXt1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 19:49:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA68B7960E
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 16:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665445759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ECL7l2qNjN7HZ8FHjWdy2QLrc8mqWYLOaevH3XZ/d1Y=;
        b=dsKaRHjPmB3oFakCjIR566YRxtbsUsOKB//0xmKNh0NlVOVWjCIbvkeFATqMxX4q1+h7I4
        i7krwIKEBYxsfKPX9xbGpcX7jhjHm+Qj0UWgk6tmuO2ybeAPwWjDmmedt4EYxl2B1jgz61
        1mgFENWy8cxV5q/poBoyPDrKDEb3LbE=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-280-OedxEBWqN8yKATv28X2qsQ-1; Mon, 10 Oct 2022 19:49:18 -0400
X-MC-Unique: OedxEBWqN8yKATv28X2qsQ-1
Received: by mail-qv1-f70.google.com with SMTP id lu3-20020a0562145a0300b004b1d6f4130eso6841180qvb.1
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 16:49:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ECL7l2qNjN7HZ8FHjWdy2QLrc8mqWYLOaevH3XZ/d1Y=;
        b=E4aeyp238gecvVLGzVRhj5H6PlTAfGJbuqLd7Z14WjFYAkVHqXf0NOtyn5OU9PqBgG
         aDJPAkQY5ppROMH3zdCOXqEvDAh7DPaE1LCNAeXolbC/X0A1MumF8UVtCpmaX7Rje3Sq
         mFusbfApW7wULpFSWsOGNy+mlkkkuqkSw18DpGfv0nR3/GSOw6ev5ZUT6wN0Olm6fqsU
         zKV/cPj9Ftotfzwzh1Sjhbm7CfZwbaymBlsSTtMGmpE6/KsVMr6RsRrt/4ieuHVV8nEu
         j7wmd+aiM7hTKOgFwepeYS0p7YZoWnC6dxHUfzwYz05q1b4zshsIKhKtKAt+ocp/XTGO
         iq7Q==
X-Gm-Message-State: ACrzQf1du0SN7tWSm19qmvLbl1HuVRYndyHi31ZNphI1nS5T5uoNwgzE
        2uStN76MmoFnR+raucW8PZ76g8GSnV3WLdu1xb4HQ1jhfOSLfc223xEBfPpSMwzLGySWUC72reH
        yHSqRc3QMfAxd
X-Received: by 2002:a05:620a:1a14:b0:6ce:a65b:8e6 with SMTP id bk20-20020a05620a1a1400b006cea65b08e6mr14491815qkb.145.1665445758022;
        Mon, 10 Oct 2022 16:49:18 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4u7xyfHg/ZkZ+m9QVEZ+j8MKikQ4pUkG/ui28WrCvU0zvQtEPFYNMQZpHrCEw8JskM1BVf8g==
X-Received: by 2002:a05:620a:1a14:b0:6ce:a65b:8e6 with SMTP id bk20-20020a05620a1a1400b006cea65b08e6mr14491800qkb.145.1665445757739;
        Mon, 10 Oct 2022 16:49:17 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id s4-20020a05620a254400b006bbc09af9f5sm11266252qko.101.2022.10.10.16.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 16:49:17 -0700 (PDT)
Date:   Mon, 10 Oct 2022 19:49:15 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
        andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
        pbonzini@redhat.com, zhenyzha@redhat.com, james.morse@arm.com,
        suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        seanjc@google.com, shan.gavin@gmail.com
Subject: Re: [PATCH v5 3/7] KVM: x86: Allow to use bitmap in ring-based dirty
 page tracking
Message-ID: <Y0SvexjbHN78XVcq@xz-m1.local>
References: <20221005004154.83502-1-gshan@redhat.com>
 <20221005004154.83502-4-gshan@redhat.com>
 <Yz86gEbNflDpC8As@x1n>
 <a5e291b9-e862-7c71-3617-1620d5a7d407@redhat.com>
 <Y0A4VaSwllsSrVxT@x1n>
 <Y0SoX2/E828mbxuf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y0SoX2/E828mbxuf@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 10, 2022 at 11:18:55PM +0000, Oliver Upton wrote:
> On Fri, Oct 07, 2022 at 10:31:49AM -0400, Peter Xu wrote:
> 
> [...]
> 
> > > - In kvm_vm_ioctl_enable_dirty_log_ring(), set 'dirty_ring_allow_bitmap' to
> > >   true when the capability is KVM_CAP_DIRTY_LONG_RING_ACQ_REL
> > 
> > What I wanted to do is to decouple the ACQ_REL with ALLOW_BITMAP, so mostly
> > as what you suggested, except..
> 
> +1
> 
> > > 
> > >   static int kvm_vm_ioctl_enable_dirty_log_ring(struct kvm *kvm, u32 cap, u32 size)
> > >   {
> > >     :
> > >     mutex_lock(&kvm->lock);
> > > 
> > >     if (kvm->created_vcpus) {
> > >        /* We don't allow to change this value after vcpu created */
> > >        r = -EINVAL;
> > >     } else {
> > >        kvm->dirty_ring_size = size;
> > 
> > .. here I'd not set dirty_ring_allow_bitmap at all so I'd drop below line,
> > instead..
> > 
> > >        kvm->dirty_ring_allow_bitmap = (cap == KVM_CAP_DIRTY_LOG_RING_ACQ_REL);
> > >        r = 0;
> > >     }
> > > 
> > >     mutex_unlock(&kvm->lock);
> > >     return r;
> > >   }
> > > - In kvm_vm_ioctl_check_extension_generic(), KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP
> > >   is always flase until KVM_CAP_DIRTY_LOG_RING_ACQ_REL is enabled.
> > > 
> > >   static long kvm_vm_ioctl_check_extension_generic(...)
> > >   {
> > >     :
> > >     case KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP:
> > >         return kvm->dirty_ring_allow_bitmap ? 1 : 0;
> > 
> > ... here we always return 1, OTOH in kvm_vm_ioctl_enable_cap_generic():
> > 
> >       case KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP:
> >            if (kvm->dirty_ring_size)
> >                 return -EINVAL;
> >            kvm->dirty_ring_allow_bitmap = true;
> >            return 0;
> > 
> > A side effect of checking dirty_ring_size is then we'll be sure to have no
> > vcpu created too.  Maybe we should also check no memslot created to make
> > sure the bitmaps are not created.
> 
> I'm not sure I follow... What prevents userspace from creating a vCPU
> between enabling the two caps?

Enabling of dirty ring requires no vcpu created, so as to make sure all the
vcpus will have the ring structures allocated as long as ring enabled for
the vm.  Done in kvm_vm_ioctl_enable_dirty_log_ring():

	if (kvm->created_vcpus) {
		/* We don't allow to change this value after vcpu created */
		r = -EINVAL;
	} else {
		kvm->dirty_ring_size = size;
		r = 0;
	}

Then if we have KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP checking
dirty_ring_size first then we make sure we need to configure both
ALLOW_BITMAP and DIRTY_RING before any vcpu creation.

> 
> > Then if the userspace wants to use the bitmap altogether with the ring, it
> > needs to first detect KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP and enable it
> > before it enables KVM_CAP_DIRTY_LOG_RING.
> > 
> > One trick on ALLOW_BITMAP is in mark_page_dirty_in_slot() - after we allow
> > !vcpu case we'll need to make sure it won't accidentally try to set bitmap
> > for !ALLOW_BITMAP, because in that case the bitmap pointer is NULL so
> > set_bit_le() will directly crash the kernel.
> > 
> > We could keep the old flavor of having a WARN_ON_ONCE(!vcpu &&
> > !ALLOW_BITMAP) then return, but since now the userspace can easily trigger
> > this (e.g. on ARM, a malicious userapp can have DIRTY_RING &&
> > !ALLOW_BITMAP, then it can simply trigger the gic ioctl to trigger host
> > warning), I think the better approach is we can kill the process in that
> > case.  Not sure whether there's anything better we can do.
> 
> I don't believe !ALLOW_BITMAP && DIRTY_RING is a valid configuration for
> arm64 given the fact that we'll dirty memory outside of a vCPU context.

Yes it's not, but after Gavin's current series it'll be possible, IOW a
malicious app can leverage this to trigger host warning, which is IMHO not
wanted.

> 
> Could ALLOW_BITMAP be a requirement of DIRTY_RING, thereby making
> userspace fail fast? Otherwise (at least on arm64) your VM is DOA on the
> target. With that the old WARN() could be preserved, as you suggest.

It's just that x86 doesn't need the bitmap, so it'll be a pure waste there
otherwise.  It's not only about the memory that will be wasted (that's
guest mem size / 32k), but also the sync() process for x86 will be all
zeros and totally meaningless - note that the sync() of bitmap will be part
of VM downtime in this case (we need to sync() after turning VM off), so it
will make x86 downtime larger but without any benefit.

> On
> top of that there would no longer be a need to test for memslot creation
> when userspace attempts to enable KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP.

-- 
Peter Xu

