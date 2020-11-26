Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD24B2C5669
	for <lists+kvm@lfdr.de>; Thu, 26 Nov 2020 14:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391102AbgKZNqu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Nov 2020 08:46:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50116 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390834AbgKZNqt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Nov 2020 08:46:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606398409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZV1eVRFg54k0Zal0/KxnT+naLTq9uAHCIPcq+JSenDw=;
        b=AqP22zNYhPZjRXSHmGv4W3TcCBz71USGXO/6B5193vdvKDVZ9kkqjU4xNtj5QxDB4/w7WN
        8B+9aswj2u4iblZBbfiPn+I87JK5Qng8CQu2Vt3r9rJ02jShFok/Kw5uPi5BjJ33R1GvK/
        kDUfGB0LtGuWUmXnseVVkqjWMAulLCc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-Xn-HebAfNb6nwNvM1dGkkQ-1; Thu, 26 Nov 2020 08:46:47 -0500
X-MC-Unique: Xn-HebAfNb6nwNvM1dGkkQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D2E6193ECE3;
        Thu, 26 Nov 2020 13:46:46 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1D1010021AA;
        Thu, 26 Nov 2020 13:46:44 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, pbonzini@redhat.com
Subject: [PATCH 1/2] KVM: arm64: CSSELR_EL1 max is 13
Date:   Thu, 26 Nov 2020 14:46:40 +0100
Message-Id: <20201126134641.35231-2-drjones@redhat.com>
In-Reply-To: <20201126134641.35231-1-drjones@redhat.com>
References: <20201126134641.35231-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Not counting TnD, which KVM doesn't currently consider, CSSELR_EL1
can have a maximum value of 0b1101 (13), which corresponds to an
instruction cache at level 7. With CSSELR_MAX set to 12 we can
only select up to cache level 6. Change it to 14.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c1fac9836af1..ef453f7827fa 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -169,7 +169,7 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 static u32 cache_levels;
 
 /* CSSELR values; used to index KVM_REG_ARM_DEMUX_ID_CCSIDR */
-#define CSSELR_MAX 12
+#define CSSELR_MAX 14
 
 /* Which cache CCSIDR represents depends on CSSELR value. */
 static u32 get_ccsidr(u32 csselr)
-- 
2.26.2

