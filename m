Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB2F2D9F47
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 19:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408872AbgLNShX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 13:37:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38254 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2440904AbgLNSeV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Dec 2020 13:34:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607970775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+NmuioRXdPzhZhBnp7tfLVLDUjPrKAJC+sD5oIOuUZ8=;
        b=I1qjgVwhUAszkGoXtwgiFs5O9gIM5UTXpSklVmb2z3HQTpCSYH+qttrnJhU9rYY7OfAeuW
        bVKDLBnwPN/aZPoMFrxTPbNJi4RwJ9exI0r1YI4nWdJheQpw+rLoMax5HsY49mtJijTm7J
        M9vm6vL+mbl2LZPs91rOJM3Q7SzQnts=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-mS9S5NL_NwCzwSqmJfjVqg-1; Mon, 14 Dec 2020 13:32:53 -0500
X-MC-Unique: mS9S5NL_NwCzwSqmJfjVqg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7BDA1007315;
        Mon, 14 Dec 2020 18:32:52 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 20C841042A7C;
        Mon, 14 Dec 2020 18:32:52 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Alexander Graf <graf@amazon.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 1/3] KVM: x86: remove bogus #GP injection
Date:   Mon, 14 Dec 2020 13:32:48 -0500
Message-Id: <20201214183250.1034541-2-pbonzini@redhat.com>
In-Reply-To: <20201214183250.1034541-1-pbonzini@redhat.com>
References: <20201214183250.1034541-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no need to inject a #GP from kvm_mtrr_set_msr, kvm_emulate_wrmsr will
handle it.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mtrr.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index 7f0059aa30e1..f472fdb6ae7e 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -84,12 +84,8 @@ bool kvm_mtrr_valid(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	} else
 		/* MTRR mask */
 		mask |= 0x7ff;
-	if (data & mask) {
-		kvm_inject_gp(vcpu, 0);
-		return false;
-	}
 
-	return true;
+	return (data & mask) == 0;
 }
 EXPORT_SYMBOL_GPL(kvm_mtrr_valid);
 
-- 
2.26.2


