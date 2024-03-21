Return-Path: <kvm+bounces-12357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A47D28855A3
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 09:26:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A29D1F23C41
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 08:26:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D1E869314;
	Thu, 21 Mar 2024 08:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="d9I+3wG3"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1c.mail.yandex.net (forwardcorp1c.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564CB2AF18;
	Thu, 21 Mar 2024 08:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711009592; cv=none; b=BvgHDXAeFG9+ywatzoAgAywFxi6MMmXRd/PF1pfUL/FN5YFoE0jBH4GdjeqviXjP1Ckng4mN4E0/Osa/Tf0mMDKAlJaZa9uKh5QmTi4xBY7tu4pQOiBL6YLNkFUYIeojBpxzVW44qNdc+E2IyyCBPoXCZlC5OWirEzY8X55fNH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711009592; c=relaxed/simple;
	bh=o7eLeeb73ije49Oi1IJyOnTmSadKsQM6b8k54OUj5ME=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ilP98SwEEJ1krDgG1NdHR2NZYYk+/7MgywVnwsQMiAHCZUY6XFOc8SiRjVa580290Zxo5tlSxv95Fnii/JAqLBBc+1Uu+ZYKQRumXSdjyRawhNuDL/zTx3h1xqyKmWLOQFiCLxsYIKIEcVTVW9l3Pl3YQBsXBZxyik/P5AGqPOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=d9I+3wG3; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-main-62.myt.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-62.myt.yp-c.yandex.net [IPv6:2a02:6b8:c12:400c:0:640:9907:0])
	by forwardcorp1c.mail.yandex.net (Yandex) with ESMTPS id 3B20A60C14;
	Thu, 21 Mar 2024 11:24:58 +0300 (MSK)
Received: from d-tatianin-nix.yandex-team.ru (unknown [2a02:6b8:b081:b674::1:39])
	by mail-nwsmtp-smtp-corp-main-62.myt.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id oOB6eO0Il4Y0-TeYwma2u;
	Thu, 21 Mar 2024 11:24:57 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1711009497;
	bh=4y4z1WbAJjObghcOw14l3LhaD/LDb5HVnVDoPNdghx0=;
	h=Message-Id:Date:Cc:Subject:To:From;
	b=d9I+3wG3sJfM+lF+n68sGZ2T1AAbNEbyUZ/HzjHSXkwmFiX5tVYCC5rFC1mlitPpl
	 hOxbRP/fmOWtfduXN+FYhwkZfV1V995Ezu9y0hv7YC1DkHHytkZelxaU/EeuUqHBC2
	 ZCMuLbNwZpD/va6Lm/suO312NsiVUxATCcCKnpWE=
Authentication-Results: mail-nwsmtp-smtp-corp-main-62.myt.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Daniil Tatianin <d-tatianin@yandex-team.ru>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Daniil Tatianin <d-tatianin@yandex-team.ru>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yc-core@yandex-team.ru
Subject: [PATCH] kvm_host: bump KVM_MAX_IRQ_ROUTE to 128k
Date: Thu, 21 Mar 2024 11:24:42 +0300
Message-Id: <20240321082442.195631-1-d-tatianin@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We would like to be able to create large VMs (up to 224 vCPUs atm) with
up to 128 virtio-net cards, where each card needs a TX+RX queue per vCPU
for optimal performance (as well as config & control interrupts per
card). Adding in extra virtio-blk controllers with a queue per vCPU (up
to 192 disks) yields a total of about ~100k IRQ routes, rounded up to
128k for extra headroom and flexibility.

The current limit of 4096 was set in 2018 and is too low for modern
demands. It also seems to be there for no good reason as routes are
allocated lazily by the kernel anyway (depending on the largest GSI
requested by the VM).

Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
---
 include/linux/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 48f31dcd318a..10a141add2a8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2093,7 +2093,7 @@ static inline bool mmu_invalidate_retry_gfn_unsafe(struct kvm *kvm,
 
 #ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
 
-#define KVM_MAX_IRQ_ROUTES 4096 /* might need extension/rework in the future */
+#define KVM_MAX_IRQ_ROUTES 131072 /* might need extension/rework in the future */
 
 bool kvm_arch_can_set_irq_routing(struct kvm *kvm);
 int kvm_set_irq_routing(struct kvm *kvm,
-- 
2.34.1


