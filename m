Return-Path: <kvm+bounces-18586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBA1F8D7589
	for <lists+kvm@lfdr.de>; Sun,  2 Jun 2024 15:07:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75E47282515
	for <lists+kvm@lfdr.de>; Sun,  2 Jun 2024 13:07:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B98973BB47;
	Sun,  2 Jun 2024 13:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LjSHyxM7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECCF10795;
	Sun,  2 Jun 2024 13:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717333628; cv=none; b=B0h1pnc1RwDKy4lRD532chGSthpiQAlO6cjUsgC+ApEa2vCj0FFijt58PTgqvvr1mLqaFLUjSIgbI1stD7BsoKrLuKrzraTcollMTbJ1KdKeR6UHJI6pjNvCF31t44/Rat2qqPVtuXgpsUn8YKaSR9UOLE86wnx7JDcKHFMVaLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717333628; c=relaxed/simple;
	bh=aY7CQ+CS/XzCddbkwvf0PWttaiGsxO0EhZdaJhOqjqM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RDGQqweCoTO/vYyYXcUF41219gET7j/fWqgqWcv6PEBLS6odImkyJHsxygG5095qpebdTuYJxN5183crYOoOOjiv8lU6gfoo4DxtSz/Q71V0uxIFyPWJ1Y4Vn03SQy0hW9QdW44ZVm3AT954KhKcSquxeCM0cAJzIFM1jxcBU7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LjSHyxM7; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7024d571d8eso1585742b3a.0;
        Sun, 02 Jun 2024 06:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717333626; x=1717938426; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CMkM9MlfzZgVeRATvWg/i192TocPTMl3rDUbRmtFlWs=;
        b=LjSHyxM72B/REVY6veHNOdBfmAQlIOJQPRoS0f2ty6Jn82xD0y1F02iMmK8Q6BcZE1
         gTmIyHkCVFq9uvHWeOLgRn7285R3JHJ/tyqa/n4MDF6RZ1h9s4s59K8zBodB7tSRj3Wj
         H3IQlmw1VB5ak71MaOmL1ZRS6zoTZhhbUNNmZgwtg+0aUC6peAxdewAjiNw9oJ70z9C1
         ty+2cAGPPrRGyFhrH2ikrKQReWwLnirVmxZ+hB/tSN473Ap1P8772zsCoYhURVbUDcN5
         IlsWKqElTC1yt4QDZYhCUSJMSHweJhyhdcq5o9LHtFR+8aYQj/tsGpUrvwE6M/W8aZiv
         rQ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717333626; x=1717938426;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CMkM9MlfzZgVeRATvWg/i192TocPTMl3rDUbRmtFlWs=;
        b=bQDMpzYIY1e2y8G+fP8wKuFZVDVsUdudrzN8/iU6lmj3k48qCFYsaseKkxbKl2kn65
         GFzJRufo9BM6srHJBm4eFmO6vNdpKW7X76milKLiQMME/+QTTYP14VJKMcTfkRgWECSI
         XQJN1nD8JQGUbhkgEkp7P4POWwysU0RBDoJqXMFQu8oBrxF7UwIgZXQyr0iCSc7Jcky+
         Xk+obTG0wTP8dc72gWPUkBXCU/R2LKAi6odn0mx3wADvQZ4xkOv9lJhSl/GaTQg4hgsj
         3DNVS9ZFRrac/DwV4yXPx18u3UzheBdOMsXGh9fib4GElXD6e9lJ4/z5DgYUJVCRDOap
         Ck5A==
X-Forwarded-Encrypted: i=1; AJvYcCU27l/yZ8OkuRhueS3KZkwTWuzCPXFcE23xXZuyQRICSFKu5k/32ZI0qxHRtLg3ugDKnoDtabGqLhoeB1lEMoo/z5Z4
X-Gm-Message-State: AOJu0YwziQrmYqggw0VPa+8us9KUqquPlkQqxT4pEZEwXXB+uKmaJXIj
	CZtwp+Gbip44/GisCnJsZf3mt854y7HgGLa7zEK830AswOCC6aNRJRyIqQ==
X-Google-Smtp-Source: AGHT+IHilXfcyVdJ7ke4pl/6A2uKMzXmBLcCjxQZli5l55Q2C/oPFSBVr4q0nF1BAkO6aXNupdN6/A==
X-Received: by 2002:a05:6a20:8415:b0:1a7:2e17:efd3 with SMTP id adf61e73a8af0-1b26f0ec4b0mr9143866637.5.1717333625498;
        Sun, 02 Jun 2024 06:07:05 -0700 (PDT)
Received: from wheely.local0.net (110-175-65-7.tpgi.com.au. [110.175.65.7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-702423cf27fsm4138655b3a.12.2024.06.02.06.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jun 2024 06:07:05 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: linux-s390@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 0/2] s390x: Fix build error messages
Date: Sun,  2 Jun 2024 23:06:54 +1000
Message-ID: <20240602130656.120866-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This fixes some non-fatal error messages during build. I have only
tested TCG with no PV, so it's not intended for merge before
that at least.

Thanks,
Nick

Nicholas Piggin (2):
  s390x: Only run genprotimg if necessary
  s390x: Specify program headers with flags to avoid linker warnings

 s390x/Makefile              |  4 ++++
 s390x/snippets/c/flat.lds.S | 12 +++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

-- 
2.43.0


