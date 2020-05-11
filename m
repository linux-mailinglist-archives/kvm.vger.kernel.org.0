Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7051CE1B3
	for <lists+kvm@lfdr.de>; Mon, 11 May 2020 19:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730974AbgEKR30 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 13:29:26 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34822 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730215AbgEKR3V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 May 2020 13:29:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589218160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VcjLXdSIU3UxVcedEoJ6SH5pMrdBTnR+Dd6Ysme7bQE=;
        b=D76+5ve1oQwO7U++ELBZev1PyZGyX3rX2nsCpN2VLvpFyIA5rlgk9kR+Co6YZN9l0lJSjE
        vrfCNQWMIri7yhj9f2xonYFJY2RVme3ldxAuryKtqBDw/Y2uY/gYQvl9vOIY+cbj4FK1Kx
        EpzaJxsorPVI+/HWXil106g8VW7P/M0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-Gcb8uUfZPIC2k9wC9j05Hg-1; Mon, 11 May 2020 13:29:18 -0400
X-MC-Unique: Gcb8uUfZPIC2k9wC9j05Hg-1
Received: by mail-wm1-f69.google.com with SMTP id k17so1047431wmi.4
        for <kvm@vger.kernel.org>; Mon, 11 May 2020 10:29:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VcjLXdSIU3UxVcedEoJ6SH5pMrdBTnR+Dd6Ysme7bQE=;
        b=HF8q9IzAjdb1K9Q3F2IBL/O8cAXXFVo5ap5Ay6xz+NlVGUbauuHwAhaGmpG6zLovhC
         UYhAsnz+GFomQX8Zi0XZr8m1SnXCeuJ2lrjRT4GTxVSTfsyap76DujQwpR1YcGHSeXNZ
         BTqjxi4Wb9Y3Q68V3T0m/8VbGBG6jN+GxIP0GUagSb0HfIdSJK3ewIj+fJLkfZCgu0/y
         K14HsxlUijXxQSpwRvjfy8heBvfypctpwK1deJAVgq5C73oLvFa8/fFFwRP9NYp8RwR2
         fitXVM4zaKVH7QQzVKAE9b/n6uq+ezZnZEhwpl/EuZr9THvWXfx+bOfR0mvLMJvRndLr
         vACw==
X-Gm-Message-State: AGi0PuYxAlQblTZWE1j+mey/3LvMRaqXGwaTVFgoLEs5UfQbMsIGZNBv
        OwVV1ChFMVVi/2qvD1t8+0E4+lrMPp4ylRmBJfKe19NJEfKKUz6NfU8qIj1s/SyUXmrg6DWA6eW
        2lasO82RCdixc
X-Received: by 2002:a05:600c:2284:: with SMTP id 4mr31160518wmf.97.1589218157429;
        Mon, 11 May 2020 10:29:17 -0700 (PDT)
X-Google-Smtp-Source: APiQypJRZVFO2OwNtcnrU/NHaU9Vp39q1pCtEQ+KrkvJyuh7MR6CBPU7MVFLvb96H+TnVnPZLr5rCw==
X-Received: by 2002:a05:600c:2284:: with SMTP id 4mr31160491wmf.97.1589218157189;
        Mon, 11 May 2020 10:29:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4c95:a679:8cf7:9fb6? ([2001:b07:6468:f312:4c95:a679:8cf7:9fb6])
        by smtp.gmail.com with ESMTPSA id m1sm19333411wrx.44.2020.05.11.10.29.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 10:29:16 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: VMX: Invoke kvm_exit tracepoint on VM-Exit due
 to failed VM-Enter
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200508235348.19427-1-sean.j.christopherson@intel.com>
 <20200508235348.19427-2-sean.j.christopherson@intel.com>
 <551ed3f8-8e6c-adbd-67ff-babd39b7597f@redhat.com>
 <20200511170823.GD24052@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e391daa9-9c3b-3e3c-6d09-bb0a825a2f67@redhat.com>
Date:   Mon, 11 May 2020 19:29:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200511170823.GD24052@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/05/20 19:08, Sean Christopherson wrote:
> On Sat, May 09, 2020 at 02:54:42PM +0200, Paolo Bonzini wrote:
>> On 09/05/20 01:53, Sean Christopherson wrote:
>>> Restore the pre-fastpath behavior of tracing all VM-Exits, including
>>> those due to failed VM-Enter.
>>>
>>> Fixes: 032e5dcbcb443 ("KVM: VMX: Introduce generic fastpath handler")
>>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>>> ---
>>>  arch/x86/kvm/vmx/vmx.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> Squashed, thanks.  Though is it really the right "Fixes"?
> 
> Pretty sure, that's the commit that moved trace_kvm_exit() from
> vmx_handle_exit() to vmx_vcpu_run().  Prior to that, all fastpaths still
> flowed through vmx_handle_exit().
> 

Indeed, fast path was never handled in vcpu_enter_guest.

Paolo

