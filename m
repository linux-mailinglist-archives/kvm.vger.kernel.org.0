Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3ED44B127
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 17:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239844AbhKIQbd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 11:31:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40050 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239782AbhKIQbc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Nov 2021 11:31:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636475325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1gLakwF4Eve2r/ZOKSyyyu4ALZgwnpk2T8Ddhd8zwjk=;
        b=gKHv7Zhuzz1RQLCAAupkMs2ed6spQUBT4/BTQQyE1EXRQXIhrvyH/S/gOYVWEnkaYvW0xG
        JkMiPJbyRaoLbx0xQnQg1CyzTNFp0vsNdM7T7Ex1V7UZaJhWea8Kex8FnxDhDS8Gr4biyN
        i56A0CAzY57owawmcL0UEZAdzPlbVmE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-hhzjrkFhOjmwxDLNMke4RA-1; Tue, 09 Nov 2021 11:28:42 -0500
X-MC-Unique: hhzjrkFhOjmwxDLNMke4RA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A0241019982;
        Tue,  9 Nov 2021 16:28:41 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DBC3656A96;
        Tue,  9 Nov 2021 16:28:36 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/8] KVM: nVMX: Enlightened MSR Bitmap feature for Hyper-V on KVM (+ KVM: x86: MSR filtering and related fixes)
Date:   Tue,  9 Nov 2021 17:28:27 +0100
Message-Id: <20211109162835.99475-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series combines "Enlightened MSR Bitmap feature for Hyper-V on KVM v4"
and Sean's "KVM: x86: MSR filtering and related fixes v4" 
(https://lore.kernel.org/kvm/20211109013047.2041518-1-seanjc@google.com/)
series as they're code dependent.

Changes in "Enlightened MSR Bitmap feature for Hyper-V on KVM v4" since
 v3 [Sean]:
- Move Hyper-V Enlightened MSR Bitmap in vmx_create_vcpu() and expand
  the comment.
- Add R-b tag to "KVM: VMX: Introduce vmx_msr_bitmap_l01_changed() helper".
- s,msr_bitmap_force_recalc,force_msr_bitmap_recalc,
- Drop unneeded 'out_clear_msr_bitmap_force_recalc' path from "KVM: nVMX:
  Implement Enlightened MSR Bitmap feature".

Original description of the feature:

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

Sean Christopherson (4):
  KVM: nVMX: Query current VMCS when determining if MSR bitmaps are in
    use
  KVM: nVMX: Handle dynamic MSR intercept toggling
  KVM: VMX: Macrofy the MSR bitmap getters and setters
  KVM: nVMX: Clean up x2APIC MSR handling for L2

Vitaly Kuznetsov (4):
  KVM: nVMX: Don't use Enlightened MSR Bitmap for L3
  KVM: VMX: Introduce vmx_msr_bitmap_l01_changed() helper
  KVM: nVMX: Track whether changes in L0 require MSR bitmap for L2 to be
    rebuilt
  KVM: nVMX: Implement Enlightened MSR Bitmap feature

 arch/x86/kvm/hyperv.c     |   2 +
 arch/x86/kvm/vmx/nested.c | 177 +++++++++++++++++---------------------
 arch/x86/kvm/vmx/vmx.c    |  94 +++++++-------------
 arch/x86/kvm/vmx/vmx.h    |  37 ++++++++
 4 files changed, 149 insertions(+), 161 deletions(-)

-- 
2.31.1

