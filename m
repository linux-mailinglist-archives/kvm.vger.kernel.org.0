Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C9246A1AA
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 17:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234517AbhLFQso (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 11:48:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234175AbhLFQsk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 11:48:40 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2083C0611F7
        for <kvm@vger.kernel.org>; Mon,  6 Dec 2021 08:45:11 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id z6so10679038pfe.7
        for <kvm@vger.kernel.org>; Mon, 06 Dec 2021 08:45:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Kr+JaHE4rxPgEMAj4CiYvS9ERF4arFyvma7ueUhBYKQ=;
        b=gp1JhwgXzLgzzsvJYuHH+5gZ60Z0lGc33kEEo4Srx2QzhbK0d/egjaJILZuVUc2x6h
         eI3w0ISWsJ1ZOgCfhBr/zzYhEyfc5K3GK08BZOFT9fBBNOXSkaAv9LtDgkHf0VEB+Zxk
         orfRVtW9sM/K2OJgMZWySKx2YlCE0givkDwAWf/fCthh00hGDJpc5mOtzhXVVyFYoeS7
         jbGK7bxVTvpsyOkBTDKSx41y5sy2TG/wcr3m7CyxA37/f2h7FY/3k9FmRC4DczsYSlj2
         6SDrYGJf9QxTtUiMlX4fbnHo7NntnwjI4LCE7CJgZh2bGvqtNqbnAynZBa1GbpmdTEcM
         0K7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Kr+JaHE4rxPgEMAj4CiYvS9ERF4arFyvma7ueUhBYKQ=;
        b=o913GfnVu6xbPU8JmMdBYN1A6FZ1U/Mc+rYpWmxBjXCbcdORW1I+Yy8nRgar8PxDzV
         f2pxOSgQRajP4Crzy+fNmlpFryefIaLmU7JNeZRquEpdhczvity45SwS/83xdLO4vIAS
         bKDo/v5SRe6cQFMjGesbdDWizzQuYo0/Qzs6I7i5eLucqhB9Alp1DduwXEtlieIzi6SQ
         PJqhhYmMnURRCHGDJncggcgIfglBMGOwOMP9ni44pJuhqrD8zQ0l1Lcviath1UoAhRvl
         68qwZOxNcqYrcrJrkNsnm27+JpzyU6oAkifU1tCR2897Z63ls86jWOACis13maTNKCRI
         XgNw==
X-Gm-Message-State: AOAM530X8OAKAYDQSsKDeyDOc8gtU+WA6idavYARH/7/DNtI4ZXqx8kc
        y+ZtCPH063tFhHLD7p1J1734vg==
X-Google-Smtp-Source: ABdhPJxf1a3uQAsmHxOlirkjOASik+f994ErP9f1daMIYHEzC9KZQoMcgpiOqeNvdFzZaVJ3QzcmCQ==
X-Received: by 2002:a62:640c:0:b0:4a2:e5af:d2a9 with SMTP id y12-20020a62640c000000b004a2e5afd2a9mr36887446pfb.43.1638809110964;
        Mon, 06 Dec 2021 08:45:10 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ot7sm14713658pjb.21.2021.12.06.08.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 08:45:10 -0800 (PST)
Date:   Mon, 6 Dec 2021 16:45:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        jmattson@google.com,
        syzbot <syzbot+f1d2136db9c80d4733e8@syzkaller.appspotmail.com>,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        joro@8bytes.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, wanpengli@tencent.com, x86@kernel.org
Subject: Re: [syzbot] WARNING in nested_vmx_vmexit
Message-ID: <Ya4+EprYtyvj5J5U@google.com>
References: <00000000000051f90e05d2664f1d@google.com>
 <87bl1u6qku.fsf@redhat.com>
 <Ya40sXNcLzBUlpdW@google.com>
 <87k0gh675j.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0gh675j.fsf@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 06, 2021, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > I objected to the patch[*], but looking back at the dates, it appears that I did
> > so after the patch was queued and my comments were never addressed.  
> > I'll see if I can reproduce this with a selftest.  The fix is likely just:
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index dc4909b67c5c..927a7c43b73b 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -6665,10 +6665,6 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >          * consistency check VM-Exit due to invalid guest state and bail.
> >          */
> >         if (unlikely(vmx->emulation_required)) {
> > -
> > -               /* We don't emulate invalid state of a nested guest */
> > -               vmx->fail = is_guest_mode(vcpu);
> > -
> >                 vmx->exit_reason.full = EXIT_REASON_INVALID_STATE;
> >                 vmx->exit_reason.failed_vmentry = 1;
> >                 kvm_register_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_1);
> >
> > [*] https://lore.kernel.org/all/YWDWPbgJik5spT1D@google.com/

Boom.  VCPU_RUN exits with KVM_EXIT_INTERNAL_ERROR.

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c b/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c
index 2835a17f1b7a..4f77c5d7c7b9 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c
@@ -27,6 +27,11 @@ enum {
 /* The virtual machine object. */
 static struct kvm_vm *vm;
 
+static void l2_guest_infinite_loop(void)
+{
+       while (1);
+}
+
 static void l2_guest_code(void)
 {
        /* Exit to L0 */
@@ -53,6 +58,9 @@ static void l1_guest_code(struct vmx_pages *vmx_pages)
 int main(int argc, char *argv[])
 {
        vm_vaddr_t vmx_pages_gva;
+       struct kvm_sregs sregs;
+       struct kvm_regs regs;
+       int r;
 
        nested_vmx_check_supported();
 
@@ -83,4 +91,17 @@ int main(int argc, char *argv[])
                        TEST_FAIL("Unknown ucall %lu", uc.cmd);
                }
        }
+
+       memset(&regs, 0, sizeof(regs));
+       vcpu_regs_get(vm, VCPU_ID, &regs);
+       regs.rip = (u64)l2_guest_infinite_loop;
+       vcpu_regs_set(vm, VCPU_ID, &regs);
+
+       memset(&sregs, 0, sizeof(sregs));
+       vcpu_sregs_get(vm, VCPU_ID, &sregs);
+       sregs.tr.unusable = 1;
+       vcpu_sregs_set(vm, VCPU_ID, &sregs);
+
+       r = _vcpu_run(vm, VCPU_ID);
+       TEST_ASSERT(0, "Unexpected return from L2, r = %d, exit_reason = %d", r, vcpu_state(vm, VCPU_ID)->exit_reason);
 }

  ------------[ cut here ]------------
  WARNING: CPU: 6 PID: 273926 at arch/x86/kvm/vmx/nested.c:4565 nested_vmx_vmexit+0xd59/0xdb0 [kvm_intel]
  CPU: 6 PID: 273926 Comm: vmx_close_while Not tainted 5.15.2-7cc36c3e14ae-pop #279
  Hardware name: ASUS Q87M-E/Q87M-E, BIOS 1102 03/03/2014
  RIP: 0010:nested_vmx_vmexit+0xd59/0xdb0 [kvm_intel]
  Call Trace:
   vmx_leave_nested+0x30/0x40 [kvm_intel]
   nested_vmx_free_vcpu+0x16/0x20 [kvm_intel]
   vmx_free_vcpu+0x4b/0x60 [kvm_intel]
   kvm_arch_vcpu_destroy+0x40/0x160 [kvm]
   kvm_vcpu_destroy+0x1d/0x50 [kvm]
   kvm_arch_destroy_vm+0xc1/0x1c0 [kvm]
   kvm_put_kvm+0x187/0x2a0 [kvm]
   kvm_vm_release+0x1d/0x30 [kvm]
   __fput+0x95/0x250
   task_work_run+0x5f/0x90
   do_exit+0x3c8/0xab0
   do_group_exit+0x47/0xb0
   __x64_sys_exit_group+0x14/0x20
   do_syscall_64+0x3b/0xc0
   entry_SYSCALL_64_after_hwframe+0x44/0xae

