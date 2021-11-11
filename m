Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC8C44DA64
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 17:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234260AbhKKQbB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 11:31:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:29513 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233921AbhKKQbA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 11:31:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636648091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DfOujgFevgbCfSH44hyzyJkrspxTIvbNw54TzLqJWDI=;
        b=RaE/Mz1+C05M+WWEw+suYforyGrHx19ejrCpW6u4EPzC/GdmxwIhWpF67dzd6SbeWnKHqo
        VE/VE9Lhrwtx/YcePrlCtJF8m7s514y56sD7UXt+0jSQzePHhZd4u+1ZQEchty4DSKogdp
        d2N5fr1GP7+pxDbaxhJlghRRObdOf/0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-9n7th--OM8ebvxxIBqNzjA-1; Thu, 11 Nov 2021 11:28:08 -0500
X-MC-Unique: 9n7th--OM8ebvxxIBqNzjA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C00787D541;
        Thu, 11 Nov 2021 16:28:05 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.82])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6EA561017CF3;
        Thu, 11 Nov 2021 16:27:55 +0000 (UTC)
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
        Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] KVM: arm64: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
Date:   Thu, 11 Nov 2021 17:27:42 +0100
Message-Id: <20211111162746.100598-2-vkuznets@redhat.com>
In-Reply-To: <20211111162746.100598-1-vkuznets@redhat.com>
References: <20211111162746.100598-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It doesn't make sense to return the recommended maximum number of
vCPUs which exceeds the maximum possible number of vCPUs.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/arm64/kvm/arm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7838e9fb693e..391dc7a921d5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -223,7 +223,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = 1;
 		break;
 	case KVM_CAP_NR_VCPUS:
-		r = num_online_cpus();
+		if (kvm)
+			r = min_t(unsigned int, num_online_cpus(),
+				  kvm->arch.max_vcpus);
+		else
+			r = min_t(unsigned int, num_online_cpus(),
+				  kvm_arm_default_max_vcpus());
 		break;
 	case KVM_CAP_MAX_VCPUS:
 	case KVM_CAP_MAX_VCPU_ID:
-- 
2.33.1

