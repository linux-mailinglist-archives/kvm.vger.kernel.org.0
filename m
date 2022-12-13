Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 070B564AC3A
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 01:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234183AbiLMASD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 19:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234121AbiLMARY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 19:17:24 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4761CB1C
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 16:17:15 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id h2-20020a170902f54200b0018e56572a4eso5741290plf.9
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 16:17:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=nM41DSVBAJr+S3W93Zis4JAYC8eUvXamzXgPZLD06L8=;
        b=nYe6ZWOHPMJgTGksZPiEisBf6HPHtTh7LwnzxBJxPqoYHxDIXfUXIa80Wv8FT5deaA
         UzHNYFP0DWaotAozDYEqkVOhGC3cJzSjZIrX35uJMvKk0qzEdjbF5qj55iPpjtEz3ipO
         bm8VP2buvMYoUm5bBSsgzK0AvSdBMq0gU3WwNjXiGhrTir7XSUZ3UlUPkv2SzjZJXHyV
         BW7oqPIg9/2WzHp2xjLzs82Y3ewdbcwG+wxaYmUKR44YKrwYEmcWRcUYbv914+1ep3vj
         XM381ihLSB7s6K13WjVWXGmod93EwbDCFi3RC00C/qqJJxPj4hbmeVdBA7F4fDCsvIiB
         q4Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nM41DSVBAJr+S3W93Zis4JAYC8eUvXamzXgPZLD06L8=;
        b=oBBCkHoDGfGVsyyBYuuix7KQ9EA6ps5iFTMkSdRYN32yeY4a1DoqUaWDPNVNhxN/r6
         2lg90j5RoF2PbPeKhiIkp3+OycfGqa0bY2mrDM3IFfWXeSwWOZ+tim7db/g/aVA7KOAW
         lyuHcNgiwcNSByS4XnXLZH82G7x2SaNw+Jp+PtYrY1vuMGORQ8yywcclgxuuLvRrVjg1
         6mM9twX+H6Sms9pp76UNc6B8msco35d/fXbpbar09BalY1AF4KoVOfmaewUMZwuSPUbp
         d6zPbG/eiLeOIrQZGQV7JOAJMxeTK6XEmCF44LTzBNAfM/olcknq3QTyIvhgVqJt1CzR
         9JZA==
X-Gm-Message-State: ANoB5pnuqdDRm9BJnwPYEpjYk0msN1/ug8H7vHEzwCUGYa/+1ZMksSCV
        OFvKhSdRScbJK92/BZdLNyjAkdOKEMM=
X-Google-Smtp-Source: AA0mqf6ZbJmcYrZNpc/Z0ppwmhrlHhb+cLSNTmH678oSo0UQF9b8LuTc9fdveE6JT7fYmZu7x1S++6s+7UY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c406:b0:189:6df9:4f85 with SMTP id
 k6-20020a170902c40600b001896df94f85mr62591897plk.27.1670890635443; Mon, 12
 Dec 2022 16:17:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Dec 2022 00:16:50 +0000
In-Reply-To: <20221213001653.3852042-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221213001653.3852042-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213001653.3852042-12-seanjc@google.com>
Subject: [PATCH 11/14] KVM: selftests: Disable "gnu-variable-sized-type-not-at-end"
 warning
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Tom Rix <trix@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-riscv@lists.infradead.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
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

Disable gnu-variable-sized-type-not-at-end so that tests and libraries
can create overlays of variable sized arrays at the end of structs when
using a fixed number of entries, e.g. to get/set a single MSR.

It's possible to fudge around the warning, e.g. by defining a custom
struct that hardcodes the number of entries, but that is a burden for
both developers and readers of the code.

lib/x86_64/processor.c:664:19: warning: field 'header' with variable sized type 'struct kvm_msrs'
not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
                struct kvm_msrs header;
                                ^
lib/x86_64/processor.c:772:19: warning: field 'header' with variable sized type 'struct kvm_msrs'
not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
                struct kvm_msrs header;
                                ^
lib/x86_64/processor.c:787:19: warning: field 'header' with variable sized type 'struct kvm_msrs'
not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
                struct kvm_msrs header;
                                ^
3 warnings generated.

x86_64/hyperv_tlb_flush.c:54:18: warning: field 'hv_vp_set' with variable sized type 'struct hv_vpset'
not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
        struct hv_vpset hv_vp_set;
                        ^
1 warning generated.

x86_64/xen_shinfo_test.c:137:25: warning: field 'info' with variable sized type 'struct kvm_irq_routing'
not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
        struct kvm_irq_routing info;
                               ^
1 warning generated.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 2487db21b177..9cff99a1cb2e 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -196,6 +196,7 @@ else
 LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
 endif
 CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
+	-Wno-gnu-variable-sized-type-not-at-end \
 	-fno-builtin-memcmp -fno-builtin-memcpy -fno-builtin-memset \
 	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
 	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
-- 
2.39.0.rc1.256.g54fd8350bd-goog

