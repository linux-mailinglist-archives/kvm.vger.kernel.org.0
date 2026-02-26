Return-Path: <kvm+bounces-71940-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yKDrN1oFoGl/fQQAu9opvQ
	(envelope-from <kvm+bounces-71940-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 09:33:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 851BA1A29E1
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 09:33:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E0B65305E9E9
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 08:33:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6297B393DCD;
	Thu, 26 Feb 2026 08:33:08 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD7B30E0F2;
	Thu, 26 Feb 2026 08:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772094787; cv=none; b=HAyzwP2GeiheEEZT79m/Qw1Hz8xG7H2ksuocF/X0qMWIQU1+7AAhAdhp6vHzlVZnttBsrQ7DUJShjfxmNA/0k9rAX6fzBI9xjGNX/2KIB1boSNtYA9NuPsP2zlFCt//pd0cOyNm+51ldhQ5/1D6H8e8TvVKVN+2Zn33wg8mUlNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772094787; c=relaxed/simple;
	bh=ou8kaKh0y+sm0A1WxELVKOCVT78NAFXtma2CnMhH3s4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CFdmbrbitz/TjyEa0ecTi2is9Sohm0A9PumrtyEKzDSaP7pjJI0XICLqC0Xm1uRxi2QgMuQ5cCoaA1zg++zLbr0bjiGPDOs9w3wupiBWhiDVKHpRS86iyStJub6IwJOQneAN8oU2uiMjQM8VSUCDOCbbZkYNhhPR9H7H8B3LO3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from fric.. (unknown [210.73.43.101])
	by APP-01 (Coremail) with SMTP id qwCowAB3HWkjBaBpUDDFCA--.13513S2;
	Thu, 26 Feb 2026 16:32:36 +0800 (CST)
From: Jiakai Xu <xujiakai2025@iscas.ac.cn>
To: linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Alexandre Ghiti <alex@ghiti.fr>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Jiakai Xu <xujiakai2025@iscas.ac.cn>
Subject: [PATCH v8 0/3] RISC-V: KVM: Validate SBI STA shmem alignment
Date: Thu, 26 Feb 2026 08:32:31 +0000
Message-Id: <20260226083234.634716-1-xujiakai2025@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAB3HWkjBaBpUDDFCA--.13513S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Gw4DZFW8ZFyDCr4UJFy5Jwb_yoW8Jr4rpa
	93Ca4FgFy8JayxA3Z3Aw4ktryfWw48CrsFyw17t342yayUKFy8trsrKFWUAa43GF1kXFs0
	va4xKa4ruF98ZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
	rcIFxwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JU6c_3UUUUU=
X-CM-SenderInfo: 50xmxthndljiysv6x2xfdvhtffof0/1tbiCQ4KCWmf1uCqDAAAsi
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
	TAGGED_FROM(0.00)[bounces-71940-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xujiakai2025@iscas.ac.cn,kvm@vger.kernel.org];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,iscas.ac.cn:mid]
X-Rspamd-Queue-Id: 851BA1A29E1
X-Rspamd-Action: no action

This series fixes a missing validation in the RISC-V KVM SBI
steal-time accounting (STA) register handling.

Patch 1 validates the configured SBI STA shared memory GPA at
KVM_SET_ONE_REG, enforcing the 64-byte alignment requirement
defined by the SBI specification or allowing INVALID_GPA to explicitly
disable steal-time accounting. This prevents invalid userspace state
from reaching runtime code paths and avoids WARN_ON() triggers during
KVM_RUN.

Patch 2 refactors existing UAPI tests from steal_time_init() into
a dedicated check_steal_time_uapi() function for better code organization,
and adds an empty stub for RISC-V.

Patch 3 fills in the RISC-V stub with tests that verify KVM correctly
enforces the STA alignment requirements.

Jiakai Xu (3):
  RISC-V: KVM: Validate SBI STA shmem alignment in 
    kvm_sbi_ext_sta_set_reg()
  KVM: selftests: Refactor UAPI tests into dedicated function
  RISC-V: KVM: selftests: Add RISC-V SBI STA shmem alignment tests

 arch/riscv/kvm/vcpu_sbi_sta.c                 | 16 ++--
 .../selftests/kvm/include/kvm_util_types.h    |  4 +
 tools/testing/selftests/kvm/steal_time.c      | 84 +++++++++++++++----
 3 files changed, 83 insertions(+), 21 deletions(-)

-- 
2.34.1


