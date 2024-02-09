Return-Path: <kvm+bounces-8420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 318DD84F20D
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 10:12:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDA51286E81
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 09:12:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F6EA6772F;
	Fri,  9 Feb 2024 09:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IU85r9dy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37232664C5;
	Fri,  9 Feb 2024 09:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707469951; cv=none; b=Fb82At//J5JvawtaV4A/GBZbzVknGKmwvs7FX+hS1+qE+DRWUVo4ZkZDCrF/EoDsV8mxS/VHdx3SlhKcTBTHmwHUUrwkdarixI4HHLHEbJ1hUwIjqIbzn7CJugtbQLwy2mhDzdvrMmihkRfTGn7CaMxIVBEhYNS3G/a3DwUNyIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707469951; c=relaxed/simple;
	bh=H5zOkFsThYHS+CIs/f4GLylAaVSi5mDx3GgSSHbQBfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jsm8YeROWpaXeLNr82J//pe6jV1Tt2p1eDZT5gIGNuYaBD2VTxX/CJgHDPjpsXWpMgcN1LShqOksS+ij5UlIH30tUESDYHe104OAw7KHlC4Zz5/EI5Gz6FXpOU10xknpkgeznt+kjoxi63HpxLYqnspxFccnrYaCe2MkKlAteJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IU85r9dy; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6e04f29c7bcso518614b3a.0;
        Fri, 09 Feb 2024 01:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707469949; x=1708074749; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J+sqr3M98Kde9sdnxslUPSokF3Ng1Usn2pZLKUoX5aU=;
        b=IU85r9dyBnZs0lrDqnKzjKYbvOjXNsINz5m3L48C9x8Tl8NhRFBjVfs7dOc64dS581
         tZjtDT3FPe1xJ0C7OBQbwYjdgsevH8kViKg2qHcgfRaj+H4WrpHApvBpJcDj6sNEEWgJ
         aE9Q6xxTmFz04Q75MuwI/r19LymBialarYw+NgFSKDnxijsBygDCgHnvD2MwYu5+Qa2f
         +0LABTzVvO3QGeC6ldb42p9HitbFrHEnvAyJMzD0choSvK5/rMFCBQiM5LBpQCT+VtA6
         +cpn3AaTrHx51lsRyfi2qZQRwBr0GJHlR5XjMHmsQj6Pv+s/lecmf5fK2AYsZIkV0eo+
         ySzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707469949; x=1708074749;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J+sqr3M98Kde9sdnxslUPSokF3Ng1Usn2pZLKUoX5aU=;
        b=Bb/VWW0Lp5xisz+S49oi0c2iDBN6Kyr2AuatL4SLwVE2EYx5/TgNYGpI1wIdQJkRDg
         t5kmvrb8uJfg8BXGPtPtr69B0zEDAA3OxXDX37iOe3NE0U8nPUIw5tz7sUkU0Gf/w+U2
         OxugGj8HeIGKQ/jC/I/Hw6Pc/CV2NF/vP61FQznlVkVTxVyhh/PJysMJrceG+e1EF1+J
         Gc++yCglQzjRuB1sYS8nkp1QjKb5WUre0dcKdZ6WFy01XnN1mPh2elMrOu2Cj1HTRm7B
         FUbmExcdLY+whngMJIEzRdNreQx6wx08UQhQzKqdrIOwDk/1u7NV/T3MaAGGJJ27JfHt
         MlyA==
X-Forwarded-Encrypted: i=1; AJvYcCXmPDQP9fKMsfhWv31bb4ATznYniv8uRbKnLBpbpSo5TvXxUMFshZWeE0BBcQyKfm3e1a6F7uEJ4JjvTXnZoW82kcOUP9rVPFbhxXcb/pRXsO4ySiLlVn4qdfI96rHLVQ==
X-Gm-Message-State: AOJu0Yxr5xGslrFHAIDJAeekHJOVly7gxQ+RtFYGBTQ8kgrqp2DGQSkP
	KYgubdDERwc7ZCjO0bvkDz7yiAeWN9EFpN9QvjTROJFkgA5fy/Fs
