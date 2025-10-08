Return-Path: <kvm+bounces-59662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 55043BC6DA2
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 01:26:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D41C1890AEB
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 23:26:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C099C2C2372;
	Wed,  8 Oct 2025 23:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iOoeywUn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC6F242D65
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 23:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759965962; cv=none; b=N35vZfLiCVvXi+PGsJ9EFV4PiubTzvViH7dc7E/SD6chD4CjKJeWIm2IacAfj7hzuC4Ynv3WGzY9KtQ/C4/MeBjWMEw0+au4LA1sbPuv0rxgKR8IHzsAGvrD7xNL24dHhuvOw2GIPGp15Aq2BbI1qlORaaltRCr6go+2XRNFwxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759965962; c=relaxed/simple;
	bh=IqkzlfAwNFQ5kaJxvUPbeQKmXMarGOsWF2kAW0H85kU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SLYxzwjkgqyfQsZSvJIl+d28jSCutyzowJv0zioR6sEqqJT4p4aF9TMRW89x/BT57djYXdBlh6se7c0djnJDUdCTLAN1UEZzbciQOvYlWeHH55QVycSYjeIoNruKnLgcyM4nEN/CN5IpI8Pjsk4+CM7BdXD55oizVxea1zHgs7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iOoeywUn; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-780d26fb6b4so361967b3a.0
        for <kvm@vger.kernel.org>; Wed, 08 Oct 2025 16:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759965960; x=1760570760; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7bNcoYjh20Sj/hNuR1vxsZQUEnF1Am9mlXqZLVeLPhI=;
        b=iOoeywUnlzfDr0kmqFAQ86tXcO7cTHOgV1WuVqQW9OXxp830RHvD1UW44mC1WayMEn
         UXPtqODGVCBBG4ulUS9cPQLH2ja9YlwwH4I1jsZGF6gmHkvLLRyuAz+73N6bK6qxL2Yx
         mSO3VM4B3vswgPDU6bOjFdVVry3pCyfvjENmbl9ROiziI4aYPUxB2TQUmakZB+JChq1P
         b3qjzy9L5z5trUyx68e/JqbFBSfbKUDTzVnfD60WSq8/hw65xUdf/BMIoSokaYgXFiqH
         Ro3rLnIQOkX3D8on+igQnvOJxmvCkJHvvkLsThL9A8gPH68caClYRZ4w+fnPnmUsJJbT
         HOPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759965960; x=1760570760;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7bNcoYjh20Sj/hNuR1vxsZQUEnF1Am9mlXqZLVeLPhI=;
        b=nXC6nJSuxnqWnahVlyZHkiSp1mv/qtMs2PMBRtIGHPY72w9Rk/n287nPcUhidk7o5T
         Ku/g4i5vHGneThILGIhvcy17GId0szRnIdbdK5ydB+vDPZ4JnPDYiU9v1Nib7Bpl73i+
         VKsIYhTJRbsUuSY68mpq93qkFbuxxZ4H9uC1LI2HwNIvSzTXfdY4q9picvpSQb3Uey+v
         bLl2KnDOgC5C/XFoKr7Ec8A0B1uhVbL+CIrkcz3sjx/MNGoEkWn08EoJOveC7wj4ca3k
         2qrgHgNCLp4qwwJEdhZ3C8etCy4ZcDvXiNHAfgQyIQKY2Kt2lOFtTTZESCdimHLzlHtB
         gvXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXL+cQt1eWx6n4Wz0T0UHCI9sHDGSSI0teS4BBviX3OsUce1HEonYwu6cfKleA0mxMb+fc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZWl18B7+ZPsOgqs/fMtRo8neq/VsJz4u2bXbKzGmPlVvIJmNd
	FO6KeYrZBoLplK7VHJvVZP/2wmd6W9YmmkRUg36rvb3g0bI/wyvzTffY6Z4L1Ub0GT73apBa2cn
	Eq8xSqgMqxwqyqQ==
X-Google-Smtp-Source: AGHT+IGi5b+QI+Yf1jjGy0nD2cOricdcAZcap68rgUqHcrtduNwkqwwWPCBnuj1uyFXd2rihxjUQ/HMiIYiX2Q==
X-Received: from pffz15.prod.google.com ([2002:aa7:990f:0:b0:77f:6432:dc09])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:114e:b0:781:9a6:116a with SMTP id d2e1a72fcca58-79385ce7b44mr5336872b3a.9.1759965959574;
 Wed, 08 Oct 2025 16:25:59 -0700 (PDT)
Date: Wed,  8 Oct 2025 23:25:21 +0000
In-Reply-To: <20251008232531.1152035-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251008232531.1152035-1-dmatlack@google.com>
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251008232531.1152035-3-dmatlack@google.com>
Subject: [PATCH 02/12] vfio: selftests: Allow passing multiple BDFs on the
 command line
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: David Matlack <dmatlack@google.com>, Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, 
	kvm@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add support for passing multiple device BDFs to a test via the command
