Return-Path: <kvm+bounces-69194-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SILhHKlKeGn2pAEAu9opvQ
	(envelope-from <kvm+bounces-69194-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:18:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CE8929007B
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 06:18:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CEBB330160F8
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 05:17:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84EB3283FEA;
	Tue, 27 Jan 2026 05:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uq1L5yTG";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="GX4meWuE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742D315B971
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 05:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769491029; cv=none; b=kTCC/oF2/WrA+WV1zZoPCDTV3AVbzWAUE/eSQ0KCTvWdK78pcSTlebjLEE6ETuWJRNE1/FGlUEgdwGx6rmOaH9pGPmxOXBbgwgopoUz7ia3BmlxlpjFhSi9NNYj353eBOJ+hTVyeVe5hisgH6Cs62laYMvbsE/N7qlPLrLtTwzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769491029; c=relaxed/simple;
	bh=IDt4VWws2TFkvdrmWgxU4xYwGz9pAECw6d3lstpYS0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4b8aXtWOwixCHvZkY1nOQbE6B1IL3Ahp2iW2pHdxs+yPJo6LQeuDkBUAAtss6L9/uXka1e04Q0vHTlOTzt5A3qaAjSlc924DIuyGiEG6YfmxR8f4SKVBS0k2aGhuOTxHxVxYqrpvmdHyh/PxUfns7AthX6P+qNwTVm7S9/h4lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Uq1L5yTG; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=GX4meWuE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769491027;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oG/eU7ht67ZLCzu+4byuSdKHIRYwTxnvqkeHA3qrxYc=;
	b=Uq1L5yTGfppU/WaGUh4fEQ6E+KlYe25MR529GU/bimcJlSMybbohbYsCDt0q5dYWmuxwEd
	BhiwQ2us7CEIT2uYw82sAIHRlGKmCuKBr+/qLjuxR/ysdj1mbNvrdspy6qZIKScCV8HXta
	FlsB6TanJE7e8AtmfFXN0KEK+9IByqI=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-iiYfLGfANeuVWK_O3ZwO1w-1; Tue, 27 Jan 2026 00:17:04 -0500
X-MC-Unique: iiYfLGfANeuVWK_O3ZwO1w-1
X-Mimecast-MFC-AGG-ID: iiYfLGfANeuVWK_O3ZwO1w_1769491024
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2a78c094ad6so51374395ad.1
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 21:17:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769491024; x=1770095824; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oG/eU7ht67ZLCzu+4byuSdKHIRYwTxnvqkeHA3qrxYc=;
        b=GX4meWuE9X6DeTx5BzfAHm+4RvHutmJ7wytoK2aqsHBcTNK/c/Pjij5T/u28gjc13z
         xL2yxqEMrL2sI/6XpmvWlVI0hG7nc4cFevxuqb+xEW+awpeH2hYBb2Mw1CQNeirZaE4G
         KA3u1ub3iGOidcMUWW5HCsSexYbGyyyxc5QGHGEGie3XtHqmxiqPvDpVN9SFu8UuRdce
         sRa13A/oS53GccMYU6brm5G3vX/C/pFaX+0IE16divsj8HekUhRK44vCQqWR63i0lbU4
         Q1sE4AzEfwFVybQvvagpvl+c9VLZsvxZYGqVUG0o/1sLrbmx4BGqumVBWTBkYFUtZZ2x
         i1Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769491024; x=1770095824;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oG/eU7ht67ZLCzu+4byuSdKHIRYwTxnvqkeHA3qrxYc=;
        b=ciPV1Iqun2AdyvCgLgvsFpEIJ2oDngTb/5OXV7NDbxmLZATxlhjSQg7Mn4FLwKiqwz
         b7fX8XCpO/xiPLcOty1kiWbyEtjfOndCTUCPG8Ilg48DIt+tbapjfXJ6tY5fb4meOynG
         yg6uQyJHWYQ+DD1yFW/5kgTKqeYXUf19xeqomAk5t2OIWxor4Dpb4VSGw/NYBdWXFuS8
         DEtIq/u4bjNsXL0juyDZ2bkT1zIhBWWDDBehnt6efaAGWDk8BvUe/XfG1CdG2lUVP/dB
         i10TDs8LwMNQAqwpzo54QzY9RbkEi7q1wFgrmCRwudqRB1F0WpaG96JeCh1KJ5UJAOES
         gsIw==
X-Forwarded-Encrypted: i=1; AJvYcCUGXqxandHZ2CMk8sv/QW60kSfY/ucwpTTfk8BundzIKhtajH38AfAQGkEJkHucA1JOZb4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLC2RyZssgpwmCgdM7ZdjrhxzC8KEP8XOhvkjMrsPlZBehr+Fe
	eWczr/aPaAnqPKOyvfYNpatMrJc6urdmvwN4n5ZHAKz8iLGBQqe8Qe/5blEQQfi3dzloAxozbbE
	LJJTh1gyj4by1wid0l0KKJ7+o1Pr4XPQEOSk0qwF4PpoFVX7YiAGpcg==
X-Gm-Gg: AZuq6aLn/HABYjHtun+23HqFldeehsIiTq24Z+xCGS+u/Rf6NRm1PCtXsw/fMhs8zvw
	E+lGLdImi2HmN/wXUQ5eHmdjIix2v0Z7AuCdYJCwg3/nwKqG4oKh6pL2G+7CCJ1k7qFSGOGmiu9
	iZ1y5jHSJ/8MVkBGgfAfSFRBOTygJIAwc8Q/V6pu9qcRkBhWyUbFPNvqEqiCA3CHA5R9oi/QcbE
	Izmk3fJPaHJ5TXMt8x5Fgbvb3yzgDS1hBLKZC99Z4JaDEI3A3TLSDy+5hEYD3BwvVJTZNx2tUtr
	Iph8/2Rm43aT7xL8lhvQBjGUqdq0qqxhdutU4NCFi3pyz23jgMC4N+PVKEkVL1jzBW9g1+t2P/+
	ASjgSj0K7i/xnHOo2B+aX8xx6sWyH8/Jt7VWxzbUl1Q==
X-Received: by 2002:a17:903:1249:b0:295:5da6:6011 with SMTP id d9443c01a7336-2a870d458cdmr5977575ad.11.1769491023751;
        Mon, 26 Jan 2026 21:17:03 -0800 (PST)
X-Received: by 2002:a17:903:1249:b0:295:5da6:6011 with SMTP id d9443c01a7336-2a870d458cdmr5977435ad.11.1769491023393;
        Mon, 26 Jan 2026 21:17:03 -0800 (PST)
Received: from rhel9-box.lan ([122.163.48.79])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-353f6230d5dsm1110925a91.17.2026.01.26.21.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 21:17:03 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v3 09/33] i386/kvm: unregister smram listeners prior to vm file descriptor change
Date: Tue, 27 Jan 2026 10:45:37 +0530
Message-ID: <20260127051612.219475-10-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260127051612.219475-1-anisinha@redhat.com>
References: <20260127051612.219475-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69194-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CE8929007B
X-Rspamd-Action: no action

