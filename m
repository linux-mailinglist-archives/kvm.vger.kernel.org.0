Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF88451D81
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 01:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349552AbhKPAak (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 19:30:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:31698 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345974AbhKOT3j (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Nov 2021 14:29:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637004403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gxvpWEIkBpi0qkBlbtcRU22EsimDIsY3tlVUs11kt8g=;
        b=UeKCPD2FSsuE7P0MImphb3V4NJyJbbPkOfXcSQSl36XCpotrpjFhqyWqjle+kKvpJytYW/
        n1EkOv87fiXntzAsZ7XY11297dTL+NEZfxJ7MVFfJb+Q8OMk+mCa7UP4TycR71WYjQMqJh
        2Brff8nCy0I3whb1e2DH7bxvXuv5/4A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-K-ZCbTVTN8mofvjUphvQmw-1; Mon, 15 Nov 2021 14:26:40 -0500
X-MC-Unique: K-ZCbTVTN8mofvjUphvQmw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A78610144E2;
        Mon, 15 Nov 2021 19:26:38 +0000 (UTC)
Received: from [10.39.195.133] (unknown [10.39.195.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 955345BAE5;
        Mon, 15 Nov 2021 19:26:35 +0000 (UTC)
Message-ID: <537a1d4e-9168-cd4a-cd2f-cddfd8733b05@redhat.com>
Date:   Mon, 15 Nov 2021 20:26:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH 0/11] Rework gfn_to_pfn_cache
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>, karahmed@amazon.com
References: <5d4002373c3ae614cb87b72ba5b7cdc161a0cd46.camel@infradead.org>
 <624bc910-1bec-e6dd-b09a-f86dc6cdbef0@redhat.com>
 <0372987a52b5f43963721b517664830e7e6f1818.camel@infradead.org>
 <1f326c33-3acf-911a-d1ef-c72f0a570761@redhat.com>
 <3645b9b889dac6438394194bb5586a46b68d581f.camel@infradead.org>
 <309f61f7-72fd-06a2-84b4-97dfc3fab587@redhat.com>
 <96cef64bf7927b6a0af2173b0521032f620551e4.camel@infradead.org>
 <40d7d808-dce6-a541-18dc-b0c7f4d6586c@redhat.com>
 <2b400dbb16818da49fb599b9182788ff9896dcda.camel@infradead.org>
 <32b00203-e093-8ffc-a75b-27557b5ee6b1@redhat.com>
 <28435688bab2dc1e272acc02ce92ba9a7589074f.camel@infradead.org>
 <4c37db19-14ed-46b8-eabe-0381ba879e5c@redhat.com>
 <537fdcc6af80ba6285ae0cdecdb615face25426f.camel@infradead.org>
 <7e4b895b-8f36-69cb-10a9-0b4139b9eb79@redhat.com>
 <95fae9cf56b1a7f0a5f2b9a1934e29e924908ff2.camel@infradead.org>
 <3a2a9a8c-db98-b770-78e2-79f5880ce4ed@redhat.com>
 <2c7eee5179d67694917a5a0d10db1bce24af61bf.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <2c7eee5179d67694917a5a0d10db1bce24af61bf.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/15/21 20:11, David Woodhouse wrote:
>> Changing mn_memslots_update_rcuwait to a waitq (and renaming it to
>> mn_invalidate_waitq) is of course also a possibility.
> I suspect that's the answer.
> 
> I think the actual*invalidation*  of the cache still lives in the
> invalidate_range() callback where I have it at the moment. But making
> the req to the affected vCPUs can live in invalidate_range_start(). And
> then the code which*handles*  that req can wait for the
> mmu_notifier_count to reach zero before it proceeds. Atomic users of
> the cache (like the Xen event channel code) don't have to get involved
> with that.
> 
>> Also, for the small requests: since you are at it, can you add the code
>> in a new file under virt/kvm/?
>
> Hm... only if I can make hva_to_pfn() and probably a handful of other
> things non-static?

Yes, I think sooner or later we also want all pfn stuff in one file 
(together with MMU notifiers) and all hva stuff in another; so for now 
you can create virt/kvm/hva_to_pfn.h, or virt/kvm/mm.h, or whatever 
color of the bikeshed you prefer.

Paolo

