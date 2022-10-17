Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D76B601A66
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 22:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbiJQUhk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 16:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbiJQUhM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 16:37:12 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 776D761129
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 13:35:33 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id l1-20020a17090a72c100b0020a6949a66aso12062561pjk.1
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 13:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VqvUf2xdjiicSbriZ9K2T7GcJiVH52G2DFhyVh/IZSg=;
        b=Cj9hnG32oSA6o2hcfmZrGjkHVKkoRUXLmA7PubtCDzmLEa1NV71tx7DgrmF3/wlr0y
         O7Y/QyhbUJ1oTnM0Ba7p0vnpInYcptoOUd3uzXKzixIi2D6jVyJZ8Or1jyT9bvB3/2Lh
         m5uuw1fKu6gCA3ditVAp8NhFC7p5jzL5I/sayUn17Sqii0JToTHceImiZP0PyyHYfyW4
         dZPmWJMwVB/EPH8nGWvktlM9LRvJbJWtAGlQFzmQDcvZPhVhs0UfHKogD/2+V94UwKGL
         Kp1M813eGfqjryASC2aKCClls2Zr2J4G0Huq4E4jYkLSp2JAZzDbWSeP9HbrQfQchBqr
         c3dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VqvUf2xdjiicSbriZ9K2T7GcJiVH52G2DFhyVh/IZSg=;
        b=jKhAMqBPNM535kWZTTOnoWdVPstpvJNSGpeebloAMRRCUofXHjqcnt8ej9FJkQjjy8
         9bVUvtMOUMf6H/M5czZP+51eQ8jkgHFkX0g78e+LJJrSn9noNNtxAonYERZA37pA7VvY
         n6ZVWmk8dOCDkOiqLH7qoixyKCLVxGP7ro6umfiNmoIKFxKvEhM9pJiFve3ngs5WhpKr
         GS/R/x6Y4Wn87cVA6jqPMDw9MMyosmUR8FCZ/L8KXCsVYx/C3Hbsed0AM/49m1L4q5dB
         qgu8RyqovAT690cF8ApnxfjmcoAdCfl2Q14wlD8Bc6TY5uAzGAobOxpv0n10OkD9QIid
         aIBw==
X-Gm-Message-State: ACrzQf0eEZaDgyzN2JBOncd7Aym6YYsmk2toIITnFBxi4fxHozM9x9hg
        NSsVjqQU6KMLD0nNF1VZ7GyW3g==
X-Google-Smtp-Source: AMsMyM59XXgkVKwJn5MmsbHzfLVkLI3fCWW8bGwPshMlZbYTcUf8Q8/jjT2TNbLhZ0HI+d9OWuv3qg==
X-Received: by 2002:a17:902:b589:b0:17f:5756:b3f9 with SMTP id a9-20020a170902b58900b0017f5756b3f9mr13605653pls.14.1666038879052;
        Mon, 17 Oct 2022 13:34:39 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a11-20020a634d0b000000b0040caab35e5bsm6505021pgb.89.2022.10.17.13.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 13:34:38 -0700 (PDT)
Date:   Mon, 17 Oct 2022 20:34:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcorr@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        andrew.jones@linux.dev
Subject: Re: [V4 6/8] KVM: selftests: add library for creating/interacting
 with SEV guests
Message-ID: <Y028WrU3pmEQqWDq@google.com>
References: <20220829171021.701198-1-pgonda@google.com>
 <20220829171021.701198-7-pgonda@google.com>
 <Yz8dpB5+RFjEhA3n@google.com>
 <CAMkAt6oZQc4jqF7FOXOKkpbP3c4NXxPumVVjX9gXwPCh-zbtYg@mail.gmail.com>
 <Y02ZLFcDQbX6lP9z@google.com>
 <CAMkAt6q0g5Ua=PwLXa2oA4zCQUaHuEQ3pTXycD61HU6-dtQ5Gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMkAt6q0g5Ua=PwLXa2oA4zCQUaHuEQ3pTXycD61HU6-dtQ5Gg@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 17, 2022, Peter Gonda wrote:
