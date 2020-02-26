Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A25EF1702C2
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 16:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgBZPjb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 10:39:31 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:41394 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgBZPja (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 10:39:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=WkRU+rCfqZmSiK2T/WyxuA5RO2CVcs+N/iUY+k8Bf6w=; b=VAxOAnW9pzTfuKbV+ZL+X4PvH1
        W9K6olNaZozucBl5tM0rP97/7AIiCC2wehQYtiI/3pg0Y9j5nWbKoAjIRAAlcsKP5Al3Zx0Flmkjp
        EPwKob8UwqDLMtoHWC1zXmmrnyoc1eWUeKk8mAvPerkADPxf2TZJOSPKuJfZZBcsra3bd3mFwTEYE
        7x6vQBzPwzNU9Z3zR9S5lvR2X0hxQgGfSFoTgqCnBtT3gZre3ddfhBgMcKUAmih2aLnT3mQrC+3WO
        /YC3vQ3BpKZkNLgbBr8ax0E1NRV+2nWLe87NfJqAm0qskdqxU4W93CDwBAPYtXpwC2J49SS/55Kon
        b+JOhB2w==;
Received: from [4.28.11.157] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6ymY-0000Y3-7U; Wed, 26 Feb 2020 15:39:30 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     torvalds@linux-foundation.org
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Revert "KVM: x86: enable -Werror"
Date:   Wed, 26 Feb 2020 07:39:29 -0800
Message-Id: <20200226153929.786743-1-hch@lst.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This reverts commit ead68df94d248c80fdbae220ae5425eb5af2e753.

Using the brain dead Werror flag fixes the build for me due to mostly
harmless KASAN or similar warnings:

arch/x86/kvm/x86.c: In function ‘kvm_timer_init’:
arch/x86/kvm/x86.c:7209:1: error: the frame size of 1112 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
 7209 | }

Feel free to add a CONFIG_WERROR if you care strong enough, but don't break
peoples builds for absolutely no good reason.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/x86/kvm/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 4654e97a05cc..b19ef421084d 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
 ccflags-y += -Iarch/x86/kvm
-ccflags-y += -Werror
 
 KVM := ../../../virt/kvm
 
-- 
2.24.1

