Return-Path: <kvm+bounces-69022-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2I+6HnPzc2ny0AAAu9opvQ
	(envelope-from <kvm+bounces-69022-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 23:17:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 159777B13C
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 23:17:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1331430692E1
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 22:15:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2C2B2D7DD2;
	Fri, 23 Jan 2026 22:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aIMP9JjC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88320248868
	for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 22:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769206552; cv=none; b=tdkK8XzmSME+XeMmqDRB0GL0H9i1GwUsc65mv70InAnV76cu4b16TXxYFkHm7p3iiirqZuuHjoPtkGSyCBc/AAlJVKYy+8rcq4VJzuNEV+g5Hhs6rJ4vnysMOgY8vPFsiI+EM5L3cV/OCuBp/jRZWeohE3tdum/KvsutqPPnkBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769206552; c=relaxed/simple;
	bh=46gVXhJmvDN4ENPIvVKEe8ZMPqDeAwPrwixf5xf7Oes=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tuugKoT++/7nlwfVwLFzaYTFX+tR2cBBFgrS59zTvg7ONsLCcUCYiAmH+vYJR8o/4HM1UWRqkpXeAg5chkMQdqgCq37ycKubgxiHa7kyA/H7QtRSw+NhI4m2+q8YIsPoeEZ9C7Ed50XpBN/DKjOKli7gynTiG+sVwv5zhIv/vmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aIMP9JjC; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-81ed3e6b917so2461132b3a.1
        for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 14:15:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769206550; x=1769811350; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YMN/+EmMPsPAQZ8tSzzUwRBwXKzIBVH9d7FNpF2H/to=;
        b=aIMP9JjCKsTlX0JQ5UGgqQj394P1girbl11S2SVAeZTVjT0V7ELuVmDWet2wMSjYJG
         mNfikb0BI7RCIOuNmhMSG7zWicVMtk6MjeKXcQ+XFN/RcFXfp3swE0Iz/nqD8FSZFij9
         TSpiac2/P0BCT2gx/4y5uJp92BNHOKJCJDvxPJ9i492I98ZjNxLV58ghyP7Hvuiovn0H
         E3tzIE2Rz2rlYt1gtVhfHyrUbdCCfdVGNHVUyo+490vGZx57eWEjHNpv2te229/OCJj+
         q2yXl7sIYWWZUWhfeWkOm3Zi3/i+EZfilWGOtH774cujcZn+TQl3lvS9DwOoIfHjVQVa
         FOWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769206550; x=1769811350;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YMN/+EmMPsPAQZ8tSzzUwRBwXKzIBVH9d7FNpF2H/to=;
        b=Hx0imkWMgbb7GHn/spQOf3Sy/kXC8lHmspyKheDi10ETGzhFU9b4nhwiSTDh3GkL7Q
         c0uFbrr2/WqqZ66cdNBgaebqcFeqesVGuWexHI/yGfw+Bq826Mw8SzOLaOrEH9lVtk6f
         B3xoA1BfHFtzSt4Q+oMHAx61QlkxoSwJukLeSplNE4vYj6d1DWyBzfR/i06FEY5KzZSw
         bIOxLW1i38ZcqqKexH4c5g6x1g7mCHYoNngZb9MVWYPHB83U0Gq4igGHR0vnTIccuDN7
         qhxS0OayEvCEYvcE3ebgGA+rwKmBlUqpTbCBYFRfwt9p8UN+Gt3rNcfi/AxvUT+ETTVS
         Mixg==
X-Gm-Message-State: AOJu0Yz6gITY2huoVcljPLWaof1tc/Sbd57WzXw0TzacnW4Usm+3Y4Qs
	XyFkxX59EadAxMzFt4oFvZSLioBhn9IkoE6RG8n3+gCXJrjT080SEGEpZI3DTBC1TxCf5bGDyfH
	6Dutm0A==
X-Received: from pfbgu11.prod.google.com ([2002:a05:6a00:4e4b:b0:7dd:8bba:6394])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:80b:b0:823:1276:9a86
 with SMTP id d2e1a72fcca58-82317e09c62mr3960900b3a.39.1769206549876; Fri, 23
 Jan 2026 14:15:49 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Jan 2026 14:15:42 -0800
In-Reply-To: <20260123221542.2498217-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260123221542.2498217-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260123221542.2498217-4-seanjc@google.com>
Subject: [PATCH 3/3] KVM: VMX: Print out "bad" offsets+value on VMCS config mismatch
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69022-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 159777B13C
X-Rspamd-Action: no action

When kvm-intel.ko refuses to load due to a mismatched VMCS config, print
all mismatching offsets+values to make it easier to debug goofs during
development, and it to make it at least feasible to triage failures that
occur during production.  E.g. if a physical core is flaky or is running
with the "wrong" microcode patch loaded, then a CPU can get a legitimate
mismatch even without KVM bugs.

Print the mismatches as 32-bit values as a compromise between hand coding
every field (to provide precise information) and printing individual bytes
(requires more effort to deduce the mismatch bit(s)).  All fields in the
VMCS config are either 32-bit or 64-bit values, i.e. in many cases,
printing 32-bit values will be 100% precise, and in the others it's close
enough, especially when considering that MSR values are split into EDX:EAX
anyways.

E.g. on mismatch CET entry/exit controls, KVM will print:

  kvm_intel: VMCS config on CPU 0 doesn't match reference config:
    Offset 76 REF = 0x107fffff, CPU0 = 0x007fffff, mismatch = 0x10000000
    Offset 84 REF = 0x0010f3ff, CPU0 = 0x0000f3ff, mismatch = 0x00100000

Opportunistically tweak the wording on the initial error message to say
"mismatch" instead of "inconsistent", as the VMCS config itself isn't
inconsistent, and the wording conflates the cross-CPU compatibility check
with the error_on_inconsistent_vmcs_config knob that treats inconsistent
VMCS configurations as errors (e.g. if a CPU supports CET entry controls
but no CET exit controls).

Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7d373e32ea9c..700a8c47b4ca 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2962,8 +2962,22 @@ int vmx_check_processor_compat(void)
 	}
 	if (nested)
 		nested_vmx_setup_ctls_msrs(&vmcs_conf, vmx_cap.ept);
+
 	if (memcmp(&vmcs_config, &vmcs_conf, sizeof(struct vmcs_config))) {
-		pr_err("Inconsistent VMCS config on CPU %d\n", cpu);
+		u32 *gold = (void *)&vmcs_config;
+		u32 *mine = (void *)&vmcs_conf;
+		int i;
+
+		BUILD_BUG_ON(sizeof(struct vmcs_config) % sizeof(u32));
+
+		pr_err("VMCS config on CPU %d doesn't match reference config:\n", cpu);
+		for (i = 0; i < sizeof(struct vmcs_config) / sizeof(u32); i++) {
+			if (gold[i] == mine[i])
+				continue;
+
+			pr_cont("  Offset %lu REF = 0x%08x, CPU%u = 0x%08x, mismatch = 0x%08x\n",
+				i * sizeof(u32), gold[i], cpu, mine[i], gold[i] ^ mine[i]);
+		}
 		return -EIO;
 	}
 	return 0;
-- 
2.52.0.457.g6b5491de43-goog


