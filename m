Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0ED4D2F92
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 13:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbiCINAt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 08:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232870AbiCINAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 08:00:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2BEDF172241
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 04:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646830788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SFPZnRqA444gLBla00f7r4rvBmtg5YJUlHA0p/BeLGU=;
        b=jVfBT8ETwjZlHtfNCZpuZuX1v2Ms9AW0T/dsnGqvBzPNUih2xzgJbikLGVOSJFiSqLq1dh
        16NfFW64Ls48HS9GfWqR1uYgftjK5MMWEhlMWeu0MbeoykhOlLriPdvcPlEkvjmjZVhz3h
        wWSakM9aJegYi08bWhdrA7EOcX/Skng=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-292-yYfIO_BUOC-I-QDFxQirPw-1; Wed, 09 Mar 2022 07:59:45 -0500
X-MC-Unique: yYfIO_BUOC-I-QDFxQirPw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 567CB1091DA2;
        Wed,  9 Mar 2022 12:59:42 +0000 (UTC)
Received: from starship (unknown [10.40.192.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA09D22E01;
        Wed,  9 Mar 2022 12:59:34 +0000 (UTC)
Message-ID: <6dc7cff15812864ed14b5c014769488d80ce7f49.camel@redhat.com>
Subject: Re: [PATCH v6 6/9] KVM: x86: lapic: don't allow to change APIC ID
 unconditionally
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Chao Gao <chao.gao@intel.com>
Cc:     Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>
Date:   Wed, 09 Mar 2022 14:59:33 +0200
In-Reply-To: <YihCtvDps/qJ2TOW@google.com>
References: <20220225082223.18288-1-guang.zeng@intel.com>
         <20220225082223.18288-7-guang.zeng@intel.com> <Yifg4bea6zYEz1BK@google.com>
         <20220309052013.GA2915@gao-cwp> <YihCtvDps/qJ2TOW@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-03-09 at 06:01 +0000, Sean Christopherson wrote:
> TL;DR: Maxim, any objection to yet another inhibit?  Any potential issues you can think of?
> 
> On Wed, Mar 09, 2022, Chao Gao wrote:
> > On Tue, Mar 08, 2022 at 11:04:01PM +0000, Sean Christopherson wrote:
> > > On Fri, Feb 25, 2022, Zeng Guang wrote:
> > > > From: Maxim Levitsky <mlevitsk@redhat.com>
> > > > 
> > > > No normal guest has any reason to change physical APIC IDs,
> > > 
> > > I don't think we can reasonably assume this, my analysis in the link (that I just
> > > realized I deleted from context here) shows it's at least plausible that an existing
> > > guest could rely on the APIC ID being writable.  And that's just one kernel, who
> > > know what else is out there, especially given that people use KVM to emulate really
> > > old stuff, often on really old hardware.
> > 
> > Making xAPIC ID readonly is not only based on your analysis, but also Intel SDM
> > clearly saying writable xAPIC ID is processor model specific and ***software should
> > avoid writing to xAPIC ID***.
> 
> Intel isn't the only vendor KVM supports, and xAPIC ID is fully writable according
> to AMD's docs and AMD's hardware.  x2APIC is even (indirectly) writable, but luckily
> KVM has never modeled that...
> 
> Don't get me wrong, I would love to make xAPIC ID read-only, and I fully agree
> that the probability of breaking someone's setup is very low, I just don't think
> the benefits of forcing it are worth the risk of breaking userspace.
> 
> > If writable xAPIC ID support should be retained and is tied to a module param,
> > live migration would depend on KVM's module params: e.g., migrate a VM with
> > modified xAPIC ID (apic_id_readonly off on this system) to one with
> > xapic_id_readonly on would fail, right? Is this failure desired?
> 
> Hrm, I was originally thinking it's not a terrible outcome, but I was assuming
> that userspace would gracefully handle migration failure.  That's a bad assumption.
> 
> > if not, we need to have a VM-scope control. e.g., add an inhibitor of APICv
> > (XAPIC_ID_MODIFIED) and disable APICv forever for this VM if its vCPUs or
> > QEMU modifies xAPIC ID.
> 
> Inhibiting APICv if IPIv is enabled (implied for AMD's AVIC) is probably a better
> option than a module param.  I was worried about ending up with silently degraded
> VM performance, but that's easily solved by adding a stat to track APICv inhibitions,
> which would be useful for other cases too (getting AMD's AVIC enabled is comically
> difficult).
> 
> That would also let us drop the code buggy avic_handle_apic_id_update().
> 
> And it wouldn't necessarily have to be forever, though I agree that's a perfectly
> fine approach until we have data that shows anything fancier is necessary.
> 
> > > Practically speaking, anyone that wants to deploy IPIv is going to have to make
> > > the switch at some point, but that doesn't help people running legacy crud that
> > > don't care about IPIv.
> > > 
> > > I was thinking a module param would be trivial, and it is (see below) if the
> > > param is off by default.  A module param will also provide a convenient opportunity
> > > to resolve the loophole reported by Maxim[1][2], though it's a bit funky.
> > 
> > Could you share the links?
> 
> Doh, sorry (they're both in this one).
> 
> https://lore.kernel.org/all/20220301135526.136554-5-mlevitsk@redhat.com
> 

My opinion on this subject is very simple: we need to draw the line somewhere.
 
There is balance between supporting (poorly) unused hardware features and
not supporting them at all.
 
Writable APIC id is not just some legacy feature like task switch but a 
feature that is frowned upon in both Intel and AMD manual:
 
Yes, look at AMD's SDM at:
 
"16.3.3 Local APIC ID
 
Unique local APIC IDs are assigned to each CPU core in the system. The value is determined by
hardware, based on the number of CPU cores on the processor and the node ID of the processor.
 
The APIC ID is located in the APIC ID register at APIC offset 20h. See Figure 16-3. It is model
dependent, whether software can modify the APIC ID Register. The initial value of the APIC ID (after
a reset) is the value returned in CPUID function 0000_0001h_EBX[31:24]."
 
 
Also in section '16.12 x2APIC_ID' of SDM it is mentioned:
 
 
RDMSR. An RDMSR of MSR 0802h returns the x2APIC_ID in EAX[31:0]. The x2APIC_ID is a
read-only register. 
 
Attempting to write MSR 802h or attempting to read this MSR when not in x2APIC
mode causes a #GP(0) exception. See 16.11 “Accessing x2APIC Registers”.
 
 
CPUID. The x2APIC ID is reported by the following CPUID functions Fn0000_000B (Extended
Topology Enumeration) and CPUID Fn8000_001E (Extended APIC ID) as follows:
 
 
From this you can also infer that x2apic id is assigned once on boot, and same value is
reported in CPUID and in MSR 0x0802.
 
 
The fact that one can outsmart the microcode, change apic id and then switch to
x2apic mode, is more a like a microcode bug that a feature IMHO, that nobody
bothered to fix since nobody uses it.
 
 
Sean, please don't get me wrong, I used to think differently on this - 
I implemented PDPTRS migration in kvm, although in retrospect I probably shouldn't.

I also understand your concerns - and I am not going to fight over this, a module
param for read only apic id, will work for me.
 
All I wanted to do is to make KVM better by simplifying it - KVM is already as complex
as it can get, anything to make it simpler is welcome IMHO.
 
 
Best regards,
	Maxim Levitsky
 
 
 
 

