Return-Path: <kvm+bounces-9833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 93094867104
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:30:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A7731C22898
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:30:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69E9A5F870;
	Mon, 26 Feb 2024 10:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VZSR87Ng"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A535F865;
	Mon, 26 Feb 2024 10:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942480; cv=none; b=l8LVnSe7zgXipx7DyNJy4WJR/+Blq5lvU7G1mdZXR+Xvm4YTHKfzADDL6OheUs3ao1f8d7N1LgIEcz99tOyRUxf41IptWy101S7RL4tFFu9RCkZ2zS+kJDdQnk4CHjcnFKyBgcLkvVEkErjAKPHqrHZ1M4u0r9XcpuPTSqx0Fv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942480; c=relaxed/simple;
	bh=GAb9oUO2ju1Qbzt1QBLKzdmcnTJ529at5QJW6z7Afts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VsFbzJNnWHrNEUbwvCd3C7aMHSQDcHDTX/eugcJlAsLl2iv77ZeaUDg9xfyFhYzb2cdJRkc9JqaicB3bslbhWqZ1lyCpBzcxoL73ERiyRQTIXaOXNcL3e3jZtljgknu8TVcmVWbQTwa86n3iA9Qlt8HMj0Mlf+6H8XP4VIvtJk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VZSR87Ng; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6e4c359e48aso1660735b3a.1;
        Mon, 26 Feb 2024 02:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708942478; x=1709547278; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nn0wpF++cem/UZGdf5BQR6BIhvfqGjZKC1JKYpLlkg4=;
        b=VZSR87NgJwM3t/cQAkcV4JDYtzSVEl9wNAkzWgVQq2qi9E0icrqvpbnde5ZyoIN2CN
         PmgyJO79SWxjPXN5VQzgrg55BodwCTV0QFjNLeD0kTmj8PrVbd2sCclC0Nyu+TFIIsWN
         lL3LfjSIZbZb8QLcecJxEqCDWhGWDrHKb+nBE+be+4Hplmua9kbSNn8UyQwSVvFFUkKF
         DgSAM3I+fAaet9EsN6tYvYKT0Ozo1/y5i0TjP/mQ+922mwheEyDF+g5EmHclG0sGWsHC
         lV6sQzBy7MwuRJcK6A/oB9La70CPS1yRsuVSstM5/0ehcIG6ClogN+S/0eSFRBINWQBI
         huxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708942478; x=1709547278;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nn0wpF++cem/UZGdf5BQR6BIhvfqGjZKC1JKYpLlkg4=;
        b=okj/csXzfP1OKAJPE7Y/cFqIvmfnrPDP0xzNPmhiXjuiDEYwYxb2ifMWVQsqXuhwPY
         V8IR+JQX+bxqbfHswYSoctdyl5K65BSkcGjgMzwAxHuIzdoAe87fQp4i2s9ycTA1V3pB
         eMiiAai9ZVci+E0Zji/08oqruTSYGWYD3NK7G9tO6LDRS1Ej3OMxV5UaN199PrFr60NJ
         LoXXM62n6OkvPEcW/GoWLu3zWNu8PkKQE9cu0yZTmlPsTl1L7dSyUiZAaAalJsIMTBPB
         /QP+VYu9UL2UAt2+9gMv3B2zDC2Inzm6tMc7l88mvMXAB2PZfSyfBH8tlDsbo22E6lqm
         JzuQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYE791an6x2jWm3XQ68IAMRZvPFz4OJFVq1NG71YB7ViIa4l5S5FzY6ajJkYiwg69zYhalIZet34IbnNmDP4xZ7DIxwMdobs0xoQYUQrPHq/+IRDf8esETakJpzejJpg==
X-Gm-Message-State: AOJu0YwNmJUUz1Jnb4V683L0U18QbHf+IgbXbpEfQaVJDDRm7l3Xh6/r
	o7I1OKGm2WSmhFrpyPA08ip5UH9caSzsCzYDyhfpmnRP8KlG6/fG
X-Google-Smtp-Source: AGHT+IEONag+59fDg0rGek6fdriFbxd2o5/eMYAnHfHOB8an4AA/o7Pf8BjvWbqvq5clxGkq4IH8cg==
X-Received: by 2002:aa7:8613:0:b0:6e4:c69f:572b with SMTP id p19-20020aa78613000000b006e4c69f572bmr7009039pfn.27.1708942478503;
        Mon, 26 Feb 2024 02:14:38 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id x24-20020aa784d8000000b006e463414493sm3626693pfn.105.2024.02.26.02.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 02:14:38 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Subject: [kvm-unit-tests PATCH 29/32] configure: Fail on unknown arch
Date: Mon, 26 Feb 2024 20:12:15 +1000
Message-ID: <20240226101218.1472843-30-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240226101218.1472843-1-npiggin@gmail.com>
References: <20240226101218.1472843-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

configure will accept an unknown arch, and if it is the name of a
directory in the source tree the command will silently succeed. Make
it only accept supported arch names.

Also print the full path of a missing test directory to disambiguate
the error in out of tree builds.

Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Laurent Vivier <lvivier@redhat.com>
Cc: Nico Böhr <nrb@linux.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Cc: kvmarm@lists.linux.dev
Cc: kvm-riscv@lists.infradead.org
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 configure | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/configure b/configure
index 6907ccbbb..ae522c556 100755
--- a/configure
+++ b/configure
@@ -45,7 +45,8 @@ usage() {
 	Usage: $0 [options]
 
 	Options include:
-	    --arch=ARCH            architecture to compile for ($arch)
+	    --arch=ARCH            architecture to compile for ($arch). ARCH can be one of:
+	                           arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
 	    --processor=PROCESSOR  processor to compile for ($arch)
 	    --target=TARGET        target platform that the tests will be running on (qemu or
 	                           kvmtool, default is qemu) (arm/arm64 only)
@@ -321,11 +322,15 @@ elif [ "$arch" = "ppc64" ]; then
 elif [ "$arch" = "riscv32" ] || [ "$arch" = "riscv64" ]; then
     testdir=riscv
     arch_libdir=riscv
+elif [ "$arch" = "s390x" ]; then
+    testdir=s390x
 else
-    testdir=$arch
+    echo "arch $arch is not supported!"
+    arch=
+    usage
 fi
 if [ ! -d "$srcdir/$testdir" ]; then
-    echo "$testdir does not exist!"
+    echo "$srcdir/$testdir does not exist!"
     exit 1
 fi
 
-- 
2.42.0


