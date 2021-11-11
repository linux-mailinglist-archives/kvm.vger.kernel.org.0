Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539BE44D977
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 16:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233966AbhKKPwZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 10:52:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38123 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233303AbhKKPwZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 10:52:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636645775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pbQfb0FQbccxBpdhc4TKBJeGDnusa2+WjQFWGi3jcio=;
        b=TUlfZ38Hccq4cfmPTaVYL4Lk8RPvIk/Di8RMdBgLdviFw5KTwpsw28ZyTt5yIKN1UXBgmZ
        oeCoJt3VqRJQNuwOh5dGaW9uH8J6j7uBsGHLkhe3icGWBszuj4yCFKwCam2QqhxYZoYKOz
        FWyEdxy1Sv9CNsNwoyfuBy3Yc9CARMo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-W4yU2YgjMIyFf9epqGoNhQ-1; Thu, 11 Nov 2021 10:49:32 -0500
X-MC-Unique: W4yU2YgjMIyFf9epqGoNhQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A5CA1B18BC9;
        Thu, 11 Nov 2021 15:49:31 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C9C4F60C36;
        Thu, 11 Nov 2021 15:49:30 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pgonda@google.com, seanjc@google.com
Subject: [PATCH v12 0/7] Add AMD SEV and SEV-ES intra host migration support
Date:   Thu, 11 Nov 2021 10:49:23 -0500
Message-Id: <20211111154930.3603189-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a fixed version of Peter Gonda's series.  The main change is
that it uses the "bugged" VM implementation (now renamed to "dead")
to ensure the source VM is inoperational, and that it correctly
charges the current cgroup for the ASID.

I also renamed the capability to KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM,
since it is similar to KVM_CAP_VM_COPY_ENC_CONTEXT_FROM.

Paolo Bonzini (2):
  KVM: generalize "bugged" VM to "dead" VM
  KVM: SEV: provide helpers to charge/uncharge misc_cg

Peter Gonda (5):
  KVM: SEV: Refactor out sev_es_state struct
  KVM: SEV: Add support for SEV intra host migration
  KVM: SEV: Add support for SEV-ES intra host migration
  selftest: KVM: Add open sev dev helper
  selftest: KVM: Add intra host migration tests

 Documentation/virt/kvm/api.rst                |  15 +
 arch/x86/include/asm/kvm_host.h               |   1 +
 arch/x86/kvm/svm/sev.c                        | 303 +++++++++++++++---
 arch/x86/kvm/svm/svm.c                        |   9 +-
 arch/x86/kvm/svm/svm.h                        |  28 +-
 arch/x86/kvm/x86.c                            |   8 +-
 include/linux/kvm_host.h                      |  12 +-
 include/uapi/linux/kvm.h                      |   1 +
 tools/testing/selftests/kvm/Makefile          |   3 +-
 .../testing/selftests/kvm/include/kvm_util.h  |   1 +
 .../selftests/kvm/include/x86_64/svm_util.h   |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  24 +-
 tools/testing/selftests/kvm/lib/x86_64/svm.c  |  13 +
 .../selftests/kvm/x86_64/sev_migrate_tests.c  | 203 ++++++++++++
 virt/kvm/kvm_main.c                           |  10 +-
 15 files changed, 551 insertions(+), 82 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c

-- 
2.27.0

