Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0C7393BDF
	for <lists+kvm@lfdr.de>; Fri, 28 May 2021 05:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236328AbhE1DUp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 23:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236023AbhE1DUp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 23:20:45 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFDFC061574;
        Thu, 27 May 2021 20:19:11 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id c12so2197278pfl.3;
        Thu, 27 May 2021 20:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pLn+gpBLNZeIF0DTenRXeN54nn8tAxDvBLhOSpC0WxA=;
        b=c+HPOkTLlzbK6BU49rtrU41ZshgOYSDdabzouPmvfzwfQ0OOuTbTYWHT2tOg6KnU8H
         ORYbt+dJIIg+hvqAwM/wOsiO2suNUGJTF6X1YHUFjcDAOlQwZH/t4yJGJlpoHguQTLSK
         zQoLInsS6hTCGEMax1KTg7/WAtXhlnYFrl5u+C5m/+e1mE1P79C4zucfQouUKWEXHOUE
         vTAyeMTSHjWYQbXg+JipabTjYmltQIncojKIdP08K7qmzcaweQ8nUuZCPLwrkJ1ADTmW
         poDStNenHgVFOs+F+cdFQeZk9Bu8d+EZz/NH5DkCer/JiYjr6QOfriTzRtdoXZECp1Sx
         ggVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pLn+gpBLNZeIF0DTenRXeN54nn8tAxDvBLhOSpC0WxA=;
        b=PxYClqRblhte7bWlVVw05uIu7zJ7Bw27UbXtY6Tt8lC6zv5GkByJXPNR4WkkoYO5Qe
         f1jPQPDzCelsEL1yRQzEumW0y+tIX50mIOy9pN8rUI14s5MFtjPU68gY6yxzC6i9idpC
         W4MqeVOAL9mZCi4Us9t1wsVTreAdcA1BhDg+JlzTslGiFThdGpXgmtxc2oly3vUDfISp
         Dzvyd5ts1fSsxz01LQpHAbQXye2sBgOtUj8uJVtkrQ4kNAOGSTvZisVMhbg0nO3eP70i
         pu+oS7ljTXnj3Da+OClYWZX1UwTgUTHq9fT+FqXm3eNQTpJQkdBidy9bY9VV1Wkm3gQy
         wgAg==
X-Gm-Message-State: AOAM532D2UZK6TqErnkY9ViFuGCneqwkZigTikair8gPGq1aA93m5jTw
        WkqMs9AQfbUeckc9O8fsBmTN9pbfbRY=
X-Google-Smtp-Source: ABdhPJylIceMrEaT8PtKPEWNRjOsTjB9irsl56e9SwQERx9aDgtQyoIfls3c8QLodO5YvTIo47Zc+A==
X-Received: by 2002:a62:3344:0:b029:28c:6f0f:cb90 with SMTP id z65-20020a6233440000b029028c6f0fcb90mr1641818pfz.58.1622171950615;
        Thu, 27 May 2021 20:19:10 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id u22sm3024766pfl.118.2021.05.27.20.19.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 May 2021 20:19:10 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Shier <pshier@google.com>, kvm@vger.kernel.org
Subject: [PATCH] KVM: X86: always reset st->preempted in record_steal_time()
Date:   Fri, 28 May 2021 01:33:58 +0800
Message-Id: <20210527173358.49427-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

st->preempted needs to be reset in record_steal_time() to clear the
KVM_VCPU_PREEMPTED bit.

But the commit 66570e966dd9 ("kvm: x86: only provide PV features if
enabled in guest's CPUID") made it cleared conditionally and
KVM_VCPU_PREEMPTED might not be cleared when entering into the guest.

Also make st->preempted be only read once, so that trace_kvm_pv_tlb_flush()
and kvm_vcpu_flush_tlb_guest() is consistent with same value of st->preempted.

Cc: Oliver Upton <oupton@google.com>
Fixes: 66570e966dd9 ("kvm: x86: only provide PV features if enabled in guest's CPUID")
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/x86.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bbc4e04e67ad..b8a7259ebd14 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3101,10 +3101,14 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
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
+	} else {
+		st->preempted = 0;
 	}
 
 	vcpu->arch.st.preempted = 0;
-- 
2.19.1.6.gb485710b

