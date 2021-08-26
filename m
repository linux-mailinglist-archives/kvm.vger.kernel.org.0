Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80FFB3F875B
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 14:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241361AbhHZM0F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 08:26:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45988 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241120AbhHZM0F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 08:26:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629980717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HWkB0hMCTj2XBhUtByrzWehSDaGM0wCcYJx5IgcI9F8=;
        b=VP9DcCLUBM3d+IgVoBYKl1QPJv+bOYXygkoiNO02k36QeYLUi8db45WQy6T94rrxiptxYE
        KT3qOn0JLXwD+3j7RVgfgqt0swYJrFePGdRMMmZrt1K7YsSd8fBrnVTYSXcfCE0hTKC7pc
        4qH8dXGugwVZTMpljKrCAdpi+7oFoo4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-CdOrIS4KMmyBa0t-wNyriw-1; Thu, 26 Aug 2021 08:25:16 -0400
X-MC-Unique: CdOrIS4KMmyBa0t-wNyriw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F04ED1966322;
        Thu, 26 Aug 2021 12:25:14 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 45BFA60877;
        Thu, 26 Aug 2021 12:25:06 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/4] KVM: x86: Fix stack-out-of-bounds memory access from ioapic_write_indirect()
Date:   Thu, 26 Aug 2021 14:24:42 +0200
Message-Id: <20210826122442.966977-5-vkuznets@redhat.com>
In-Reply-To: <20210826122442.966977-1-vkuznets@redhat.com>
References: <20210826122442.966977-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KASAN reports the following issue:

 BUG: KASAN: stack-out-of-bounds in kvm_make_vcpus_request_mask+0x174/0x440 [kvm]
 Read of size 8 at addr ffffc9001364f638 by task qemu-kvm/4798

 CPU: 0 PID: 4798 Comm: qemu-kvm Tainted: G               X --------- ---
 Hardware name: AMD Corporation DAYTONA_X/DAYTONA_X, BIOS RYM0081C 07/13/2020
 Call Trace:
  dump_stack+0xa5/0xe6
  print_address_description.constprop.0+0x18/0x130
  ? kvm_make_vcpus_request_mask+0x174/0x440 [kvm]
  __kasan_report.cold+0x7f/0x114
  ? kvm_make_vcpus_request_mask+0x174/0x440 [kvm]
  kasan_report+0x38/0x50
  kasan_check_range+0xf5/0x1d0
  kvm_make_vcpus_request_mask+0x174/0x440 [kvm]
  kvm_make_scan_ioapic_request_mask+0x84/0xc0 [kvm]
  ? kvm_arch_exit+0x110/0x110 [kvm]
  ? sched_clock+0x5/0x10
  ioapic_write_indirect+0x59f/0x9e0 [kvm]
  ? static_obj+0xc0/0xc0
  ? __lock_acquired+0x1d2/0x8c0
  ? kvm_ioapic_eoi_inject_work+0x120/0x120 [kvm]

The problem appears to be that 'vcpu_bitmap' is allocated as a single long
on stack and it should really be KVM_MAX_VCPUS long. We also seem to clear
the lower 16 bits of it with bitmap_zero() for no particular reason (my
guess would be that 'bitmap' and 'vcpu_bitmap' variables in
kvm_bitmap_or_dest_vcpus() caused the confusion: while the later is indeed
16-bit long, the later should accommodate all possible vCPUs).

Fixes: 7ee30bc132c6 ("KVM: x86: deliver KVM IOAPIC scan request to target vCPUs")
Fixes: 9a2ae9f6b6bb ("KVM: x86: Zero the IOAPIC scan request dest vCPUs bitmap")
Reported-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/ioapic.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index ff005fe738a4..8c065da73f8e 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -319,8 +319,8 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 	unsigned index;
 	bool mask_before, mask_after;
 	union kvm_ioapic_redirect_entry *e;
-	unsigned long vcpu_bitmap;
 	int old_remote_irr, old_delivery_status, old_dest_id, old_dest_mode;
+	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
 
 	switch (ioapic->ioregsel) {
 	case IOAPIC_REG_VERSION:
@@ -384,9 +384,9 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 			irq.shorthand = APIC_DEST_NOSHORT;
 			irq.dest_id = e->fields.dest_id;
 			irq.msi_redir_hint = false;
-			bitmap_zero(&vcpu_bitmap, 16);
+			bitmap_zero(vcpu_bitmap, KVM_MAX_VCPUS);
 			kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq,
-						 &vcpu_bitmap);
+						 vcpu_bitmap);
 			if (old_dest_mode != e->fields.dest_mode ||
 			    old_dest_id != e->fields.dest_id) {
 				/*
@@ -399,10 +399,10 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 				    kvm_lapic_irq_dest_mode(
 					!!e->fields.dest_mode);
 				kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq,
-							 &vcpu_bitmap);
+							 vcpu_bitmap);
 			}
 			kvm_make_scan_ioapic_request_mask(ioapic->kvm,
-							  &vcpu_bitmap);
+							  vcpu_bitmap);
 		} else {
 			kvm_make_scan_ioapic_request(ioapic->kvm);
 		}
-- 
2.31.1

