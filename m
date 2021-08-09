Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95EE63E480F
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 16:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235045AbhHIOzO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 10:55:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54193 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235126AbhHIOzA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Aug 2021 10:55:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628520879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Of72I49nauR2VhDblZZ+5IyF6nFKX4mvsTZhOlXnK2k=;
        b=b+ypKdAog2JbkTFovp2QJoPbyz0uQDOQrcnuEaSDZFAqBuIKcYLNGyg5iHKtlYmkpl/COA
        GLphoJkTw8QSTKD6f8Dl/3L0F0camr78U7q1B8JYVJeETTw4bTYvwgHEbaCLcNH0EfoM8w
        rJdrC93AJE1LUwa81Y1ljrVk42gw2qU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-4GVZdNtbNf2kvaxqGV2MhQ-1; Mon, 09 Aug 2021 10:54:37 -0400
X-MC-Unique: 4GVZdNtbNf2kvaxqGV2MhQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A9D910AFE50;
        Mon,  9 Aug 2021 14:54:24 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.220])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 62D9B749BB;
        Mon,  9 Aug 2021 14:53:44 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [PATCH 0/2] KVM: nSVM: avoid TOC/TOU race when checking vmcb12
Date:   Mon,  9 Aug 2021 16:53:41 +0200
Message-Id: <20210809145343.97685-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently there is a TOC/TOU race between the first check of vmcb12's
efer, cr0 and cr4 registers and the later save of their values in
svm_set_*, because the guest could modify the values in the meanwhile.

To solve this issue, this serie 1) moves the actual check nearer to the
usage (from nested_svm_vmrun to enter_svm_guest_mode), possible thanks
to the patch "KVM: nSVM: remove useless kvm_clear_*_queue"
and 2) adds local variables in enter_svm_guest_mode to save the
current value of efer, cr0 and cr4 and later use these to set the
vcpu->arch.* state.

Patch 1 just refactors the code to simplify the second patch, where
we move the TOC nearer to the TOU and use local variables.

Based-on: <20210802125634.309874-1-pbonzini@redhat.com>
Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>

Emanuele Giuseppe Esposito (2):
  KVM: nSVM: move nested_vmcb_check_cr3_cr4 logic in
    nested_vmcb_valid_sregs
  KVM: nSVM: temporarly save vmcb12's efer, cr0 and cr4 to avoid TOC/TOU
    races

 arch/x86/kvm/svm/nested.c | 99 ++++++++++++++++++---------------------
 1 file changed, 45 insertions(+), 54 deletions(-)

-- 
2.31.1

