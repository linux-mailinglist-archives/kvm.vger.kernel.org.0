Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 417A7FB49B
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 17:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbfKMQFn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 11:05:43 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:35648 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727528AbfKMQFm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 11:05:42 -0500
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iUv9D-0003v1-9C; Wed, 13 Nov 2019 17:05:35 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH] KVM: Forbid /dev/kvm being opened by a compat task when CONFIG_KVM_COMPAT=n
Date:   Wed, 13 Nov 2019 16:05:23 +0000
Message-Id: <20191113160523.16130-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, jhogan@kernel.org, paulus@ozlabs.org, borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com, sean.j.christopherson@intel.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, peter.maydell@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On a system without KVM_COMPAT, we prevent IOCTLs from being issued
by a compat task. Although this prevents most silly things from
happening, it can still confuse a 32bit userspace that is able
to open the kvm device (the qemu test suite seems to be pretty
mad with this behaviour).

Take a more radical approach and return a -ENODEV to the compat
task.

Reported-by: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/kvm_main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 543024c7a87f..1243e48dc717 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -122,7 +122,13 @@ static long kvm_vcpu_compat_ioctl(struct file *file, unsigned int ioctl,
 #else
 static long kvm_no_compat_ioctl(struct file *file, unsigned int ioctl,
 				unsigned long arg) { return -EINVAL; }
-#define KVM_COMPAT(c)	.compat_ioctl	= kvm_no_compat_ioctl
+
+static int kvm_no_compat_open(struct inode *inode, struct file *file)
+{
+	return is_compat_task() ? -ENODEV : 0;
+}
+#define KVM_COMPAT(c)	.compat_ioctl	= kvm_no_compat_ioctl,	\
+			.open		= kvm_no_compat_open
 #endif
 static int hardware_enable_all(void);
 static void hardware_disable_all(void);
-- 
2.20.1