We will re-register smram listeners after the VM file descriptors has changed.
We need to unregister them first to make sure addresses and reference counters
work properly.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/kvm.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 346e1ef6f7..e28ab18a14 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -113,6 +113,11 @@ typedef struct {
 static void kvm_init_msrs(X86CPU *cpu);
 static int kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
                           QEMUWRMSRHandler *wrmsr);
+static int unregister_smram_listener(NotifierWithReturn *notifier,
+                                     void *data, Error** errp);
+NotifierWithReturn kvm_vmfd_change_notifier = {
+    .notify = unregister_smram_listener,
+};
 
 const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
     KVM_CAP_INFO(SET_TSS_ADDR),
@@ -2749,6 +2754,17 @@ static void register_smram_listener(Notifier *n, void *unused)
     }
 }
 
+static int unregister_smram_listener(NotifierWithReturn *notifier,
+                                     void *data, Error** errp)
+{
+    if (!((VmfdChangeNotifier *)data)->pre) {
+        return 0;
+    }
+
+    memory_listener_unregister(&smram_listener.listener);
+    return 0;
+}
+
 /* It should only be called in cpu's hotplug callback */
 void kvm_smm_cpu_address_space_init(X86CPU *cpu)
 {
@@ -3401,6 +3417,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
+    kvm_vmfd_add_change_notifier(&kvm_vmfd_change_notifier);
+
     return 0;
 }
 
-- 
2.42.0


