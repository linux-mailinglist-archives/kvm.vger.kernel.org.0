Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0C39F173F
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 14:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731714AbfKFNhR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 08:37:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55597 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727022AbfKFNhE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 08:37:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573047423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=a4A/mMQkY14kjAgt3Bt+aoHAn+YimNMP05kIez+opDg=;
        b=MT8FjZlC2HKlhqsEtif1OwmvxkSw9A2NMYjrPNqC5sziS3io0KIMoY+W57atFSOh2XYsWE
        dCqqQmlB0WH0/aDVyizMT9dhHy14GUH9uYp7WMvPMI47cnMooC3S+I1vVoJQd/ISGGKgIO
        8k1yCONs18cY5mkr/zpd9mJPHjk3fR4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-3lGQ8HhkMcaUc1z8XZXVGA-1; Wed, 06 Nov 2019 08:37:00 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F3F7477;
        Wed,  6 Nov 2019 13:36:58 +0000 (UTC)
Received: from virtlab512.virt.lab.eng.bos.redhat.com (virtlab512.virt.lab.eng.bos.redhat.com [10.19.152.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 449395D9E5;
        Wed,  6 Nov 2019 13:36:51 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, mtosatti@redhat.com, rkrcmar@redhat.com,
        vkuznets@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Subject: [PATCH v1 0/2] KVM: deliver IOAPIC scan request only to the target vCPUs
Date:   Wed,  6 Nov 2019 08:36:36 -0500
Message-Id: <1573047398-7665-1-git-send-email-nitesh@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: 3lGQ8HhkMcaUc1z8XZXVGA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

IOAPIC scan requests with fixed delivery mode should only be delivered to t=
he vCPUs
specified by the destination ID.
The second patch in this patch-set introduces an additional
kvm_get_dest_vcpus_mask() API which retrieves a bitmap with bits set for ea=
ch
target vCPUs. This bitmap is later passed on to the kvm_make_vcpus_request_=
mask().

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

Nitesh Narayan Lal (1):
  KVM: x86: deliver KVM IOAPIC scan request to target vCPUs

Radim Kr=C4=8Dm=C3=A1=C5=99 (1):
  KVM: remember position in kvm->vcpus array

 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/ioapic.c           | 33 ++++++++++++++++++++++++++++--
 arch/x86/kvm/lapic.c            | 45 +++++++++++++++++++++++++++++++++++++=
++++
 arch/x86/kvm/lapic.h            |  3 +++
 arch/x86/kvm/x86.c              |  6 ++++++
 include/linux/kvm_host.h        | 13 +++++-------
 virt/kvm/kvm_main.c             | 19 ++++++++++++++++-
 7 files changed, 110 insertions(+), 11 deletions(-)

--=20

