Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92732DB3C7
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 19:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731498AbgLOS3h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 13:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730472AbgLOS3W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 13:29:22 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC092C0611CF;
        Tue, 15 Dec 2020 10:28:33 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id b73so22064861edf.13;
        Tue, 15 Dec 2020 10:28:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=doIMCM/CToq9Jbv6jz6zVoEhuL9pFBHCD93XAYTZiak=;
        b=e+vgd4s4pLeiGcmeLRWukldHDTnE5CMva8Y5p/xy5be4OToCaYiDvlDO6stecGIbyh
         zj7Kzi5OMpHFHrFOdl8ogEgAp1zHLaNMZSV/I57wZanLYJOi8u82Gt1m5W2oFmHS40iD
         3q+YV9KFBfzV6jd/ZNo7SzzKETYN8lme8ZehYinQevV9HCMbepBVw9AY24+hY84JFMJG
         jzBzKJfnqm9qV8VRiY9DC7xuoGypjsxHhuEtmvWXvKz0RitW5DcdpMF19BrXdgqU9hdv
         Q4+Bg8EiDylm1NWCP8zTyRFHvHIntL6WeA1efifRxOmJ/IdEBREW75CvNIYyv70GbAwI
         Ll4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=doIMCM/CToq9Jbv6jz6zVoEhuL9pFBHCD93XAYTZiak=;
        b=Nuh6sILpHS593dlsajhXWUy6AvOrvEufrmfm660KGHQuwCFa4BxdM2C1JhKH45BtOG
         +9SAP9p5ZO5q9AWMZCn/6IpZa0vg/PGdw2Bec/ayv/5Vrj0SA96Tq1NMI+/zHF6wJnud
         banAOgaMwuJ7LYXECY9imNBEMZ81rWQhZqW6azb7f2tC1t0cgQe5D/mJVN51urILV9qB
         HoltuUdhr8TzEXMHlXZKLzvsrXdKGR2H9Ttf4x9y9UKxB7rvpTXojOg5BZF6QIAMXZED
         p+jjjHLuTXtYSI/EWPx1vEYixZ3cY8IWNlcvKJfWPbWTW35VluEzO9JWgaTy2qSqB5nL
         VIaA==
X-Gm-Message-State: AOAM531ZYQvaNMoZLE5tHQJd81vRpl+Q9iRp0BseKyJ7aHUtApY3kXJw
        YYznXtJtAkzNvERxd9bg4+Q=
X-Google-Smtp-Source: ABdhPJwnj92sUfDJzxNZoIDbn3gTJ53XjZjYpEbpUTUwa5ohjSsFzr7O3uH+RR5alWgDSOxFszCFNg==
X-Received: by 2002:a50:d484:: with SMTP id s4mr30952192edi.13.1608056912382;
        Tue, 15 Dec 2020 10:28:32 -0800 (PST)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id r21sm7369228eds.91.2020.12.15.10.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 10:28:31 -0800 (PST)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 3/3] KVM/VMX: Use try_cmpxchg64() in posted_intr.c
Date:   Tue, 15 Dec 2020 19:28:05 +0100
Message-Id: <20201215182805.53913-4-ubizjak@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201215182805.53913-1-ubizjak@gmail.com>
References: <20201215182805.53913-1-ubizjak@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use try_cmpxchg64() instead of cmpxchg64() to reuse flags from
cmpxchg/cmpxchg8b instruction. For 64 bit targets flags reuse
avoids a CMP instruction, while for 32 bit targets flags reuse
avoids XOR/XOR/OR instruction sequence.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
---
 arch/x86/kvm/vmx/posted_intr.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index f02962dcc72c..47b47970fb46 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -60,8 +60,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 			new.ndst = (dest << 8) & 0xFF00;
 
 		new.sn = 0;
-	} while (cmpxchg64(&pi_desc->control, old.control,
-			   new.control) != old.control);
+	} while (!try_cmpxchg64(&pi_desc->control, &old.control, new.control));
 
 after_clear_sn:
 
@@ -111,8 +110,7 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
 
 		/* set 'NV' to 'notification vector' */
 		new.nv = POSTED_INTR_VECTOR;
-	} while (cmpxchg64(&pi_desc->control, old.control,
-			   new.control) != old.control);
+	} while (!try_cmpxchg64(&pi_desc->control, &old.control, new.control));
 
 	if (!WARN_ON_ONCE(vcpu->pre_pcpu == -1)) {
 		spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
@@ -181,8 +179,7 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
 
 		/* set 'NV' to 'wakeup vector' */
 		new.nv = POSTED_INTR_WAKEUP_VECTOR;
-	} while (cmpxchg64(&pi_desc->control, old.control,
-			   new.control) != old.control);
+	} while (!try_cmpxchg64(&pi_desc->control, &old.control, new.control));
 
 	/* We should not block the vCPU if an interrupt is posted for it.  */
 	if (pi_test_on(pi_desc) == 1)
-- 
2.26.2

