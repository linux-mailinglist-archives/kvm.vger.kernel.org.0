Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A31B5452E67
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 10:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbhKPJyc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 04:54:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:40422 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233634AbhKPJxm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 04:53:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637056244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WI9gXZd/YfgChvu90tDdTH+mU6xPfdwBKXa4/MoRGbE=;
        b=TY9ZjsfhjcRZfdL1PA/5AtZPRW260JGMrsbL3dC/PfLbUQ2BucqEZnBeuw3HvlCC4eSAgB
        f0qMchg0Z+S9Qx+G8LEeLdOXofUyzSn4jTxBDM3UBuBGM1FLQtjPez2y3rKZjYds9F9a4F
        LOU0RYApBRy84O/nmpwV+9Gd3v/a8H8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-27-07bi-SnHNwCAibvJlRsw2w-1; Tue, 16 Nov 2021 04:50:39 -0500
X-MC-Unique: 07bi-SnHNwCAibvJlRsw2w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D48D1015DA0;
        Tue, 16 Nov 2021 09:50:37 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0489D1F41F;
        Tue, 16 Nov 2021 09:50:33 +0000 (UTC)
Message-ID: <04b7e240-8e1d-1402-3cef-e65469bd9317@redhat.com>
Date:   Tue, 16 Nov 2021 10:50:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] KVM: x86: fix cocci warnings
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vihas Mak <makvihas@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     seanjc@google.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211114164312.GA28736@makvihas> <87o86leo34.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87o86leo34.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/15/21 10:59, Vitaly Kuznetsov wrote:
> One minor remark: 'kvm_set_pte_rmapp()' handler is passed to
> 'kvm_handle_gfn_range()' which does
> 
>          bool ret = false;
> 
>          for_each_slot_rmap_range(...)
>                  ret |= handler(...);
> 
> and I find '|=' to not be very natural with booleans. I'm not sure it's
> worth changing though.

Changing that would be "harder" than it seems because "ret = ret || 
handler(...)" is wrong, and "|" is even more unnatural than "|=" (so 
much that clang warns about it).

In fact I wonder if "|=" with a bool might end up warning with clang, 
which we should check before applying this patch.  It doesn't seem to be 
in the original commit[1], but better safe than sorry: Nick, does clang 
intend to warn also about "ret |= fn()" and "ret &= fn()"?  Technically, 
it is a bitwise operation with side-effects in the RHS.

Paolo

[1] https://github.com/llvm/llvm-project/commit/f59cc9542bfb461

