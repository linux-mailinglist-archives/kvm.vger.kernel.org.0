Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76CD22EB5A
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 13:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgG0Lnk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 07:43:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59153 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726873AbgG0Lnk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jul 2020 07:43:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595850218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fj8z1m818DDGkVImIUhwVP/NDjsB0jy0U2cJeVkzmBs=;
        b=NKnA0DG1Fd7Nxo4M24VSPgbosbx6b3y/Wz0YsvhtL2CRwf8Y6l5AXjjgYZIlq4ioNYsyI0
        XSZCXGFJyurglkEN3zzBVvV5HT5Ds5RgVm4U0bvl39c8DjF64Yo5o8uDMqdYyp7WGmjvMh
        A0Ov36Wes8qFNbHHHdVqh7ZhabCR0J8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-qvQQTR5BM1iteKjxG2aXcg-1; Mon, 27 Jul 2020 07:43:36 -0400
X-MC-Unique: qvQQTR5BM1iteKjxG2aXcg-1
Received: by mail-wr1-f72.google.com with SMTP id d6so2276195wrv.23
        for <kvm@vger.kernel.org>; Mon, 27 Jul 2020 04:43:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fj8z1m818DDGkVImIUhwVP/NDjsB0jy0U2cJeVkzmBs=;
        b=nZ2cpGxHnDDbGBVdW8tFHjcd9MHbyt6T+Sx1GRTSb1qfh98f0plzAl7FrfiLRt6ydf
         B65Wpr2YSG1z0Z5mhfMgeKoNekDqgVaPtGO5Dta33tatr3lUWn86Bvy0OB5ZObx6pS+o
         M/15ABq7W8B5Y1ds2OQYFajxYCk21uk658qRtIzThRMadDC81yG+5cfmxFLuZZyG64vc
         QCJJJOitvl+3Pqm21Lfy+SBhba+y6idgpf6e+qyPhkvYP/Bpam7E8NYsjOyXt0DNvUVV
         /wZSMVQwhfFoT3/BJY1SAo6uY2VRyoiNWTKBFwCMItMGkOywKxynKX55NqXlXOM9MVxv
         54gQ==
X-Gm-Message-State: AOAM532LubyGF0/p20nQKBU4NfF+NLFR/4YbNlLaDbqyQ6ZkxucbviGO
        CQeHBw7hbRu+AuFwiAqy68xZrWBa1aryaC9UPPASa5gWSko4EZdoAsw/k6kPMscyM18dsmSm81t
        PxrroQnjr4qlV
X-Received: by 2002:a1c:1f8b:: with SMTP id f133mr7502916wmf.65.1595850215565;
        Mon, 27 Jul 2020 04:43:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxw1DFiLxTBnx0dQkBfP08qqXab6djnIi+darp7HN96pmEh9Ssi7B4w9eJAMu1Apm8wi3pLdA==
X-Received: by 2002:a1c:1f8b:: with SMTP id f133mr7502892wmf.65.1595850215283;
        Mon, 27 Jul 2020 04:43:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4502:3ee3:2bae:c612? ([2001:b07:6468:f312:4502:3ee3:2bae:c612])
        by smtp.gmail.com with ESMTPSA id f17sm19698789wme.14.2020.07.27.04.43.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2020 04:43:34 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: properly pad struct kvm_vmx_nested_state_hdr
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
References: <20200713082824.1728868-1-vkuznets@redhat.com>
 <20200713151750.GA29901@linux.intel.com>
 <878sfntnoz.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <85fd54ff-01f5-0f1f-1bb7-922c740a37c1@redhat.com>
Date:   Mon, 27 Jul 2020 13:43:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <878sfntnoz.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/07/20 17:54, Vitaly Kuznetsov wrote:
> Which means that userspace built for the old kernel will potentially send in
> garbage for the new 'flags' field due to it being uninitialized stack data,
> even with the layout after this patch.

It might as well send it now if the code didn't attempt to zero the
struct before filling it in (this is another good reason to use a
"flags" field to say what's been filled in).  I don't think special
casing padding is particularly useful; C11 for example requires
designated initializers to fill padding with zero bits[1] and even
before it's always been considered good behavior to use memset.

Paolo

[1]  It says: "If an object that has static or thread storage duration
is not initialized explicitly, then [...] any padding is initialized to
zero bits" and even for non-static objects, "If there are fewer
initializers in a brace-enclosed list than there are elements or members
of an aggregate [...] the remainder of the aggregate shall be
initialized implicitly the same as objects that have static storage
duration".

