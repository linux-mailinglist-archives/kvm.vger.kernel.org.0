Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5CB54BE5C
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 01:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353655AbiFNXeJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 19:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345988AbiFNXdu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 19:33:50 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037914ECEE
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 16:33:48 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id m5-20020a17090a4d8500b001e0cfe135c7so181630pjh.3
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 16:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ucyUYE+avnReV/NlugmT9mH5RtL+uAsCDPn2qHXO7FY=;
        b=WYXQVMEwjEHCcw1xxT86Vbs65AyUV4XX/jqrw2OhnJ2yWc+nuEGi1LzBDzL1VNHUat
         SOsARc5BcIYIu00/qktAcem1AixZ+bd62CREEN7pPxuiyNJADuE6vWxJnrvbbd6k546g
         zuA8ps8/bhPBaTI5RmPuFdCGm19v6h6ixk6FWu7HW384NK5/kf758VPBArrbQaElA94N
         m9uYbDGk4vpaNKpApnXRZKjtSwANe1/h5dCidROCRz31+w1mDghD43UaIq7VjOvpF8Uh
         qBG0tQZW02WzL0ij0S8m1xmps03iZEEthOTb7OEbe06rl16Nd7PIXgNwe5hmOmHXOxxN
         ASbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ucyUYE+avnReV/NlugmT9mH5RtL+uAsCDPn2qHXO7FY=;
        b=Z7BBkAN1AvtWqihxJoSr6WXc9jMgXSpCXgdnm01GmSldCjxTN7YTgPkexxCJdOfWHi
         Us3cDPmHD6hydGqly8ViJlDvZQDXnJdpb47c5Ax1b9+H81faEB/mES24e6BaXnp1RUdX
         R5c5WHUeUX1rmyHecIFnmtp36isbX7OFlSS0JfbQsQWa0doN42Iey+WD0c3pjIK4KJjx
         lIjPIotc3D1yyRAjiFajt+ZAk670NeApyV1Psmu0mnBgAh+0hZ+7rFPeMGSRxVYDe/67
         C6WXGefii3jiVwHagD89M9M2B7Y2l6+OjRP9UkpPlyGslGdyY1Oj1NMZQr6E2rCa0vj/
         vFVQ==
X-Gm-Message-State: AJIora+mCGcVRyQGGPDg8Jr2AhCLcvWFSDoA3vTpGbHWorrdSf7l7PYQ
        dhrxW1rg273qxvdSMwvXtewv9usVL2E=
X-Google-Smtp-Source: AGRyM1t6JM382xs2x35j07siN8YES1LgIQ/Ay+Nj6j4kpinOigsWY0dTNThe+vHwxLcBC5qtiQiVJFXmqK4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:1c8:b0:167:67ff:323d with SMTP id
 e8-20020a17090301c800b0016767ff323dmr6319364plh.22.1655249627503; Tue, 14 Jun
 2022 16:33:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 23:33:27 +0000
In-Reply-To: <20220614233328.3896033-1-seanjc@google.com>
Message-Id: <20220614233328.3896033-8-seanjc@google.com>
Mime-Version: 1.0
References: <20220614233328.3896033-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 7/8] KVM: x86/mmu: Truncate paging32's PT_BASE_ADDR_MASK to
 32 bits
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Truncate paging32's PT_BASE_ADDR_MASK to a pt_element_t, i.e. to 32 bits.
Ignoring PSE huge pages, the mask is only used in conjunction with gPTEs,
which are 32 bits, and so the address is limited to bits 31:12.

PSE huge pages encoded PA bits 39:32 in PTE bits 20:13, i.e. need custom
logic to handle their funky encoding regardless of PT_BASE_ADDR_MASK.

Note, PT_LVL_OFFSET_MASK is somewhat confusing in that it computes the
offset of the _gfn_, not of the gpa, i.e. not having bits 63:32 set in
PT_BASE_ADDR_MASK is again correct.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 4fcde3a18f5f..3ed7ba4730b4 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -39,7 +39,7 @@
 	#define pt_element_t u32
 	#define guest_walker guest_walker32
 	#define FNAME(name) paging##32_##name
-	#define PT_BASE_ADDR_MASK PAGE_MASK
+	#define PT_BASE_ADDR_MASK ((pt_element_t)PAGE_MASK)
 	#define PT_LEVEL_BITS PT32_LEVEL_BITS
 	#define PT_MAX_FULL_LEVELS 2
 	#define PT_GUEST_DIRTY_SHIFT PT_DIRTY_SHIFT
-- 
2.36.1.476.g0c4daa206d-goog

