Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440F227AD3E
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 13:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgI1Lvu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 07:51:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27458 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726564AbgI1Lvu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 07:51:50 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601293909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vxB4Elj1Nndu0kAFuc8Y1iPA4beSknlsdeTyCEnHbQI=;
        b=QgAbH5Xs4YMtXT2mAyr0cQ/2a28qYxZRwyZBI1DkczvUtqEOwJOQ7LeNihgqXABqOBiCBM
        Kps/8jTqA5Atx4DCR/7FfivLQuJInkgL+7ALr1xQ6QrgdMINSZyaED2BWMTpG9pbtxn1h/
        yfNkPud0u23QyoHjL5y94eI266QvU3o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-EsuNcFYqNSepjckz9hM-LA-1; Mon, 28 Sep 2020 07:51:47 -0400
X-MC-Unique: EsuNcFYqNSepjckz9hM-LA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49CC7100559B;
        Mon, 28 Sep 2020 11:51:45 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E910B19D7D;
        Mon, 28 Sep 2020 11:51:44 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com
Subject: [PATCH 0/2] KVM: nSVM: do not access MSR permission bitmap before KVM_RUN
Date:   Mon, 28 Sep 2020 07:51:42 -0400
Message-Id: <20200928115144.2446240-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Similar to what we need to do for VMX, the MSR permission bitmap
should not be accessed until the first KVM_RUN.  This is important
because the memory map might not be up-to-date at the time of
KVM_SET_NESTED_STATE.

Paolo Bonzini (2):
  KVM: x86: rename KVM_REQ_GET_VMCS12_PAGES
  KVM: nSVM: delay MSR permission processing to first nested VM run

 arch/x86/include/asm/kvm_host.h |  4 ++--
 arch/x86/kvm/svm/nested.c       | 20 ++++++++++++++++++--
 arch/x86/kvm/vmx/nested.c       |  8 ++++----
 arch/x86/kvm/x86.c              |  4 ++--
 4 files changed, 26 insertions(+), 10 deletions(-)

-- 
2.26.2

