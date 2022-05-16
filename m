Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 277485293A7
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 00:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346500AbiEPWfB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 18:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbiEPWe7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 18:34:59 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47009369FF
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 15:34:56 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id y19so19814277ljd.4
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 15:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Oa1ie+jbSRcbYGvT1r4itWrw5osHCRmNPKudkUqGsQ8=;
        b=XHiOeuz7/nPDQ+OzKWQbijjgHdmanKyPN6lCXReGTE7Ht4QCFlqOdS9VLDCb6fsV/v
         9NhKhk50jmjeVx0xWVLzFs1Xa81+zlL43ub9L8WnYcifc4HGJIh6/aqY9gI5PcCe5inH
         g7eu5kEvtk83lEayPmiLYN+w08zQVoaWCTdNR75Zx97RYpJiNZQ7CC1KtdMARhJhABSc
         TOgfUpLNDU++2CKf1VUeCgVxUPpw22E+fFLeBQdyimOBKP18CGQ9veb2mcHN5roLqSls
         2qamGoCKdan6j3ZEOASTP7UpCDsmA17c9t6Jhm754ZNQ8ubqs7seHppWDWFKTY4F4v6w
         8jiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Oa1ie+jbSRcbYGvT1r4itWrw5osHCRmNPKudkUqGsQ8=;
        b=ByyXPXhALaax1It27z7Wrv9lAjG8w1ipXCbIqRG+yzmVeYFobTvQLtGZg0a0fD2uKQ
         ThsjVguwJzMlT+UlPw2b5VeY3Dy7SekOBgKfn5F1y+yPAwbKK2TZxycl+VziMvvPYJfL
         3n5ovLyPktR7D8CNVBCSZwQE8Z4ds1+osFgJPitWgAjEgTMuMZwTa9xjHm0Rxz7MKy1X
         xVKtUxVP1pobt/enfFfsxYoLFvAHYHCUqqMy3Rfu2m2tC25vOQ61aD/tPldk+edwvZUJ
         BQAs1Xy6Fbv89AXdEWGGu7VQPfLEOuoW+3hS8va8CqC9gqHOMSImhAB0HaP5unUy7Ryq
         ye/A==
X-Gm-Message-State: AOAM530wbj6M8Ae0AUAJw3+dQw3kJDm9Ik5xpuYMBbIZaSJoV9UE6RiK
        7GOdbDgp+LMbo5k63xcXuvClzsouMtKsm1MNPZNxdg==
X-Google-Smtp-Source: ABdhPJzPtv9uTfIG8svv5WhXvMye9wfMeP1NmA7/SEeF5i8/uSERJ+c4G5Nisvm56UHW3AoJ9TMvEtndGiAe0GOIR9U=
X-Received: by 2002:a05:651c:b24:b0:250:6414:c91a with SMTP id
 b36-20020a05651c0b2400b002506414c91amr12241861ljr.198.1652740494496; Mon, 16
 May 2022 15:34:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220429183935.1094599-1-dmatlack@google.com> <20220429183935.1094599-10-dmatlack@google.com>
 <YoLNcd1SQMSNdSMb@xz-m1.local>
In-Reply-To: <YoLNcd1SQMSNdSMb@xz-m1.local>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 16 May 2022 15:34:28 -0700
Message-ID: <CALzav=dwEJx=HrPDBxVyTJU-JkjX3c0hx-4JvJ2bY+BW7FL5dQ@mail.gmail.com>
Subject: Re: [PATCH 9/9] KVM: selftests: Add option to run dirty_log_perf_test
 vCPUs in L2
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 16, 2022 at 3:17 PM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Apr 29, 2022 at 06:39:35PM +0000, David Matlack wrote:
> > +static void perf_test_l1_guest_code(struct vmx_pages *vmx, uint64_t vcpu_id)
> > +{
> > +#define L2_GUEST_STACK_SIZE 64
> > +     unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
> > +     unsigned long *rsp;
> > +
> > +     GUEST_ASSERT(vmx->vmcs_gpa);
> > +     GUEST_ASSERT(prepare_for_vmx_operation(vmx));
> > +     GUEST_ASSERT(load_vmcs(vmx));
> > +     GUEST_ASSERT(ept_1g_pages_supported());
> > +
> > +     rsp = &l2_guest_stack[L2_GUEST_STACK_SIZE - 1];
> > +     *rsp = vcpu_id;
> > +     prepare_vmcs(vmx, perf_test_l2_guest_entry, rsp);
>
> Just to purely ask: is this setting the same stack pointer to all the
> vcpus?

No, but I understand the confusion since typically selftests use
symbols like "l2_guest_code" that are global. But "l2_guest_stack" is
actually a local variable so it will be allocated on the stack. Each
vCPU runs on a separate stack, so they will each run with their own
"l2_guest_stack".

>
> > +
> > +     GUEST_ASSERT(!vmlaunch());
> > +     GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
> > +     GUEST_DONE();
> > +}
>
> [...]
>
> > +/* Identity map the entire guest physical address space with 1GiB Pages. */
> > +void nested_map_all_1g(struct vmx_pages *vmx, struct kvm_vm *vm)
> > +{
> > +     __nested_map(vmx, vm, 0, 0, vm->max_gfn << vm->page_shift, PG_LEVEL_1G);
> > +}
>
> Could max_gfn be large?  Could it consumes a bunch of pages even if mapping
> 1G only?

Since the selftests only support 4-level EPT, this will use at most
513 pages. If we add support for 5-level EPT we may need to revisit
this approach.

>
> Thanks,
>
> --
> Peter Xu
>
