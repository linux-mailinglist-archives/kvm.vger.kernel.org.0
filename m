Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B77475EC9A
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 09:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbjGXHfl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 03:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjGXHfi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 03:35:38 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2206DB9;
        Mon, 24 Jul 2023 00:35:37 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id af79cd13be357-76754b9eac0so373317485a.0;
        Mon, 24 Jul 2023 00:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690184136; x=1690788936;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EDTSsXyhM0omkYQyX53gEEvKIjkVRX9tpymTOGcpwOQ=;
        b=eDtyE95HreJTGndVUo26mno6lxe14TQaKM9C6h1Sh1yzgD96924Q4BFeW8fBEwx/KC
         wLdRECEVUywZKJ9MODAYrjPNxxmRiHk0jXj2Eid4m6Nt5hrBF+0gqKcl0bFy8QNMAHCt
         xPAD1JJrKy5izVH0Me4jqnz6OWFY4rj8LvqFwrz7F/LGXioJveDX5k9AkhyLYC+VQvB4
         u+kbUbeadvb7DBdJatgZTTp0vEgg1goaZ8BesJTRYQJ9iqGemKOVkPTYSxKPmnZRpBNx
         PCUJ79MkOGFfWawtfAjfKRk/oqhyI1V07Ske9KDcalzvq8o3StHskuujBWLVeyKTNrnp
         bu3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690184136; x=1690788936;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EDTSsXyhM0omkYQyX53gEEvKIjkVRX9tpymTOGcpwOQ=;
        b=J5cAHLhLqxrwBnCCSihPps3EzrU59e6dMPpghrKvZrlcMXptAi6VercqaHIWLLcNk2
         SK+S5RcCLqJhEhU3zceOgIGIwdPvEcdXMJLXsOMXXQZREM4Clse0Eug0T3ydEAfDNfmH
         mPOgOD8ZFdgr2REasyhHxodrfpIb+8fxpK8Mhh28KIzIjWSkwNBejpkyXa0OyOK38Wfr
         yNqDH8JRMWY0RAgMeqNYtlM8eywDQjfxGLPi6NDM9a0V2egO/YKSzl2L1z13zYfW68pQ
         iQJGWaHMa+romMhpAh2fvIgYrugOUjKJcgfdX8VmtSiu7hBl8/hg5Otr38YIh7SgtGTU
         DM9Q==
X-Gm-Message-State: ABy/qLbNFqyDir0Aafq9aUpKW54XN9LRe6F/ZJAISj5YPQPJogEhxeXX
        4EI9Qeabj8G79T+oawB+paU=
X-Google-Smtp-Source: APBJJlFgp/n3+l891x8uDSlxTEdfF2902YtqoBzNeXbPhmeq3qlXI7B1it7Uotbv0maQyvXyw+V36w==
X-Received: by 2002:a05:620a:4484:b0:767:81e5:566 with SMTP id x4-20020a05620a448400b0076781e50566mr8778382qkp.58.1690184136196;
        Mon, 24 Jul 2023 00:35:36 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id w1-20020a17090a6b8100b00265cdfa3628sm8283147pjj.6.2023.07.24.00.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 00:35:35 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: x86/tsc: Use calculated tsc_offset before matching the fist vcpu's tsc
Date:   Mon, 24 Jul 2023 15:35:16 +0800
Message-ID: <20230724073516.45394-1-likexu@tencent.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Avoid using kvm->arch.cur_tsc_offset until tsc sync is actually needed.

When the vcpu is created for the first time, its tsc is 0, and KVM
calculates its tsc_offset according to kvm_compute_l1_tsc_offset().
The userspace will then set the first non-zero tsc expected value for the
first guest vcpu, at this time there is no need to play the tsc synchronize
mechanism, the KVM should continue to write tsc_offset based on previously
used kvm_compute_l1_tsc_offset().

If the tsc synchronization mechanism is incorrectly applied at this point,
KVM will use the rewritten offset of the kvm->arch.cur_tsc_offset (on
tsc_stable machines) to write tsc_offset, which is not in line with the
expected tsc of the user space.

Based on the current code, the vcpu's tsc_offset is not configured as
expected, resulting in significant guest service response latency, which
is observed in our production environment.

Applying the tsc synchronization logic after the vcpu's tsc_generation
and KVM's cur_tsc_generation have completed their first match and started
keeping tracked helps to fix this issue, which also does not break any
existing guest tsc test cases.

Reported-by: Yong He <alexyonghe@tencent.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217423
Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Like Xu <likexu@tencent.com>
---
V1 -> V2 Changelog:
- Test the 'kvm_vcpu_has_run(vcpu)' proposal; (Sean)
- Test the kvm->arch.user_changed_tsc proposal; (Oliver)
V1: https://lore.kernel.org/kvm/20230629164838.66847-1-likexu@tencent.com/

 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a6b9bea62fb8..4724dacea2df 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2721,7 +2721,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 			 * kvm_clock stable after CPU hotplug
 			 */
 			synchronizing = true;
-		} else {
+		} else if (kvm->arch.nr_vcpus_matched_tsc) {
 			u64 tsc_exp = kvm->arch.last_tsc_write +
 						nsec_to_cycles(vcpu, elapsed);
 			u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;

base-commit: fdf0eaf11452d72945af31804e2a1048ee1b574c
-- 
2.41.0

