Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5863518A3
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 19:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235564AbhDARqp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:46:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57948 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234910AbhDARlR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:41:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617298876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vPQ/nf2q8LAkQ8OcVv2K8+oWAe1O0DGRxava7ECuAkg=;
        b=fKjyL/mQYGT6FOrLp9bmGBK+1k2MjmUvAWdi8sRjj65GMaCs6Yz9bh5ghX4avItdZ8j2F0
        7Kp/mr8j6enRgmvh3TznNcoUBmuQK2+l08GLDU5bHyjVE173TVF5p9fl1sL0lArr2xitlV
        K98XG5jD+oOSPoNYv0o5v/O8pjLIbx4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-WkrSyo2-PJ2wmI7lp45zfw-1; Thu, 01 Apr 2021 10:39:29 -0400
X-MC-Unique: WkrSyo2-PJ2wmI7lp45zfw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27CA783DEA6;
        Thu,  1 Apr 2021 14:38:22 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 351CD5D9CA;
        Thu,  1 Apr 2021 14:38:18 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/4] KVM: nSVM/nVMX: fix nested virtualization treatment of
 nested exceptions
Date:   Thu,  1 Apr 2021 17:38:13 +0300
Message-Id: <20210401143817.1030695-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

clone of "kernel-starship-5.12.unstable"=0D
=0D
Maxim Levitsky (4):=0D
  KVM: x86: pending exceptions must not be blocked by an injected event=0D
  KVM: x86: separate pending and injected exception=0D
  KVM: x86: correctly merge pending and injected exception=0D
  KVM: x86: remove tweaking of inject_page_fault=0D
=0D
 arch/x86/include/asm/kvm_host.h |  34 +++-=0D
 arch/x86/kvm/svm/nested.c       |  65 +++----=0D
 arch/x86/kvm/svm/svm.c          |   8 +-=0D
 arch/x86/kvm/vmx/nested.c       | 107 +++++------=0D
 arch/x86/kvm/vmx/vmx.c          |  14 +-=0D
 arch/x86/kvm/x86.c              | 302 ++++++++++++++++++--------------=0D
 arch/x86/kvm/x86.h              |   6 +-=0D
 7 files changed, 283 insertions(+), 253 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

