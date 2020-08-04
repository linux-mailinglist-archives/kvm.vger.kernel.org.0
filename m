Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0534923BE99
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 19:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729778AbgHDRId (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 13:08:33 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37624 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729022AbgHDRIX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Aug 2020 13:08:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596560902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u3R78I0xIcTidytSUpGka2ZN17jeItCiL5JpEI42hQQ=;
        b=PRbBgmSpYM1C7bDlwK9Wb1QpY8pXzDTZraUEXeKdZbH7OpxNLhKIAWfGFKYGHhvHxuSP8I
        ygdjLmvKOEuh8QyLydFITrP1i4YmRQDnsgRbVM/SjxmuyqiiShbOszLWXz1OzAc9TvM1N0
        oT0/B9iUXkzJgmxVeq51eshZ49HVhho=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-jk7L9GsZP6OljFwiSKzfAQ-1; Tue, 04 Aug 2020 13:06:10 -0400
X-MC-Unique: jk7L9GsZP6OljFwiSKzfAQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E32910059AB;
        Tue,  4 Aug 2020 17:06:09 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E048888D6B;
        Tue,  4 Aug 2020 17:06:07 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, steven.price@arm.com, pbonzini@redhat.com
Subject: [PATCH v2 1/6] KVM: arm64: pvtime: steal-time is only supported when configured
Date:   Tue,  4 Aug 2020 19:05:59 +0200
Message-Id: <20200804170604.42662-2-drjones@redhat.com>
In-Reply-To: <20200804170604.42662-1-drjones@redhat.com>
References: <20200804170604.42662-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't confuse the guest by saying steal-time is supported when
it hasn't been configured by userspace and won't work.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/pvtime.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
index f7b52ce1557e..c3ef4ebd6846 100644
--- a/arch/arm64/kvm/pvtime.c
+++ b/arch/arm64/kvm/pvtime.c
@@ -43,7 +43,8 @@ long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
 	switch (feature) {
 	case ARM_SMCCC_HV_PV_TIME_FEATURES:
 	case ARM_SMCCC_HV_PV_TIME_ST:
-		val = SMCCC_RET_SUCCESS;
+		if (vcpu->arch.steal.base != GPA_INVALID)
+			val = SMCCC_RET_SUCCESS;
 		break;
 	}
 
-- 
2.25.4

