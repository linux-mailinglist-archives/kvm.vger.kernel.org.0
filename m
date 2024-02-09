Return-Path: <kvm+bounces-8397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 35D3684F08D
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 08:02:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CA29EB28B62
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 07:02:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24AAA657B7;
	Fri,  9 Feb 2024 07:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jKVnlqNN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E060651B0;
	Fri,  9 Feb 2024 07:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707462168; cv=none; b=b09eQvUnV5GJjN35Q5+G2LmHyykHofK1PofUNhvMslbkKj8UntoVaoN0Up383mGX+fhQMkbSlgc7CoL/DzOcWEy1FtMgP8eofqENf+AEdHJ6uzED2hFfT4DICmnhMVKTSWy0tZ4S7u4nK02Q7fxe/gMYkWQVDA/+h8kQtlunVuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707462168; c=relaxed/simple;
	bh=2We+TY3TrSFlAYJp9qjCOG7hr8bE3hpOyLxv0thXofA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dG0y74AL6knFrumvaUE0M5qUna96btytcLRCbMvBv9oRNpMDQgCYg724uUgZylswjox3goIdt3+O9xhTxRU88OdCTsJh4NDzbOCHdmDfBGYs52ClkzuuURN5EvW0nEUVxckyMc8mKKgxOTYgIQ1VLLjOhn4vAR0yM7B02u9Y9DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jKVnlqNN; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1d9b2400910so4794045ad.0;
        Thu, 08 Feb 2024 23:02:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707462166; x=1708066966; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qsb66D3Bdnju/B4wMjZRE5sQcB0Os6ZjxNoeFhHSgYI=;
        b=jKVnlqNN03rQqi+6Dbmcbm333+62bJBH5AEbQGJtzlPZKjfKM2QLD+dJg49kVfDaYZ
         7shon5X0WhMrEew3g2TLFhruTcRJo0X/y0Vq6heNxbhr2TKPtGtpGeLVLZ5atc4LsD5f
         KU1Ds5HrT9MgLE4CcG1v57lCVd6bRln1u8E5w55z8kicC2pLdzUH+q2zEuEapFZkV1fb
         vq7g1ABKUNoxXnzIB3FlJ5TPCd+Ymy1D+0bmVjMwmyfaE/iascLGTVWlQd/5lBUiXNCL
         gZYWKQtRo4ITXrNNUq2u1wA0VVYesSpNS81W9N9JYIt5prTQZnHUERamc3F9npmjSO12
         b5xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707462166; x=1708066966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qsb66D3Bdnju/B4wMjZRE5sQcB0Os6ZjxNoeFhHSgYI=;
        b=RrfPqDkmqIe0/H7eeNo6UA2s18sNtwVmvHunX6/Lg5BPeupCK/wH5W9ZXx22FHzU3i
         supFPdecCTINJGf7LXs5ZqgNKLPPTBmBP1fAO+Z0JQxBkPT7JTUDHAYz0alfsMXgIRF1
         DGY69JFFgh//aA0GsHh5bwjoLxSpAFDcL3N7cOxLI3rS8XJMzRftkVHqhOhPcK7Ki5P/
         YosB3D3HThMC9zfBpWKwUq55c0TXByQmstyVaTLdCkqJjJdOlgWY8+3vQuDhYkyZTFD7
         9LsqgEOHUarOnvFE8haB51xwNGIv1o95diz75yalSZGJO9AWK1XhcH+26p1QiClMGB+Y
         q5vA==
X-Forwarded-Encrypted: i=1; AJvYcCXLV69ADRmIa0PYXu84035Kykh+YR5L4ozyZTCpa9yzhe9zupOn2T7MoQtzvx0ZTFMKIOMqJkjWTwsiVq/OQDeyEoNp3lTxTYS62+CKburfDeoTS4Vh2y+WGjx/51DbuA==
X-Gm-Message-State: AOJu0Yxcwg1ihOpmx+ZjaukCvbTMpotk8xLWJI7UnEuUMoc78qpokeHF
	VoXWPVo6nz+oDlJdD5NCW4OR7R8muIbj6a5UVVkbP9tCmeP8s7iP
