Return-Path: <kvm+bounces-16564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AB6F8BBB35
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 14:29:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C634F1F2211D
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 12:29:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28E3422EFB;
	Sat,  4 May 2024 12:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PYcXxsL1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118A3210E6
	for <kvm@vger.kernel.org>; Sat,  4 May 2024 12:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714825737; cv=none; b=sImGInGH7TVoHQF4eBTyPjAhdshaWjfAtdCevYmwCE6XsPr73Y/a5OZ5t458LWqlOFDQKvu2F6d0dgYTirUdp6dzXYcbaWEI/VTEtD6WvMr+Fh+w2pZx8rjwOkHePiWu8Sb6W8yW5Uq8tBZaMd4YDHJ8ecpNMWQYhQBR0Pco4dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714825737; c=relaxed/simple;
	bh=2QcFFYgwQPC65qputPJMHR1hgRLVpSziaskZ2637ibk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OuPADWNMAOtVEPNF6hTckiID7wwAih4Zf+o7JwAaKSYmFKkYRLUyY5WOTY1+3WbQhQtVlf8RuUVybh5iyPA9fTea9rYW1fcJjQ7VOnm9OLAvqrK6L2HxwyvF6OfoAgvksnjkVOGrTVj4F0tsXo1r9Msmz6t3aVwqBE00vcRntOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PYcXxsL1; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6f44390e328so524176b3a.2
        for <kvm@vger.kernel.org>; Sat, 04 May 2024 05:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714825735; x=1715430535; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I25dR1hp7l0QjjFDNAfUmrV/isLz0uJLZYj3XaBOpYk=;
        b=PYcXxsL1kwoT1i3UldxkumrOPvX1vDYdFBP/USXqDpZs6ymcy3GCR3lPLqBCKFtElB
         EbKquRi9N85/9i3tv7MjEXtpzCjzsT+TBwvZpxDbeJCxWpUqH9MwogNFJVTjyk1Y68eQ
         92JH2xMkQwxaTL1e2/gH+rgBYOtUMP5Rt29415l6mNZY59wAmB3wEQdp+I0hzY3cwWUX
         aZWvQTdWAOZzWsdaJTNBnEahctrLYduPPN9cerzYQLvs6NbRiZZod67Y0HBi+R+G6nD9
         ARMfZXbUL9p8XTT7WSqrU/x1qTXmgX9FSuFtQRVh2qFi5jQGCI/3GBEqyowinZarvcgn
         Wuzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714825735; x=1715430535;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I25dR1hp7l0QjjFDNAfUmrV/isLz0uJLZYj3XaBOpYk=;
        b=lbI7WGipDi1u93rOwiFkH1DIFvq6SCgyuVRGoGOrbryMhy0/pcfDtrTvMVny8zf3Io
         wW1q6gQ9VFNRKTYTDLIWtukEGLOY/YXaPq26g73Xj+mxomaEUl/a3xLHSr0Vc2naOk8g
         F1ATVrq+b63HBfYaT644iKtgCDrOOZoDWEUUW/OJMpiuTd0WafGwcNylZslneHBNvlC0
         6/PigZzxUgdu7sxZ6+WRNSauPffMXRYZYKxevVzwNlgSrQzP8OyAxYHyIF23BmtXrClz
         rbdKyNUedtB2rfuu1kOwH1RfsLa7K8Lgsx+q7PIEwavPPgAUAy94pxmPWKnKM+V6jb/z
         wLXA==
X-Forwarded-Encrypted: i=1; AJvYcCU06Tw4TvuIrzB7mQtxGaFMI3yOVakJIESoHdhfD5v2lNhHKYMmI78nGag1rnvpMoNB0A57SkR9TPXyj1Xx0Sot/WQB
X-Gm-Message-State: AOJu0Yzv/0vd2dV7WO8KEd+oRV9Xto7O6RhhL2idrqfX4qmNsEZBUkVT
	k6GI2pKWScl/oIETQ03hy6bzi0w2mn7FtSCP+cRKpzjc975VkcC6
X-Google-Smtp-Source: AGHT+IGaFaM98B+g3awhLTc0POSb1Mkk5D3cQDh3d7Qwnrc2vPOZNBOGQtUtLg4E7fAYXpIWmzWJXA==
X-Received: by 2002:a05:6a00:18a0:b0:6f4:1799:c714 with SMTP id x32-20020a056a0018a000b006f41799c714mr7186679pfh.12.1714825735365;
        Sat, 04 May 2024 05:28:55 -0700 (PDT)
Received: from wheely.local0.net (220-245-239-57.tpgi.com.au. [220.245.239.57])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a000a9000b006f4473daa38sm3480068pfl.128.2024.05.04.05.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 May 2024 05:28:54 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v9 01/31] doc: update unittests doc
Date: Sat,  4 May 2024 22:28:07 +1000
Message-ID: <20240504122841.1177683-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240504122841.1177683-1-npiggin@gmail.com>
References: <20240504122841.1177683-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds a few minor fixes.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 docs/unittests.txt | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/docs/unittests.txt b/docs/unittests.txt
index 3192a60ec..7cf2c55ad 100644
--- a/docs/unittests.txt
+++ b/docs/unittests.txt
@@ -15,8 +15,8 @@ unittests.cfg format
 
 # is the comment symbol, all following contents of the line is ignored.
 
-Each unit test is defined with a [unit-test-name] line, followed by
-a set of parameters that control how the test case is run. The name is
+Each unit test is defined with a [unit-test-name] line, followed by a
+set of parameters that control how the test case is run. The name is
 arbitrary and appears in the status reporting output.
 
 Parameters appear on their own lines under the test name, and have a
@@ -62,8 +62,8 @@ groups
 groups = <group_name1> <group_name2> ...
 
 Used to group the test cases for the `run_tests.sh -g ...` run group
-option. Adding a test to the nodefault group will cause it to not be
-run by default.
+option. The group name is arbitrary, aside from the nodefault group
+which makes the test to not be run by default.
 
 accel
 -----
@@ -82,8 +82,10 @@ Optional timeout in seconds, after which the test will be killed and fail.
 
 check
 -----
-check = <path>=<<value>
+check = <path>=<value>
 
 Check a file for a particular value before running a test. The check line
 can contain multiple files to check separated by a space, but each check
 parameter needs to be of the form <path>=<value>
+
+The path and value can not contain space, =, or shell wildcard characters.
-- 
2.43.0


