Return-Path: <kvm+bounces-29919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 390949B40ED
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 04:16:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F25E12838CD
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 03:15:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0696620101C;
	Tue, 29 Oct 2024 03:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FTHuSNJ6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7CE1FCF49
	for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 03:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730171650; cv=none; b=njRODY3lixl6s5Lw6xt9js03dUeqpYFTn0WS8YaK+RwX2uUDRaJSkoOga6diXfXbAil8tJT5+TuyK3LDJdC2n1uo1Ob/bPj/Bx58UrLiKvfRBAPwuHfAqzpWehZpKDX+Q/MPAcnboCeNrxLTlCLIWcX5r64IUByjmaLNn3JJ4vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730171650; c=relaxed/simple;
	bh=e3mnB95l0+StkHV8WW0Kyb3JcGNBepgPCH3LG4uxrl0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Um0gNPdxuFo2n8hInK+nGa9hII33I1qjEMATJJgnZDr6cn/ZPB0FsJ48W9KV9fNjZCM6/uRCYBaxqa8GqMBpUZO/QebDw38Mc99WGg6DyI1E11YqNNPJNP+3Qikm2dQkb2MoaZX1Uwz0v62lPYLu5jDXo4n0AqsilMJ9b/oEqRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FTHuSNJ6; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-20e6981ca77so53354535ad.2
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 20:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730171647; x=1730776447; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hY0U2BSY5rjzdYRiUNE/NnDc+Aaii3oMoTVczkWgK4w=;
        b=FTHuSNJ67zaIA9cG0k+vQwxZIexe1ZNPTSC1HUo51rwacuTIKUQAlAzQu1PGrr5CKB
         2AdRcoFcJM136+545QgL49uxIfwivO5CVlLc8eluNYHdca9NQKD0iI4jhCe2DedZoSJc
         brl3sP2C6vhQ4bZWcW7QI7Qk1RZNjUk7gw9CwNUjVZDTgSwZSNvqa7jm5mLQcdk0cGNj
         jlab/0aA9YcAUNyFpd8wzENuRABg/V00OtPPgZwi+RP6WSEijDiR4wil9FBj7BlKg6f3
         S2QjDkneRyomWhhM5YUC1Nb7CQkqKnPuG1PKTghH8Pg6ibXGwIwtrB3gKfL0yitTV04K
         atbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730171647; x=1730776447;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hY0U2BSY5rjzdYRiUNE/NnDc+Aaii3oMoTVczkWgK4w=;
        b=Jh8dbMpp6UFUcrlBOJivQsEdS6wAMGAdxlRqi1Buonu75TgrA9IAQEzJHuy4zUBvN7
         Jz3QEjhECt4wFl7k3B+9UVk1gxrFVkp+3XLieyY+iMYgyV3/Luq6Ul4l+sQgus38E/2g
         K/g6yIQubjpEW78ZZf9gtd05VUdIRYDN/tMoEA0j+zAXjn0fV9YtMlK9bzVykbixmyJh
         f+3udNnw6vqNxZUtZJxhXz+ENfQjPqRZei4qi2eLIxxtt8DgmGLkn0dzLxTnCjbLrlV0
         A0c4v1bFSZA6gzgHjq+IBi3zCK98can9sWSDEn2sE0x59GNT2UmBFcEjR3LAI4xlMG9A
         6Bfw==
X-Forwarded-Encrypted: i=1; AJvYcCVB3K3fA0ob7O6sFxioH5Rh1eu7YKUym8UJdhAsD0afyKAReVmpMhb1jwsNhQHxrpXLiqk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLYNsdqiFm4psBXGwzobS4aTR54vW+P0t4CqkNW2HrjG7lsIzN
	uydGSdLoHMUSKhbSUtFlUhQFTaLCHNBELIPFf3SjHtP8Ku08FMlK
X-Google-Smtp-Source: AGHT+IEcaIAHMs9BJckxJcfP/0G9ohWgYCacVX5fo5xhpPCQT8jOd4bxSJfsC481VrVhw4ZvtEhEjA==
X-Received: by 2002:a17:902:d486:b0:210:e8b5:1363 with SMTP id d9443c01a7336-210e8b5136emr21879435ad.55.1730171647513;
        Mon, 28 Oct 2024 20:14:07 -0700 (PDT)
Received: from localhost.localdomain ([14.22.11.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-210bbf43476sm57300795ad.24.2024.10.28.20.14.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 20:14:07 -0700 (PDT)
From: Yong He <zhuangel570@gmail.com>
X-Google-Original-From: Yong He <alexyonghe@tencent.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: wanpengli@tencent.com,
	alexyonghe@tencent.com,
	junaids@google.com
Subject: [PATCH 0/2] Introduce configuration for LRU cache of previous CR3s
Date: Tue, 29 Oct 2024 11:13:58 +0800
Message-ID: <20241029031400.622854-1-alexyonghe@tencent.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yong He <alexyonghe@tencent.com>

When running function loading inside VM without EPT supported,
we found shadow page table rebuilds are very frequent even
only 3 process running inside VM, such as kvm_mmu_free_roots
if invoked frequently.

PTI is enabled inside our VM, so 3 process will have 6
valid CR3s, but there are only 3 LRU cache of previous CR3s,
so this made the cache is always invalid, and the shadow page
table is frequently rebuilt.

In this patch we enlarge the number of LRU cache, and introduce
a parameter for it, so that user could enlarge the cache when
needed.

Here is context switch latency test of lmbench3, run in Ice
lake server, after enlarge the LRU cache number, the switch
latency reduced 14%~18%.

process number     2      3      4      5      6      7      8
LRU cache = 3    4.857  6.802  7.518  7.836  7.770  7.287  7.271
LRU cache = 11   4.654  5.518  6.292  6.516  6.512  7.135  7.270

Also, the kvm_mmu_free_roots reduced from 7k+ to 60, when running
the latency test with 4 processes.

Yong He (2):
  KVM: x86: expand the LRU cache of previous CR3s
  KVM: x86: introduce cache configurations for previous CR3s

 arch/x86/include/asm/kvm_host.h |  7 +++---
 arch/x86/kvm/mmu.h              |  1 +
 arch/x86/kvm/mmu/mmu.c          | 40 +++++++++++++++++++++++----------
 arch/x86/kvm/vmx/nested.c       |  4 ++--
 arch/x86/kvm/x86.c              |  2 +-
 5 files changed, 36 insertions(+), 18 deletions(-)

-- 
2.43.5


