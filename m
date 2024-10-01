Return-Path: <kvm+bounces-27727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EDE698B35D
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 07:04:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3756283FF4
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 05:04:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 534B61BE860;
	Tue,  1 Oct 2024 05:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="W6bw8Nid"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD181A3BDA;
	Tue,  1 Oct 2024 05:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727758939; cv=none; b=IucSap/jv0sqAEufqkysAveyZtpa3QHUB7n14Sm8dB9dwksxzPc1TMCuNx1evQ6Khjag25O660BgXengZrUqoxct8/uhH34kqZMOGdSolMrtJoxZI6lHKpCdjQKq/FGhmaQUadnYWoLeDJIhhQWSOby/zqpiPTQPDgCSgPEvd78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727758939; c=relaxed/simple;
	bh=D0M8MUphEJDzt0DhRWl6jjrN238HMRnD/K9ryJpI3N4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IalPto9jy2L87LrivdAvxIlrTyJtS+kH2VAJk3M84QP90TAzfjEhqimzVxMsWake+RHuzUXlKKyLs7tcmxQ98I7m7EUKgKKpY5xhdxqa3bnGXzruJ+O+zLmoT+iY6gJq/XtEdwEOuyHpqA5jNfK5DLHrNv7E+rBMlCu2SY9z8eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=W6bw8Nid; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 49151A7V3643828
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 30 Sep 2024 22:01:21 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 49151A7V3643828
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024091601; t=1727758882;
	bh=9fOauzGby+rPmCjUXvj6urYAJT7PhTs9glaZ68z8kxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W6bw8NidU/8g0afX5F7UrR84tBgi/aIhFmJnSwqaANZ3dnAsl8yNSMcv8rwT3kE51
	 QhnOT1CT/dKFOr0CYmL+s8MRxUyFbmZgny5LX9fL+Pb5+EyIsvN2h5zeb9tg6AC2oL
	 X5xIyfVZAyFGSjRYa0vKYoWjQcF7ZuqemSipFrZ+R1I6/6++M0yFHf4mF2TPaDHVJq
	 pHl9J3Qf7KooHgnhihh0RpetfXzYYADDaYyiurm7qgplwct6ihEz+DspZ31KSX9QgK
	 +AYNB8kcef9l8y5gKQPpHU8MHbPaZfDrPTR02uj5/OdhpuDc3RosKNc6ZrEonaDWSz
	 qtSHPHc98Evtg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, xin@zytor.com
Subject: [PATCH v3 06/27] x86/cea: Export per CPU variable cea_exception_stacks
Date: Mon, 30 Sep 2024 22:00:49 -0700
Message-ID: <20241001050110.3643764-7-xin@zytor.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241001050110.3643764-1-xin@zytor.com>
References: <20241001050110.3643764-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The per CPU variable cea_exception_stacks contains per CPU stacks for
NMI, #DB and #DF, which is referenced in KVM to set host FRED RSP[123]
each time a vCPU is loaded onto a CPU, thus it needs to be exported.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
---
 arch/x86/mm/cpu_entry_area.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/mm/cpu_entry_area.c b/arch/x86/mm/cpu_entry_area.c
index 575f863f3c75..b8af71b67d9a 100644
--- a/arch/x86/mm/cpu_entry_area.c
+++ b/arch/x86/mm/cpu_entry_area.c
@@ -17,6 +17,7 @@ static DEFINE_PER_CPU_PAGE_ALIGNED(struct entry_stack_page, entry_stack_storage)
 #ifdef CONFIG_X86_64
 static DEFINE_PER_CPU_PAGE_ALIGNED(struct exception_stacks, exception_stacks);
 DEFINE_PER_CPU(struct cea_exception_stacks*, cea_exception_stacks);
+EXPORT_PER_CPU_SYMBOL(cea_exception_stacks);
 
 static DEFINE_PER_CPU_READ_MOSTLY(unsigned long, _cea_offset);
 
-- 
2.46.2


