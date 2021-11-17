Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B64454D3E
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 19:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240044AbhKQSfL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 13:35:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233890AbhKQSfK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 13:35:10 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC56C061570;
        Wed, 17 Nov 2021 10:32:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=UrCfwAAERGpFkpH84kgGsztDfzBHzApXpFPk7Q4aM3Q=; b=qlkcK6EiUDCYNFmrW2y88AiZNE
        cmQvmZ/hQeDmBuBaxBlEz8/9xSDGrc79+e+G9Ohrg5SCBR9+U6oMY2TCcJXuU2nNiBFuD3+kWs5eT
        IBPH2OgqzqIIS3CImevIylsIHPwL04bJaRDQbp5TgrjKZuuQ7/IGm6pG4x0HQWq0ZUJe2eHLXzCPj
        f6Yvwy6gqczKGGJV9qWHf3sPhxK2DC4ivkTSa4HaWFyKoFujkMpT8PDC2tAVJRnfRaU58s8vA1x38
        8L1RywfOIo3IjwOk1sM0OUF4A2t8iZC5ZKCHOLMVvHUQ609zEC4WkGW9X1KUl7pVE6G8B/0JOjLPo
        DBQsXa2g==;
Received: from [2001:8b0:10b:1:d129:67c1:5868:c3aa] (helo=[IPv6:::1])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mnPiu-00GXzz-IG; Wed, 17 Nov 2021 18:31:56 +0000
Date:   Wed, 17 Nov 2021 18:31:55 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Marc Zyngier <maz@kernel.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com,
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
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v3_08/12=5D_KVM=3A_Propagate_vcpu?= =?US-ASCII?Q?_explicitly_to_mark=5Fpage=5Fdirty=5Fin=5Fslot=28=29?=
User-Agent: K-9 Mail for Android
In-Reply-To: <87pmqy7ir2.wl-maz@kernel.org>
References: <20211117174003.297096-1-dwmw2@infradead.org> <20211117174003.297096-9-dwmw2@infradead.org> <87pmqy7ir2.wl-maz@kernel.org>
Message-ID: <63CDC53D-D05A-499B-8694-14E5DA3855FB@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 17 November 2021 18:13:37 GMT, Marc Zyngier <maz@kernel=2Eorg> wrote:
>On Wed, 17 Nov 2021 17:39:59 +0000,
>David Woodhouse <dwmw2@infradead=2Eorg> wrote:
>>=20
>> From: David Woodhouse <dwmw@amazon=2Eco=2Euk>
>>=20
>> The kvm_dirty_ring_get() function uses kvm_get_running_vcpu() to work o=
ut
>> which dirty ring to use, but there are some use cases where that doesn'=
t
>> work=2E
>>=20
>> There's one in setting the Xen shared info page, introduced in commit
>> 629b5348841a ("KVM: x86/xen: update wallclock region") and reported by
>> "butt3rflyh4ck" <butterflyhuangxx@gmail=2Ecom> in
>> https://lore=2Ekernel=2Eorg/kvm/CAFcO6XOmoS7EacN_n6v4Txk7xL7iqRa2gABg3F=
7E3Naf5uG94g@mail=2Egmail=2Ecom/
>>=20
>> There's also about to be another one when the newly-reintroduced
>> gfn_to_pfn_cache needs to mark a page as dirty from the MMU notifier
>> which invalidates the mapping=2E In that case, we will *know* the vcpu
>> that can be 'blamed' for dirtying the page, and we just need to be
>> able to pass it in as an explicit argument when doing so=2E
>>=20
>> This patch preemptively resolves the second issue, and paves the way
>> for resolving the first=2E A complete fix for the first issue will need
>> us to switch the Xen shinfo to be owned by a particular vCPU, which
>> will happen in a separate patch=2E
>>=20
>> Signed-off-by: David Woodhouse <dwmw@amazon=2Eco=2Euk>
>> ---
>>  arch/arm64/kvm/mmu=2Ec           |  2 +-
>>  arch/x86/kvm/mmu/mmu=2Ec         |  2 +-
>>  arch/x86/kvm/mmu/spte=2Ec        |  2 +-
>>  arch/x86/kvm/mmu/tdp_mmu=2Ec     |  2 +-
>>  arch/x86/kvm/x86=2Ec             |  4 ++--
>>  include/linux/kvm_dirty_ring=2Eh |  6 ++++--
>>  include/linux/kvm_host=2Eh       |  3 ++-
>>  virt/kvm/dirty_ring=2Ec          |  8 ++++++--
>>  virt/kvm/kvm_main=2Ec            | 18 +++++++++---------
>>  9 files changed, 27 insertions(+), 20 deletions(-)
>
>What's the base for this series? This patch fails to compile for me
>(at least on arm64), and the following patch doesn't apply on -rc1=2E

kvm/master

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
