Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A456C7B1851
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 12:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbjI1Khg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 06:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbjI1Khf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 06:37:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5D4126
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 03:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695897407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=/M1XGsBjJpvK/GnlGAlPbx2DaQFA1wRSQ+/UPgks3eY=;
        b=fFOI2Yzg91qQ1Un36Pd1EsBBXsDuUxGcbu9ckdsfU2abAwO0/Kia9dl4bNRRpKfGE2zdLN
        M8MT9GE4uyzoGm13NV8+c4Xau4M6BAbQPDJ7AxjSYZC5XxCatmM6AibwFsdxch377oXBQ3
        0ZBl55AmUzEXv9TAXaWtK3/xqQ2kPGA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-286-hcFT5IvcOmeAj929CVKO_g-1; Thu, 28 Sep 2023 06:36:44 -0400
X-MC-Unique: hcFT5IvcOmeAj929CVKO_g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13162802D38;
        Thu, 28 Sep 2023 10:36:44 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.226.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA59F492B16;
        Thu, 28 Sep 2023 10:36:41 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 0/4] KVM: x86: tracepoint updates
Date:   Thu, 28 Sep 2023 13:36:36 +0300
Message-Id: <20230928103640.78453-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series is intended to add some selected information=0D
to the kvm tracepoints to make it easier to gather insights about=0D
running nested guests.=0D
=0D
This patch series was developed together with a new x86 performance analysi=
s tool=0D
that I developed recently (https://gitlab.com/maximlevitsky/kvmon)=0D
which aims to be a better kvm_stat, and allows you at glance=0D
to see what is happening in a VM, including nesting.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (4):=0D
  KVM: x86: refactor req_immediate_exit logic=0D
  KVM: x86: add more information to the kvm_entry tracepoint=0D
  KVM: x86: add information about pending requests to kvm_exit=0D
    tracepoint=0D
  KVM: x86: add new nested vmexit tracepoints=0D
=0D
 arch/x86/include/asm/kvm-x86-ops.h |   2 +-=0D
 arch/x86/include/asm/kvm_host.h    |  10 +--=0D
 arch/x86/kvm/svm/nested.c          |  22 ++++++=0D
 arch/x86/kvm/svm/svm.c             |  22 +++++-=0D
 arch/x86/kvm/trace.h               | 105 +++++++++++++++++++++++++++--=0D
 arch/x86/kvm/vmx/nested.c          |  27 ++++++++=0D
 arch/x86/kvm/vmx/vmx.c             |  30 +++++----=0D
 arch/x86/kvm/vmx/vmx.h             |   2 -=0D
 arch/x86/kvm/x86.c                 |  34 +++++-----=0D
 9 files changed, 208 insertions(+), 46 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

