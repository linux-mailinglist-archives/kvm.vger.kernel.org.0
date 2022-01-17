Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319E3490311
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 08:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237645AbiAQHpp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 02:45:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237649AbiAQHpl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 02:45:41 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6985C061574;
        Sun, 16 Jan 2022 23:45:41 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id o1so7823825pjr.2;
        Sun, 16 Jan 2022 23:45:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GkAPPJxr7LuTpG9OJGgJUPDs1a2LoTlbTW3EbsgAu5Y=;
        b=MppZTLaimhm8UmhbCB00A8KNYs/ZUrgClg8qmYuMXDbCo4urrSM3sM1LOeuzOFuVON
         ijFGcGFV41OYkdnbr33/oQgUw+cLHlraTQdqu6Pcy46FqNqckr9LASzPtfwi4/Df3yD9
         yNKgL4GbkSVYpKP2tcrp3tCFtjCZ4oDnJe/xb/WPipzIZqYmPJI7Vd3wj3c9Y4ZTn7qy
         ZySzeRm3V4te1v/w31uiAItUnXHfOEb6khfUrNU+MVX3VUmTxc6HCvbaVva7s07qGVr7
         vA8btV8hAGk9c9Rwg+v4+T7yW3E4PWCJPbDkqX6PydgPbXvn+sXoGM3EiY2sit6mz3Vr
         Lp6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GkAPPJxr7LuTpG9OJGgJUPDs1a2LoTlbTW3EbsgAu5Y=;
        b=77FIV3qrs/zQlvPXpIH1Y0Ut20gXt5rVd+HEggEjtRm89puQFI9BHXy+CgG0nMNro6
         T2KMPDgFHWmKqpgINdAASdgmWLKLwl1mMxgjiWW34e1oYoex1HUq3o2RQfN7hkf7Hp0j
         miKyLBuxtAQaZa2tvwC09lsm0lG/Q71YXbO0pPbo6ZUKt3bQ3L/zApWn/qzf9tb0yuJI
         nMmeGY0A+bGFNC4ckgc/idZC0ao9masK9uoKvXSJcyo/Q3B9hR/KlafX7XoTNbl3sGGj
         tUxY+T+zf9kSpGFz8cQaEs5sMeAcv43hHQBfhM7Smgins/3j/MMS2jIfi5q0GV8Y14Dj
         ah+g==
X-Gm-Message-State: AOAM533O2m/CyRvHShiPszyxwhbnW/wLuH4Ug8ZCMxMVlaVLAGNTwoU2
        mZBY3y4K112WbGbK8L37eio=
X-Google-Smtp-Source: ABdhPJze+WlFcB7IDwV8006ITombRKdQByMmYNOLzUl4RvemXO7DkdGZQu4gz/szcRpORiK5IdH5Zg==
X-Received: by 2002:a17:903:1107:b0:149:98f7:9629 with SMTP id n7-20020a170903110700b0014998f79629mr20890865plh.160.1642405541351;
        Sun, 16 Jan 2022 23:45:41 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x19sm10803737pgi.19.2022.01.16.23.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jan 2022 23:45:40 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jing Liu <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/cpuid: Clear XFD for component i if the base feature is missing
Date:   Mon, 17 Jan 2022 15:45:31 +0800
Message-Id: <20220117074531.76925-1-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

According to Intel extended feature disable (XFD) spec, the sub-function i
(i > 1) of CPUID function 0DH enumerates "details for state component i.
ECX[2] enumerates support for XFD support for this state component."

If KVM does not report F(XFD) feature (e.g. due to CONFIG_X86_64),
then the corresponding XFD support for any state component i
should also be removed. Translate this dependency into KVM terms.

Fixes: 690a757d610e ("kvm: x86: Add CPUID support for Intel AMX")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/cpuid.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c55e57b30e81..e96efef4f048 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -886,6 +886,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 				--array->nent;
 				continue;
 			}
+
+			if (!kvm_cpu_cap_has(X86_FEATURE_XFD))
+				entry->ecx &= ~BIT_ULL(2);
 			entry->edx = 0;
 		}
 		break;
-- 
2.33.1

