Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889F14213B1
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 18:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236454AbhJDQM1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 12:12:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42303 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235966AbhJDQM0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 12:12:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633363837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FVbkf/jcBFVRfE0J9D7YHJAbSJJPgT+ifzPwiDUviTs=;
        b=b3NpiWp4ijdwDAbudElfAsYl19saL8CRi2cXebWL+S2F3I27hgOmeVsTkkSCJqdJqV4qQT
        mmwqB0F7MIk9A/I9xL47dsfwv5g0fas3gsu5mcHDoTlUk9wwIMmjVIX4kT1Vs0S52/RN5X
        a7DZ5hzerqz/KXPJKwrRKMFsxRI1Crg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-hCCZaHc_MPG_WGnU2LclOw-1; Mon, 04 Oct 2021 12:10:36 -0400
X-MC-Unique: hCCZaHc_MPG_WGnU2LclOw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C474284A5E1;
        Mon,  4 Oct 2021 16:10:34 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 618B618A50;
        Mon,  4 Oct 2021 16:10:31 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] KVM: nVMX: Enlightened MSR Bitmap feature for Hyper-V on KVM
Date:   Mon,  4 Oct 2021 18:10:25 +0200
Message-Id: <20211004161029.641155-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v1:
- Added Maxim's R-b tags to patches 1,2
- Moved nested.msr_bitmap_changed clearing from nested_get_vmcs12_pages()
  to nested_vmx_prepare_msr_bitmap [Maxim Levitsky]
- Rebased to current kvm/queue.

Updating MSR bitmap for L2 is not cheap and rearly needed. TLFS for Hyper-V
offers 'Enlightened MSR Bitmap' feature which allows L1 hypervisor to
inform L0 when it changes MSR bitmap, this eliminates the need to examine
L1's MSR bitmap for L2 every time when 'real' MSR bitmap for L2 gets
constructed.

When the feature is enabled for Win10+WSL2, it shaves off around 700 CPU
cycles from a nested vmexit cost (tight cpuid loop test).

First patch of the series is unrelated to the newly implemented feature,
it fixes a bug in Enlightened MSR Bitmap usage when KVM runs as a nested
hypervisor on top of Hyper-V.

Vitaly Kuznetsov (4):
  KVM: nVMX: Don't use Enlightened MSR Bitmap for L3
  KVM: VMX: Introduce vmx_msr_bitmap_l01_changed() helper
  KVM: nVMX: Track whether changes in L0 require MSR bitmap for L2 to be
    rebuilt
  KVM: nVMX: Implement Enlightened MSR Bitmap feature

 arch/x86/kvm/hyperv.c     |  2 ++
 arch/x86/kvm/vmx/nested.c | 29 +++++++++++++++++++++++++---
 arch/x86/kvm/vmx/vmx.c    | 40 ++++++++++++++++++++++++++-------------
 arch/x86/kvm/vmx/vmx.h    |  6 ++++++
 4 files changed, 61 insertions(+), 16 deletions(-)

-- 
2.31.1