> On Mon, Oct 17, 2022 at 12:04 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, Oct 17, 2022, Peter Gonda wrote:
> > > This refactor sounds good, working on this with a few changes.
> > >
> > > Instead of kvm_init_vm_address_properties() as you suggested I've added this:
> > >
> > > @@ -272,6 +275,8 @@ struct kvm_vm *____vm_create(enum vm_guest_mode
> > >  mode, uint64_t nr_pages)
> > >                 vm->type = KVM_VM_TYPE_ARM_IPA_SIZE(vm->pa_bits);
> > >  #endif
> > >
> > > +       kvm_init_vm_arch(vm);
> >
> > Why?  I'm not necessarily opposed to adding kvm_init_vm_arch(), but since x86
> > "needs" a dedicated hook to unpack the mode, why not piggyback that one?
> >
> 
> Well I since I need to do more than just
> kvm_init_vm_address_properties() I thought the more generic name would
> be better. We need to allocate kvm_vm_arch, find the c-bit, and call
> KVM_SEV_INIT. I can put it back in that switch case if thats better,
> thoughts?
> 
> > > +
> > >         vm_open(vm);
> > >
> > >         /* Limit to VA-bit canonical virtual addresses. */
> > >
> > > And I need to put kvm_arch_vm_post_create() after the vCPUs are
> > > created because the ordering we need is: KVM_SEV_INIT -> Create vCPUS
> > > -> KVM_SEV_LAUNCH_FINISH.
> >
> > Hrm, that's annoying.  Please don't use kvm_arch_vm_post_create() as the name,
> > that's a better fit for what Vishal is doing since the "vm_post_create()" implies
> > that it's called for "all" VM creation paths, where "all" means "everything
> > except barebones VMs".  E.g. in Vishal's series, kvm_arch_vm_post_create() can
> > be used to drop the vm_create_irqchip() call in common code.  In your case, IIUC
> > the hook will be invoked from __vm_create_with_vcpus().
> >
> > I'm a little hesitant to have an arch hook for this case since it can't be
> > all-or-nothing (again, ignoring barebones VMs).  If a "finalize" arch hook is added,
> > then arguably tests that do __vm_create() and manually add vCPUs should call the
> > arch hook, i.e. we'd be adding maintenance burden to tests that in all likelihood
> > don't care about SEV and never will.
> >
> > It's somewhat unfortunate, but dedicated vm_sev_create_with_one_vcpu() and
> > and vm_sev_create_with_vcpus() wrappers is probably the least awful solution.
> 
> Make sense. I think we can go back to your suggestion of
> kvm_init_vm_address_properties() above since we can now do all the
> KVM_SEV_* stuff. I think this means we don't need to add
> VM_MODE_PXXV48_4K_SEV since we can set up the c-bit from inside of
> vm_sev_create_*(), thoughts?

Configuring the C-bit inside vm_sev_create_*() won't work (at least not well).
The C-bit needs to be known before kvm_vm_elf_load(), i.e. can't be handled after
__vm_create(), and needs to be tracked inside the VM, i.e. can't be handled before
__vm_create().

The proposed kvm_init_vm_address_properties() seems like the best fit since the
C-bit (and TDX's S-bit) is stolen from GPA space, i.e. directly affects the other
values computed in that path.

As for the kvm_vm_arch allocation ugliness, when we talked off-list I didn't
consider the need to allocate in kvm_init_vm_address_properties().  That's quite
gross, especially since the pointer will be larger than the thing being allocated.

With that in mind, adding .../include/<arch>/kvm_util.h so that "struct kvm_vm_arch"
can be defined and referenced directly doesn't seem so bad.  Having to stub in the
struct for the other architectures is annoying, but not the end of the world.
