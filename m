Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06647283B2D
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 17:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728729AbgJEPkN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 11:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727533AbgJEP3L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Oct 2020 11:29:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79C8C0613B4;
        Mon,  5 Oct 2020 08:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=HqqwdRjVDoj9+F/+r3bh/9jhBNHxbUs9BYhMrQMENKE=; b=gmD3ayvSPj1DprApblctSTU3J4
        r0DicvjW6naTXV3IHO74tZFlH3LaakjjaVCL2AmVdGM6Vf4lN6PgfnZClO3Oma29yDjFn2q82HeAh
        bI2ZUVOrCy+1LxonlKeX694LuAi2DWjRyI/590pFmxWz1rcpbUep7QbmmllcNwnwaiyGsfZMI+ko8
        9UMhc4eiP4zSJ52JRaoFO54FhpBZsxPO+P7Wl8T7opu0SCJPRzZVua/OcoEcE6Y2f4QZ0KajckUmB
        rPoh1YXm+IweE+Yaz+4G6wppvU6+BiU2V90NyC7KkVELfdQNW6r+bxRL+L8Odx03+Xb2GvfRMIhZx
        gZjw1cKw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPSQ4-0001mP-V1; Mon, 05 Oct 2020 15:28:57 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kPSQ4-0045Qz-FI; Mon, 05 Oct 2020 16:28:56 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     iommu <iommu@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, linux-hyperv@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 11/13] x86/smp: Allow more than 255 CPUs even without interrupt remapping
Date:   Mon,  5 Oct 2020 16:28:54 +0100
Message-Id: <20201005152856.974112-11-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201005152856.974112-1-dwmw2@infradead.org>
References: <77e64f977f559412f62b467fd062d051ea288f14.camel@infradead.org>
 <20201005152856.974112-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Now that external interrupt affinity can be limited to the range of
CPUs that can be reached through legacy IOAPIC RTEs and MSI, it is
possible to use additional CPUs.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kernel/apic/apic.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 069f5e9f1d28..750a92464bec 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1881,8 +1881,6 @@ static __init void try_to_enable_x2apic(int remap_mode)
 		 */
 		x2apic_phys = 1;
 	}
-	if (apic_limit)
-		x2apic_set_max_apicid(apic_limit);
 
 	/* Build the affinity mask for interrupts that can't be remapped. */
 	cpumask_clear(&x86_non_ir_cpumask);
-- 
2.26.2

