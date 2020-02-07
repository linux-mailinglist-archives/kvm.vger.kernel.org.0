Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06A98155955
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 15:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbgBGO1a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 09:27:30 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:51734 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726954AbgBGO12 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 09:27:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581085647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jwJM7q/e9p9HXTIwr62/TuUkBLeaNLEHgFKTsr8PSuE=;
        b=eqBKQHTAHddWNI+Ccu3zIvtRvtyT1WfUy+yyWJtXeqA4r8ZeakaS7WqspPaWDnVsp1u9Cy
        Xm7Aj7ON7gLKRf37b51nQSEO1eMzKavYGkiSp0JwgNdIlnFclb0g0HYst1MJsTJPeKQyGX
        KJnG8SvyqHyO4X4c3jChRhba+8HeX6s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-1rZIaGQvNe2wvYr-CXgZYQ-1; Fri, 07 Feb 2020 09:27:25 -0500
X-MC-Unique: 1rZIaGQvNe2wvYr-CXgZYQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35674113787E;
        Fri,  7 Feb 2020 14:27:24 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ABF8C60BEC;
        Fri,  7 Feb 2020 14:27:17 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com
Cc:     thuth@redhat.com, drjones@redhat.com, wei.huang2@amd.com,
        krish.sadhukhan@oracle.com
Subject: [PATCH v5 0/4] selftests: KVM: AMD Nested SVM test infrastructure
Date:   Fri,  7 Feb 2020 15:27:11 +0100
Message-Id: <20200207142715.6166-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the basic infrastructure needed to test AMD nested SVM.
Also add a first basic vmcall test.

Best regards

Eric

This series can be found at:
https://github.com/eauger/linux/tree/v5.5-amd-svm-v5

History:
v4 -> v5:
- Added "selftests: KVM: Remove unused x86_register enum"
- reorder GPRs within gpr64_regs
- removed vmcb_hva and save_area_hva from svm_test_data
- remove the naming for vmcb_gpa in run_guest

v3 -> v4:
- gpr64_regs struct just contains 64b mode GPRs ordered
  as in x86_register
- cleanup in run_guest (vm* instructions) and reduce
  clubber list.
- add some comments

v2 -> v3:
- Took into account Vitaly's comment:
  - added "selftests: KVM: Replace get_gdt/idt_base() by
    get_gdt/idt()"
  - svm.h now is a copy of arch/x86/include/asm/svm.h
  - avoid duplicates

v1 -> v2:
- split into 2 patches
- remove the infrastructure to run low-level sub-tests and only
  keep vmmcall's one.
- move struct regs into processor.h
- force vmcb_gpa into rax in run_guest()

Eric Auger (4):
  selftests: KVM: Replace get_[gdt | idt]_base() by get_[gdt | idt]()
  selftests: KVM: Remove unused x86_register enum
  selftests: KVM: AMD Nested test infrastructure
  selftests: KVM: SVM: Add vmcall test

 tools/testing/selftests/kvm/Makefile          |   3 +-
 .../selftests/kvm/include/x86_64/processor.h  |  44 +--
 .../selftests/kvm/include/x86_64/svm.h        | 297 ++++++++++++++++++
 .../selftests/kvm/include/x86_64/svm_util.h   |  36 +++
 tools/testing/selftests/kvm/lib/x86_64/svm.c  | 159 ++++++++++
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  |   6 +-
 .../selftests/kvm/x86_64/svm_vmcall_test.c    |  79 +++++
 7 files changed, 598 insertions(+), 26 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/svm.h
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/svm_util.h
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/svm.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c

--=20
2.20.1

