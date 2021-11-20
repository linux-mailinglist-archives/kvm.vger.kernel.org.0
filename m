Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167BC457D00
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 11:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237361AbhKTKby (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Nov 2021 05:31:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbhKTKbj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Nov 2021 05:31:39 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06AE2C061758;
        Sat, 20 Nov 2021 02:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=TRQbOF8/4m0nHVfskdWnV/CbhyujsfdkdJEMQwMkjO0=; b=rbKCaOFZ5JgbTWc13zVz+5G7pi
        KBsQiaKHv+h4s104PvBQTp/kMM6/OdJCllxmEOyK5rvtMsQSX46f5Kl9Z7EymiscQymAkHvlJOzzz
        4wfNgKl/OSoEhCEgRijyPyzUCTwgBZLGoQv1EKqX8xdLP88DagjU/O+5OIBKY2OoWzc0Nrc8gEbea
        58vMK2VKRZrZ484UmWfULmUrPnSj2kHDYl4O6wELuu4GZwiFjdj6JKMWUAxSxOZAZw2hOPDLSn5yU
        /iGuOmWhPC9CieBa65vESz2HpuvVn6zz7wBgOgj/SimKg5bMS6vVbHenWynsGrQpqppawbeIlgWkd
        10UdTq7g==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1moNbR-00H55u-Hg; Sat, 20 Nov 2021 10:28:13 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1moNbQ-0002K2-3l; Sat, 20 Nov 2021 10:28:12 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anup Patel <anup.patel@wdc.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org
Subject: PATCH v4 00/11] KVM: x86/xen: Add in-kernel Xen event channel delivery
Date:   Sat, 20 Nov 2021 10:27:59 +0000
Message-Id: <20211120102810.8858-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Event channels, yeah. That really is where I started.

It was all so simple in Joao and Ankur's original version at 
https://www.spinics.net/lists/kvm/msg182556.html — just a handful
of simple test_and_set_bit() calls on the mapped page.

When I posted v1 I didn't quite understand how steal time and nesting
were safely using the kvm_map_gfn() function, and I posted the Xen
part declaring that I had "reduced it to a previously solved problem".

Then I frowned at kvm_map_gfn() for a bit longer, concluded it was
basically impossible to use it safely on its own because the page it
maps might belong to another guest by the time it even returns to its
caller, and posted a v2 in which I did something safer for myself by
hooking into the MMU notifiers.

I then fixed the steal time reporting, and killed gfn_to_pfn_cache,
under separate cover.

In v3 of this series I re-introduced a saner gfn_to_pfn_cache with MMU 
notifier support to give it proper invalidation semantics. This can now 
be used for the Xen event channel support and should also be usable for 
fixing the various use-after-free races in the nesting code too — the 
last patch in this series being an untested proof of concept attempt at 
fixing one such.

Since adding a C file in virt/kvm/ was somewhat more painful than it
really should have been, there is a small detour into all the arch
specific Makefiles to make them include a common one.

v4: Rework the dirty marking given the relevation that it can only be 
done from the context of an active vCPU. So just defer it to happen in 
the unmap. Also introduce a lightweight unmap call instead of just the 
full destroy. Document the Xen shared info page as NOT participating in 
dirty tracking. Fix a typo in the CONFIG_HAVE_KVM_DIRTY_RING patch which 
prevented the capability from being advertised.

Intended for merging up to patch 10. Patch 11 is for illustration.



