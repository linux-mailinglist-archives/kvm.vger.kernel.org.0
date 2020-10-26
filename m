Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723EE29926C
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 17:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1785958AbgJZQaV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 12:30:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20679 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1776214AbgJZQaV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Oct 2020 12:30:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603729820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/qVZfErBgM2F849WNZFnK/2eCYeC9hSvuEZ0ZfgFC2c=;
        b=gt+1Dd75zzfreQONIH9b2rG9k/L99CIijGswrNXdQ+cD7XiHkpsGOa3xbvipoQdUcLB4Kx
        4JjTgP+BgVzmC9M6h/2SdXim+UESjQEHXeWwg57bjrjLdLhGy6CUPWKu1t1gIaKI7n2NUE
        ICj0sPRTW6DodoGgg4bOM9HPVoEcyRM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-FPXA-Ii3NUahKeN95qi7FQ-1; Mon, 26 Oct 2020 12:30:18 -0400
X-MC-Unique: FPXA-Ii3NUahKeN95qi7FQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA7871084D64;
        Mon, 26 Oct 2020 16:30:16 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 861CF5B4AC;
        Mon, 26 Oct 2020 16:30:14 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jon Doron <arilou@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] KVM: x86: hyper-v: make KVM_GET_SUPPORTED_HV_CPUID more useful
Date:   Mon, 26 Oct 2020 17:30:11 +0100
Message-Id: <20201026163013.3164236-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v3:
- Rebase to the latest kvm/queue (KVM_CAP_SYS_HYPERV_CPUID changed to 191)

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

Vitaly Kuznetsov (2):
  KVM: x86: hyper-v: allow KVM_GET_SUPPORTED_HV_CPUID as a system ioctl
  KVM: selftests: test KVM_GET_SUPPORTED_HV_CPUID as a system ioctl

 Documentation/virt/kvm/api.rst                | 16 ++--
 arch/x86/kvm/hyperv.c                         |  6 +-
 arch/x86/kvm/hyperv.h                         |  4 +-
 arch/x86/kvm/vmx/evmcs.c                      |  3 +-
 arch/x86/kvm/x86.c                            | 45 ++++++----
 include/uapi/linux/kvm.h                      |  3 +-
 .../testing/selftests/kvm/include/kvm_util.h  |  2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 26 ++++++
 .../selftests/kvm/x86_64/hyperv_cpuid.c       | 87 +++++++++++--------
 9 files changed, 123 insertions(+), 69 deletions(-)

-- 
2.25.4

