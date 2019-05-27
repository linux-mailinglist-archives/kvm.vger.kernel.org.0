Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 106002AECD
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 08:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbfE0Gia (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 02:38:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:41140 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725943AbfE0Gi3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 02:38:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ACB3AAE07;
        Mon, 27 May 2019 06:38:28 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 3F883E00A9; Mon, 27 May 2019 08:38:28 +0200 (CEST)
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH] kvm: memunmap() also needs HAS_IOMEM
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Radim Krcmar" <rkrcmar@redhat.com>,
        KarimAllah Ahmed <karahmed@amazon.de>,
        linux-kernel@vger.kernel.org
Message-Id: <20190527063828.3F883E00A9@unicorn.suse.cz>
Date:   Mon, 27 May 2019 08:38:28 +0200 (CEST)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit d30b214d1d0a ("kvm: fix compilation on s390") addresses link error
(undefined reference to memremap) without HAS_IOMEM but memunmap() is also
only available with HAS_IOMEM enabled so that we need similar fix in
kvm_vcpu_unmap().

Fixes: e45adf665a53 ("KVM: Introduce a new guest mapping API")
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 virt/kvm/kvm_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 134ec0283a8a..301089a462c4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1795,8 +1795,10 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map,
 
 	if (map->page)
 		kunmap(map->page);
+#ifdef CONFIG_HAS_IOMEM
 	else
 		memunmap(map->hva);
+#endif
 
 	if (dirty) {
 		kvm_vcpu_mark_page_dirty(vcpu, map->gfn);
-- 
2.21.0

