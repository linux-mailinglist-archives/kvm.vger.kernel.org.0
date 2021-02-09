Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01F06314D3A
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 11:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbhBIKfu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 05:35:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21394 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230311AbhBIKdX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 05:33:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612866717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bwHfnqlVJZWOMF4IzUY0PToWasPm/SAqHnnheQjmeeA=;
        b=N3gFEm0sf1QCB1yT8x9MKwOoPuDSGWaiajQJ/vlYSAh0gvQLzYt5EbrFrbQuNp4APV+HOY
        d9fvdZPq6gg/CRJ6pUFFF49XxV4oHyXV8A8CoattgFIhpeGPxpbChbnqhw/y5Ul4Kgz/ww
        m0Ohofa6uT9oACY6TlcuvqH+JIUMe4c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-tlbHZpGFN4GuvsK-PIFNhw-1; Tue, 09 Feb 2021 05:31:55 -0500
X-MC-Unique: tlbHZpGFN4GuvsK-PIFNhw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8258C803F4A;
        Tue,  9 Feb 2021 10:31:54 +0000 (UTC)
Received: from starship (unknown [10.35.206.191])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A186760C04;
        Tue,  9 Feb 2021 10:31:52 +0000 (UTC)
Message-ID: <f3e80b43f31f3992011d13ed8a713c6e1528dd9b.camel@redhat.com>
Subject: Re: [PATCH v2 10/15] KVM: x86: hyper-v: Always use to_hv_vcpu()
 accessor to get to 'struct kvm_vcpu_hv'
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Tue, 09 Feb 2021 12:31:51 +0200
In-Reply-To: <874kiloctw.fsf@vitty.brq.redhat.com>
References: <20210126134816.1880136-1-vkuznets@redhat.com>
         <20210126134816.1880136-11-vkuznets@redhat.com>
         <53c5fc3d29ed35ca3252cd5f6547dcb113ab21b9.camel@redhat.com>
         <874kiloctw.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-02-09 at 09:38 +0100, Vitaly Kuznetsov wrote:
> Maxim Levitsky <mlevitsk@redhat.com> writes:
> 
> > On Tue, 2021-01-26 at 14:48 +0100, Vitaly Kuznetsov wrote:
> > 
> > 
> > ...
> > > _vcpu_mask(
> > >  static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, u64 ingpa, u16 rep_cnt, bool ex)
> > >  {
> > >  	struct kvm *kvm = vcpu->kvm;
> > > -	struct kvm_vcpu_hv *hv_vcpu = &vcpu->arch.hyperv;
> > > +	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(current_vcpu);
> > You probably mean vcpu here instead of current_vcpu. Today I smoke tested the kvm/nested-svm branch,
> > and had this fail on me while testing windows guests.
> > 
> 
> Yes!!!
> 
> We were using 'current_vcpu' instead of 'vcpu' here before but Sean
> warned me about the danger of shadowing global 'current_vcpu' so I added
> 'KVM: x86: hyper-v: Stop shadowing global 'current_vcpu' variable' to
> the series. Aparently, I missed this 'current_vcpu' while
> rebasing. AFAIU, normally vcpu == current_vcpu when entering this
> function so nothing blew up in my testing.
> 
> Thanks for the report! I'll be sending a patch to fix this shortly.
> 
> > Other than that HyperV seems to work and even survive nested migration (I had one
> > windows reboot but I suspect windows update did it.)
> > I'll leave my test overnight (now with updates disabled) to see if it
> > is stable.
> 
> That's good to hear! Are you testing on Intel or AMD? With AMD there's a
> stale bug somewhere which prevents Gen2 (UEFI) L2 guests from booting,
> the firmare just hangs somewhere not making any progress. Both Hyper-V
> 2016 and 2019 seem to be affected. Gen1 guests (including Windows in
> root partition) work fine. I tried approaching it a couple times but
> with no luck so far. Not sure if this is CPU specific or something...
> 

I never had luck with Gen2 guests on AMD (they did work on Intel last time I tried).
I have both Gen1 and Gen2 guests installed, and I boot them once in a while. 

The VM I test HV with is running windows 10 pro build 1909.

On Intel both work, on AMD only Gen1 works. I can take a look, maybe I can spot something.

Do you know by a chance if WSL2 is a Gen2 guest? They have hidden it very well from the user
so you don't even know that you are running a VM.

About my 'windows update' theory, I was wrong, I just haven't given enough memory to
the HV host, and it eventually started getting out of memory crashes according to the event log, 
so I upped the HV memory a bit and it survived ~900 iterations of nested migration so far.

Besides this,
I do have two HV bugs that I am tracking. One relates to not correct initalization of mmu
on nested state load, which is not HV specific but seems to be triggered by it VM 
(I'll send a patch today)

Second issue, is if I run the HV host as a nested itself (which is overkill, but this can easily be not
related to this setup but just have different timings), 
the HV host bluescreens eventually, after doing repeated migration of L1 guest 
(L1 is linux with same patched kernel, L2 is HV host)
It does seem to work on Intel.

Best regards,
	Maxim Levitsky


