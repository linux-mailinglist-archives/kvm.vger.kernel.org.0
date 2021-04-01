Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E43351D10
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234915AbhDASXl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:23:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37281 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235296AbhDASVD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 14:21:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617301262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Gy/ng5zCwEi0kvaEHLz2eineziKHWcaMJpVr9bUxhnU=;
        b=eVbfKshU0rpWhdVZISL+3gKcPPe2dx13MEssTleOKUce4PvALxlsUje8ppFQOOpgjg6QPq
        uWgTHCR2w9j/BP28yGgsrQjqRHFePTQ0gcE+BsWyrDXNd2dnY+JiWb4PkxVGfUfrMQ13x+
        lFe5teYzKZrUOMTpY9KPqIW9txVZX4Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-o6gNyiRcMtqFtV05SKEVdg-1; Thu, 01 Apr 2021 10:19:01 -0400
X-MC-Unique: o6gNyiRcMtqFtV05SKEVdg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17C831853032;
        Thu,  1 Apr 2021 14:18:20 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC2AA6F7EA;
        Thu,  1 Apr 2021 14:18:15 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/6] Introduce KVM_{GET|SET}_SREGS2 and fix PDPTR migration
Date:   Thu,  1 Apr 2021 17:18:08 +0300
Message-Id: <20210401141814.1029036-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch set aims to fix few flaws that were discovered=0D
in KVM_{GET|SET}_SREGS on x86:=0D
=0D
* There is no support for reading/writing PDPTRs although=0D
  these are considered to be part of the guest state.=0D
=0D
* There is useless interrupt bitmap which isn't needed=0D
=0D
* No support for future extensions (via flags and such)=0D
=0D
Final two patches in this patch series allow to=0D
correctly migrate PDPTRs when new API is used.=0D
=0D
This patch series was tested by doing nested migration test=0D
of 32 bit PAE L1 + 32 bit PAE L2 on AMD and Intel and by=0D
nested migration test of 64 bit L1 + 32 bit PAE L2 on AMD.=0D
The later test currently fails on Intel (regardless of my patches).=0D
=0D
Finally patch 2 in this patch series fixes a rare L0 kernel oops,=0D
which I can trigger by migrating a hyper-v machine.=0D
=0D
Best regards,=0D
	Maxim Levitskky=0D
=0D
Maxim Levitsky (6):=0D
  KVM: nVMX: delay loading of PDPTRs to KVM_REQ_GET_NESTED_STATE_PAGES=0D
  KVM: nSVM: call nested_svm_load_cr3 on nested state load=0D
  KVM: x86: introduce kvm_register_clear_available=0D
  KVM: x86: Introduce KVM_GET_SREGS2 / KVM_SET_SREGS2=0D
  KVM: nSVM: avoid loading PDPTRs after migration when possible=0D
  KVM: nVMX: avoid loading PDPTRs after migration when possible=0D
=0D
 Documentation/virt/kvm/api.rst  |  43 ++++++++++=0D
 arch/x86/include/asm/kvm_host.h |   7 ++=0D
 arch/x86/include/uapi/asm/kvm.h |  13 +++=0D
 arch/x86/kvm/kvm_cache_regs.h   |  12 +++=0D
 arch/x86/kvm/svm/nested.c       |  55 ++++++++-----=0D
 arch/x86/kvm/svm/svm.c          |   6 +-=0D
 arch/x86/kvm/vmx/nested.c       |  26 ++++--=0D
 arch/x86/kvm/x86.c              | 136 ++++++++++++++++++++++++++------=0D
 include/uapi/linux/kvm.h        |   5 ++=0D
 9 files changed, 249 insertions(+), 54 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

