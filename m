Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF4124B1CE
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 11:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgHTJNk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 05:13:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39752 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726819AbgHTJNh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 05:13:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597914816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=A3aFtdgeFbcYR03wKrWlf344PhwxLiPdlKO9qqCpcnY=;
        b=fuo/QEJuz+YkSDag8JooAPqlkwvrfGQPu2hSCGSI6zDV3dQH5WSKGnVfNTHxDtSxoiXmYo
        X9KLfksQ99KlNSI741yot/L60y6zzlvztrzFnKss7QMGYORnt6PGUiCs/NO/mmNyBtnjgV
        7BJZhpDC72YWTmaHlnu17se449eT95M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-zyT1cK7ZMwSTsNDtTeLzcw-1; Thu, 20 Aug 2020 05:13:34 -0400
X-MC-Unique: zyT1cK7ZMwSTsNDtTeLzcw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B72B4425D2;
        Thu, 20 Aug 2020 09:13:32 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BEBE27E309;
        Thu, 20 Aug 2020 09:13:28 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)),
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/8] KVM: nSVM: ondemand nested state allocation + nested
 guest state caching
Date:   Thu, 20 Aug 2020 12:13:19 +0300
Message-Id: <20200820091327.197807-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi!=0D
=0D
This patch series implements caching of the whole nested guest vmcb=0D
as opposed to current code that only caches its control area.=0D
This allows us to avoid race in which guest changes the data area=0D
while we are verifying it.=0D
=0D
In adddition to that I also implemented on demand nested state area=0D
to compensate a bit for memory usage increase from this caching.=0D
This way at least guests that don't use nesting won't waste memory=0D
on nested state.=0D
=0D
Patches 1,2,3 are just refactoring,=0D
=0D
Patches 4,5 are for ondemand nested state, while patches 6,7,8 are=0D
for caching of the nested state.=0D
=0D
Patch 8 is more of an optimization and can be dropped if you like to.=0D
=0D
The series was tested with various nested guests, in one case even with=0D
L3 running, but note that due to unrelated issue, migration with nested=0D
guest running didn't work for me with or without this series.=0D
I am investigating this currently.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (8):=0D
  KVM: SVM: rename a variable in the svm_create_vcpu=0D
  KVM: nSVM: rename nested 'vmcb' to vmcb_gpa in few places=0D
  KVM: SVM: refactor msr permission bitmap allocation=0D
  KVM: x86: allow kvm_x86_ops.set_efer to return a value=0D
  KVM: nSVM: implement ondemand allocation of the nested state=0D
  SVM: nSVM: cache whole nested vmcb instead of only its control area=0D
  KVM: nSVM: implement caching of nested vmcb save area=0D
  KVM: nSVM: read only changed fields of the nested guest data area=0D
=0D
 arch/x86/include/asm/kvm_host.h |   2 +-=0D
 arch/x86/kvm/svm/nested.c       | 296 +++++++++++++++++++++++---------=0D
 arch/x86/kvm/svm/svm.c          | 129 +++++++-------=0D
 arch/x86/kvm/svm/svm.h          |  32 ++--=0D
 arch/x86/kvm/vmx/vmx.c          |   5 +-=0D
 arch/x86/kvm/x86.c              |   3 +-=0D
 6 files changed, 312 insertions(+), 155 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

