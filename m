Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0FA8456377
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 20:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbhKRT0k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 14:26:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhKRT0k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 14:26:40 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3031C061574;
        Thu, 18 Nov 2021 11:23:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=dY7Tt+ADu2oQp52XUsO3VZxqjQj7MzSBRXMcpbCbafM=; b=WoRuVORo9B/4wm/C+f4RvGG6R5
        aSUlxt0MYkOWLrvIgcfDvIr6UXShHu6loY5lSDBiU4FXuXgp3uspwRzYskh1Vs0x+Y53tK7p3vn/+
        ZjMS5DvaH8e0oC/2BcGEHKvjs+1WptAZ4FhRVASSjAXe0I60rDRJ6dyyjWPnh9cgyFCuKyilaytvL
        pJluZNiT0bwovPzhRdqmRPs1ZauvCLfEzEFBRXf3uCL1xUUDMSI+n0zj7a52oRJa//NNrrLSKe5bX
        qlCpX75DD9121jX1HXfgGNlPWl6zYrgFS/RdDFdi+eoCK7Q6hIhil60eqnxdT/fcHrzlvDtVCn6sx
        ikJ6CUsQ==;
Received: from [2a01:4c8:1087:8341:4271:4cd3:119b:a847] (helo=[IPv6:::1])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mnn08-00GkGi-FB; Thu, 18 Nov 2021 19:23:16 +0000
Date:   Thu, 18 Nov 2021 19:23:12 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
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
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v3_08/12=5D_KVM=3A_Propagate_vcpu?= =?US-ASCII?Q?_explicitly_to_mark=5Fpage=5Fdirty=5Fin=5Fslot=28=29?=
User-Agent: K-9 Mail for Android
In-Reply-To: <YZagjzYUsixbFre9@google.com>
References: <20211117174003.297096-1-dwmw2@infradead.org> <20211117174003.297096-9-dwmw2@infradead.org> <85d9fec17f32c3eb9e100e56b91af050.squirrel@twosheds.infradead.org> <4c48546b-eb4a-dff7-cc38-5df54f73f5d4@redhat.com> <20b5952e76c54a3a5dfe5a898e3b835404ac6fb1.camel@infradead.org> <YZaeL5YztL3p1nLM@google.com> <YZagjzYUsixbFre9@google.com>
Message-ID: <35AEC3FD-B46A-451D-B7D5-4B1BDD5407BD@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 18 November 2021 18:50:55 GMT, Sean Christopherson <seanjc@google=2Ecom=
> wrote:
>On Thu, Nov 18, 2021, Sean Christopherson wrote:
>> On Thu, Nov 18, 2021, David Woodhouse wrote:
>> > That leaves the one in TDP MMU handle_changed_spte_dirty_log() which
>> > AFAICT can trigger the same crash seen by butt3rflyh4ck =E2=80=94 can=
't that
>> > happen from a thread where kvm_get_running_vcpu() is NULL too? For th=
at
>> > one I'm not sure=2E
>>=20
>> I think could be trigger in the TDP MMU via kvm_mmu_notifier_release()
>> -> kvm_mmu_zap_all(), e=2Eg=2E if the userspace VMM exits while dirty l=
ogging is
>> enabled=2E  That should be easy to (dis)prove via a selftest=2E
>
>Scratch that, the dirty log update is guarded by the new_spte being prese=
nt, so
>zapping of any kind won't trigger it=2E
>
>Currently, I believe the only path that would create a present SPTE witho=
ut an
>active vCPU is mmu_notifer=2Echange_pte, but that squeaks by because its =
required
>to be wrapped with invalidate_range_{start,end}(MMU_NOTIFY_CLEAR), and KV=
M zaps
>in that situation=2E

Is it sufficient to have *an* active vCPU?  What if a VMM has threads for =
active vCPUs but is doing mmap/munmap on a *different* thread? Does that no=
t suffer the same crash?


--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
