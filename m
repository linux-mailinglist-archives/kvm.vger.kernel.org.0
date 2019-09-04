Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2B9A8D50
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731968AbfIDQpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 12:45:11 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:33881 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731564AbfIDQpL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 12:45:11 -0400
Received: by mail-io1-f66.google.com with SMTP id s21so45729791ioa.1
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2019 09:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1ISAgYt2isF3ZLZv6yYVWTeS9uhPVlNAV5cONkpIgWc=;
        b=iNvs3zWL3s6IOPqCe8JZP9odqEQjoOcqZ16RcqxhXj5TJ9GzBuU8rmFli6g802QeKk
         ik4SHDp5FDmD1BLCOMR/mCZCNXq0slKa/T8SeWii430MpajQpGkZjA6Mv9iRVl3O4jR6
         LPK3FpdrK4Dr8U21+bSgEQt6Yy/2GoqzA0Ctg2wznllaQgra1QEFbVbDKJwTeZm1L9Qy
         nUbKYP2WQOkEaiTw8FO/ql3bXr+dDjOg/wnD2P4RNi9hJRaQKAv3EXlBEXYGkE0j0UgY
         OupnRKzzQZ5Xe33o82C4epWYkXMm33aGdGEIn1YyJMyomw8NelxbKSkxSsrH4YC7VOiD
         EKyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1ISAgYt2isF3ZLZv6yYVWTeS9uhPVlNAV5cONkpIgWc=;
        b=RtvqiMftQ7uxSELzS+PGbEMWVI8uQe1I/rpEmzkkuuO8Y1kwoK39cx7ByCZn03pIPR
         uXvCjjYhVg2SmR74mGiZrf2Ni9IbKTWKB13+89to/BXold6VjaZA5xQN0Yj4++jTpZ6/
         bnuBJKE2LPHnOEYkzmqY+Qoeog9EsGnE0h7GNOyccsXa8ZZ4ODdMAMfFz4KJzlTCeQ5D
         ZjOIDB2bh9ykvbq6Tzyz4S1wd4kZehkxkkaPNojBSiUqEgWtIokr8gR0hI7YNl8vT1t2
         TIv/fsRoQBpwg+evnSGYjbzcuPfwBN+vLLvBq0C1Oax9IM9T3qZCokm9WPJ/gFxWONw3
         LHnw==
X-Gm-Message-State: APjAAAXFScqQrO1/i52q6q3+O66kNn5Ut9+olI7vgnXvEte30yVwR5Hi
        DgQR+YHDFJuVd7TyaysjU+dMczfjCHagjwRbaKLlww==
X-Google-Smtp-Source: APXvYqyhd+/+gtdwO0jQV6D9CAZn3SFxG3PcbfAKMSf/abjHitRn0Kn2UTYZ/Mh61hwrsV1dBEBfuHu7O7+lXi1JnqY=
X-Received: by 2002:a6b:1606:: with SMTP id 6mr587887iow.108.1567615510273;
 Wed, 04 Sep 2019 09:45:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190829205635.20189-1-krish.sadhukhan@oracle.com>
 <20190829205635.20189-3-krish.sadhukhan@oracle.com> <CALMp9eSekWEvvgwhMXWOtRZG1saQDOaKr+_4AacuM9JtH5guww@mail.gmail.com>
 <a4882749-a5cc-f8cd-4641-dd61314e6312@oracle.com> <CALMp9eTBPRT+Re9rZzmutAiy62qSMQRfMrnyiYkNHkCKDy-KPQ@mail.gmail.com>
 <CALMp9eRWSvg22JPUKOssOHwOq=uXn6GumXP1-LB2ZiYbd0N6bQ@mail.gmail.com> <e229bea2-acb2-e268-6281-d8e467c3282e@oracle.com>
In-Reply-To: <e229bea2-acb2-e268-6281-d8e467c3282e@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 4 Sep 2019 09:44:58 -0700
Message-ID: <CALMp9eTObQkBrKpN-e=ejD8E5w3WpbcNkXt2gJ46xboYwR+b7Q@mail.gmail.com>
Subject: Re: [PATCH 2/4] KVM: nVMX: Check GUEST_DR7 on vmentry of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 3, 2019 at 5:59 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
>
> On 09/01/2019 05:33 PM, Jim Mattson wrote:
>
> On Fri, Aug 30, 2019 at 4:15 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Fri, Aug 30, 2019 at 4:07 PM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
>
> On 08/29/2019 03:26 PM, Jim Mattson wrote:
>
> On Thu, Aug 29, 2019 at 2:25 PM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
>
> According to section "Checks on Guest Control Registers, Debug Registers,=
 and
