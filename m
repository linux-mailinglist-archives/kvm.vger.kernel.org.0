Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD8826A913
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 17:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbgIOPrP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 11:47:15 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30008 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727455AbgIOPnp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Sep 2020 11:43:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600184596;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=S7LOvCl7XUVBU80Y/PU+FTVOH70oxm6JnXxMde/HKVE=;
        b=LLEva9hWSkYksK8FihM07TdSQcZklvlTOQpA+T2fUuK1hpZykRTeUdtSDU6gZstkduG2W3
        p1wHp/AcpDx0LicFCwmP7xLy0y3LYP9Etrst9GCnjuMAa1/cjyyIqdwS0JWXcrJi5IRq6g
        JFkW/j492lmhRNz5Xi5xgUJ7NIAxdjY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-HNLXfCHwMlOI095IlUogdg-1; Tue, 15 Sep 2020 11:43:12 -0400
X-MC-Unique: HNLXfCHwMlOI095IlUogdg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA9D2CF983;
        Tue, 15 Sep 2020 15:43:10 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 120A119D61;
        Tue, 15 Sep 2020 15:43:07 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Wei Huang <whuang2@amd.com>, linux-kernel@vger.kernel.org
Subject: [PATCH RFC 0/2] KVM: x86: allow for more CPUID entries
Date:   Tue, 15 Sep 2020 17:43:04 +0200
Message-Id: <20200915154306.724953-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With QEMU and newer AMD CPUs (namely: Epyc 'Rome') the current limit for
KVM_MAX_CPUID_ENTRIES(80) is reported to be hit. Last time it was raised
from '40' in 2010. We can, of course, just bump it a little bit to fix
the immediate issue but the report made me wonder why we need to pre-
allocate vcpu->arch.cpuid_entries array instead of sizing it dynamically.
This RFC is intended to feed my curiosity.

Very mildly tested with selftests/kvm-unit-tests and nothing seems to
break. I also don't have access to the system where the original issue
was reported but chances we're fixing it are very good IMO as just the
second patch alone was reported to be sufficient.

Reported-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

Vitaly Kuznetsov (2):
  KVM: x86: allocate vcpu->arch.cpuid_entries dynamically
  KVM: x86: bump KVM_MAX_CPUID_ENTRIES

 arch/x86/include/asm/kvm_host.h |  4 +--
 arch/x86/kvm/cpuid.c            | 55 ++++++++++++++++++++++++---------
 arch/x86/kvm/x86.c              |  1 +
 3 files changed, 43 insertions(+), 17 deletions(-)

-- 
2.25.4

