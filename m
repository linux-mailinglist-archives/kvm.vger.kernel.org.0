Return-Path: <kvm+bounces-9786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 025FA866FCA
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:03:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B14762891AD
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:03:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B76245EE6E;
	Mon, 26 Feb 2024 09:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TR78LaH7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890895E22C;
	Mon, 26 Feb 2024 09:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708940368; cv=none; b=ZyTbChhgzIQUNmePq7L5+2uaud5GNfUFOJ3M9furE+N0/O4m4ZaWsAFmT0IIGmIAwVRbNAtPANPYvdd+doa3ki4NQj8HRc/jfhRUOOl3Sv9k/osiG2iUG/sOjkU4GGvxWOSU3is4y1KUxI+HK9CluUuy9NvIGVInq92qlV9Wf9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708940368; c=relaxed/simple;
	bh=ch0oCFU3DPtmmV3mWi2ZGJZNHNRxTVrZGJf3WMLapsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5Rbvlr+XDcJiwC08c3qC1n0G/aZvqRnyzk9MvewPckO1lcsef41cCSEND4MXVnsW9b4X2bN5mpcsyKKf5WlSBlkbcqqBf735OsQPfQEdZOhVpmAG9iI/F5aaSYTxispN8SDpFGIQdUaN3tZPqFTT3IW5w/P0bHy6H5CQJv1sG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TR78LaH7; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-299b92948a6so1818779a91.3;
        Mon, 26 Feb 2024 01:39:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708940366; x=1709545166; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ir8XVGfbEwUzyyUuS20ld9G5VKQJor6iBkETXZzZgso=;
        b=TR78LaH7kh18dzCfx3Z6J81NKwhEqpG/w+FLbdQ7DQzEiGv58RZ53YBwF/qyOipXMV
         KkUGQQGwij1fGhIIk4uIEQW2CZFyiLaRXQVb1iYHWxT2hlrGhFiXnsMUapTNMGmbFiZr
         k05/Q3aH1/iIL+mFJIoLEPMFlRFwpayttVXW03/lqIsH+F51L4ipd5tuClFwuyEoSRFl
         XCgpwNEZWbyTwz6yfiQj0E2V4JOcPBPrHimq8uk/4loFT3XE/aU9cC1k132mKg2fcUd5
         t1xUj9Irs4vCuPrv8cJOK02JhTXgB0YXGv4L8ditRDa7HZbtAOeZTSkgccx76fvO/n4l
         iuyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708940366; x=1709545166;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ir8XVGfbEwUzyyUuS20ld9G5VKQJor6iBkETXZzZgso=;
        b=urnoODCe8H8jPjFgr72x4lm9cfRpQSX4kfI4vsmy80L9hmp1noaCZMOUInS0PxvXnb
         4MvRHzsxllTiczwTTd145W0ufimzox0yQ4qO7Kmd5ygbO57FDf/voglUmHPASXpcMnUY
         uVL0qAJv/R9Y52NxQyk3orJX2paYruerXc15mT4dQN1pGnfh37VZXVJ3cMUk0KBWP6A7
         KAN2YQHQpY4m1VO1T6yuosXeL47+46pWAEdlz6w5cDg1yDED1m/K78XpR45YGSJUisMI
         E0oH9NZDBzUUY2+g4O1Dh7Kxl+NeJkmGliaHLqPcfHhwoDCtUwJvfdsPRPiiXFzzu1yC
         ZN0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVf7zCnV/0EF9u4PYvi3vnYohTscZLNBiuNNxrIggeDyCpG1ORIS6Pg/Ro+sLY9/TpCjqH8qZmz0Q7m7R4DpFW1a3dEEopu656HbmISFCUpkzqhF+TrLcmMy1Di+73uLA==
X-Gm-Message-State: AOJu0Yy9KNwErHzZUt8zhoYma/jiwcycLINxtk0ZPawr86kE262QXjRp
	pI0JlDX7iqqgH9GjNHuASePKJBgu6ypNRICw6cJjvZGerS6ataRaLkf2iT2Y
X-Google-Smtp-Source: AGHT+IGmvHjEHV9FtxS/iLLwhsoB6LA76JI/2S+B5fHnmu7Hgj2BYmypa1uOlQi8la9CdsvyNQ+YiA==
X-Received: by 2002:a17:90a:1117:b0:299:14c9:94f0 with SMTP id d23-20020a17090a111700b0029914c994f0mr4250349pja.11.1708940365783;
        Mon, 26 Feb 2024 01:39:25 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id pa3-20020a17090b264300b0029929ec25fesm6036782pjb.27.2024.02.26.01.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 01:39:25 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 6/7] gitlab-ci: Run migration selftest on s390x and powerpc
Date: Mon, 26 Feb 2024 19:38:31 +1000
Message-ID: <20240226093832.1468383-7-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240226093832.1468383-1-npiggin@gmail.com>
References: <20240226093832.1468383-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The migration harness is complicated and easy to break so CI will
be helpful.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 .gitlab-ci.yml | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 71d986e98..61f196d5d 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -64,26 +64,28 @@ build-arm:
 build-ppc64be:
  extends: .outoftree_template
  script:
- - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu
+ - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu nmap-ncat
  - mkdir build
  - cd build
  - ../configure --arch=ppc64 --endian=big --cross-prefix=powerpc64-linux-gnu-
  - make -j2
  - ACCEL=tcg ./run_tests.sh
-     selftest-setup spapr_hcall rtas-get-time-of-day rtas-get-time-of-day-base
-     rtas-set-time-of-day emulator
+     selftest-setup selftest-migration selftest-migration-skip spapr_hcall
+     rtas-get-time-of-day rtas-get-time-of-day-base rtas-set-time-of-day
+     emulator
      | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
 
 build-ppc64le:
  extends: .intree_template
  script:
- - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu
+ - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu nmap-ncat
  - ./configure --arch=ppc64 --endian=little --cross-prefix=powerpc64-linux-gnu-
  - make -j2
  - ACCEL=tcg ./run_tests.sh
-     selftest-setup spapr_hcall rtas-get-time-of-day rtas-get-time-of-day-base
-     rtas-set-time-of-day emulator
+     selftest-setup selftest-migration selftest-migration-skip spapr_hcall
+     rtas-get-time-of-day rtas-get-time-of-day-base rtas-set-time-of-day
+     emulator
      | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
 
@@ -107,7 +109,7 @@ build-riscv64:
 build-s390x:
  extends: .outoftree_template
  script:
- - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu
+ - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu nmap-ncat
  - mkdir build
  - cd build
  - ../configure --arch=s390x --cross-prefix=s390x-linux-gnu-
@@ -133,6 +135,8 @@ build-s390x:
       sclp-1g
       sclp-3g
       selftest-setup
+      selftest-migration
+      selftest-migration-skip
       sieve
       smp
       stsi
-- 
2.42.0


