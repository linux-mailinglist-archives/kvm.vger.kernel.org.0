Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922AC30E82D
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234104AbhBDACN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 19:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234076AbhBDACJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 19:02:09 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01A5C061786
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 16:01:28 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id dj13so787148qvb.20
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 16:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=xlob3SxVBzuk6VwhTKCHNdeQ5cEpkkL7dVmYnzLmun0=;
        b=pCmvpt0R661t/A0DjVN4wniue+VW7yOO9Lz/O/Xm7JfDLttlBTqYdxSlV4GkuGR9jU
         a9LIq3BEDUe05rDusUEU75qDQiaYVUHS5bzdEMX2FPjZg/CXoLDQt9rij4eoLs7LfDHp
         Ezuk43HAN3Mk/CHRnVJaAezIf+YKeVexCGCml8eMfx+1Q97YlZfVLpzkk8RmoTwuMjfU
         QtfryjianriFO4Q3xaHTUV4y+VfFuhfxjsiC4u2Tk2Sp4SXp/mStsWuD49fY5yi+naxC
         43HAuW+/GDYbShHoazRXNnYzbynTUSSiXnKWWUgeY9sHLK8j+MOEXQrBTX/OCDVzraAz
         LBJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=xlob3SxVBzuk6VwhTKCHNdeQ5cEpkkL7dVmYnzLmun0=;
        b=WmLEmf3fFP0n1J93PQGbQz2UOrdvShsNf0zKQ0AkRrh69tS56MFyPUNeWmfVgjlWZX
         dU7MWyAwJ+IdghFYV9s2WGhBpettYFGS/TW+d7JhtrQ8aDAKWvOkTdpWjvLJpMIqWYiH
         Q+BernHmYU4qO/R3IhI8uptPX776zrtHX1MYIZSQgKqVJmBB6y0SKRod6emJVk8D0K5i
         xDFPBNHKCCNLkfDRxDFxsWtXL4k1V0iqhHqhPYiegakF2aPCCFb0+rikMk8iQzOaqSa/
         VBMi5+KfHw7AF9Pui8G3NNCSvW49sm3u0si+dwPvXPma2zb2iRDucpCXW7h4vzYWCJBv
         JiWQ==
X-Gm-Message-State: AOAM5330czn1lcZpfRb3rAX+aV01P2/q49dYUZLIg2pKNQj9AaLj4fTa
        6CAlfo12GJ1eP7vNzUloU/7//LBtHgQ=
X-Google-Smtp-Source: ABdhPJwbxo0jhQm0FLX75tZWB7FNsV1Ul3pvxTbJF9kRwBzPSD9aQGisdB56VNOpsohROXiIsNxiNEsR3GQ=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:a9a0:e924:d161:b6cb])
 (user=seanjc job=sendgmr) by 2002:a0c:c78c:: with SMTP id k12mr5114776qvj.47.1612396888075;
 Wed, 03 Feb 2021 16:01:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  3 Feb 2021 16:01:06 -0800
In-Reply-To: <20210204000117.3303214-1-seanjc@google.com>
Message-Id: <20210204000117.3303214-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210204000117.3303214-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH 01/12] KVM: x86: Set so called 'reserved CR3 bits in LM mask'
 at vCPU reset
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set cr3_lm_rsvd_bits, which is effectively an invalid GPA mask, at vCPU
reset.  The reserved bits check needs to be done even if userspace never
configures the guest's CPUID model.

Cc: stable@vger.kernel.org
Fixes: 0107973a80ad ("KVM: x86: Introduce cr3_lm_rsvd_bits in kvm_vcpu_arch")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 667d0042d0b7..e6fbf2f574a6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10091,6 +10091,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	fx_init(vcpu);
 
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
+	vcpu->arch.cr3_lm_rsvd_bits = rsvd_bits(cpuid_maxphyaddr(vcpu), 63);
 
 	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
 
-- 
2.30.0.365.g02bc693789-goog

