Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8C31AE272
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 18:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgDQQos (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 12:44:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26408 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726694AbgDQQos (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Apr 2020 12:44:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587141887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=FFr7Xpb7/1UqdoZBjTKNeIgRsFQa+LGb0mOrrAFMJFY=;
        b=PzpfaCEAnd4iBWwWnxx3RiNb7pvLnsO7Vno4qQCv8xQRjl35xzn+WJuy6nJa2J7Ct36LSb
        PlOIz5V50pQOd2oSvpEqmzU+xG7PvDz4tg+hKZ0PBBPckjIDjma+ViJ/57ktvZHILqKwO/
        lSctwX5Rne7Zir12nXV0jrTpW34SmYE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-uWHtHPv_NXmCRHfLaDQP3g-1; Fri, 17 Apr 2020 12:44:45 -0400
X-MC-Unique: uWHtHPv_NXmCRHfLaDQP3g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89D2B1934100;
        Fri, 17 Apr 2020 16:44:14 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 007331001920;
        Fri, 17 Apr 2020 16:44:13 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH 0/3] KVM: x86: move nested-related kvm_x86_ops to a separate struct
Date:   Fri, 17 Apr 2020 12:44:10 -0400
Message-Id: <20200417164413.71885-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch 3 follows the lead of the kvm_pmu_ops and moves callbacks related
to nested virtualization to a separate struct.  Patches 1 and 2 are
preparation (patch 1 mostly makes some lines shorter, while patch 2
avoids semantic changes in KVM_GET_SUPPORTED_HV_CPUID).

While this reintroduces some pointer chasing that was removed in
afaf0b2f9b80 ("KVM: x86: Copy kvm_x86_ops by value to eliminate layer
of indirection", 2020-03-31), the cost is small compared to retpolines
and anyway most of the callbacks are not even remotely on a fastpath.
In fact, only check_nested_events should be called during normal VM
runtime.  When static calls are merged into Linux my plan is to use them
instead of callbacks, and that will finally make things fast again by
removing the retpolines.

Thanks,

Paolo

Paolo Bonzini (3):
  KVM: x86: check_nested_events is never NULL
  KVM: eVMCS: check if nesting is enabled
  KVM: x86: move nested-related kvm_x86_ops to a separate struct

 arch/x86/include/asm/kvm_host.h | 29 +++++++++++++++-------------
 arch/x86/kvm/hyperv.c           |  4 ++--
 arch/x86/kvm/svm/nested.c       |  6 +++++-
 arch/x86/kvm/svm/svm.c          | 13 +++++--------
 arch/x86/kvm/svm/svm.h          |  3 ++-
 arch/x86/kvm/vmx/evmcs.c        |  4 +++-
 arch/x86/kvm/vmx/nested.c       | 16 +++++++++-------
 arch/x86/kvm/vmx/nested.h       |  2 ++
 arch/x86/kvm/vmx/vmx.c          |  7 +------
 arch/x86/kvm/x86.c              | 34 ++++++++++++++++-----------------
 10 files changed, 62 insertions(+), 56 deletions(-)

-- 
2.18.2

