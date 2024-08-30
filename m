Return-Path: <kvm+bounces-25539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7E32966626
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 17:54:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9156128128B
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 15:54:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 625CB1B86D7;
	Fri, 30 Aug 2024 15:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="W0VFZAWK"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BE01B6552
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 15:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725033226; cv=none; b=jIuucGeJ+T4Bkl0ly3wxr7BdxFt6RMt5+uAJk8Z34RWZQyQN5tVwTgGI63LTJc52q/W54+skusZ7jWjUMbWy9bwibCgoDKapEWc3ZqwzJi/fiqY/6f/s3WDWq8r4arykmQaoWRiC6XTbJqSavPP0HibAC7zd8os36mxE3tZiD4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725033226; c=relaxed/simple;
	bh=q1wHv3wRdnPu4MEXSXZB1ZG7nptt1B+2p4uTXhFm90A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YSUO1Bc1gVXffwKiD1g/dwD7K9hP56e7V/OA2TNUKIgEznQUz4HO8tbqWyWdwm/jVRNV2NPUZ5bra2uj3uX0gsoBD9G1g481vyKuP4qtEPP4Gq6MArY3/YlQ3S7I/Kvpplk3bparkv3t2rcJY10zTjPnonP4LUAZi95vqmQT3Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=W0VFZAWK; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725033220;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Q9nQeTHXBGHtyPPVkhzzSyXEl/OipGutGOZazJvHdCU=;
	b=W0VFZAWKkdS/jVo9XpCgFsBpBrNU334DJF7B39wWRKNssviGn03cWHxTAgd5rMDzN4Uihy
	Fe7sCPdEfg8v1Sy87dcNCinpw97e2vYQV1H1k4Z4dTnmJpiVlizCQ0oY0zg+dG0yOsaG00
	O5s8r1GcS2PJAWekhV+aIlfOoFXucXw=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 0/2] riscv: sbi: Rename sbi ecall wrappers
Date: Fri, 30 Aug 2024 17:53:38 +0200
Message-ID: <20240830155337.335534-4-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Just some renaming to improve readability and also add another DBCN
test to ensure we only write a single byte with write-byte. Use the
"raw" ecall for that because sbi_dbcn_write_byte now takes a uint8_t.

Andrew Jones (2):
  sbi: Rename __*_sbi_ecall to sbi_*
  sbi: dbcn: Add write-byte test with more than byte given

 riscv/sbi.c | 48 ++++++++++++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 18 deletions(-)

-- 
2.45.2


