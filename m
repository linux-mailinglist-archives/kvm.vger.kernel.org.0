Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D15D1E4525
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 16:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730352AbgE0OEk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 10:04:40 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:48510 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730258AbgE0OEj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 May 2020 10:04:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590588278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=NcFdxBDv4qTLkO36Cyhthea6RiBA+xci3OrDd7Ic3kg=;
        b=GHijKu1PxOxkpFiW5jWHJfhu2P3L7pWFYvChtporDWqNFGA8CV33GeSEUWW0HxNDlAOYR4
        6C6TZzhUH0GeMfQ6xZlU9DNO0q0gYZyExUGau6gDl0UR9F7PYienQBCFBVUt05xdEZ4wGH
        mRRYB+kNnWn+9Chs0HYtPeH4YFbk1sU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-9wuW275oOzawgKXdjjUfsA-1; Wed, 27 May 2020 10:04:34 -0400
X-MC-Unique: 9wuW275oOzawgKXdjjUfsA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71CE4460;
        Wed, 27 May 2020 14:04:32 +0000 (UTC)
Received: from starship.f32vm (unknown [10.35.206.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 293642DE69;
        Wed, 27 May 2020 14:04:27 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jingqi Liu <jingqi.liu@intel.com>, Tao Xu <tao3.xu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 0/2] Fix issue with not starting nesting guests on my system
Date:   Wed, 27 May 2020 17:04:23 +0300
Message-Id: <20200527140425.3484-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On my AMD machine I noticed that I can't start any nested guests,=0D
because nested KVM (everything from master git branches) complains=0D
that it can't find msr MSR_IA32_UMWAIT_CONTROL which my system doesn't supp=
ort=0D
at all anyway.=0D
=0D
I traced it to the recently added UMWAIT support to qemu and kvm.=0D
The kvm portion exposed the new MSR in KVM_GET_MSR_INDEX_LIST without=0D
checking that it the underlying feature is supported in CPUID.=0D
It happened to work when non nested because as a precation kvm,=0D
tries to read each MSR on host before adding it to that list,=0D
and when read gets a #GP it ignores it.=0D
=0D
When running nested, the L1 hypervisor can be set to ignore unknown=0D
msr read/writes (I need this for some other guests), thus this safety=0D
check doesn't work anymore.=0D
=0D
V2: * added a patch to setup correctly the X86_FEATURE_WAITPKG kvm capabili=
ty=0D
    * dropped the cosmetic fix patch as it is now fixed in kvm/queue=0D
=0D
V3: addressed the review feedback and possibly made the commit messages a b=
it better=0D
    Thanks!=0D
=0D
Best regards,=0D
        Maxim Levitsky=0D
=0D
Maxim Levitsky (2):=0D
  KVM: VMX: enable X86_FEATURE_WAITPKG in KVM capabilities=0D
  KVM: x86: don't expose MSR_IA32_UMWAIT_CONTROL unconditionally=0D
=0D
 arch/x86/kvm/vmx/vmx.c | 3 +++=0D
 arch/x86/kvm/x86.c     | 4 ++++=0D
 2 files changed, 7 insertions(+)=0D
=0D
-- =0D
2.26.2=0D
=0D

