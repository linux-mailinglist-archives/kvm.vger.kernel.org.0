Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D2532529C
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 16:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbhBYPnr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 10:43:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49789 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232608AbhBYPnY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Feb 2021 10:43:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614267717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=axaqQIPGaFc+YTyqMCXEXh8BI5G1o+8Zoo95SuSqdjc=;
        b=dAS6xtkWsrqqvMM67/jfw7qaDhPxAghFPbX6WoEAYtW5yhjOMQq+idKWvi4OOvVPBv44sa
        EMT7S1xGmw5MM4Rn0SU5oPxt5k2noEA9m9S01TO8B5ew60F4JyVy8P62IJnRGD0+gCRNeX
        6ibKZttLxvq/lA6TNcybITrAGj93yK0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-CBQ6YWgAMK6-Dvnpj2RAVA-1; Thu, 25 Feb 2021 10:41:50 -0500
X-MC-Unique: CBQ6YWgAMK6-Dvnpj2RAVA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FC7A107ACFE;
        Thu, 25 Feb 2021 15:41:49 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.207.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B26650DD2;
        Thu, 25 Feb 2021 15:41:45 +0000 (UTC)
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
Subject: [PATCH 2/4] KVM: x86: mmu: initialize fault.async_page_fault in walk_addr_generic
Date:   Thu, 25 Feb 2021 17:41:33 +0200
Message-Id: <20210225154135.405125-3-mlevitsk@redhat.com>
In-Reply-To: <20210225154135.405125-1-mlevitsk@redhat.com>
References: <20210225154135.405125-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This field was left uninitialized by a mistake.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index d9f66cc459e84..3dc9a25772bd8 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -503,6 +503,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 #endif
 	walker->fault.address = addr;
 	walker->fault.nested_page_fault = mmu != vcpu->arch.walk_mmu;
+	walker->fault.async_page_fault = false;
 
 	trace_kvm_mmu_walker_error(walker->fault.error_code);
 	return 0;
-- 
2.26.2

