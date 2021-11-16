Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C9F453A43
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 20:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240077AbhKPTiD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 14:38:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbhKPTiD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 14:38:03 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7DCC061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 11:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=vrLnP0kRMefjAGd9qVwE3zPFXuFRLmobFXiip5iu7aQ=; b=SOmoGISYxVrhzT/ilu//B+tNlI
        Vsg3UcgmlocMXqGAclsMPXnfrBOttCMgN7FrsRvU8gfqF4z+3PbikvcxcnI7DhKon2p4oyK2hBelA
        JZNroKHlpfgB0URDRb4Ou9HFTUCSPYAYVwOI32+sAkNfr7e0GWt/Qz97BzEJnQ4DZ9GaF5m+Mrt69
        qXYjipkbwJ2L2aWUeuGf9wPmCDNEP2jevIUcnZyVtgf9i8bDf6ZZCD85F2+ckl1vRS2fxK0D27a3/
        faGfaORB9L3DYUk/AzW93h2FnwBQZtGqGfeKmWyA3sXOruORZHqeh6GJ7h7f7Zk5Drv6KBVYEC/oM
        pmTU+SGA==;
Received: from [2a01:4c8:1065:75ad:1534:b29b:894:5154] (helo=[IPv6:::1])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mn4E5-00GMq7-Fv; Tue, 16 Nov 2021 19:34:41 +0000
Date:   Tue, 16 Nov 2021 19:34:37 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <bonzini@gnu.org>,
        Sean Christopherson <seanjc@google.com>
CC:     kvm <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>, karahmed@amazon.com
Subject: Re: [RFC PATCH 0/11] Rework gfn_to_pfn_cache
User-Agent: K-9 Mail for Android
In-Reply-To: <cfa1a13d-5ad2-3ca4-147e-84273ffa2f38@gnu.org>
References: <2b400dbb16818da49fb599b9182788ff9896dcda.camel@infradead.org> <95fae9cf56b1a7f0a5f2b9a1934e29e924908ff2.camel@infradead.org> <3a2a9a8c-db98-b770-78e2-79f5880ce4ed@redhat.com> <2c7eee5179d67694917a5a0d10db1bce24af61bf.camel@infradead.org> <537a1d4e-9168-cd4a-cd2f-cddfd8733b05@redhat.com> <YZLmapmzs7sLpu/L@google.com> <57d599584ace8ab410b9b14569f434028e2cf642.camel@infradead.org> <94bb55e117287e07ba74de2034800da5ba4398d2.camel@infradead.org> <04bf7e8b-d0d7-0eb6-4d15-bfe4999f42f8@redhat.com> <19bf769ef623e0392016975b12133d9a3be210b3.camel@infradead.org> <ad0648ac-b72a-1692-c608-b37109b3d250@redhat.com> <126b7fcbfa78988b0fceb35f86588bd3d5aae837.camel@infradead.org> <02cdb0b0-c7b0-34c5-63c1-aec0e0b14cf7@redhat.com> <9733f477bada4cc311078be529b7118f1dec25bb.camel@infradead.org> <1b8af2ad-17f8-8c22-d0d5-35332e919104@gnu.org> <7bcb9dafa55c283f9f9d0b841f4a53f0b6b3286d.camel@infradead.org> <cfa1a13d-5ad2-3ca4-147e-84273ffa2f38@gnu.org>
Message-ID: <960E233F-EC0B-4FB5-BA2E-C8D2CCB38B12@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 16 November 2021 18:46:03 GMT, Paolo Bonzini <bonzini@gnu=2Eorg> wrote:
>On 11/16/21 18:57, David Woodhouse wrote:
>>>> +		read_lock(&gpc->lock);
>>>> +		if (!kvm_gfn_to_pfn_cache_check(vcpu->kvm, gpc, gpc->gpa, PAGE_SIZ=
E)) {
>>>> +			read_unlock(&gpc->lock);
>>>>    			goto mmio_needed;
>>>> +		}
>>>> +
>>>> +		vapic_page =3D gpc->khva;
>>> If we know this gpc is of the synchronous kind, I think we can skip th=
e
>>> read_lock/read_unlock here?!?
>> Er=2E=2E=2E this one was OUTSIDE_GUEST_MODE and is the atomic kind, whi=
ch
>> means it needs to hold the lock for the duration of the access in order
>> to prevent (preemption and) racing with the invalidate?
>>=20
>> It's the IN_GUEST_MODE one (in my check_guest_maps()) where we might
>> get away without the lock, perhaps?
>
>Ah, this is check_nested_events which is mostly IN_GUEST_MODE but not=20
>always (and that sucks for other reasons)=2E  I'll think a bit more about=
=20
>it when I actually do the work=2E
>
>>>>    		__kvm_apic_update_irr(vmx->nested=2Epi_desc->pir,
>>>>    			vapic_page, &max_irr);
>>>> @@ -3749,6 +3783,7 @@ static int vmx_complete_nested_posted_interrupt=
(struct kvm_vcpu *vcpu)
>>>>    			status |=3D (u8)max_irr;
>>>>    			vmcs_write16(GUEST_INTR_STATUS, status);
>>>>    		}
>>>> +		read_unlock(&gpc->lock);
>>>>    	}
>>>>   =20
>> I just realised that the mark_page_dirty() on invalidation and when the
>> the irqfd workqueue refreshes the gpc might fall foul of the same
>> dirty_ring problem that I belatedly just spotted with the Xen shinfo
>> clock write=2E I'll fix it up to*always*  require a vcpu (to be
>> associated with the writes), and reinstate the guest_uses_pa flag since
>> that can no longer in implicit in (vcpu!=3DNULL)=2E
>
>Okay=2E
>
>> I may leave the actual task of fixing nesting to you, if that's OK, as
>> long as we consider the new gfn_to_pfn_cache sufficient to address the
>> problem? I think it's mostly down to how we*use*  it now, rather than
>> the fundamental design of cache itself?
>
>Yes, I agree=2E  Just stick whatever you have for nesting as an extra=20
>patch at the end, and I'll take it from there=2E


Will do; thanks=2E I believe you said you'd already merged a batch includi=
ng killing the first three of the nesting kvm_vcpu_map() users, so I'll wai=
t for those to show up in a tree I can pull from and then post a single ser=
ies with the unified Makefile=2Ekvm bits followed by pfncache=2Ec and the X=
en event channel support using it=2E And as requested, ending with the nest=
ed pfncache one I posted a couple of messages ago=2E

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
