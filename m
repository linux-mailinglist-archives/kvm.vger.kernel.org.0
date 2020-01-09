Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCAE135A7A
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 14:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731165AbgAINr0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 08:47:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32228 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725839AbgAINr0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 08:47:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578577644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wcxAGEZpymOZcLKXkHX/7V/8SWLuXIEYNtbnwOyzIC8=;
        b=OuiLXYR7g9xAinhmz30O6Ad6s2yAGh1lWZP6n9R2Wfivgcrgt9VzsNttdCNf/oNIaxyZqa
        JevgtJZ/yz81lhc4Z68Yv/HPZphh94VOvsufF7xQeaXTzMRTPS3pLH/xVpYm9TMHt8E47L
        FcgefttY7OXtI7yVotLBxY+007jB4Vs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-z7PXUMgZPNK1HSE7hpByfw-1; Thu, 09 Jan 2020 08:47:21 -0500
X-MC-Unique: z7PXUMgZPNK1HSE7hpByfw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94E2B1088392;
        Thu,  9 Jan 2020 13:47:20 +0000 (UTC)
Received: from localhost (dhcp-192-245.str.redhat.com [10.33.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8297D5DA2C;
        Thu,  9 Jan 2020 13:47:17 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH] KVM: s390: check if kernel irqchip is actually enabled
Date:   Thu,  9 Jan 2020 14:47:13 +0100
Message-Id: <20200109134713.14755-1-cohuck@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On s390, we only allow userspace to create an in-kernel irqchip
if it has first enabled the KVM_CAP_S390_IRQCHIP vm capability.
Let's assume that a userspace that enabled that capability has
created an irqchip as well.

Fixes: 84223598778b ("KVM: s390: irq routing for adapter interrupts.")
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---

A more precise check would be to add a field in kvm_arch that tracks
whether an irqchip has actually been created; not sure if that is
really needed.

Found while trying to hunt down QEMU crashes with kvm-irqchip=3Doff;
this is not sufficient, though. I *think* everything but irqfds
should work without kvm-irqchip as well, but have not found the problem
yet.

---
 arch/s390/kvm/irq.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/irq.h b/arch/s390/kvm/irq.h
index 484608c71dd0..30e13d031379 100644
--- a/arch/s390/kvm/irq.h
+++ b/arch/s390/kvm/irq.h
@@ -13,7 +13,7 @@
=20
 static inline int irqchip_in_kernel(struct kvm *kvm)
 {
-	return 1;
+	return !!kvm->arch.use_irqchip;
 }
=20
 #endif
--=20
2.21.1

