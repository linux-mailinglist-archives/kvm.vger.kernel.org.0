Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3B8396BE4
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 05:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbhFADdD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 23:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232663AbhFADdC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 May 2021 23:33:02 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7738C061574;
        Mon, 31 May 2021 20:31:21 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 133so4632137pgf.2;
        Mon, 31 May 2021 20:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p/jZUfwCFBPckxbdbh+7RUuX92UxFL0EGZoB0VYPQFg=;
        b=NLJbbkYsskv7euY+iC/duSDT8A3cUew6l/8zNBURHuO3auvYRLki4WkXyK4qlKCnxi
         yROL7GPERMc2Px/V+LDNMWwjRkca9caJzlQ4OZNt/vgzlYp+LCKrFaC6fg0UYBKa8KCc
         Z6Fq/jTUOPDor5pPCpaFA9SD89IZp6LATQDilPL5L9P93TCNcVhLQ2d5Gizjnj7cewHV
         TehGCYbctHfANFnkljk7HAa8KW18lQLnTBCfU2oZFvutznLV8+bwRtm5zQXCSrxoLdjb
         MsZ9JC1/olnZLER3HAoYh/dkxGJUczHNrGmLeff46c2Zm09Sle936/p5zwq8fF0ubYOe
         wWvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p/jZUfwCFBPckxbdbh+7RUuX92UxFL0EGZoB0VYPQFg=;
        b=WHDBGZ3Jq95o0TWd/vKt/lh0crZZ1lFIE3LyTEm5QisnSwGD3Q6kNOIr0Y+84Rr2Oy
         JzpghA883I/gAFD0YfpD5Af5VDQdz8+3FWu63zWaUa7rRGJJTBF5joofsdtHyksHhhHW
         qcqpQ0H5en0z5dtoTbpLrGAl1IndqCMlUp3eSeMADmIYxXkUJ6f7Y7k9lz10PYBD6pc9
         G1patmVUP+k7gaXNtn4JRsHKEMDlxDRedgE/e6fjjQ2JJb3EOmfVwhdvfTA/SMNjEp47
         MWne8fhZ16zaNxuRHd8jz7v2/P9NdcXTDy8NF3PI8n993TCr8QfXSr5lPJHABt5NOnp+
         OIVw==
X-Gm-Message-State: AOAM531IGSD+DmZcXc9Aojngd/hJLi5hyh92QxmXOSA6H5H1OAps/Vgo
        6BWR7owSNEClXjLBFsxH+LmjmDnzBes=
X-Google-Smtp-Source: ABdhPJzjJiJONtWWBkuTi7UE/6NVJzFi9hjG8wz4DH3OqHXyDk/E69kQFs19T+T6EHwUItVBNR+A3w==
X-Received: by 2002:a63:b25d:: with SMTP id t29mr10248864pgo.449.1622518281150;
        Mon, 31 May 2021 20:31:21 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id c11sm12190588pjr.32.2021.05.31.20.31.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 31 May 2021 20:31:20 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: [PATCH] KVM: X86: reset and read st->preempted in atomic way
Date:   Tue,  1 Jun 2021 01:46:28 +0800
Message-Id: <20210531174628.10265-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <CANRm+CypKbrhwFR-jLCuUruXwApq4Tb62U_KP_4H-_=7yX1VQg@mail.gmail.com>
References: <CANRm+CypKbrhwFR-jLCuUruXwApq4Tb62U_KP_4H-_=7yX1VQg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

In record_steal_time(), st->preempted is read twice, and
trace_kvm_pv_tlb_flush() might output result inconsistent if
kvm_vcpu_flush_tlb_guest() see a different st->preempted later.

It is a very trivial problem and hardly has actual harm and can be
avoided by reseting and reading st->preempted in atomic way via xchg().

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0087d3532c98..fba39fe162da 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3117,9 +3117,11 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	 * expensive IPIs.
 	 */
 	if (guest_pv_has(vcpu, KVM_FEATURE_PV_TLB_FLUSH)) {
+		u8 st_preempted = xchg(&st->preempted, 0);
+
 		trace_kvm_pv_tlb_flush(vcpu->vcpu_id,
-				       st->preempted & KVM_VCPU_FLUSH_TLB);
-		if (xchg(&st->preempted, 0) & KVM_VCPU_FLUSH_TLB)
+				       st_preempted & KVM_VCPU_FLUSH_TLB);
+		if (st_preempted & KVM_VCPU_FLUSH_TLB)
 			kvm_vcpu_flush_tlb_guest(vcpu);
 	} else {
 		st->preempted = 0;
-- 
2.19.1.6.gb485710b

