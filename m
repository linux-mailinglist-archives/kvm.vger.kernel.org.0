Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63564537A5
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 17:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234196AbhKPQiQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 11:38:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:37956 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234044AbhKPQiE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 11:38:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637080507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xVDknFf2nCeVQlDtcEI9s9kI+cRfWuofuSSpiZvEcD4=;
        b=IQgHdEs417O6NSV7cvkDqjERgV6KJgHsAWzIzRS1sKZtFIZZq8t64jNg3lYezHus6nG220
        haVmoAObcY08LDmsxn3DsglEE/2o006vKansawVMPBf0aVPUKG+gfjmFwuX2xacU5/sAla
        vKWHtnu0A5KxflDNJq1x0DFZyRg+enE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-hkd7BFgZMVaKSNGfz14umw-1; Tue, 16 Nov 2021 11:35:04 -0500
X-MC-Unique: hkd7BFgZMVaKSNGfz14umw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D27BA87D543;
        Tue, 16 Nov 2021 16:35:01 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 204FD60C0F;
        Tue, 16 Nov 2021 16:34:52 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm-ppc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/6] KVM: arm64: Cap KVM_CAP_NR_VCPUS by kvm_arm_default_max_vcpus()
Date:   Tue, 16 Nov 2021 17:34:38 +0100
Message-Id: <20211116163443.88707-2-vkuznets@redhat.com>
In-Reply-To: <20211116163443.88707-1-vkuznets@redhat.com>
References: <20211116163443.88707-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Generally, it doesn't make sense to return the recommended maximum number
of vCPUs which exceeds the maximum possible number of vCPUs.

Note: ARM64 is special as the value returned by KVM_CAP_MAX_VCPUS differs
depending on whether it is a system-wide ioctl or a per-VM one. Previously,
KVM_CAP_NR_VCPUS didn't have this difference and it seems preferable to
keep the status quo. Cap KVM_CAP_NR_VCPUS by kvm_arm_default_max_vcpus()
which is what gets returned by system-wide KVM_CAP_MAX_VCPUS.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/arm64/kvm/arm.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7838e9fb693e..0690c76def5d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -223,7 +223,14 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = 1;
 		break;
 	case KVM_CAP_NR_VCPUS:
-		r = num_online_cpus();
+		/*
+		 * ARM64 treats KVM_CAP_NR_CPUS differently from all other
+		 * architectures, as it does not always bound it to
+		 * num_online_cpus(). It should not matter much because this
+		 * is just an advisory value.
+		 */
+		r = min_t(unsigned int, num_online_cpus(),
+			  kvm_arm_default_max_vcpus());
 		break;
 	case KVM_CAP_MAX_VCPUS:
 	case KVM_CAP_MAX_VCPU_ID:
-- 
2.33.1

