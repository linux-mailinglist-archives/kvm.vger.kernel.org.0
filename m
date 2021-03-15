Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAEC33C91F
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 23:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbhCOWKl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 18:10:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39314 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232605AbhCOWKb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Mar 2021 18:10:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615846230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=GO4Svw6p1VObWYcp8yWMtHx+jBqxgLew+cAErGqrrHw=;
        b=ZXzROqVC+NIBFFOHqbfv4OmaH/FZ9mto+xfqza7ja/Qic/Ra3jRFJF90VENUycRhWj5Y/f
        fhNRL5Z68QNx0Y+hYPLQ8MuHwg/l+8mWsbee5w8mXzUFwgWNpgzdNTp9scovdJJEmGvJty
        mtvU96nhdmNPQDckbi3xXyNmTmOB+vU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-dg5EnmfcNuaKPeeqVJjVGw-1; Mon, 15 Mar 2021 18:10:29 -0400
X-MC-Unique: dg5EnmfcNuaKPeeqVJjVGw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D693C801817;
        Mon, 15 Mar 2021 22:10:26 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.207.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EAD6C5C261;
        Mon, 15 Mar 2021 22:10:21 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Kieran Bingham <kbingham@kernel.org>,
        Jessica Yu <jeyu@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 0/3] KVM: my debug patch queue
Date:   Tue, 16 Mar 2021 00:10:17 +0200
Message-Id: <20210315221020.661693-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi!=0D
=0D
I would like to publish two debug features which were needed for other stuf=
f=0D
I work on.=0D
=0D
One is the reworked lx-symbols script which now actually works on at least=
=0D
gdb 9.1 (gdb 9.2 was reported to fail to load the debug symbols from the ke=
rnel=0D
for some reason, not related to this patch) and upstream qemu.=0D
=0D
The other feature is the ability to trap all guest exceptions (on SVM for n=
ow)=0D
and see them in kvmtrace prior to potential merge to double/triple fault.=0D
=0D
This can be very useful and I already had to manually patch KVM a few=0D
times for this.=0D
I will, once time permits, implement this feature on Intel as well.=0D
=0D
Best regards,=0D
        Maxim Levitsky=0D
=0D
Maxim Levitsky (3):=0D
  scripts/gdb: rework lx-symbols gdb script=0D
  KVM: x86: guest debug: don't inject interrupts while single stepping=0D
  KVM: SVM: allow to intercept all exceptions for debug=0D
=0D
 arch/x86/include/asm/kvm_host.h |   2 +=0D
 arch/x86/kvm/svm/svm.c          |  77 ++++++++++++++++++++++-=0D
 arch/x86/kvm/svm/svm.h          |   5 +-=0D
 arch/x86/kvm/x86.c              |  11 +++-=0D
 kernel/module.c                 |   8 ++-=0D
 scripts/gdb/linux/symbols.py    | 106 +++++++++++++++++++++++---------=0D
 6 files changed, 174 insertions(+), 35 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

