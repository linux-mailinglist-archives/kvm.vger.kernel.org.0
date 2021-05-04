Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84350372EA3
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 19:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbhEDRSq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 13:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbhEDRSn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 13:18:43 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA722C06138B
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 10:17:47 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id r20-20020ac85c940000b02901bac34fa2eeso4007617qta.11
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 10:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=zyk/CnPUPX4IZt1E/UCYCEZ+CYodKlkrWWKieBP0u40=;
        b=sXmep3CNmV6ncUmh4Bwt9ZAeJiSDP0JoBEhefkkGoDExZ3KWPbvsIU53JnIsEc8zfT
         2CLrK3Ev6uYm//ZTV8x3LBbl0pu76DCNtR4bhbBmeIoP1Yxz394XylT340mUTD2ikJIm
         +1cv0jsiXrLQd9DYbrRc3EM3FU169gR0ontu9WZBcWU/oftdv3RNOpv39sWk79rVQmhu
         B/zjoWAHBa3MpJXy4gwirrxumf1PQnWBGtr/HgGs/qyv9/i2JD56atdndo7MZm/gbzY5
         MFZ6Abd/WzdR+F5CHGnUmZQzWy1xnjK6u/Qywe7tLexPOd7WjMK9OLibvAMFXhgOgPAB
         HnXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=zyk/CnPUPX4IZt1E/UCYCEZ+CYodKlkrWWKieBP0u40=;
        b=FsKiS/E1q9zzYEGLRhSBVg7fBTEPvrYZjYWMqpA7BrbtdaJOZJrSpWFKB1tQvB/C5o
         ts92jBAPl+BDFA7BPmEmxYUJ43LF5Oe3E+OTfWtIhkE0cIE3Mp50qBLE00N0DMn2a+1h
         QItdiBj5mgtxO0SySgU+iT+wu6361kqD7GkqPbOXtRWN+MytAGSK7tZWXLaGdKq5Ge3e
         knTGRrMpkV0/hO9S1QyBcy+8HvX5rqAvShxFkbZoGjjSZIFZsEO9vJ61B6dROilRA+ef
         NyfCzWr5PV8YL3BlLwvuvunJpT2u/gdqTZi3I/ensuVJ4AapAFX5/OcJQmT+Ot5+yRhf
         A1uw==
X-Gm-Message-State: AOAM530xmdgSz3YjSEmRn3IjkiZ9Rgico+mzgCxF2Vy7D/HfFpWDjdHh
        clUuM3kN7sfLkkzQsmKCGYJKGYLL9Pc=
X-Google-Smtp-Source: ABdhPJxwWT2eyWq3SHAnHcamuoyl+SuIC6Dyz9Xd5AV959ifFtMmBZB15+K8e6dS33p4FmM7eJNyadnHMuA=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:df57:48cb:ea33:a156])
 (user=seanjc job=sendgmr) by 2002:a05:6214:c2d:: with SMTP id
 a13mr18106571qvd.37.1620148666938; Tue, 04 May 2021 10:17:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 May 2021 10:17:21 -0700
In-Reply-To: <20210504171734.1434054-1-seanjc@google.com>
Message-Id: <20210504171734.1434054-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210504171734.1434054-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH 02/15] KVM: x86: Emulate RDPID only if RDTSCP is supported
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do not advertise emulation support for RDPID if RDTSCP is unsupported.
RDPID emulation subtly relies on MSR_TSC_AUX to exist in hardware, as
both vmx_get_msr() and svm_get_msr() will return an error if the MSR is
unsupported, i.e. ctxt->ops->get_msr() will fail and the emulator will
inject a #UD.

Note, RDPID emulation also relies on RDTSCP being enabled in the guest,
but this is a KVM bug and will eventually be fixed.

Fixes: fb6d4d340e05 ("KVM: x86: emulate RDPID")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index f765bf7a529c..c96f79c9fff2 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -637,7 +637,8 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
 	case 7:
 		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 		entry->eax = 0;
-		entry->ecx = F(RDPID);
+		if (kvm_cpu_cap_has(X86_FEATURE_RDTSCP))
+			entry->ecx = F(RDPID);
 		++array->nent;
 	default:
 		break;
-- 
2.31.1.527.g47e6f16901-goog

