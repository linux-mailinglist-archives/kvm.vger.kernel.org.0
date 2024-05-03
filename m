Return-Path: <kvm+bounces-16481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C68648BA6C5
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 08:01:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C4C87B21AC2
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 06:00:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63AD2139CE8;
	Fri,  3 May 2024 06:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R62oGebn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAF0139579
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 06:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714716050; cv=none; b=jjHz1m2iQSMPK39d3TqTdqpScO3VXcFHHb6orPRiVyP0iJff6UBVbuB2aSO2n0RXY04uWxI3OPLh+bnu48I1XwAEDKwBAXNyApuDvyAPHVd4rLka2tXqDSty0bCkK8W5Eru1e7/LWCnLaZYnO7XLFovgG/zDTsqKWRqn4LPjfwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714716050; c=relaxed/simple;
	bh=Lp30UNYo0tKybRVZVAtNpHveRT/j09+L9aU63DJH4fA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kmNFu+x2hLQXiRv/Y7RdKuJe3L3a2b4wa97au0r/NhyvQn1v+5PI4EsF1JYarWk1mmtM7/E2kUrLvSEnjpTurI19cS83WdwMTl1cxn+Rb0ttZlsiom6fqyDPw7OHl2eV/QMDs11enNmsaC4w6Dmg+wq2adFxNemdU6V4/z+Xihg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R62oGebn; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1e834159f40so71368525ad.2
        for <kvm@vger.kernel.org>; Thu, 02 May 2024 23:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714716048; x=1715320848; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4XqJ5Ig2VtkuCWHVeEx2oKL56Rab9Hfay3wXYgXTFUU=;
        b=R62oGebnTPAHCW8rYpOGEmOFrKL1Jv1/haRq6HiuzvQybI0ynY+atVrc/BmF3ceu4u
         +b8OJP8ctTDWJCsUky+mDCcI6GijHuyKg4UdrGCj3KA2vhR2CzieY4V15UYqUWRrizme
         DnEq1NWDRspeoQXm+M14aKL3YyDlJjBS5sCfehcakbkN7lVnyIh7cjmwctf+1oYD0n25
         7ffoU2RE79OEFawwBTQyPbWyHfTzALMDr3yNjCuYW8ni9NR8ou6lnebR7Jzh0/BAIY6d
         pYH9YHGGR0h/yhDxVSwmLnXurmC0CMb+SefMHbEfhH+yBEBvcVAyx7kdY2d7kcRj1+Hq
         01DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714716048; x=1715320848;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4XqJ5Ig2VtkuCWHVeEx2oKL56Rab9Hfay3wXYgXTFUU=;
        b=Hz4a7RHKOc2Ji3TlsTuL9AQT1G3eqvuqNrZr2CW5yfk1z3YTGNMhBDAue7uutnnfC+
         AdYWU37RNSMSeqVbL6RqMHVSdLGy56IkXIRoYtqX0qvIvdsG2tjay4DUS67SjUy/PdrR
         N+FFNwzIeYVHOQi6rZA+/wpGQEzaPEzHu1LKqkmbeD9yt6ksQRnkcawz94dgtZffWazP
         3vzvf3eJjc+WpdeK5aKeF0mFOgEavzvizQfLSv5MCB5RzgnCmUcawBn1mC0XtX+9YjSZ
         W8Co0FG3PWaWLjLstH7HP5brgDTff62+klkHtZas4ol7cnXjly1h07By4RhcXW7azWUs
         BA4Q==
X-Forwarded-Encrypted: i=1; AJvYcCW5z99Qjsr7xbIyiD6DZytDuP+BDxeAPvAs6Qus2UlcqQ2n2tzXQSvFp7qLqLWP+CfV+NkbJDjNXRPo4c7SN0LHEmOi
X-Gm-Message-State: AOJu0YxB3BFncN1WrK2+/0I6L3jbcKeVizYSjkciW91OqSsW58sD8m3c
	5Zy34S/Zl9LreVtVzUE2tqv1PqYIj+MNTi+r3O7sUrIok0Xhhs0E
X-Google-Smtp-Source: AGHT+IGbTVgj2L0F3ykah72Ocm9k+HY2IM0L4lNd2enFW9q5jChRfLBhoJB9VB3s/DK0TBrkVFh0KA==
X-Received: by 2002:a17:902:d2ca:b0:1e4:4000:a576 with SMTP id n10-20020a170902d2ca00b001e44000a576mr1990302plc.43.1714716048321;
        Thu, 02 May 2024 23:00:48 -0700 (PDT)
Received: from wheely.local0.net ([1.146.23.181])
        by smtp.gmail.com with ESMTPSA id y8-20020a17090322c800b001ea963d0d58sm2398536plg.137.2024.05.02.23.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 May 2024 23:00:47 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH] doc: update unittests doc
Date: Fri,  3 May 2024 16:00:38 +1000
Message-ID: <20240503060039.978863-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some cleanups and a comment about the check parameter restrictions.

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


