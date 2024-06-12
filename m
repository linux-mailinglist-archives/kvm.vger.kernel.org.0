Return-Path: <kvm+bounces-19465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D5A6905597
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 16:47:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C595C28A0AF
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 14:47:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A42221802DA;
	Wed, 12 Jun 2024 14:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gysKcROM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516601802A0
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 14:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718203564; cv=none; b=oPU9TePV49xjZaEaenwmwvbsZvUfZRUL2zwqNKuoGwNydaZmzxsOjyON1dadYpdHKz+KZgC2Of2FrGqgtQcK0PKQl6BdBV9NI+L6saw6dPmcGuSk5p8xdb14WeVeVawVfBpKwgLAkHsDd0f7dN3+nd8Yd+A4u6JNk5M22E/77HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718203564; c=relaxed/simple;
	bh=XZpuq8XXaphEtICVe+CBZq6Xjt9zGTjTiS89MwFA7m0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LQOPiGNdZCj+/HEFhJ3uoipVO06ri4/YTK+2hwfMnx2vYZw8fzlRIoRGc8+Kc8UnRv7j5aNLXTt6Sava5FFdnDLtSmy51Pq/BWwoSua534s7a9Xu7+GPHjNzfQKBu71YFF5u60v+Nv9AnYn5FCRA3KIBZEDCT2pdm8dxmIvQ4l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gysKcROM; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-52c82101407so7481922e87.3
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 07:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718203561; x=1718808361; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=90jPOH96cHSDTO17IWoMlm6kFPsoA10tI2fctk2DnOA=;
        b=gysKcROMClXMds984GKgn3ja6Ma0qiVyRyqj7P3PMrXRy+0gd2T1ywVVDOPMXGs53X
         N9sEvomq2Y/mBfjRzDEuQ01mbXAqUrukiHy8rEB8YQt3TrcGXa46Pnr/3OT63BHeiotf
         GPrnKcvHAZ7/3ARAiWy6pR/Wv0BKaVNpPa6Vcwq0ARKaaMFpkQjSnphLQNcO7bpOXCGz
         X3sLXzeNMhVbv/r4JSVofNMDQWu9lYwNzBY2doIXGBv8kMpYBQhsU2CNVLIXA9p/J/OA
         H+r6dCSDmeJCGS7viwH3ZKxFIYU+M9MtDyE6pnTufzCdRtIV3ohGEvo07DUtZVqaG+kM
         b+VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718203561; x=1718808361;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=90jPOH96cHSDTO17IWoMlm6kFPsoA10tI2fctk2DnOA=;
        b=O/PJEyJTSnKxQQIRXH65w+HlunX8Ex1tur9P/a18H+pizy5JPBQlwandZM0nqvWz6c
         1tlB9v8MkFGLT8LRX3eRR/T8ih8uMGTWByknVNlchO+6tMm4tA+azspoayMRVRL/hhCJ
         IHKZEkf1InqlbL0pIi3PPUe9YSjWoYiky6OlwXhSTsYBf0wJks715uIpuFaaKO+9a0db
         McoyuNDHofsm2c5puJ0oSACdMxJTIMKc4HAqwnzGk1SEBcCUOqV1NtBqWatMGP6AWIyq
         kJyXsGnqZJxi+uvlc8dZp2caUDIimLf0a0ZkmeA2n5/bXQ0hVl+kkhCfZdzlg0tawkR8
         /8Qw==
X-Gm-Message-State: AOJu0YwcpBrEv56lA09CxTWANGB+kH3QPSu+zDG7QpXP+dQY0Z7+1A7j
	48lJ3QYrav403BdIR6YK+sIYSJ6oEq3QuU5vloVXsPGsmmJhZp3+4eJEXou7
X-Google-Smtp-Source: AGHT+IG1Uohaz+v1ibTQJTDkvtswUWqLaYmK3XmvfFBNJugZk1Gr/534VzletMV74kZX7xbqPipaSw==
X-Received: by 2002:a05:6512:1253:b0:529:b718:8d00 with SMTP id 2adb3069b0e04-52c9a3bfb36mr2138177e87.8.1718203560720;
        Wed, 12 Jun 2024 07:46:00 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab7c:f800:473b:7cbe:2ac7:effa])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f18bbf3cbsm456440366b.1.2024.06.12.07.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 07:46:00 -0700 (PDT)
From: vsntk18@gmail.com
To: kvm@vger.kernel.org
Cc: vsntk18@gmail.com,
	andrew.jones@linux.dev,
	jroedel@suse.de,
	papaluri@amd.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	vkarasulli@suse.de
Subject: [kvm-unit-tests PATCH v8 12/12] lib/x86: remove unused SVM_IOIO_* macros
Date: Wed, 12 Jun 2024 16:45:39 +0200
Message-Id: <20240612144539.16147-13-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240612144539.16147-1-vsntk18@gmail.com>
References: <20240612144539.16147-1-vsntk18@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vasant Karasulli <vkarasulli@suse.de>

svm.h contains many such macros are not used anywhere.

Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 lib/x86/svm.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/lib/x86/svm.h b/lib/x86/svm.h
index 96e17dc3..53bf115a 100644
--- a/lib/x86/svm.h
+++ b/lib/x86/svm.h
@@ -140,16 +140,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {

 #define SVM_INTERRUPT_SHADOW_MASK 1

-#define SVM_IOIO_STR_SHIFT 2
-#define SVM_IOIO_REP_SHIFT 3
 #define SVM_IOIO_SIZE_SHIFT 4
-#define SVM_IOIO_ASIZE_SHIFT 7
-
-#define SVM_IOIO_TYPE_MASK 1
-#define SVM_IOIO_STR_MASK (1 << SVM_IOIO_STR_SHIFT)
-#define SVM_IOIO_REP_MASK (1 << SVM_IOIO_REP_SHIFT)
-#define SVM_IOIO_SIZE_MASK (7 << SVM_IOIO_SIZE_SHIFT)
-#define SVM_IOIO_ASIZE_MASK (7 << SVM_IOIO_ASIZE_SHIFT)

 #define SVM_IOIO_TYPE_STR  BIT(2)
 #define SVM_IOIO_TYPE_IN   1
--
2.34.1


