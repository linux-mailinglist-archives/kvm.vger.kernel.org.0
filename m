Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C457453994
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 19:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239186AbhKPStF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 13:49:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhKPStD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 13:49:03 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1144BC061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 10:46:06 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id t5so6599836edd.0
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 10:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wlme9Vu6LOpFH3vZ4zLx5iBLJ/IVmnpXe5AaDfQWBPI=;
        b=coMHiYQLowf1qs9I+Et8Rj+WyqWj6htDkH5dTi6nkWnAIWLkO+dhHDs0OQROGj0Ou7
         XcAc+Qvj3rKfOlaZFDgTVSmnh1dCTeBRniytdQz/fvW89wYq3/HXBqYtTiOowOMo+Cut
         o7kZsvE/ABF0eGCuoIx1KAtQvDnuHfEOcYo+Y5looILym1kcF19+4cWmtb4MjHzBFLCx
         304FSTdeJ12Gj+h/gfJZqR3Ieq0R1N/Jv3T4GujtBaNXi1uElL+QhsXPOhmoUPv4QylD
         qSauFvT+LH7YkK2Pq+++0/hn/doZrfefM/dVGGLE1LjSPYNy1bwFH00fUIB05qSnrnK2
         Dy5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wlme9Vu6LOpFH3vZ4zLx5iBLJ/IVmnpXe5AaDfQWBPI=;
        b=XGmhlPK66G6S7mPMhWoq2nAIgKkcosmD0UluaPYGKjf3W4XvdtO1d+HQk5s7pzaDeX
         M7CgSEutGNbxvRvH5wpGzwH37Z7NP7g1u4/1SuzFiTHLC0cGE9j18r/jN8t4bV2ThvRQ
         QEggw9XXX0HqLlGz83j4pHKZBmyh4rJ3THcLTiNA7KVVaGPC3e7Am4TBPqWd71MORFip
         Z9nvxuZfMzr7rubVoUOIXWBQnVlpx1E+BS8fBvfz0rO3ZkE+bt0ucJM1CbkpmtMwYlte
         gYGc2OecKz4cgbHNQ4RI6PPLxI64OzESa2rI1FhQkig4xzmpEiJ2gYMle7r44aCpWLpC
         iyWA==
X-Gm-Message-State: AOAM532sQnncGkTVal9WP+4cE4KdnRKxPGj14m30RLQC8BPwh5OFtIwI
        fyGjfLtccpYUFvPRCU6TYPo=
X-Google-Smtp-Source: ABdhPJze/cSzon/weyxHLIEFfzPJ52f1Jk2j6w0pMOWnJ0tgRpHLYyN3rr0fnW0hyV6Epl3WGCpUSA==
X-Received: by 2002:a17:906:1396:: with SMTP id f22mr13071064ejc.228.1637088364620;
        Tue, 16 Nov 2021 10:46:04 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id m6sm3195890edc.36.2021.11.16.10.46.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 10:46:04 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <cfa1a13d-5ad2-3ca4-147e-84273ffa2f38@gnu.org>
Date:   Tue, 16 Nov 2021 19:46:03 +0100
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
 <02cdb0b0-c7b0-34c5-63c1-aec0e0b14cf7@redhat.com>
 <9733f477bada4cc311078be529b7118f1dec25bb.camel@infradead.org>
 <1b8af2ad-17f8-8c22-d0d5-35332e919104@gnu.org>
 <7bcb9dafa55c283f9f9d0b841f4a53f0b6b3286d.camel@infradead.org>
From:   Paolo Bonzini <bonzini@gnu.org>
In-Reply-To: <7bcb9dafa55c283f9f9d0b841f4a53f0b6b3286d.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 18:57, David Woodhouse wrote:
>>> +		read_lock(&gpc->lock);
>>> +		if (!kvm_gfn_to_pfn_cache_check(vcpu->kvm, gpc, gpc->gpa, PAGE_SIZE)) {
>>> +			read_unlock(&gpc->lock);
>>>    			goto mmio_needed;
>>> +		}
>>> +
>>> +		vapic_page = gpc->khva;
>> If we know this gpc is of the synchronous kind, I think we can skip the
>> read_lock/read_unlock here?!?
> Er... this one was OUTSIDE_GUEST_MODE and is the atomic kind, which
> means it needs to hold the lock for the duration of the access in order
> to prevent (preemption and) racing with the invalidate?
> 
> It's the IN_GUEST_MODE one (in my check_guest_maps()) where we might
> get away without the lock, perhaps?

Ah, this is check_nested_events which is mostly IN_GUEST_MODE but not 
always (and that sucks for other reasons).  I'll think a bit more about 
it when I actually do the work.

>>>    		__kvm_apic_update_irr(vmx->nested.pi_desc->pir,
>>>    			vapic_page, &max_irr);
>>> @@ -3749,6 +3783,7 @@ static int vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
>>>    			status |= (u8)max_irr;
>>>    			vmcs_write16(GUEST_INTR_STATUS, status);
>>>    		}
>>> +		read_unlock(&gpc->lock);
>>>    	}
>>>    
> I just realised that the mark_page_dirty() on invalidation and when the
> the irqfd workqueue refreshes the gpc might fall foul of the same
> dirty_ring problem that I belatedly just spotted with the Xen shinfo
> clock write. I'll fix it up to*always*  require a vcpu (to be
> associated with the writes), and reinstate the guest_uses_pa flag since
> that can no longer in implicit in (vcpu!=NULL).

Okay.

> I may leave the actual task of fixing nesting to you, if that's OK, as
> long as we consider the new gfn_to_pfn_cache sufficient to address the
> problem? I think it's mostly down to how we*use*  it now, rather than
> the fundamental design of cache itself?

Yes, I agree.  Just stick whatever you have for nesting as an extra 
patch at the end, and I'll take it from there.

Paolo
