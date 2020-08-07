Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A1923E94F
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 10:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgHGIkP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 04:40:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49201 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728040AbgHGIkN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 04:40:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596789612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1tapk5X882JkWKX+3cYAD+GMIrv4DCXAv+v7JG2RGp4=;
        b=BI661UTG9J4C1LJhWSB+PwIdiQHJlSzmBL9XckO/dGj1EqU52kHvsAO3P3i/r7xrehp82q
        PUCKF7i1k/M1VEKwHPclGV9VcQ5hNVWgXXXgCfUfEsCLFmnFhYItY6R9WWvkQGbGMVYFFZ
        QXPppQdBdTSjlSW6f4uXPRxT7hCQRc8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-D_5NxhDnMcWUlNv0PozHow-1; Fri, 07 Aug 2020 04:40:11 -0400
X-MC-Unique: D_5NxhDnMcWUlNv0PozHow-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3C5B8017FB;
        Fri,  7 Aug 2020 08:40:09 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8B3DF5C1D2;
        Fri,  7 Aug 2020 08:40:07 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jon Doron <arilou@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] KVM: x86: hyper-v: always advertise HV_STIMER_DIRECT_MODE_AVAILABLE
Date:   Fri,  7 Aug 2020 10:39:43 +0200
Message-Id: <20200807083946.377654-5-vkuznets@redhat.com>
In-Reply-To: <20200807083946.377654-1-vkuznets@redhat.com>
References: <20200807083946.377654-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

HV_STIMER_DIRECT_MODE_AVAILABLE is the last conditionally set feature bit
in KVM_GET_SUPPORTED_HV_CPUID but it doesn't have to be conditional: first,
this bit is only an indication to userspace VMM that direct mode stimers
are supported, it still requires manual enablement (enabling SynIC) to
work so no VMM should just blindly copy it to guest CPUIDs. Second,
lapic_in_kernel() is a must for SynIC. Expose the bit unconditionally.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 5a6831799544..a8ebaa66a8e1 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2027,13 +2027,7 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 			ent->ebx |= HV_DEBUGGING;
 			ent->edx |= HV_X64_GUEST_DEBUGGING_AVAILABLE;
 			ent->edx |= HV_FEATURE_DEBUG_MSRS_AVAILABLE;
-
-			/*
-			 * Direct Synthetic timers only make sense with in-kernel
-			 * LAPIC
-			 */
-			if (lapic_in_kernel(vcpu))
-				ent->edx |= HV_STIMER_DIRECT_MODE_AVAILABLE;
+			ent->edx |= HV_STIMER_DIRECT_MODE_AVAILABLE;
 
 			break;
 
-- 
2.25.4

