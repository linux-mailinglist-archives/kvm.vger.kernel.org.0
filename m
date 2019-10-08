Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D548D0158
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 21:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730647AbfJHTnt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 15:43:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33304 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730442AbfJHTns (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 15:43:48 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2E17E3084025;
        Tue,  8 Oct 2019 19:43:48 +0000 (UTC)
Received: from vitty.brq.redhat.com (ovpn-204-92.brq.redhat.com [10.40.204.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86B335D6A7;
        Tue,  8 Oct 2019 19:43:46 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 3/3] selftests: kvm: vmx_dirty_log_test: skip the test when VMX is not supported
Date:   Tue,  8 Oct 2019 21:43:38 +0200
Message-Id: <20191008194338.24159-4-vkuznets@redhat.com>
In-Reply-To: <20191008194338.24159-1-vkuznets@redhat.com>
References: <20191008194338.24159-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Tue, 08 Oct 2019 19:43:48 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vmx_dirty_log_test fails on AMD and this is no surprise as it is VMX
specific. Bail early when nested VMX is unsupported.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
index 0bca1cfe2c1e..a223a6401258 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
@@ -78,6 +78,8 @@ int main(int argc, char *argv[])
 	struct ucall uc;
 	bool done = false;
 
+	nested_vmx_check_supported();
+
 	/* Create VM */
 	vm = vm_create_default(VCPU_ID, 0, l1_guest_code);
 	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
-- 
2.20.1

