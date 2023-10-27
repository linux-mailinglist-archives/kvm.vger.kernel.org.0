Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCF77D8CA5
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 02:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345060AbjJ0AzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 20:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345018AbjJ0Ay7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 20:54:59 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543311B5
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 17:54:57 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d9ab79816a9so1243606276.3
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 17:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698368096; x=1698972896; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bkuZQVHnF0aSkP/dIjheAABr7DI7ra4xf7ceUlIhIOA=;
        b=N5vy/BojceYcyZsXOErv9zlqMz1YHVjjgIddiN4EzVvc+LKvh7WUmN6EwF9jycZquG
         +Mb1ojPiJFciP1PWnyLDQc60VyVp/soJDRKccS60oDKonDjLxB1zQPDqEvPyuWsxjpoQ
         utzhW01A6U9is1aAtx7IY4OAsJyAan2JMlz5fw/9TMUpY8T68GIf8f3ckH1zqsB5NVfQ
         6jcbk+Tf6i1jO4DmdPwR1NXu431HnoR3DeUcI0bzulPOv5RbkCvRXjMKxU5JSL1yuS7/
         ghitgYvgvmA5SIdscnxFNL2YmWU8V23TDUqPrvIdzjy8GevIxVV5IFJ0SP2cUdytMiAq
         pldQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698368096; x=1698972896;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bkuZQVHnF0aSkP/dIjheAABr7DI7ra4xf7ceUlIhIOA=;
        b=AZnmuAbzAb+RS3Qm7CCRpdfXf77aewArR0xBmdjUIbVqiLM/FseFramHZNwKeU8DVc
         MrR4xvxhEEAPmau8HoMU5h9jinO6Z+Zu24MxEyMCiotSERcQu7mI3TSxduUU+g5/I0UV
         Rm8bpoyRKZKHjW68zVjh9YvE4e7klY7RxQNI6/GNord91CmMvLmtxpaKEMOb/FwUBNmV
         IodjbXAVuP98qqUYE0jcteGNym3Wk8Ict1AeVclzbN+ajh0/1tcJ/CRVKmkBibJaiLNA
         SsUldsaIsn39OtbX6bW6yJJ/jEiT8MizEbp/VsisYSAe5uq0p6EucF90kOi+sjUVTqcR
         YFEg==
X-Gm-Message-State: AOJu0YxiERnutmUu8rVU/ZvI0kEgnIB+zxDH9lSFpIfdEIqKnl69UxIT
        oXemH3qvDYTkmWPJ2C3yxa14MvhHZAs=
X-Google-Smtp-Source: AGHT+IFzmJoqDgYO9QXDRmkYoxqCR+kjdKTksziWrDJdDTfTH+RScme8Nu0cffkwjhcLtTaBByM2IWGLXsM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:494:0:b0:d13:856b:c10a with SMTP id
 142-20020a250494000000b00d13856bc10amr22985ybe.3.1698368096547; Thu, 26 Oct
 2023 17:54:56 -0700 (PDT)
Date:   Thu, 26 Oct 2023 17:54:54 -0700
In-Reply-To: <a65e6d23-791b-4866-8cb8-543d8f1942a6@zytor.com>
Mime-Version: 1.0
References: <a65e6d23-791b-4866-8cb8-543d8f1942a6@zytor.com>
Message-ID: <ZTsKXmXXr4lIi5If@google.com>
Subject: Re: Run user level code in guest in a new KVM selftest
From:   Sean Christopherson <seanjc@google.com>
To:     Xin Li <xin@zytor.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 26, 2023, Xin Li wrote:
> Hi Sean,
> 
> I'm adding a nested exception selftest for FRED, which needs to run
> user level code in guest.  I have to add the following hack for that:
> 
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index d8288374078e..72928c07ccbe 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -159,6 +159,7 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm
> *vm,
> 
>         if (!(*pte & PTE_PRESENT_MASK)) {
>                 *pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK;
> +               *pte |= PTE_USER_MASK;
>                 if (current_level == target_level)
>                         *pte |= PTE_LARGE_MASK | (paddr &
> PHYSICAL_PAGE_MASK);
>                 else
> @@ -222,6 +223,7 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr,
> uint64_t paddr, int level)
>         TEST_ASSERT(!(*pte & PTE_PRESENT_MASK),
>                     "PTE already present for 4k page at vaddr: 0x%lx\n",
> vaddr);
>         *pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK | (paddr &
> PHYSICAL_PAGE_MASK);
> +       *pte |= PTE_USER_MASK;
>  }
> 
>  void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
> 
> 
> Is there an exiting selftest running user level code in guest?

Nope, not that I know of.

> It seems there is none as the USER bit in PTEs is never set, what have I
> missed?

Nothing.

> If such a facility doesn't exist, we probably need to find a
> clean solution to add the USER bit in user level page table mappings
> (which seems not yet clearly defined yet).

Yes, being able to run usercode would be very nice indeed.  It should be a lot
simpler than KUT since we can stuff guest state directly.  The big hiccup is SMEP
and SMAP, e.g. we can't just set PTE_USER_MASK blindly :-(

My best off-the-top-of-my-head idea is to play games with "enum vm_guest_mode" so
that we know from time zero that the guest will be run in user mode, e.g. so that
loading the initial guest_code can map it for user.
