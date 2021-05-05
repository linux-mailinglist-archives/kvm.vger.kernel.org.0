Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BABF0373E50
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 17:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbhEEPT0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 11:19:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25149 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231995AbhEEPTZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 11:19:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620227908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uQ+znxrQIRFv+05hyI+fCjT9uFUvKbWwa+xMdmXjPWA=;
        b=co3kng0zEO7JhmNf7Snri0PIb1ffW5MM3Lii52C9/192Q3ysRkgRLJwSta13Ia6Tb7p0lC
        V5rDGFNnIMEDW5FKwQybgUlWM9s4TXe1/wqVQLx6h0QVbKGgETVVruxqxyydcu+4eIBB7O
        ZAZplkT3wLDuviKKvTWKXbgz8LXkONI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-1lfl42_XPj25mMG3K0TfdQ-1; Wed, 05 May 2021 11:18:27 -0400
X-MC-Unique: 1lfl42_XPj25mMG3K0TfdQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D10B824FAB;
        Wed,  5 May 2021 15:18:26 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 43D235C1A3;
        Wed,  5 May 2021 15:18:24 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] KVM: selftests: evmcs_test: Check issues induced by late eVMCS mapping upon restore
Date:   Wed,  5 May 2021 17:18:20 +0200
Message-Id: <20210505151823.1341678-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A regression was introduced by commit f2c7ef3ba955
("KVM: nSVM: cancel KVM_REQ_GET_NESTED_STATE_PAGES on nested vmexit"). When
L2->L1 exit is forced immediately after restoring nested state, 
KVM_REQ_GET_NESTED_STATE_PAGES request is cleared and VMCS12 changes (e.g.
fresh RIP) are not reflected to eVMCS. The consequent nested vCPU run gets
broken. Add a test for the condition (PATCH2). PATCH1 is a preparatory
change, PATCH3 adds a test for a situation when KVM_GET_NESTED_STATE is 
requested right after KVM_SET_NESTED_STATE, this is still broken in KVM
(so the patch is not to be committed).

Vitaly Kuznetsov (3):
  KVM: selftests: evmcs_test: Check that VMLAUNCH with bogus EVMPTR is
    causing #UD
  KVM: selftests: evmcs_test: Check that VMCS12 is alway properly synced
    to eVMCS after restore
  KVM: selftests: evmcs_test: Test that KVM_STATE_NESTED_EVMCS is never
    lost

 .../testing/selftests/kvm/x86_64/evmcs_test.c | 150 +++++++++++++-----
 1 file changed, 108 insertions(+), 42 deletions(-)

-- 
2.30.2

