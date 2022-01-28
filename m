Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC0749F00B
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 01:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344987AbiA1Ax6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 19:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344852AbiA1Axl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 19:53:41 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01526C061765
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:31 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id a4-20020a17090a70c400b001b21d9c8bc8so5216349pjm.7
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ADtLnC7rC8gu4V3bqeDUD4mAscpBUdWqwAs1PraRCkw=;
        b=psBjtOn9J3Eh3Pc/Ropdvm/BqO87KA3r+8yOwYWROS23VFm73VLstZCUXjP/dFRh8F
         8ERZZ2QL+QUFnFMuuObpzcU/ekomsr9qzaElPaq7dW1KmvYjIZXrUfWwNCdAXjDCX63/
         IoNOJAow/rQCZHMeFBP0P6WR/WxLXjmR5hseiFjx2utGWmQ0yapCh5sC/utnNUIXywgU
         ychZGErvItyZZZPpHjs90XKvs5DZCcbWSxxek9qogRhY+n0mMX+NHoDr7ycekmCEpUqs
         sZFzHI2nvqdF6SK58p0wdaqv9vm+gbdog+pBj77Hufu+UOZp/21JYkK1+poMKoah3Ipe
         dltw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ADtLnC7rC8gu4V3bqeDUD4mAscpBUdWqwAs1PraRCkw=;
        b=ZU1ykrHuFmBqUb73p6NP58qCMsUDQnwzFFfQGaAQ8ErqjLc7fBM7tbDFkmLhuRpE6a
         UUlFKEnPetoJqTiEhpXCN43gjHTvCskePQudTZimrygWdTU6Sid7GGd9XhSZAB+HzqYf
         uMXbeJCE8RIrQ18MQ9kOAzihQjVSPemyizzmKDQxoRre4o1CLNs7Ptsg6z2HTXrlSwaC
         GPxA7d68fijWnx6OfGKM0ttj9DLDRfP+L+g1KFbSsZZewV8m5kV0XDNeKo2WjGxY6dqM
         uq/46yFRtFX4jR1XVOtRL8P7Ut5AIK3/IvrnkThS0fLWogtQOTOtvwQtV8KK1o6kadzA
         QKew==
X-Gm-Message-State: AOAM532qJtJqFpkqyGgcJJZHi1U2IhV1v/YGXCOqt6e2+duEFDbW56qG
        L12KRgEOppBnuq4XGpkKwhHHduDRXUo=
X-Google-Smtp-Source: ABdhPJxLkLHu14NSMGZzCeuyo/Vu0/MjIaw4sO4tBzYj/s5KmDF1uOoQ4pjBoMP+0a4xo9D/1ErkClxjx1w=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:22d1:: with SMTP id
 y17mr5969171plg.107.1643331210493; Thu, 27 Jan 2022 16:53:30 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jan 2022 00:51:56 +0000
In-Reply-To: <20220128005208.4008533-1-seanjc@google.com>
Message-Id: <20220128005208.4008533-11-seanjc@google.com>
Mime-Version: 1.0
References: <20220128005208.4008533-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 10/22] KVM: x86: Unexport kvm_x86_ops
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the export of kvm_x86_ops now it is no longer referenced by SVM or
VMX.  Disallowing access to kvm_x86_ops is very desirable as it prevents
vendor code from incorrectly modifying hooks after they have been set by
kvm_arch_hardware_setup(), and more importantly after each function's
associated static_call key has been updated.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cc14f79c446c..a8ea1b212267 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -124,7 +124,6 @@ static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
 static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
 
 struct kvm_x86_ops kvm_x86_ops __read_mostly;
-EXPORT_SYMBOL_GPL(kvm_x86_ops);
 
 #define KVM_X86_OP(func)					     \
 	DEFINE_STATIC_CALL_NULL(kvm_x86_##func,			     \
-- 
2.35.0.rc0.227.g00780c9af4-goog