X-Google-Smtp-Source: AGHT+IHU0yLvmoVA6RKCQ6uyd2pMX3xvxjI2eIt3+EkdLZ4rFtP2o0Kv2c+t5MKAEvXWGxoEJoqkhA==
X-Received: by 2002:a17:902:dac4:b0:1d8:ff72:eef8 with SMTP id q4-20020a170902dac400b001d8ff72eef8mr252746plx.18.1707462166439;
        Thu, 08 Feb 2024 23:02:46 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWUS07VqJtp8QffWN3zhicRM8LYt8elB5iTOnmCfZ9yy015fREDprJMZMviRnS98UcXQ/VxQw5ldSNprvJDhbVvdZ2iTvfcBiAjIzZfqX58zO6C8/i7isMINudyqNMaFxktdnnzLNazq6uh+2kKcYxmW4vZDXt8HbVI8+QYEcbcIRlCYgMvivyCqBZ6LkfiVKkaqRVhOnH1HSaJkFlOP64LphaRgHUHEniYyVPhgJ2cftwYq3LZ8hQtH3X4i94sQ1NmT12Uu39pJiWkIUij9SP4kCLNt41SD0xaEIECmybtiFoq1h7Fkr3ziDK8J0m7NyoAcZ9UwSVZivUHtCuYCt6i6nZMHfN2FIL+UC4mt/7Vt9FQ4OftEaUD4g0Uj75ilOzRkKQiRzXv2CJAB7cV7goDUn40aKB6FotefYlzCEHOwttpUYJdMEU+iksnfmeV0C1WAhxVF6EOkXiv/2qUsbmlWT/TJBT5tupgBrXLQc4X/zjmDQsWKW/5uB/n2l1aRYc2ChurcIcQZOSF9H1AL/ldjQ168IPS9m45kha/V5LyIKKwVJYZc17j
Received: from wheely.local0.net ([1.146.102.26])
        by smtp.gmail.com with ESMTPSA id r10-20020a170903410a00b001d7284b9461sm839285pld.128.2024.02.08.23.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Feb 2024 23:02:46 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Subject: [kvm-unit-tests PATCH v3 6/8] migration: Add quiet migration support
Date: Fri,  9 Feb 2024 17:01:39 +1000
Message-ID: <20240209070141.421569-7-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240209070141.421569-1-npiggin@gmail.com>
References: <20240209070141.421569-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Console output required to support migration becomes quite noisy
when doing lots of migrations. Provide a migrate_quiet() call that
suppresses console output and doesn't log a message.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/migrate.c         | 12 ++++++++++++
 lib/migrate.h         |  1 +
 scripts/arch-run.bash |  4 ++--
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/lib/migrate.c b/lib/migrate.c
index b7721659..4e0ab516 100644
--- a/lib/migrate.c
+++ b/lib/migrate.c
@@ -18,6 +18,18 @@ void migrate(void)
 	report_info("Migration complete");
 }
 
+/*
+ * Like migrate() but supporess output and logs, useful for intensive
+ * migration stress testing without polluting logs. Test cases should
+ * provide relevant information about migration in failure reports.
+ */
+void migrate_quiet(void)
+{
+	puts("Now migrate the VM (quiet)\n");
+	(void)getchar();
+}
+
+
 /*
  * Initiate migration and wait for it to complete.
  * If this function is called more than once, it is a no-op.
diff --git a/lib/migrate.h b/lib/migrate.h
index 2af06a72..95b9102b 100644
--- a/lib/migrate.h
+++ b/lib/migrate.h
@@ -7,4 +7,5 @@
  */
 
 void migrate(void);
+void migrate_quiet(void);
 void migrate_once(void);
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 0b45eb61..29cf9b0c 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -152,7 +152,7 @@ run_migration ()
 		-chardev socket,id=mon,path=${src_qmp},server=on,wait=off \
 		-mon chardev=mon,mode=control > ${src_outfifo} &
 	live_pid=$!
-	cat ${src_outfifo} | tee ${src_out} &
+	cat ${src_outfifo} | tee ${src_out} | grep -v "Now migrate the VM (quiet)" &
 
 	# The test must prompt the user to migrate, so wait for the "migrate"
 	# keyword
@@ -200,7 +200,7 @@ do_migration ()
 		-mon chardev=mon,mode=control -incoming unix:${dst_incoming} \
 		< <(cat ${dst_infifo}) > ${dst_outfifo} &
 	incoming_pid=$!
-	cat ${dst_outfifo} | tee ${dst_out} &
+	cat ${dst_outfifo} | tee ${dst_out} | grep -v "Now migrate the VM (quiet)" &
 
 	# The test must prompt the user to migrate, so wait for the "migrate" keyword
 	while ! grep -q -i "Now migrate the VM" < ${src_out} ; do
-- 
2.42.0


