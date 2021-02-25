Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE625325295
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 16:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbhBYPnO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 10:43:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57962 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229845AbhBYPnN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Feb 2021 10:43:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614267707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=s3cK62eP5ZGb6zqZ97C6c3P2QiYoHi/l4dd9rsUiLKg=;
        b=XRwZIY5xJQfI/V5Hrtn68LGqe8KVhVyqXBYLkagaaS2Qn492pPQ4AlY34oyjvcgh+MkcTI
        zsqhCbqRL/HDZx3gKAIs7Smfm2qmDNiTL1ybxa5/ABgZs5Zb+n/lmRH6t8Rl41RqOee4w0
        lGrQZ1+MnWv+tBkW15G8QSmw0aDhzBs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-6Uv32vupNAyDs-gCC2l4TA-1; Thu, 25 Feb 2021 10:41:44 -0500
X-MC-Unique: 6Uv32vupNAyDs-gCC2l4TA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 132B8107ACC7;
        Thu, 25 Feb 2021 15:41:41 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.207.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 36D8A39A63;
        Thu, 25 Feb 2021 15:41:36 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/4] RFC/WIP: KVM: separate injected and pending exception +
 few more fixes
Date:   Thu, 25 Feb 2021 17:41:31 +0200
Message-Id: <20210225154135.405125-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

clone of "kernel-starship-5.11"=0D
=0D
Maxim Levitsky (4):=0D
  KVM: x86: determine if an exception has an error code only when=0D
    injecting it.=0D
  KVM: x86: mmu: initialize fault.async_page_fault in walk_addr_generic=0D
  KVM: x86: pending exception must be be injected even with an injected=0D
    event=0D
  kvm: WIP separation of injected and pending exception=0D
=0D
 arch/x86/include/asm/kvm_host.h |  23 +-=0D
 arch/x86/include/uapi/asm/kvm.h |  14 +-=0D
 arch/x86/kvm/mmu/paging_tmpl.h  |   1 +=0D
 arch/x86/kvm/svm/nested.c       |  57 +++--=0D
 arch/x86/kvm/svm/svm.c          |   8 +-=0D
 arch/x86/kvm/vmx/nested.c       | 109 +++++----=0D
 arch/x86/kvm/vmx/vmx.c          |  14 +-=0D
 arch/x86/kvm/x86.c              | 377 +++++++++++++++++++-------------=0D
 arch/x86/kvm/x86.h              |   6 +-=0D
 include/uapi/linux/kvm.h        |   1 +=0D
 10 files changed, 374 insertions(+), 236 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

