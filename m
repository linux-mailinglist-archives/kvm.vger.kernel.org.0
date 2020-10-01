Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4605A27FFB3
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 15:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732099AbgJANFv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 09:05:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20241 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731952AbgJANFt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Oct 2020 09:05:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601557548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1JG7ezNBqKZhBbCXdsZ165RW99M6aDw/GQyklFdmaXA=;
        b=avCjQAZbLxSXBADzfkLTzeTGE0x/IVO84lu8IEQpUffQRiEaTR289R1BKHmXph02H5OA5y
        iAHyx4yPtO9GdZELvk/GRN+zhOgmRQVfNg3AQhacP4aj4tmW6yKmPmhS9rehGt5J874XCY
        7lOdAImB3poijT2EctfPk0R45H4E2m8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-JSH1ATewPmOR9i5Wag52aw-1; Thu, 01 Oct 2020 09:05:47 -0400
X-MC-Unique: JSH1ATewPmOR9i5Wag52aw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9266B802B67;
        Thu,  1 Oct 2020 13:05:45 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E7295C1CF;
        Thu,  1 Oct 2020 13:05:43 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Wei Huang <whuang2@amd.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] KVM: x86: allow for more CPUID entries
Date:   Thu,  1 Oct 2020 15:05:38 +0200
Message-Id: <20201001130541.1398392-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since RFC:
- "KVM: x86: disconnect kvm_check_cpuid() from vcpu->arch.cpuid_entries"
  added to allow running kvm_check_cpuid() before vcpu->arch.cpuid_entries/
  vcpu->arch.cpuid_nent are changed [Sean Christopherson]
- Shorten local variable names in kvm_vcpu_ioctl_set_cpuid[,2]
  [Sean Christopherson]
- Drop unneeded 'out' labels from kvm_vcpu_ioctl_set_cpuid[,2]
  and return directly whenever possible [Sean Christopherson]

Original description:

With QEMU and newer AMD CPUs (namely: Epyc 'Rome') the current limit for
KVM_MAX_CPUID_ENTRIES(80) is reported to be hit. Last time it was raised
from '40' in 2010. We can, of course, just bump it a little bit to fix
the immediate issue but the report made me wonder why we need to pre-
allocate vcpu->arch.cpuid_entries array instead of sizing it dynamically.
This RFC is intended to feed my curiosity.

Very mildly tested with selftests/kvm-unit-tests and nothing seems to
break. I also don't have access to the system where the original issue
was reported but chances we're fixing it are very good IMO as just the
second patch alone was reported to be sufficient.

Reported-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

Vitaly Kuznetsov (3):
  KVM: x86: disconnect kvm_check_cpuid() from vcpu->arch.cpuid_entries
  KVM: x86: allocate vcpu->arch.cpuid_entries dynamically
  KVM: x86: bump KVM_MAX_CPUID_ENTRIES

 arch/x86/include/asm/kvm_host.h |   4 +-
 arch/x86/kvm/cpuid.c            | 123 +++++++++++++++++++-------------
 arch/x86/kvm/x86.c              |   1 +
 3 files changed, 75 insertions(+), 53 deletions(-)

-- 
2.25.4

