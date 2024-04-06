Return-Path: <kvm+bounces-13796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E00BE89AABA
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 14:25:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F6361F218E2
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 12:25:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0F682D05E;
	Sat,  6 Apr 2024 12:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ilL4JOsm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BFD1EB48;
	Sat,  6 Apr 2024 12:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712406321; cv=none; b=reoaqVj6ppNOtVfIJ1ln6sspgOgVQJ31lNiA4qEwXFb1Q6/CCkP2a+KVWPbOuQbwKMM0k27K5DM5YJFmFpZgo3dTnWWCCaJMF74LKRly4DWGTCG97dKflGnXSwdFW7CvjDwneRLh1ss4l5cqjThq4iuFHJ1e8OTr4fvZFbh9d+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712406321; c=relaxed/simple;
	bh=BxWK7NEwn5ck4UeEMX33/rVqqkBLkS9af6vrGYtg1oA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sWseJGLEIrM2Wnnokg9U1ii0u9MGQjYJRZZ07UUG2XD5I++Ig95s8FyVQjjoI1dhvVVFpiLW5WA2Dl2WYX4UbySrNQULEvMpaNZ8YlmEwzX0Bsfm+Dn5glzYoP+qMwuNVtxkna40K2CCwCIgv4QvGngwQHgbJUsXD42dXF00rDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ilL4JOsm; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6ecee5c08e6so2784018b3a.3;
        Sat, 06 Apr 2024 05:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712406319; x=1713011119; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XSK5UQTlMV1ztZkWhZqfur2IVdnbon/itN8WGbHBLUI=;
        b=ilL4JOsmSMYi3vjJUMuiQDcNoOcEEuca4/Iw4oZFKyYx9pAEuQ2YazHbJlXqvO5bgt
         CLb1rIkmsbWlreU6STze1i2b23bvLaHJiMPeolGaa1YfNqTc6QKk2g8oi50G5tPWuDeW
         Y1NDGDA5FwEHA/UBJd8nqZVVLsvXBf8+Fik7YboSsSDDKJCdKsY7boPJJC++Y6LcbTrF
         q+PBkwMjbIDbxghTCZJrkVF5vophNazCEf7NIqHmYdYzycxYIwg7zPruekDHQ5hB7ytA
         RpEezFXzUJkTRXXngedZAddxT9Nso2OzErRbx8zxXQbwtmowRJbg8fUD5Q2ZG2fnpCDr
         GL1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712406319; x=1713011119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XSK5UQTlMV1ztZkWhZqfur2IVdnbon/itN8WGbHBLUI=;
        b=LzhXe+FknQpIY62rOIbIaF9tFq188EMGgiulgSwadwKKKERRt2Sk7fib5ovKmfYdbd
         UeUMNIjJW0bXMaf2N38U/VIp4rvQcIAi1oovc2YRjIMwkF2fPtDwBYymxL2icLKgUegg
         aJ/iB8iSztKv2lzG3kkifLRGSHy6r1RA8kVggmiAilIgdXM6h4PrjrTVqtWL2cPH61yD
         fl4t950E7W2rkDQaKiqQ05eL94K/ogHOaP8coEbxYfghVImZU/HGTX6rtNeMsCrbOIR7
         vGxnxZOmZS+QBsI1LajqA9dqVwN778dKEDBGG6bUackq7raSh0GGmhYC8RPRnrwkMzkO
         gvOw==
X-Forwarded-Encrypted: i=1; AJvYcCWcBHiRmiBbK/WUADAUokudtyaKFsapmKmqB4LMKArS61r5bI20S4YXHX/7ioe2e0N0wkudI23vwmCQ0KfKxncCFGDobK7jKKdtNKT/HtHNY18dZF78k3jaHdZqd8VNXA==
X-Gm-Message-State: AOJu0Yxr+4QVoiILZiJA4ioogR3d4zo+mYltaCnZeyFj6sAFHUB6Oiij
	dmFOztGhP1asoGFKV1qTp43MTTccdmBB9DnjrW5YNQhmIrKhZOOx
X-Google-Smtp-Source: AGHT+IHH9djoXOEB0pvV/E3DdN1MJ+EuiicIYZd2KCoHyCuZheUsRvIoq2ET5GfONXO6xOufxIcdyw==
X-Received: by 2002:a05:6a00:2355:b0:6e6:9c79:87e9 with SMTP id j21-20020a056a00235500b006e69c7987e9mr4877242pfj.34.1712406318770;
        Sat, 06 Apr 2024 05:25:18 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id g14-20020aa7874e000000b006e69a142458sm3091392pfo.213.2024.04.06.05.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 05:25:18 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linux-s390@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 2/2] s390x: Fix is_pv check in run script
Date: Sat,  6 Apr 2024 22:24:54 +1000
Message-ID: <20240406122456.405139-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240406122456.405139-1-npiggin@gmail.com>
References: <20240406122456.405139-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Shellcheck reports "is_pv references arguments, but none are ever
passed." and suggests "use is_pv "$@" if function's $1 should mean
script's $1."

The is_pv test does not evaluate to true for .pv.bin file names, only
for _PV suffix test names. The arch_cmd_s390x() function appends
.pv.bin to the file name AND _PV to the test name, so this does not
affect run_tests.sh runs, but it might prevent PV tests from being
run directly with the s390x-run command.

Reported-by: shellcheck SC2119, SC2120
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 s390x/run | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/s390x/run b/s390x/run
index e58fa4af9..34552c274 100755
--- a/s390x/run
+++ b/s390x/run
@@ -21,12 +21,12 @@ is_pv() {
 	return 1
 }
 
-if is_pv && [ "$ACCEL" = "tcg" ]; then
+if is_pv "$@" && [ "$ACCEL" = "tcg" ]; then
 	echo "Protected Virtualization isn't supported under TCG"
 	exit 2
 fi
 
-if is_pv && [ "$MIGRATION" = "yes" ]; then
+if is_pv "$@" && [ "$MIGRATION" = "yes" ]; then
 	echo "Migration isn't supported under Protected Virtualization"
 	exit 2
 fi
@@ -34,12 +34,12 @@ fi
 M='-machine s390-ccw-virtio'
 M+=",accel=$ACCEL$ACCEL_PROPS"
 
-if is_pv; then
+if is_pv "$@"; then
 	M+=",confidential-guest-support=pv0"
 fi
 
 command="$qemu -nodefaults -nographic $M"
-if is_pv; then
+if is_pv "$@"; then
 	command+=" -object s390-pv-guest,id=pv0"
 fi
 command+=" -chardev stdio,id=con0 -device sclpconsole,chardev=con0"
-- 
2.43.0


