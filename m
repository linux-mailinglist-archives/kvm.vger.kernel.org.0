Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2CE3F527D
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 22:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbhHWU52 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 16:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbhHWU50 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Aug 2021 16:57:26 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FE4C061575
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 13:56:43 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id k5so40633199lfu.4
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 13:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MfPwGm7EjtmSmvRvog46PefSQxr+x+Md7zVpSE6q5iY=;
        b=F2VT7MfdNQfF2aC+mrjNV+Daso+Yq3Z14ZV+Z6h8uaopYNj0tHQL/DCg520+YFSpkz
         HMHC2ObB8T9d6VnhiY6VgvFdgh5rlX4vqTZi96FDXT1DF/Vwkw+F3Jjn+pn8OWQPMWkB
         mYCV0IwCPhknXBSAj7wi+114bTreZL51D42va1MYcCoXCWvrXScI0UQLqnLnFLvUkHA0
         bBSxLSelk4cilUeMgdUnelmsbIaqk5mZOBrMeTaM+8unId+sJlOGteHTlUeZRNAMFn5z
         bRzAC4Jjv0D2b83ZDGDLlPorCzx8OR+UxWNK66lljAtyFbDduaVa4Bu6ME55eIQ7e3X5
         EAlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MfPwGm7EjtmSmvRvog46PefSQxr+x+Md7zVpSE6q5iY=;
        b=hmHLwunqdlch8KQCej2PaH13J/+OO7jwWFzWMl9w7gILBy4TnLySQNdZFa/m/zE5ZK
         YTWS/y/OFKbWDeWPxISrTar/BNkjwUO3/HNmsSs0SLxqq8WYsRLrZcaEgXJFEbn9SvBS
         GMgFqQQDFGfpUA/vBevqZjXtAs6yGUEvpKG+c61dVcGr7CfxSjhmVjRQBegu+3YXkMaJ
         jeu07Ic+kXaH3eJyEwieEKkrnS1VnQinBx9p3bP3wJjWgI1kSDjYK5KDqa9+7waUN17K
         OKaZJ7nbzc/C/ISznH+eMXzuBDAJPnfiM2AxtlS8eXzUBANnXZZ6OV80gOup9h3LwYUB
         dkGg==
X-Gm-Message-State: AOAM530pldRPLCQEAZunnBOO/cwqakQjKdHe3p8skUe3Rq9z2qJ3QI+Z
        49pLZGndPJO/Bu3DzZ9fhxBvDlhYyteY4bZcJi6wbWYkbVqSew==
X-Google-Smtp-Source: ABdhPJw8SHvShGUZj5r3Nx+hzSSyezPNL0Amodo1oDiTqLZh0M2RrBLha351nIEgZs2TuC0YuCzhvO/JGjr8cgLzSXg=
X-Received: by 2002:a05:6512:3ba4:: with SMTP id g36mr26490576lfv.80.1629752200949;
 Mon, 23 Aug 2021 13:56:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210816001130.3059564-1-oupton@google.com> <20210816001130.3059564-7-oupton@google.com>
In-Reply-To: <20210816001130.3059564-7-oupton@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Mon, 23 Aug 2021 13:56:30 -0700
Message-ID: <CAOQ_Qsj_MfRNRRSK1UswsfBw4c9ugSW6tKXNua=3O78sHEonvA@mail.gmail.com>
Subject: Re: [PATCH v7 6/6] KVM: x86: Expose TSC offset controls to userspace
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

On Sun, Aug 15, 2021 at 5:11 PM Oliver Upton <oupton@google.com> wrote:
>
> To date, VMM-directed TSC synchronization and migration has been a bit
> messy. KVM has some baked-in heuristics around TSC writes to infer if
> the VMM is attempting to synchronize. This is problematic, as it depends
> on host userspace writing to the guest's TSC within 1 second of the last
> write.
>
> A much cleaner approach to configuring the guest's views of the TSC is to
> simply migrate the TSC offset for every vCPU. Offsets are idempotent,
> and thus not subject to change depending on when the VMM actually
> reads/writes values from/to KVM. The VMM can then read the TSC once with
> KVM_GET_CLOCK to capture a (realtime, host_tsc) pair at the instant when
> the guest is paused.
>
> Cc: David Matlack <dmatlack@google.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>

Could you please squash the following into this patch? We need to
advertise KVM_CAP_VCPU_ATTRIBUTES to userspace. Otherwise, happy to
resend.

Thanks,
Oliver

 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b946430faaae..b5be1ca07704 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4070,6 +4070,7 @@ int kvm_vm_ioctl_check_extension(struct kvm
*kvm, long ext)
        case KVM_CAP_VM_COPY_ENC_CONTEXT_FROM:
        case KVM_CAP_SREGS2:
        case KVM_CAP_EXIT_ON_EMULATION_FAILURE:
+       case KVM_CAP_VCPU_ATTRIBUTES:
                r = 1;
                break;
        case KVM_CAP_EXIT_HYPERCALL:
-- 
2.33.0.rc2.250.ged5fa647cd-goog
