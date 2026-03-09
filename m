Return-Path: <kvm+bounces-73358-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IE9sKRwhr2neOAIAu9opvQ
	(envelope-from <kvm+bounces-73358-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 20:35:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 412B52401F3
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 20:35:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DD64F307648C
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 19:31:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ED4641160B;
	Mon,  9 Mar 2026 19:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zYVzPMLx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8982E410D18
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 19:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773084677; cv=none; b=MWeMaeg8lgkTKQgJ1GZngDusnNUogIWduiqGcrt6gnGgu7fr9W6DeusHphYW8pnpuhBVFG1c0k9ew8W4JhpMdSY4kw3r0z990/Vqa787RmWHfnV/NXxE4xSChIkRNvMfY9qzsImgKKvPRMvKMEDVe2GqjsaxrhLcHlSrhDQAhMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773084677; c=relaxed/simple;
	bh=mUKw0kl0f4KxNAzKhr8UyqO0R7jCXXC379eGBhra2Q8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=psQY8NaO5/VKAWL2RQ0Gt+AaLaP3knZML5hu+VSXbLSlFzack+jynMMgVMti/2HPuH3D54XlAQAkySfB4uvW5HwY9+s2BD/bgWwVOTS2GxgtMhp6CkiZ7iS+mS/9GEEgNKnLEPcdqL3TAyISg38QfyV3PxHbQE/Qcvp5vFYR4sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zYVzPMLx; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8299499d582so11490138b3a.2
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 12:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773084676; x=1773689476; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1G09RtyABu4hfI9DMnNr2bllkac+dmhEIEcvARTdDJk=;
        b=zYVzPMLxyfgWNWIGVx+FhZzYjdW6KlRPal5FWU5nVKX9Ekz020jycy/N8L4pWnNwDv
         tIr8HIwIpIO4PDWBU9CESIhnABTGwOpuVAKEGjcBiO1rlqIOHn0tauHjBU8TShrppBV0
         6Vj/daXm88s5hP4OJkotY7xxO6TH75dDN4Xl+7R/pFnCx1STvW+t1kKUI5DAtNpFfVDZ
         pNZ5xKZgudojvAYZWIuK9bNn4utQO6v/5Uz0saTNC5dwlTzdhaMS+RzudcSybAlMEgPN
         wzMy0JC3b3V4l7eQqF4rxbCJSQAGiQxRjtmUPxt1h1+U1RIu0+TxKTL/9q0FUB8tHUz7
         awRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773084676; x=1773689476;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1G09RtyABu4hfI9DMnNr2bllkac+dmhEIEcvARTdDJk=;
        b=mMK/R/YE2HLP7C/82+1p/PtxtkIiTq3eNKdJw84F1kRjU6SLua8Neasx9OZpjmmPjw
         QU1nZt4M6vB9Z6sZjhSlxNHy1A1JMHERymrXao7NcBAVjYH0JgKKm75XjRxcPRAmUdnc
         Fp99ljrPJ7++t11/N+wh9yzn6vyiigw7NdWH2AMCkrOvui0X4m/JnDRfQKkl0vlGk6hk
         ln8OjVLwqe7G1wutGEQWYiTxBKPwoaL/8dRqZdh+jROpJSKa/7E71LE+g4hHfAGIMxyi
         QMnnJZQ9SQsoz9alM1F9U1nzlJ9nYmmL+nDUdw1fR3p6q2Uq9Ti9hb2Wd1yC/dzIxl7Q
         BUrw==
X-Forwarded-Encrypted: i=1; AJvYcCUoWXmYwhIFMYcSxi07pTzZ7Ic7EUKFtxWolw61dHgrDjaG4LKmsPvedOit1EQ6+70PbZo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYjOtZLpuuLr7NhvedlLuHKSVwDl5zz8ZHZPVDttb4jt73RJuA
	wt/ObZCeSj5g4TjD1LKCT9lptI/xPNRu1Ut62K60EQRoJiVNFgfTAxYU70ufaBIFXWTouVL9Uve
	/RsQ1UA==
X-Received: from pfog16.prod.google.com ([2002:aa7:8750:0:b0:829:707f:6f3e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1827:b0:827:444a:58e0
 with SMTP id d2e1a72fcca58-829a2ea9fd8mr11118741b3a.32.1773084675798; Mon, 09
 Mar 2026 12:31:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon,  9 Mar 2026 12:30:58 -0700
In-Reply-To: <20260309193059.2244645-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260309193059.2244645-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260309193059.2244645-3-seanjc@google.com>
Subject: [RFC PATCH 2/3] srcu: Add and export call_srcu_expedited() to avoid
 transferring grace periods
From: Sean Christopherson <seanjc@google.com>
To: Lai Jiangshan <jiangshanlai@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Josh Triplett <josh@joshtriplett.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: rcu@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, Keir Fraser <keirf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 412B52401F3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73358-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com,kernel.org,joshtriplett.org,redhat.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Action: no action

Add and export an expedited version of call_srcu() so that users of
synchronize_srcu_expedited() can avoid "transferring" non-expedited grace
periods.  In response to userspace changes to guest devices and memory,
KVM uses call_srcu() when freeing an object to avoid having to wait for
readers to go away, but then often emits a synchronize_srcu_expedited() in
a largely unrelated path shortly thereafter (on the same SRCU object).

Due to differences in how VMMs manage guest devices, and in the
architecture being emulated by userspace, some updates trigger call_srcu()
with concurrent readers (i.e. while the VM is active), while others occur
without readers, e.g. when configuring devices during a pre-boot setup.
For the later case (no concurrent readers), using the vanilla call_srcu()
is problematic, as it can kick off a normal grace period (totally fine for
freeing the object) and effectively transfer the non-expedited grace period
to the upcoming synchronize_srcu_expedited().

For micro-VM use cases with CONFIG_HZ=100 kernels, the resulting ~20ms
delay on the would-be-expedited sync can increase the boot time of the VM
by 15% or more.

Link: https://lore.kernel.org/all/a84ddba8-12da-489a-9dd1-ccdf7451a1ba@amazon.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/srcutiny.h | 6 ++++++
 include/linux/srcutree.h | 2 ++
 kernel/rcu/srcutree.c    | 7 +++++++
 3 files changed, 15 insertions(+)

diff --git a/include/linux/srcutiny.h b/include/linux/srcutiny.h
index 4976536e8b28..e2fc8c138e6a 100644
--- a/include/linux/srcutiny.h
+++ b/include/linux/srcutiny.h
@@ -130,6 +130,12 @@ static inline void srcu_barrier(struct srcu_struct *ssp)
 	synchronize_srcu(ssp);
 }
 
+static inline void call_srcu_expedited(struct srcu_struct *ssp, struct rcu_head *rhp,
+				       rcu_callback_t func)
+{
+	call_srcu(ssp, rhp, func);
+}
+
 static inline void srcu_expedite_current(struct srcu_struct *ssp) { }
 #define srcu_check_read_flavor(ssp, read_flavor) do { } while (0)
 
diff --git a/include/linux/srcutree.h b/include/linux/srcutree.h
index 958cb7ef41cb..ed3cbbe7f5ce 100644
--- a/include/linux/srcutree.h
+++ b/include/linux/srcutree.h
@@ -234,6 +234,8 @@ struct srcu_struct {
 					__DEFINE_SRCU(name, SRCU_READ_FLAVOR_FAST_UPDOWN, static)
 
 int __srcu_read_lock(struct srcu_struct *ssp) __acquires_shared(ssp);
+void call_srcu_expedited(struct srcu_struct *ssp, struct rcu_head *head,
+			 rcu_callback_t func);
 void synchronize_srcu_expedited(struct srcu_struct *ssp);
 void srcu_barrier(struct srcu_struct *ssp);
 void srcu_expedite_current(struct srcu_struct *ssp);
diff --git a/kernel/rcu/srcutree.c b/kernel/rcu/srcutree.c
index aef8e91ad33e..77076d2a1c57 100644
--- a/kernel/rcu/srcutree.c
+++ b/kernel/rcu/srcutree.c
@@ -1495,6 +1495,13 @@ void call_srcu(struct srcu_struct *ssp, struct rcu_head *rhp,
 }
 EXPORT_SYMBOL_GPL(call_srcu);
 
+void call_srcu_expedited(struct srcu_struct *ssp, struct rcu_head *rhp,
+			 rcu_callback_t func)
+{
+	__call_srcu(ssp, rhp, func, rcu_gp_is_normal());
+}
+EXPORT_SYMBOL_GPL(call_srcu_expedited);
+
 /*
  * Helper function for synchronize_srcu() and synchronize_srcu_expedited().
  */
-- 
2.53.0.473.g4a7958ca14-goog


