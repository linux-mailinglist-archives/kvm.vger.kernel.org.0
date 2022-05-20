Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B170B52F1BC
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 19:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352267AbiETRhA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 13:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352300AbiETRgz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 13:36:55 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021428CB3D
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 10:36:53 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 185-20020a6304c2000000b003f5d1f7f49aso4451846pge.7
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 10:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0vS5tkNj/9TlbMnAs+B1cjDPjcuZkRtuDIjGGmBhLLU=;
        b=PEmM1RGmVuLBu120z/RlrWPyZpLJYhPj+jDp22paKqbA/AW15hv5/0aK0v72q/e89H
         z8Ct1YOmwPpr+CX+7sNGXnn1e5P+zjwlLZvf/uuu1OeIe7khyBlkltTJPHDywwSyI9PY
         7HYYg1JHOnR8Mmq0hY8xzTSngiCMWr5WMTVpDuO7OYY4+syqH3vCoEfwlsUwzuC12is9
         7IFRDUTL3i95C5s9zR00oBMqY8T0QVO4FnbmX9VK32pEci18oxqSckrsWr+cVAURioQe
         di6DfTnjJkDs0c2fzNJzC2JOOVU0/R5DCScyVS+DcvM2YjSm+j1CSM5d94jlaRrGcMVl
         LkTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0vS5tkNj/9TlbMnAs+B1cjDPjcuZkRtuDIjGGmBhLLU=;
        b=TRumoWcRImyC5DnYjyJ6lVz4pjmOwJzesjzqFyHyk8FbS88MenbJ8DTbvS0zh1Err2
         3Dh4JvW7gixYPvpbQ/GNupRQfiisI8wI2CYfqrWo7nAmPgWblZ2cDyAeWTqRhMuVQ0/y
         R7UwEC+8mzJuOecHJrD6BjwUT2ApkJCweee3Z8nFfwdSjdZoF5fnWkx/HC2NBJBKLqLN
         9b9LTR+ktbdB9wdKTPV062trx0UvHuivSbx0GU6RI/GNOYnNyxY6d9hdu4oSWI7Rn0Om
         kbWALKmn6gBvsZrD5PgZRImA6kmeNQCt02dDtR8MZIpTwqq459qL9apBMtA4tWUq0QFd
         0j7g==
X-Gm-Message-State: AOAM530PQpb8TBlz5cNl2bU/FTs6wy6qkb8j3dW/bAtjR5MEgLsSRhnw
        zfP5Tc46I+FRXSDSXY47sJFIlULP
X-Google-Smtp-Source: ABdhPJyhNjLRNc0GopP5PHCHktoHPui+KBu6dJbbM+pH4fINJdFd4yaSbUXeatsX2631xXX4JnzbxL/Q
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:4c5:ddc5:8182:560f])
 (user=juew job=sendgmr) by 2002:a05:6a00:2450:b0:4f7:bf07:c063 with SMTP id
 d16-20020a056a00245000b004f7bf07c063mr10926460pfj.51.1653068213138; Fri, 20
 May 2022 10:36:53 -0700 (PDT)
Date:   Fri, 20 May 2022 10:36:35 -0700
In-Reply-To: <20220520173638.94324-1-juew@google.com>
Message-Id: <20220520173638.94324-6-juew@google.com>
Mime-Version: 1.0
References: <20220520173638.94324-1-juew@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v4 5/8] KVM: x86: Use kcalloc to allocate the mce_banks array.
From:   Jue Wang <juew@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Matlack <dmatlack@google.com>
Cc:     Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        Greg Thelen <gthelen@google.com>,
        Jiaqi Yan <jiaqiyan@google.com>, Jue Wang <juew@google.com>
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

Corrected Machine Check Interrupt (CMCI) can be configured via the per
Machine Check bank registers: IA32_MCI_CTL2. To emulate IA32_MCI_CTL2
registers, it's necessary to introduce another array mci_ctl2_banks
in analogy to the mce_banks array under struct kvm_vcpu_arch.

This patch updates the allocation of mce_banks with the array allocation
API (kcalloc) as a precedent for the later mci_ctl2_banks.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jue Wang <juew@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4790f0d7d40b..0e839077ce52 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11224,7 +11224,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 		goto fail_free_lapic;
 	vcpu->arch.pio_data = page_address(page);
 
-	vcpu->arch.mce_banks = kzalloc(KVM_MAX_MCE_BANKS * sizeof(u64) * 4,
+	vcpu->arch.mce_banks = kcalloc(KVM_MAX_MCE_BANKS * 4, sizeof(u64),
 				       GFP_KERNEL_ACCOUNT);
 	if (!vcpu->arch.mce_banks)
 		goto fail_free_pio_data;
-- 
2.36.1.124.g0e6072fb45-goog

