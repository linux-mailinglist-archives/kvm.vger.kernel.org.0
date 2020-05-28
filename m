Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9101E5367
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 03:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgE1ByT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 21:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbgE1ByT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 21:54:19 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC795C08C5C1;
        Wed, 27 May 2020 18:54:18 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1003)
        id 49XW2v5CXhz9sSc; Thu, 28 May 2020 11:54:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1590630855; bh=1dkTCAmepa8D/tUnw26bVomyWCJr3VvbPcigofmw/oU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Sc5+sYr+mgtPlC2bcDEWWiSpUGaA9k83bVXJJvAxR4BNVIEXZZmBRZGb1VpI+V8wc
         VwY11SIAqhVBxCJNilOa9FjjGCvf1i5Pk4OudUoNuoEzZLTl1FhYc7k+HVoOb98Z+g
         Vr9LkygcVlFBW8My7BFkivxBCUwy4+auEiInxLATDRHnD08zCEz8A0TApKfmqN6i8W
         eaxmldtwbxC5i8jTMadPVdzQA+5QnIOnkSZXD7M+OCZC3gjFks1IDnn7t9UNVy7Bpm
         +1yAafc7v8Hr+10CDCKaTaFa1OTt6RZ+NA6M1+COT5O9zSed8jDpCUn6ubhC4j6003
         HQy1GZnO6PopA==
Date:   Thu, 28 May 2020 11:54:10 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Nick Piggin <npiggin@au1.ibm.com>
Subject: [PATCH 2/2] KVM: PPC: Book3S HV: Close race with page faults around
 memslot flushes
Message-ID: <20200528015410.GE307798@thinks.paulus.ozlabs.org>
References: <20200528015331.GD307798@thinks.paulus.ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528015331.GD307798@thinks.paulus.ozlabs.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is a potential race condition between hypervisor page faults
and flushing a memslot.  It is possible for a page fault to read the
memslot before a memslot is updated and then write a PTE to the
partition-scoped page tables after kvmppc_radix_flush_memslot has
completed.  (Note that this race has never been explicitly observed.)

To close this race, it is sufficient to increment the MMU sequence
number while the kvm->mmu_lock is held.  That will cause
mmu_notifier_retry() to return true, and the page fault will then
return to the guest without inserting a PTE.

Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
---
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index bc3f795..aa41183 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -1130,6 +1130,11 @@ void kvmppc_radix_flush_memslot(struct kvm *kvm,
 					 kvm->arch.lpid);
 		gpa += PAGE_SIZE;
 	}
+	/*
+	 * Increase the mmu notifier sequence number to prevent any page
+	 * fault that read the memslot earlier from writing a PTE.
+	 */
+	kvm->mmu_notifier_seq++;
 	spin_unlock(&kvm->mmu_lock);
 }
 
-- 
2.7.4

