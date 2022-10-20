Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB29D605B2B
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 11:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiJTJbS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 05:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiJTJbN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 05:31:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4CE15381D
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 02:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666258268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=HREmpKeE6zG7wXYYBoUdQLZW+Or4137GWbBcA8ju1B4=;
        b=Gm1Pjx4315vmKUQmwW5w4PZ9x5zXCSKBXSuIMw0TL0Im353kfFkkmCqvHFdLjLZOX4DKRI
        0agIiwwretEIKhG0i88xCHoWQ2aUBmUjlISxVYf7p/sMTs0uXWs6UnhEWx5E/cDLQD8/pS
        EJSW1PRYAVAzwmB/CjZImmQMfHd9pS4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-posLbKhRPH6OIOo4sHzkZw-1; Thu, 20 Oct 2022 05:31:05 -0400
X-MC-Unique: posLbKhRPH6OIOo4sHzkZw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A02CD882820;
        Thu, 20 Oct 2022 09:31:04 +0000 (UTC)
Received: from localhost.localdomain (ovpn-192-51.brq.redhat.com [10.40.192.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75D0E49BB60;
        Thu, 20 Oct 2022 09:31:01 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/4] nSVM: fix L0 crash if L2 has shutdown condtion which L1 doesn't intercept
Date:   Thu, 20 Oct 2022 12:30:51 +0300
Message-Id: <20221020093055.224317-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Recently while trying to fix some unit tests I found another CVE in SVM nes=
ted code.=0D
=0D
In 'shutdown_interception' vmexit handler we call kvm_vcpu_reset.=0D
=0D
However if running nested and L1 doesn't intercept shutdown, we will still =
end=0D
up running this function and trigger a bug in it.=0D
=0D
The bug is that this function resets the 'vcpu->arch.hflags' without proper=
ly=0D
leaving the nested state, which leaves the vCPU in inconsistent state, whic=
h=0D
later triggers a kernel panic in SVM code.=0D
=0D
The same bug can likely be triggered by sending INIT via local apic to a vC=
PU=0D
which runs a nested guest.=0D
=0D
On VMX we are lucky that the issue can't happen because VMX always intercep=
ts=0D
triple faults, thus triple fault in L2 will always be redirected to L1.=0D
Plus the 'handle_triple_fault' of VMX doesn't reset the vCPU.=0D
=0D
INIT IPI can't happen on VMX either because INIT events are masked while in=
=0D
VMX mode.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (4):=0D
  KVM: x86: nSVM: leave nested mode on vCPU free=0D
  KVM: x86: nSVM: harden svm_free_nested against freeing vmcb02 while=0D
    still in use=0D
  KVM: x86: add kvm_leave_nested=0D
  KVM: x86: forcibly leave nested mode on vCPU reset=0D
=0D
 arch/x86/kvm/svm/nested.c | 6 +++---=0D
 arch/x86/kvm/svm/svm.c    | 1 +=0D
 arch/x86/kvm/vmx/nested.c | 3 ---=0D
 arch/x86/kvm/x86.c        | 9 ++++++++-=0D
 4 files changed, 12 insertions(+), 7 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

