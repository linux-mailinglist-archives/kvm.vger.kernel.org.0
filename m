Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D071F2E8D
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 13:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388392AbfKGMyA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 07:54:00 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20179 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726810AbfKGMyA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Nov 2019 07:54:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573131238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=6FLN7O1yAviKDZlM0e9S3vB8E0dXgIqkr70PMj8kw/c=;
        b=UfGwsjO+m3moK8Who9WIUbV38IooVt5T8NOuctXvXW2wKMJDQR8Bd1qiQturOuh9NRm9BY
        8tNzBGIet34WrzgagWzsB/pnbojCWNFxJml8BcAlzh0MB2BiCSHGovPCFGVOePCuPKAAl9
        HkoYSoH+oX7ENEF9BIcLHJiwO1mlrm0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-JfVVaFmIPxSrfm964BNNTg-1; Thu, 07 Nov 2019 07:53:55 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B6071005500;
        Thu,  7 Nov 2019 12:53:53 +0000 (UTC)
Received: from virtlab512.virt.lab.eng.bos.redhat.com (virtlab512.virt.lab.eng.bos.redhat.com [10.19.152.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 51DCC1001B34;
        Thu,  7 Nov 2019 12:53:48 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, mtosatti@redhat.com, rkrcmar@redhat.com,
        vkuznets@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Subject: [PATCH v2 0/2] KVM: deliver IOAPIC scan request only to the target vCPUs
Date:   Thu,  7 Nov 2019 07:53:41 -0500
Message-Id: <1573131223-5685-1-git-send-email-nitesh@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: JfVVaFmIPxSrfm964BNNTg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

IOAPIC scan requests with fixed delivery mode should only be delivered to t=
he
vCPUs specified by the destination ID.
The second patch in this patch-set introduces an additional
kvm_get_dest_vcpus_mask() API which retrieves a bitmap with bits set for ea=
ch
target vCPUs. This bitmap is later passed on to the
kvm_make_vcpus_request_mask().

I have re-used the patch sent by Radim Kr=C4=8Dm=C3=A1=C5=99, which adds th=
e support to
remember the position of each vCPUs in kvm->vcpus array.
As I needed to find out the vCPUs index in kvm->vcpus array for setting the
bits in the bitmap corresponding to the target vCPUs.

This support will enable us to reduce the latency overhead on isolated
vCPUs caused by the IPI to process due to KVM_REQ_IOAPIC_SCAN. With the cur=
rent
implementation, the KVM_REQ_IOAPIC_SCAN is flushed on to all the vCPUs even
if it is meant for just one of them.

Testing:
I have added the support for testing IOAPIC logical and physical destinatio=
n
mode under Fixed Delivery mode to kvm-unit-test and used it to test this pa=
tch.
https://patchwork.kernel.org/cover/11230215/
Tested the scenario where kvm_apic_map_get_dest_lapic() returns false in
kvm_get_dest_vcpus_mask() using the same patch-set mentioned above.

Changes from v1:
https://lkml.org/lkml/2019/11/6/535
- Renamed vcpus_idx to vcpu_idx.
- Fixed a bug in kvm_get_dest_vcpus_mask(), which would have triggered when
=C2=A0 kvm_apic_map_get_dest_lapic() returned false.
- Removed kvm_make_cpus_request_mask() from kvm_main.c. Now, I am directly
=C2=A0 calling kvm_make_vcpus_request_mask() from
=C2=A0 kvm_make_scan_ioapic_request_mask().

Nitesh Narayan Lal (1):
  KVM: x86: deliver KVM IOAPIC scan request to target vCPUs

Radim Kr=C4=8Dm=C3=A1=C5=99 (1):
  KVM: remember position in kvm->vcpus array

 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/ioapic.c           | 33 +++++++++++++++++++++++++++++--
 arch/x86/kvm/lapic.c            | 44 +++++++++++++++++++++++++++++++++++++=
++++
 arch/x86/kvm/lapic.h            |  3 +++
 arch/x86/kvm/x86.c              | 14 +++++++++++++
 include/linux/kvm_host.h        | 13 +++++-------
 virt/kvm/kvm_main.c             |  5 +++--
 7 files changed, 102 insertions(+), 12 deletions(-)

-- =20

