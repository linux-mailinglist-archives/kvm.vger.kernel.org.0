Return-Path: <kvm+bounces-22293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B4D3093CE72
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 09:05:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7996D281B65
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 07:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63B41176AC6;
	Fri, 26 Jul 2024 07:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LMhFVKXi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE06176252
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 07:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721977518; cv=none; b=ead+lA885Jo07qux7XJkYvX2BalEx9U61si9Zcm9HlFQqDP8NSGKH6E6Elv2JxG3dlQ4SDROLLWsU8tL9L8RMe6G5TrRTOeqEVKNlYRIp2nvXFqsCAOldVYnv6S5ciGS2O9Ja+Ubl38OVYlxEcriSXRxJ7JP1+OYnfkP9Lejl7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721977518; c=relaxed/simple;
	bh=RA1Oz/Qs7Q7NBa/PATOVIFOS4UN9NSRIp2v6/R6XIQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXtZA33WvxtlQGJuzLTFDuP0HYsmIy0H1QMpUevpin7Sjxx48YlkwiR6n6jiavvTsCEJuMHBkFrHxPMiBzGGm8sDTLJ0gpvqmoVQyC74BYjhTNmEC35D2+eFHjbScCOjs/gcodD+prMZFhDqlgoyxLWIzuHhqqQyFuKCrIA4T0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LMhFVKXi; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1fd9e6189d5so3315245ad.3
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 00:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721977516; x=1722582316; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2sBRxxxMJ5DZOxweYHYLXpqI2/nbFUU7jwO+abOru3w=;
        b=LMhFVKXiQ1WTBWXDsX5ObZYTspMIm8XQhSkFrKFV5OCtTO6lkBtkgvtCTGG0yeJn26
         HZDoBLwLy3YgMAZHTUyxFnSE8X8t++bxq0hq0fNzW696mPV8C993KA7JYjMv89r79m2s
         DJ4gl/iv9hmtk+ubpk4AhYZ0kgD62IfPMlZHc8zjOnZJOFAXEsorI9qGF5tCVlpluSRu
         sPorxrS99bwHUTJJ89xPGdyOEUQhk6c/tHI4f0PXJuFxulnWIptaMAWt1eLrWN4t1bhb
         BGJDgU8ym4GI6Pizr6NXQo3U44pRgPwjo+RtH1mpDSBHb6lGMdyqqIdUSep0fOb914t8
         oonA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721977516; x=1722582316;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2sBRxxxMJ5DZOxweYHYLXpqI2/nbFUU7jwO+abOru3w=;
        b=K4EIThD+GXeT0e0Qvkrg2U8cLP3dY5IJ3Rwsr84ppH69XXlimJwf3tfKd5Bw0jEAis
         gZPj3vn0nCUJLz4tpYEBK4HIMSmcDysc9kVBpHR3wOMuLcmhylmJNtQxWFbJRqD/uFTd
         mYEt2Tpxjzs7JdFg44Vdp/HTvTesySCN2+uYkxpL7R1kmjXk/QGze47RGvr3ba3wfp4M
         Dx+4PRSpI5eOSG8z+fdiPWl05B/lj0uGTCAkaHQ+wE88IY3PSHOBtL8bUNKZX4wOsdYS
         xSHCi4Sw+YV7E8Pls3nz2zk+OLGFnbJX+G56QTUIv+V2IVcy1K/C1ctijlRNMeho633+
         wZYg==
X-Forwarded-Encrypted: i=1; AJvYcCUMZavgAScgDJlddmmGJ8IlePtnmmD2hB2rentsfk6J6wNBSg9XC0XyGkQPTOhBP2lPTLrRjLUGGym2aKLW0k8f/rTl
X-Gm-Message-State: AOJu0YzUIjAHMY/PAm6KhZMrYlhe8PIuNpT5jhv42r/df657M8P6mM3i
	n4xj3Y0hymz1nSEO+IXYiEe0wuIrqq7Dr3R7lLAFsoQzAbhLTVB9nXfoeQ==
X-Google-Smtp-Source: AGHT+IEXfLmeepfs/qaamcwnIWTnRwqd4HA+vbHMMIVBMjb8dhxgdwMDJGbPpGdCCuZqegei30A4Sg==
X-Received: by 2002:a17:902:cf07:b0:1fb:6294:2e35 with SMTP id d9443c01a7336-1fed92f34aamr47459155ad.50.1721977515930;
        Fri, 26 Jul 2024 00:05:15 -0700 (PDT)
Received: from wheely.local0.net ([1.146.16.227])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7ee4d26sm25034215ad.166.2024.07.26.00.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jul 2024 00:05:15 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 3/6] gitlab-ci: upgrade to CentOS 8
Date: Fri, 26 Jul 2024 17:04:44 +1000
Message-ID: <20240726070456.467533-4-npiggin@gmail.com>
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

CentOS 7 reached EOL at the end of June 2024. Upgrade to CentOS 8.
The mirror URL adjustment script still seems to be required.

This brings across some of the x86-64 tests that had been enabled
on the fedora build as well.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 .gitlab-ci.yml | 40 +++++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 823f03c3e..2d048b11d 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -296,26 +296,52 @@ build-clang:
       | tee results.txt
  - grep -q PASS results.txt && ! grep -q FAIL results.txt
 
-build-centos7:
+build-centos8:
  extends: .outoftree_template
- image: centos:7
+ image: centos:8
  before_script:
 # CentOS mirrors have changed, these sed scripts fixes the repos.
  - sed -i s/mirror.centos.org/vault.centos.org/g /etc/yum.repos.d/*.repo
  - sed -i s/^#.*baseurl=http/baseurl=http/g /etc/yum.repos.d/*.repo
  - sed -i s/^mirrorlist=http/#mirrorlist=http/g /etc/yum.repos.d/*.repo
  - yum update -y
- - yum install -y make python qemu-kvm gcc
+ - yum install -y make python39 qemu-kvm gcc
  script:
  - mkdir build
  - cd build
  - ../configure --arch=x86_64 --disable-pretty-print-stacks
  - make -j2
  - ACCEL=tcg ./run_tests.sh
-     vmexit_cpuid vmexit_mov_from_cr8 vmexit_mov_to_cr8 vmexit_inl_pmtimer
-     vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed port80
-     setjmp sieve tsc rmap_chain umip
-     | tee results.txt
+      eventinj
+      intel_iommu
+      ioapic-split
+      memory
+      pks
+      pku
+      port80
+      rdpru
+      rmap_chain
+      setjmp
+      sieve
+      smap
+      smptest
+      smptest3
+      syscall
+      tsc
+      umip
+      vmexit_cpuid
+      vmexit_cr0_wp
+      vmexit_cr4_pge
+      vmexit_inl_pmtimer
+      vmexit_ipi
+      vmexit_ipi_halt
+      vmexit_mov_from_cr8
+      vmexit_mov_to_cr8
+      vmexit_ple_round_robin
+      vmexit_tscdeadline
+      vmexit_tscdeadline_immed
+      | tee results.txt
+ - if grep -q FAIL results.txt ; then exit 1 ; fi
  - grep -q PASS results.txt && ! grep -q FAIL results.txt
  - make -s check-kerneldoc 2>&1 | tee docwarnings.txt
  - test -z `cat docwarnings.txt`
-- 
2.45.2


