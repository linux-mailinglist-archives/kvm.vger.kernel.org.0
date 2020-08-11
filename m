Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34ECB242130
	for <lists+kvm@lfdr.de>; Tue, 11 Aug 2020 22:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgHKUQi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 16:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgHKUQh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Aug 2020 16:16:37 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20D0C06174A
        for <kvm@vger.kernel.org>; Tue, 11 Aug 2020 13:16:37 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id j7so13430762oij.9
        for <kvm@vger.kernel.org>; Tue, 11 Aug 2020 13:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pRxU7qJmyuLoNQQfb9C1xZqOr8tleC77Y730y1ZUt4Y=;
        b=kkMeipvMZ1cV6Eg4WFbgRHdi/l44XTqw5F3XKJggdchNsPC3oDnt+h/NFEwK8/Q/pl
         2Jt6GFr9jzjWrm12W25VwsI+5teGrtUBl55PCpAgcSFphYqVEwOuZPj241PhPWkE2Lxb
         34XEzVx2NPC00FRshn+pQ6xrWkcMZXSZtzHxMhdCFOHI3mwgQ1Msksb8Jc7cQrZkvbuw
         /0u3HDNgOIgnHj36XxRQNeaskz+iNSAk7UmKuajLKqZMUuGHXqiFwb74wRoEfH3Gigtz
         sgEs1UMdCacycVu9pQjO/trrzWHVMgcpb532rS5fQCeakh5Dwnk53x9vz73OXnt3VdT5
         CgQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pRxU7qJmyuLoNQQfb9C1xZqOr8tleC77Y730y1ZUt4Y=;
        b=eznQ9L3xDo8bjE6eBeHdofqGuw1WKZtRXZu2JSt6aJsQSxRoV6T05OQCylloqRaxti
         ODuEpJexffoqiLbw2yI8ojdNO3AwmTQ46EhmEPCPWGNZG+fB311FMc4wZRglMMmNBONz
         DOAEVLskDHck28qa/2cPEpgBVJxs0UEyXgmV+toNbvTucl7eH9OutufxdE6TRfhdLqDt
         +T5oMyOTZDQJgJEcvb/ZyREHV3hnzlTUkaRqa07iM/eTUziPor/IC8VFhr6jMayKd8ex
         4jIaiOxq2C7aOuEEsgnLgY3Edox1vXQBulFKzO+fqlFhvdDVhZ66lsJNAI1PkQJsKKUH
         kgPg==
X-Gm-Message-State: AOAM533ZmH1x++5DbGLmPrIvnx+5WWd+YELU1rVq/gbF7UnX2mr5vs2a
        3njkEHfc4o+VCe/bPw6Iij5pYCmb/wiH+JpLe9FQXQ==
X-Google-Smtp-Source: ABdhPJyHIJuWQgc3jpUqacru0dVVgrx0GR8gbN9BTmWwMn7q+RdIuwY1tWJ36/ieLx5a3KCCE4zujqKckM5Ug/ODXfc=
X-Received: by 2002:aca:670b:: with SMTP id z11mr4767979oix.6.1597176996762;
 Tue, 11 Aug 2020 13:16:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200810223927.82895-1-krish.sadhukhan@oracle.com>
 <CALMp9eT00_qO8NXnLjtMzHCUYOCV0pWQ2jWp4-EPu+Gc9XpNGg@mail.gmail.com> <8534bec9-df9d-fa44-8c09-b9730a83c16b@oracle.com>
In-Reply-To: <8534bec9-df9d-fa44-8c09-b9730a83c16b@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 11 Aug 2020 13:16:24 -0700
Message-ID: <CALMp9eQ=KWARv-cms1=OkanpqywRdxBayMxk-kG9v46MFQ4UQg@mail.gmail.com>
Subject: Re: [PATCH] KVM: nSVM: Test combinations of EFER.LME, CR0.PG,
 CR4.PAE, CR0.PE and CS register on VMRUN of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 11, 2020 at 12:48 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
> On 8/11/20 11:37 AM, Jim Mattson wrote:
> > On Mon, Aug 10, 2020 at 3:40 PM Krish Sadhukhan
> > <krish.sadhukhan@oracle.com> wrote:
> >> According to section "Canonicalization and Consistency Checks" in APM vol. 2
> >> the following guest state combinations are illegal:
> >>
> >>          * EFER.LME and CR0.PG are both set and CR4.PAE is zero.
> >>          * EFER.LME and CR0.PG are both non-zero and CR0.PE is zero.
> >>          * EFER.LME, CR0.PG, CR4.PAE, CS.L, and CS.D are all non-zero
> >>
> >> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> >> ---
> >>   x86/svm_tests.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
> >>   1 file changed, 44 insertions(+)
> >>
> >> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> >> index 1908c7c..43208fd 100644
> >> --- a/x86/svm_tests.c
> >> +++ b/x86/svm_tests.c
> >> @@ -1962,7 +1962,51 @@ static void test_efer(void)
> >>          SVM_TEST_REG_RESERVED_BITS(16, 63, 4, "EFER", vmcb->save.efer,
> >>              efer_saved, SVM_EFER_RESERVED_MASK);
> >>
> >> +       /*
> >> +        * EFER.LME and CR0.PG are both set and CR4.PAE is zero.
> >> +        */
> >> +       u64 cr0_saved = vmcb->save.cr0;
> >> +       u64 cr0;
> >> +       u64 cr4_saved = vmcb->save.cr4;
> >> +       u64 cr4;
> >> +
> >> +       efer = efer_saved | EFER_LME;
> >> +       vmcb->save.efer = efer;
> >> +       cr0 = cr0_saved | X86_CR0_PG;
> >> +       vmcb->save.cr0 = cr0;
> >> +       cr4 = cr4_saved & ~X86_CR4_PAE;
> >> +       vmcb->save.cr4 = cr4;
> >> +       report(svm_vmrun() == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
> >> +           "CR0.PG=1 (%lx) and CR4.PAE=0 (%lx)", efer, cr0, cr4);
> > This seems adequate, but you have to assume that CR0.PE is set, or you
> > could just be testing the second rule (below).
> >
> >> +       /*
> >> +        * EFER.LME and CR0.PG are both set and CR0.PE is zero.
> >> +        */
> >> +       vmcb->save.cr4 = cr4_saved;
> >> +       cr0 &= ~X86_CR0_PE;
> >> +       vmcb->save.cr0 = cr0;
> >> +       report(svm_vmrun() == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
> >> +           "CR0.PG=1 and CR0.PE=0 (%lx)", efer, cr0);
> > This too, seems adequate, but you have to assume that CR4.PAE is set,
> > or you could just be testing the first rule (above).
>
>
> I see what you mean. I am just trying to understand how extensive our
> explicit assumptions should be when testing a given APM rule on valid
> guest state. For example, should we also explicitly unset CS.L and CS.D
> bits (third rule below) ? Or should we also explicitly unset CR3 MBZ
> bits because CR3 is relevant when we are setting CR0.PG ?

I think it's enough to begin with any 'known good' state. However, if
you have <N> illegal guest states with intersecting sets of
specifications, you need to be careful to make sure that each test
case only satisfies the specifications of the one illegal guest state
that the test is attempting to verify. If the test meets the
specifications of multiple illegal guest states, then you can't be
sure which of the matching illegal guest states has triggered the
failed VM-entry.
