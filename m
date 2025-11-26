Return-Path: <kvm+bounces-64780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id D31E9C8C505
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 00:18:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 41CCB35044E
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 23:18:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 024D0342CB1;
	Wed, 26 Nov 2025 23:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rLcrkCNb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D45304BDC
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 23:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764199069; cv=none; b=aDBClYzhwyKinNJyoEKh69wPbwwBmdxkyU845dCUuxV6Tz3Ce3oiv3Ld6DitKKerc22KhDTgCO0mwNr2uk6ISUPKCMnCYWQOFNFhRqgrnASa9xEBNMdZ8+zxvPs1jmuQRxMsYLzCS6aTkjT6O07wktxK6cE1FOLZCFMb9GszoRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764199069; c=relaxed/simple;
	bh=AvSFNKiKL+c7A+jWVKE0Bg18iz3X2ZUYRCg6aF1PgR4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qKGiiUbpWiepB+Uj2V0oeenwSgO5F/DV1931eU181yUJFh9y0jnx7yvi/Q+wNBFXKIx/+L1fUH6yAH5VG1PD9yYdb2Dhd2Dg9Wpw0vQkdjUonWo702e0doL597lbT37tYlVJpiZ9jkkVoslPoQ9AwZQhSTM2dBZk/zM4bnkeLWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rLcrkCNb; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7be3d08f863so340336b3a.2
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 15:17:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764199067; x=1764803867; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2NmqlILt/SIZo48TbaGQlmIwJAUYztjRVDmwIOHsj6Y=;
        b=rLcrkCNb0Qi94JuYAhH244e6Kr3e44p9lGcPro1K2c8iiX0iL88o6qtJqIFYFm1wDh
         s0C8h8TJHWYh+W5UPgVSkYasPPrPBVSv7yobkQwhE6oN+thUELA8URoZ0Qq1UjL9zyNC
         uEZ9mrI0TEXEAZ7Zxtl9zemUkdw2RFRt4NkxHLA7OrJhqb+GXbTbCxvHyiFeOTnZ967p
         GC6N/lTtKx6nEdvC2NVtzoyD2sJKvrwA9KYl4SzfUENpYNf0egcoBWGon5GqsjaEzxgJ
         P/PgQegCfv31AYb4rx2r4NjLq6nYoY/pU2L5+I+E7vWtRJzM6kd4jFHRiEjj6wExMRjI
         F0HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764199067; x=1764803867;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2NmqlILt/SIZo48TbaGQlmIwJAUYztjRVDmwIOHsj6Y=;
        b=gwrXNCGZ1vi4eRnLoEy/SW+UAAl13cLnbiMra2AfNJOERIoj49hyupK4n1W3kMCggC
         qXQ9+4ukvbY82vEvR8WkGrf31Rz1nptO9iGmAovuXTRi2piRq6SmpoW3uTeq/CtZORdc
         ZYN2v4kMtSqlmLkBFye2NcU+fKCJ/idZDdE/WBQd2nAHfJqbjT2hFd2qNAC4W03Dr5Rj
         brtnw47417U1LiDVY/hwHF6i9fO8GkWEIMO8bAulrXxbNrMFoQQPO2oEjuYuwrbUL6IG
         LhjHv8gnVbBiFlWRmjR/hsF31vMYf+wTQLEWGBtTkAuu/hBALOLdckTHAlzNoKhpkqtb
         zYdQ==
X-Forwarded-Encrypted: i=1; AJvYcCWv2cZMbnFhKOXnxyPqxDDS853x8HlBtOigP9eGrBiUc6AbyCEFGZZ5qCQ2kTVzIepNpT0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/mRr+WhA/v7JCFC45htc4RH51NbxaSVoiJsGzdHmsPoE93x+W
	CgQ67bpQA/Dmdh1IMR/oWDoOFx8FffrA4b9PibaXcUMzLKFfFKwgh9EnZRx7h6QrZb/x0jELgA9
	152rJxgoEdCHTNA==
