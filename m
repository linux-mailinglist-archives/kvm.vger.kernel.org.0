Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEF630DD80
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 16:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233504AbhBCPCy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 10:02:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233232AbhBCPCw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 10:02:52 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C284C061351
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 07:01:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ReK5thv1qXOwz+4YkuKyfjPNJ1MbHAE+zDofKyksugE=; b=luIfNr7/TV3HKkwxcUZBlAjsDy
        TlFcx8YrZWUYlcjQNSbgttbaC7F4OcSBWeAVLgXOtRL0bPGCwd9zoZELmCYJWXqPbjtzsIhpSR9u+
        0ctmDaF+FVKQL4GtZxFTvjUAZhQV9ooDPIvYJNDEjYEJ/i98BJxjI040nka1505yChGsnseNkxXIc
        8QLacxF/SWY2N6343VTThaU/ETfb0aZI1zEyNHp0aZsYMenTl2FFIRJGuPagY31qDBUKmgZ8vXEyf
        2w1BHA+cE8kWWtQ8kcXR4oVw7zjtpcQ7SlnHmQrEsoX5DL8lKmaAETHVe0IYl+4KpMtlmFiAFeEJv
        MBwbLmQw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l7Jef-00H3zG-F2; Wed, 03 Feb 2021 15:01:19 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l7Jef-003reD-2V; Wed, 03 Feb 2021 15:01:17 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Subject: [PATCH v6 02/19] KVM: x86/xen: Fix __user pointer handling for hypercall page installation
Date:   Wed,  3 Feb 2021 15:00:57 +0000
Message-Id: <20210203150114.920335-3-dwmw2@infradead.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210203150114.920335-1-dwmw2@infradead.org>
References: <20210203150114.920335-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

The address we give to memdup_user() isn't correctly tagged as __user.
This is harmless enough as it's a one-off use and we're doing exactly
the right thing, but fix it anyway to shut the checker up. Otherwise
it'll whine when the (now legacy) code gets moved around in a later
patch.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/x86.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 40be21f7c359..6f8aaf5860a3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2853,8 +2853,8 @@ static int xen_hvm_config(struct kvm_vcpu *vcpu, u64 data)
 {
 	struct kvm *kvm = vcpu->kvm;
 	int lm = is_long_mode(vcpu);
-	u8 *blob_addr = lm ? (u8 *)(long)kvm->arch.xen_hvm_config.blob_addr_64
-		: (u8 *)(long)kvm->arch.xen_hvm_config.blob_addr_32;
+	u64 blob_addr = lm ? kvm->arch.xen_hvm_config.blob_addr_64
+		: kvm->arch.xen_hvm_config.blob_addr_32;
 	u8 blob_size = lm ? kvm->arch.xen_hvm_config.blob_size_64
 		: kvm->arch.xen_hvm_config.blob_size_32;
 	u32 page_num = data & ~PAGE_MASK;
@@ -2864,7 +2864,9 @@ static int xen_hvm_config(struct kvm_vcpu *vcpu, u64 data)
 	if (page_num >= blob_size)
 		return 1;
 
-	page = memdup_user(blob_addr + (page_num * PAGE_SIZE), PAGE_SIZE);
+	blob_addr += page_num * PAGE_SIZE;
+
+	page = memdup_user((u8 __user *)blob_addr, PAGE_SIZE);
 	if (IS_ERR(page))
 		return PTR_ERR(page);
 
-- 
2.29.2

