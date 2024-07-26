Return-Path: <kvm+bounces-22294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DA7A393CE74
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 09:05:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 68070B2144D
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 07:05:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D69F0176AA1;
	Fri, 26 Jul 2024 07:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I6Vt+Azl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF13A176ACB
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 07:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721977521; cv=none; b=Ih5goNhHS4L36TutaaW6k/8JD7OTZPXl5M9Hhoy2rMa1HIqXnUaomFCsFsS3GwSjMgCui34x95BRPfoNdxq9hBeGVPR2NjtARl1/plK5P7OKa8Mm01c1dqklUEZMKtANcTohHakEr1Cc1pr90bfdNtKWiOxOoIPFXd0vXZAnsrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721977521; c=relaxed/simple;
	bh=1NbCxafabXGXTAXc9kvrXBBak8yW/fXZt/kY/35G3T8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E8EyTK6zd4dggn5nievJ6oPr5w3CizYNk4v1ollpq1fbCdn5XVU8rN9+M5jr+OAKuHpKIsp4E53JBDTEjvr2QLKiDLC0Tx6JxJa2fCVuLRhxExjgptlFDwJVo4EQ/PsQYpRv8f/cthXfenhUnlTi4HGI7LtdgQDGTp32uGuKWE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I6Vt+Azl; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1fd70ba6a15so3062075ad.0
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 00:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721977519; x=1722582319; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QvGzgrplidlxm5HjJhkmSkIF44ZTZQEDLgrNfwf7u/E=;
        b=I6Vt+AzlMiDYECQ8DRkBIfOqw7DSvV6MmRUtPcooullzBE0oKB1WjVX3PiLELkKrrX
         GCVo6B92MYeO0KW9qLpvHq4unKhYpgxKUmymyY1MhC9Cipquljsr2ryXUa+qI1q3Lhq0
         zp+X9SbrvYUm5vh3q6Yst6La6rKduwVqavrI3ctOau+/47WBHEB/Np0B9qa8z0EOWZXA
         KQ8DyqJGh5rvO1V816E3lMuc7JkS8bkmGUzFhRwHA8s/lCNPwdJrf+CYXQ86coQB9+OM
         1uAC+lsKwrs43DJ8PCWDTTM6fnmBoUwt7fYGumoFuaZ/q6VNJLr9oQafYfzGQcG9DYNH
         Nw6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721977519; x=1722582319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QvGzgrplidlxm5HjJhkmSkIF44ZTZQEDLgrNfwf7u/E=;
        b=LdH4rTUo8sS9ZvJjQDMfkuv/pEGIE7BefZTGg8FWxXdhJBQbduKW/chdF6J+d8PFrA
         MoPncmuqzPRPf1wWCOouig19EmatiGj3E/NRnjVLxFSww67XtXs8xljmKE/h7rd7JTMU
         A2rHdT9oW8DCqp1ab9FmSQOWRDjakJBqnGq7eAZu9EbgpdPMXpz9X4+6H5+0j7PtHvzS
         6yJZs1HY8q+/GIDf/BrdN/zQVFPVuwTC5yCI+Vn23x2BjXlLcvwMiwsayfrYr3dJnj3s
         K+StOUfTZZUwa9mmYiGqtUq86+/4MYbxlrnWFCSlEtOtt367fPJZ20yDFf73s9FgPhxW
         kqZA==
X-Forwarded-Encrypted: i=1; AJvYcCUf+sGeOhrvUgMNxoi95meYt1e4mmWLtleq0Bcn78yvzq3FgISLo/jvk1YrPzFvQ2Hvuv4plZJcOYcVXGMU3VT/1Vzx
X-Gm-Message-State: AOJu0Yx1akjO9fqviiyhnhdIFp0iVAJPYqvNJhR2AqjF6PIlHmfHbbbK
	+Xret4phqOnOojUtdW4Kg2THmgeysPg+68HZVKVyaRHVRb1TLHOK
X-Google-Smtp-Source: AGHT+IEyJU4aGS3gFnfSVz09i0PH0jYrkLLqijpi5zSEeedXJYNzSC7+LOsosttYmnwUCz/xoCoRIg==
X-Received: by 2002:a17:902:c40d:b0:1fb:35c7:8eb2 with SMTP id d9443c01a7336-1fed92ca3c3mr50699145ad.55.1721977518927;
        Fri, 26 Jul 2024 00:05:18 -0700 (PDT)
Received: from wheely.local0.net ([1.146.16.227])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7ee4d26sm25034215ad.166.2024.07.26.00.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jul 2024 00:05:18 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 4/6] gitlab-ci: Move check-kerneldoc test out of the centos test
Date: Fri, 26 Jul 2024 17:04:45 +1000
Message-ID: <20240726070456.467533-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240726070456.467533-1-npiggin@gmail.com>
References: <20240726070456.467533-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This creates a new lightweight (alpine) kerneldoc check, based
on the QEMU static checking jobs.

The aim is to decouple the test build and run jobs on different
platforms from the static checker images, so one can be adjusted
without affecting the other.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 .gitlab-ci.yml | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 2d048b11d..0f72cefe7 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -305,7 +305,7 @@ build-centos8:
  - sed -i s/^#.*baseurl=http/baseurl=http/g /etc/yum.repos.d/*.repo
  - sed -i s/^mirrorlist=http/#mirrorlist=http/g /etc/yum.repos.d/*.repo
  - yum update -y
- - yum install -y make python39 qemu-kvm gcc
+ - yum install -y make qemu-kvm gcc
  script:
  - mkdir build
  - cd build
@@ -343,8 +343,6 @@ build-centos8:
       | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
  - grep -q PASS results.txt && ! grep -q FAIL results.txt
- - make -s check-kerneldoc 2>&1 | tee docwarnings.txt
- - test -z `cat docwarnings.txt`
 
 # Cirrus-CI provides containers with macOS and Linux with KVM enabled,
 # so we can test some scenarios there that are not possible with the
@@ -418,3 +416,16 @@ s390x-kvm:
  only:
   variables:
    - $S390X_Z15_RUNNER_AVAILABLE
+
+check-kerneldoc:
+  extends: .intree_template
+  stage: build
+  image: python:3.10-alpine
+  needs: []
+  script:
+    - ./configure --arch=x86_64
+    - make -s check-kerneldoc 2>&1 | tee docwarnings.txt
+    - test -z `cat docwarnings.txt`
+  before_script:
+    - apk -U add bash make perl gcc
+  allow_failure: true
-- 
2.45.2


