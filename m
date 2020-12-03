Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F56F2CD944
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 15:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436525AbgLCOez (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 09:34:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57266 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728159AbgLCOez (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 09:34:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607006009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6smsIvjf77OYufhjM+C0nrIBQuuSFafCoX7/LBefMiM=;
        b=gULYPi1uPCVBZnRipEt/DTz9hk356RosnjManBt2OlMXsHldmMwq6DCD2X2zoqHWupMyjO
        B5urZ28cLHZJHSgH5T6NofDAjDgHCcoaOg+ZBRfL0d12VcD92CQTcIR2LKYwDeHmPKXvxc
        Hy5lNo30+fJ4i2F6LGIN2wMMf3d6Pkw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-AOBA8ru4POGmZP_E6v16cw-1; Thu, 03 Dec 2020 09:33:27 -0500
X-MC-Unique: AOBA8ru4POGmZP_E6v16cw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 716B315822E;
        Thu,  3 Dec 2020 14:33:25 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E723A18A60;
        Thu,  3 Dec 2020 14:33:20 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/1] Fix for a recent regression in kvm/queue (guest using
 100% cpu time)
Date:   Thu,  3 Dec 2020 16:33:18 +0200
Message-Id: <20201203143319.159394-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I did a quick bisect yesterday after noticing that my VMs started=0D
to take 100% cpu time.=0D
=0D
Looks like we don't ignore SIPIs that are received while the CPU isn't=0D
waiting for them, and that makes KVM think that CPU always has=0D
pending events which makes it never enter an idle state.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (1):=0D
  KVM: x86: ignore SIPIs that are received while not in wait-for-sipi=0D
    state=0D
=0D
 arch/x86/kvm/lapic.c | 15 ++++++++-------=0D
 1 file changed, 8 insertions(+), 7 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

