Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D731412AE4
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 04:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237926AbhIUCCa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 22:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238125AbhIUB5G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Sep 2021 21:57:06 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83BEC08E6E2
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 17:03:28 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id bj32-20020a05620a192000b00433162e24d3so77818583qkb.8
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 17:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Ym2emPwLi6hBWXuVQ5SMChiyaLYndbZZKPx2aD/RWHg=;
        b=G53bu8YtWfPhTJl7dpgEOdGgUv2aGGU1Y/ekt2BFN7/krSh0oUFzBv3QdhYcHymA15
         +CFObsnyeSzM0f7vsX/Wmue34f49I+NYYiiDldzIm+asPs+zMqpEvQCQZaeM/lE1q+jl
         llLCL6rf0Mxyz6cMqgjdkNScgAsEfvvA/O9ZFXeicjo6BDSq0zKSeZUoCanw2ps4U/Y0
         TOSeVjWhJLA1KsjIg1XhZY3FKCWJDULbVigcLkJkCXjtqLAXiGHycEqPOU3QGZKwtCvx
         ZY1FZS8v4qp70R4BJck0Q8a2e60rqbhtcCl9OKhikCuAI4fT/jY62bcG4oEGSTurOu4r
         tUvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Ym2emPwLi6hBWXuVQ5SMChiyaLYndbZZKPx2aD/RWHg=;
        b=JGzH5lLcYvcraGlHEzrgLUNrGIfWtw1gsKQ232nDZm4r/I1VSq/sbBPtD7CwQVf1TW
         qSmHDwIBueYKqVl/pQbCj2xicVgOuZn//FTmM+mzWjqgdL5DKyudJR1WN/fkJfu0+KRX
         ry2+iMk1EOHDVqqQDDkvQUvO3/cHdLf4DWB5WbE7IhvPkGm6g6AoShXd2rG4FVEBw4IL
         2D7LRF+ukyvZGaCAmOUWSDmj6ynXGpXolfebYDPl3QAqGqmTOcn3UOgOaIlQEV6RfJuJ
         N0LK6lWQssliFqZAyHs2p4hVyVyzObwT8orqaGwM2cEaUNjw+CltfQ20nl7gI9IoO5Os
         RI7g==
X-Gm-Message-State: AOAM530ElRTbh387eZpZtMz9vBO9QmcUKlaq0AAAupOUwa9lnvAhR20g
        oho9OboNeEC4HrqA7guxUtoqtAk9K2M=
X-Google-Smtp-Source: ABdhPJzuVdqk4ThCgINc8YkhlliVHw3Jms0KhMiLJkLelwBCitGX1BRAKRmGs4BK+ZmwFDj2dedaImMA0UE=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e430:8766:b902:5ee3])
 (user=seanjc job=sendgmr) by 2002:a25:ef03:: with SMTP id g3mr35561970ybd.369.1632182607846;
 Mon, 20 Sep 2021 17:03:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 20 Sep 2021 17:03:03 -0700
In-Reply-To: <20210921000303.400537-1-seanjc@google.com>
Message-Id: <20210921000303.400537-11-seanjc@google.com>
Mime-Version: 1.0
References: <20210921000303.400537-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v2 10/10] KVM: x86: WARN on non-zero CRs at RESET to detect
 improper initalization
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

WARN if CR0, CR3, or CR4 are non-zero at RESET, which given the current
KVM implementation, really means WARN if they're not zeroed at vCPU
creation.  VMX in particular has several ->set_*() flows that read other
registers to handle side effects, and because those flows are common to
RESET and INIT, KVM subtly relies on emulated/virtualized registers to be
zeroed at vCPU creation in order to do the right thing at RESET.

Use CRs as a sentinel because they are most likely to be written as side
effects, and because KVM specifically needs CR0.PG and CR0.PE to be '0'
to correctly reflect the state of the vCPU's MMU.  CRs are also loaded
and stored from/to the VMCS, and so adds some level of coverage to verify
that KVM doesn't conflate zero-allocating the VMCS with properly
initializing the VMCS with VMWRITEs.

Note, '0' is somewhat arbitrary, vCPU creation can technically stuff any
value for a register so long as it's coherent with respect to the current
vCPU state.  In practice, '0' works for all registers and is convenient.

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ec61b90d9b73..4e25baac3977 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10800,6 +10800,16 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	unsigned long new_cr0;
 	u32 eax, dummy;
 
+	/*
+	 * Several of the "set" flows, e.g. ->set_cr0(), read other registers
+	 * to handle side effects.  RESET emulation hits those flows and relies
+	 * on emulated/virtualized registers, including those that are loaded
+	 * into hardware, to be zeroed at vCPU creation.  Use CRs as a sentinel
+	 * to detect improper or missing initialization.
+	 */
+	WARN_ON_ONCE(!init_event &&
+		     (old_cr0 || kvm_read_cr3(vcpu) || kvm_read_cr4(vcpu)));
+
 	kvm_lapic_reset(vcpu, init_event);
 
 	vcpu->arch.hflags = 0;
-- 
2.33.0.464.g1972c5931b-goog

