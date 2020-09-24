Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91542774A2
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 16:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbgIXO6T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 10:58:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43741 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728307AbgIXO6P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 10:58:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600959494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=kiRvf77/BW2pJi/JFFEx+okLfqnrBcg7+cHOh16//18=;
        b=Sxh4UaUSk12Y8bxKPMEHx4PqVflIvz3eu/HbOIglp3l35gzYeWs4ra88HPl4OTsda8H1aZ
        3wfhKLqvYejIF18J8IwZb+G2Kjo8h6MgTpxHnKrhy3xvO7fta2dl+lROicuxJCXlEXxH8S
        ePllBi+4qGwrW1Tw00WO5K/w37b7Kws=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171--Sk-b6pwOVm3bA48u1k4Lg-1; Thu, 24 Sep 2020 10:58:03 -0400
X-MC-Unique: -Sk-b6pwOVm3bA48u1k4Lg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F17D1008562;
        Thu, 24 Sep 2020 14:58:01 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.192.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B0BA55786;
        Thu, 24 Sep 2020 14:57:59 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jon Doron <arilou@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/7] KVM: x86: hyper-v: make KVM_GET_SUPPORTED_HV_CPUID more useful
Date:   Thu, 24 Sep 2020 16:57:50 +0200
Message-Id: <20200924145757.1035782-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v1:
- Rebased to kvm/queue [KVM_CAP_SYS_HYPERV_CPUID -> 188]

QEMU series using the feature:
https://lists.gnu.org/archive/html/qemu-devel/2020-09/msg02017.html

Original description:

KVM_GET_SUPPORTED_HV_CPUID was initially implemented as a vCPU ioctl but
this is not very useful when VMM is just trying to query which Hyper-V
features are supported by the host prior to creating VM/vCPUs. The data
in KVM_GET_SUPPORTED_HV_CPUID is mostly static with a few exceptions but
it seems we can change this. Add support for KVM_GET_SUPPORTED_HV_CPUID as
a system ioctl as well.

QEMU specific description:
In some cases QEMU needs to collect the information about which Hyper-V
features are supported by KVM and pass it up the stack. For non-hyper-v
features this is done with system-wide KVM_GET_SUPPORTED_CPUID/
KVM_GET_MSRS ioctls but Hyper-V specific features don't get in the output
(as Hyper-V CPUIDs intersect with KVM's). In QEMU, CPU feature expansion
happens before any KVM vcpus are created so KVM_GET_SUPPORTED_HV_CPUID
can't be used in its current shape.

Vitaly Kuznetsov (7):
  KVM: x86: hyper-v: Mention SynDBG CPUID leaves in api.rst
  KVM: x86: hyper-v: disallow configuring SynIC timers with no SynIC
  KVM: x86: hyper-v: make KVM_GET_SUPPORTED_HV_CPUID output independent
    of eVMCS enablement
  KVM: x86: hyper-v: always advertise HV_STIMER_DIRECT_MODE_AVAILABLE
  KVM: x86: hyper-v: drop now unneeded vcpu parameter from
    kvm_vcpu_ioctl_get_hv_cpuid()
  KVM: x86: hyper-v: allow KVM_GET_SUPPORTED_HV_CPUID as a system ioctl
  KVM: selftests: test KVM_GET_SUPPORTED_HV_CPUID as a system ioctl

 Documentation/virt/kvm/api.rst                | 12 +--
 arch/x86/include/asm/kvm_host.h               |  2 +-
 arch/x86/kvm/hyperv.c                         | 30 ++++----
 arch/x86/kvm/hyperv.h                         |  3 +-
 arch/x86/kvm/vmx/evmcs.c                      |  8 +-
 arch/x86/kvm/vmx/evmcs.h                      |  2 +-
 arch/x86/kvm/x86.c                            | 44 ++++++-----
 include/uapi/linux/kvm.h                      |  3 +-
 .../testing/selftests/kvm/include/kvm_util.h  |  2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 26 +++++++
 .../selftests/kvm/x86_64/hyperv_cpuid.c       | 77 +++++++++----------
 11 files changed, 120 insertions(+), 89 deletions(-)

-- 
2.25.4