X-Google-Smtp-Source: AGHT+IGZiCLeAGHQEeXZBPf6iULKQpILOZ0yiXZFxdekf6snAicAqOXMJ5tAAJqWOoJoPAenpSfyfA==
X-Received: by 2002:a05:6a20:9e47:b0:19e:3a9f:f925 with SMTP id mt7-20020a056a209e4700b0019e3a9ff925mr1379427pzb.14.1707469949311;
        Fri, 09 Feb 2024 01:12:29 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVzluO77dA063QfZWhHREA8V27IxpTe9fFgjzHmlT7bplmWFF152odg1GY/Slh6d8UPJTMANFSrITjUQ0ZsVqx+spgRQEVJ+SXxTdj5OfvWG+QyNpKU9ojdeobZTJuurl6QEnqzJRn8ypfSc7USux7m6h7xZIg7cohLhOljnsjBWtwgpByMWvWzkO0mdnEY3SWfG3gwAL4H+xgDUxWM8QW45cQdlEv09vFEnxijUHiMTGFLxivLp13tBWO76S87z7kfj5i5flJj7daI57LyoDUeCGACU0VoFibaf5To0doTdDkoHOHRoXm4+EJWraVJ4Ds7QDbk+DbyQtdPgekRLpc8g2sjQ1pg9DWaX3y0a0r4zsA/Yd1bs+KTkH9jh/ruwgLzmm+RqM9n+MKClAnuNel5pMLNrqL7lJTegkrgd0nxN30CMzv8ZF62Kmvmcaj5ENlPByFuO4bgJYcuJFcH0GKBZP7EqW6fsS7i0hLhK9gNM0eIdKi1J+4btINqVsA1oz8hCafDKYNlQZ3riVPWLHUfmS1tJdMfZfjOWB6XLSjgK2AJ2HR/qIXT
Received: from wheely.local0.net ([118.208.150.76])
        by smtp.gmail.com with ESMTPSA id cb1-20020a056a02070100b005c1ce3c960bsm1101742pgb.50.2024.02.09.01.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Feb 2024 01:12:29 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v4 6/8] migration: Add quiet migration support
Date: Fri,  9 Feb 2024 19:11:32 +1000
Message-ID: <20240209091134.600228-7-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240209091134.600228-1-npiggin@gmail.com>
References: <20240209091134.600228-1-npiggin@gmail.com>
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
 lib/migrate.c         | 11 +++++++++++
 lib/migrate.h         |  1 +
 scripts/arch-run.bash |  4 ++--
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/lib/migrate.c b/lib/migrate.c
index b7721659..92d1d957 100644
--- a/lib/migrate.c
+++ b/lib/migrate.c
@@ -18,6 +18,17 @@ void migrate(void)
 	report_info("Migration complete");
 }
 
+/*
+ * Like migrate() but suppress output and logs, useful for intensive
+ * migration stress testing without polluting logs. Test cases should
+ * provide relevant information about migration in failure reports.
+ */
+void migrate_quiet(void)
+{
+	puts("Now migrate the VM (quiet)\n");
+	(void)getchar();
+}
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
index c98429e8..0a98e512 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -152,7 +152,7 @@ run_migration ()
 		-chardev socket,id=mon,path=${src_qmp},server=on,wait=off \
 		-mon chardev=mon,mode=control > ${src_outfifo} &
 	live_pid=$!
-	cat ${src_outfifo} | tee ${src_out} &
+	cat ${src_outfifo} | tee ${src_out} | grep -v "Now migrate the VM (quiet)" &
 
 	# Start the first destination QEMU machine in advance of the test
 	# reaching the migration point, since we expect at least one migration.
@@ -190,7 +190,7 @@ do_migration ()
 		-mon chardev=mon,mode=control -incoming unix:${dst_incoming} \
 		< <(cat ${dst_infifo}) > ${dst_outfifo} &
 	incoming_pid=$!
-	cat ${dst_outfifo} | tee ${dst_out} &
+	cat ${dst_outfifo} | tee ${dst_out} | grep -v "Now migrate the VM (quiet)" &
 
 	# The test must prompt the user to migrate, so wait for the
 	# "Now migrate VM" console message.
-- 
2.42.0


