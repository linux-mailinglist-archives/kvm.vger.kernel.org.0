Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D1745EBC9
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 11:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376895AbhKZKj7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 05:39:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:43277 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1376898AbhKZKh7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Nov 2021 05:37:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637922886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FvamVlY8+eH2d6eZ0kPB9KuGqvbC7YHJ0BAgKSSORyo=;
        b=GefqusZP3kpHjBPdX0A4ROr/Nk1t2N8j49Yia2xOh8KKy1MSaJk+o/whNEdNF9MwTMnH8A
        7bl+UnzHQ/l2vor751smD+CuSxQEpFEZesEBk8i4EdCdyvu9hyIe6nMs7Bb2zMu/YiuOCw
        ZMz9u+xi06F3TUFNfu+3XVI14lzg/FQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-255-jo1_Ghq0MKmABYCWdo-0gA-1; Fri, 26 Nov 2021 05:34:43 -0500
X-MC-Unique: jo1_Ghq0MKmABYCWdo-0gA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1821F100CCC2;
        Fri, 26 Nov 2021 10:34:42 +0000 (UTC)
Received: from [10.39.195.16] (unknown [10.39.195.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BB90A19C46;
        Fri, 26 Nov 2021 10:34:29 +0000 (UTC)
Message-ID: <14e0bf75-27f4-83ec-d52f-82d7d4dab5a7@redhat.com>
Date:   Fri, 26 Nov 2021 11:34:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 2/3] KVM: Use atomic_long_cmpxchg() instead of an
 open-coded variant
Content-Language: en-US
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Igor Mammedov <imammedo@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1637884349.git.maciej.szmigiero@oracle.com>
 <7bdc7ee3dcc09a109cfaf9fb8662fb49ca0bec2c.1637884349.git.maciej.szmigiero@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <7bdc7ee3dcc09a109cfaf9fb8662fb49ca0bec2c.1637884349.git.maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/26/21 01:31, Maciej S. Szmigiero wrote:
> -		if ((long)old == atomic_long_read(&slots->last_used_slot))
> -			atomic_long_set(&slots->last_used_slot, (long)new);
> +		/*
> +		 * The atomicity isn't strictly required here since we are
> +		 * operating on an inactive memslots set anyway.
> +		 */
> +		atomic_long_cmpxchg(&slots->last_used_slot,
> +				    (unsigned long)old, (unsigned long)new);

I think using read/set is more readable than a comment saying that 
atomicity is not required.

It's a fairly common pattern, and while I agree that it's a PITA to 
write atomic_long_read and atomic_long_set, the person that reads the 
code is also helped by read/set, because they know they have to think 
about ownership invariants rather than concurrency invariants.

Paolo

