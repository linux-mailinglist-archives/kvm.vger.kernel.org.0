Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951F23A20EF
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 01:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhFIXp0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 19:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbhFIXpR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 19:45:17 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B54C061574
        for <kvm@vger.kernel.org>; Wed,  9 Jun 2021 16:43:11 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id k16-20020ae9f1100000b02903aa0311ef7bso15095389qkg.0
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 16:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ActxyiNIAcKHyidC7LFkIvgoRqVhbyRGA66pjNXcgQE=;
        b=m07n+P+gFAsAJyhYlFLQ9ZQrL75NF7caFSlvPHloWwX3zHtXO4cbiRRCpbNQ0CVclM
         Cx5o6D+MnSCtYDGyj8nYX4pcYiYc5I9DceQ2rAA4KmVGM5o02u+qlo9IuiS+LTQ5NQN9
         J7/Sy+zysap40wxcRdjNFLQs40StLgmMm5U4OjYIGZF5rMyYp7UcvaQUeVK6ma1h3pk5
         iE5z3JUX0ZWsaLac5W/G7x1ieWfyUeCY7ymkW4rtzvWmNBlYJ+aARI1a+ujs2PhEIvg/
         JVkDI5PXrVqVJjwDq/ZVqMr7jglH3bUMKpTLUb+idz2IpfjW2fs0pmFhDFBqD2WPUUYU
         5XkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ActxyiNIAcKHyidC7LFkIvgoRqVhbyRGA66pjNXcgQE=;
        b=EPSySAH42/76NB7oXIz7C3kcw+lhR5w/Mu2c0HS0lhaBJa9Bd2cIX5wDFXVme71ZGc
         oUIBqkDsXi1WIeIJYovmT5NKKWBLUiFHTuM208yyuIvtj7H3EOBNBCSlBVisQCW1f9tv
         UoaL1o7QXiiAOCkjkIwkfiFSFviMT+iWbvd9gZekk4jlv5jQP467E4qJ4Gm6hMYWAd+1
         69E6S0Vxaz0dhuiIy9MGq/653CdBSmDMWpWXzT2J44Pabu4jGBtvF+sKPZsOQ+juH8t2
         /dq70rdO0Xo7zoqu0sYBOI4Imx7NUXhdop4e+tM/w78hx4Kx6WmmVbNuQwjMMKFNwAld
         EE3w==
X-Gm-Message-State: AOAM533cz85PCm8lVEsfInr5cWFPG8jaGjTxeLCD5RHU+amgw8dW46ip
        yqieWBb4znrvPeEatu1Jz2r982v4MCI=
X-Google-Smtp-Source: ABdhPJzmrF3mElvNIB2Fkk21bCN8biEs9twT/HY2vEYwJLImwQzdCDYt5p3QSFOLneMFNnnfPZroTu4kslw=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:8daf:e5e:ae50:4f28])
 (user=seanjc job=sendgmr) by 2002:a0c:eda5:: with SMTP id h5mr2604134qvr.26.1623282190465;
 Wed, 09 Jun 2021 16:43:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  9 Jun 2021 16:42:32 -0700
In-Reply-To: <20210609234235.1244004-1-seanjc@google.com>
Message-Id: <20210609234235.1244004-13-seanjc@google.com>
Mime-Version: 1.0
References: <20210609234235.1244004-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 12/15] KVM: x86: Defer MMU sync on PCID invalidation
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Junaid Shahid <junaids@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Defer the MMU sync on PCID invalidation so that multiple sync requests in
a single VM-Exit are batched.  This is a very minor optimization as
checking for unsync'd children is quite cheap.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9620d8936dc4..d3a2a3375541 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1096,7 +1096,7 @@ static void kvm_invalidate_pcid(struct kvm_vcpu *vcpu, unsigned long pcid)
 	 * happen anyway before switching to any other CR3.
 	 */
 	if (kvm_get_active_pcid(vcpu) == pcid) {
-		kvm_mmu_sync_roots(vcpu);
+		kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
 		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 	}
 
-- 
2.32.0.rc1.229.g3e70b5a671-goog

