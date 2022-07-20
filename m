Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 600B857B8AC
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 16:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbiGTOma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 10:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiGTOm3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 10:42:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6E35A4D805
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 07:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658328147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cvhT3S9WVM0zbX99AylzeVt8EncWc0nM5sQ4BeMLhBk=;
        b=UzvpBvIv0zEd7m4CXN88yg4EWop+mXthhR84RibTwejlWl0LCUUUgaCYDDXiYSU+S/peyT
        tkLhMKPfXnrCwV2tX95MP7yx8D45MZgZtvpmgxqdDAuTsVLNfUJtrhPJ4wBFaT1HQrmpcS
        GxaaeJUq56j+WbLtKLs8gZ7We3XVMWs=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187-zf-iVOCRMIuacE0VB_BnMg-1; Wed, 20 Jul 2022 10:42:26 -0400
X-MC-Unique: zf-iVOCRMIuacE0VB_BnMg-1
Received: by mail-qv1-f69.google.com with SMTP id u15-20020a0ced2f000000b004732a5e7a99so9525315qvq.5
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 07:42:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=cvhT3S9WVM0zbX99AylzeVt8EncWc0nM5sQ4BeMLhBk=;
        b=QrwZ2D+9np+if+omUJtLIJFKO0gEBphmru4hpHtLBcG3CtnFdE9KWl5XrGE4gPePTf
         DVHxB39UZj2oHDfgDJOoFbz//7r4hi0HRrSzbWrSYQVEEyvqzBRRKMo9tQsoRu/KewdD
         aI+klxtDZq6pVm0JXAQfHle46kXRBxrTrtczzJ2Sxb2QdxPQHaCxXk4crgSqTrGfzPDp
         OQ3rQrsMbMgl3TLWssPGA+zbJAtGtthjgSWxNd5ci4aCbRmwclmodfyU6rL5Fj99whpA
         uR5gxR5WIRbpdHBJBkmRxz5w1EIpkjtTLEKDuR/ZYW2Hv9jwm2ww/nFN4wRNgEnzen+q
         vDtg==
X-Gm-Message-State: AJIora9UXTGpl5VSpjw8ahJKDq1t2uvz4IdzNzdqEIk0iU121Zys8b5N
        OOzAV5/ifOcipjO1p4u32JHkg0DTNjxr7WGjFBBJsZdVMtBqfBUAXbk6kmC8m93jQMvJEtFGElw
        gx628K2YrB+yo
X-Received: by 2002:a05:622a:1a14:b0:31e:e89f:4dda with SMTP id f20-20020a05622a1a1400b0031ee89f4ddamr15317180qtb.622.1658328145879;
        Wed, 20 Jul 2022 07:42:25 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tGn9yFp45TY6RYzVBxsl9nb/67MqV9TQtVWfuHzl2vf0hFiw4YH/r3ee/crX2uGuJr5QQhHQ==
X-Received: by 2002:a05:622a:1a14:b0:31e:e89f:4dda with SMTP id f20-20020a05622a1a1400b0031ee89f4ddamr15317158qtb.622.1658328145616;
        Wed, 20 Jul 2022 07:42:25 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id y206-20020a3764d7000000b006b5652edb93sm16190459qkb.48.2022.07.20.07.42.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 07:42:24 -0700 (PDT)
Message-ID: <c22a18631c2067871b9ed8a9246ad58fa1ab8947.camel@redhat.com>
Subject: Re: [RFC PATCH v3 04/19] KVM: x86: mmu: allow to enable write
 tracking externally
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Date:   Wed, 20 Jul 2022 17:42:17 +0300
In-Reply-To: <5ed0d0e5a88bbee2f95d794dbbeb1ad16789f319.camel@redhat.com>
References: <20220427200314.276673-1-mlevitsk@redhat.com>
         <20220427200314.276673-5-mlevitsk@redhat.com> <YoZyWOh4NPA0uN5J@google.com>
         <5ed0d0e5a88bbee2f95d794dbbeb1ad16789f319.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 2022-05-22 at 13:22 +0300, Maxim Levitsky wrote:
> On Thu, 2022-05-19 at 16:37 +0000, Sean Christopherson wrote:
> > On Wed, Apr 27, 2022, Maxim Levitsky wrote:
> > > @@ -5753,6 +5752,10 @@ int kvm_mmu_init_vm(struct kvm *kvm)
> > >         node->track_write = kvm_mmu_pte_write;
> > >         node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
> > >         kvm_page_track_register_notifier(kvm, node);
> > 
> > Can you add a patch to move this call to kvm_page_track_register_notifier() into
> > mmu_enable_write_tracking(), and simultaneously add a WARN in the register path
> > that page tracking is enabled?
> > 
> > Oh, actually, a better idea. Add an inner __kvm_page_track_register_notifier()
> > that is not exported and thus used only by KVM, invoke mmu_enable_write_tracking()
> > from the exported kvm_page_track_register_notifier(), and then do the above.
> > That will require modifying KVMGT and KVM in a single patch, but that's ok.
> > 
> > That will avoid any possibility of an external user failing to enabling tracking
> > before registering its notifier, and also avoids bikeshedding over what to do with
> > the one-line wrapper to enable tracking.
> > 
> 
> This is a good idea as well, especially looking at kvmgt and seeing that
> it registers the page track notifier, when the vGPU is opened.
> 
> I'll do this in the next series.
> 
> Thanks for the review!

After putting some thought into this, I am not 100% sure anymore I want to do it this way.
 
Let me explain the current state of things:

For mmu: 
- write tracking notifier is registered on VM initialization (that is pretty much always),
and if it is called because write tracking was enabled due to some other reason
(currently only KVMGT), it checks the number of shadow mmu pages and if zero, bails out.
 
- write tracking enabled when shadow root is allocated.
 
This can be kept as is by using the __kvm_page_track_register_notifier as you suggested.
 
For KVMGT:
- both write tracking and notifier are enabled when an vgpu mdev device is first opened.
That 'works' only because KVMGT doesn't allow to assign more that one mdev to same VM,
thus a per VM notifier and the write tracking for that VM are enabled at the same time
 
 
Now for nested AVIC, this is what I would like to do:
 
- just like mmu, I prefer to register the write tracking notifier, when the VM is created.
- just like mmu, write tracking should only be enabled when nested AVIC is actually used
  first time, so that write tracking is not always enabled when you just boot a VM with nested avic supported,
  since the VM might not use nested at all.
 
Thus I either need to use the __kvm_page_track_register_notifier too for AVIC (and thus need to export it)
or I need to have a boolean (nested_avic_was_used_once) and register the write tracking
notifier only when false and do it not on VM creation but on first attempt to use nested AVIC.
 
Do you think this is worth it? I mean there is some value of registering the notifier only when needed
(this way it is not called for nothing) but it does complicate things a bit.
 
I can also stash this boolean (like 'bool registered;') into the 'struct kvm_page_track_notifier_node', 
and thus allow the kvm_page_track_register_notifier to be called more that once - 
then I can also get rid of __kvm_page_track_register_notifier. 

What do you think about this?
 
Best regards,
	Maxim Levitsky


> 
> Best regards,
>         Maxim Levitsky


