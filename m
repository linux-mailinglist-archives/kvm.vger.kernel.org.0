Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8375A254B7F
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 19:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbgH0REs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 13:04:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37786 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726232AbgH0REr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Aug 2020 13:04:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598547885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=6skhDZK1eBFqInLIv6DlYJCfL20AefptLm3lM0sktaQ=;
        b=KysYfwv++BEGcBPflnLlC/v8oNnYgrJ6UYCVvRORnSFF5J3Ge2PBT37wZEScUzp5jjn76j
        Sy5t4SGWqd38h2Xrd5TgOaCBPsvt8sTI1qUQBO73ToKSu66BAvPgbQy8fPap9vTdOkKKeL
        q4Y6NLkLaUCK90E+lhKRtijBnBKA8+A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-vuJ0MpH5PuSgTyT0hBShIQ-1; Thu, 27 Aug 2020 13:04:41 -0400
X-MC-Unique: vuJ0MpH5PuSgTyT0hBShIQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DF13107464C;
        Thu, 27 Aug 2020 17:04:40 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2891919936;
        Thu, 27 Aug 2020 17:04:34 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/8] KVM: nSVM: ondemand nested state allocation + smm fixes
Date:   Thu, 27 Aug 2020 20:04:26 +0300
Message-Id: <20200827170434.284680-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series does some refactoring and implements on demand nested sta=
te area=0D
This way at least guests that don't use nesting won't waste memory=0D
on nested state.=0D
=0D
This patch series is based on patch series '[PATCH 0/3] Few nSVM bugfixes'=
=0D
(patch #7 here should have beeing moved there as well to be honest)=0D
=0D
The series was tested with various nested guests, and it seems to work=0D
as long as I disable the TSC deadline timer (this is unrelated to this=0D
patch series)=0D
=0D
I addressed the review feedback from V2, and added few refactoring=0D
patches to this series as suggested.=0D
=0D
Best regards,=0D
        Maxim Levitsky=0D
=0D
Maxim Levitsky (8):=0D
  KVM: SVM: rename a variable in the svm_create_vcpu=0D
  KVM: nSVM: rename nested vmcb to vmcb12=0D
  KVM: SVM: refactor msr permission bitmap allocation=0D
  KVM: SVM: use __GFP_ZERO instead of clear_page=0D
  KVM: SVM: refactor exit labels in svm_create_vcpu=0D
  KVM: x86: allow kvm_x86_ops.set_efer to return a value=0D
  KVM: emulator: more strict rsm checks.=0D
  KVM: nSVM: implement ondemand allocation of the nested state=0D
=0D
 arch/x86/include/asm/kvm_host.h |   2 +-=0D
 arch/x86/kvm/emulate.c          |  22 ++-=0D
 arch/x86/kvm/svm/nested.c       | 267 ++++++++++++++++++--------------=0D
 arch/x86/kvm/svm/svm.c          | 106 +++++++------=0D
 arch/x86/kvm/svm/svm.h          |  10 +-=0D
 arch/x86/kvm/vmx/vmx.c          |   9 +-=0D
 arch/x86/kvm/x86.c              |   3 +-=0D
 7 files changed, 243 insertions(+), 176 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

