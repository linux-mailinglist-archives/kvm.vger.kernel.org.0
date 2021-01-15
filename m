Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 349CF2F7C65
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 14:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731973AbhAONU5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 08:20:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55752 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725946AbhAONU5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 08:20:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610716736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ao2xbbNQJXMqeVzp4UrdBWa4saqlByaCvu/toIAb94s=;
        b=NvrNGWeXpGUWhVuC2O8R9Ti340okiZUmCFFWRO7wcKkzNu+83I8qR/85d7Uc4cctOAhtYa
        GX9LnnO58JMyEOTjjY9KcdDI6BSujL1/urozBdDV4DqJoIiHbgc3B+hdIy1TCTvmX584Gb
        S9z3deV0vEJlx0xqnF6HSV3GeW8KcGA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-mEqvCrI_PYyPwMQT_uwyUg-1; Fri, 15 Jan 2021 08:18:54 -0500
X-MC-Unique: mEqvCrI_PYyPwMQT_uwyUg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 537EECE647;
        Fri, 15 Jan 2021 13:18:53 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CFD6760CCE;
        Fri, 15 Jan 2021 13:18:51 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH RFC 3/4] KVM: Define KVM_USER_MEM_SLOTS in arch-neutral include/linux/kvm_host.h
Date:   Fri, 15 Jan 2021 14:18:43 +0100
Message-Id: <20210115131844.468982-4-vkuznets@redhat.com>
In-Reply-To: <20210115131844.468982-1-vkuznets@redhat.com>
References: <20210115131844.468982-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Memory slots are allocated dynamically when added so the only real
limitation in KVM is 'id_to_index' array which is 'short'. Define
KVM_USER_MEM_SLOTS to the maximum possible value in the arch-neutral
include/linux/kvm_host.h, architectures can still overtide the setting
if needed.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 include/linux/kvm_host.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f3b1013fb22c..ab83a20a52ca 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -425,6 +425,10 @@ struct kvm_irq_routing_table {
 #define KVM_PRIVATE_MEM_SLOTS 0
 #endif
 
+#ifndef KVM_USER_MEM_SLOTS
+#define KVM_USER_MEM_SLOTS (SHRT_MAX - KVM_PRIVATE_MEM_SLOTS)
+#endif
+
 #ifndef KVM_MEM_SLOTS_NUM
 #define KVM_MEM_SLOTS_NUM (KVM_USER_MEM_SLOTS + KVM_PRIVATE_MEM_SLOTS)
 #endif
-- 
2.29.2

