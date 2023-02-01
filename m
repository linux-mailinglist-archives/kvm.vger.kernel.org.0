Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCD66866DC
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 14:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbjBAN37 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 08:29:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232260AbjBAN3x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 08:29:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298573FF3C
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 05:29:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675258152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WVZhHFqxaYwFzMBunRS7wzwewBfk2ypSvewsEHL38n4=;
        b=I5bo8WLc8d4VDXOyIM+XAD0tyFq8xcIgFQcM8CTiL0LCi9PJBGya6AJc2hFOw03JWIzR9q
        ihQHCUWYZMRnc99q4E8F2jkL98in8sTuKctZ0cLkNa3hEaje8mqzf1waXIGbHg/4Tuj6Cc
        GDiKz1ZPE+hFSrnUNjbyV/STHgTw8c4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556--jTa2-zGPn6Z9Z_7KBKPyw-1; Wed, 01 Feb 2023 08:29:09 -0500
X-MC-Unique: -jTa2-zGPn6Z9Z_7KBKPyw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CFBFA8027FD;
        Wed,  1 Feb 2023 13:29:08 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1666140C2064;
        Wed,  1 Feb 2023 13:29:08 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Ben Serebrin <serebrin@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [PATCH 0/3] KVM: support the cpu feature FLUSH_L1D
Date:   Wed,  1 Feb 2023 08:29:02 -0500
Message-Id: <20230201132905.549148-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As the title suggest, if the host cpu supports flush_l1d flag and
QEMU/userspace wants to boot a VM with the same flag (or emulate same
host features), KVM should be able to do so.

Patch 3 is the main fix, because if flush_l1d is not advertised by
KVM, a linux VM will erroneously mark
/sys/devices/system/cpu/vulnerabilities/mmio_stale_data
as vulnerable, even though it isn't since the host has the feature
and takes care of this. Not sure what would happen in the nested case though.

Patch 1 and 2 are just taken and refactored from Jim Mattison's serie that it
seems was lost a while ago:
https://patchwork.kernel.org/project/kvm/patch/20180814173049.21756-1-jmattson@google.com/

I thought it was worth re-posting them.

Thank you,
Emanuele

Emanuele Giuseppe Esposito (3):
  kvm: vmx: Add IA32_FLUSH_CMD guest support
  kvm: svm: Add IA32_FLUSH_CMD guest support
  kvm: x86: Advertise FLUSH_L1D to user space

 arch/x86/kvm/cpuid.c      |  2 +-
 arch/x86/kvm/svm/svm.c    | 44 ++++++++++++++++--------
 arch/x86/kvm/vmx/nested.c |  3 ++
 arch/x86/kvm/vmx/vmx.c    | 70 +++++++++++++++++++++++++--------------
 4 files changed, 80 insertions(+), 39 deletions(-)

-- 
2.39.1

