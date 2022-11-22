Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D948634121
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 17:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234266AbiKVQO5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 11:14:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234100AbiKVQOZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 11:14:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56ED674A82
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:12:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669133519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=q/u2ywsqITyRS2vkYqlY++H7YAafgsFuK0CF1Xs2lzM=;
        b=g9JnwoLB5ooy9SivZpADXQ5t0VewU3ubwh+Wax4NSnhWE5mfc+bRRfNpp44yjHG2LSNSFX
        A/28apnySVjx/nMmzYmHsAYegxREzkEh05rruFjF0kO+53MPXgYytFAOH3CESKLwk7wGsN
        Rd2h5DWKkP9jUzsMw6VtfrHQoAmL4pI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-E4uTVwrwMdSTz6O_Rrv-Ww-1; Tue, 22 Nov 2022 11:11:56 -0500
X-MC-Unique: E4uTVwrwMdSTz6O_Rrv-Ww-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B46EB185A79C;
        Tue, 22 Nov 2022 16:11:55 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B48DD1121314;
        Tue, 22 Nov 2022 16:11:53 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Nico Boehr <nrb@linux.ibm.com>,
        Cathy Avery <cavery@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v3 00/27] kvm-unit-tests: set of fixes and new tests
Date:   Tue, 22 Nov 2022 18:11:25 +0200
Message-Id: <20221122161152.293072-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is set of fixes and new unit tests that I developed for the=0D
KVM unit tests.=0D
=0D
I also did some work to separate the SVM code into a minimal=0D
support library so that you could use it from an arbitrary test.=0D
=0D
V2:=0D
=0D
  - addressed review feedback, and futher cleaned up the svm tests=0D
    set to use less global variables=0D
    (the patches are large, but each changes one thing all over the tests, =
so hopefully not hard to review).=0D
=0D
Best regards,=0D
    Maxim Levitsky=0D
=0D
Maxim Levitsky (27):=0D
  x86: replace irq_{enable|disable}() with sti()/cli()=0D
  x86: introduce sti_nop() and sti_nop_cli()=0D
  x86: add few helper functions for apic local timer=0D
  svm: remove nop after stgi/clgi=0D
  svm: make svm_intr_intercept_mix_if/gif test a bit more robust=0D
  svm: use apic_start_timer/apic_stop_timer instead of open coding it=0D
  x86: Add test for #SMI during interrupt window=0D
  x86: Add a simple test for SYSENTER instruction.=0D
  svm: add simple nested shutdown test.=0D
  SVM: add two tests for exitintinto on exception=0D
  lib: Add random number generator=0D
  x86: add IPI stress test=0D
  svm: remove get_npt_pte extern=0D
  svm: move svm spec definitions to lib/x86/svm.h=0D
  svm: move some svm support functions into lib/x86/svm_lib.h=0D
  svm: move setup_svm() to svm_lib.c=0D
  svm: correctly skip if NPT not supported=0D
  svm: move vmcb_ident to svm_lib.c=0D
  svm: rewerite vm entry macros=0D
  svm: move v2 tests run into test_run=0D
  svm: cleanup the default_prepare=0D
  svm: introduce svm_vcpu=0D
  svm: introduce struct svm_test_context=0D
  svm: use svm_test_context in v2 tests=0D
  svm: move nested vcpu to test context=0D
  svm: move test_guest_func to test context=0D
  x86: ipi_stress: add optional SVM support=0D
=0D
 Makefile                  |    3 +-=0D
 README.md                 |    1 +=0D
 lib/prng.c                |   41 ++=0D
 lib/prng.h                |   23 +=0D
 lib/x86/apic.c            |   38 ++=0D
 lib/x86/apic.h            |    6 +=0D
 lib/x86/processor.h       |   39 +-=0D
 lib/x86/random.c          |   33 +=0D
 lib/x86/random.h          |   17 +=0D
 lib/x86/smp.c             |    2 +-=0D
 lib/x86/svm.h             |  367 +++++++++++=0D
 lib/x86/svm_lib.c         |  179 ++++++=0D
 lib/x86/svm_lib.h         |  151 +++++=0D
 scripts/arch-run.bash     |    2 +-=0D
 x86/Makefile.common       |    5 +-=0D
 x86/Makefile.x86_64       |    5 +=0D
 x86/apic.c                |    6 +-=0D
 x86/asyncpf.c             |    6 +-=0D
 x86/eventinj.c            |   22 +-=0D
 x86/hyperv_connections.c  |    2 +-=0D
 x86/hyperv_stimer.c       |    4 +-=0D
 x86/hyperv_synic.c        |    6 +-=0D
 x86/intel-iommu.c         |    2 +-=0D
 x86/ioapic.c              |   15 +-=0D
 x86/ipi_stress.c          |  244 +++++++=0D
 x86/pmu.c                 |    4 +-=0D
 x86/smm_int_window.c      |  118 ++++=0D
 x86/svm.c                 |  341 ++--------=0D
 x86/svm.h                 |  495 +-------------=0D
 x86/svm_npt.c             |   81 ++-=0D
 x86/svm_tests.c           | 1278 ++++++++++++++++++++++---------------=0D
 x86/sysenter.c            |  203 ++++++=0D
 x86/taskswitch2.c         |    4 +-=0D
 x86/tscdeadline_latency.c |    4 +-=0D
 x86/unittests.cfg         |   20 +=0D
 x86/vmexit.c              |   18 +-=0D
 x86/vmx_tests.c           |   47 +-=0D
 37 files changed, 2454 insertions(+), 1378 deletions(-)=0D
 create mode 100644 lib/prng.c=0D
 create mode 100644 lib/prng.h=0D
 create mode 100644 lib/x86/random.c=0D
 create mode 100644 lib/x86/random.h=0D
 create mode 100644 lib/x86/svm.h=0D
 create mode 100644 lib/x86/svm_lib.c=0D
 create mode 100644 lib/x86/svm_lib.h=0D
 create mode 100644 x86/ipi_stress.c=0D
 create mode 100644 x86/smm_int_window.c=0D
 create mode 100644 x86/sysenter.c=0D
=0D
-- =0D
2.34.3=0D
=0D

