Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCC347454C
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 15:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbhLNOjJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 09:39:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:37071 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233255AbhLNOjI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Dec 2021 09:39:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639492748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XnCTgHqgBTTsW/X9gnyUdbG/JiwmhzdIPk9DzvCicVg=;
        b=SoDmZIcGGj5aFsZnwWoEgzbJpizdo6Id41ImzFsqUhJyLexQ7BJj+6ZX2pVsrTv05BtSJS
        776n3cnV3APFBNT15geUm/dY1BQc17RbFnnRs0+ZDoZFVtumvPj7KcEs3YO6jZWBpYnlk3
        skDOXZiG59sgj+AkJJMyjWndm3qRHmU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-35-ycO1xHtJPauOfIJ2qJ36Vw-1; Tue, 14 Dec 2021 09:39:04 -0500
X-MC-Unique: ycO1xHtJPauOfIJ2qJ36Vw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BFCC81CCB9;
        Tue, 14 Dec 2021 14:39:03 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B5AA8756ED;
        Tue, 14 Dec 2021 14:39:00 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] KVM: nVMX: Fix Windows 11 + WSL2 + Enlightened VMCS
Date:   Tue, 14 Dec 2021 15:38:54 +0100
Message-Id: <20211214143859.111602-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Windows 11 with enabled Hyper-V role doesn't boot on KVM when Enlightened
VMCS interface is provided to it. The observed behavior doesn't conform to
Hyper-V TLFS. In particular, I'm observing 'VMREAD' instructions trying to
access field 0x4404 ("VM-exit interruption information"). TLFS, however, is
very clear this should not be happening:

"Any VMREAD or VMWRITE instructions while an enlightened VMCS is active is
unsupported and can result in unexpected behavior."

Microsoft confirms this is a bug in Hyper-V which is supposed to get fixed
eventually. For the time being, implement a workaround in KVM allowing 
VMREAD instructions to read from the currently loaded Enlightened VMCS.

Patches 1-2 are unrelated fixes to VMX feature MSR filtering when eVMCS is
enabled. Patches 3 and 4 are preparatory changes, patch 5 implements the
workaround.

Vitaly Kuznetsov (5):
  KVM: nVMX: Also filter MSR_IA32_VMX_TRUE_PINBASED_CTLS when eVMCS
  KVM: nVMX: eVMCS: Filter out VM_EXIT_SAVE_VMX_PREEMPTION_TIMER
  KVM: nVMX: Rename vmcs_to_field_offset{,_table} to
    vmcs12_field_offset{,_table}
  KVM: nVMX: Implement evmcs_field_offset() suitable for handle_vmread()
  KVM: nVMX: Allow VMREAD when Enlightened VMCS is in use

 arch/x86/kvm/vmx/evmcs.c  |  4 ++--
 arch/x86/kvm/vmx/evmcs.h  | 48 +++++++++++++++++++++++++++++++--------
 arch/x86/kvm/vmx/nested.c | 42 ++++++++++++++++++++++++----------
 arch/x86/kvm/vmx/vmcs12.c |  4 ++--
 arch/x86/kvm/vmx/vmcs12.h |  6 ++---
 5 files changed, 76 insertions(+), 28 deletions(-)

-- 
2.33.1

