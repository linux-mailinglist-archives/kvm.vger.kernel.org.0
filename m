Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C2D4B515E
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 14:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351749AbiBNNQa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 08:16:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354055AbiBNNQ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 08:16:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0C51F11E
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 05:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644844579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XPhmnDB6fu8E/hoDE9/GdeQZJ4dWtGNexac9axqOCko=;
        b=dOiegYA4gsL55Ic0SCKrfxoBgduLe6Z5drpKrPRTphWXN7KH+7ru4M2KrMhqJfk2pKagdw
        BWCbsphiEVHTggunDUWzMGxLhwrVAmld3ZlOGG+I5f6Vx3y468wpfKHxIwPvqF9XZVfWiB
        6XyspBwD0SA/gslRQ6qynGXLJWMWrh8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-PCSLg626MX2_3vAMjlpnoQ-1; Mon, 14 Feb 2022 08:16:16 -0500
X-MC-Unique: PCSLg626MX2_3vAMjlpnoQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E268808240;
        Mon, 14 Feb 2022 13:16:15 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D112106F75B;
        Mon, 14 Feb 2022 13:16:15 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH v2 0/5] kvm: x86: better handling of optional kvm_x86_ops
Date:   Mon, 14 Feb 2022 08:16:09 -0500
Message-Id: <20220214131614.3050333-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series is really two changes:

- patch 1 to 4 clean up optional kvm_x86_ops so that they are marked
  in kvm-x86-ops.h and the non-optional ones WARN if used incorrectly.
  As an additional outcome of the review, a few more uses of
  static_call_cond are introduced.

- patch 5 allows to NULL a few kvm_x86_ops that return a value, by
  using __static_call_ret0.

v1->v2:
- use KVM_X86_OP_OPTIONAL and KVM_X86_OP_OPTIONAL_RET0
- mark load_eoi_exitmap and set_virtual_apic_mode as optional
- fix module compilation of KVM

Paolo Bonzini (5):
  KVM: x86: use static_call_cond for optional callbacks
  KVM: x86: remove KVM_X86_OP_NULL and mark optional kvm_x86_ops
  KVM: x86: warn on incorrectly NULL static calls
  KVM: x86: make several AVIC callbacks optional
  KVM: x86: allow defining return-0 static calls

 arch/x86/include/asm/kvm-x86-ops.h | 104 +++++++++++++++--------------
 arch/x86/include/asm/kvm_host.h    |  11 ++-
 arch/x86/kvm/lapic.c               |  24 +++----
 arch/x86/kvm/svm/avic.c            |  23 -------
 arch/x86/kvm/svm/svm.c             |  30 ---------
 arch/x86/kvm/svm/svm.h             |   1 -
 arch/x86/kvm/x86.c                 |  16 ++---
 kernel/static_call.c               |   1 +
 8 files changed, 79 insertions(+), 131 deletions(-)

-- 
2.31.1

