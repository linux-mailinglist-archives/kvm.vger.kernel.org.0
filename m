Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8091A3C01
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 23:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgDIVid (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 17:38:33 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38901 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbgDIVid (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 17:38:33 -0400
Received: by mail-qk1-f194.google.com with SMTP id h14so330904qke.5
        for <kvm@vger.kernel.org>; Thu, 09 Apr 2020 14:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ni7Yb3Kb54bOCuk3AbZkZK2w6stFJR6Ii3Ic9F0QVDI=;
        b=i0Y9QxO3lZNEVxtT/GGiGKXmZI1a1o6M57/3FGsAQAk8+q3XICzrpzWEMT7M8M5en5
         QwMUYdamnbeNHW9PV5d2kirucOgEuPXZGEqk1lC2TudUqYlIVjrX1Pkzqlb/W1OiwcXM
         kZj4sklgbVspOjh7Wnln6TN0qALmTS4zyHl3R3D+I5veHhyfLIhApdxEGXnp6DEsBBRl
         2/WPQhqqE8GSx5PufeMOOOKhJ8fsewJibyfcn6SSzmKCKG1sBlk9+vOzbrZQKSRI6FAV
         NpTJcawhYhZjqPooUFIsz1B4ENrN3PEtrG1sWq5K7Z9E1xbXY8EpK5SJV4gI53GiNcAT
         wsSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ni7Yb3Kb54bOCuk3AbZkZK2w6stFJR6Ii3Ic9F0QVDI=;
        b=MDapGYuV2mxdkIZJXzDrGRE2DPNr06R+wH1Tc7lQyX1kaWXev+1thTFq2vV4YrGbu3
         ImjPDsyR8rlF8KpfcbE54eCZqb1UcqocAKg4cCbt9YuR/80KJzJeTKJhONrCnEdI05Ty
         2b1US5VHag3oS6CNnT+mtlWJqeqozQslmppwM8zndaO9JNSlhbYj503HCBZH8sYpjfH4
         Tjbitj5Hc0/FIcilKK3COOLxY/6tSSHmXOs/ik1pNE116l9psVEGSH9R5zhTwD2UaEra
         nD1PbrHjiPMY0RTGODOBeHean9J2hZnDHDlfI72SFuWDPDigZe0N6K78nOuVeqQvGouX
         XSLw==
X-Gm-Message-State: AGi0PuZ2N2EygzRcTOnxTFvq/g014UTRl4CdVgnw8PjT8HPnbIVqr0HZ
        gDP7dck6ARy+E0OAh0upOVqXMUPbVZIoXlsAZ/3srA==
X-Google-Smtp-Source: APiQypLmKzIzXjsj0HwMrON5/CzJg2HMiznE5p6WXqwC1p5vtDluWg86dbyATS1m9HFBK1RUR7s7xTYMUt4q9U1Zeg8=
X-Received: by 2002:a37:b702:: with SMTP id h2mr993904qkf.491.1586468311915;
 Thu, 09 Apr 2020 14:38:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200406225537.48082-1-brigidsmith@google.com> <600aee64-18c4-8525-9ece-a791ca24c5b3@oracle.com>
In-Reply-To: <600aee64-18c4-8525-9ece-a791ca24c5b3@oracle.com>
From:   Peter Shier <pshier@google.com>
Date:   Thu, 9 Apr 2020 14:38:21 -0700
Message-ID: <CACwOFJQrOWrOBDxf1CzGy0WGfmQTsL09t5UnGrBtyuhzG04=uw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: gtests: add new test for
 vmread/vmwrite flags preservation
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     Simon Smith <brigidsmith@google.com>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 6, 2020 at 6:42 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
> On 4/6/20 3:55 PM, Simon Smith wrote:
> > This commit adds new unit tests for commit a4d956b93904 ("KVM: nVMX:
> > vmread should not set rflags to specify success in case of #PF")
> >
> > The two new tests force a vmread and a vmwrite on an unmapped
> > address to cause a #PF and verify that the low byte of %rflags is
> > preserved and that %rip is not advanced.  The cherry-pick fixed a
> > bug in vmread, but we include a test for vmwrite as well for
> > completeness.
> >
> > Before the aforementioned commit, the ALU flags would be incorrectly
> > cleared and %rip would be advanced (for vmread).
> >
> > Reviewed-by: Jim Mattson <jmattson@google.com>
> > Signed-off-by: Simon Smith <brigidsmith@google.com>
> > ---
> >   x86/vmx.c | 121 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >   1 file changed, 121 insertions(+)
> >
> > diff --git a/x86/vmx.c b/x86/vmx.c
> > index 647ab49408876..e9235ec4fcad9 100644
> > --- a/x86/vmx.c
> > +++ b/x86/vmx.c
> > @@ -32,6 +32,7 @@
> >   #include "processor.h"
> >   #include "alloc_page.h"
> >   #include "vm.h"
> > +#include "vmalloc.h"
> >   #include "desc.h"
> >   #include "vmx.h"
> >   #include "msr.h"
> > @@ -368,6 +369,122 @@ static void test_vmwrite_vmread(void)
> >       free_page(vmcs);
> >   }
> >
> > +ulong finish_fault;
> > +u8 sentinel;
> > +bool handler_called;
> > +static void pf_handler(struct ex_regs *regs)
> > +{
> > +     // check that RIP was not improperly advanced and that the
> > +     // flags value was preserved.
> > +     report("RIP has not been advanced!",
> > +             regs->rip < finish_fault);
> > +     report("The low byte of RFLAGS was preserved!",
> > +             ((u8)regs->rflags == ((sentinel | 2) & 0xd7)));
> > +
> > +     regs->rip = finish_fault;
> > +     handler_called = true;
> > +
> > +}
> > +
> > +static void prep_flags_test_env(void **vpage, struct vmcs **vmcs, handler *old)
> > +{
> > +     // get an unbacked address that will cause a #PF
> > +     *vpage = alloc_vpage();
> > +
> > +     // set up VMCS so we have something to read from
> > +     *vmcs = alloc_page();
> > +
> > +     memset(*vmcs, 0, PAGE_SIZE);
> > +     (*vmcs)->hdr.revision_id = basic.revision;
> > +     assert(!vmcs_clear(*vmcs));
> > +     assert(!make_vmcs_current(*vmcs));
> > +
> > +     *old = handle_exception(PF_VECTOR, &pf_handler);
> > +}
> > +
> > +static void test_read_sentinel(void)
> > +{
> > +     void *vpage;
> > +     struct vmcs *vmcs;
> > +     handler old;
> > +
> > +     prep_flags_test_env(&vpage, &vmcs, &old);
> > +
> > +     // set the proper label
> > +     extern char finish_read_fault;
> > +
> > +     finish_fault = (ulong)&finish_read_fault;
> > +
> > +     // execute the vmread instruction that will cause a #PF
> > +     handler_called = false;
> > +     asm volatile ("movb %[byte], %%ah\n\t"
> > +                   "sahf\n\t"
> > +                   "vmread %[enc], %[val]; finish_read_fault:"
> > +                   : [val] "=m" (*(u64 *)vpage)
> > +                   : [byte] "Krm" (sentinel),
> > +                   [enc] "r" ((u64)GUEST_SEL_SS)
> > +                   : "cc", "ah"
> > +                   );
> > +     report("The #PF handler was invoked", handler_called);
> > +
> > +     // restore old #PF handler
> > +     handle_exception(PF_VECTOR, old);
> > +}
> > +
> > +static void test_vmread_flags_touch(void)
> > +{
> > +     // set up the sentinel value in the flags register. we
> > +     // choose these two values because they candy-stripe
> > +     // the 5 flags that sahf sets.
> > +     sentinel = 0x91;
> > +     test_read_sentinel();
> > +
> > +     sentinel = 0x45;
> > +     test_read_sentinel();
> > +}
> > +
> > +static void test_write_sentinel(void)
> > +{
> > +     void *vpage;
> > +     struct vmcs *vmcs;
> > +     handler old;
> > +
> > +     prep_flags_test_env(&vpage, &vmcs, &old);
> > +
> > +     // set the proper label
> > +     extern char finish_write_fault;
> > +
> > +     finish_fault = (ulong)&finish_write_fault;
> > +
> > +     // execute the vmwrite instruction that will cause a #PF
> > +     handler_called = false;
> > +     asm volatile ("movb %[byte], %%ah\n\t"
> > +                   "sahf\n\t"
> > +                   "vmwrite %[val], %[enc]; finish_write_fault:"
> > +                   : [val] "=m" (*(u64 *)vpage)
> > +                   : [byte] "Krm" (sentinel),
> > +                   [enc] "r" ((u64)GUEST_SEL_SS)
> > +                   : "cc", "ah"
> > +                   );
> > +     report("The #PF handler was invoked", handler_called);
> > +
> > +     // restore old #PF handler
> > +     handle_exception(PF_VECTOR, old);
> > +}
> > +
> > +static void test_vmwrite_flags_touch(void)
> > +{
> > +     // set up the sentinel value in the flags register. we
> > +     // choose these two values because they candy-stripe
> > +     // the 5 flags that sahf sets.
> > +     sentinel = 0x91;
> > +     test_write_sentinel();
> > +
> > +     sentinel = 0x45;
> > +     test_write_sentinel();
> > +}
> > +
> > +
> >   static void test_vmcs_high(void)
> >   {
> >       struct vmcs *vmcs = alloc_page();
> > @@ -1994,6 +2111,10 @@ int main(int argc, const char *argv[])
> >               test_vmcs_lifecycle();
> >       if (test_wanted("test_vmx_caps", argv, argc))
> >               test_vmx_caps();
> > +     if (test_wanted("test_vmread_flags_touch", argv, argc))
> > +             test_vmread_flags_touch();
> > +     if (test_wanted("test_vmwrite_flags_touch", argv, argc))
> > +             test_vmwrite_flags_touch();
> >
> >       /* Balance vmxon from test_vmxon. */
> >       vmx_off();
>
> Not related to your patch, but just thought of mentioning it here. I
> find the name 'handle_exception' odd, because we really don't handle an
> exception in there, we just set the handler passed in and return the old
> one. May be, we should call it set_exception_handler ?
>
>
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

Reviewed-by: Peter Shier <pshier@google.com>
