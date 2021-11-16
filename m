Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E264C4533D3
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 15:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237246AbhKPOPG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 09:15:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43730 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237226AbhKPOPE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 09:15:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637071926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uiBvnRvlGIqT14BdpzfcmO5gnIzPg64WEEQz7oQX4y4=;
        b=RvNeroua7x9tNLEhrzZEb6BE6Fhu4N9XJGhhR/qXV9QrQkQ/rFYNMOoahSnWjvKb8nd6XI
        IlZI/wWkUzvOVy+O8pHNb92n8N/IJys94QeceESY96hBkMAhTjIeCfy89TO7Jk3VpD9sfZ
        rJTHZErAwabdryN8FYxVBPC0Dwd53To=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-Iru3ZIoyM_y6YvmfIhYeOg-1; Tue, 16 Nov 2021 09:12:03 -0500
X-MC-Unique: Iru3ZIoyM_y6YvmfIhYeOg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08DE515721;
        Tue, 16 Nov 2021 14:12:00 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 74B9919D9B;
        Tue, 16 Nov 2021 14:11:57 +0000 (UTC)
Message-ID: <04bf7e8b-d0d7-0eb6-4d15-bfe4999f42f8@redhat.com>
Date:   Tue, 16 Nov 2021 15:11:56 +0100
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
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <94bb55e117287e07ba74de2034800da5ba4398d2.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 14:17, David Woodhouse wrote:
> I'm not sure I'm ready to sign up to immediately fix everything that's
> hosed in nesting and kill off all users of the unsafe kvm_vcpu_map(),
> but I'll at least convert one vCPU user to demonstrate that the new
> gfn_to_pfn_cache is working sanely for that use case.

I even have old patches that tried to do that, so I can try.

Paolo

