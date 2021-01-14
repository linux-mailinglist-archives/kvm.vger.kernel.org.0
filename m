Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFD012F6CAC
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 21:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbhANU41 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 15:56:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49400 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726573AbhANU41 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 15:56:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610657701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZyDfgALqUiawzmubBa6Wwvj+Dzw/MHsKyDI805lQ07Y=;
        b=i9XIuKNFJmaDeAYJuM57Nc2BjJnWoQDScF+nkulMW6D7VolNVUtzG16K6zyEUSrzjitOjI
        8YiFOZ67Bz0A0AJJTsrqO0FcGTrXFdIdyebv9h32Y8rauVA+bymEJiAEYvEVWcVul9wGKk
        3viDio1QEugPtjGbZqt0QLbv1Qiy78w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-D0uFwfSuOIeZyvrNomKfkg-1; Thu, 14 Jan 2021 15:54:57 -0500
X-MC-Unique: D0uFwfSuOIeZyvrNomKfkg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83F358144E1;
        Thu, 14 Jan 2021 20:54:55 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E1545C1C5;
        Thu, 14 Jan 2021 20:54:50 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 0/3] VMX: more nested fixes
Date:   Thu, 14 Jan 2021 22:54:46 +0200
Message-Id: <20210114205449.8715-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is hopefully the last fix for VMX nested migration=0D
that finally allows my stress test of migration with a nested guest to pass=
.=0D
=0D
In a nutshell after an optimization that was done in commit 7952d769c29ca,=
=0D
some of vmcs02 fields which can be modified by the L2 freely while it runs=
=0D
(like GSBASE and such) were not copied back to vmcs12 unless:=0D
=0D
1. L1 tries to vmread them (update done on intercept)=0D
2. vmclear or vmldptr on other vmcs are done.=0D
3. nested state is read and nested guest is running.=0D
=0D
What wasn't done was to sync these 'rare' fields when L1 is running=0D
but still has a loaded vmcs12 which might have some stale fields,=0D
if that vmcs was used to enter a guest already due to that optimization.=0D
=0D
Plus I added two minor patches to improve VMX tracepoints=0D
a bit. There is still a large room for improvement.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (3):=0D
  KVM: nVMX: Always call sync_vmcs02_to_vmcs12_rare on migration=0D
  KVM: nVMX: add kvm_nested_vmlaunch_resume tracepoint=0D
  KVM: VMX: read idt_vectoring_info a bit earlier=0D
=0D
 arch/x86/kvm/trace.h      | 30 ++++++++++++++++++++++++++++++=0D
 arch/x86/kvm/vmx/nested.c | 19 ++++++++++++++-----=0D
 arch/x86/kvm/vmx/vmx.c    |  3 ++-=0D
 arch/x86/kvm/x86.c        |  1 +=0D
 4 files changed, 47 insertions(+), 6 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

