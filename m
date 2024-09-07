Return-Path: <kvm+bounces-26056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EDD9596FF23
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 04:13:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1FE4E1C225D8
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 02:13:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDBB312B8B;
	Sat,  7 Sep 2024 02:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mtwnK1Mn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDB079C4
	for <kvm@vger.kernel.org>; Sat,  7 Sep 2024 02:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725675210; cv=none; b=iU0FYVaKmxVZBN76Xp2u3a2z8Hub6gZa86rLcn0mkpsw1ddukFuPZMkMw/O0Shdt+b+hXq1tur9pMsR9wu9OFkKuATFl8rfGkzei6+IvouKnxLB5JC5VV2Id4vaHbK/Mx3DllxFTF/hd7qMAAuJ8tPLghJNOk16eTewFGJqb5Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725675210; c=relaxed/simple;
	bh=SNOvhoYBB5SJDHIbHpS0QV9aIJV6NfHYZGJgFdzLauo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=QqNdlTNslZpR0sw+ZH49xmkOUbi10ZTBbs3e9wY8xMmKcDZJyItqXS3asjYOLXSPSl/K4+Vd3hhIu6WFpexSoupXiZNtVoaCC7XoG2AN3lcRuAYEP9OovX86MLluJvkAn7bz6sRmma2n14EQYOoMINzCr+5gRkV5H4iwbLGLz5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mtwnK1Mn; arc=none smtp.client-ip=209.85.214.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-2057835395aso24774205ad.3
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2024 19:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725675208; x=1726280008; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=psYR6Fpa2WL2j1KoF7tx9o28WzrEhoxZkZBKoH4RuSc=;
        b=mtwnK1MnmdMjaE1Efu1HmswkPfAFATDpPi+m+XZrbbS1vuMhtlRUG8KR8XYX1NvJun
         s48Uk78RBxzop6nuZCQVCpHNQg9iNkYgmEe0XeDa23A+/X6wId9/fEmrfylxbhQlcbKf
         4pVfqytil8euHBc0lZbzUswX0ExTHulKKH+LNjfKeMpKntAqGfVZ4Ii75RqL1Kyi9YDD
         7gG+9KqcrVXw/Bz7Ub+AakdPF02hZed0TSasW8He980JtjKvEb/YhHH5FGjQC5EgjT8R
         bSX3XHU+JNoGywxiH7ZppfzYmqaNQhs5uwtQn3piiMsNLHVLp0A8dKa57+XZ6tgFckP8
         1Feg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725675208; x=1726280008;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=psYR6Fpa2WL2j1KoF7tx9o28WzrEhoxZkZBKoH4RuSc=;
        b=nEu3QywDoQsvkjdVqhMli76NLIQkuDjVNY34BPeLQ6UhLD6yR+6OXaqUxUQTUN3rW2
         FYRLkKrW1uzNG+S6QicJR7fsrUuqqWCLsfYJG8rLzchyuegRmDAIFM+gvyfeErggUvCX
         DiXJNtoqyP82F1KA7BMSurIlqOnXUB2qRRBcGO7ULdBwZkyqP1TK7O68Z9v0Pih6dFgB
         tN6xP1MUqTRl/nfJRxLt1b+lJQsjo+U/8uYanWQH/n2YfO2jQzsuEhiV3sH4giFw2MID
         yEq3f8M7ln+u62rOFn6GG9bDb5Lox9ebJeQj1BXUzUQLikaD1/s6OgcfARtocEPwfU88
         xzcw==
X-Gm-Message-State: AOJu0YyTruyr3/DUiUx+0YFUXv7RQi8GlW97ndjET3S8v4xokPlReUbg
	5ctjKy2R/XGOT1NoRP4lHI0Zrgg390w/KDJd594hXkksjty/l2GZpnOTOciW
X-Google-Smtp-Source: AGHT+IGWQqweig6NVDeHkvCxqzD6zKhjRjNZzBhiz4FNxgcl1DB95/oyhzgRr+d8c/ChlCI91eHfuA==
X-Received: by 2002:a17:903:3693:b0:206:b399:2f21 with SMTP id d9443c01a7336-2070a7e51aamr11868295ad.43.1725675207391;
        Fri, 06 Sep 2024 19:13:27 -0700 (PDT)
Received: from localhost.localdomain ([14.154.195.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20710f20104sm1215845ad.233.2024.09.06.19.13.26
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 19:13:27 -0700 (PDT)
From: Dongli Si <sidongli1997@gmail.com>
To: kvm@vger.kernel.org
Subject: [PATCH kvmtool v2 0/4] x86: Fixes issue with only one CPU available in kernel 6.9
Date: Sat,  7 Sep 2024 10:13:17 +0800
Message-ID: <20240907021321.30222-1-sidongli1997@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On x86 architecture, starting with Linux 6.9, using the "noapic" kernel
command line parameter will result in only one CPU being available, which
is currently the case with kvmtool, and this series fixes this issue.

v1 version is here:
https://lore.kernel.org/all/20240819010154.13808-1-sidongli1997@gmail.com/

Changes since v1:
 - Improved the subject and description of some patches

Dongli Si (4):
  x86: Set the correct srcbusirq of pci irq mptable
  x86: Add the ISA IRQ entries of mptable
  x86: Remove the "noapic" kernel cmdline parameter (for enable the IO
    APIC)
  x86: Disable Topology Extensions on AMD processors in cpuid

 x86/cpuid.c   |  3 +++
 x86/kvm.c     |  2 +-
 x86/mptable.c | 23 +++++++++++++++++++----
 3 files changed, 23 insertions(+), 5 deletions(-)

-- 
2.44.0


