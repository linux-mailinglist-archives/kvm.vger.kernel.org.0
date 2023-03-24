Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C90126C82EF
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 18:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbjCXRK2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 13:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231983AbjCXRKX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 13:10:23 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F1921A2C
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 10:10:20 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id kx3-20020a17090b228300b0023cfd09ed94so2593544pjb.4
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 10:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679677820;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vyDS7zcExbdUJKL+EU4Z73G2mWyinpCTeuPFZtODKYE=;
        b=UOKFh/r2A49LuZpNoYzxruwq0cUWLiB4ILV1YowxrZ7He1LO/2mMPJf7lfbKte7daz
         ah9gnQS7EOomNLly1ux0KwATpHwRt3vQy93XdyjUFTfKITsCoUhgZsTir+AKiGmjP7b4
         +6wTYrEaegTyS9x+Rp6am1FdEFKYNdYZ6aYmR4WhmAU1C52iE2ZIV/GXql9yQRnfaGQ/
         6d4eISlWPolEpTEncTKagZmw7H8f11cs3/d7jCD8UlQQ0BNBArunAaLqEsVvhLVmElOQ
         ZBEdztZjZvtsm/GENWVZnqjiaor2zRr1Q2d4UDT63RGUbdWQHQgwY/RdPmhS+vfE8jWV
         yvig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679677820;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vyDS7zcExbdUJKL+EU4Z73G2mWyinpCTeuPFZtODKYE=;
        b=ydepMbw3brFMCD4Ymb2GE4QRvzQwby7MlwLoyK93gVySZZeGzgXwDM1u6I3IM3H/Bx
         MvMrCElIDsHNpYOZz4lHb7ZcBs5k5M4EszqwloYVZG2pIkBadLX5XSOgzbNifOCcUZoc
         lCa3Vzj8CKGWeNLyaGZsnT4R+2lLlK5Xw6sFXkTDQS9E9QFED4LaNM9GCEJuwIN5S6Hf
         bLRu7VCMGyP7HMtL/JBeh/EOUeD8KShjp7l4UnKp99b7Lw/YjLWnY8mpQp8wgEmj0kEO
         mAZk7vTbYfE2vJZMMqgvNRE3e2oqzx/Lw8gkEu+JB3pePRqo9R2LUY839WQBEFRGtGlL
         3HRg==
X-Gm-Message-State: AAQBX9fg3BKdd+zKvO+Cp99l7uudcfZQzbBmK7wPRvuY/T60gqdyLBdl
        uQhlbi/RMTh4xDmVHjqTPYPgFayHyIw=
X-Google-Smtp-Source: AKy350a8xIOJAwkNAQ0q4xylGy4UnbU2e+5S+fKOut9r/kh7MGLuj+VxEJRsh//jMz2xLck3pJg/M38ookk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:66cf:b0:23b:446b:bbfd with SMTP id
 z15-20020a17090a66cf00b0023b446bbbfdmr1097256pjl.1.1679677820315; Fri, 24 Mar
 2023 10:10:20 -0700 (PDT)
Date:   Fri, 24 Mar 2023 10:10:18 -0700
In-Reply-To: <20230110175057.715453-3-pgonda@google.com>
Mime-Version: 1.0
References: <20230110175057.715453-1-pgonda@google.com> <20230110175057.715453-3-pgonda@google.com>
Message-ID: <ZB3Zei0cxEWS997R@google.com>
Subject: Re: [PATCH V6 2/7] KVM: selftests: add hooks for managing protected
 guest memory
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 10, 2023, Peter Gonda wrote:
> Add kvm_vm.protected metadata. Protected VMs memory, potentially
> register and other state may not be accessible to KVM. This combined
> with a new protected_phy_pages bitmap will allow the selftests to check
> if a given pages is accessible.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Vishal Annapurve <vannapurve@google.com>
> Cc: Ackerley Tng <ackerleytng@google.com>
> cc: Andrew Jones <andrew.jones@linux.dev>
> Originally-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h        | 14 ++++++++++++--
>  tools/testing/selftests/kvm/lib/kvm_util.c       | 16 +++++++++++++---
>  2 files changed, 25 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index fbc2a79369b8..015b59a0b80e 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -45,6 +45,7 @@ typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
>  struct userspace_mem_region {
>  	struct kvm_userspace_memory_region region;
>  	struct sparsebit *unused_phy_pages;
> +	struct sparsebit *protected_phy_pages;
>  	int fd;
>  	off_t offset;
>  	enum vm_mem_backing_src_type backing_src_type;
> @@ -111,6 +112,9 @@ struct kvm_vm {
>  	vm_vaddr_t handlers;
>  	uint32_t dirty_ring_size;
>  
> +	/* VM protection enabled: SEV, etc*/
> +	bool protected;
> +
>  	/* Cache of information for binary stats interface */
>  	int stats_fd;
>  	struct kvm_stats_header stats_header;
> @@ -679,10 +683,16 @@ const char *exit_reason_str(unsigned int exit_reason);
>  
>  vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
>  			     uint32_t memslot);
> -vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
> -			      vm_paddr_t paddr_min, uint32_t memslot);
> +vm_paddr_t _vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,

Two underscores please.  Ignore the terrible precedent that has been set, we're
slowly purging that crud.

> +			      vm_paddr_t paddr_min, uint32_t memslot, bool protected);

Wrap, no strong justification for running long in this case since the declaration
has already wrapped, and the definition does wrap.
