Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1E214AB8B
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 22:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgA0VXB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 16:23:01 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:54332 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgA0VXB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jan 2020 16:23:01 -0500
Received: by mail-pg1-f202.google.com with SMTP id i21so7267955pgm.21
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2020 13:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=M7uDook8T4JuFhQPKzSHd/4CKNgbM46H4EUNpVdKl20=;
        b=nQCoMeg5/E+KDXBiPl89mZrX/Kg1XuVS5rl428w6rs8LyHFj8aVDYpYacV9NcKKeEg
         I5vAbvKzZSe21rKyTDluGc9cKcpMpZvjlp/lhl0vvJ6wENBCcWLDosQ0+D9vhuClnUOI
         upl33DmT7LzNNtkcaKyNxk3VTMVFyXpPXQkWxaHFDPqJj+kFbmmzDcjMseirRMpI0gfK
         ah5uQV/ilEnZmwn2oOiwRRuVjHhWnzXvrDjF4LSsOr9bKaZP3HayadlgPM/BAdgn4TI6
         R00A86ey46B9XNod6zeVEXD6N7ebi95rOqgYc410VknfnRFkZ80cF8yTiUZu9KFYK4zV
         wX5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=M7uDook8T4JuFhQPKzSHd/4CKNgbM46H4EUNpVdKl20=;
        b=f+5Q+szJ4E8qpBXFq3Y0MkOOGQ8+0rrYXJaSbxmcZUpSMKG0euOIms4dq4RxZkVjCa
         4W3di4WeNzEPSBiD7SFCdZmyVL/0/4wcn8NDyUtOQJGo9COj4a/nTJJEEbEGzgOiNwLN
         7M+zhqpzlEWylygzdwrh1k1V0CUbDojEzCFYvp5YJBvonaikk+qlEazC2kt0PjuRicIc
         SEtubIphEaMzRhWUa89UFJamy60IGN30BnrUWHvTrfy1uBxP5NGzonfOhnWL+0cknI8y
         dd5b9KX8uH4xHsZxVEAxG7Oo2vDzHOWCIYwWyQQFaxB1GME5ovrYidDwbfRn7kr4gqk3
         2veQ==
X-Gm-Message-State: APjAAAXiI1L+01PS5uNfv9XA8hBtSI2aPFtPSi+o0CPQeQ3duw9sesYt
        z/HR1l+mZMaTomi4H5IxK1U5f8RWgc5l7Fo=
X-Google-Smtp-Source: APXvYqztwCCBeFLwUdmvoDFFpxL4zFNAytONdjZTYtHWUot99zcOcBOoTdZdb7LJZVxpMkDMsscdqyNegKD5ym8=
X-Received: by 2002:a63:1756:: with SMTP id 22mr21988920pgx.109.1580160180456;
 Mon, 27 Jan 2020 13:23:00 -0800 (PST)
Date:   Mon, 27 Jan 2020 13:22:56 -0800
Message-Id: <20200127212256.194310-1-ehankland@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH] KVM: x86: Fix perfctr WRMSR for running counters
From:   Eric Hankland <ehankland@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Eric Hankland <ehankland@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Correct the logic in intel_pmu_set_msr() for fixed and general purpose
counters. This was recently changed to set pmc->counter without taking
in to account the value of pmc_read_counter() which will be incorrect if
the counter is currently running and non-zero; this changes back to the
old logic which accounted for the value of currently running counters.

Signed-off-by: Eric Hankland <ehankland@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 34a3a17bb6d7..9bdbe05b599c 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -264,9 +264,10 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 				pmc->counter = data;
 			else
 				pmc->counter = (s32)data;
+			pmc->counter += pmc->counter - pmc_read_counter(pmc);
 			return 0;
 		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
-			pmc->counter = data;
+			pmc->counter += data - pmc_read_counter(pmc);
 			return 0;
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
 			if (data == pmc->eventsel)

