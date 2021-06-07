Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C56BC39D823
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 11:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbhFGJEF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 05:04:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32397 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230193AbhFGJEE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Jun 2021 05:04:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623056533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=6y4bPXafko5+G4PApCVrwklZB5xWMqNeD2Kae54wrKI=;
        b=PLCCIBLhcR2rk0NYJtRku3VYFcLDMuCoxNzB+jlInHC2TJqf8vAFHeGQksCIInTU2tYLxu
        YN4fXxA0ZBC66v2pQ/K1tgZzzs96xS2N4S2Fonc4/OzGZqZkqqRep0eAPQPX5SpBoOAtgD
        Pp6vaJTGnvia2heGLZ9whJICX9rzLYk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-WBdQ5GvgOuSHR_s4xZ_7ig-1; Mon, 07 Jun 2021 05:02:12 -0400
X-MC-Unique: WBdQ5GvgOuSHR_s4xZ_7ig-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87E1E101371F;
        Mon,  7 Jun 2021 09:02:10 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F8551037EA4;
        Mon,  7 Jun 2021 09:02:05 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jim Mattson <jmattson@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 0/8] Introduce KVM_{GET|SET}_SREGS2 and fix PDPTR migration
Date:   Mon,  7 Jun 2021 12:01:55 +0300
Message-Id: <20210607090203.133058-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
Changes from V2:=0D
  - I took in the patch series from Sean Christopherson that=0D
    removes the pdptrs_changed function and rebased my code=0D
    on top of it.=0D
  - I updated the SET_SREGS2 ioctl to load PDPTRS from memory=0D
    when user haven't given PDPTRS.=0D
  - Minor refactoring all over the place.=0D
=0D
Changes from V1:=0D
  - move only PDPTRS load to KVM_REQ_GET_NESTED_STATE_PAGES on VMX=0D
  - rebase on top of kvm/queue=0D
  - improve the KVM_GET_SREGS2 to have flag for PDPTRS=0D
    and remove padding=0D
=0D
Patches to qemu to enable this feature were sent as well.=0D
=0D
Maxim Levitsky (5):=0D
  KVM: nSVM: refactor the CR3 reload on migration=0D
  KVM: nVMX: delay loading of PDPTRs to KVM_REQ_GET_NESTED_STATE_PAGES=0D
  KVM: x86: introduce kvm_register_clear_available=0D
  KVM: x86: Introduce KVM_GET_SREGS2 / KVM_SET_SREGS2=0D
  KVM: x86: avoid loading PDPTRs after migration when possible=0D
=0D
Sean Christopherson (3):=0D
  KVM: nVMX: Drop obsolete (and pointless) pdptrs_changed() check=0D
  KVM: nSVM: Drop pointless pdptrs_changed() check on nested transition=0D
  KVM: x86: Always load PDPTRs on CR3 load for SVM w/o NPT and a PAE=0D
    guest=0D
=0D
 Documentation/virt/kvm/api.rst  |  48 +++++++++=0D
 arch/x86/include/asm/kvm_host.h |   7 +-=0D
 arch/x86/include/uapi/asm/kvm.h |  13 +++=0D
 arch/x86/kvm/kvm_cache_regs.h   |  12 +++=0D
 arch/x86/kvm/svm/nested.c       |  39 +++++--=0D
 arch/x86/kvm/svm/svm.c          |   6 +-=0D
 arch/x86/kvm/vmx/nested.c       |  32 ++++--=0D
 arch/x86/kvm/x86.c              | 176 +++++++++++++++++++++-----------=0D
 include/uapi/linux/kvm.h        |   4 +=0D
 9 files changed, 253 insertions(+), 84 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

