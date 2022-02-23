Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2794C1045
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 11:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239488AbiBWK1Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 05:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiBWK1O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 05:27:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5EE202E0BA
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 02:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645612006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dc7XLh6K2KrBr7j9Ohe2YtIT5ilZsSkfLQurBsKqNYk=;
        b=Rz5zDT8U7rer0YShnMwguuVHWW8bFIUbq7g8DbzBK9TpI27sixsbQ5i5vKsOmx5ngmyo8C
        xQrNhn1L+K2O0SSg49PffNWmrG6GRabEDzzEJNrATBXrIucR8KBR6nR0kIQO73VuTFk1sJ
        Fhv5D1kvkGcqes+Tu+pfyziL+POAuh0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-448-L544UElrM8iAQ36cIJMnQg-1; Wed, 23 Feb 2022 05:26:43 -0500
X-MC-Unique: L544UElrM8iAQ36cIJMnQg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9553EFC80;
        Wed, 23 Feb 2022 10:26:40 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5FC771038AC1;
        Wed, 23 Feb 2022 10:26:32 +0000 (UTC)
Message-ID: <7e7d16f2919f4bc708a0da3237161b4325a867c5.camel@redhat.com>
Subject: Re: [PATCH v5 7/8] KVM: VMX: Update PID-pointer table entry when
 APIC ID is changed
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Chao Gao <chao.gao@intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Zeng Guang <guang.zeng@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
Date:   Wed, 23 Feb 2022 12:26:31 +0200
In-Reply-To: <20220223061037.GA21263@gao-cwp>
References: <640e82f3-489d-60af-1d31-25096bef1a46@amd.com>
         <4eee5de5-ab76-7094-17aa-adc552032ba0@intel.com>
         <aa86022c-2816-4155-8d77-f4faf6018255@amd.com>
         <aa7db6d2-8463-2517-95ce-c0bba22e80d4@intel.com>
         <d058f7464084cadc183bd9dbf02c7f525bb9f902.camel@redhat.com>
         <20220110074523.GA18434@gao-cwp>
         <1ff69ed503faa4c5df3ad1b5abe8979d570ef2b8.camel@redhat.com>
         <YeClaZWM1cM+WLjH@google.com> <YfsSjvnoQcfzdo68@google.com>
         <Yfw5ddGNOnDqxMLs@google.com> <20220223061037.GA21263@gao-cwp>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-02-23 at 14:10 +0800, Chao Gao wrote:
> On Thu, Feb 03, 2022 at 08:22:13PM +0000, Sean Christopherson wrote:
> > i.e. ACPI_NUMA gets priority and thus amd_numa_init() will never be reached if
> > the NUMA topology is enumerated in the ACPI tables.  Furthermore, the VMM would
> > have to actually emulate an old AMD northbridge, which is also extremely unlikely.
> > 
> > The odds of breaking a guest are further diminised given that KVM doesn't emulate
> > the xAPIC ID => x2APIC ID hilarity on AMD CPUs and no one has complained.
> > 
> > So, rather than tie this to IPI virtualization, I think we should either make
> > the xAPIC ID read-only across the board,
> 
> We will go this way and defer the introduction of "xapic_id_writable" to the
> emergence of the "crazy" use case.
> 
> Levitsky, we plan to revise your patch 13 "[PATCH RESEND 13/30] KVM: x86: lapic:
> don't allow to change APIC ID when apic acceleration is enabled" to make xAPIC
> ID read-only regardless of APICv/AVIC and include it into IPI virtualization
> series (to eliminate the dependency on your AVIC series). Is it fine with you?


Absolutely!
> And does this patch 13 depend on other patches in your fixes?

This patch doesn't depend on anything.

There is also patch 14 in this series which closes a case where malicious userspace
could upload non default _x2apic id_. I  haven't yet written a unit test
to demonstrate this, but I will soon.

You don't need that patch for now IMHO.

> 
> > or if we want to hedge in case someone
> > has a crazy use case, make the xAPIC ID read-only by default, add a module param
> > to let userspace opt-in to a writable xAPIC ID, and report x2APIC and APICv as
> > unsupported if the xAPIC ID is writable.  E.g. rougly this, plus your AVIC patches
> > if we want to hedge.


Best regards,
	Maxim Levitsky

