Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6537A48741E
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 09:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345847AbiAGIcS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 03:32:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39204 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232742AbiAGIcS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 03:32:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641544337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oLJDHZnC+sET9jArPRQxdauwdVxkw06f0Vq94v7b63k=;
        b=BM8yq99+5SD+aiQ/LyDto6X0DTIAYVh6csJYY/tBpVYMeDMovYNLNzDbU7oHo0ZqQdcwEN
        ecqen2I/7jfm7AaIe5zGcGDFSqlt5SROWpsxmnHGOGmI6yQDJKm9AKdo4KNxuEpqOF/gR7
        ZMz9feP+Dfd+n/AlX8aD5umB5N+wGpM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-29CgojVGMG-fPJ6tl4xNtA-1; Fri, 07 Jan 2022 03:32:14 -0500
X-MC-Unique: 29CgojVGMG-fPJ6tl4xNtA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE5831898291;
        Fri,  7 Jan 2022 08:32:10 +0000 (UTC)
Received: from starship (unknown [10.40.192.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 761137317F;
        Fri,  7 Jan 2022 08:32:00 +0000 (UTC)
Message-ID: <d058f7464084cadc183bd9dbf02c7f525bb9f902.camel@redhat.com>
Subject: Re: [PATCH v5 7/8] KVM: VMX: Update PID-pointer table entry when
 APIC ID is changed
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Zeng Guang <guang.zeng@intel.com>,
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
        "Huang, Kai" <kai.huang@intel.com>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Date:   Fri, 07 Jan 2022 10:31:59 +0200
In-Reply-To: <aa7db6d2-8463-2517-95ce-c0bba22e80d4@intel.com>
References: <20211231142849.611-1-guang.zeng@intel.com>
         <20211231142849.611-8-guang.zeng@intel.com>
         <640e82f3-489d-60af-1d31-25096bef1a46@amd.com>
         <4eee5de5-ab76-7094-17aa-adc552032ba0@intel.com>
         <aa86022c-2816-4155-8d77-f4faf6018255@amd.com>
         <aa7db6d2-8463-2517-95ce-c0bba22e80d4@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-01-07 at 16:05 +0800, Zeng Guang wrote:
> On 1/6/2022 10:06 PM, Tom Lendacky wrote:
> > On 1/5/22 7:44 PM, Zeng Guang wrote:
> > > On 1/6/2022 3:13 AM, Tom Lendacky wrote:
> > > > On 12/31/21 8:28 AM, Zeng Guang wrote:
> > > > Won't this blow up on AMD since there is no corresponding SVM op?
> > > > 
> > > > Thanks,
> > > > Tom
> > > Right, need check ops validness to avoid ruining AMD system. Same
> > > consideration on ops "update_ipiv_pid_table" in patch8.
> > Not necessarily for patch8. That is "protected" by the
> > kvm_check_request(KVM_REQ_PID_TABLE_UPDATE, vcpu) test, but it couldn't hurt.
> 
> OK, make sense. Thanks.

I haven't fully reviewed this patch series yet,
and I will soon.

I just want to point out few things:

1. AMD's AVIC also has a PID table (its calle AVIC physical ID table). 
It stores addressses of vCPUs apic backing pages,
and thier real APIC IDs.

avic_init_backing_page initializes the entry (assuming apic_id == vcpu_id) 
(which is double confusing)

2. For some reason KVM supports writable APIC IDs. Does anyone use these?
Even Intel's PRM strongly discourages users from using them and in X2APIC mode,
the APIC ID is read only.

Because of this we have quite some bookkeeping in lapic.c, 
(things like kvm_recalculate_apic_map and such)

Also AVIC has its own handling for writes to APIC_ID,APIC_LDR,APIC_DFR
which tries to update its physical and logical ID tables.

(it used also to handle apic base and I removed this as apic base otherwise
was always hardcoded to the default vaule)

Note that avic_handle_apic_id_update is broken - it always copies the entry
from the default (apicid == vcpu_id) location to new location and zeros
the old location, which will fail in many cases, like even if the guest
were to swap few apic ids.

Also writable apic ID means that two vCPUs can have same apic ID. No way
we handle this correclty, and no way APICv/AVIC does.

Best regards,
	Maxim Levitsky

> 
> > Thanks,
> > Tom
> > 
> > > I will revise in next version. Thanks.
> > > > > +        } else
> > > > >                 ret = 1;
> > > > >             break;
> > > > > 


