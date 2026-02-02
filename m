Return-Path: <kvm+bounces-69936-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8FyPI7UogWkwEgMAu9opvQ
	(envelope-from <kvm+bounces-69936-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:44:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id B596AD2627
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:44:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 18B723097307
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 22:33:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F085E392C3D;
	Mon,  2 Feb 2026 22:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tpAXDRy+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9444339283C
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 22:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770071459; cv=none; b=H4NiGNRIvy53+cApDhjn6h5rTpAwdNDNLa0ZRrjr58TxUPGkXk0bUIP68ycYUY207g2nkz2bm88a1Cgm+KYaxE8qGtuEzfFaxvtfxSDzLcOlFhg6wnvpPWF5nAGVrRePNox61euc+kQ1k8GTSvetnniVrIOdh1rAK9acNsFNVYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770071459; c=relaxed/simple;
	bh=2Pig+BE6mlwz3Atq97H7ZcTJ4jMwJiYk8WbNx5KJYm4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ALW5AGFDCelVvhTPlT5aKWI3sPNpmv6dlTh0WOGaY4IK78LSWzTpSU+MDuL6gnbFVcRfj8u9DPSVyhUJgG4F+DQi0GPbfe3xbJ+u/Glw97RKISDTjveiz6mXfHJ8G+D/UC7ylVtpugej5P9HaVFk0uCj8tf9mAF0Yy8rTb0DwRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tpAXDRy+; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c54e81eeab9so3377548a12.3
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 14:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770071457; x=1770676257; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KnXsdQ94XcuKuzn9mP+GBRZHRqSPvjoz+jTMa8UBwEA=;
        b=tpAXDRy+MH62c8PBeVdoW7/3MYKlkUP8Uw89rf6CBHBshRelxSJOKPkqDchrwpFiTf
         12HM/4cVagjt6NT+00MaVlvW6rZy9/0Ao+D1YrBYIcM7ReGTkLrJVf2AYeDrg52iQTXm
         7LaW9Dq+M2LTx8rZp6HB8qkguOiLJ5jLHrPMH9Y6K9U4bXDcDuxFrY7lBfYFXUul1tP1
         rXLIKY5vLdxRv3QupVFHtBgY+h4ULWd5tV8CYVy3yUwxsMu9lFwnlGbqFLrPRHGr7Yzv
         pNR16ngbwrShrsBSpKZui+/cYFSNm5AdWyfcKA4dvvfOPWxukzFk+v9AT/n7VVrksr1K
         Gynw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770071457; x=1770676257;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KnXsdQ94XcuKuzn9mP+GBRZHRqSPvjoz+jTMa8UBwEA=;
        b=Pp/C+8HE+PR5+Qm0shLZlLJtHMdocBUdJqSCmexygx2gahW75aqzhRWbUW52bV8X9A
         FHYxsdDg3pO9vj1TC2IdnwEleiF3qzNsPXkZc+1iKu7MlLGwieucbs3YoDte4uhtxduD
         ZpnBh9+N6VC8kGOkbq1b6/tcxIjbuuHCRG+vKa/9fPy/J3E1G0qKLRdngaRIp4yqDpTc
         +ssQSX4QsEXGSivOkuP6p4Pm1tK0j134Qfm/KTr//3JDQF3Jf8CQHALgrfHOXy5Kc3u4
         GZzJisgsay7kHXHfAPF4BTkwfmdsJYr0Ra1InFi2Igm1tGphqEnn6X5fSbGoqt4VFEJs
         gfpg==
X-Gm-Message-State: AOJu0Yz2obJOJUqQB9x3z1zJ7vmdrqTbEMriZIjNnKTKqnZOHc9/K+fv
	YCjM6YsarjmEf9Osp+utpbRRrRdXg36NQwVTZqARFYOmg4WMnf/f/Dqd3TA+mQ7MkgleVU2Hk0G
	4nRDGAt2YLoWGBQDJOyuMieDFUlGwOi4i6enT5EU87s768cNLVJYFIYlPbrT0kQ96lsEjUXS3U7
	V+OX9P6WPwPKsAKvrKa8HfzScXbldzPzznWNskiYL6driV+SKwukDq7hEMqmo=
X-Received: from pjkh1.prod.google.com ([2002:a17:90a:7101:b0:350:fd27:2bc8])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:fc4f:b0:352:b674:2592 with SMTP id 98e67ed59e1d1-3543b30564bmr14178775a91.7.1770071456574;
 Mon, 02 Feb 2026 14:30:56 -0800 (PST)
Date: Mon,  2 Feb 2026 14:29:59 -0800
In-Reply-To: <cover.1770071243.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1770071243.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <84cd59d887139f01a0624c214c0a43f4c0c730f8.1770071243.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 21/37] KVM: selftests: Test conversion flow when INIT_SHARED
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
	yan.y.zhao@intel.com, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-69936-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_GT_50(0.00)[51];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B596AD2627
X-Rspamd-Action: no action

Add a test case to verify that conversions between private and shared
memory work correctly when the memory is initially created as shared.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/guest_memfd_conversions_test.c     | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
index 48265215f218..438937980f04 100644
--- a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
@@ -95,6 +95,12 @@ static void __gmem_conversions_##test(test_data_t *t, int nr_pages)		\
 #define GMEM_CONVERSION_TEST_INIT_PRIVATE(test)					\
 	__GMEM_CONVERSION_TEST_INIT_PRIVATE(test, 1)
 
+#define __GMEM_CONVERSION_TEST_INIT_SHARED(test, __nr_pages)			\
+	GMEM_CONVERSION_TEST(test, __nr_pages, GUEST_MEMFD_FLAG_INIT_SHARED)
+
+#define GMEM_CONVERSION_TEST_INIT_SHARED(test)					\
+	__GMEM_CONVERSION_TEST_INIT_SHARED(test, 1)
+
 struct guest_check_data {
 	void *mem;
 	char expected_val;
@@ -186,6 +192,12 @@ GMEM_CONVERSION_TEST_INIT_PRIVATE(init_private)
 	test_convert_to_private(t, 0, 'C', 'E');
 }
 
+GMEM_CONVERSION_TEST_INIT_SHARED(init_shared)
+{
+	test_shared(t, 0, 0, 'A', 'B');
+	test_convert_to_private(t, 0, 'B', 'C');
+	test_convert_to_shared(t, 0, 'C', 'D', 'E');
+}
 
 int main(int argc, char *argv[])
 {
-- 
2.53.0.rc1.225.gd81095ad13-goog


