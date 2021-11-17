Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913104541E1
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 08:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233543AbhKQHe2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 02:34:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41239 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233491AbhKQHeZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Nov 2021 02:34:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637134287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=23OuV/mk3Y+a0kNS+SMynu0YzqB1dzxguYv4ugNy9/M=;
        b=bXW5SurW2pxwLDGxBjyH07oYmogUu9JYdlr690/MqKHr0F6i1rmDA+y0eu89OL+EltyJBI
        cVee6Tmu4kQAq1O1zMipLEwfPji5sVV4POvbjAq2xc9bHy1t6N+uZgnl23AHljhnS06DHL
        hBXQJ97F9KWahCXk6MptGoEUvt0MjbE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-11-BxEfvrPvNBGoDxCI6c0q6Q-1; Wed, 17 Nov 2021 02:31:23 -0500
X-MC-Unique: BxEfvrPvNBGoDxCI6c0q6Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 19CAC846187;
        Wed, 17 Nov 2021 07:31:21 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B97F418E;
        Wed, 17 Nov 2021 07:31:18 +0000 (UTC)
Message-ID: <2e2ab02c-b324-e136-924a-0376040163a8@redhat.com>
Date:   Wed, 17 Nov 2021 08:31:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Thoughts of AMX KVM support based on latest kernel
Content-Language: en-US
To:     "Nakajima, Jun" <jun.nakajima@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     "Liu, Jing2" <jing2.liu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>
References: <BYAPR11MB325685AB8E3DFD245846F854A9939@BYAPR11MB3256.namprd11.prod.outlook.com>
 <878rxn6h6t.ffs@tglx> <16BF8BE6-B7B1-4F3E-B972-9D82CD2F23C8@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <16BF8BE6-B7B1-4F3E-B972-9D82CD2F23C8@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/17/21 05:52, Nakajima, Jun wrote:
> If a (creative) guest wants to set XFD[AMX] = 1 for fun while keeping
> AMX state alive without saving the AXM state, it may lose the state
> after VM exit/entry.

I think this should not happen, unless you also document that other 
random events (hypothetically, it could be some other core using AMX?) 
can cause the loss of XTILEDATA if XFD[AMX]=1.  Virtualization should 
not be special, I'd prefer that the guest has the same behavior as bare 
metal in this respect.

Paolo

