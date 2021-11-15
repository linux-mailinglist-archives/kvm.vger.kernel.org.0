Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C06E450A1D
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 17:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbhKOQyU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 11:54:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbhKOQxn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 11:53:43 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082E9C061767
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 08:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=I5MO6Kjs8ztHhQHRFKG7EtQl7QsFAAABR/vPWt03KwE=; b=LgQs+f31kMuZwVYBf7bjlQNIu5
        wE13F4D/p5HYG0YE4XR04OUiyzktOvgXNiGKp9HdVWZLL8gM2B71ltDQd+5NaxPQToQJqrNaiY7Ah
        u+cVxJpggPxbtgLGzQ5ZygbyzJ1nGktNiY0GUuyASnNaIXlmMZulMSrnTJrBWsAqz5vHHTFl7Vakc
        JFpzmN5r2kySMa9rw+5LkhB9a97DfRc8ulOZxRQZu84PTvQ2SY/rnVsOJ1BGV9PC9VgKKfkOtY4uu
        pVYyujpsLt1Fta0VEM96sbvWeFkE41CANasHhKmaMWi8KIby3j+5nkB4ttU7i8EcoDRjrhvX/FqFP
        aYYEPeCA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmfBe-00GAg6-OQ; Mon, 15 Nov 2021 16:50:30 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmfBe-0001wW-EH; Mon, 15 Nov 2021 16:50:30 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com
Subject: [PATCH 02/11] KVM: x86/xen: Fix get_attr of KVM_XEN_ATTR_TYPE_SHARED_INFO
Date:   Mon, 15 Nov 2021 16:50:21 +0000
Message-Id: <20211115165030.7422-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211115165030.7422-1-dwmw2@infradead.org>
References: <95fae9cf56b1a7f0a5f2b9a1934e29e924908ff2.camel@infradead.org>
 <20211115165030.7422-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
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

