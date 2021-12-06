Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A62B46938D
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 11:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236616AbhLFK2A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 05:28:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233542AbhLFK17 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 05:27:59 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF34C061746;
        Mon,  6 Dec 2021 02:24:31 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id o19-20020a1c7513000000b0033a93202467so7250702wmc.2;
        Mon, 06 Dec 2021 02:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HP481SlKiuyCsHUCaP7DTefIxupA0tKqZe3YXN2SCGc=;
        b=N824mFa9knOQsKJ7BGph0ZNiTjOsqnEniTBcLLOm8sqfYV0Y5P4u4G5EXnURa3Aym1
         epEXa3y6NcCavJ22WbV36rnvhOm8n0vBhr17daw7JVgqCFa3xBXKnaygxxkMO51XTZfY
         k+KC6fMVnpA75KPLc+G34u6bke62c+zjo4dZsRbx1qXWcUtqB1f9oJyfln1mZKX4l5eI
         V4Z65B3h6wWrSQo4ReUFbmGX29lE/gbwNpE6h9eTqM5VKf8TfjcMdoRAJg9DsmjIeDbF
         25jju52mZuRSO6/YnYEgJDWVjdt7xq6xiF/0ds6dVgGoxwYq5lAI0rYgHZaGzYLC7TSY
         vB2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HP481SlKiuyCsHUCaP7DTefIxupA0tKqZe3YXN2SCGc=;
        b=cRYjp4p3z+4pvMM/zCIOw/TWWYCn7O1KM/e5FT6PAIYABtY/TWtJVYY/lrWU0Aa2OE
         DWSLmd+MZXrN2+xt5IZr4IVn+9fbKZG7q7ZsC1eMPTE6ozfKGpMkjDz+Oti6loWkIH9u
         /hTNn0gcOhrUV2QTHDnlQgVI4IWuqDee5ZRexD7KysuriMy6FXmIPxznjhYIkYYr2gpp
         Wa1gJ5y2u4mS7rI2HrMok861y5s18yVU8qrDZTmOZmaFgqmLGMgmcq2v0Dn7JvEjNGKR
         P+U2WuhAqQXC2U/xq6YJvNSKp7OAEuO77aHTBN96a5kLm3lTjYeBMNUoNSmwyjIwapa/
         AOaA==
X-Gm-Message-State: AOAM530ZJwm9ue/WeTL7wujWhSlaGsBcljiuepQn937nV/qestRRAyLl
        KLyN2k+byGeVwqR47lOkF5bwZ53R2ZtP0vtp0sk=
X-Google-Smtp-Source: ABdhPJwUQZu1A6BomNnUFeiwzM8v/bIWhse1eTBCFB3s5dsmleYqllvHm58BlHp3M1aEoir0M0HE2g==
X-Received: by 2002:a1c:a301:: with SMTP id m1mr38299694wme.118.1638786269740;
        Mon, 06 Dec 2021 02:24:29 -0800 (PST)
Received: from localhost.localdomain ([39.48.147.147])
        by smtp.gmail.com with ESMTPSA id g13sm10279386wmk.37.2021.12.06.02.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 02:24:29 -0800 (PST)
From:   Ameer Hamza <amhamza.mgc@gmail.com>
To:     vkuznets@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, Ameer Hamza <amhamza.mgc@gmail.com>
Subject: [PATCH v2] KVM: x86: fix for missing initialization of return status variable
Date:   Mon,  6 Dec 2021 15:24:03 +0500
Message-Id: <20211206102403.10797-1-amhamza.mgc@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <87ee6q6r1p.fsf@redhat.com>
References: <87ee6q6r1p.fsf@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If undefined ioctl number is passed to the kvm_vcpu_ioctl_device_attr
function, it should return with error status.

Addresses-Coverity: 1494124 ("Uninitialized scalar variable")

Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>

---
Added default case to return EINV for undefined ioctl number
---
 arch/x86/kvm/x86.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e0aa4dd53c7f..e6e00f997b1f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5019,6 +5019,8 @@ static int kvm_vcpu_ioctl_device_attr(struct kvm_vcpu *vcpu,
 	case KVM_SET_DEVICE_ATTR:
 		r = kvm_arch_tsc_set_attr(vcpu, &attr);
 		break;
+	default:
+		r = -EINVAL;
 	}
 
 	return r;
-- 
2.25.1

