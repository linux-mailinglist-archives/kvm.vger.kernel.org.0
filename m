Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCB151684DF
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 18:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbgBUR0M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 12:26:12 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28482 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725957AbgBUR0J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Feb 2020 12:26:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582305968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aa4zbJiGMg7M3QmslZBzxRFUBeWyQYNCsrPB0JpL0lk=;
        b=VzUhsS0HNSqOO6CsxJYJzgbY3yjuPcHhRJCRUV/SU+AG3mvKRyKQW39hGdlgZlWIDXcPpp
        yjmsv3BMrtGqVe/jmXW7xtIVFtvFovuu5k0bm3qSGPkGFKQHSnvqNP25V9mEhDanFkeLdP
        h3TomUZ0dKfQgEChY3HQh8ROfyj9TiE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-AFjBEGyJPsuoz0v-XDbtow-1; Fri, 21 Feb 2020 12:26:04 -0500
X-MC-Unique: AFjBEGyJPsuoz0v-XDbtow-1
Received: by mail-wm1-f70.google.com with SMTP id p2so848437wma.3
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 09:26:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aa4zbJiGMg7M3QmslZBzxRFUBeWyQYNCsrPB0JpL0lk=;
        b=RkokB7bJC+UGkM7jUMFSZcDXC2ofiKG4I2m1cS+dfDce4kKZPQOBYkktgHqymQYpQ3
         SY8LNNJbmriYW130e2PxMEzL5NpLAk4Qc8OHIJcO3SOKRmL/iXkbuBW6Ldbs452uV3zB
         sGZqBDSx70O/X7MSg2Zzefkw9nBKTi5mFFZ9S0GvOhZIbSXMlUkz/9rdewH2weIxqGEa
         DQbDGHdtG7XMZ824B/eGO5EiIULae3wUobBKI1dvoINK7Kl8z6iagYuFQuKE3n2vXteV
         oOFpx9G76pY2O8a58LNQUB7oZeS5ifu+U+HFQmyvzSAp+Sn90NHjB6k1mr8E22Onlzsi
         AxOw==
X-Gm-Message-State: APjAAAVdOD2bAvldfUd9mGDLuK/PFkDT2uRFmQR71+XzcuDzTIvpLwUV
        kW8WzjeZF+/oCNYbr7h0PCKT9FCCT7gIDOQWnpbR63PwM6fEnYsoj0RepMDmda1Ug59KBDi+/+k
        4HqTKFua234cq
X-Received: by 2002:adf:f8c8:: with SMTP id f8mr49551480wrq.331.1582305963517;
        Fri, 21 Feb 2020 09:26:03 -0800 (PST)
X-Google-Smtp-Source: APXvYqzfBUjuDSSdiZSSO9suK49MMgtyvOMcRngBUhZB6jOyM+FsBg+E+dvkna0uZ8vrz9sbtbKk5g==
X-Received: by 2002:adf:f8c8:: with SMTP id f8mr49551468wrq.331.1582305963261;
        Fri, 21 Feb 2020 09:26:03 -0800 (PST)
Received: from [192.168.178.40] ([151.20.135.128])
        by smtp.gmail.com with ESMTPSA id q124sm10395988wme.2.2020.02.21.09.26.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 09:26:02 -0800 (PST)
Subject: Re: [PATCH 01/10] KVM: VMX: Use vpid_sync_context() directly when
 possible
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200220204356.8837-1-sean.j.christopherson@intel.com>
 <20200220204356.8837-2-sean.j.christopherson@intel.com>
 <878skwt6yt.fsf@vitty.brq.redhat.com>
 <20200221153619.GE12665@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <24835177-ecab-8b84-d31b-e6f93df544ef@redhat.com>
Date:   Fri, 21 Feb 2020 18:26:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200221153619.GE12665@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/02/20 16:36, Sean Christopherson wrote:
>>>  				vmx->nested.last_vpid = vmcs12->virtual_processor_id;
>>> -				__vmx_flush_tlb(vcpu, nested_get_vpid02(vcpu), false);
>>> +				vpid_sync_context(nested_get_vpid02(vcpu));
>>>  			}
>>>  		} else {
>>>  			/*
>>> @@ -5154,17 +5154,17 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
>>>  			__invvpid(VMX_VPID_EXTENT_INDIVIDUAL_ADDR,
>>>  				vpid02, operand.gla);
>>>  		} else
>>> -			__vmx_flush_tlb(vcpu, vpid02, false);
>>> +			vpid_sync_context(vpid02);
>> This is a pre-existing condition but coding style requires braces even
>> for single statements when they were used in another branch.
> I'll fix this in v2.
> 

Can also remove the braces from the "then" branch.

Paolo

