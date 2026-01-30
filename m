Return-Path: <kvm+bounces-69651-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WIgUCy0JfGn1KAIAu9opvQ
	(envelope-from <kvm+bounces-69651-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 02:28:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 56CA5B627E
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 02:28:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id F304B3004052
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 01:28:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EDEB330320;
	Fri, 30 Jan 2026 01:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q6F/Bw4f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309AF215F42
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 01:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769736486; cv=none; b=E//BEf+JG+HHXxT3of1JcxtNlErS5TFTeL4QWSpLrULR+Terlj7LdgPrnd+UvfEu+jOaxYNC7YNuGqF8uTVbsb8nxk+8N91cP3KHegGMX0dIp80giJNvfsw2MPlfQ6ocyomC7vrrh4CK4zSFuyb86UN6b59IEbebE9ZTAC+QTT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769736486; c=relaxed/simple;
	bh=3taJYbZdCbrpWbXI7XIdYXHLYZ3hNlpBVda8BMbduFE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FCsgRK131IHjetXKpOY0RDI2cyPKfqWlxGzbuTSoXYrcCffRxmsn3vNCg7lhhgOVKihZBtlmboRCreXS7CJJyVGqw039Ltz6kh8xN3dDBr54VXmPBNXP1dy2soD97pa1SmljnHkGbauW6lBWF6jI9IMcur5fzICFi7fiJKQATWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q6F/Bw4f; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-822f926eff5so769524b3a.1
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 17:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769736484; x=1770341284; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Go9/SPH+2Gh6etMrbpw5IFO/ov1QdlQoCkDEqINUYds=;
        b=Q6F/Bw4fHY/M6k88jL+KHGi9SOH2idIJMvMec7UyMWbZJETTY/aRIBmi0M08Qi8Glq
         bzwVo7TSXdAT75iBaDFh/G+MK2ZN0zo+qGwRm99R8DNNzfz+cRT1ZV70htii2/b8DQVm
         YJZfGBd9XhiUzXagd2bZm3j/ftEODaS+yNcW116ImUlCbgo2WtONstkE9fEeFUc/Gwg4
         BbOpAThfbTzV4TEi26Tu5KofRfE/P13fYUkdDFY7mAiQ8zF/jpvcE4MZC+8RG9J9WxZA
         FAR7jUqctnEeHTlfzzK6uBqIEEEvQ4Mxl0V6PgWim+Mt7uEY/U8/OMIrwqZWHerMuafv
         iYxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769736484; x=1770341284;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Go9/SPH+2Gh6etMrbpw5IFO/ov1QdlQoCkDEqINUYds=;
        b=iAoSWxrhStSo8d89PdzDefrgrUKKQ5kOkS+bq9l982ABiy30Qqt0uc4/d0PrkPujHC
         QxxN0ztctDDf3iaef+KnkDK9CThnJ9ILYyyN5wIfYe3uH/at7o22gCM1Z95FoBsZ3xB0
         to5BygU/ws7f+SQQrSwsvIY3fZC/HVNvq/46BfbAHCMgX8EpH/zlt1QYWkhaSD1cfj83
         pTZO/CA1/dSk8wK50JM8LMqby/KC8UiOQNdNDx3GcEz4YwCdb5nRRLpuL5JCunLgupXW
         1Kyrsyyw0iqGlWOTF+YrtF+qr/mpSy3OH7lGGHOoWrUfL/jORRN5kM1mrQb4J8wyHYCh
         mR4w==
X-Forwarded-Encrypted: i=1; AJvYcCWKLWYKRycIkh5R9aoNFNEoJwGQz08rB93oNlZVtmBEA4TZWO6CJG1nkzE047PRGZ/gvBY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTr2Vh9y9hCHClG9397XMLOTl9ywnYLv+W3Hia8lj8ZSAY+5y5
	kDyIaiDsBuwdaRPdHs9XVbU02Mzkc/upPWLUcqUqeE9NcTP91lSF+fj1XMYdL2PORkDIOJ1IPpG
	l0IOD9A==
X-Received: from pfbgi12.prod.google.com ([2002:a05:6a00:63cc:b0:7dd:8bba:6393])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:aa89:b0:821:8569:7f19
 with SMTP id d2e1a72fcca58-823ab9853fdmr1132825b3a.59.1769736484397; Thu, 29
 Jan 2026 17:28:04 -0800 (PST)
Date: Thu, 29 Jan 2026 17:28:02 -0800
In-Reply-To: <f9f65b0fad57db12e21d2168d02bac036615fb7f.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <20260129011517.3545883-5-seanjc@google.com>
 <f9f65b0fad57db12e21d2168d02bac036615fb7f.camel@intel.com>
Message-ID: <aXwJIkFJw_4mRl70@google.com>
Subject: Re: [RFC PATCH v5 04/45] KVM: x86: Make "external SPTE" ops that can
 fail RET0 static calls
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "x86@kernel.org" <x86@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	"bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com" <mingo@redhat.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@kernel.org" <tglx@kernel.org>, Kai Huang <kai.huang@intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "sagis@google.com" <sagis@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69651-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[104.64.211.4:from];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[100.90.174.1:received];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[19];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 56CA5B627E
X-Rspamd-Action: no action

On Thu, Jan 29, 2026, Rick P Edgecombe wrote:
> On Wed, 2026-01-28 at 17:14 -0800, Sean Christopherson wrote:
> > Define kvm_x86_ops .link_external_spt(), .set_external_spte(), and
> > .free_external_spt() as RET0 static calls so that an unexpected call to a
> > a default operation doesn't consume garbage.
> > 
> > Fixes: 77ac7079e66d ("KVM: x86/tdp_mmu: Propagate building mirror page tables")
> > Fixes: 94faba8999b9 ("KVM: x86/tdp_mmu: Propagate tearing down mirror page tables")
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> We don't want to crash unnecessarily, but do we want to get some sort of notice?

Hmm, that's probably doable, but definitely in a separate patch.  E.g. something
like:

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 6083fb07cd3b..270149f84bb4 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -3,6 +3,13 @@
 BUILD_BUG_ON(1)
 #endif
 
+#ifndef KVM_X86_OP_OPTIONAL
+#define KVM_X86_OP_OPTIONAL KVM_X86_OP
+#define KVM_X86_OP_OPTIONAL_RET0 KVM_X86_OP
+#define KVM_X86_OP_OPTIONAL_WARN KVM_X86_OP
+#define KVM_X86_OP_OPTIONAL_RET0_WARN KVM_X86_OP
+#endif
+
 /*
  * KVM_X86_OP() and KVM_X86_OP_OPTIONAL() are used to help generate
  * both DECLARE/DEFINE_STATIC_CALL() invocations and
@@ -94,11 +101,11 @@ KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
 KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
 KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
-KVM_X86_OP_OPTIONAL(alloc_external_sp)
-KVM_X86_OP_OPTIONAL(free_external_sp)
-KVM_X86_OP_OPTIONAL_RET0(set_external_spte)
-KVM_X86_OP_OPTIONAL(reclaim_external_sp)
-KVM_X86_OP_OPTIONAL_RET0(topup_external_cache)
+KVM_X86_OP_OPTIONAL_WARN(alloc_external_sp)
+KVM_X86_OP_OPTIONAL_WARN(free_external_sp)
+KVM_X86_OP_OPTIONAL_RET0_WARN(set_external_spte)
+KVM_X86_OP_OPTIONAL_WARN(reclaim_external_sp)
+KVM_X86_OP_OPTIONAL_RET0_WARN(topup_external_cache)
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cd3e7dc6ab9b..663c9943c0dd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2004,8 +2004,6 @@ extern struct kvm_x86_ops kvm_x86_ops;
 
 #define KVM_X86_OP(func) \
        DECLARE_STATIC_CALL(kvm_x86_##func, *(((struct kvm_x86_ops *)0)->func));
-#define KVM_X86_OP_OPTIONAL KVM_X86_OP
-#define KVM_X86_OP_OPTIONAL_RET0 KVM_X86_OP
 #include <asm/kvm-x86-ops.h>
 
 int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c3d71ba9a1dc..1748f44c81c0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -143,8 +143,6 @@ struct kvm_x86_ops kvm_x86_ops __read_mostly;
 #define KVM_X86_OP(func)                                            \
        DEFINE_STATIC_CALL_NULL(kvm_x86_##func,                      \
                                *(((struct kvm_x86_ops *)0)->func));
-#define KVM_X86_OP_OPTIONAL KVM_X86_OP
-#define KVM_X86_OP_OPTIONAL_RET0 KVM_X86_OP
 #include <asm/kvm-x86-ops.h>
 EXPORT_STATIC_CALL_GPL(kvm_x86_get_cs_db_l_bits);
 EXPORT_STATIC_CALL_GPL(kvm_x86_cache_reg);
@@ -9965,6 +9963,17 @@ static struct notifier_block pvclock_gtod_notifier = {
 };
 #endif
 
+static void kvm_static_call_warn(void)
+{
+       WARN_ON_ONCE(1);
+}
+
+static long kvm_static_call_warn_return0(void)
+{
+       WARN_ON_ONCE(1);
+       return 0;
+}
+
 static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
 {
        memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
@@ -9977,6 +9986,12 @@ static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
 #define KVM_X86_OP_OPTIONAL_RET0(func) \
        static_call_update(kvm_x86_##func, (void *)kvm_x86_ops.func ? : \
                                           (void *)__static_call_return0);
+#define KVM_X86_OP_OPTIONAL_WARN(func) \
+       static_call_update(kvm_x86_##func, (void *)kvm_x86_ops.func ? : \
+                                          (void *)kvm_static_call_warn);
+#define KVM_X86_OP_OPTIONAL_RET0_WARN(func) \
+       static_call_update(kvm_x86_##func, (void *)kvm_x86_ops.func ? : \
+                                          (void *)kvm_static_call_warn_return0);
 #include <asm/kvm-x86-ops.h>
 #undef __KVM_X86_OP

