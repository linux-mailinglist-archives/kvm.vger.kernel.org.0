Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6CB24BEF5
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 15:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729070AbgHTNhL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 09:37:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28019 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729663AbgHTNd7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 09:33:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597930437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=X2fJCEf/hhnmDqCnQtY5hjOcNe8YUPEVscVUU8eAkMY=;
        b=FgUxwuImrHXMEeBy5azRmZsROXuXDEEzkyOt3QmFHc6HukJHlqW1Tt7LCRCo7rWmfaAaJW
        rDUNrSJRIdxHiy+wQe/31PsyKJGwR/Ny7aLW0S9Tke5+1VgRKw45xxQYkd9m0tWa/bW1pi
        vNvh1NI8AfRThKGysUcsxlUo8MprPfE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-vDgPCg3fNbqGSmAdSCx5vQ-1; Thu, 20 Aug 2020 09:33:46 -0400
X-MC-Unique: vDgPCg3fNbqGSmAdSCx5vQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B2A52AE641;
        Thu, 20 Aug 2020 13:33:43 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 35F7219D6C;
        Thu, 20 Aug 2020 13:33:40 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 0/7] KVM: nSVM: ondemand nested state allocation + smm fixes
Date:   Thu, 20 Aug 2020 16:33:32 +0300
Message-Id: <20200820133339.372823-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi!=0D
=0D
This patch series does some refactoring and implements on demand nested sta=
te area=0D
This way at least guests that don't use nesting won't waste memory=0D
on nested state.=0D
=0D
Patches 1,2,3 are refactoring=0D
=0D
Patches 4,5 are new from V1 and implement more strict SMM save state area c=
hecking=0D
on resume from SMM to avoid guest tampering with this area.=0D
=0D
This was done to avoid crashing if the guest enabled 'guest was interrupted=
'=0D
flag there and we don't have nested state allocated.=0D
=0D
Patches 6,7 are for ondemand nested state.=0D
=0D
The series was tested with various nested guests, in one case even with=0D
L3 running, but note that due to unrelated issue, migration with nested=0D
guest running didn't work for me with or without this series.=0D
I am investigating this currently.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (7):=0D
  KVM: SVM: rename a variable in the svm_create_vcpu=0D
  KVM: nSVM: rename nested 'vmcb' to vmcb12_gpa in few places=0D
  KVM: SVM: refactor msr permission bitmap allocation=0D
  KVM: x86: allow kvm_x86_ops.set_efer to return a value=0D
  KVM: nSVM: more strict smm checks=0D
  KVM: emulator: more strict rsm checks.=0D
  KVM: nSVM: implement ondemand allocation of the nested state=0D
=0D
 arch/x86/include/asm/kvm_host.h |   2 +-=0D
 arch/x86/kvm/emulate.c          |  22 ++++--=0D
 arch/x86/kvm/svm/nested.c       |  53 +++++++++++--=0D
 arch/x86/kvm/svm/svm.c          | 130 ++++++++++++++++++--------------=0D
 arch/x86/kvm/svm/svm.h          |  10 ++-=0D
 arch/x86/kvm/vmx/vmx.c          |   5 +-=0D
 arch/x86/kvm/x86.c              |   3 +-=0D
 7 files changed, 151 insertions(+), 74 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

