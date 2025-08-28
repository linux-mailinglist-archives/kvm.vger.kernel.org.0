Return-Path: <kvm+bounces-56168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F2D9EB3AA73
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 20:58:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1679A1C8047A
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 18:58:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EFD430E0D3;
	Thu, 28 Aug 2025 18:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UZ5pXECe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C736C24A046
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 18:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756407505; cv=none; b=XGXd6jitGehQpK27UIkNRAEj/9TesX2JPjvBXGuidjtmMztDDYzsSyxsWdwXzc1IArS65/CeHHnCgXa8v+dPJQlko28ucuoHr6eYAQOKNgOwxa3GvPDcQ5S7lJ5GFnuW/M/k4i8Z+J3lmnmMbWGFZIGi6dlT0xAf3OqhjCaM1nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756407505; c=relaxed/simple;
	bh=XkBAFTLQCIq9QSeNk92D9or1TzMH1cHo7Lh9QpbseJM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=o29rN8zAat2CTF4P2Z8t/OolJ19ZoEvz2veeASwoy7UKYhw0+R1e+Xu7AxIXYeVPmqd6ZrdK3KXbzbCFFFlTzEadX7S7j+2Coo/QNJgIlhaGhFPIyPJrSMl1vP7S4kcodDuBALYQpZMifB4Fz7yGgIzZw30Xfsigl0UsxCZSuH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UZ5pXECe; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-248942647c5so24330635ad.0
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 11:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756407503; x=1757012303; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MBY7cXhgfR8O2W9m1pTJItAJLq+HckTk69hf+0g/I+w=;
        b=UZ5pXECerqmCYeVY5+ZUuxKR6/QAwslRC0FOAbxSsfsA0BgqxSBUE62sK0cVkG/ztG
         wesoGxdrj3i3+0SD79quTANbuwLTX8I5qTBcK26FEi1HuZHZyQ+8v3cq2D+tsX/m/m8Z
         9C5XxrEpOa95xFg7KRLn9iKOMCcTyjlprqOaCznHcwODuQQY/pAbTzmMBa8YiWcGCYZ7
         fxio3H39Qx8NpfOXWMavR0OjYER7I4Kb7ODlWVnW6lpetyfZ2eEVAR3GlIJnVGtisS0j
         apw+bvKiQ6ytWGVQC+ua4ZXceL68q0BmFmV1hzEBLHU4ARMuDCANrXK5+AHvftg5X7tA
         GZsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756407503; x=1757012303;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MBY7cXhgfR8O2W9m1pTJItAJLq+HckTk69hf+0g/I+w=;
        b=Q7bo+msVYpsgsfGpeYWC6NHAwtukbhflhYmVWykpwbeCrMy7EIJY2PKW88knQPDOg4
         mArD8p8aFP5I/4yjvLj4edRSt7+Aum7lVcGVG0fE4d1xXMayND1lrFA/964uxDB+rXnW
         76SIdOWtYLDDeX46ek9Hk+poghiunqeZRfiF+EgxnveJpZ+mm17lkYws21UPtctvDzi1
         LEN/7rAxHNS3EAZnMeOWLkxVbgiFAbhpv2CIEWl7Lco9AZZwBqWPHD5JMe7KOlAmzPgj
         jRrnjsIpYq0HzhUB8siaXuhiauVfuXHKHmiIoJ13u3TR3RDXNIzeEzU4NKrbi7i/zyp3
         OTog==
X-Forwarded-Encrypted: i=1; AJvYcCXBVcUOHAlYEVXhMiNRSZmCna0vPkHAigEuhNFQPHp6aNDnejOhBkKRTnJzPBWS+nk0jhc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOdnBtwN5jPP3qFm3JrIpkXxaE+gc05lUhgdzD85BmW58ie0lK
	Vn6sdSjHO/fXNwoabiUc3gejXSNw7q46s7D5CDPQ8k80nPdxWv56naZ8pJZnRLhEw+LIfr0ZUiq
	8/g1KLSd+8FCuWw==
X-Google-Smtp-Source: AGHT+IHhpR4oJ/EC2/otIYb/KR914MTWCOL9TcmyuO6XcuOdl4LhwB4VzDj+gKcUoeDe7/miOrFCELKO1RQ1Dg==
X-Received: from pjboh8.prod.google.com ([2002:a17:90b:3a48:b0:31f:26b:cc66])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e743:b0:248:eb3e:54d6 with SMTP id d9443c01a7336-248eb3e64e9mr29915525ad.21.1756407502941;
 Thu, 28 Aug 2025 11:58:22 -0700 (PDT)
Date: Thu, 28 Aug 2025 18:58:14 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.338.gd7d06c2dae-goog
Message-ID: <20250828185815.382215-1-dmatlack@google.com>
Subject: [PATCH] vfio: selftests: Fix .gitignore for already tracked files
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: David Matlack <dmatlack@google.com>, kvm@vger.kernel.org, 
	Shuah Khan <skhan@linuxfoundation.org>, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"

Fix the rules in tools/testing/selftests/vfio/.gitignore to not ignore
some already tracked files (.gitignore, Makefile, lib/libvfio.mk).

This change should be a no-op, since these files are already tracked by git and
thus git will not ignore updates to them even though they match the ignore
rules in the VFIO selftests .gitignore file.

However, they do generate warnings with W=1, as reported by the kernel test
robot.

  $ KBUILD_EXTRA_WARN=1 scripts/misc-check
  tools/testing/selftests/vfio/.gitignore: warning: ignored by one of the .gitignore files
  tools/testing/selftests/vfio/Makefile: warning: ignored by one of the .gitignore files
  tools/testing/selftests/vfio/lib/libvfio.mk: warning: ignored by one of the .gitignore files

Fix this by explicitly un-ignoring the tracked files.

Fixes: 292e9ee22b0a ("selftests: Create tools/testing/selftests/vfio")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202508280918.rFRyiLEU-lkp@intel.com/
Signed-off-by: David Matlack <dmatlack@google.com>
---
Note, this is on top of the vfio/next branch so I'm not sure if the hash
in the fixes tag is guaranteed to be stable. It might be simpler to
squash this into commit 292e9ee22b0a ("selftests: Create
tools/testing/selftests/vfio") before sending the pull request to Linus.

 tools/testing/selftests/vfio/.gitignore | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/vfio/.gitignore b/tools/testing/selftests/vfio/.gitignore
index 6d9381d60172..7fadc19d3bca 100644
--- a/tools/testing/selftests/vfio/.gitignore
+++ b/tools/testing/selftests/vfio/.gitignore
@@ -5,3 +5,6 @@
 !*.h
 !*.S
 !*.sh
+!*.mk
+!.gitignore
+!Makefile

base-commit: 9f3acb3d9a1872e2fa36af068ca2e93a8a864089
-- 
2.51.0.338.gd7d06c2dae-goog


