Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A35442077
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 20:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbhKATHx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 15:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbhKATHv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Nov 2021 15:07:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1ADC061764
        for <kvm@vger.kernel.org>; Mon,  1 Nov 2021 12:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=I5MO6Kjs8ztHhQHRFKG7EtQl7QsFAAABR/vPWt03KwE=; b=NKGSQsj9goon5+a4A6dTSHrW5U
        HC1LtCa7F9/9bVnfdsEb5gOFtCenONivDcXgnMQQyVBK8any8mMu4TNKtAgnTwhdOHtC5HpPeeIqX
        tzED5VrLUAwfR6sLyjn7QHsSeHyBUpY2aHOQ8DKbr8i/886JvI6ZJyn0yVxlubLTUE2CSJBodyO+T
        gbiBSTiTK+htX0kfziUdW3oj04c4hPPQfT5NonXmuuo4ppZZsMYZ/hdw3PHSa+GDIbDOhHFRbY/8O
        WecKd0bhH8Bvu8CC6aMxgXyC6R06FuRjKx8mRciVyw5U+tgAC72qNNXzK90GVj2/F6j73HnFrgqmQ
        cdC281DA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mhcaS-003xXb-NK; Mon, 01 Nov 2021 19:03:37 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mhcaS-0004hN-9L; Mon, 01 Nov 2021 19:03:16 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        KarimAllah Raslan <karahmed@amazon.com>
Subject: [PATCH v2 1/6] KVM: x86/xen: Fix get_attr of KVM_XEN_ATTR_TYPE_SHARED_INFO
Date:   Mon,  1 Nov 2021 19:03:09 +0000
Message-Id: <20211101190314.17954-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211101190314.17954-1-dwmw2@infradead.org>
References: <20211101190314.17954-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

In commit 319afe68567b ("KVM: xen: do not use struct gfn_to_hva_cache") we
stopped storing this in-kernel as a GPA, and started storing it as a GFN.
Which means we probably should have stopped calling gpa_to_gfn() on it
when userspace asks for it back.

Cc: stable@vger.kernel.org
Fixes: 319afe68567b ("KVM: xen: do not use struct gfn_to_hva_cache")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/xen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 8f62baebd028..6dd3d687cf04 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -299,7 +299,7 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		break;
 
 	case KVM_XEN_ATTR_TYPE_SHARED_INFO:
-		data->u.shared_info.gfn = gpa_to_gfn(kvm->arch.xen.shinfo_gfn);
+		data->u.shared_info.gfn = kvm->arch.xen.shinfo_gfn;
 		r = 0;
 		break;
 
-- 
2.31.1

