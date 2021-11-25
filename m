Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037E545E17E
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 21:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243540AbhKYUXS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 15:23:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25343 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356929AbhKYUVS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Nov 2021 15:21:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637871486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vWvDIzaR2bx+Vdo3MkX6KaH7zFuYCjV3qRrLqKSpquM=;
        b=QRJ6X3CfldMZRvmBzVwvKX5YsnLMY2pG1hqGe1ZJhiURS7DnfN6ah7lzdJ8V6rU0qTGPnC
        r+TGMX98fRp/5VmdEm+EUkwfzL5rEKGRT08Xkmz/nAChRHsp+jF5g52X3hObbBWXNm37D8
        vaop1WEzWpEJAt1lVg82JDLrzelNa6c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-58-s5dDJZ-2OV2JjHk2k2lTyw-1; Thu, 25 Nov 2021 15:18:03 -0500
X-MC-Unique: s5dDJZ-2OV2JjHk2k2lTyw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 426FF8042E2;
        Thu, 25 Nov 2021 20:18:01 +0000 (UTC)
Received: from [10.39.192.99] (unknown [10.39.192.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0CEF81000324;
        Thu, 25 Nov 2021 20:17:48 +0000 (UTC)
Message-ID: <620e127f-59d3-ccad-e0f6-39ca9ee7098e@redhat.com>
Date:   Thu, 25 Nov 2021 21:17:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH v3 46/59] KVM: VMX: Move register caching logic to
 common code
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>, isaku.yamahata@intel.com,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <2f3c1207f66f44fdd2f3eb0809d552f5632e4b41.1637799475.git.isaku.yamahata@intel.com>
 <87mtlshu66.ffs@tglx>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87mtlshu66.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/25/21 21:11, Thomas Gleixner wrote:
>>
>> Use kvm_x86_ops.cache_reg() in ept_update_paging_mode_cr0() rather than
>> trying to expose vt_cache_reg() to vmx.c, even though it means taking a
>> retpoline.  The code runs if and only if EPT is enabled but unrestricted
>> guest.
> This sentence does not parse because it's not a proper sentence.
> 
>> Only one generation of CPU, Nehalem, supports EPT but not
>> unrestricted guest, and disabling unrestricted guest without also
>> disabling EPT is, to put it bluntly, dumb.
> This one is only significantly better and lacks an explanation what this
> means for the dumb case.

Well, it means a retpoline (see paragraph before).  However, I'm not 
sure why it one wouldn't create a vt.h header with all vt_* functions.

Paolo

