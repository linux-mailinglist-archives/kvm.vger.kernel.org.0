Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F682F7C63
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 14:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732842AbhAONUk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 08:20:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24946 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731154AbhAONUj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 08:20:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610716739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HXrO0z3NA/MOjhjd7HoZa0Hz80ReRRITKzujw+2yTqE=;
        b=hdQoZ42k0Qy/OwUFzEhjk35FXbDFLT6nXZi3msDZd7mhbqhxORkoGY0Rvx4I8gCVJbt/LW
        B+ydEW7hTn1++wumj9/PbxNJDGK6wn3yb+UxWBum8IvYaXX5Pv+ZD6+/lMPUlfEqhWdl7K
        KcU8lwX1yj2l8oBVy7kixwc9jjOvaRE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-26M0E_TCN0GXaCI0medALw-1; Fri, 15 Jan 2021 08:18:56 -0500
X-MC-Unique: 26M0E_TCN0GXaCI0medALw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20D10190A7A3;
        Fri, 15 Jan 2021 13:18:55 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A9ADB60CCE;
        Fri, 15 Jan 2021 13:18:53 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH RFC 4/4] KVM: x86: Stop limiting KVM_USER_MEM_SLOTS
Date:   Fri, 15 Jan 2021 14:18:44 +0100
Message-Id: <20210115131844.468982-5-vkuznets@redhat.com>
In-Reply-To: <20210115131844.468982-1-vkuznets@redhat.com>
References: <20210115131844.468982-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current KVM_USER_MEM_SLOTS limit (509) can be a limiting factor for some
configurations. In particular, when QEMU tries to start a Windows guest
with Hyper-V SynIC enabled and e.g. 256 vCPUs the limit is hit as SynIC
requires two pages per vCPU and the guest is free to pick any GFN for
each of them, this fragments memslots as QEMU wants to have a separate
memslot for each of these pages (which are supposed to act as 'overlay'
pages).

Memory slots are allocated dynamically in KVM when added so the only real
limitation is 'id_to_index' array which is 'short'. We don't have any
KVM_MEM_SLOTS_NUM/KVM_USER_MEM_SLOTS-sized statically defined arrays.

Let's drop the limitation.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1bcf67d76753..546b839de797 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -40,7 +40,7 @@
 #define KVM_MAX_VCPUS 288
 #define KVM_SOFT_MAX_VCPUS 240
 #define KVM_MAX_VCPU_ID 1023
-#define KVM_USER_MEM_SLOTS 509
+
 /* memory slots that are not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS 3
 
-- 
2.29.2

