Return-Path: <kvm+bounces-69951-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GITpBvEogWkwEgMAu9opvQ
	(envelope-from <kvm+bounces-69951-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:45:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B2A0BD266A
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:45:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 807453011B50
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 22:37:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DFCF39B482;
	Mon,  2 Feb 2026 22:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bj97y5Ns"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B8539A7F0
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 22:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770071483; cv=none; b=Mxsbh26Q1ywS7CJpW9i6CvGuslNElHS90adsld0NRucbTfm13/BqKhLs7fNxmjbNtMSp+prI7z0nKtdUQVdf/JtTk931z2vpmW6eIz3AgZPtEh2ZU1NT8eKbB3ieEFtRvSxPeum8r8GPpfVKClXjQmJGU+4E23twY2DR2MVrZsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770071483; c=relaxed/simple;
	bh=uUk0S2BVuJ3WVVu8GlDY++t/M050M70+ZcrqbqgPgMQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jHTbyY16ww7rJSYJALcvIW0h2Hc+vkLK/f2aoc3MsI6/zJo4f8cLWEVON1cN0RKznoxM836gfBnr9spr23Xa/Gs93fHQTKFPBpWVD2x5UhB5/WX+oS3ReIQhCVYeMLnCxGaCpRiPz+LxOZ2m6RatPHzSX7NqCrfpYJrOzWn8kTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bj97y5Ns; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a79164b686so50093385ad.0
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 14:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770071481; x=1770676281; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CvY5PdjeEdArYXhOoEPGmWzzemIVPGSONb/31dy+9Os=;
        b=bj97y5NstBNG+Z0r5RkkrDouMM4pEcUxusbV4nOKEacpDU/xmWRkcto52qxwzPjnH7
         YILqATnEHHz40e/zHiDB/ps9ZHhYjegozyHOIxgWv6PHNwwsGvL5Kerl8IiNWswtDjJl
         J94s5EXSg7Ezf+nnuS8FvWeMY5VlgJhZTmsv4Tf4S6hK5iEtPdXFfkdxZawMv0pMqCT0
         F7rnKsbk2FU4jtXpd3MPkh4CNDvOFFr9ytf3TLi0lofNBw8t5fOcVgtpg3DmE17IezUM
         V0YwHpQHtSLYHtJc3dAxV7REJ/3r4wWvoBjobepBrkntguuoSxE+BoHaOA3tdlEB0Amr
         3TxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770071481; x=1770676281;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CvY5PdjeEdArYXhOoEPGmWzzemIVPGSONb/31dy+9Os=;
        b=KYgHYM2VEwbh76/e7TRkuJ8z/nKraI0XLlu7RhSZ+PWNSCaqMw/05lwG/PA/qZviGT
         TfrpQ4WTWJrDIYglRFZJyKzGz7bxVSOeKf1VnD9/62nx0g451gIEW35CT65SH9uDg0Ou
         HYZINDuajv9ITtdbdjZVqRVIMhHrUrnBr4CX0UJkVp88n6AIwiaLxbU/ksAE8CJq3S3e
         MdH8/hdvY1RhwURm5LGxD+vIDqrewslM06JRJtdNAB76pusQC9JTSEak7XgItZLGhqld
         qNDE9sNrF8cSeC3dr8p3BFyFxovu7nd4rtK7gt36MNfSYLn30VG70c70LS/BVOrO3MDK
         RZqg==
X-Gm-Message-State: AOJu0YxsPSTene4vFwfkix/ImoQIp+E9bYDlE3ewE2R9gbv9sPz4vLCk
	eqKgX6P+XTsC7suZKE/OY3ULL2D1IzDX9Q8Qzo/nJeDC29FIxPzKttJzosUMwA/UQA3kwN6id2s
	gUuWjr/zCAX3OlQ0KAfH5Ed29g2uDpYL+90jM4Tj/zhJSDdQKAOJCu82dJI1U0GzFhikYg5xorm
	3g+0K+iNvEH7nH6DuhZJDzYmqQhQtg2F7ur5Lfm829BfwNVPVyPU+NAtXHZfI=
X-Received: from pll9.prod.google.com ([2002:a17:902:c209:b0:2a7:8fa1:30cd])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2bcc:b0:2a7:ca82:c198 with SMTP id d9443c01a7336-2a8d9593256mr131240535ad.6.1770071480922;
 Mon, 02 Feb 2026 14:31:20 -0800 (PST)
Date: Mon,  2 Feb 2026 14:30:14 -0800
In-Reply-To: <cover.1770071243.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1770071243.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <d7d3ca70995a941bcf01d527c37470c2e64cafc0.1770071243.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 36/37] KVM: selftests: Update pre-fault test to work
 with per-guest_memfd attributes
From: Ackerley Tng <ackerleytng@google.com>
To: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	bp@alien8.de, brauner@kernel.org, chao.p.peng@intel.com, 
	chao.p.peng@linux.intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, hpa@zytor.com, 
	ira.weiny@intel.com, jgg@nvidia.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, maobibo@loongson.cn, mathieu.desnoyers@efficios.com, 
	maz@kernel.org, mhiramat@kernel.org, michael.roth@amd.com, mingo@redhat.com, 
	mlevitsk@redhat.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, prsampat@amd.com, qperret@google.com, 
	ricarkol@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, seanjc@google.com, shivankg@amd.com, shuah@kernel.org, 
	steven.price@arm.com, tabba@google.com, tglx@linutronix.de, 
	vannapurve@google.com, vbabka@suse.cz, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69951-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_GT_50(0.00)[50];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B2A0BD266A
X-Rspamd-Action: no action

From: Sean Christopherson <seanjc@google.com>

Skip setting memory to private in the pre-fault memory test when using
per-gmem memory attributes, as memory is initialized to private by default
for guest_memfd, and using vm_mem_set_private() on a guest_memfd instance
requires creating guest_memfd with GUEST_MEMFD_FLAG_MMAP (which is totally
doable, but would need to be conditional and is ultimately unnecessary).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/pre_fault_memory_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
index 93e603d91311..831b612449ec 100644
--- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
+++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
@@ -187,7 +187,7 @@ static void __test_pre_fault_memory(unsigned long vm_type, bool private)
 				    TEST_NPAGES, private ? KVM_MEM_GUEST_MEMFD : 0);
 	virt_map(vm, gva, gpa, TEST_NPAGES);
 
-	if (private)
+	if (!kvm_has_gmem_attributes && private)
 		vm_mem_set_private(vm, gpa, TEST_SIZE);
 
 	pre_fault_memory(vcpu, gpa, 0, SZ_2M, 0, private);
-- 
2.53.0.rc1.225.gd81095ad13-goog


