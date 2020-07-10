Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC69021B9E2
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 17:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728224AbgGJPsn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 11:48:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50242 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728178AbgGJPsh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 11:48:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594396116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=We5wJ84o/aljkxoB41joXofmlMWZ48vbTILISgRltrw=;
        b=hpA+e9fld7MUKyQJwX3Yv9T0CO97KMCb9RP9iJh6elZY6Dp23AR834NwWln6fNmqKu/UMW
        2HEhU5w5robCrot3tcpE9s1JCwLiJuCEX1vvX/MB9jXGPVWNldhr8TbJfcM9+FTm3jTog4
        YCtu+aZM6gFS0c45Z+l39G/dO/vGx98=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-SmA5nucdOz2_qG-395OCUw-1; Fri, 10 Jul 2020 11:48:34 -0400
X-MC-Unique: SmA5nucdOz2_qG-395OCUw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D6A1800C64;
        Fri, 10 Jul 2020 15:48:33 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-114-235.ams2.redhat.com [10.36.114.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A66447EF8E;
        Fri, 10 Jul 2020 15:48:30 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org
Subject: [PATCH v3 5/9] KVM: x86: update exception bitmap on CPUID changes
Date:   Fri, 10 Jul 2020 17:48:07 +0200
Message-Id: <20200710154811.418214-6-mgamal@redhat.com>
In-Reply-To: <20200710154811.418214-1-mgamal@redhat.com>
References: <20200710154811.418214-1-mgamal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

Allow vendor code to observe changes to MAXPHYADDR and start/stop
intercepting page faults.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 8a294f9747aa..ea5bbf2153bb 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -128,6 +128,8 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 	kvm_mmu_reset_context(vcpu);
 
 	kvm_pmu_refresh(vcpu);
+	kvm_x86_ops.update_exception_bitmap(vcpu);
+
 	return 0;
 }
 
-- 
2.26.2

