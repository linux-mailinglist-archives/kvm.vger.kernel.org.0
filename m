Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28907A1A68
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 14:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfH2Mry (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 08:47:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53560 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbfH2Mry (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 08:47:54 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4759C8980F3;
        Thu, 29 Aug 2019 12:47:54 +0000 (UTC)
Received: from localhost (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B1125C1D6;
        Thu, 29 Aug 2019 12:47:51 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH] KVM: s390: improve documentation for S390_MEM_OP
Date:   Thu, 29 Aug 2019 14:47:46 +0200
Message-Id: <20190829124746.28665-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Thu, 29 Aug 2019 12:47:54 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly specify the valid ranges for size and ar, and reword
buf requirements a bit.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
supposed to go on top of "KVM: s390: Test for bad access register and
size at the start of S390_MEM_OP" (<20190829122517.31042-1-thuth@redhat.com>)
---
 Documentation/virt/kvm/api.txt | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
index 2d067767b617..76c9d6fdbfdb 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -3079,12 +3079,14 @@ This exception is also raised directly at the corresponding VCPU if the
 flag KVM_S390_MEMOP_F_INJECT_EXCEPTION is set in the "flags" field.
 
 The start address of the memory region has to be specified in the "gaddr"
-field, and the length of the region in the "size" field. "buf" is the buffer
-supplied by the userspace application where the read data should be written
-to for KVM_S390_MEMOP_LOGICAL_READ, or where the data that should be written
-is stored for a KVM_S390_MEMOP_LOGICAL_WRITE. "buf" is unused and can be NULL
-when KVM_S390_MEMOP_F_CHECK_ONLY is specified. "ar" designates the access
-register number to be used.
+field, and the length of the region in the "size" field (which must not
+be 0). The maximum value for "size" can be obtained by checking the
+KVM_CAP_S390_MEM_OP capability. "buf" is the buffer supplied by the
+userspace application where the read data should be written to for
+KVM_S390_MEMOP_LOGICAL_READ, or where the data that should be written is
+stored for a KVM_S390_MEMOP_LOGICAL_WRITE. When KVM_S390_MEMOP_F_CHECK_ONLY
+is specified, "buf" is unused and can be NULL. "ar" designates the access
+register number to be used; the valid range is 0..15.
 
 The "reserved" field is meant for future extensions. It is not used by
 KVM with the currently defined set of flags.
-- 
2.20.1

