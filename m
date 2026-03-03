Return-Path: <kvm+bounces-72515-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yJg0M9Gzpmk7TAAAu9opvQ
	(envelope-from <kvm+bounces-72515-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 11:11:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 494501EC70E
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 11:11:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9C020305D2AF
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 10:11:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8543C3988EA;
	Tue,  3 Mar 2026 10:11:08 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D886263CB;
	Tue,  3 Mar 2026 10:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772532668; cv=none; b=bO3J2cFx93zKomVNMqf/QTUgckvn5LaQnczb6VJ+YvaUe3fhMJDHTpqkvHaaD6l1KGn46KTb5OGWpqNuzu/CpaPWA4FxfPshOp0tTK1D33y5nssLPtf0bFTawboTB9pXPAqQl7Nv2OI7mR2/t750RTl+phrPGVmhGEfDyn4epwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772532668; c=relaxed/simple;
	bh=OoYFEb9rgjRkpyir6Iz325BhpZXKMZEPiFK8neV5XeY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oE6jP/vmZZLX4hnusCfvPnnIundOOWzI8RX532Ish/YCz5s4ZfuoAQUM9F+O3RPEfK48RzecreFbk3MWMWq5sgY2Qe6TzDdVLVtiTG7GPlVNr8RLicCX+PEIbdziW1maNeK0WQCA+0ho47AtPA+mFjoWN3jicOZ026YQgtIkQkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from fric.. (unknown [210.73.43.101])
	by APP-05 (Coremail) with SMTP id zQCowADHWQ2Os6Zp6paTCQ--.25899S2;
	Tue, 03 Mar 2026 18:10:23 +0800 (CST)
From: Jiakai Xu <xujiakai2025@iscas.ac.cn>
To: anup@brainfault.org
Cc: alex@ghiti.fr,
	aou@eecs.berkeley.edu,
	atish.patra@linux.dev,
	jiakaiPeanut@gmail.com,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	palmer@dabbelt.com,
	paul.walmsley@sifive.com,
	xujiakai2025@iscas.ac.cn
Subject: Re: [PATCH] RISC-V: KVM: Change imsic->vsfile_lock from rwlock_t  to raw_spinlock_t
Date: Tue,  3 Mar 2026 10:10:22 +0000
Message-Id: <20260303101022.2174021-1-xujiakai2025@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAAhSdy1x=4J2fZA-U_nB2yvFP38rmdcwVqYsR7c_6kHQw56+ew@mail.gmail.com>
References: <CAAhSdy1x=4J2fZA-U_nB2yvFP38rmdcwVqYsR7c_6kHQw56+ew@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowADHWQ2Os6Zp6paTCQ--.25899S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZFy8AF1rtrW7Jry3Kw15Arb_yoWDXFcEkr
	Z5KFyxJ3y5Ar1UWrs5Xw1fZF1vkanrAa4xKrWrGFySvryDGFs3GayfKrZ093ZxAw4xG3y2
	krsxJrZ3Xr9I9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbfkFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s
	1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
	w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r4j6F4UMc
	vjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v
	4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64
	vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUeApnUUUUU
X-CM-SenderInfo: 50xmxthndljiysv6x2xfdvhtffof0/1tbiBg0PCWmmd08nhAACsb
X-Rspamd-Queue-Id: 494501EC70E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-72515-lists,kvm=lfdr.de];
	DMARC_NA(0.00)[iscas.ac.cn];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[ghiti.fr,eecs.berkeley.edu,linux.dev,gmail.com,lists.infradead.org,vger.kernel.org,dabbelt.com,sifive.com,iscas.ac.cn];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FROM_NEQ_ENVFROM(0.00)[xujiakai2025@iscas.ac.cn,kvm@vger.kernel.org];
	NEURAL_HAM(-0.00)[-0.531];
	TO_DN_NONE(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_DKIM_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,iscas.ac.cn:mid]
X-Rspamd-Action: no action

Hi Anup,

Thank you for the review and for pointing out the issue.

I've been trying to reproduce the problem following the setup described in 
https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-QEMU.

I tested with this patch applied on two different kernel bases:
1. https://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git master
2. https://github.com/kvm-riscv/linux master

I modified the QEMU command from the wiki to enable AIA:
./qemu/build/qemu-system-riscv64 -cpu rv64 -M virt,aia=aplic-imsic -m 512M \
  -nographic -kernel ./build-riscv64/arch/riscv/boot/Image \
  -initrd ./rootfs_kvm_riscv64.img \
  -append "root=/dev/ram rw console=ttyS0 earlycon=sbi"

Then ran the guest with:
./apps/lkvm-static run -m 128 -c2 --console serial \
  -p "console=ttyS0 earlycon" -k ./apps/Image --debug

In my testing, the guest boots successfully.

Could you please provide more details about your setup so I can reproduce 
the issue?

Thanks,
Jiakai


