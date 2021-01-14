Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDB42F5EF8
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 11:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbhANKjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 05:39:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30278 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728732AbhANKjJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 05:39:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610620663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+hJXtfkfIsQuOWJQwFllSA/VmwaaMSwqBRVC3R1TgZY=;
        b=YR/6yo4jt6qzH6fOSdyOKJGZ2MPgqeirA5M5GzbUrToeRcTmCmcnmOFjGVAkUEmIEdn3gm
        wh4YBLL3aCDkqDNriur182CX1Cr+Lcx+CxxDYzUSPrO9OJOFN8wbuuN1qHInHgqY8rRrSd
        LEazB+L4MgHdZhW+0rd0CnzzVOXt1Jc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-qAFO6Wd9NrmhCjLZgaESvQ-1; Thu, 14 Jan 2021 05:37:40 -0500
X-MC-Unique: qAFO6Wd9NrmhCjLZgaESvQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F37C107ACF8;
        Thu, 14 Jan 2021 10:37:38 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-114-165.ams2.redhat.com [10.36.114.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B07287047A;
        Thu, 14 Jan 2021 10:37:29 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com
Cc:     alexandru.elisei@arm.com, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        shuah@kernel.org, pbonzini@redhat.com
Subject: [PATCH v2 5/9] KVM: arm: move has_run_once after the map_resources
Date:   Thu, 14 Jan 2021 11:37:04 +0100
Message-Id: <20210114103708.26763-6-eric.auger@redhat.com>
In-Reply-To: <20210114103708.26763-1-eric.auger@redhat.com>
References: <20210114103708.26763-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

has_run_once is set to true at the beginning of
kvm_vcpu_first_run_init(). This generally is not an issue
except when exercising the code with KVM selftests. for instance,
if kvm_vgic_map_resources() fails due to erroneous user settings,
has_run_once is set and this prevents from continuing
executing the test. This patch moves the assignment after the
kvm_vgic_map_resources().

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v1 -> v2:
- slight reword of the commit msg (for instance)
---
 arch/arm64/kvm/arm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 04c44853b103..580760e58980 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -573,8 +573,6 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	if (!kvm_arm_vcpu_is_finalized(vcpu))
 		return -EPERM;
 
-	vcpu->arch.has_run_once = true;
-
 	if (likely(irqchip_in_kernel(kvm))) {
 		/*
 		 * Map the VGIC hardware resources before running a vcpu the
@@ -591,6 +589,8 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 		static_branch_inc(&userspace_irqchip_in_use);
 	}
 
+	vcpu->arch.has_run_once = true;
+
 	ret = kvm_timer_enable(vcpu);
 	if (ret)
 		return ret;
-- 
2.21.3

