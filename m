Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687444E3510
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 01:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbiCUXvV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 19:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233676AbiCUXvN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 19:51:13 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6072818F23E
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 16:49:19 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id i8-20020a056a00004800b004fa5a5ecc4bso384883pfk.16
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 16:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=03AtXXduXg1zb1Lu6FvRz8gaF3DklY9yvpB3ES+4Dvo=;
        b=Q1xUUUmlqEpBGcIC6H+wXtC8Gr2rWlrSz7NI5xNmSE0uvZIhuVGBn3UBiUKZBNEP3y
         uVJDWwuVe+43rOQ4ih/Q02ttE3rAuFeZ09lxezOVwWDDfJ/49M59H936VvqCqVYdbPMz
         kEr69NpA4DkdxnFB5YyruXcZUqGqEGBmB45uzV/etPNq43icb12Av7RpQmZLXgbm9A9d
         8uKXZ3Ng66TKGPqurVnVl/3Q/ufsUqWlXF1Hij+3jE1dOt3pcaa68W2Z/fgm6VNv7jnh
         RwqSAAEAJ/T9NOGtFFtqaoreplYfA45saZWQEXhVN28LoX1yyKAGp9P24yQf0lLNQt6j
         kjAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=03AtXXduXg1zb1Lu6FvRz8gaF3DklY9yvpB3ES+4Dvo=;
        b=l0xSDpKHzafHTjb7v5SzLzQcdmckMvc8crGzdASFI0L1jFdsEBZqxDS6XqB1NTtQFc
         nAsOb2RAFbrppVGPVgiJLxlD2vkSQ5uN6mk75AjabAvjoSnBw3LQ/TOlQ5EFSxrwIY4G
         L9BDw875l0qNPz/z2Zdi4j5Kc2n+3fVQhLJ9S1Zrhj3fPe4umrAaU/9uflqNoQ3zDj/a
         AC/NBbyD5eUQeKRBJV4JeSTqNbk1C448UMxzGjMR9rNtolpk+JPkkdnG74W6B88guDiC
         GLdUz44lRwvDqtOlgvQz7KJsVXYH5ISvSc1U2PfbLAcmwP6LL4KYoa1dvlFjl7HuydbO
         OWXQ==
X-Gm-Message-State: AOAM530OK9d+Iuhv4+7cPhnT7qgH+9M/mMibLzwj/kuCXOpjd0fAyEdp
        sdzdVF0MgAuHrLxxoSs+aTxVZ61vY9c0
X-Google-Smtp-Source: ABdhPJyku+3fzcf4ntA+Tu3Q+OdzLeoDGPq6egXk8Edj0z6jYxTHXMgyqm99IUFx4je5oaBLEjfaCc7A1/nJ
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:b76a:f152:cb5e:5cd2])
 (user=bgardon job=sendgmr) by 2002:aa7:943a:0:b0:4f6:adc9:d741 with SMTP id
 y26-20020aa7943a000000b004f6adc9d741mr25936431pfo.30.1647906558205; Mon, 21
 Mar 2022 16:49:18 -0700 (PDT)
Date:   Mon, 21 Mar 2022 16:48:43 -0700
In-Reply-To: <20220321234844.1543161-1-bgardon@google.com>
Message-Id: <20220321234844.1543161-11-bgardon@google.com>
Mime-Version: 1.0
References: <20220321234844.1543161-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 10/11] KVM: x86: Fix errant brace in KVM capability handling
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The braces around the KVM_CAP_XSAVE2 block also surround the
KVM_CAP_PMU_CAPABILITY block, likely the result of a merge issue. Simply
move the curly brace back to where it belongs.

Fixes: ba7bb663f5547 ("KVM: x86: Provide per VM capability for disabling PMU virtualization")
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 73df90a6932b..74351cbb9b5b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4352,10 +4352,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		if (r < sizeof(struct kvm_xsave))
 			r = sizeof(struct kvm_xsave);
 		break;
+	}
 	case KVM_CAP_PMU_CAPABILITY:
 		r = enable_pmu ? KVM_CAP_PMU_VALID_MASK : 0;
 		break;
-	}
 	case KVM_CAP_DISABLE_QUIRKS2:
 		r = KVM_X86_VALID_QUIRKS;
 		break;
-- 
2.35.1.894.gb6a874cedc-goog

