Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4671036B225
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 13:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbhDZLO7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 07:14:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41637 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232492AbhDZLO4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Apr 2021 07:14:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619435655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=4EGSofxQx4brtBrsah9Z+zPRC9nWkVvSS5E/pnfMZn0=;
        b=E0S6t5qc1zssvPJR2i03GN7FsBl/xfOKirD79+vlmyeJMSCiGLYE6eNjkqYydjfnVzq4Ov
        JLrw0Dn3DpThH/RdoWS073q/3ZFrjlz3g74zeEJAPpLgyPrzoUk/wAfOrm0FupFIbsvcXo
        LJ+YxwtkrqTzH7h8x/txfEct/a2A99k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-78yYM6mCOhS2wonT2h580w-1; Mon, 26 Apr 2021 07:14:11 -0400
X-MC-Unique: 78yYM6mCOhS2wonT2h580w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ABF3F84B9A7;
        Mon, 26 Apr 2021 11:13:40 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.73])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BAE505D9F0;
        Mon, 26 Apr 2021 11:13:35 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 0/6] Introduce KVM_{GET|SET}_SREGS2 and fix PDPTR migration
Date:   Mon, 26 Apr 2021 14:13:27 +0300
Message-Id: <20210426111333.967729-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
Also if the user doesn't use the new SREG2 api, the PDPTR=0D
load after migration is now done on KVM_REQ_GET_NESTED_STATE_PAGES=0D
to at least read them correctly in cases when guest memory=0D
map is not up to date when nested state is loaded.=0D
=0D
This patch series was tested by doing nested migration test=0D
of 32 bit PAE L1 + 32 bit PAE L2 on AMD and Intel and by=0D
nested migration test of 64 bit L1 + 32 bit PAE L2 on AMD.=0D
The later test currently fails on Intel (regardless of my patches).=0D
=0D
Changes from V1:=0D
  - move only PDPTRS load to KVM_REQ_GET_NESTED_STATE_PAGES on VMX=0D
  - rebase on top of kvm/queue=0D
  - improve the KVM_GET_SREGS2 to have flag for PDPTRS=0D
    and remove padding=0D
=0D
Patches to qemu will be send soon as well.=0D
=0D
Best regards,=0D
        Maxim Levitskky=0D
=0D
Maxim Levitsky (6):=0D
  KVM: nSVM: refactor the CR3 reload on migration=0D
  KVM: nVMX: delay loading of PDPTRs to KVM_REQ_GET_NESTED_STATE_PAGES=0D
  KVM: x86: introduce kvm_register_clear_available=0D
  KVM: x86: Introduce KVM_GET_SREGS2 / KVM_SET_SREGS2=0D
  KVM: nSVM: avoid loading PDPTRs after migration when possible=0D
  KVM: nVMX: avoid loading PDPTRs after migration when possible=0D
=0D
 Documentation/virt/kvm/api.rst  |  48 +++++++++++=0D
 arch/x86/include/asm/kvm_host.h |   7 ++=0D
 arch/x86/include/uapi/asm/kvm.h |  13 +++=0D
 arch/x86/kvm/kvm_cache_regs.h   |  12 +++=0D
 arch/x86/kvm/svm/nested.c       |  33 ++++++--=0D
 arch/x86/kvm/svm/svm.c          |   6 +-=0D
 arch/x86/kvm/vmx/nested.c       |  24 ++++--=0D
 arch/x86/kvm/x86.c              | 139 ++++++++++++++++++++++++++------=0D
 include/uapi/linux/kvm.h        |   4 +=0D
 9 files changed, 246 insertions(+), 40 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

