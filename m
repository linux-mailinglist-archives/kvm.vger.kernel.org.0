Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAB82EBCD5
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 11:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbhAFKyu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 05:54:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46842 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725877AbhAFKyu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Jan 2021 05:54:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609930404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=QaEUzQ6yh8rdW3dVNi86zCFUfCiUJ9L8dDbZnEnAkcY=;
        b=cIH5zkajrbSOBznNjLYzkQbRtD0tdGIT80H1shz/nlQXKzZSJYERuwc8Z7OQcFphbraVYV
        uWIzYUmyONmKYOxnLExjUooI2PzwuOK41EgNpaD4Vz1EZh4gYhWe8kNShH0iVx7CBT3BR7
        aO8kCDuS9lLR6LlhZdj3/s4KZdFNTYY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-lyyoWnXsNmOTb6hm22CjDg-1; Wed, 06 Jan 2021 05:53:13 -0500
X-MC-Unique: lyyoWnXsNmOTb6hm22CjDg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32F0810054FF;
        Wed,  6 Jan 2021 10:53:12 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 858EC5B4A9;
        Wed,  6 Jan 2021 10:53:08 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Wanpeng Li <wanpengli@tencent.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)),
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/2] RFC: VMX: fix for disappearing L1->L2 event injection on
 L1 migration
Date:   Wed,  6 Jan 2021 12:53:04 +0200
Message-Id: <20210106105306.450602-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is VMX version of the same issue as I reproduced on SVM.=0D
=0D
Unlike SVM, this version has 2 pending issues to resolve.=0D
=0D
1. This seems to break 'vmx' kvm-unit-test in=0D
'error code <-> (!URG || prot_mode) [+]' case.=0D
=0D
The test basically tries to do nested vm entry with unrestricted guest disa=
bled,=0D
real mode, and for some reason that works without patch 2 of this series an=
d it=0D
doesn't cause the #GP to be injected, but with this patch the test complain=
s=0D
about unexpected #GP.=0D
I suspect that this test case is broken, but this has to be investigated.=0D
=0D
2. L1 MTF injections are lost since kvm has no notion of them, this is TBD =
to=0D
be fixed.=0D
=0D
This was lightly tested on my nested migration test which no VMX sadly stil=
l=0D
crashes and burns on an (likely) unrelated issue.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (2):=0D
  KVM: VMX: create vmx_process_injected_event=0D
  KVM: nVMX: fix for disappearing L1->L2 event injection on L1 migration=0D
=0D
 arch/x86/kvm/vmx/nested.c | 12 ++++----=0D
 arch/x86/kvm/vmx/vmx.c    | 60 ++++++++++++++++++++++++---------------=0D
 arch/x86/kvm/vmx/vmx.h    |  4 +++=0D
 3 files changed, 47 insertions(+), 29 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

