Return-Path: <kvm+bounces-9142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A81185B60C
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 09:54:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 083CA2843AA
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 08:54:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AF706217F;
	Tue, 20 Feb 2024 08:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KLtS+PG6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9ECC62158
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 08:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708419119; cv=none; b=n27k1MfmxBByucIf2twXxLcXchFeI22rAlLemMPWGOFjX8q+dzdCBP1JPjgIvE3jAIcTprQ3vE61OgHL/2g1P3iFK9vuP1VOwm88j6UviTEhBdJCNm0D21pf/EfAaYmvIZUiJRaCt2Y7HrfLWP8yxOAPCX759irZnXrvVhtFRBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708419119; c=relaxed/simple;
	bh=6UsEcVg9fs955dIXXCf2kt0xbeMG9Ov3y7WZ6RkN4uU=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=Qhx6NoHKdW7j3LUntSKcmMsbUxj7TzZTeFtA0+RCmxkdmT+zu7ggjqNMdKFBLlHf69B2vVwJt+yqniOg5Rm+0tWx8VTIAxEdLiMvmjKKajRchFytGJy9Hbpqbvi6z+1NNWPpOaGnTtSoh0vvPo5hEDG4pgK0jmyd5Ce5LA2ZXdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KLtS+PG6; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1dba6b9b060so24909235ad.1
        for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 00:51:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708419117; x=1709023917; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RHRw7NfUQxOmzf6TUbuN67SVbSWk7iT5PJ4EhCUmtMI=;
        b=KLtS+PG6qf7Rop1f9IoPrCLydLMzqiAJD7tpD54/Jp1A56K/X45KwKtSrpLBv6n/yl
         9xflvCl494I2YZYt6X/KsSdimzGCtvIZnK8qOtjUBP7uly0SmoXdQAuZ/1Cpn/sYBaQ+
         t9Vu88hvjTq0ArtJuv9leyytm6oTp4oxg8vDoyGG+nr5Ad2gWDqK760ew32jcAbKVlV1
         OJzqoUD49lWvZq6XNITFafOQ5CFYW0kTNZXeDrSLDw7qRVXsZfORjH3EMrDUbAnOTBdC
         1QizysSsmFg+hXWH1xyJUfF5dyTOsXlgMEbpHW+O+nzL+jGGpSZM+M7d/6DnnYgONpB1
         pMRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708419117; x=1709023917;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RHRw7NfUQxOmzf6TUbuN67SVbSWk7iT5PJ4EhCUmtMI=;
        b=OPlLBU7M9KFwchqWzofSSB3EtVcpepFl0JAXLtJS5MwS2+Rfgf0zM/zTE9ZMr6vnga
         hXryjiXMz1TWhJuUgiEibwqI99GPBKfCG5ak/gc8FHQ1Gz26Xw9cKnk7JDBhMGRs82CS
         EWzyJdYVVVJDPzBTlILYoG4pQSsbhDkwfbaLa5Bz2jUqZIfUkQLL5jQdjspBvOeDdwzO
         IuFxedJscRdHf4mIEoUjY6fzJpgQYcDgdQKcGYALPU8PnAvbUwL2B01UZOV7jWJbbL1C
         HH0ngaMlBmfUvFwh3iXl8eCMmQfxNzS8yIU8HeAKg/hduzSvRxMl/6ne7igG2kFS63hL
         zhjg==
X-Forwarded-Encrypted: i=1; AJvYcCUGI+ggtmXi1yfr0uJgInAK5WlgyOFIASEX+b6bIjk/eZ2b40t7haw7/RhZTy8YqgUYOdOJU7abacRHjxqJmSmp15Ck
X-Gm-Message-State: AOJu0Yzif8sPZVo28ajaV+kmqXkGrRpBZZkw4uubc4zALB9Ye+sD8mxX
	7cAqOPRoMEn1rWOO3pVdShutnpmSPomy3zMyQfoUT/yyiIDBGY7M
