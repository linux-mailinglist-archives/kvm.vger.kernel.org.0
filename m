Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D573767B31
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237694AbjG2Bhy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237617AbjG2Bh1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:37:27 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479A45243
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:37:06 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d063bd0bae8so2556382276.0
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690594577; x=1691199377;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=NKdCtniWiAg1ywOiZ6YDPXm5HtZo7eRagpKdBNR7xpg=;
        b=5Uv4EcFsDMD9NsYdJZO7/8bilal5ddhv5oXjy9nAKQerIStaoVew/onb+SGkfBqNof
         2A3L/r6MHTGAjoy91PbYkNyIZqhSj+Rg5jo5GTtNjedp97sPqdaRQOHc7gwlvo5jU8vA
         kxfdHRIh4lvv6FD1geSFpk4NwkD+WEEwwGy3B85/dF9ect82C0iAl04aq+Y6Af05FV+X
         eXrW2treDagoJmIR73mRzrOOWVmuG7OOwd2Ma2xFq/LHuAyy666HGuXj9cqbQY3SU40h
         VSBG/8KN0SLJPWJ5J61UOibT5kgPqqUSxMYjl2PUOWixvTmfEoaYCwnesh8KVRoki6BH
         JQ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690594577; x=1691199377;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NKdCtniWiAg1ywOiZ6YDPXm5HtZo7eRagpKdBNR7xpg=;
        b=elPcaoyp9xM4gXodOT3DV8AwcVjUaBeHvDJQ0gSwxeHS/BQ3frmqsMBZHVYf/KM9cq
         J7WMVuwx/PdFBVK6wMaDaNHHfbWBBbEnjW5RX2Zi9tA5r2ys3kTNgfkr8GaOwhezSmyO
         9vEiVlotHD+UPT6XT1EX1nLtjUNm5um9r7qiBdcAEptKZeOogHdp0JCnYCv3OV7IhOn/
         wZ7scI6iFNmrxZUllPKrGDCFSjlP7XLO34qB7FUI5MyDNwxpJFBP9oeyajZZ8uhNllvt
         Vyu/my4uj5mVJ2RunSrW1A7NT7D23po5UE8/+KMlUAFU9COF5dsW8IYqCwhuWQzk+VGB
         qisw==
X-Gm-Message-State: ABy/qLYBKqzuczpc7YCBNTcaUpNBN4iIxzKfbsLFq1E3jcHD9apOOgSI
        jLOv9ABIkdgjkEBUDaHtrbix43K2IvM=
X-Google-Smtp-Source: APBJJlF751SnqTSnU6vTW0Y18Fw9691eJmjowXxwgAdnr7jOeokEcu/hShizd7Z5E3jpc33zhy+X2tt4XMM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2086:0:b0:d07:a03b:38a2 with SMTP id
 g128-20020a252086000000b00d07a03b38a2mr19106ybg.10.1690594576926; Fri, 28 Jul
 2023 18:36:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 18:35:23 -0700
In-Reply-To: <20230729013535.1070024-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729013535.1070024-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729013535.1070024-18-seanjc@google.com>
Subject: [PATCH v4 17/29] drm/i915/gvt: Don't bother removing write-protection
 on to-be-deleted slot
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     kvm@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Yongwei Ma <yongwei.ma@intel.com>,
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

When handling a slot "flush", don't call back into KVM to drop write
protection for gfns in the slot.  Now that KVM rejects attempts to move
memory slots while KVMGT is attached, the only time a slot is "flushed"
is when it's being removed, i.e. the memslot and all its write-tracking
metadata is about to be deleted.

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index e9276500435d..3ea3cb9eb599 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1630,14 +1630,8 @@ static void kvmgt_page_track_flush_slot(struct kvm *kvm,
 
 	for (i = 0; i < slot->npages; i++) {
 		gfn = slot->base_gfn + i;
-		if (kvmgt_gfn_is_write_protected(info, gfn)) {
-			write_lock(&kvm->mmu_lock);
-			kvm_slot_page_track_remove_page(kvm, slot, gfn,
-						KVM_PAGE_TRACK_WRITE);
-			write_unlock(&kvm->mmu_lock);
-
+		if (kvmgt_gfn_is_write_protected(info, gfn))
 			kvmgt_protect_table_del(info, gfn);
-		}
 	}
 	mutex_unlock(&info->vgpu_lock);
 }
-- 
2.41.0.487.g6d72f3e995-goog

