Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5827946F2E1
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 19:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243218AbhLISYI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 13:24:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237501AbhLISYH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 13:24:07 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0FBC061746
        for <kvm@vger.kernel.org>; Thu,  9 Dec 2021 10:20:33 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id k64so6150805pfd.11
        for <kvm@vger.kernel.org>; Thu, 09 Dec 2021 10:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tvmy9iuHyCNf/Lo2PS/zSkuGC5kcxP0bkqvMrstnVw0=;
        b=NVqDlwIh2sHhH5QYeeW/d2laVrOu2ZCkrX5i1KWgB76AOG2RQBQs2eQory7cxCXrhR
         nF9Sk1RJUQmqWcurEx53sgPYE9+1EjHlb5vh3v4TFSa8BYl8AfMFviYEzLVEACUOBq3e
         vVyN7UXKVfrTz7zA85/wfZXGyZ1LH7smYOcR3nuxwDjvZ2GTU5K12scLVF1WQusWk70e
         2Q3yGDrH6JbHGSSDUYjntJLtU6INyTpesMqiefJcCPlTwnWrOmpF8321ukShaZ6O4cm4
         Ij9HSjxGc6rwMnN7reCUtYi9R7z4FCeiSFgQU5xqOhyIpK63FfxTdCvNH7DJ3xv64UZG
         ltEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tvmy9iuHyCNf/Lo2PS/zSkuGC5kcxP0bkqvMrstnVw0=;
        b=6gjHDggGW9oa9P4hfjlqHGoSpHwj4PdUty7JjTmhVQRH6YgNMtJa34lsAbANegAT/q
         0kESB6w/rrr7OSjHn9ycmHsafK/v/pYFpnTDbANLjxSfTN7p6HdUcXhTsJ7HPOzUh8D+
         fADKAXW9nI1LjkYs3NqNqpR1W/g6RW7MG8chGJ9GaHSwhaBkQ524FvSFLJH7GPhj+2No
         9FkWyQEDFn73m+vL5wnV/Mg7IAadxROkxHOZwz39QaDG1EF6E0CB+BCdJh5N0YWXYn3j
         HCWKqF0ud+shb/CG7SC6v3BCYoZX5TRP/9RYPMThcqaIsPDAjF6eCa67pxFvyoN4lknx
         OAzA==
X-Gm-Message-State: AOAM533FORk/R3bGabxasds0nJ7PJT037IkK+LZdamNkpq1Yu84f836y
        NSEriCL/rNdAgs2Ng8xRApxZMg2MidZ7Gi6irY+1lg==
X-Google-Smtp-Source: ABdhPJyD+/hhRaesCxfvIDL8j2lPF4eYq/ATj7b/WPTrGaMg2JzO9vmEOdlSJAt8Mxxn++KBRtz0n28hg1VrkZTfT/8=
X-Received: by 2002:a05:6a00:b89:b0:4ae:d9a3:ccf9 with SMTP id
 g9-20020a056a000b8900b004aed9a3ccf9mr13242826pfj.13.1639074033142; Thu, 09
 Dec 2021 10:20:33 -0800 (PST)
MIME-Version: 1.0
References: <20211209155257.128747-1-marcorr@google.com> <5f8c31b4-6223-a965-0e91-15b4ffc0335e@redhat.com>
In-Reply-To: <5f8c31b4-6223-a965-0e91-15b4ffc0335e@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 9 Dec 2021 10:20:22 -0800
Message-ID: <CALMp9eThf3UtvoLFjajkrXtvOEWQvc8_=Xf6-m6fHXkOhET+GA@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: x86: Always set kvm_run->if_flag
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Orr <marcorr@google.com>, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        thomas.lendacky@amd.com, mlevitsk@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 9, 2021 at 9:48 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 12/9/21 16:52, Marc Orr wrote:
> > The kvm_run struct's if_flag is a part of the userspace/kernel API. The
> > SEV-ES patches failed to set this flag because it's no longer needed by
> > QEMU (according to the comment in the source code). However, other
> > hypervisors may make use of this flag. Therefore, set the flag for
> > guests with encrypted registers (i.e., with guest_state_protected set).
> >
> > Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
> > Signed-off-by: Marc Orr<marcorr@google.com>
>
> Applied, though I wonder if it is really needed by those other VMMs
> (which? gVisor is the only one that comes to mind that is interested in
> userspace APIC).

Vanadium appears to have one use of it.

> It shouldn't be necessary for in-kernel APIC (where userspace can inject
> interrupts at any time), and ready_for_interrupt_injection is superior
> for userspace APIC.

LOL. Here's that one use...

if (vcpu_run_state_->request_interrupt_window &&
vcpu_run_state_->ready_for_interrupt_injection &&
vcpu_run_state_->if_flag) {
...
}

So, maybe this is much ado about nothing?