X-Google-Smtp-Source: AGHT+IHCOTgBz8F34jaXArxWnHGtuhxxlqEqR4+fUf3AafBkZCORlDzDbK6ysUpJFvEkQMWPuP1vtQ==
X-Received: by 2002:a17:903:58d:b0:1db:a7bb:492d with SMTP id jv13-20020a170903058d00b001dba7bb492dmr13463979plb.5.1708419117076;
        Tue, 20 Feb 2024 00:51:57 -0800 (PST)
Received: from localhost (123-243-155-241.static.tpgi.com.au. [123.243.155.241])
        by smtp.gmail.com with ESMTPSA id b15-20020a170902d50f00b001d9aa663282sm5686547plg.266.2024.02.20.00.51.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Feb 2024 00:51:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 20 Feb 2024 18:51:51 +1000
Message-Id: <CZ9S150A3M1Y.1HVL51OVY2ZW8@wheely>
Cc: "Andrew Jones" <andrew.jones@linux.dev>, "Eric Auger"
 <eric.auger@redhat.com>, <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>
Subject: Re: [kvm-unit-tests PATCH] lib/arm/io: Fix calling getchar()
 multiple times
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Alexandru Elisei" <alexandru.elisei@arm.com>, "Thomas Huth"
 <thuth@redhat.com>
X-Mailer: aerc 0.15.2
References: <20240216140210.70280-1-thuth@redhat.com>
 <ZdOIJfvVm7C23ZdZ@raptor>
In-Reply-To: <ZdOIJfvVm7C23ZdZ@raptor>

On Tue Feb 20, 2024 at 2:56 AM AEST, Alexandru Elisei wrote:
> Hi,
>
> Thanks for writing this. I've tested it with kvmtool, which emulates a 82=
50
> UART:
>
> Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
>
> This fixes a longstanding bug with kvmtool, where migrate_once() would re=
ad
> the last character that was sent, and then think that migration was
> completed even though it was never performed.
>
> While we are on the subject of migration:
>
> SKIP: gicv3: its-migration: Test requires at least 4 vcpus
> Now migrate the VM, then press a key to continue...
> INFO: gicv3: its-migration: Migration complete
> SUMMARY: 1 tests, 1 skipped
>
> That's extremely confusing. Why is migrate_once() executed after the
> test_its_pending() function call without checking if the test was skipped=
?

Seems not too hard, incremental patch on top of multi migration
series below. After this series is merged I can try that (s390
could benefit with some changes too).

Thanks,
Nick

---
diff --git a/arm/gic.c b/arm/gic.c
index c950b0d15..bbf828f17 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -782,13 +782,15 @@ static void test_its_migration(void)
 	struct its_device *dev2, *dev7;
 	cpumask_t mask;
=20
-	if (its_setup1())
+	if (its_setup1()) {
+		migrate_skip();
 		return;
+	}
=20
 	dev2 =3D its_get_device(2);
 	dev7 =3D its_get_device(7);
=20
-	migrate_once();
+	migrate();
=20
 	stats_reset();
 	cpumask_clear(&mask);
@@ -819,8 +821,10 @@ static void test_migrate_unmapped_collection(void)
 	int pe0 =3D 0;
 	u8 config;
