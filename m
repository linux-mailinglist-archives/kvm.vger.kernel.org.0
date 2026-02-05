Return-Path: <kvm+bounces-70279-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uJZ/IgTtg2lavwMAu9opvQ
	(envelope-from <kvm+bounces-70279-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 02:06:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CE42EED8FC
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 02:06:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6947F3020D60
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 01:05:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63E3A221F24;
	Thu,  5 Feb 2026 01:05:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2469F13957E;
	Thu,  5 Feb 2026 01:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770253524; cv=none; b=SwA/cWpSKBGBhuz9C5POTC3szurHyx64VLK/UW1DO+qcyODfnCnSmJhuJ0Bb0RZDQsV99Hr+oJ8yI6RJVOi8pl1RCjybJB7ApeMhQRiZXIy3EhujiwbGiuYufrZ817ClI2P4+KZUliNRdRasNBW02Xo4CGGTQeunm0Nj+KPnL1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770253524; c=relaxed/simple;
	bh=czFVKYU7XbuTrd+l9yaMK/RrteJThaDaySfDIbnSPF4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qfj/XbFvUw3ndPfT9kveWxgrwQ14GojKEd1YfHQWB2Rg7G3CuErV7UqpupwzIdiS8Rr/03omvGKxUFL/fy7dtkeClED2UKgLuvcMSJ+tGNLBd5k3vUsQSQ63kWJ0pOKWXhBk9qeSrToZa5BjVN+5x9xH/y4hgdju5y4tgQDUnAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from fric.. (unknown [210.73.43.101])
	by APP-03 (Coremail) with SMTP id rQCowACXt97A7INpzKW1Bw--.43975S2;
	Thu, 05 Feb 2026 09:05:04 +0800 (CST)
From: Jiakai Xu <xujiakai2025@iscas.ac.cn>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Cc: Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <ajones@ventanamicro.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Jiakai Xu <xujiakai2025@iscas.ac.cn>
Subject: [PATCH v6 0/2] RISC-V: KVM: Validate SBI STA shmem alignment
Date: Thu,  5 Feb 2026 01:05:00 +0000
Message-Id: <20260205010502.2554381-1-xujiakai2025@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowACXt97A7INpzKW1Bw--.43975S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Gw4DZFW8ZFyDCr4UJFy5Jwb_yoWDKrgE9a
	4IyrZ8Xr4UZF42vFZ2kw4DXrWrKw4xG3ZFgF1jvF129rykZFWUW3Wkuw1YvFyUJw4rC3sx
	ZFsYv34furyY9jkaLaAFLSUrUUUU1b8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbyAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2kKe7AKxVWUXVWUAwAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY
	62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7V
	C2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0
	x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7AKxV
	W8ZVWrXwCY02Avz4vE14v_KwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8
	JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1V
	AFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xII
	jxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4
	A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU
	0xZFpf9x0pR6yxiUUUUU=
X-CM-SenderInfo: 50xmxthndljiysv6x2xfdvhtffof0/1tbiDAcJCWmD6tsHrwAAs4
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_NA(0.00)[iscas.ac.cn];
	RCVD_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	TAGGED_FROM(0.00)[bounces-70279-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xujiakai2025@iscas.ac.cn,kvm@vger.kernel.org];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.976];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,iscas.ac.cn:mid]
X-Rspamd-Queue-Id: CE42EED8FC
X-Rspamd-Action: no action

This series fixes a missing validation in the RISC-V KVM SBI
steal-time accounting (STA) register handling.

Patch 1 validates the configured SBI STA shared memory GPA at
KVM_SET_ONE_REG, enforcing the 64-byte alignment requirement
defined by the SBI specification or allowing INVALID_GPA to explicitly
disable steal-time accounting. This prevents invalid userspace state
from reaching runtime code paths and avoids WARN_ON() triggers during
KVM_RUN.

Patch 2 adds RISC-V KVM selftests to verify the expected behavior,
ensuring that misaligned GPAs are rejected, aligned GPAs are accepted,
and INVALID_GPA correctly disables steal-time accounting.

Jiakai Xu (2):
  RISC-V: KVM: Validate SBI STA shmem alignment in 
    kvm_sbi_ext_sta_set_reg()
  RISC-V: KVM: selftests: Add RISC-V SBI STA shmem alignment tests

 arch/riscv/kvm/vcpu_sbi_sta.c                 | 16 ++++++---
 .../selftests/kvm/include/riscv/processor.h   |  4 +++
 tools/testing/selftests/kvm/steal_time.c      | 33 +++++++++++++++++++
 3 files changed, 48 insertions(+), 5 deletions(-)

-- 
2.34.1


