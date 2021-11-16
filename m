Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB974537B9
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 17:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234876AbhKPQjA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 11:39:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26308 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232252AbhKPQi7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 11:38:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637080562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tKE+cntXrkzP99c9RfIwCSUBp3uLto7NMCtdS5oLqy0=;
        b=VxtbgHl79mPeqGQB3qNCa9C2stjzOwVQJwUGgyKgVWv/Bt7mztqxG2cWdfPPsS3EvahEDL
        ssAi6QmC1/KsuWBdABLIT/ztoDBK+5gs95l1iM4BdI2Nns3G8IG+WzkIMflCKvUshEEGVv
        vf3jT9hR88GaTCRMsZY72WJoWbtF0Qw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-_nOTq_pZMjC_gzlxlhMDlg-1; Tue, 16 Nov 2021 11:35:58 -0500
X-MC-Unique: _nOTq_pZMjC_gzlxlhMDlg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C96E1572D;
        Tue, 16 Nov 2021 16:35:56 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D893060C0F;
        Tue, 16 Nov 2021 16:35:50 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm-ppc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/6] KVM: s390: Cap KVM_CAP_NR_VCPUS by num_online_cpus()
Date:   Tue, 16 Nov 2021 17:34:42 +0100
Message-Id: <20211116163443.88707-6-vkuznets@redhat.com>
In-Reply-To: <20211116163443.88707-1-vkuznets@redhat.com>
References: <20211116163443.88707-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_CAP_NR_VCPUS is a legacy advisory value which on other architectures
return num_online_cpus() caped by KVM_CAP_NR_VCPUS or something else
(ppc and arm64 are special cases). On s390, KVM_CAP_NR_VCPUS returns
the same as KVM_CAP_MAX_VCPUS and this may turn out to be a bad
'advice'. Switch s390 to returning caped num_online_cpus() too.

Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/s390/kvm/kvm-s390.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6a6dd5e1daf6..1cfe36f6432e 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -585,6 +585,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 			r = KVM_MAX_VCPUS;
 		else if (sclp.has_esca && sclp.has_64bscao)
 			r = KVM_S390_ESCA_CPU_SLOTS;
+		if (ext == KVM_CAP_NR_VCPUS)
+			r = min_t(unsigned int, num_online_cpus(), r);
 		break;
 	case KVM_CAP_S390_COW:
 		r = MACHINE_HAS_ESOP;
-- 
2.33.1

