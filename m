Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D26D34CF54
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 13:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbhC2Lsb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 07:48:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59570 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231304AbhC2LsK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Mar 2021 07:48:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617018490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XBBhbaK4RjgYEf7pYCtNqcj852KHocFegJV6ZZyHbik=;
        b=SUIb51kMGcZ7cwd/bpdwSb6/t0CPfyh1j/qBl3EGcDMv3GvfIVYMDZE1Uv88GeErPaw52E
        CRMc/CYRs2NsPmfoak9MwFTtmncV1CSqjnNBbkaXL/O7zrhPFcJqZlmAI7C/XKu6eatS1k
        0W2NB8uF85H2FjI/p/KTgX9xuQJNOM0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-kZar8vd3PgO6U-y2Jj34Fw-1; Mon, 29 Mar 2021 07:48:08 -0400
X-MC-Unique: kZar8vd3PgO6U-y2Jj34Fw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB0CC180FCA5;
        Mon, 29 Mar 2021 11:48:06 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 765FB1001B2C;
        Mon, 29 Mar 2021 11:48:01 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v2 0/2] KVM: x86: hyper-v: Fix TSC page update after KVM_SET_CLOCK(0) call
Date:   Mon, 29 Mar 2021 13:47:58 +0200
Message-Id: <20210329114800.164066-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v1:
- Fix the issue by casting 'hv_clock->system_time' to s64 in 
 compute_tsc_page_parameters() instead of clamping its value to zero in
 kvm_guest_time_update() [Paolo]

Original description:

I discovered that after KVM_SET_CLOCK(0) TSC page value in the guest can
go through the roof and apparently we have a signedness issue when the
update is performed. Fix the issue and add a selftest.

Vitaly Kuznetsov (2):
  KVM: x86: hyper-v: Properly divide maybe-negative
    'hv_clock->system_time' in compute_tsc_page_parameters()
  selftests: kvm: Check that TSC page value is small after
    KVM_SET_CLOCK(0)

 arch/x86/kvm/hyperv.c                             |  9 ++++++---
 tools/testing/selftests/kvm/x86_64/hyperv_clock.c | 13 +++++++++++--
 2 files changed, 17 insertions(+), 5 deletions(-)

-- 
2.30.2

