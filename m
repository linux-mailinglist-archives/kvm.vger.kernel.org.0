Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD3F84C8D09
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 14:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235163AbiCAN43 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 08:56:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235159AbiCAN4X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 08:56:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B62CF9F3AB
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 05:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646142941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Vh025xasYH3lAD0rZlLLEDVRC/Yu4hHgdUH3WyvQrwA=;
        b=gxmgSubnTaxnXLVmCymHjXcigOk6fTkkOTYCTP+6UWTuSwovrovVowvJkq/V6Wp3j+ApIj
        Y0c/UhPJHERP3V5PMWPRyi/LijFK41V3Er40yi/ie9gY9kTJePeIM1KilONFzggqSfSwkc
        754i9+xPk1NvjyGbyINse07odg4luI8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-zfU7u-X8PFiaxZkEB0hx8A-1; Tue, 01 Mar 2022 08:55:40 -0500
X-MC-Unique: zfU7u-X8PFiaxZkEB0hx8A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 144E2180FD72;
        Tue,  1 Mar 2022 13:55:38 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0AC6E1057FD1;
        Tue,  1 Mar 2022 13:55:27 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/4] SVM fixes + apic fix
Date:   Tue,  1 Mar 2022 15:55:22 +0200
Message-Id: <20220301135526.136554-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Those are few bug fixes which are in my patch queue,=0D
rebased against current kvm/queue.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (4):=0D
  KVM: x86: mark synthetic SMM vmexit as SVM_EXIT_SW=0D
  KVM: x86: SVM: disable preemption in avic_refresh_apicv_exec_ctrl=0D
  KVM: x86: SVM: use vmcb01 in avic_init_vmcb=0D
  KVM: x86: lapic: don't allow to set non default apic id when not using=0D
    x2apic api=0D
=0D
 arch/x86/kvm/lapic.c    | 17 ++++++++---------=0D
 arch/x86/kvm/svm/avic.c |  6 +++++-=0D
 arch/x86/kvm/svm/svm.c  |  2 +-=0D
 3 files changed, 14 insertions(+), 11 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

