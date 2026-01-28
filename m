Return-Path: <kvm+bounces-69309-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SM+yOtlpeWmPwwEAu9opvQ
	(envelope-from <kvm+bounces-69309-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 02:43:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 76E949C008
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 02:43:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A567D3015C9E
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 01:43:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4902826FD9A;
	Wed, 28 Jan 2026 01:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HYfuDvbo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FAE257854
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 01:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769564600; cv=none; b=lSqv4STF12+ZdAKvAj52v2woO+OQOrmu2KkgSiSAr3rV0gznTqWd3hjT/cAlRb/WiCIHhJJs2psMFQeasBY5LhANZqknj5JgUKwM5VRfA6n/L86MxrgL64nmxg1/5A4ANLvWHRehKCOuIUqz3vIelDey4rh8DCPb0rLt2HWM6fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769564600; c=relaxed/simple;
	bh=4El7qL7PVPZa0aprqlCvyq41SKfmYL6SM5DDRrMwQkk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gEXk04HsfzaZRh7qk43WckBcS56D9R2MMz+U/Ucy2fqZywnouJ3V8OeQnl6fF+/ZS7U4UZCuQML+2yDWzz44kKVT6aJI0WMSKX1QjrdCzc0Ke3+Ptc32JGYwfvuRugS1zNfGn1XiydYif9+n38J3xV/lIEcb77NFSu6TOBJuyxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HYfuDvbo; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34ec823527eso10628854a91.2
        for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 17:43:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769564598; x=1770169398; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EsE5fDwgRpoSCOUNzOT/fBkqra7ip2Uh79gr2v+01xE=;
        b=HYfuDvbodAz/bNo070L71s6v0EibEE5YcvqyoNHPdIo4PhCsUO68vYlk1Lmck+nET8
         lLnWY6gKlVGqWuIkDZF48VZuHc3bc5Sk8UweL6rDudrceQuKIYTkxwYQYXlOdz5XKsFu
         7NAm3gYkYfDSGIgzYqHRpuy4VmzX7/ZEgmSh4J6Q66Zwza5g5ojSrPp5hkXWYta88Sur
         Y7D/8YQozg7M3bJ3RpwwvsmFkbtZyrE16IHKwcRN0JYszhfH5WapGBGDN8/+CbhTXXi4
         fyGSgBCHZw7AniBPY/AAX1hlojPoSCH+igkl6dR1/0Lf59fPq84oloKN+DbnC0j4GBxA
         QlFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769564598; x=1770169398;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EsE5fDwgRpoSCOUNzOT/fBkqra7ip2Uh79gr2v+01xE=;
        b=K7BNNvHmi8Bq6lH2vtac2kxTIbW4kAe6eCMJWDWJyKGWSRpKn+wyQ6pf0mTtxTwreF
         /22JZJpPRVJoZ/pn1Y1FPGb2MYR4YlAY5npiBokS8XXvPEYXmqLJLHw+mzAN8r5gaa4l
         PdIQ7OCa4q1n1hpcNrl57tRiA6H796nMnhmlnxdOQ/m7ga7FyH4nzBnIf61bYe8PcSzN
         PTlaClcUSZd3wKd4Qi+7raJhDIXwCPLkImvTczxf6JM9wA8OQGaCQ/B1xjiwKx4paZXW
         gukEo/hE6nwBZNcXVrm0NVE2IEiXnJD3g8uIa7GLFuL5MuX1/cmb8q2ojmG5Y77yY1Z9
         SN8w==
X-Gm-Message-State: AOJu0YxFjJd0UASb5X9i7SlBVkUlp1jXCUyH6Tfma5XhZWHQBr0yb57g
	i47RNNmotklL0dlaGfH/P9hGWTWZsdvyJVQYVgOsKOJU7rGlIv0izwBDQqu/uRemiJMHDc3XOow
	K/TZ4QQ==
X-Received: from pjrx13.prod.google.com ([2002:a17:90a:bc8d:b0:34c:811d:e3ca])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d404:b0:352:bd7c:ddbd
 with SMTP id 98e67ed59e1d1-353fed846d8mr3252257a91.23.1769564598099; Tue, 27
 Jan 2026 17:43:18 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 27 Jan 2026 17:43:10 -0800
In-Reply-To: <20260128014310.3255561-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260128014310.3255561-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260128014310.3255561-4-seanjc@google.com>
Subject: [PATCH v2 3/3] KVM: VMX: Print out "bad" offsets+value on VMCS config mismatch
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
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69309-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
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
X-Rspamd-Queue-Id: 76E949C008
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
 arch/x86/kvm/vmx/vmx.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 93ec1e6181e4..11bb4b933227 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2962,8 +2962,23 @@ int vmx_check_processor_compat(void)
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
+		pr_err("VMCS config on CPU %d doesn't match reference config:", cpu);
+		for (i = 0; i < sizeof(struct vmcs_config) / sizeof(u32); i++) {
+			if (gold[i] == mine[i])
+				continue;
+
+			pr_cont("\n  Offset %u REF = 0x%08x, CPU%u = 0x%08x, mismatch = 0x%08x",
+				i * (int)sizeof(u32), gold[i], cpu, mine[i], gold[i] ^ mine[i]);
+		}
+		pr_cont("\n");
 		return -EIO;
 	}
 	return 0;
-- 
2.52.0.457.g6b5491de43-goog


