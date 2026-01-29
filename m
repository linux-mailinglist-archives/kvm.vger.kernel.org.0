Return-Path: <kvm+bounces-69619-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EAb1IfDQe2m0IgIAu9opvQ
	(envelope-from <kvm+bounces-69619-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:28:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 71FE0B4A92
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:28:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3EF2C3011B54
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 21:27:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABB22366816;
	Thu, 29 Jan 2026 21:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jeUpRM1U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9645736606E
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 21:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769721961; cv=none; b=Km51v4cjEtgZRVstiEamB8LR2vzzaFFYoAsWafcJIRW+uIK3Pkniw+ORRuaWF4xHeCxncWT/HysRVsb5i20WMSj9g7JGsVmZqMQNVwXt/Rg0HQHgPSlAvNn/YgtgKj7CvV8m7SLCr+ipufPLgk3aWbWiab0MQrGJK5pWkev9llM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769721961; c=relaxed/simple;
	bh=FPm4HNnNzdGsASTEmXYmmsAPSB4aul9GWDReAyxeCCY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R1h8MWs0ZkMFOKY3mVm67BiqhwGv+At9oNanuA0N6V5ZUeqi3VjRpwHCg8vwTXzpQGPUB54+YZMnn7S3+zXtEhqtMWgRzh2o2wQeXBpaCJ0jcnbjGCC7IZFT8/LKtY+oO3I9tOFSeCij/yEPAYzxucaOrMVf0YXxnlIbgJ5j08E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jeUpRM1U; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c54e81eeab9so902436a12.3
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 13:25:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721959; x=1770326759; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=idHpW3SDccKJdv6+7GcWw8jBEpKmDKEMPgP0EwwfxqU=;
        b=jeUpRM1UNmTsBxYdioDrYyaaBwCFGiaoczwyCBJZM67st2YYKUK208OKLs7RYsr+D1
         BJBExVhnR5YILu3UlQ3Ik9nU/V3io0yTjFysavSShZS6Zi83Moo6S/iiOg9okaftHKTG
         /OCM7VqwrAJ1caIGChnC1gcg4HOBFTLLhphWpuY3BACjk3dqIz/7O6mFsy/A6PPjLunC
         ObFwNqzIUX+EtQiMLStK0f3Zvp+ugXw9XHCOG10iSBdzrs/04Mf0Pl994mDUK0jvpWBt
         kA1Dh67dlTNA3ioHsoQdQlnsjWivaZ3NzH7oihtDOml5t+98mMjV8eXnd9FeNtdw6B7p
         xneA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721959; x=1770326759;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=idHpW3SDccKJdv6+7GcWw8jBEpKmDKEMPgP0EwwfxqU=;
        b=BnbVJ/jaY45Sok6oktE+T94Li2mpICrnvG8STY/n0h2FHm2RmWY1LMqKMwUZfCTCCx
         wZVtiM7a791lpJ+XrAtYWnHiXsBLDESJ5NC4QzptDuVDYFFYhd0S7stfGOzLPp+raF2m
         b4plDmvCFNvVSSoo2YkV4MtNDKThMBIZXFXO6sQPen9vBs1BWCFraAseP6MAsEJno81T
         g8XmxGY3XDgnEiwE7bS61Bk8yznI1zs30W8xBqAnZOWoR01JDUPDWqbbynQY5u0m91Di
         KRrNhO1Vhz4MCCUiQpJ6beqZMwmg7oxgduP7Hpcghglg4FCvNDHuWCaKu9E0iINMuDMH
         uDrg==
X-Forwarded-Encrypted: i=1; AJvYcCUj9EfTGgAXg2P5741UrXMpyyvCZ2xF++MgIj61UzQm4St5rAsYRoBn/hxN5Eh4apdQceE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfHPPZmvzIcKJWQGo1+rT8VM9nRLxND3Noatk6Q8OvgzbTxplo
	aZNYWJfmP6AZMItbBdWxxd5klrOwppAwAqpbGJbP6DHnh1IRes3Tf0UmxqZJsN+5suryI+qrNaw
	thZm6+qUP6aW7tQ==
X-Received: from pgdj29.prod.google.com ([2002:a05:6a02:521d:b0:c5e:d16c:917e])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:3392:b0:366:581e:1a11 with SMTP id adf61e73a8af0-392e0148145mr472290637.57.1769721958852;
 Thu, 29 Jan 2026 13:25:58 -0800 (PST)
Date: Thu, 29 Jan 2026 21:25:00 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-14-dmatlack@google.com>
Subject: [PATCH v2 13/22] selftests/liveupdate: Add helpers to
 preserve/retrieve FDs
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	"=?UTF-8?q?Thomas=20Hellstr=C3=B6m?=" <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69619-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[45];
	FREEMAIL_CC(0.00)[nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 71FE0B4A92
X-Rspamd-Action: no action

From: Vipin Sharma <vipinsh@google.com>

Add helper functions to preserve and retrieve file descriptors from an
LUO session. These will be used be used in subsequent commits to
preserve FDs other than memfd.

No functional change intended.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Co-developed-by: David Matlack <dmatlack@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../liveupdate/lib/include/libliveupdate.h    |  3 ++
 .../selftests/liveupdate/lib/liveupdate.c     | 41 +++++++++++++++----
 2 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h b/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
index 4390a2737930..4c93d043d2b3 100644
--- a/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
+++ b/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
@@ -26,6 +26,9 @@ int luo_create_session(int luo_fd, const char *name);
 int luo_retrieve_session(int luo_fd, const char *name);
 int luo_session_finish(int session_fd);
 
+int luo_session_preserve_fd(int session_fd, int fd, int token);
+int luo_session_retrieve_fd(int session_fd, int token);
+
 int create_and_preserve_memfd(int session_fd, int token, const char *data);
 int restore_and_verify_memfd(int session_fd, int token, const char *expected_data);
 
diff --git a/tools/testing/selftests/liveupdate/lib/liveupdate.c b/tools/testing/selftests/liveupdate/lib/liveupdate.c
index 60121873f685..9bf4f16ca0a4 100644
--- a/tools/testing/selftests/liveupdate/lib/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/lib/liveupdate.c
@@ -54,9 +54,35 @@ int luo_retrieve_session(int luo_fd, const char *name)
 	return arg.fd;
 }
 
+int luo_session_preserve_fd(int session_fd, int fd, int token)
+{
+	struct liveupdate_session_preserve_fd arg = {
+		.size = sizeof(arg),
+		.fd = fd,
+		.token = token,
+	};
+
+	if (ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, &arg))
+		return -errno;
+
+	return 0;
+}
+
+int luo_session_retrieve_fd(int session_fd, int token)
+{
+	struct liveupdate_session_retrieve_fd arg = {
+		.size = sizeof(arg),
+		.token = token,
+	};
+
+	if (ioctl(session_fd, LIVEUPDATE_SESSION_RETRIEVE_FD, &arg))
+		return -errno;
+
+	return arg.fd;
+}
+
 int create_and_preserve_memfd(int session_fd, int token, const char *data)
 {
-	struct liveupdate_session_preserve_fd arg = { .size = sizeof(arg) };
 	long page_size = sysconf(_SC_PAGE_SIZE);
 	void *map = MAP_FAILED;
 	int mfd = -1, ret = -1;
@@ -75,9 +101,8 @@ int create_and_preserve_memfd(int session_fd, int token, const char *data)
 	snprintf(map, page_size, "%s", data);
 	munmap(map, page_size);
 
-	arg.fd = mfd;
-	arg.token = token;
-	if (ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, &arg) < 0)
+	ret = luo_session_preserve_fd(session_fd, mfd, token);
+	if (ret)
 		goto out;
 
 	ret = 0;
@@ -92,15 +117,13 @@ int create_and_preserve_memfd(int session_fd, int token, const char *data)
 int restore_and_verify_memfd(int session_fd, int token,
 			     const char *expected_data)
 {
-	struct liveupdate_session_retrieve_fd arg = { .size = sizeof(arg) };
 	long page_size = sysconf(_SC_PAGE_SIZE);
 	void *map = MAP_FAILED;
 	int mfd = -1, ret = -1;
 
-	arg.token = token;
-	if (ioctl(session_fd, LIVEUPDATE_SESSION_RETRIEVE_FD, &arg) < 0)
-		return -errno;
-	mfd = arg.fd;
+	mfd = luo_session_retrieve_fd(session_fd, token);
+	if (mfd < 0)
+		return mfd;
 
 	map = mmap(NULL, page_size, PROT_READ, MAP_SHARED, mfd, 0);
 	if (map == MAP_FAILED)
-- 
2.53.0.rc1.225.gd81095ad13-goog


