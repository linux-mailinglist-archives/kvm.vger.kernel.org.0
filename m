Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C1845365B
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 16:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238589AbhKPPwv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 10:52:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43839 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238652AbhKPPwd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 10:52:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637077776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yn+ieJfD0EQp6jTfQXC4dqRAso26cdB/i5RBhi9hi2A=;
        b=bb4HaZIcZcHD7fFDVSgWkvEIZ9nxyXXkNLaf9bKure0QaEIFnI8hTPx9ir4+Xxvl8Xwfoo
        Dgbd7yU35bn7bO6DdBFFr1FaHKbjXq2hgSCmd5DQkUaV4aT9xboOmXIwYzZABWJtguHckb
        pD5uAspPI4RheDi7+GxkvNoFkftcuuo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-5i5D7G51MJSOOTDllXXX1w-1; Tue, 16 Nov 2021 10:49:32 -0500
X-MC-Unique: 5i5D7G51MJSOOTDllXXX1w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6325715724;
        Tue, 16 Nov 2021 15:49:31 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D4FE5F4E0;
        Tue, 16 Nov 2021 15:49:28 +0000 (UTC)
Message-ID: <02cdb0b0-c7b0-34c5-63c1-aec0e0b14cf7@redhat.com>
Date:   Tue, 16 Nov 2021 16:49:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH 0/11] Rework gfn_to_pfn_cache
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>, karahmed@amazon.com
References: <2b400dbb16818da49fb599b9182788ff9896dcda.camel@infradead.org>
 <32b00203-e093-8ffc-a75b-27557b5ee6b1@redhat.com>
 <28435688bab2dc1e272acc02ce92ba9a7589074f.camel@infradead.org>
 <4c37db19-14ed-46b8-eabe-0381ba879e5c@redhat.com>
 <537fdcc6af80ba6285ae0cdecdb615face25426f.camel@infradead.org>
 <7e4b895b-8f36-69cb-10a9-0b4139b9eb79@redhat.com>
 <95fae9cf56b1a7f0a5f2b9a1934e29e924908ff2.camel@infradead.org>
 <3a2a9a8c-db98-b770-78e2-79f5880ce4ed@redhat.com>
 <2c7eee5179d67694917a5a0d10db1bce24af61bf.camel@infradead.org>
 <537a1d4e-9168-cd4a-cd2f-cddfd8733b05@redhat.com>
 <YZLmapmzs7sLpu/L@google.com>
 <57d599584ace8ab410b9b14569f434028e2cf642.camel@infradead.org>
 <94bb55e117287e07ba74de2034800da5ba4398d2.camel@infradead.org>
 <04bf7e8b-d0d7-0eb6-4d15-bfe4999f42f8@redhat.com>
 <19bf769ef623e0392016975b12133d9a3be210b3.camel@infradead.org>
 <ad0648ac-b72a-1692-c608-b37109b3d250@redhat.com>
 <126b7fcbfa78988b0fceb35f86588bd3d5aae837.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <126b7fcbfa78988b0fceb35f86588bd3d5aae837.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 16:09, David Woodhouse wrote:
> On Tue, 2021-11-16 at 15:57 +0100, Paolo Bonzini wrote:
>> This should not be needed, should it?  As long as the gfn-to-pfn
>> cache's vcpu field is handled properly, the request will just cause
>> the vCPU not to enter.
> 
> If the MMU mappings never change, the request never happens. But the
> memslots *can* change, so it does need to be revalidated each time
> through I think?

That needs to be done on KVM_SET_USER_MEMORY_REGION, using the same 
request (or even the same list walking code) as the MMU notifiers.

>> It would have to take the gpc->lock around
>> changes to gpc->vcpu though (meaning: it's probably best to add a
>> function gfn_to_pfn_cache_set_vcpu).
> 
> Hm, in my head that was never going to *change* for a given gpc; it
> *belongs* to that vCPU for ever (and was even part of vmx->nested. for
> that vCPU, to replace e.g. vmx->nested.pi_desc_map).

Ah okay, I thought it would be set in nested vmentry and cleared in 
nested vmexit.

> +static void nested_vmx_check_guest_maps(struct kvm_vcpu *vcpu)
> +{
> +	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	struct gfn_to_pfn_cache *gpc;
> +
> +	bool valid;
> +
> +	if (nested_cpu_has_posted_intr(vmcs12)) {
> +		gpc = &vmx->nested.pi_desc_cache;
> +
> +		read_lock(&gpc->lock);
> +		valid = kvm_gfn_to_pfn_cache_check(vcpu->kvm, gpc,
> +						   vmcs12->posted_intr_desc_addr,
> +						   PAGE_SIZE);
> +		read_unlock(&gpc->lock);
> +		if (!valid) {
> +			/* XX: This isn't idempotent. Make it so, or use a different
> +			 * req for the 'refresh'. */
> +			kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
> +			return;
> +		}
> +	}
> +}

That's really slow to do on every vmentry.

> So nested_get_vmcs12_pages() certainly isn't idempotent right now
> because of all the kvm_vcpu_map() calls, which would just end up
> leaking — but I suppose the point is to kill all those, and then maybe
> it will be?

Yes, exactly.  That might be a larger than normal patch, but it should 
not be one too hard to review.  Once there's something that works, we 
can think of how to split (if it's worth it).

Paolo

> I quite liked the idea of *not* refreshing the caches immediately,m
> because we can wait until the vCPU is in L2 mode again and actually
> *needs* them.
>   
> 

