Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7964E4FFD5A
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 20:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237619AbiDMSDI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 14:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237585AbiDMSCW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 14:02:22 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B5D4090D
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 11:00:00 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id f12-20020a170902ce8c00b0015874d582e8so1548122plg.7
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 11:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=S9c5hfgea9nF2vcGLAzTx3MCtPKtuM/ZU/yidQX2w98=;
        b=fysxMTw5FfeK2kfCYyldf+U2U6tRB7zRsq9JmBoQbVpkoKWgjcJFFsaxGEaogeuHP2
         0tkRlXfnlvVimHa9GCR61mV1Cwo8kJeXLMx8NY3eLl+pNzl0E70NCHbzTodLmT3FCJ+S
         ulQ+1RrkXHdi6NuH3A9ke1uwAs40IuhESL/zkPW3jhBOq9XChi9ndNgfZiQJzkwp/nwp
         W+Ro7evQEnJDKZObBIaEEZmKBimsckWmr+UseTNZ7Juk5JyA3mf8sE2krn3iCSJ8ryMR
         ZBE3RYt7ww+T8Q5A3WHEOuUDMYzIvb+hjkWJnMHRgNGpKV6cx8n55PYy8Ox07OAqcVTf
         yMcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=S9c5hfgea9nF2vcGLAzTx3MCtPKtuM/ZU/yidQX2w98=;
        b=qlWr6fb4lU25k4UNwt+ou4S6c3N/AqOYmsekSBZXTHbsyCmxLyNIcFaIrE4qEYOn06
         oWk+Q5H089bottmpI55rFhw3VdCKSXFUy7JgnwrR/9cVqSWrer/Ce3cXNiQlQOqF4yCp
         onCaay2bTJcQwQC9qMx6OkS8SSwnpz7US5OLFiancqE8p6NNlwwKaOyuV247gXZAXnKZ
         6jjzRmdctmsf9taxH0q5B+jgz89aGe+m3AVtSqtCB9eO8LLekQMZ/hLX6UpkelBiboH/
         4tBhZ/Zo95LG5LxrAMIXpJNen6D1xdi/jotcjdNjzuDi4TpRizNOZkeiHd6NzPjhmTQK
         lQHg==
X-Gm-Message-State: AOAM533Slrj85e/srC4NnepWEIZyLT+dg/zcVi7hrzXlXQ1vjRZ3uJiE
        5Tj64fNZEMBR1k/5lrD4pBKCvzF98IbW
X-Google-Smtp-Source: ABdhPJwz1kE+LgFkjp6n93PoL8eszyj+sUtefQWtn3Wy529KwG2yZvBjUXDzUykj7XYTEdt1lSJb6vGRqYH9
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:c087:f2f2:f5f0:f73])
 (user=bgardon job=sendgmr) by 2002:a17:902:d2d0:b0:158:761e:c165 with SMTP id
 n16-20020a170902d2d000b00158761ec165mr13217509plc.59.1649872800278; Wed, 13
 Apr 2022 11:00:00 -0700 (PDT)
Date:   Wed, 13 Apr 2022 10:59:41 -0700
In-Reply-To: <20220413175944.71705-1-bgardon@google.com>
Message-Id: <20220413175944.71705-8-bgardon@google.com>
Mime-Version: 1.0
References: <20220413175944.71705-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v5 07/10] KVM: x86: Fix errant brace in KVM capability handling
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
        autolearn=ham autolearn_force=no version=3.4.6
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
index ab336f7c82e4..665c1fa8bb57 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4382,10 +4382,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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
2.35.1.1178.g4f1659d476-goog

