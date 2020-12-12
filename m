Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0849B2D897F
	for <lists+kvm@lfdr.de>; Sat, 12 Dec 2020 19:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407812AbgLLS5M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Dec 2020 13:57:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47297 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407750AbgLLSwQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 12 Dec 2020 13:52:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607799050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jQHoHNYAV8SPm9x4gENdfPMBg5XjWAXfV/w36dOvvcc=;
        b=YQCrjFxnF8WMpHwQ/HtGOK0/sQXDpunHlKvibHZ6EK/HwzjvjZaWfj/X3P0pCDjDU+4dSY
        /uNHjQVgVhnEtBfcC1OEHwAxDH8yYXSHYNxZW938OihUA0OD4kdyoCZyt9WlKPEFscYEWc
        jxu+plF0DDrIRsxRE/st4uEQLCaJvAs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-Y9AFZVqmOSWcsl6hBVA-ZQ-1; Sat, 12 Dec 2020 13:50:46 -0500
X-MC-Unique: Y9AFZVqmOSWcsl6hBVA-ZQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20C941005504;
        Sat, 12 Dec 2020 18:50:45 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-115-41.ams2.redhat.com [10.36.115.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 24F2D1F069;
        Sat, 12 Dec 2020 18:50:38 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com
Cc:     alexandru.elisei@arm.com, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        shuah@kernel.org, pbonzini@redhat.com
Subject: [PATCH 5/9] KVM: arm: move has_run_once after the map_resources
Date:   Sat, 12 Dec 2020 19:50:06 +0100
Message-Id: <20201212185010.26579-6-eric.auger@redhat.com>
In-Reply-To: <20201212185010.26579-1-eric.auger@redhat.com>
References: <20201212185010.26579-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

has_run_once is set to true at the beginning of
kvm_vcpu_first_run_init(). This generally is not an issue
except when exercising the code with KVM selftests. Indeed,
if kvm_vgic_map_resources() fails due to erroneous user settings,
has_run_once is set and this prevents from continuing
executing the test. This patch moves the assignment after the
kvm_vgic_map_resources().

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arch/arm64/kvm/arm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c0ffb019ca8b..331fae6bff31 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -540,8 +540,6 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	if (!kvm_arm_vcpu_is_finalized(vcpu))
 		return -EPERM;
 
-	vcpu->arch.has_run_once = true;
-
 	if (likely(irqchip_in_kernel(kvm))) {
 		/*
 		 * Map the VGIC hardware resources before running a vcpu the
@@ -560,6 +558,8 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 		static_branch_inc(&userspace_irqchip_in_use);
 	}
 
+	vcpu->arch.has_run_once = true;
+
 	ret = kvm_timer_enable(vcpu);
 	if (ret)
 		return ret;
-- 
2.21.3