=20
-	if (its_setup1())
+	if (its_setup1()) {
+		migrate_skip();
 		return;
+	}
=20
 	if (!errata(ERRATA_UNMAPPED_COLLECTIONS)) {
 		report_skip("Skipping test, as this test hangs without the fix. "
@@ -836,7 +840,7 @@ static void test_migrate_unmapped_collection(void)
 	its_send_mapti(dev2, 8192, 0, col);
 	gicv3_lpi_set_config(8192, LPI_PROP_DEFAULT);
=20
-	migrate_once();
+	migrate();
=20
 	/* on the destination, map the collection */
 	its_send_mapc(col, true);
@@ -875,8 +879,10 @@ static void test_its_pending_migration(void)
 	void *ptr;
 	int i;
=20
-	if (its_prerequisites(4))
+	if (its_prerequisites(4)) {
+		migrate_skip();
 		return;
+	}
=20
 	dev =3D its_create_device(2 /* dev id */, 8 /* nb_ites */);
 	its_send_mapd(dev, true);
@@ -923,7 +929,7 @@ static void test_its_pending_migration(void)
 	gicv3_lpi_rdist_enable(pe0);
 	gicv3_lpi_rdist_enable(pe1);
=20
-	migrate_once();
+	migrate();
=20
 	/* let's wait for the 256 LPIs to be handled */
 	mdelay(1000);
@@ -970,17 +976,14 @@ int main(int argc, char **argv)
 	} else if (!strcmp(argv[1], "its-migration")) {
 		report_prefix_push(argv[1]);
 		test_its_migration();
-		migrate_once();
 		report_prefix_pop();
 	} else if (!strcmp(argv[1], "its-pending-migration")) {
 		report_prefix_push(argv[1]);
 		test_its_pending_migration();
-		migrate_once();
 		report_prefix_pop();
 	} else if (!strcmp(argv[1], "its-migrate-unmapped-collection")) {
 		report_prefix_push(argv[1]);
 		test_migrate_unmapped_collection();
-		migrate_once();
 		report_prefix_pop();
 	} else if (strcmp(argv[1], "its-introspection") =3D=3D 0) {
 		report_prefix_push(argv[1]);
diff --git a/lib/migrate.c b/lib/migrate.c
index 92d1d957d..dde43a90e 100644
--- a/lib/migrate.c
+++ b/lib/migrate.c
@@ -43,3 +43,13 @@ void migrate_once(void)
 	migrated =3D true;
 	migrate();
 }
+
+/*
+ * When the test has been started in migration mode, but the test case is
+ * skipped and no migration point is reached, this can be used to tell the
+ * harness not to mark it as a failure to migrate.
+ */
+void migrate_skip(void)
+{
+	puts("Skipped VM migration (quiet)\n");
+}
diff --git a/lib/migrate.h b/lib/migrate.h
index 95b9102b0..db6e0c501 100644
--- a/lib/migrate.h
+++ b/lib/migrate.h
@@ -9,3 +9,5 @@
 void migrate(void);
 void migrate_quiet(void);
 void migrate_once(void);
+
+void migrate_skip(void);
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 2214d940c..3257d5218 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -152,7 +152,9 @@ run_migration ()
 		-chardev socket,id=3Dmon,path=3D${src_qmp},server=3Don,wait=3Doff \
 		-mon chardev=3Dmon,mode=3Dcontrol > ${src_outfifo} &
 	live_pid=3D$!
-	cat ${src_outfifo} | tee ${src_out} | grep -v "Now migrate the VM (quiet)=
" &
+	cat ${src_outfifo} | tee ${src_out} | \
+		grep -v "Now migrate the VM (quiet)" | \
+		grep -v "Skipped VM migration (quiet)" &
=20
 	# Start the first destination QEMU machine in advance of the test
 	# reaching the migration point, since we expect at least one migration.
@@ -190,16 +192,22 @@ do_migration ()
 		-mon chardev=3Dmon,mode=3Dcontrol -incoming unix:${dst_incoming} \
 		< <(cat ${dst_infifo}) > ${dst_outfifo} &
 	incoming_pid=3D$!
-	cat ${dst_outfifo} | tee ${dst_out} | grep -v "Now migrate the VM (quiet)=
" &
+	cat ${dst_outfifo} | tee ${dst_out} | \
+		grep -v "Now migrate the VM (quiet)" | \
+		grep -v "Skipped VM migration (quiet)" &
=20
 	# The test must prompt the user to migrate, so wait for the
 	# "Now migrate VM" console message.
 	while ! grep -q -i "Now migrate the VM" < ${src_out} ; do
 		if ! ps -p ${live_pid} > /dev/null ; then
-			echo "ERROR: Test exit before migration point." >&2
 			echo > ${dst_infifo}
-			qmp ${src_qmp} '"quit"'> ${src_qmpout} 2>/dev/null
 			qmp ${dst_qmp} '"quit"'> ${dst_qmpout} 2>/dev/null
+			if grep -q -i "Skipped VM migration" < ${src_out} ; then
+				wait ${live_pid}
+				return $?
+			fi
+			echo "ERROR: Test exit before migration point." >&2
+			qmp ${src_qmp} '"quit"'> ${src_qmpout} 2>/dev/null
 			return 3
 		fi
 		sleep 0.1

