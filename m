Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD8E261BED
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 21:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731717AbgIHTKv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 15:10:51 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49653 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731224AbgIHQFX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Sep 2020 12:05:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599581122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=KJcoVDyKewg3G3aOBDZEKOnoV7moFsQCTbWTRI6UTAU=;
        b=AA8RZ/lU2h3Y8M6YLYzCQP01tD5i6cTJVsM0KRMjuAgsVZHNFYwBHOHtWAo1KYVKjN3CjX
        +FaJvKIWL++VBj29l9LJEAfLZSIBX4PAsAsEptnLRiXxJ7Lb7ge/YEh5GtJzMDtDNC5En7
        3j3plaAXDWI3c74z/MkoF/H3zSC8xeo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-80-fQOSRBHaMYKFKVuipxgTTA-1; Tue, 08 Sep 2020 09:53:55 -0400
X-MC-Unique: fQOSRBHaMYKFKVuipxgTTA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D45F8801AE0;
        Tue,  8 Sep 2020 13:53:53 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 90D7360DA0;
        Tue,  8 Sep 2020 13:53:51 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>
Subject: [PATCH 0/2] x86/kvm: fix interrupts based APF mechanism
Date:   Tue,  8 Sep 2020 15:53:48 +0200
Message-Id: <20200908135350.355053-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linux-5.9 switched KVM guests to interrupt based APF mechanism for 'page
ready' events (instead of the previously used '#PF' exception) but a
collision with the newly introduced IDTENTRY magic happened and it wasn't
properly resolved. QEMU doesn't currently enable KVM_FEATURE_ASYNC_PF_INT
bit so the breakage is invisible but all KVM guests will hang as soon as
the bit will get exposed.

Vitaly Kuznetsov (2):
  x86/kvm: properly use DEFINE_IDTENTRY_SYSVEC() macro
  x86/kvm: don't forget to ACK async PF IRQ

 arch/x86/kernel/kvm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

-- 
2.25.4

