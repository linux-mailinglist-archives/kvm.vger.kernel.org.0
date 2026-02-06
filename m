Return-Path: <kvm+bounces-70396-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wFaLK9NHhWkN/QMAu9opvQ
	(envelope-from <kvm+bounces-70396-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 02:45:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AA58F901B
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 02:45:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B258E30214FC
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 01:45:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6D762472B6;
	Fri,  6 Feb 2026 01:45:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FE681DDC1B;
	Fri,  6 Feb 2026 01:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770342339; cv=none; b=CRhtbnDzQqvH19A0ZxrMMiU9vWFAKaR1ZUcvvrGNO4KDW6HwgiAJtH1bY78pO4zI7y+PvpD5krqwaio5D7oubiYol4i01f4kYNBrnw6AHj4IoWw0SsW8u6K86gptJRTFhFMyybQt6fvwOkEGCj/Y6g1YZ66u6wJ0yjMvY0mrG24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770342339; c=relaxed/simple;
	bh=ii6RKtFYyE+Ewcaswlc7T5jvksLlmxsqr496cRHnhqY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SMc5DC/sjOBls8Vrb3dGnI1+r9/owNIyYrfWx0yTIlN60E9UoIlaGy5buFGAmtAsF66trwWKc0m+a8S2AeqXgYTJvycSrk9CIFqUHpzB+NJn2hi0J5UxVMKSpl/89trCO3uk/BWvJ+/sBkrnzyyJZjd4jZQwc0QIq/lChQvRICI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8CxLMO5R4Vp1FYQAA--.52757S3;
	Fri, 06 Feb 2026 09:45:29 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front1 (Coremail) with SMTP id qMiowJCx98C3R4VpgLZAAA--.40823S2;
	Fri, 06 Feb 2026 09:45:28 +0800 (CST)
From: Song Gao <gaosong@loongson.cn>
To: maobibo@loongson.cn,
	chenhuacai@kernel.org
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	kernel@xen0n.name,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 0/2] LongArch: KVM: Add DMSINTC support irqchip in kernel
Date: Fri,  6 Feb 2026 09:20:26 +0800
Message-Id: <20260206012028.3318291-1-gaosong@loongson.cn>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCx98C3R4VpgLZAAA--.40823S2
X-CM-SenderInfo: 5jdr20tqj6z05rqj20fqof0/
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_FROM(0.00)[bounces-70396-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DMARC_NA(0.00)[loongson.cn];
	TAGGED_RCPT(0.00)[kvm];
	R_DKIM_NA(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gaosong@loongson.cn,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-0.986];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5AA58F901B
X-Rspamd-Action: no action

Hi,

This series  implements the DMSINTC in-kernel irqchip device,
enables irqfd to deliver MSI to DMSINTC, and supports injecting MSI interrupts
to the target vCPU.
applied this series.  use netperf test.
VM with one CPU and start netserver, host run netperf.
disable dmsintc
taskset 0x2f  netperf -H 192.168.122.204 -t UDP_RR  -l 36000
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate
bytes  Bytes  bytes    bytes   secs.    per sec   

212992 212992 1        1       36000.00   27107.36   

enable dmsintc
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate         
bytes  Bytes  bytes    bytes   secs.    per sec   

212992 212992 1        1       36000.00   28831.14  (+6.3%)

v6: 
  Fix kvm_device leak in kvm_dmsintc_destroy(). 

v5:
  Combine patch2 and patch3
  Add check msgint feature when register DMSINT device. 

V4: Rebase and R-b; 
   replace DINTC to DMSINTC.


V3: Fix kvm_arch_set_irq_inatomic() missing dmsintc set msi.(patch3)

V2:
https://patchew.org/linux/20251128091125.2720148-1-gaosong@loongson.cn/

Thanks.
Song Gao

Song Gao (2):
  LongArch: KVM: Add DMSINTC device support
  LongArch: KVM: Add dmsintc inject msi to the dest vcpu

 arch/loongarch/include/asm/kvm_dmsintc.h |  22 +++++
 arch/loongarch/include/asm/kvm_host.h    |   8 ++
 arch/loongarch/include/uapi/asm/kvm.h    |   4 +
 arch/loongarch/kvm/Makefile              |   1 +
 arch/loongarch/kvm/intc/dmsintc.c        | 117 +++++++++++++++++++++++
 arch/loongarch/kvm/interrupt.c           |   1 +
 arch/loongarch/kvm/irqfd.c               |  42 +++++++-
 arch/loongarch/kvm/main.c                |   6 ++
 arch/loongarch/kvm/vcpu.c                |  58 +++++++++++
 include/uapi/linux/kvm.h                 |   2 +
 10 files changed, 257 insertions(+), 4 deletions(-)
 create mode 100644 arch/loongarch/include/asm/kvm_dmsintc.h
 create mode 100644 arch/loongarch/kvm/intc/dmsintc.c

-- 
2.39.3