line. This is a prerequisite for multi-device tests.

Single-device tests can continue using vfio_selftests_get_bdf(), which
will continue to return argv[argc - 1] (if it is a BDF string), or the
environment variable $VFIO_SELFTESTS_BDF otherwise.

For multi-device tests, a new helper called vfio_selftests_get_bdfs() is
introduced which will return an array of all BDFs found at the end of
argv[], as well as the number of BDFs found (passed back to the caller
via argument). The array of BDFs returned does not need to be freed by
the caller.

The environment variable VFIO_SELFTESTS_BDF continues to support only a
single BDF for the time being.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/vfio/lib/include/vfio_util.h    |  2 +
 .../selftests/vfio/lib/vfio_pci_device.c      | 58 +++++++++++++++----
 2 files changed, 48 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/vfio_util.h b/tools/testing/selftests/vfio/lib/include/vfio_util.h
index ed31606e01b7..2acf119cbedb 100644
--- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
+++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
@@ -198,6 +198,8 @@ struct vfio_pci_device {
  * If BDF cannot be determined then the test will exit with KSFT_SKIP.
  */
 const char *vfio_selftests_get_bdf(int *argc, char *argv[]);
+char **vfio_selftests_get_bdfs(int *argc, char *argv[], int *nr_bdfs);
+
 const char *vfio_pci_get_cdev_path(const char *bdf);
 
 extern const char *default_iommu_mode;
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index 0921b2451ba5..f2fc5a52902b 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -566,29 +566,63 @@ static bool is_bdf(const char *str)
 	return count == 4 && length == strlen(str);
 }
 
-const char *vfio_selftests_get_bdf(int *argc, char *argv[])
+static char **vfio_selftests_get_bdfs_cmdline(int *argc, char *argv[], int *nr_bdfs)
 {
-	char *bdf;
+	int i;
+
+	for (i = *argc - 1; i > 0 && is_bdf(argv[i]); i--)
+		continue;
+
+	i++;
+	*nr_bdfs = *argc - i;
+	*argc -= *nr_bdfs;
+
+	return *nr_bdfs ? &argv[i] : NULL;
+}
 
-	if (*argc > 1 && is_bdf(argv[*argc - 1]))
-		return argv[--(*argc)];
+static char **vfio_selftests_get_bdfs_env(int *argc, char *argv[], int *nr_bdfs)
+{
+	static char *bdf;
 
 	bdf = getenv("VFIO_SELFTESTS_BDF");
-	if (bdf) {
-		VFIO_ASSERT_TRUE(is_bdf(bdf), "Invalid BDF: %s\n", bdf);
-		return bdf;
-	}
+	if (!bdf)
+		return NULL;
+
+	*nr_bdfs = 1;
+	VFIO_ASSERT_TRUE(is_bdf(bdf), "Invalid BDF: %s\n", bdf);
+
+	return &bdf;
+}
+
+char **vfio_selftests_get_bdfs(int *argc, char *argv[], int *nr_bdfs)
+{
+	char **bdfs;
+
+	bdfs = vfio_selftests_get_bdfs_cmdline(argc, argv, nr_bdfs);
+	if (bdfs)
+		return bdfs;
+
+	bdfs = vfio_selftests_get_bdfs_env(argc, argv, nr_bdfs);
+	if (bdfs)
+		return bdfs;
 
-	fprintf(stderr, "Unable to determine which device to use, skipping test.\n");
+	fprintf(stderr, "Unable to determine which device(s) to use, skipping test.\n");
 	fprintf(stderr, "\n");
 	fprintf(stderr, "To pass the device address via environment variable:\n");
 	fprintf(stderr, "\n");
-	fprintf(stderr, "    export VFIO_SELFTESTS_BDF=segment:bus:device.function\n");
+	fprintf(stderr, "    export VFIO_SELFTESTS_BDF=\"segment:bus:device.function\"\n");
 	fprintf(stderr, "    %s [options]\n", argv[0]);
 	fprintf(stderr, "\n");
-	fprintf(stderr, "To pass the device address via argv:\n");
+	fprintf(stderr, "To pass the device address(es) via argv:\n");
 	fprintf(stderr, "\n");
-	fprintf(stderr, "    %s [options] segment:bus:device.function\n", argv[0]);
+	fprintf(stderr, "    %s [options] segment:bus:device.function ...\n", argv[0]);
 	fprintf(stderr, "\n");
 	exit(KSFT_SKIP);
 }
+
+const char *vfio_selftests_get_bdf(int *argc, char *argv[])
+{
+	int nr_bdfs;
+
+	return vfio_selftests_get_bdfs(argc, argv, &nr_bdfs)[0];
+}
-- 
2.51.0.710.ga91ca5db03-goog


