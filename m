Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7F320114F
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 17:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393871AbgFSPkE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 11:40:04 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:51195 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2393769AbgFSPjy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jun 2020 11:39:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592581193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ApAwRnIqoKoWTTJBXjZG+FIZOjIxYSpaUm7PAr6FKp4=;
        b=GcEVB0X6oP/RKM53ZFPfY9s9uvfMU0l1X56c9CrjLLlAXKC60hcY0tWxwUy6LXhVJKjl8X
        FhExEQWsYMDd3F1SccKXr3xrWVvV5POHrUl0vgw6n+Ah2FzN+Lg9e3A4VjbsXuexkeTJLA
        trqG0kvmLcpHnKys0bxLjxgzBFw+fMA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-T7shlh7sO1iy-CaAz7ymvA-1; Fri, 19 Jun 2020 11:39:50 -0400
X-MC-Unique: T7shlh7sO1iy-CaAz7ymvA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A53F81EDED;
        Fri, 19 Jun 2020 15:39:34 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-254.ams2.redhat.com [10.36.112.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C18460BF4;
        Fri, 19 Jun 2020 15:39:27 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, thomas.lendacky@amd.com,
        babu.moger@amd.com, Mohammed Gamal <mgamal@redhat.com>
Subject: [PATCH v2 00/11] KVM: Support guest MAXPHYADDR < host MAXPHYADDR
Date:   Fri, 19 Jun 2020 17:39:14 +0200
Message-Id: <20200619153925.79106-1-mgamal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When EPT/NPT is enabled, KVM does not really look at guest physical
address size. Address bits above maximum physical memory size are reserved.
Because KVM does not look at these guest physical addresses, it currently
effectively supports guest physical address sizes equal to the host.

This can be problem when having a mixed setup of machines with 5-level page
tables and machines with 4-level page tables, as live migration can change
MAXPHYADDR while the guest runs, which can theoretically introduce bugs.

In this patch series we add checks on guest physical addresses in EPT
violation/misconfig and NPF vmexits and if needed inject the proper
page faults in the guest.

A more subtle issue is when the host MAXPHYADDR is larger than that of the
guest. Page faults caused by reserved bits on the guest won't cause an EPT
violation/NPF and hence we also check guest MAXPHYADDR and add PFERR_RSVD_MASK
error code to the page fault if needed.

The last 3 patches (i.e. SVM bits and patch 11) are not intended for
immediate inclusion and probably need more discussion.
We've been noticing some unexpected behavior in handling NPF vmexits
on AMD CPUs (see individual patches for details), and thus we are
proposing a workaround (see last patch) that adds a capability that
userspace can use to decide who to deal with hosts that might have
issues supprting guest MAXPHYADDR < host MAXPHYADDR.


Mohammed Gamal (7):
  KVM: x86: Add helper functions for illegal GPA checking and page fault
    injection
  KVM: x86: mmu: Move translate_gpa() to mmu.c
  KVM: x86: mmu: Add guest physical address check in translate_gpa()
  KVM: VMX: Add guest physical address check in EPT violation and
    misconfig
  KVM: SVM: introduce svm_need_pf_intercept
  KVM: SVM: Add guest physical address check in NPF/PF interception
  KVM: x86: SVM: VMX: Make GUEST_MAXPHYADDR < HOST_MAXPHYADDR support
    configurable

Paolo Bonzini (4):
  KVM: x86: rename update_bp_intercept to update_exception_bitmap
  KVM: x86: update exception bitmap on CPUID changes
  KVM: VMX: introduce vmx_need_pf_intercept
  KVM: VMX: optimize #PF injection when MAXPHYADDR does not match

 arch/x86/include/asm/kvm_host.h | 10 ++------
 arch/x86/kvm/cpuid.c            |  2 ++
 arch/x86/kvm/mmu.h              |  6 +++++
 arch/x86/kvm/mmu/mmu.c          | 12 +++++++++
 arch/x86/kvm/svm/svm.c          | 41 +++++++++++++++++++++++++++---
 arch/x86/kvm/svm/svm.h          |  6 +++++
 arch/x86/kvm/vmx/nested.c       | 28 ++++++++++++--------
 arch/x86/kvm/vmx/vmx.c          | 45 +++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/vmx.h          |  6 +++++
 arch/x86/kvm/x86.c              | 29 ++++++++++++++++++++-
 arch/x86/kvm/x86.h              |  1 +
 include/uapi/linux/kvm.h        |  1 +
 12 files changed, 158 insertions(+), 29 deletions(-)

-- 
2.26.2