> and MSRs" in Intel SDM vol 3C, the following checks are performed on vmen=
try
> of nested guests:
>
>      If the "load debug controls" VM-entry control is 1, bits 63:32 in th=
e DR7
>      field must be 0.
>
> Can't we just let the hardware check guest DR7? This results in
> "VM-entry failure due to invalid guest state," right? And we just
> reflect that to L1?
>
> Just trying to understand the reason why this particular check can be
> deferred to the hardware.
>
> The vmcs02 field has the same value as the vmcs12 field, and the
> physical CPU has the same requirements as the virtual CPU.
>
> Actually, you're right. There is a problem. With the current
> implementation, there's a priority inversion if the vmcs12 contains
> both illegal guest state for which the checks are deferred to
> hardware, and illegal entries in the VM-entry MSR-load area. In this
> case, we will synthesize a "VM-entry failure due to MSR loading"
> rather than a "VM-entry failure due to invalid guest state."
>
> There are so many checks on guest state that it's really compelling to
> defer as many as possible to hardware. However, we need to fix the
> aforesaid priority inversion. Instead of returning early from
> nested_vmx_enter_non_root_mode() with EXIT_REASON_MSR_LOAD_FAIL, we
> could induce a "VM-entry failure due to MSR loading" for the next
> VM-entry of vmcs02 and continue with the attempted vmcs02 VM-entry. If
> hardware exits with EXIT_REASON_INVALID_STATE, we reflect that to L1,
> and if hardware exits with EXIT_REASON_INVALID_STATE, we reflect that
> to L1 (along with the appropriate exit qualification).
>
>
> Looking at nested_vmx_exit_reflected(), it seems we do return to L1 if th=
e error is EXIT_REASON_INVALID_STATE. So if we fix the priority inversion, =
this should work then ?

Yes.

> The tricky part is in undoing the successful MSR writes if we reflect
> EXIT_REASON_INVALID_STATE to L1. Some MSR writes can't actually be
> undone (e.g. writes to IA32_PRED_CMD), but maybe we can get away with
> those. (Fortunately, it's illegal to put x2APIC MSRs in the VM-entry
> MSR-load area!) Other MSR writes are just a bit tricky to undo (e.g.
> writes to IA32_TIME_STAMP_COUNTER).
>
>
> Let's say that the priority inversion issue is fixed. In the scenario in =
which the Guest state is fine but the VM-entry MSR-Load area contains an il=
legal entry,  you are saying that the induced "VM-entry failure due to MSR =
loading"  will be caught during the next VM-entry of vmcs02. So how far doe=
s the attempted VM-entry of vmcs02  continue with an illegal MSR-Load entry=
 and how do get to the next VM-entry of vmcs02 ?

Sorry; I don't understand the questions.
>
> There are two other scenarios there:
>
>     1. Guest state is illegal and VM-entry MSR-Load area contains an ille=
gal entry
>     2. Guest state is illegal but VM-entry MSR-Load area is fine
>
> In these scenarios, L2 will exit to L1 with EXIT_REASON_INVALID_STATE and=
 finally this will be returned to L1 userspace. Right ?  If so, we do we ca=
re about reverting MSR-writes  because the SDM section 26.8 say,
>
>         "Processor state is loaded as would be done on a VM exit (see Sec=
tion 27.5)"

I'm not sure how the referenced section of the SDM is relevant. Are
you assuming that every MSR in the VM-entry MSR load area also appears
in the VM-exit MSR load area? That certainly isn't the case.

> Alternatively, we could perform validity checks on the entire vmcs12
> VM-entry MSR-load area before writing any of the MSRs. This may be
> easier, but it would certainly be slower. We would have to be wary of
> situations where processing an earlier entry affects the validity of a
> later entry. (If we take this route, then we would also have to
> process the valid prefix of the VM-entry MSR-load area when we reflect
> EXIT_REASON_MSR_LOAD_FAIL to L1.)

Forget this paragraph. Even if all of the checks pass, we still have
to undo all of the MSR-writes in the event of a deferred "VM-entry
failure due to invalid guest state."

> Note that this approach could be extended to permit the deferral of
> some control field checks to hardware as well.
>
>
> Why can't the first approach be used for VM-entry controls as well ?

Sorry; I don't understand this question either.

>  As long as the control
> field is copied verbatim from vmcs12 to vmcs02 and the virtual CPU
> enforces the same constraints as the physical CPU, deferral should be
> fine. We just have to make sure that we induce a "VM-entry failure due
> to invalid guest state" for the next VM-entry of vmcs02 if any
> software checks on guest state fail, rather than immediately
> synthesizing an "VM-entry failure due to invalid guest state" during
> the construction of vmcs02.
>
>
> Is it OK to keep this Guest check in software for now and then remove it =
once we have a solution in place ?

Why do you feel that getting the priority correct is so important for
this one check in particular? I'd be surprised if any hypervisor ever
assembled a VMCS that failed this check.
