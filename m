Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0DA453ED8E
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 20:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbiFFSIm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 14:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbiFFSIl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 14:08:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 37D721FCC7
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 11:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654538919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=U+KgFftnN6DMnXXkePugl57yvd3ZUVGOjzbkB2GcSPM=;
        b=ddAqL2JONNqzd0weJ3hw/r5YpsBuW7IFaSGsd6NsEcK32IWRMNtiLDogzT8fZ/SdthCAHG
        JZElrGtj+RJUzaDk9UNWfCBFqIWGtQRJnfU8ZgtPYvbMgRzarCIfFGB0Uvm2HAM0ddiPcm
        Z6tpbfd0MpCjvjMpBJdlZ1dpZpT2hoc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-252-_oL6_bKdNkef3f4x6Cg3LA-1; Mon, 06 Jun 2022 14:08:35 -0400
X-MC-Unique: _oL6_bKdNkef3f4x6Cg3LA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 888B8858EFF;
        Mon,  6 Jun 2022 18:08:34 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBC331121314;
        Mon,  6 Jun 2022 18:08:30 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 0/7] KVM: x86: AVIC/APICv patch queue
Date:   Mon,  6 Jun 2022 21:08:22 +0300
Message-Id: <20220606180829.102503-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series contains a few fixes that I worked on=0D
recently.=0D
=0D
Also included another attempt to add inhibit=0D
when the guest had changed apic id and/or apic base.=0D
=0D
I also tested AVIC with full preemption and=0D
found few bugs, which are now hopefully fixed.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (7):=0D
  KVM: x86: document AVIC/APICv inhibit reasons=0D
  KVM: x86: inhibit APICv/AVIC when the guest and/or host changes either=0D
    apic id or the apic base from their default values.=0D
  KVM: x86: SVM: remove avic's broken code that updated APIC ID=0D
  KVM: x86: SVM: fix avic_kick_target_vcpus_fast=0D
  KVM: x86: disable preemption while updating apicv inhibition=0D
  KVM: x86: disable preemption around the call to=0D
    kvm_arch_vcpu_{un|}blocking=0D
  KVM: x86: SVM: there is no need for preempt safe wrappers for=0D
    avic_vcpu_load/put=0D
=0D
 arch/x86/include/asm/kvm_host.h |  68 ++++++++++++-=0D
 arch/x86/kvm/lapic.c            |  27 ++++-=0D
 arch/x86/kvm/svm/avic.c         | 171 ++++++++++++++------------------=0D
 arch/x86/kvm/svm/svm.c          |   4 +-=0D
 arch/x86/kvm/svm/svm.h          |   4 +-=0D
 arch/x86/kvm/vmx/vmx.c          |   4 +-=0D
 arch/x86/kvm/x86.c              |   2 +=0D
 virt/kvm/kvm_main.c             |   8 +-=0D
 8 files changed, 180 insertions(+), 108 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

