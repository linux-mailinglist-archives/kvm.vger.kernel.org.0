Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E42A4BA7B0
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 19:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244018AbiBQSIz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 13:08:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243991AbiBQSIw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 13:08:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 27A2F15F0BF
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 10:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645121317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/mzReXLZLc6tMkB5b5vqNxs8KSSNOnaDt2HEPY2pWPQ=;
        b=BxCzK7XJazYVz/UOP79rGfKECAzDvGZ4Km3/sNr3TjKGR8eVmEgpdo3r7rhjHXyegfKaNP
        y1bfW9ORDAGJ22vqAZdVIRxMDr3fyqiDoK/otp45TOcnfrmtw+eYfpfcfjuWKPS6dve1+u
        OFy+pZIhaSGTLV4SKjnu1X/Iri8oqmc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-OWoCh0mEM6yrXXK5RTYhJw-1; Thu, 17 Feb 2022 13:08:33 -0500
X-MC-Unique: OWoCh0mEM6yrXXK5RTYhJw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73D602F4C;
        Thu, 17 Feb 2022 18:08:32 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A3688276C;
        Thu, 17 Feb 2022 18:08:32 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH v3 0/6] kvm: x86: better handling of optional kvm_x86_ops
Date:   Thu, 17 Feb 2022 13:08:25 -0500
Message-Id: <20220217180831.288210-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series is really two changes:

- patch 1 remove a kvm_x86_ops callback.

- patch 2 to 5 clean up optional kvm_x86_ops so that they are marked
  in kvm-x86-ops.h and the non-optional ones WARN if used incorrectly.
  As an additional outcome of the review, a few more uses of
  static_call_cond are introduced.

- patch 6 allows to NULL a few kvm_x86_ops that return a value, by
  using __static_call_ret0.

v1->v2:
- use KVM_X86_OP_OPTIONAL and KVM_X86_OP_OPTIONAL_RET0
- mark load_eoi_exitmap and set_virtual_apic_mode as optional
- fix module compilation of KVM

v2->v3:
- new patch 1 to remove .has_accelerated_tpr
- do not expand KVM_X86_OP_OPTIONAL in KVM_X86_OP
- cosmetic changes to comments

Paolo Bonzini (6):
  KVM: x86: return 1 unconditionally for availability of KVM_CAP_VAPIC
  KVM: x86: use static_call_cond for optional callbacks
  KVM: x86: remove KVM_X86_OP_NULL and mark optional kvm_x86_ops
  KVM: x86: warn on incorrectly NULL members of kvm_x86_ops
  KVM: x86: make several AVIC callbacks optional
  KVM: x86: allow defining return-0 static calls

 arch/x86/include/asm/kvm-x86-ops.h | 104 +++++++++++++++--------------
 arch/x86/include/asm/kvm_host.h    |  14 ++--
 arch/x86/kvm/lapic.c               |  24 +++----
 arch/x86/kvm/svm/avic.c            |  23 -------
 arch/x86/kvm/svm/svm.c             |  30 ---------
 arch/x86/kvm/svm/svm.h             |   1 -
 arch/x86/kvm/vmx/vmx.c             |   6 --
 arch/x86/kvm/x86.c                 |  20 ++----
 kernel/static_call.c               |   1 +
 9 files changed, 81 insertions(+), 142 deletions(-)

-- 
2.31.1

