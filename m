Return-Path: <kvm+bounces-3206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A524801899
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 01:06:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 574D0281EC0
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 00:06:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FA327495;
	Sat,  2 Dec 2023 00:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a0yc4Rex"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDCA1992
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 16:05:03 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5d0c4ba7081so49002937b3.0
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 16:05:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701475503; x=1702080303; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=o4Hn9d5ofhE1GJj3G12PpMWX7+kcX8n0WNzzYeEBc4A=;
        b=a0yc4Rex3MoouOFIWOZKCcYuyd/kTZjnFweVpGCdVLO3DFs3lJA/0j7EtoPQc4aNoU
         mNO/ISX6b2dXzXjaxZImfkxF87+vcwrzeYQYQNFe0qzy93uAC76LLIEcDO8hui0ktkDX
         Hs/LrlIN9T9aynAkhHfrWfl+0YtaK5ew0xFJ9LPevm2d18p8Rbl0NgAVicMnkS+0D16v
         VIoEWC5umWUUAb5sofokEMO/KIgLRXcipArwLDvh3Fhm9f6oS4WDcQT9LSQAw8IPMFfp
         mySjVlrA6c3oMzhT7Yr+wkYaIGDq8pmbatcZFEfLvJQzN59A9urDZWxLeUmJn3q1zxcT
         PjqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701475503; x=1702080303;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o4Hn9d5ofhE1GJj3G12PpMWX7+kcX8n0WNzzYeEBc4A=;
        b=RGC8PtbvWKRFZWyAPAbOoJTMGlfwr34MjgEKw+2lhZZfuS4VQ/6QWnDjJY4UKxNduO
         zt9W70AYXpWKIe6NO7TYsTx5pQ7MaFCZZpDuhDKpsdT3Pl4nmOzZshC/ufeNwhfGNFu6
         x+wEj8Eo1O8A1/4nauGaavwXvfUuOzPkyjO++pCRMtrnDvpHh0LY8svZEOHTDuKHR/Sm
         uWTuMFkSHyHaxJcE/ACu2CXol4pUoRw/U4B+7W4WK0EFoTOO7bSwrCWR6ailmit/TY5L
         +2TWSjvymeU2IeX4iNlv8QjNlaGFBhS2JRQ9Tye7uCeipOZAeaAC58/be1Iz8wOc+Xea
         hggQ==
X-Gm-Message-State: AOJu0YysgtmOh/iwyOdrF0BhD43ssOxECOhjLSegK6wE2QHPqsIfnMmh
	VXTphyBHz/mU1y6NFSuqDP/vPZosZ4k=
X-Google-Smtp-Source: AGHT+IEfYD8/aO1YsOS7xpxy1hILfZ6VtNdznm5JECRIumWrla/+fgq7Hq6T/EEWs8LHFWYupYqlfXK5Ptw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:57d4:0:b0:5d3:a348:b0bd with SMTP id
 l203-20020a8157d4000000b005d3a348b0bdmr197529ywb.6.1701475502927; Fri, 01 Dec
 2023 16:05:02 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Dec 2023 16:04:11 -0800
In-Reply-To: <20231202000417.922113-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231202000417.922113-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231202000417.922113-23-seanjc@google.com>
Subject: [PATCH v9 22/28] KVM: selftests: Add helpers to read integer module params
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Add helpers to read integer module params, which is painfully non-trivial
because the pain of dealing with strings in C is exacerbated by the kernel
inserting a newline.

Don't bother differentiating between int, uint, short, etc.  They all fit
in an int, and KVM (thankfully) doesn't have any integer params larger
than an int.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  4 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 62 +++++++++++++++++--
 2 files changed, 60 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index e0da036a13ae..4293af2cb28c 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -257,6 +257,10 @@ bool get_kvm_param_bool(const char *param);
 bool get_kvm_intel_param_bool(const char *param);
 bool get_kvm_amd_param_bool(const char *param);
 
+int get_kvm_param_integer(const char *param);
+int get_kvm_intel_param_integer(const char *param);
+int get_kvm_amd_param_integer(const char *param);
+
 unsigned int kvm_check_cap(long cap);
 
 static inline bool kvm_has_cap(long cap)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 17a978b8a2c4..878bdbc8e618 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -51,13 +51,13 @@ int open_kvm_dev_path_or_exit(void)
 	return _open_kvm_dev_path_or_exit(O_RDONLY);
 }
 
-static bool get_module_param_bool(const char *module_name, const char *param)
+static ssize_t get_module_param(const char *module_name, const char *param,
+				void *buffer, size_t buffer_size)
 {
 	const int path_size = 128;
 	char path[path_size];
-	char value;
-	ssize_t r;
-	int fd;
+	ssize_t bytes_read;
+	int fd, r;
 
 	r = snprintf(path, path_size, "/sys/module/%s/parameters/%s",
 		     module_name, param);
@@ -66,11 +66,46 @@ static bool get_module_param_bool(const char *module_name, const char *param)
 
 	fd = open_path_or_exit(path, O_RDONLY);
 
-	r = read(fd, &value, 1);
-	TEST_ASSERT(r == 1, "read(%s) failed", path);
+	bytes_read = read(fd, buffer, buffer_size);
+	TEST_ASSERT(bytes_read > 0, "read(%s) returned %ld, wanted %ld bytes",
+		    path, bytes_read, buffer_size);
 
 	r = close(fd);
 	TEST_ASSERT(!r, "close(%s) failed", path);
+	return bytes_read;
+}
+
+static int get_module_param_integer(const char *module_name, const char *param)
+{
+	/*
+	 * 16 bytes to hold a 64-bit value (1 byte per char), 1 byte for the
+	 * NUL char, and 1 byte because the kernel sucks and inserts a newline
+	 * at the end.
+	 */
+	char value[16 + 1 + 1];
+	ssize_t r;
+
+	memset(value, '\0', sizeof(value));
+
+	r = get_module_param(module_name, param, value, sizeof(value));
+	TEST_ASSERT(value[r - 1] == '\n',
+		    "Expected trailing newline, got char '%c'", value[r - 1]);
+
+	/*
+	 * Squash the newline, otherwise atoi_paranoid() will complain about
+	 * trailing non-NUL characters in the string.
+	 */
+	value[r - 1] = '\0';
+	return atoi_paranoid(value);
+}
+
+static bool get_module_param_bool(const char *module_name, const char *param)
+{
+	char value;
+	ssize_t r;
+
+	r = get_module_param(module_name, param, &value, sizeof(value));
+	TEST_ASSERT_EQ(r, 1);
 
 	if (value == 'Y')
 		return true;
@@ -95,6 +130,21 @@ bool get_kvm_amd_param_bool(const char *param)
 	return get_module_param_bool("kvm_amd", param);
 }
 
+int get_kvm_param_integer(const char *param)
+{
+	return get_module_param_integer("kvm", param);
+}
+
+int get_kvm_intel_param_integer(const char *param)
+{
+	return get_module_param_integer("kvm_intel", param);
+}
+
+int get_kvm_amd_param_integer(const char *param)
+{
+	return get_module_param_integer("kvm_amd", param);
+}
+
 /*
  * Capability
  *
-- 
2.43.0.rc2.451.g8631bc7472-goog


