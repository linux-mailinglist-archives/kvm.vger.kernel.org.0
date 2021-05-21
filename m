Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B93538C3F8
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 11:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237383AbhEUJzr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 05:55:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53846 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236316AbhEUJyW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 May 2021 05:54:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621590778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L2y4UY7mS22ucZnG9059BXjXbPgH018VPdiRxVoH0D0=;
        b=IXKsGHG8JTLvZWEx9NbMbfGc607CMjFh9PTx6hr4i9pEwU4mAREoKVjF9UtQmPHQkWJ+KB
        UfrfWYnThpp0ledjrqr9dsgu7OwZNpP4EoTPV0LGjMfnLPLkZOgSJMLxTJU8xs4EbCR1L4
        pwSnEUd4kBEz8d5OcIPBN9jUp9pDHrI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-CatLWyA2MmqZcQxUNlqRhA-1; Fri, 21 May 2021 05:52:56 -0400
X-MC-Unique: CatLWyA2MmqZcQxUNlqRhA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 57870800C60;
        Fri, 21 May 2021 09:52:55 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 223406A037;
        Fri, 21 May 2021 09:52:52 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 16/30] KVM: x86: hyper-v: Honor HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE privilege bit
Date:   Fri, 21 May 2021 11:51:50 +0200
Message-Id: <20210521095204.2161214-17-vkuznets@redhat.com>
In-Reply-To: <20210521095204.2161214-1-vkuznets@redhat.com>
References: <20210521095204.2161214-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4, HV_X64_MSR_CRASH_CTL are only
available to guest when HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE bit is
exposed.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index f416c9de73cb..43ebb53b6b38 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1253,6 +1253,10 @@ static bool hv_check_msr_access(struct kvm_vcpu_hv *hv_vcpu, u32 msr)
 	case HV_X64_MSR_TSC_EMULATION_STATUS:
 		return hv_vcpu->cpuid_cache.features_eax &
 			HV_ACCESS_REENLIGHTENMENT;
+	case HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4:
+	case HV_X64_MSR_CRASH_CTL:
+		return hv_vcpu->cpuid_cache.features_edx &
+			HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE;
 	default:
 		break;
 	}
-- 
2.31.1

