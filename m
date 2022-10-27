Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF54610251
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 22:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236842AbiJ0UDb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 16:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236834AbiJ0UD1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 16:03:27 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 896EF36429
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 13:03:26 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 204-20020a2510d5000000b006be7970889cso2479491ybq.21
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 13:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5U5KGPA2RxlK5HZq/lifrukyKlRZoskBuzdbIGc8W1A=;
        b=iPr2JcYLbN/WjRuSpxTwdCFdvYSD8UvcLJmTGl6abDzYih95Yl7AP0fTo1zuEaUFEB
         Wu6ldu5NE29knKkz+FKQ/ZDsEyfm35qfs3wXJgQlf0ACRM/hRcJmZue4yQQz3MgjtvKd
         P1oIv28ecVl4sE7uA+QxISfCbi1ciOBC0/l28zJyLeWf7fSdqd/+VLadyBpTSjy5rUf3
         hKAmEJwaxfcgneLftty6cl00ECVk8fhgLT7XXyv0rhYHJwBxZZ9B+ci8GRF0YViXJsPl
         WRAZbq1Sm4uyALAhVaCZBDl7qURwESagxy/WfTYThD3RJqWBMgpPs4h9+/YwS9k5RKr6
         0OiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5U5KGPA2RxlK5HZq/lifrukyKlRZoskBuzdbIGc8W1A=;
        b=hWx54hOoRrkVtFOpA3kl/ceMl9NpAwGHGBWe+Z0GlTHu4GPGkRBhoiZqDuCesGVdLD
         DenIX25/N7A1Le+BZbskqScI0Hv1uQMSe6peNsWeOvnkql6GgW42DheLHhUoGr+818kp
         0x0No5syWjHpp10RlmKfQvD+OuoddQlE3j+JYdB2GxKylScyKvgFz8xXuR9cXCtWkMlX
         6qaPVpA4hT4Le2i1UTx57kndK2JBY/IMkA40yxvmEcLLPro8T8JNMoR9fk2a1/yd37a8
         63n7NlKunTlNrJ1PHCu1sTMxqjbWRr2cBR5+ncuRl1xUMAS6T8vHcgB/G7pn6Dhenflj
         cEBg==
X-Gm-Message-State: ACrzQf1g7+fRuUWAKStzl+YdrrfyDqvyhe4LQ3K22quk7aWhI4kv1idj
        2e+FJOmLyCP6WEQCIsWkdJgARIlKbqy2ZQ==
X-Google-Smtp-Source: AMsMyM4828ZIVCbVNRMsGtPCjnK36mpWkXx8zKNJa748d3+ubLnpxYmeIccnJ//EiL1VmMVu9Wp1Yay05Pz2iQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:bb13:0:b0:6bc:c39d:fe07 with SMTP id
 z19-20020a25bb13000000b006bcc39dfe07mr0ybg.186.1666901005097; Thu, 27 Oct
 2022 13:03:25 -0700 (PDT)
Date:   Thu, 27 Oct 2022 13:03:16 -0700
In-Reply-To: <20221027200316.2221027-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221027200316.2221027-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221027200316.2221027-3-dmatlack@google.com>
Subject: [PATCH 2/2] KVM: x86/mmu: Do not recover NX Huge Pages when dirty
 logging is enabled
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>
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

Do not recover NX Huge Pages if dirty logging is enabled on any memslot.
Zapping a region that is being dirty tracked is a waste of CPU cycles
(both by the recovery worker, and subsequent vCPU faults) since the
memory will just be faulted back in at the same 4KiB granularity.

Use kvm->nr_memslots_dirty_logging as a cheap way to check if NX Huge
Pages are being dirty tracked. This has the additional benefit of
ensuring that the NX recovery worker uses little-to-no CPU during the
precopy phase of a live migration.

Note, kvm->nr_memslots_dirty_logging can result in false positives and
false negatives, e.g. if dirty logging is only enabled on a subset of
memslots or the recovery worker races with a memslot update. However
there are no correctness issues either way, and eventually NX Huge Pages
will be recovered once dirty logging is disabled on all memslots.

An alternative approach would be to lookup the memslot of each NX Huge
Page and check if it is being dirty tracked. However, this would
increase the CPU usage of the recovery worker and MMU lock hold time
in write mode, especially in VMs with a large number of memslots.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6f81539061d6..b499d3757173 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6806,6 +6806,14 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 	bool flush = false;
 	ulong to_zap;
 
+	/*
+	 * Do not attempt to recover NX Huge Pages while dirty logging is
+	 * enabled since any subsequent accesses by a vCPUs will just fault the
+	 * memory back in at the same 4KiB granularity.
+	 */
+	if (READ_ONCE(kvm->nr_memslots_dirty_logging))
+		return;
+
 	rcu_idx = srcu_read_lock(&kvm->srcu);
 	write_lock(&kvm->mmu_lock);
 
-- 
2.38.1.273.g43a17bfeac-goog

