Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3056518A08
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 14:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfEIMuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 08:50:50 -0400
Received: from 2.mo6.mail-out.ovh.net ([46.105.76.65]:55787 "EHLO
        2.mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfEIMuu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 08:50:50 -0400
Received: from player715.ha.ovh.net (unknown [10.108.54.203])
        by mo6.mail-out.ovh.net (Postfix) with ESMTP id 625C11BFA29
        for <kvm@vger.kernel.org>; Thu,  9 May 2019 14:34:00 +0200 (CEST)
Received: from kaod.org (deibp9eh1--blueice1n0.emea.ibm.com [195.212.29.162])
        (Authenticated sender: clg@kaod.org)
        by player715.ha.ovh.net (Postfix) with ESMTPSA id C2ABF5840F79;
        Thu,  9 May 2019 12:33:47 +0000 (UTC)
From:   =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
To:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
Subject: [PATCH v2] KVM: Remove useless checks in 'release' method of KVM device
Date:   Thu,  9 May 2019 14:33:44 +0200
Message-Id: <20190509123344.3031-1-clg@kaod.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 2177490423789947783
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrkeehgdehhecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no need to test for the device pointer validity when releasing
a KVM device. The file descriptor should identify it safely.

Fixes: 2bde9b3ec8bd ("KVM: Introduce a 'release' method for KVM devices")
Signed-off-by: Cédric Le Goater <clg@kaod.org>
Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---

 Changes since v1:

 - better commit log title.
 
 virt/kvm/kvm_main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 161830ec0aa5..ac15b8fd8399 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2939,12 +2939,6 @@ static int kvm_device_release(struct inode *inode, struct file *filp)
 	struct kvm_device *dev = filp->private_data;
 	struct kvm *kvm = dev->kvm;
 
-	if (!dev)
-		return -ENODEV;
-
-	if (dev->kvm != kvm)
-		return -EPERM;
-
 	if (dev->ops->release) {
 		mutex_lock(&kvm->lock);
 		list_del(&dev->vm_node);
-- 
2.20.1

