Return-Path: <kvm+bounces-18856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 274A28FC56D
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 10:10:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 493721F2157D
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 08:10:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18C8318F2EA;
	Wed,  5 Jun 2024 08:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UBYMcFti"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEEF18F2E4
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 08:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717574996; cv=none; b=d7TG0fJKdIR2eqKc/w+6rZqS0E9zcMQ4C/ff701WsyWdCHhlUKKYrt0TIXiBOwuHnY99wJPAd+C85r1u/oApIIy0KR+7LbohDkJJZTifhH9V5cRG89j6LlJxCFVp77G3vmBQBvNUPcnavJckp896baQZfXis1/APyURHi9QoPuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717574996; c=relaxed/simple;
	bh=bnOQqI//3TW77ODN2dIMoc+AGy0B19ITR5PqEDsRhQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bNZGqiJhRgnDDMzpWRyfR8IwS/T6DBNFJzR6AAYIVgi7WsttWdC8mzcPdDPuClNqyEe1YaWn6iTiWanppbg1TFTCANQfSTm2MX3mQSzvUux2hpQVAUYSjieiWy63krDglZzr3HhKIe0Amg2IFUbPe9zc+g64rmgEOd0cDFDGfKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UBYMcFti; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1f6342c5fa8so39072705ad.1
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 01:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717574994; x=1718179794; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3bS5X+2iRCqKghZHw7j8sOuL2938EX8uAkbCu/GgW6g=;
        b=UBYMcFticiKRpXaiASjnV+fMJXd3/Nf3TU5YrvEz3snLseAiPwypOlWDwIxiR22j18
         4xyOgLO/MGLQDz6Sznr3g6bXv6wwUNEhsH7Kq3ZG3k3T/I8spWPMKG31tdJY08XW2ue0
         bbcdY8qOSFHSb/f5sNFhv3tWUzj16y457qBT3TuOIJ1FFMIVI/2LQH6lYbS1qcomg6XW
         qAErgned31o5b1cT+Ja9iMM4gG9aJDZa89OOK+YksoFexp0AACC+UKtUWiXzaTYWnyj5
         znjeOEnnKOj2K6nyUweidqcxT3yJiZlW5u4/qbtXGCbz4dsy8S/ksMl8LLDyfo/Kslqs
         h1GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717574994; x=1718179794;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3bS5X+2iRCqKghZHw7j8sOuL2938EX8uAkbCu/GgW6g=;
        b=eXzzkWbnBE/eYGADgiBKHA4Qvj+M/u3u1ZYAKbDNXeQR8xAogwRIFPWAjsd7n7PuvV
         ozD5TU3jgB8L8ug/hlf8/nSRA8po28wp3uNEkqx2jhIdYsMFn4kOQr1jPYl6j07PQ575
         mo91G4GXjhSCX2RhhRD+6mdH9NzI00kVCDypGmbFcP+NnWHgEMHONIai17ZDwtS8hIa7
         UaG8OH8Q/g29EF9XISmjLCQifoWhN/UAnMST9DHKIVwOjsQbibSSe5NxmOFhKwug2A7J
         22WgjXuawWx6ucrTMYisGFOzPhP4v7aothPDocDExeoSBNipQ6ExN0NjIl/5KLztFaRU
         Qy0g==
X-Forwarded-Encrypted: i=1; AJvYcCXWNIEjWMSL9Du4Tf37xeWx7Rroon1OwoBc31ABPHMTGVyKf4L2B5dWkQnsdLEwnFDH909JTmVPlL1j52FDX+EkcQw9
X-Gm-Message-State: AOJu0YzPAVJrnoHjY+4kao79hk1lwBTRRwMxPiXCY+AleF9oBUFP4HRp
	LI2xLldVoK/FsYodMPv/KEvXrrUU8vwPdbaZiUbHF/m/wcDJU1s1
X-Google-Smtp-Source: AGHT+IEqpgy1Fyef+LREZRqVaVILaMrE8+YblNRBKpimM6I3l8JidJCvI5L1l/U5HTvAkznhJ7pcjA==
X-Received: by 2002:a17:902:ea08:b0:1f2:fe60:2d80 with SMTP id d9443c01a7336-1f6a5901ff5mr22091845ad.6.1717574994127;
        Wed, 05 Jun 2024 01:09:54 -0700 (PDT)
Received: from wheely.local0.net ([1.146.96.134])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f64cff7166sm78662035ad.160.2024.06.05.01.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 01:09:53 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 1/2] doc: update unittests doc
Date: Wed,  5 Jun 2024 18:09:40 +1000
Message-ID: <20240605080942.7675-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240605080942.7675-1-npiggin@gmail.com>
References: <20240605080942.7675-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Document the special groups, check path restrictions, and a small fix
for check option syntax.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 docs/unittests.txt | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/docs/unittests.txt b/docs/unittests.txt
index 6ff9872cf..c4269f623 100644
--- a/docs/unittests.txt
+++ b/docs/unittests.txt
@@ -69,8 +69,11 @@ groups
 groups = <group_name1> <group_name2> ...
 
 Used to group the test cases for the `run_tests.sh -g ...` run group
-option. Adding a test to the nodefault group will cause it to not be
-run by default.
+option. The group name is arbitrary, except for these special groups:
+- Tests in the "nodefault" group are not run by default (with no -g option).
+- Tests in the "migration" group are run with the migration harness and
+  are expected to make migrate_*() calls.
+- Tests in the "panic" group expect QEMU to enter the GUEST_PANICKED state.
 
 accel
 -----
@@ -89,8 +92,10 @@ Optional timeout in seconds, after which the test will be killed and fail.
 
 check
 -----
-check = <path>=<<value>
+check = <path>=<value>
 
 Check a file for a particular value before running a test. The check line
 can contain multiple files to check separated by a space, but each check
 parameter needs to be of the form <path>=<value>
+
+The path and value cannot contain space, =, or shell wildcard characters.
-- 
2.43.0


