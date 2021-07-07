Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6FF23BE856
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 14:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhGGMxx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 08:53:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25857 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231553AbhGGMxw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 08:53:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625662272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=/M5uzOua0aRNYcHJWpaKTA9Cu1WdOfYfIL4dJ1elvAg=;
        b=F7xvBiB9fNqDCXqw7z/Hb0ZNkhQU8WfDcp0wt2H6vYtXoQQy8MLRO/zloC1m1OrHG1YFX8
        HBsG94wAERmiG69PHoTnCGaltJAJPU0G8HxA3zmD4ax/QxS2QgMYuWLL9baBXInLYUWYt0
        Y7d3jZz4wgafeIi+G5qLJpXeL8FKUvE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-AfUOIf0MMDOQMePnuigX_w-1; Wed, 07 Jul 2021 08:51:11 -0400
X-MC-Unique: AfUOIf0MMDOQMePnuigX_w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B7D28030B0;
        Wed,  7 Jul 2021 12:51:07 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 30E0E19C66;
        Wed,  7 Jul 2021 12:51:01 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/3] KVM: SMM fixes
Date:   Wed,  7 Jul 2021 15:50:57 +0300
Message-Id: <20210707125100.677203-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi!=0D
=0D
I did first round of testing of SMM by flooding the guest with SMIs,=0D
and running nested guests in it, and I found out that SMM=0D
breaks nested KVM due to a refactoring change=0D
that was done in 5.12 kernel. Fix for this is in patch 1.=0D
=0D
I also fixed another issue I noticed in this patch which is purely=0D
theoretical but nevertheless should be fixed. This is patch 2.=0D
=0D
I also propose to add (mostly for debug for now) a module param=0D
that can make the KVM to avoid intercepting #SMIs on SVM.=0D
(Intel doesn't have such intercept I think)=0D
The default is still to intercept #SMI so nothing is changed by=0D
default.=0D
=0D
This allows to test the case in which SMI are not intercepted,=0D
by L1 without running Windows (which doesn't intercept #SMI).=0D
=0D
In addition to that I found out that on bare metal, at least=0D
on two Zen2 machines I have, the CPU ignores SMI interception and=0D
never VM exits when SMI is received. As I guessed earlier=0D
this must have been done for security reasons.=0D
=0D
Note that bug that I fixed in patch 1, should crash VMs very soon=0D
on bare metal as well, if the CPU were to honour the SMI intercept.=0D
as long as there are some SMIs generated while the system is running.=0D
=0D
I tested this on bare metal by using local APIC to send SMIs=0D
to all real CPUs, and also used ioport 0xB2 to send SMIs.=0D
In both cases my system slowed to a crawl but didn't show=0D
any SMI vmexits (SMI intercept was enabled).=0D
=0D
In a VM I also used ioport 0xB2 to generate a flood of SMIs,=0D
which allowed me to reproduce this bug (and with intercept_smi=3D0=0D
module parameter I can reproduce the bug that Vitaly fixed in=0D
his series as well while just running nested KVM).=0D
=0D
Note that while doing nested migration I am still able to cause=0D
severe hangs of the L1 when I run the SMI stress test in L1=0D
and a nested VM. VM isn't fully hung but its GUI stops responding,=0D
and I see lots of cpu lockups errors in dmesg.=0D
This seems to happen regardless of #SMI interception in the L1=0D
(with Vitaly's patches applied of course)=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (3):=0D
  KVM: SVM: #SMI interception must not skip the instruction=0D
  KVM: SVM: remove INIT intercept handler=0D
  KVM: SVM: add module param to control the #SMI interception=0D
=0D
 arch/x86/kvm/svm/nested.c |  4 ++++=0D
 arch/x86/kvm/svm/svm.c    | 18 +++++++++++++++---=0D
 arch/x86/kvm/svm/svm.h    |  1 +=0D
 3 files changed, 20 insertions(+), 3 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

