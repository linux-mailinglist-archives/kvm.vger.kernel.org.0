Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF1FE37178B
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 17:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbhECPJz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 11:09:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43646 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229852AbhECPJy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 11:09:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620054541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3NSTvLyUxmHOiVo7fotK2BXG7bF8hMwAK4lLfzcPP+k=;
        b=d7H2rc5Gs0V1wR/LrH8zHK1J9FDP0j1cJ/JZ5Qm//NwO48SjOU29xIzYALQcbEDfos3M1B
        oos+v20LwMT0i173t3TrQEEpHV6DQ6ppU8OJTUBFFtLeFhtntO2A7LUVihrILVVx8WVl3Y
        cp5CNASh1R77SRgpT2ewtS+QvRfrLMU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-575-ynpy81ogPmqaVuiVqqWbYQ-1; Mon, 03 May 2021 11:08:59 -0400
X-MC-Unique: ynpy81ogPmqaVuiVqqWbYQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 06994107ACC7;
        Mon,  3 May 2021 15:08:58 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CFDFA19C45;
        Mon,  3 May 2021 15:08:55 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] KVM: nVMX: Fix migration of nested guests when eVMCS is in use
Date:   Mon,  3 May 2021 17:08:50 +0200
Message-Id: <20210503150854.1144255-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Win10 guests with WSL2 enabled sometimes crash on migration when
enlightened VMCS was used. The condition seems to be induced by the
situation when L2->L1 exit is caused immediately after migration and
before L2 gets a chance to run (e.g. when there's an interrupt pending).
The issue was introduced by commit f2c7ef3ba955 ("KVM: nSVM: cancel 
KVM_REQ_GET_NESTED_STATE_PAGES on nested vmexit") and the first patch
of the series addresses the immediate issue. The eVMCS mapping restoration
path, however, seems to be fragile and the rest of the series tries to
make it more future proof by including eVMCS GPA in the migration data.

Vitaly Kuznetsov (4):
  KVM: nVMX: Always make an attempt to map eVMCS after migration
  KVM: nVMX: Properly pad 'struct kvm_vmx_nested_state_hdr'
  KVM: nVMX: Introduce __nested_vmx_handle_enlightened_vmptrld()
  KVM: nVMX: Map enlightened VMCS upon restore when possible

 arch/x86/include/uapi/asm/kvm.h |  4 ++
 arch/x86/kvm/vmx/nested.c       | 82 +++++++++++++++++++++++----------
 2 files changed, 61 insertions(+), 25 deletions(-)

-- 
2.30.2

