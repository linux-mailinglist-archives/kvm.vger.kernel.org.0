Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8287844DA69
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 17:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234295AbhKKQbQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 11:31:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50222 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234057AbhKKQbP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 11:31:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636648105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NmiJDhyq+drucaTkVr87beK9OfQhHewmWSpxx8X97oU=;
        b=Rsa+JzLGxZeTVDM8H7o01rqK85ef5dVl87w4Bdwk4wLhAYNhGH8g1aLNYmoHafW740N+6F
        3B/TkiMzVJ3xgxVwRRrG/5ZAKse5XX4Ossaz7xPQxEc3bDdKFyNvEwwcliXVYTqiZ/vw51
        nJBV8/KCHu8UIhzgfqs6VmdWiuO58V4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-542-hQfBFG5GMAaVZ8dBEiX5Ug-1; Thu, 11 Nov 2021 11:28:24 -0500
X-MC-Unique: hQfBFG5GMAaVZ8dBEiX5Ug-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F44010144F0;
        Thu, 11 Nov 2021 16:28:22 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.82])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E27FE1017E37;
        Thu, 11 Nov 2021 16:28:05 +0000 (UTC)
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
Subject: [PATCH 2/5] KVM: MIPS: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
Date:   Thu, 11 Nov 2021 17:27:43 +0100
Message-Id: <20211111162746.100598-3-vkuznets@redhat.com>
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
 arch/mips/kvm/mips.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 562aa878b266..aa20d074d388 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -1067,7 +1067,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = 1;
 		break;
 	case KVM_CAP_NR_VCPUS:
-		r = num_online_cpus();
+		r = min_t(unsigned int, num_online_cpus(), KVM_MAX_VCPUS);
 		break;
 	case KVM_CAP_MAX_VCPUS:
 		r = KVM_MAX_VCPUS;
-- 
2.33.1

