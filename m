Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2347148A2B1
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 23:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345386AbiAJWYi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 17:24:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:33021 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241368AbiAJWYd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Jan 2022 17:24:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641853472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OVMJVto/h3bHuFIQM4/MuFTwUhyIKi5r+o6uRQ0M4D4=;
        b=JOLfxy3LlPFrRx0kwuzGZbO0Ak0uNG2nmtN+pBSsrQAWrBS5160SViG5YuJb2nJb1hRn2z
        RJD5kdIjtS+95CNeFwn6cFjGjbB3FowwU4OnTkeSuaUfajdB8MHxgdB2/yyjPpOP9NDkQJ
        PYbaTV+pxgaXYd/4Lh0Ftz3gPrn4REQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-227-QlOkv7AVPGSKBOUJ_syiaQ-1; Mon, 10 Jan 2022 17:24:29 -0500
X-MC-Unique: QlOkv7AVPGSKBOUJ_syiaQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F6BB84BA40;
        Mon, 10 Jan 2022 22:24:26 +0000 (UTC)
Received: from starship (unknown [10.40.192.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CEB7A78DD2;
        Mon, 10 Jan 2022 22:24:10 +0000 (UTC)
Message-ID: <1ff69ed503faa4c5df3ad1b5abe8979d570ef2b8.camel@redhat.com>
Subject: Re: [PATCH v5 7/8] KVM: VMX: Update PID-pointer table entry when
 APIC ID is changed
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     Zeng Guang <guang.zeng@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>
Date:   Tue, 11 Jan 2022 00:24:09 +0200
In-Reply-To: <20220110074523.GA18434@gao-cwp>
References: <20211231142849.611-1-guang.zeng@intel.com>
         <20211231142849.611-8-guang.zeng@intel.com>
         <640e82f3-489d-60af-1d31-25096bef1a46@amd.com>
         <4eee5de5-ab76-7094-17aa-adc552032ba0@intel.com>
         <aa86022c-2816-4155-8d77-f4faf6018255@amd.com>
         <aa7db6d2-8463-2517-95ce-c0bba22e80d4@intel.com>
         <d058f7464084cadc183bd9dbf02c7f525bb9f902.camel@redhat.com>
         <20220110074523.GA18434@gao-cwp>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-01-10 at 15:45 +0800, Chao Gao wrote:
> On Fri, Jan 07, 2022 at 10:31:59AM +0200, Maxim Levitsky wrote:
> > On Fri, 2022-01-07 at 16:05 +0800, Zeng Guang wrote:
> > > On 1/6/2022 10:06 PM, Tom Lendacky wrote:
> > > > On 1/5/22 7:44 PM, Zeng Guang wrote:
> > > > > On 1/6/2022 3:13 AM, Tom Lendacky wrote:
> > > > > > On 12/31/21 8:28 AM, Zeng Guang wrote:
> > > > > > Won't this blow up on AMD since there is no corresponding SVM op?
> > > > > > 
> > > > > > Thanks,
> > > > > > Tom
> > > > > Right, need check ops validness to avoid ruining AMD system. Same
> > > > > consideration on ops "update_ipiv_pid_table" in patch8.
> > > > Not necessarily for patch8. That is "protected" by the
> > > > kvm_check_request(KVM_REQ_PID_TABLE_UPDATE, vcpu) test, but it couldn't hurt.
> > > 
> > > OK, make sense. Thanks.
> > 
> > I haven't fully reviewed this patch series yet,
> > and I will soon.
> > 
> > I just want to point out few things:
> 
> Thanks for pointing them out.
> 
> > 1. AMD's AVIC also has a PID table (its calle AVIC physical ID table). 
> > It stores addressses of vCPUs apic backing pages,
> > and thier real APIC IDs.
> > 
> > avic_init_backing_page initializes the entry (assuming apic_id == vcpu_id) 
> > (which is double confusing)
> > 
> > 2. For some reason KVM supports writable APIC IDs. Does anyone use these?
> > Even Intel's PRM strongly discourages users from using them and in X2APIC mode,
> > the APIC ID is read only.
> > 
> > Because of this we have quite some bookkeeping in lapic.c, 
> > (things like kvm_recalculate_apic_map and such)
> > 
> > Also AVIC has its own handling for writes to APIC_ID,APIC_LDR,APIC_DFR
> > which tries to update its physical and logical ID tables.
> 
> Intel's IPI virtualization doesn't handle logical-addressing IPIs. They cause
> APIC-write vm-exit as usual. So, this series doesn't handle APIC_LDR/DFR.
> 
> > (it used also to handle apic base and I removed this as apic base otherwise
> > was always hardcoded to the default vaule)
> > 
> > Note that avic_handle_apic_id_update is broken - it always copies the entry
> > from the default (apicid == vcpu_id) location to new location and zeros
> > the old location, which will fail in many cases, like even if the guest
> > were to swap few apic ids.
> 
> This series differs from avic_handle_apic_id_update slightly:
> 
> If a vCPU's APIC ID is changed, this series zeros the old entry in PID-pointer
> table and programs the vCPU's PID to the new entry (rather than copy from the
> old entry).

Yes. The AVIC code is pretty much totaly busted in this regard which I noticed recently. 
It will fail the 2nd time it is called because it zeroes the entry it copies, 
and even if the guest changes the APIC ID once, this code will still fail because, 
it is called after each AVIC inhibition.

> 
> But this series is also problematic if guest swaps two vCPU's APIC ID without
> using another free APIC ID; it would end up one of them having no valid entry.

Yes, exactly. I wanted to fix the AVIC's code and also noticed that.
Plus, the guest can assign the same APIC ID to two vCPUs in theory and keep it this
way which complicates things further, from the point of view of what malicious guests can do.
 

> 
> One solution in my mind is:
> 
> when a vCPU's APIC ID is changed, KVM traverses all vCPUs to count vCPUs using
> the old APIC ID and the new APIC ID, programs corrsponding entries following
> below rules:
> 1. populate an entry with a vCPU's PID if the corrsponding APIC ID is
> exclusively used by that vCPU.
> 2. zero an entry for other cases.

Yes, that what I was thinking as well - but zeroing *both* entries when they are duplicate,
is not what I was thinkging and it is a very good idea IMHO.


> 
> Proper locking is needed in this process to prevent changes to vCPUs' APIC IDs.
Yes.

> 
> Or if it doesn't worth it, we can disable IPI virtualization for a guest on its
> first attempt to change xAPIC ID.

Yes, and this brings the main question. Are there any OSes that actually change the APIC ID?
 
I tested winxp, and win10 32 bit, and they seem to work just fine when I don't allow them to change apic id.
Older/more obscure oses like win98/95/dos and such don't use APIC at all.
That leaves only modern OSes like *BSD and such, I'll try to check a few of them soon.
 
I just don't see any reason whatsoever to change APIC ID. It seems that it was initially writable,
just because Intel' forgot to make it read-only, and then they even made it read-only with x2apic.
 
Both Intel and AMD's PRM also state that changing APIC ID is implementation dependent.
 
I vote to forbid changing apic id, at least in the case any APIC acceleration is used, be that APICv or AVIC.
 
 

Best regards,
	Maxim Levitsky

> 
> Let us know which option is preferred.
> 


