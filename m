Return-Path: <kvm+bounces-5154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3760081CAF9
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 14:52:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BE427B21C81
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 13:52:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF5671A28F;
	Fri, 22 Dec 2023 13:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DSpfNJ53"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9461A707;
	Fri, 22 Dec 2023 13:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3bb7376957eso1370824b6e.1;
        Fri, 22 Dec 2023 05:51:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703253116; x=1703857916; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i1XkxTZ2p8Mr79CLZoHVshU8p4yh93A2s6s7Gh9L7a0=;
        b=DSpfNJ53IOOacxiZ3oCP/uOfHxmw7QbqcFqnnPHKUyp56qPmlQxOHF24BHOFHwo0eA
         eeEFeKO0uJ4ZhOhMZXT/sR0LlaHQ/WgVmA9W8ikdpP1Z/Hdv8jcWP/EOI/B5sULSdCxo
         m1TmWLt2NQkNlzuA2XNOBjKlnG4O+/GcTPRpEnCrxOCXYc2dv+gc/r9o0fwt2ByeagPE
         dFG4s27VmnMWQJFY+elZ2a4mJgyKPW0UHbyecR0th0yafyHBjwcTnc8F+yF+s5dmS+cK
         XPP4BIjot+zqTCafUWCoW5uTMrlNIZYRTxNRAfBIKTfy0T6uXvHYTnjcNBp7kknUhD5U
         9A1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703253116; x=1703857916;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i1XkxTZ2p8Mr79CLZoHVshU8p4yh93A2s6s7Gh9L7a0=;
        b=oD7hQUQuRLbI6k/P1sANAUlJAIyluu7jNTbbc1/+No22IkvGzvNRF8vdBoS90TmUB0
         2taHQ701BPagC1Dw393td+riEOocST5X98e/K/z7QUyzbvqVx3p4dklwCuGDb9AJxON0
         1wuOoCTVcNmJNnRaVIQzupugNiuq+rQm+HFfBHTsHlTcdwb07N9UAKCCOFr2RaQjj6y+
         PEdyeuBTuUd2JArg6AUjTgoWjvRGQJE1w3zcKp94EjM2OJg6jF45ERVt0Ikp9QRqimmK
         n4+pX8G5oPEHlA73xRy9+VU7jy97wXnHHphQ7Bz+LqvbVtLUk4vK8kSmINeWjPrn+be+
         WzDQ==
X-Gm-Message-State: AOJu0YxDQjeYZIA1IebrtGGFZ7mEg3ifZktRnGb++ZK/Pubzr+NusiZ1
	0ZpPt04jYhNTFlzXZXa7i5U=
X-Google-Smtp-Source: AGHT+IHprTJdNCxifUOv0AsH6VXtdtjc+g+uqqU9nBqDg7SkScil2ywB1uZtDvuMofooy7y5LD0ZIQ==
X-Received: by 2002:a05:6358:63a8:b0:174:b807:1208 with SMTP id k40-20020a05635863a800b00174b8071208mr1233165rwh.62.1703253116275;
        Fri, 22 Dec 2023 05:51:56 -0800 (PST)
Received: from wheely.local0.net ([203.220.145.68])
        by smtp.gmail.com with ESMTPSA id n12-20020a17090ac68c00b0028ae54d988esm3629280pjt.48.2023.12.22.05.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Dec 2023 05:51:55 -0800 (PST)
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
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [kvm-unit-tests PATCH 7/9] migration: Add quiet migration support
Date: Fri, 22 Dec 2023 23:50:46 +1000
Message-ID: <20231222135048.1924672-8-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231222135048.1924672-1-npiggin@gmail.com>
References: <20231222135048.1924672-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Console output required to support migration becomes quite noisy
when doing lots of migrations. Provide a migrate_quiet() call that
suppresses console output and doesn't log.

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


