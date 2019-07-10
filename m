Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 281A66442F
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 11:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbfGJJNm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 05:13:42 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:32903 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727541AbfGJJNm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 05:13:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1562750021; x=1594286021;
  h=from:to:cc:subject:date:message-id;
  bh=Ba6zmy4mGWGl4ESd7RsEjdPzxqn1rF3/gl5upjYy9Go=;
  b=aDBbtcHWrwMjOkjFj0DzsT7g0CBAdg2bdJb55ksLzr5jN3USNYIRWbAH
   odKhd7iNl3Elo+sDBhlBtY30CizGK4lZSjvnvt/DaNUaK5LBG7zIbHFoO
   DVnWJOoN6HnvHhi7+PnqV/aA+Grx//q3fGRn4uGLAox+L6Zp21dQNd5G+
   Q=;
X-IronPort-AV: E=Sophos;i="5.62,474,1554768000"; 
   d="scan'208";a="810374755"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 10 Jul 2019 09:13:38 +0000
Received: from u54e1ad5160425a4b64ea.ant.amazon.com (iad7-ws-svc-lb50-vlan3.amazon.com [10.0.93.214])
        by email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com (Postfix) with ESMTPS id 8D0EEA1BE6;
        Wed, 10 Jul 2019 09:13:36 +0000 (UTC)
Received: from u54e1ad5160425a4b64ea.ant.amazon.com (localhost [127.0.0.1])
        by u54e1ad5160425a4b64ea.ant.amazon.com (8.15.2/8.15.2/Debian-3) with ESMTP id x6A9DYlb013434;
        Wed, 10 Jul 2019 11:13:34 +0200
Received: (from karahmed@localhost)
        by u54e1ad5160425a4b64ea.ant.amazon.com (8.15.2/8.15.2/Submit) id x6A9DYQh013432;
        Wed, 10 Jul 2019 11:13:34 +0200
From:   KarimAllah Ahmed <karahmed@amazon.de>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Cc:     KarimAllah Ahmed <karahmed@amazon.de>
Subject: [PATCH] KVM: Properly check if "page" is valid in kvm_vcpu_unmap
Date:   Wed, 10 Jul 2019 11:13:13 +0200
Message-Id: <1562749993-12840-1-git-send-email-karahmed@amazon.de>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The field "page" is initialized to KVM_UNMAPPED_PAGE when it is not used
(i.e. when the memory lives outside kernel control). So this check will
always end up using kunmap even for memremap regions.

Fixes: e45adf665a53 ("KVM: Introduce a new guest mapping API")
Signed-off-by: KarimAllah Ahmed <karahmed@amazon.de>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2f2d24a..e629766 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1790,7 +1790,7 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map,
 	if (!map->hva)
 		return;
 
-	if (map->page)
+	if (map->page != KVM_UNMAPPED_PAGE)
 		kunmap(map->page);
 #ifdef CONFIG_HAS_IOMEM
 	else
-- 
2.7.4

