Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA563506FC8
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 16:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352947AbiDSOKJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 10:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243198AbiDSOKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 10:10:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 88B392A734
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 07:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650377243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=avwN5vEGwMPyhOCrMD1a05vTManbL4SDpzVBe7ItULs=;
        b=A24lCJsVihwQRMJLAndHGnfr4hn6bJIFRxnCrRrpq/3LUaAbU1w9QhUsIfpJeO/jrZsI7e
        XnZnJTRpo2l4Wmnrzj4Kk1PkkXY7zQLEWO+60LCfG41FSrACiBI+En37duDpjQTYdqHxcZ
        y1Q1KJizrsnRPABk/FuNMek4ZZm1OZ0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-440-no00TsvoNoeUNikNEe6h8Q-1; Tue, 19 Apr 2022 10:07:18 -0400
X-MC-Unique: no00TsvoNoeUNikNEe6h8Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6CB383C23FA0;
        Tue, 19 Apr 2022 14:07:17 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4743840885A1;
        Tue, 19 Apr 2022 14:07:12 +0000 (UTC)
Message-ID: <080d6ced254e56dbad2910447f81c5ea976fc419.camel@redhat.com>
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
Date:   Tue, 19 Apr 2022 17:07:11 +0300
In-Reply-To: <YlmDtC73u/AouMsu@google.com>
References: <20220411090447.5928-1-guang.zeng@intel.com>
         <20220411090447.5928-7-guang.zeng@intel.com> <YlmDtC73u/AouMsu@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-04-15 at 14:39 +0000, Sean Christopherson wrote:
> On Mon, Apr 11, 2022, Zeng Guang wrote:
> > From: Maxim Levitsky <mlevitsk@redhat.com>
> > 
> > No normal guest has any reason to change physical APIC IDs, and
> > allowing this introduces bugs into APIC acceleration code.
> > 
> > And Intel recent hardware just ignores writes to APIC_ID in
> > xAPIC mode. More background can be found at:
> > https://lore.kernel.org/lkml/Yfw5ddGNOnDqxMLs@google.com/
> > 
> > Looks there is no much value to support writable xAPIC ID in
> > guest except supporting some old and crazy use cases which
> > probably would fail on real hardware. So, make xAPIC ID
> > read-only for KVM guests.
> 
> AFAIK, the plan is to add a capability to let userspace opt-in to a fully read-only
> APIC ID[*], but I haven't seen patches...
> 
> Maxim?

Yep, I will start working on this pretty much today.

I was busy last 3 weeks stablilizing nested AVIC
(I am getting ~600,000 IPIs/s instead of ~40,000 in L2 VM with nested AVIC!),
with 700,000-900,000 IPIs native with AVIC, 
almost bare metal IPI performance in L2!

(the result is from test which I will soon publish makes all 
vCPUs send IPIs in round robin fashion, and a vCPU sends IPI only after 
it received it from previous vCPU - the number is total
number of IPIs send on 8 vCPUs).


The fact that the dreadful AVIC errata dominates my testing again,
supports my feeling that I mostly fixed nested AVIC bugs.'
Tomorrow I'll send RFC v2 of the patches.


About read-only apic ID cap, 
I have few questions before I start implementing it:

Paolo gave me recently an idea to make the APIC ID always read-only for 
guest writes, and only allow host APIC ID changes (unless the cap is set).

I am kind of torn about it - assuming that no guest writes APIC ID this will work just fine 
in empty logical sense, but if a guest actually writes an apic id, 
while it will migrate fine to a newer KVM, but then after a reboot 
it won't be able to set its APIC ID again.

On the other hand, versus fully unconditional read-only apic id, 
that will support that very unlikely case if the hypervisor
itself is actually the one that for some reason changes the apic id,
from the initial value it gave.


In terms of what I need:

- In nested AVIC I strongly prefer read-only apic ids, and I can
  make nested AVIC be conditional on the new cap.
  IPI virtualization also can be made conditional on the new cap.


- I also would love to remove broken code from *non nested* AVIC, 
  which tries to support APIC ID change. 

  I can make non nested AVIC *also* depend on the new cap, 
  but that will technically be a regression, since this way users of 
  older qemu and new kernel will suddenly have their AVIC inhibited. 

  I don't know if that is such a big issue though because AVIC is
  (sadly) by default disabled anyway.

  If that is not possible the other way to solve this is to inhibit AVIC
  as soon as the guest tries to change APIC ID.

- I would also want to remove the ability to relocate apic base,
  likely depending on the new cap as well, but if there are objections
  I can drop this. I don't need this, but it is just nice to do while we
  are at it.


Paolo, Sean, and everyone else: What do you think?

Also:
Suggestions for the name for the new cap? Is this all right if
the same cap would make both apic id read only and apic base
(this is also something Paolo suggested to me)

Best regards,
	Maxim Levitsky


> 
> [*] https://lore.kernel.org/all/c903e82ed2a1e98f66910c35b5aabdcf56e08e72.camel@redhat.com
> 


