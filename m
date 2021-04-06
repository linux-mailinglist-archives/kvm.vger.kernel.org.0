Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD54A355BFC
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 21:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237341AbhDFTH4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 15:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235663AbhDFTHy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 15:07:54 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2F0C061756
        for <kvm@vger.kernel.org>; Tue,  6 Apr 2021 12:07:44 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id h26so10747375qtm.13
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 12:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=+A1SrmIwbZ1FSLGZhqe9uQgP9D/HiOqOM3+S6Gii/38=;
        b=PgvSfT+fXAh6dZEtkAl7gx/WHOeTCqQmX9nUeKPm/cvqfkmjneuEeb4Kp9aufNpibv
         Aumvo4Kbq52Wf9hTPWAWx6K9Y+OXz39yEgrMsoRIGgovP3A1H169jn13Gx3bKnxsWKkw
         fYwaUSyabMe37APColz5hhdt06HPXCkIg5JacdurEnfK37fY04fAKmA1q64wLGOpkqNp
         Dl4ksebaI8Gyg6yRIj16m4EPJH0o5kefoVuDxjYrX3Ow7hOtiD1aW5PmZJxT0bW6fP7n
         wybt+5efodRRVUwe0h3DRFZkGfPEa2SXu6QE4ecAvNAbtdQ3vMAyvJjW2N9Wbk8JqZjp
         /zBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=+A1SrmIwbZ1FSLGZhqe9uQgP9D/HiOqOM3+S6Gii/38=;
        b=clCq7uYg6zNkciDWA59Cp6bp+NVGs1qWao60KjhOfuoQTYRL6kT1+luT28u4vj/Sz+
         de3ENRWhbkCPoFZvFQF+41Qbek0oaaunDbz28/eeKhFcxq1m/QXlsMedeS52g5lW3qP+
         +ZXZeRh8UnsaTxNvUz6Laj2HNxZBRtg6jB33wbMq6OrzRVDCxvOx5/yVwPRknbIiS3Qn
         HxHs9RqueN7tBGOG8qtKTmpyS7NXRhdKtnsxlJ08w+6xC9i95FciSJweKqBZ87LH21ja
         XX2VimpWmt0ehlBmJR+ZX7E91w1MnP1NSy5tpzSvFdUhJDDrPtNH8VoyaYXaGOOetTqM
         3gXQ==
X-Gm-Message-State: AOAM531H7O4tzP4s0filMm3F1AoLmv0dMWcKE4D0Ru9pjCsTDEjASj5V
        gNBukTvIb5BAHHpucg0lNmLGNSUX5w8=
X-Google-Smtp-Source: ABdhPJy2JLGhNT9+ISmHitMjw/KB5xcpDEWYnlaJYLIyRoj+RvbqxxoOq7PeaACZwl0qjuByKmf1yiR7pFw=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:24a1:90fb:182b:777c])
 (user=seanjc job=sendgmr) by 2002:ad4:4e4e:: with SMTP id eb14mr14413638qvb.14.1617736064053;
 Tue, 06 Apr 2021 12:07:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  6 Apr 2021 12:07:40 -0700
Message-Id: <20210406190740.4055679-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2] KVM: Explicitly use GFP_KERNEL_ACCOUNT for 'struct
 kvm_vcpu' allocations
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <kernellwp@gmail.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use GFP_KERNEL_ACCOUNT when allocating vCPUs to make it more obvious that
that the allocations are accounted, to make it easier to audit KVM's
allocations in the future, and to be consistent with other cache usage in
KVM.

When using SLAB/SLUB, this is a nop as the cache itself is created with
SLAB_ACCOUNT.

When using SLOB, there are caveats within caveats.  SLOB doesn't honor
SLAB_ACCOUNT, so passing GFP_KERNEL_ACCOUNT will result in vCPU
allocations now being accounted.   But, even that depends on internal
SLOB details as SLOB will only go to the page allocator when its cache is
depleted.  That just happens to be extremely likely for vCPUs because the
size of kvm_vcpu is larger than the a page for almost all combinations of
architecture and page size.  Whether or not the SLOB behavior is by
design is unknown; it's just as likely that no SLOB users care about
accounding and so no one has bothered to implemented support in SLOB.
Regardless, accounting vCPU allocations will not break SLOB+KVM+cgroup
users, if any exist.

Cc: Wanpeng Li <kernellwp@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

v2: Drop the Fixes tag and rewrite the changelog since this is a nop when
    using SLUB or SLAB. [Wanpeng]

 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0a481e7780f0..580f98386b42 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3192,7 +3192,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	if (r)
 		goto vcpu_decrement;
 
-	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
+	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
 	if (!vcpu) {
 		r = -ENOMEM;
 		goto vcpu_decrement;
-- 
2.31.0.208.g409f899ff0-goog

