Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E7C307BC6
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 18:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbhA1RHA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 12:07:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50638 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232793AbhA1RAH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 12:00:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611853120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G4jD35+hnsHoKaUUBuRwrYC+j4SclCwEjlq41Rscm40=;
        b=LLz4o0N4Ekh9OFu05q3MAzzlmCAFZ6g7SdkzxVNzXp8dNJcHYNZqwzF6v9TErwGBcJuEDo
        0B2IOpRIffL5lV56s+ETt8rB2aWKwZj+Vh4XaC5nrP+kV1GBEwBiBqC81cCTUOvlS77Rd3
        LuEdWTqjR7pF9gHQ/t3pt6gHv5IoG0E=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-i8egr1pCNSGDb_YAPUhgpA-1; Thu, 28 Jan 2021 11:58:39 -0500
X-MC-Unique: i8egr1pCNSGDb_YAPUhgpA-1
Received: by mail-ed1-f70.google.com with SMTP id j12so3461532edq.10
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 08:58:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G4jD35+hnsHoKaUUBuRwrYC+j4SclCwEjlq41Rscm40=;
        b=tG8Fly8qe95p4XsPfXw+je/GQBn2PUeGTm1mFelikWG42h76NdBb5vpIuqJr/WMkdQ
         VYX4PqJk+t6HF3qhu/0+HsZwTs6yQH9JezgnUce1cLnyfBDbD2LAv9rmqWloq7uW/JfI
         2ZqbRmj+CYDnrdwSG1oFYSks3wXQg5mNOzDUysz1LF9IWSNKcXm3eElIp0k/m8m/+NiI
         oB4A+ea1rWzsmV/xryLTj+3jqXTchzAyKczgWaxb5WM4Py+oba4+aUde6bbW3AFrpBZM
         SeCU78uf8RqMTcNcs9TAZ43PDefwkR9LsMi6SZVY19idd6lwIdUQF12SBZ0hnTL/qmCy
         f41g==
X-Gm-Message-State: AOAM533xGWSEsWiblTMvTcsvBx8/Na1bhClWKuXHt6D7lqQZBwF4r3Fd
        /Pald1sSWRmb00wFDXdF/xlLkF7JySqs+U59bak8SBnIuJZLstGotN3KQha5qRHOfcSHWEclwWz
        egb5OLR5PYSEz
X-Received: by 2002:a05:6402:8cd:: with SMTP id d13mr454887edz.335.1611853118216;
        Thu, 28 Jan 2021 08:58:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxTK53nJc/ZY8iLKLipDuvrqQk2AjWPBAuKb4t05OqdYgsJkRnBxTT/6kwaD0JSzhxEpTkwfg==
X-Received: by 2002:a05:6402:8cd:: with SMTP id d13mr454864edz.335.1611853118068;
        Thu, 28 Jan 2021 08:58:38 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id bo12sm2496665ejb.93.2021.01.28.08.58.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 08:58:37 -0800 (PST)
Subject: Re: [PATCH v2 11/15] KVM: x86: hyper-v: Prepare to meet unallocated
 Hyper-V context
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
References: <20210126134816.1880136-1-vkuznets@redhat.com>
 <20210126134816.1880136-12-vkuznets@redhat.com>
 <fe1bb68d-96a0-cbb3-967a-8576c3533cf6@redhat.com>
 <87y2gd140a.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f2255ad5-1109-44e3-a8f4-be0ac836a8bb@redhat.com>
Date:   Thu, 28 Jan 2021 17:58:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <87y2gd140a.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/01/21 16:21, Vitaly Kuznetsov wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
> 
>> On 26/01/21 14:48, Vitaly Kuznetsov wrote:
>>>
>>> +static inline u32 to_hv_vpindex(struct kvm_vcpu *vcpu)
>>> +{
>>> +	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
>>> +
>>> +	return hv_vcpu ? hv_vcpu->vp_index : kvm_vcpu_get_idx(vcpu);
>>> +}
>>> +
>>
>> I'd rather restrict to_* names for pointer conversions.
>> kvm_hv_get_vpindex is a better choice here.
> 
> No objections, feel free to rename. Alternatively, I can send a
> follow-up patch.

Ok, will do.

Paolo

