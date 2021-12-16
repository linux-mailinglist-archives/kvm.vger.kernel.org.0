Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A714779B8
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 17:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239781AbhLPQwY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 11:52:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53837 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235311AbhLPQwX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Dec 2021 11:52:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639673542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rmRjF0yR+1jFr399uH+onlIYE7HiNv0Y/IJaL55Uyjg=;
        b=aNriZ8l43aFRiYG94mhsp6R5LSXo25nhCvXUsKomJVSGzDBRuY12k+YOgKM7h7UHkO5Dd6
        Ihqoo/JeQl2CA6pXJomfWNp/oG+kkO0NKxlbb68v/Y8RP4Q0jv1lgwJPlqPShz52ktqAu6
        hhcjt9ahtYSemvx77EI/Hk9QA0aA83k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-82-Fd0v_6dwMTOSkUBwtJpu_Q-1; Thu, 16 Dec 2021 11:52:19 -0500
X-MC-Unique: Fd0v_6dwMTOSkUBwtJpu_Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ECB3792502;
        Thu, 16 Dec 2021 16:52:17 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C0D175F904;
        Thu, 16 Dec 2021 16:52:14 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, oliver.sang@intel.com,
        Like Xu <like.xu@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] KVM: x86: Fix MSR_IA32_PERF_CAPABILITIES writes check and vmx_pmu_msrs_test
Date:   Thu, 16 Dec 2021 17:52:11 +0100
Message-Id: <20211216165213.338923-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a continuation of "KVM: selftests: Avoid KVM_SET_CPUID2 after 
KVM_RUN in vmx_pmu_msrs_test" work. Instead of fixing the immediate issue,
drop incorrect check in KVM which was making the result of host initiated
writes to MSR_IA32_PERF_CAPABILITIES dependent on guest visible CPUIDs and
the corresponding tests in vmx_pmu_msrs_test, this will also make the issue
reported by kernel test robot to go away.

Vitaly Kuznetsov (2):
  KVM: selftests: vmx_pmu_msrs_test: Drop tests mangling guest visible
    CPUIDs
  KVM: x86: Drop guest CPUID check for host initiated writes to
    MSR_IA32_PERF_CAPABILITIES

 arch/x86/kvm/x86.c                              |  2 +-
 .../selftests/kvm/x86_64/vmx_pmu_msrs_test.c    | 17 -----------------
 2 files changed, 1 insertion(+), 18 deletions(-)

-- 
2.33.1

