Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F808201151
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 17:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393887AbgFSPkL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 11:40:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54755 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2393833AbgFSPkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jun 2020 11:40:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592581201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=We5wJ84o/aljkxoB41joXofmlMWZ48vbTILISgRltrw=;
        b=CYXdbyqv5EYC91AYlGLQqKY2849JZblIqcYgBIod8W0N3qFFrga2PohP3S51+ws5cy7Ebd
        3xRQ7++ZJuXq1jKCXZAeoQ2TroFVMRtQ1vz8zfsYggoFeDvjO+btrw+ymBe/Gx9+F2cGzB
        Yuycpr0lIXJjD7pW/MKmwnJLwR5kHzo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-87-l2SPM01fOMa4Hx0H8gQnLQ-1; Fri, 19 Jun 2020 11:39:55 -0400
X-MC-Unique: l2SPM01fOMa4Hx0H8gQnLQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 30668107B266;
        Fri, 19 Jun 2020 15:39:54 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-254.ams2.redhat.com [10.36.112.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D5D6160BF4;
        Fri, 19 Jun 2020 15:39:49 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, thomas.lendacky@amd.com,
        babu.moger@amd.com
Subject: [PATCH v2 05/11] KVM: x86: update exception bitmap on CPUID changes
Date:   Fri, 19 Jun 2020 17:39:19 +0200
Message-Id: <20200619153925.79106-6-mgamal@redhat.com>
In-Reply-To: <20200619153925.79106-1-mgamal@redhat.com>
References: <20200619153925.79106-1-mgamal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

