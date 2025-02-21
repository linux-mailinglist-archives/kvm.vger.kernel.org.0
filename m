Return-Path: <kvm+bounces-38873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DE15AA3FB65
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 17:34:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A2111884AAC
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 16:28:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3E771E7C1E;
	Fri, 21 Feb 2025 16:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="D828hQ75"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48429442F
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 16:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740155281; cv=none; b=jL+aC35IIVLOMvYvhmGejAHUhrMAOoucTEDz2iBl5bvy2I9UZNfmcMg8KzaMtcoprcqC9WIErFXiz97Xko4WJtS5PHbJY/kKafXqOIIFypfBamHEvG2M8Snmqd9cSx1HgpIl/BhpfKanMl26y4lRvQtgXTbTm30eK/cKPBxov30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740155281; c=relaxed/simple;
	bh=AMxR5ZSQxPzg55A/d06ZNoezPQDhKj5nrMW5f/fdjoA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DGTIJYtQ2oH+cP+XJSui0rJf3Syth/2pXpI9f5Jjh5SrsEQItaC6QJ5N2PZ0j4D0t2BYfejOt19tX2rzAXnYX8db0T65qTYAt9+N9MqC1QdKK2EU7WIbyhKIDvF5lre7dmZbVMTFpbB+1xq7GG2kdpI1Hi63Q74pB1cQ2PxwIBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=D828hQ75; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740155277;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nvihCTLUnpjmg13KE8NiIArlIRl2NHcMe9sLvn5Y8Zc=;
	b=D828hQ75x7LcOdaHJUuv76LZ+nhQ8J8i5aSAy56h5icG2a3z371jSsXKTo/xvKiOMfb03n
	+n5E3c5bSCajtQAXd17J+nj4FAGLlOTFGxjBu1nKXL1xxRFVF3WoIyo/cEpDFsrYEqfKlV
	O/MyDN77kIR7K5XqOhTjQ58Vd911NTI=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	atishp@rivosinc.com,
	cleger@rivosinc.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH 0/2] riscv: Run with other QEMU models
Date: Fri, 21 Feb 2025 17:27:54 +0100
Message-ID: <20250221162753.126290-4-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Provide a couple patches allowing a QEMU machine model other than 'virt'
to be used. We just need to be able to override 'virt' in the command
line and it's also nice to be able to specify a different UART address
for any early (pre DT parsing) outputs. 

Andrew Jones (2):
  configure: Allow earlycon for all architectures
  riscv: Introduce MACHINE_OVERRIDE

 configure | 88 +++++++++++++++++++++++++++----------------------------
 riscv/run |  6 ++--
 2 files changed, 47 insertions(+), 47 deletions(-)

-- 
2.48.1


