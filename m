Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDE13143A9
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 00:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhBHXYN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 18:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbhBHXYL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 18:24:11 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1E2C061788
        for <kvm@vger.kernel.org>; Mon,  8 Feb 2021 15:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=5L36mpGr/XPL+7u4b7c8E9IqKbgHh8wd3Yu65g/6LgY=; b=nfMTmm7EN2xiw77Xfi8XdFbZzW
        8PQlObbdIkRIwTxcHHCQX9wnrkhqFUD2HvdToLWNnOCrBwBUNDWf1WOM4VTj7zBpEHhel01GvODhH
        JOU7jQX5efR+DB+HZhi3nFHdv1RLZWBXx8ECL68LUqfvarZ7SxszINQQPLq0fsPvncVQBdEaP2SF7
        9eQgyh6nVyLCFW/+tRLlhENiS7QVCS53MKp8BUu6VeN/ktt6AWgeNaI7jSGrI0E4nl4M+mnHBeRfr
        86NcCyCHFvn2DjrqKGXWYvX/U5FvAAb6+NCZe8ufXJXLB+chU8uEjtanPDdfbNY1AXTDS1oQ+MqKn
        9eIsBBIg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l9FsO-0002eQ-1d; Mon, 08 Feb 2021 23:23:28 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l9FsM-007gAt-Vk; Mon, 08 Feb 2021 23:23:26 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Subject: [PATCH 2/2] KVM: x86/xen: Remove extra unlock in kvm_xen_hvm_set_attr()
Date:   Mon,  8 Feb 2021 23:23:26 +0000
Message-Id: <20210208232326.1830370-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210208232326.1830370-1-dwmw2@infradead.org>
References: <20210208232326.1830370-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

This accidentally ended up locking and then immediately unlocking kvm->lock
at the beginning of the function. Fix it.

Fixes: a76b9641ad1c ("KVM: x86/xen: add KVM_XEN_HVM_SET_ATTR/KVM_XEN_HVM_GET_ATTR")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/xen.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 06fec10ffc4f..d8cdd84b1c0e 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -105,8 +105,6 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 
 	mutex_lock(&kvm->lock);
 
-	mutex_unlock(&kvm->lock);
-
 	switch (data->type) {
 	case KVM_XEN_ATTR_TYPE_LONG_MODE:
 		if (!IS_ENABLED(CONFIG_64BIT) && data->u.long_mode) {
-- 
2.29.2

