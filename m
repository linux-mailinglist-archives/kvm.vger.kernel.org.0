Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 209AB37F661
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 13:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbhEMLIQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 07:08:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38197 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233190AbhEMLH4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 May 2021 07:07:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620904004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=gsWC6J70o6b0pVkL+gUwIw95ElvD0h548+CAgK/jyk8=;
        b=Z+QuSYdElK9rsEaFD/utHLNbYbTbyCXdDtF7llDud9F7EJL0aZyUs5bHvrWFkELB6Tmgaq
        I8Dh7HboSAgfrH8z/uMOgXhFoKojNvsXuzKo29Db/XDK7ZGK3Atc3voOT15tzdH23c6KNl
        G2Olu1IpNayJQNYWG3jZj3tO/JOeaJI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-AJtCcZ8pO0WKCjzLudgMyw-1; Thu, 13 May 2021 07:06:41 -0400
X-MC-Unique: AJtCcZ8pO0WKCjzLudgMyw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A49C501E8;
        Thu, 13 May 2021 11:06:40 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-43.bne.redhat.com [10.64.54.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E33315D6AC;
        Thu, 13 May 2021 11:06:37 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        drjones@redhat.com, pbonzini@redhat.com, maz@kernel.org
Subject: [PATCH] KVM: arm64: selftests: Request PMU feature in get-reg-list
Date:   Thu, 13 May 2021 21:06:55 +0800
Message-Id: <20210513130655.73154-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since the following commit, PMU registers are hidden from user until
it's explicitly requested by feeding feature (KVM_ARM_VCPU_PMU_V3).
Otherwise, 74 missing PMU registers are missing as the following
log indicates.

   11663111cd49 ("KVM: arm64: Hide PMU registers from userspace when not available")

   # ./get-reg-list
   Number blessed registers:   308
   Number registers:           238

   There are 74 missing registers.
   The following lines are missing registers:

      	ARM64_SYS_REG(3, 0, 9, 14, 1),
	ARM64_SYS_REG(3, 0, 9, 14, 2),
             :
	ARM64_SYS_REG(3, 3, 14, 15, 7),

This fixes the issue of wrongly reported missing PMU registers by
requesting it explicitly.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 tools/testing/selftests/kvm/aarch64/get-reg-list.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index 486932164cf2..6c6bdc6f5dc3 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -314,6 +314,8 @@ static void core_reg_fixup(void)
 
 static void prepare_vcpu_init(struct kvm_vcpu_init *init)
 {
+	init->features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
+
 	if (reg_list_sve())
 		init->features[0] |= 1 << KVM_ARM_VCPU_SVE;
 }
-- 
2.23.0

