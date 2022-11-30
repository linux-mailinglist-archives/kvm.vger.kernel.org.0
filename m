Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3493B63E49F
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 00:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiK3XLI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 18:11:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiK3XK0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 18:10:26 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E838598039
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:09:56 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 11-20020a63000b000000b004776fe2eebfso85429pga.9
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:09:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=uhI8yDhdR7lIAaqvku/gdFE7HWy6VU8JNAGQp8QsO6I=;
        b=JGKTwFHTr3zFyFeRyDhx800NTwE8fbKBoChRZ4rCsQDcOc/eGjPbGsVDNkCwWmSHdn
         4zWsAcy02h7DG9I7KIrR/3G3ynUAl5zHFprvqWawNYq0ujuz0rj9xQPN87hRttEvJWya
         MaZkpYk6hJDhRKiSggxmfSLSCGk6wAycOhmze7v3vnTNsBJM82DsGnT9K7gXXth5q453
         GXnW0gnhFQMQ7rKcFFJUmj9xHXOE1CyUnZYbsfJ9eekI1f6DwJJHgA0YwjDavFZGHgxi
         PIdF3Xw7u6ZSs+rqvW6sJFzKLF1Mn/CCKFnzXLHVYU5aHYTg5a9RqdAAC/8bhq/W34bo
         HRWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uhI8yDhdR7lIAaqvku/gdFE7HWy6VU8JNAGQp8QsO6I=;
        b=H/+AUpbrpxINys8yWqjPUtvw8urhNrS/AjsK0LOiClIlH815myqwhMwJEeCweh8/XD
         1JJvgC6TzTRp1XlAfiBcaITgNPdaznX/15r0ISot00c84OnHXAZcX3PQ+Oea6sQFu+/X
         x/cVTK2YCMkmGYJDu8vrdZcMUaI/6re4YtWcJjp3p2MADFFfip4Pid9Tt2GVnZ0/FeKL
         DFUNc8ECrcSNbSM5rYEf7rSTuQS+mrzW3WPpbeDuEs3R4ZUKd0IwxK1Lh6xzBE7ujmtB
         mHouTC8VAlHSZwf8aXBNiXliysXdLi6sXVit6CP4NU3J/666RorqboDhvAKMs/PGUNbZ
         URMg==
X-Gm-Message-State: ANoB5plpUFg5JxUprpFeNJsYEpylY5ruZP3iV/WogpcMXJWrd8WlTIV6
        M2nMOon07FHiuqbAa3XIhwDuF4/6X8c=
X-Google-Smtp-Source: AA0mqf4UbHeO/7xp9TeaJC3lcd9wjoTeVcRzR2/roKzeL1N7msdBGBxph7L3Wcu7JbcPwh3sZzXNOI19OJg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:3084:0:b0:56d:dd2a:c494 with SMTP id
 w126-20020a623084000000b0056ddd2ac494mr44472082pfw.76.1669849796263; Wed, 30
 Nov 2022 15:09:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 30 Nov 2022 23:08:55 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-12-seanjc@google.com>
Subject: [PATCH v2 11/50] KVM: VMX: Don't bother disabling eVMCS static key on
 module exit
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paul Durrant <paul@xen.org>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yuan Yao <yuan.yao@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        "=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't disable the eVMCS static key on module exit, kvm_intel.ko owns the
key so there can't possibly be users after the kvm_intel.ko is unloaded,
at least not without much bigger issues.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d85d175dca70..c0de7160700b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8490,10 +8490,6 @@ static void vmx_exit(void)
 
 	kvm_exit();
 
-#if IS_ENABLED(CONFIG_HYPERV)
-	if (static_branch_unlikely(&enable_evmcs))
-		static_branch_disable(&enable_evmcs);
-#endif
 	vmx_cleanup_l1d_flush();
 
 	allow_smaller_maxphyaddr = false;
-- 
2.38.1.584.g0f3c55d4c2-goog

