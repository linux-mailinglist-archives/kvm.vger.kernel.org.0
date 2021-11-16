Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCABD4534BF
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 15:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237677AbhKPPAy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 10:00:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34590 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233685AbhKPPAr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 10:00:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637074670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J9ZGbcfgP1zFzA+Vk6QiIz3QS4KTU9mznjiqf2bI91I=;
        b=YVcLdbg3NtMa6FopCJZF5DHMznOy4qFnSuuU82yZRsUJI7MzL9qfgNcS/d5GZAggvs45sK
        XG1qLiKwOwhTGTfyeFK5cJ/3Y0zSbTOxRzwXXNhZNuFVVkPJrXg/mC9G2HqrfJ39IJJnsi
        mL+UA9QN9ClbA0DhmiypoA1zZjYWa8E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-gWdK6xN2P7eS0tB9DWAPug-1; Tue, 16 Nov 2021 09:57:46 -0500
X-MC-Unique: gWdK6xN2P7eS0tB9DWAPug-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71F4ACC625;
        Tue, 16 Nov 2021 14:57:42 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE3245C1D5;
        Tue, 16 Nov 2021 14:57:39 +0000 (UTC)
Message-ID: <ad0648ac-b72a-1692-c608-b37109b3d250@redhat.com>
Date:   Tue, 16 Nov 2021 15:57:38 +0100
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
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <19bf769ef623e0392016975b12133d9a3be210b3.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 15:25, David Woodhouse wrote:
> +       /*
> +        * If the guest requires direct access to mapped L1 pages, check
> +        * the caches are valid. Will raise KVM_REQ_GET_NESTED_STATE_PAGES
> +        * to go and revalidate them, if necessary.
> +        */
> +       if (is_guest_mode(vcpu) && kvm_x86_ops.nested_ops->check_guest_maps)
> +               kvm_x86_ops.nested_ops->check_guest_maps();
> +

This should not be needed, should it?  As long as the gfn-to-pfn
cache's vcpu field is handled properly, the request will just cause
the vCPU not to enter.  It would have to take the gpc->lock around
changes to gpc->vcpu though (meaning: it's probably best to add a
function gfn_to_pfn_cache_set_vcpu).

Doing it lockless would be harder; I cannot think of any well-known
pattern that is good for this scenario.

> That check_guest_maps() function can validate the caches which the L2
> guest is actually using in the VMCS02, and if they need to be refreshed
> then raising a req will immediately break out of vcpu_enter_guest() to
> allow that to happen.
> 
> I*think*  we can just use KVM_REQ_GET_NESTED_STATE_PAGES for that and
> don't need to invent a new one?

Yes, maybe even do it unconditionally?

-                if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
+                if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu) ||
		     kvm_check_request(KVM_REQ_GPC_INVALIDATE, vcpu))

if the gfn-to-pfn cache's vcpu field is set/reset properly across nested
VM entry and exit.

Paolo

