Return-Path: <kvm+bounces-7821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEE528468E0
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 08:03:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA50E1C216F6
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 07:03:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F219418622;
	Fri,  2 Feb 2024 06:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D+H37xl6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8110182B9;
	Fri,  2 Feb 2024 06:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706857144; cv=none; b=uHxDiSYZUEZzYE077UlmKoaZ9leNWyQQWTKTYII+5S7OtDFU+MDVn/8L//wb0/OIcMAwftjzWgekF2iA1BBvZ4ry0MX0YVcKqb3Z3Sfjum/fiumqzqInaCxl1GmHLMcRKUish6Nxx9QacojF2IJGoMbntrymz/0pcrXiGfNwYTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706857144; c=relaxed/simple;
	bh=2beTdUj4YXNqigb6jUTF4KkxHyvHbagk5SI7K1z8HW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YDO4gojNJjJfIfMju16pviCw7qcAOeAW5VGiBaY0pgrQesMfD1anlAW9RRYO6kUJdelA747A3pfuKbSpgUHROkMcBg8YknrpKlzRdHyxGxMS5ZpH84HW3huZKgX/dDVNGy0CALJ2qwkIXM1HluPmukC+yUc3DHnmI2MPClmqfNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D+H37xl6; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1d7858a469aso13496465ad.2;
        Thu, 01 Feb 2024 22:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706857142; x=1707461942; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AcbZ3b72z5JTsiEYQiD8/BwtKqeQBzzGW/MZj7+sxQo=;
        b=D+H37xl6WXQcYsA4x9f26iEE4XQx4I7jkX7gIa5jnr/POMecNkuB9Cr/03kqtdlJL+
         PDwyC0vFsVOBrJwuhqWD5F17bmIiCY3jcEXl9syLQ7JBMORqOxe4fIao9wPDsqETscwz
         MF8Kaw8JBXLhTL1nKtUGBUg5ekMURjXKCjhHKWN3svuO0hCNMN6lz0MwYjo1RDhepD/w
         KIDI9H1MqYKcBu7By5+3tCVIPHK/yPTFUnZj81lamvfTcE2KXwOrJYy+H9rxJ04pCJmP
         m3JIYCgeS9CZycY3krJXbedBgTUzsMnsbUOnY6shPQtL9xf1DTajIv87XtBSVHsgo9Lb
         Gn4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706857142; x=1707461942;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AcbZ3b72z5JTsiEYQiD8/BwtKqeQBzzGW/MZj7+sxQo=;
        b=Q+tW3S1HDqhtYVNI1vFuHbeuSbqLFV9Itgbh4tBsfbeTaWD2rZSXR9YjrdKxxlZGAo
         G8hXt91xRCwzb6pldVTZVWQ9JHgEv+j3NB9ZX1btRV/ynI837ga0spfIALo5w8X3xvlF
         jtC8BdEW+09NnEI90JmMxRJjOxFc6A80C+6qgLhoNuCqDLlsQvILSDr6lzvYKmqQf7hQ
         9Vxynued54k4NYA7uknZ8k60nQ2De4P1CNcJpfNXppL4tajx7tGVuxFdk68eJKdHaCU0
         GUOHbgMKVdkJjoyJ74/3IZh92QLHVY9a6Zy7qujE90mfDYDigG+Kf2aex8pD3NUDPAsK
         c6oQ==
X-Gm-Message-State: AOJu0YwDv5aQ9I/DJvIrFDMgatdgy6yn1dfl+E5Osvsd/7FXwMr3R9eI
	oI6vopMPDGoxe6yTXFlsAHAcuIkXON/yI2U2D47wWGZ4S+bn57Ar
X-Google-Smtp-Source: AGHT+IFs+IN8kqrNAOK7L1kdhKg2x+fFZzGf5XMf2+FBY9Nbg8lXWJKa6GZTbVG9lE7J4tad2sbYug==
X-Received: by 2002:a17:902:ce8c:b0:1d9:7412:834 with SMTP id f12-20020a170902ce8c00b001d974120834mr719999plg.8.1706857141947;
        Thu, 01 Feb 2024 22:59:01 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWSPDjupVheTRpWjNG3qQOcVOPZJWHEhIlPhxS7xEOECZT/j+hA5vA7EhckWrkOUVp1YN/gMV83pWB6BlPQnN464jm5KGO0FaR/AV/72oUiwHzfmmMXB6AfWsXAYGreRlgFfBq4q4v6indtcbkufNSdGjsgqswIjC9s7nUFqPjexotrw7C85wdEReHZ4i4Hc+8/N4m44m9fAMAT3yAWTKAuRw+HxNNdwwHUbfL06hssswrFRRGhvZqesWG9HRgrSFM5+hbwwelX/CD22eTA4iFEQsrzWQ1WCRHt1Rl3QDWgENNcYBjqIAfOAr+7Nw+VVm+kmHyXa61hG/SGbSzt47XfF81ZEZIU4/dt0kycXB3YA5i/hltb8mlyQhIfojSw8EiSEAX/hczMK1BJxR1JblUApaYd1Yu1trsAUfTu5Efg2L8YNp3UnHiMD9WXpZJcE6f79A5grOoZGB/t1Fq41wpCqsWUsrcSembgQLmQNRqA2UZytjtZI/hxLRLhl13CTJQgHhr2cqx8R6E=
Received: from wheely.local0.net ([1.146.53.155])
        by smtp.gmail.com with ESMTPSA id d18-20020a170903209200b001d948adc19fsm905734plc.46.2024.02.01.22.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 22:59:01 -0800 (PST)
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
	kvmarm@lists.linux.dev
Subject: [kvm-unit-tests PATCH v2 7/9] migration: Add quiet migration support
Date: Fri,  2 Feb 2024 16:57:38 +1000
Message-ID: <20240202065740.68643-8-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240202065740.68643-1-npiggin@gmail.com>
References: <20240202065740.68643-1-npiggin@gmail.com>
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
index 0feaa190..5810f9a1 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -154,7 +154,7 @@ run_migration ()
 		-chardev socket,id=mon,path=${src_qmp},server=on,wait=off \
 		-mon chardev=mon,mode=control > ${src_outfifo} &
 	live_pid=$!
-	cat ${src_outfifo} | tee ${src_out} &
+	cat ${src_outfifo} | tee ${src_out} | grep -v "Now migrate the VM (quiet)" &
 
 	# The test must prompt the user to migrate, so wait for the "migrate"
 	# keyword
@@ -202,7 +202,7 @@ do_migration ()
 		-mon chardev=mon,mode=control -incoming unix:${dst_incoming} \
 		< <(cat ${dst_infifo}) > ${dst_outfifo} &
 	incoming_pid=$!
-	cat ${dst_outfifo} | tee ${dst_out} &
+	cat ${dst_outfifo} | tee ${dst_out} | grep -v "Now migrate the VM (quiet)" &
 
 	# The test must prompt the user to migrate, so wait for the "migrate" keyword
 	while ! grep -q -i "Now migrate the VM" < ${src_out} ; do
-- 
2.42.0


