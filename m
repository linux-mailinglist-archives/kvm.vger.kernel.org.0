Return-Path: <kvm+bounces-69243-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IAV5Gxm1eGlzsQEAu9opvQ
	(envelope-from <kvm+bounces-69243-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 13:52:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ED61694864
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 13:52:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 216D93051D00
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 12:51:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFD0A3563C2;
	Tue, 27 Jan 2026 12:51:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6987B34CFAF;
	Tue, 27 Jan 2026 12:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769518294; cv=none; b=qjlydjkVkCl2hmfs0fnZZR4dvuuIayep4jeaSjiB8Dodx68SalGYRsHtuyQHNhXYXtc5oo22D/GLRv8YB4CEZRJQ+c/djrCEPKVjPHQsAhH8qpmIEm3enoY2ex7LVHSDF0XMW63sdO35VyJRVXXzPnc2uvM6a7OTLxAiKTByZp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769518294; c=relaxed/simple;
	bh=cTZGm8jJRhVzmq5B5yqfHKHSgkjUudLOWfPO51Zf+NM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=b7SCz0jJAgftjj5hnUBzCSa/TN9hV6z9iqYh9E4OSe6QlZLO3szXq0gXk7OHHe7rue4cPqNKNMu8QZLNo/Wvb89kOOmUsjNfFjUWFF6zYHlRERcaV8OLh8DSVfxWN+IHkapmOqeHLINVLhgIFYy/QgmVaI65zVaai/TWohQlaCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Axz8PNtHhpKR4NAA--.43177S3;
	Tue, 27 Jan 2026 20:51:25 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJAxWcHMtHhpYpo0AA--.24006S2;
	Tue, 27 Jan 2026 20:51:25 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v2 0/3] LoongArch: KVM: Add FPU delay load support
Date: Tue, 27 Jan 2026 20:51:21 +0800
Message-Id: <20260127125124.3234252-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxWcHMtHhpYpo0AA--.24006S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	DMARC_NA(0.00)[loongson.cn];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-69243-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.997];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NEQ_ENVFROM(0.00)[maobibo@loongson.cn,kvm@vger.kernel.org];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,loongson.cn:mid]
X-Rspamd-Queue-Id: ED61694864
X-Rspamd-Action: no action

FPU is lazy enabled in KVM hypervisor. After FPU is enabled and loaded,
vCPU can be preempted and FPU will be lost, there will be FPU exception
and FPU load again.

Here FPU is delay load until guest enter entry.

---
v1 ... v2:
  1. Keep funtion trace_kvm_aux() with FPU restore called still, only
     remove preempt disable/enable API call.
  2. Use one KVM_REQ_FPU_LOAD request bit and add fpu_load_type int
     type, remove KVM_REQ_LSX_LOAD/KVM_REQ_LASX_LOAD request bit
---
Bibo Mao (3):
  LoongArch: KVM: Move LSX capability check in LSX exception handler
  LoongArch: KVM: Move LASX capability check in LASX exception handler
  LoongArch: KVM: Add FPU delay load support

 arch/loongarch/include/asm/kvm_host.h |  2 ++
 arch/loongarch/kvm/exit.c             | 15 ++++++++---
 arch/loongarch/kvm/vcpu.c             | 39 ++++++++++++++-------------
 3 files changed, 35 insertions(+), 21 deletions(-)


base-commit: fcb70a56f4d81450114034b2c61f48ce7444a0e2
-- 
2.39.3


