Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC7B450F37C
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 10:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344231AbiDZIRd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 04:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233706AbiDZIRc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 04:17:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A38946D397
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 01:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650960864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MEOR6S/ja4n9OTXgV5FZcIwBotf+F762IQYY3cXNpwg=;
        b=SSD7j5/FKApdxL4eEKPMZdJKjKAms50AfoobkoKTGAy0ToXBuo2+iq4micKzCGPcjAOZ3U
        C7o5jJWtcNTRXnujLMwpZxLBaxqKCLQIrYWLfgcGl3XzV/i+ru7i5kJWC0x4LX6HGgbFg7
        0L9b77lt4dEaH4qk7ontqvkGDj86mlk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-325--M4JGlQgP9mKuY5GdlcSxg-1; Tue, 26 Apr 2022 04:14:21 -0400
X-MC-Unique: -M4JGlQgP9mKuY5GdlcSxg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E0E3811E76;
        Tue, 26 Apr 2022 08:14:20 +0000 (UTC)
Received: from starship (unknown [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 734972024CB8;
        Tue, 26 Apr 2022 08:14:15 +0000 (UTC)
Message-ID: <6475522c58aec5db3ee0a5ccd3230c63a2f013a9.camel@redhat.com>
Subject: Re: [PATCH v8 6/9] KVM: x86: lapic: don't allow to change APIC ID
 unconditionally
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
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
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Gao Chao <chao.gao@intel.com>
Date:   Tue, 26 Apr 2022 11:14:14 +0300
In-Reply-To: <080d6ced254e56dbad2910447f81c5ea976fc419.camel@redhat.com>
References: <20220411090447.5928-1-guang.zeng@intel.com>
         <20220411090447.5928-7-guang.zeng@intel.com> <YlmDtC73u/AouMsu@google.com>
         <080d6ced254e56dbad2910447f81c5ea976fc419.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-04-19 at 17:07 +0300, Maxim Levitsky wrote:
> On Fri, 2022-04-15 at 14:39 +0000, Sean Christopherson wrote:
> > On Mon, Apr 11, 2022, Zeng Guang wrote:
> > > From: Maxim Levitsky <mlevitsk@redhat.com>
> > > 
> > > No normal guest has any reason to change physical APIC IDs, and
> > > allowing this introduces bugs into APIC acceleration code.
> > > 
> > > And Intel recent hardware just ignores writes to APIC_ID in
> > > xAPIC mode. More background can be found at:
> > > https://lore.kernel.org/lkml/Yfw5ddGNOnDqxMLs@google.com/
> > > 
> > > Looks there is no much value to support writable xAPIC ID in
> > > guest except supporting some old and crazy use cases which
> > > probably would fail on real hardware. So, make xAPIC ID
> > > read-only for KVM guests.
> > 
> > AFAIK, the plan is to add a capability to let userspace opt-in to a fully read-only
> > APIC ID[*], but I haven't seen patches...
> > 
> > Maxim?
> 
> Yep, I will start working on this pretty much today.
> 
> I was busy last 3 weeks stablilizing nested AVIC
> (I am getting ~600,000 IPIs/s instead of ~40,000 in L2 VM with nested AVIC!),
> with 700,000-900,000 IPIs native with AVIC, 
> almost bare metal IPI performance in L2!
> 
> (the result is from test which I will soon publish makes all 
> vCPUs send IPIs in round robin fashion, and a vCPU sends IPI only after 
> it received it from previous vCPU - the number is total
> number of IPIs send on 8 vCPUs).
> 
> 
> The fact that the dreadful AVIC errata dominates my testing again,
> supports my feeling that I mostly fixed nested AVIC bugs.'
> Tomorrow I'll send RFC v2 of the patches.
> 
> 
> About read-only apic ID cap, 
> I have few questions before I start implementing it:
> 
> Paolo gave me recently an idea to make the APIC ID always read-only for 
> guest writes, and only allow host APIC ID changes (unless the cap is set).
> 
> I am kind of torn about it - assuming that no guest writes APIC ID this will work just fine 
> in empty logical sense, but if a guest actually writes an apic id, 
> while it will migrate fine to a newer KVM, but then after a reboot 
> it won't be able to set its APIC ID again.
> 
> On the other hand, versus fully unconditional read-only apic id, 
> that will support that very unlikely case if the hypervisor
> itself is actually the one that for some reason changes the apic id,
> from the initial value it gave.
> 
> 
> In terms of what I need:
> 
> - In nested AVIC I strongly prefer read-only apic ids, and I can
>   make nested AVIC be conditional on the new cap.
>   IPI virtualization also can be made conditional on the new cap.
> 
> 
> - I also would love to remove broken code from *non nested* AVIC, 
>   which tries to support APIC ID change. 
> 
>   I can make non nested AVIC *also* depend on the new cap, 
>   but that will technically be a regression, since this way users of 
>   older qemu and new kernel will suddenly have their AVIC inhibited. 
> 
>   I don't know if that is such a big issue though because AVIC is
>   (sadly) by default disabled anyway.
> 
>   If that is not possible the other way to solve this is to inhibit AVIC
>   as soon as the guest tries to change APIC ID.
> 
> - I would also want to remove the ability to relocate apic base,
>   likely depending on the new cap as well, but if there are objections
>   I can drop this. I don't need this, but it is just nice to do while we
>   are at it.
> 
> 
> Paolo, Sean, and everyone else: What do you think?

Palo, Sean, Any update?

After thinking more about this, I actualy think I will do something
different, something that actually was proposed here, and I was against it:


1. I will add new inhibit APICV_INHIBIT_REASON_RO_SETTINGS, which will be set
first time any vCPU touches apic id and/or apic base because why not...

That will take care of non nested case cleanly, and will take care of IPIv
for now (as long as it does't support nesting).

2. For my nested AVIC, I will do 2 things:

   a. My code never reads L1 apic ids, and always uses vcpu_id, thus
      in theory, if I just ignore the problem, and the guest changes apic ids,
      the nested AVIC will just keep on using initial apic ids, thus there is  no danger
      of CVE like issue if the guest tries to change theses ids in the 'right' time.

   b. on each nested vm entry I'll just check that apic id is not changed from the default,
      if AVIC is enabled for the nested guest.

      if so the nested entry will fail (best with kvm_vm_bugged) to get attention of
      the user, but I can just fail it with standard vm exit reason of 0xFFFFFFFF.

      Chances that there is a modern VM, which runs nested guests, on AMD, and changes APIC IDs,
      IMHO are too low to bother, plus one can always disable nested AVIC for this case by tweaking
      the nested CPUID.


This way there will no need to patch qemu, propogate the new cap to the machines, etc, etc.

What do you think?

Best regards,
	Maxim Levitsky



> 
> Also:
> Suggestions for the name for the new cap? Is this all right if
> the same cap would make both apic id read only and apic base
> (this is also something Paolo suggested to me)
> 
> Best regards,
> 	Maxim Levitsky
> 
> 
> > [*] https://lore.kernel.org/all/c903e82ed2a1e98f66910c35b5aabdcf56e08e72.camel@redhat.com
> > 