X-Google-Smtp-Source: AGHT+IFe/Mo3B5TgFhtPN43rvpR/V3Sb3frYIJR1W12Kqz3wnQ9iJPaORUJ41nbeEG+8jvATbp+GIwQQjnw/uw==
X-Received: from pfbhj14.prod.google.com ([2002:a05:6a00:870e:b0:77d:4a42:1179])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:390d:b0:7aa:9e4d:b693 with SMTP id d2e1a72fcca58-7c58e113a8amr24159761b3a.17.1764199066615;
 Wed, 26 Nov 2025 15:17:46 -0800 (PST)
Date: Wed, 26 Nov 2025 23:17:18 +0000
In-Reply-To: <20251126231733.3302983-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251126231733.3302983-1-dmatlack@google.com>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
Message-ID: <20251126231733.3302983-4-dmatlack@google.com>
Subject: [PATCH v4 03/18] vfio: selftests: Allow passing multiple BDFs on the
 command line
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Alex Mastro <amastro@fb.com>, David Matlack <dmatlack@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Raghavendra Rao Ananta <rananta@google.com>, Vipin Sharma <vipinsh@google.com>
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

Reviewed-by: Alex Mastro <amastro@fb.com>
Tested-by: Alex Mastro <amastro@fb.com>
Reviewed-by: Raghavendra Rao Ananta <rananta@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/vfio/lib/include/vfio_util.h    |  2 +
 .../selftests/vfio/lib/vfio_pci_device.c      | 57 +++++++++++++++----
 2 files changed, 48 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/vfio_util.h b/tools/testing/selftests/vfio/lib/include/vfio_util.h
index 69ec0c856481..0b9a5628d23e 100644
--- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
+++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
@@ -208,6 +208,8 @@ struct iova_allocator {
  * If BDF cannot be determined then the test will exit with KSFT_SKIP.
  */
 const char *vfio_selftests_get_bdf(int *argc, char *argv[]);
+char **vfio_selftests_get_bdfs(int *argc, char *argv[], int *nr_bdfs);
+
 const char *vfio_pci_get_cdev_path(const char *bdf);
 
 extern const char *default_iommu_mode;
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index b479a359da12..eda8f14de797 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -868,29 +868,64 @@ static bool is_bdf(const char *str)
 	return count == 4 && length == strlen(str);
 }
 
-const char *vfio_selftests_get_bdf(int *argc, char *argv[])
+static char **get_bdfs_cmdline(int *argc, char *argv[], int *nr_bdfs)
 {
-	char *bdf;
+	int i;
 
-	if (*argc > 1 && is_bdf(argv[*argc - 1]))
-		return argv[--(*argc)];
+	for (i = *argc - 1; i > 0 && is_bdf(argv[i]); i--)
+		continue;
+
+	i++;
+	*nr_bdfs = *argc - i;
+	*argc -= *nr_bdfs;
+
+	return *nr_bdfs ? &argv[i] : NULL;
+}
+
+static char *get_bdf_env(void)
+{
+	char *bdf;
 
 	bdf = getenv("VFIO_SELFTESTS_BDF");
-	if (bdf) {
-		VFIO_ASSERT_TRUE(is_bdf(bdf), "Invalid BDF: %s\n", bdf);
-		return bdf;
+	if (!bdf)
+		return NULL;
+
+	VFIO_ASSERT_TRUE(is_bdf(bdf), "Invalid BDF: %s\n", bdf);
+	return bdf;
+}
+
+char **vfio_selftests_get_bdfs(int *argc, char *argv[], int *nr_bdfs)
+{
+	static char *env_bdf;
+	char **bdfs;
+
+	bdfs = get_bdfs_cmdline(argc, argv, nr_bdfs);
+	if (bdfs)
+		return bdfs;
+
+	env_bdf = get_bdf_env();
+	if (env_bdf) {
+		*nr_bdfs = 1;
+		return &env_bdf;
 	}
 
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
2.52.0.487.g5c8c507ade-goog


