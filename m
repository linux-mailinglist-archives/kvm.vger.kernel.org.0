Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293A0275E8F
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 19:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgIWRZz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 13:25:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55391 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726515AbgIWRZz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Sep 2020 13:25:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600881953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZuD3/+M0e5AmZWztkEsIZId0b+68cZomfjMUlFnHeY8=;
        b=hHtdF6nVpT2ufolriYD0zTO/IRLhGGFvcsLSH50Afmh+/1+SJgFGH4Y3LbksZcImSVmF18
        zpSVKFJf2EeS6SmqM7NgVUJCuw6Z3eCK4HnlSG3ncxld7Mp6qUxligDrZK2HJmw/T7msXx
        1mwbBGBeCvkDKjdE5kB/F/aqZdlxx6o=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-qo5gZZHXO8Gv1by5W8QCSg-1; Wed, 23 Sep 2020 13:25:51 -0400
X-MC-Unique: qo5gZZHXO8Gv1by5W8QCSg-1
Received: by mail-wm1-f71.google.com with SMTP id u5so190541wme.3
        for <kvm@vger.kernel.org>; Wed, 23 Sep 2020 10:25:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZuD3/+M0e5AmZWztkEsIZId0b+68cZomfjMUlFnHeY8=;
        b=nYupVvciN3LySLjMKJ84ZEWsE9MKLitAjgRsO2+/GlK+WnGfHVeh+uxhyWfg+F3gBF
         pNyV+zr4iqSpEEp6eB0b2ngTL5cMzCAfrFuz3UridsRHK0d7i5SUVC9eTZ+D8A1HF0Df
         WLH4tvT23GPN2Ui7C0a+chtq1yy+pZ3Cek8026OmrEOwWvrsuXwHNS/4N3f9/3xNPbdy
         HibgWUGWQ2IaD6nijaWADZlfXp1FHxzR/4S5sNp+gMPZBc1w3pTWwY77PmJyS0L/i1Z+
         4/f5Wn8Ai6/itXN69PM5rf9y+lfzlXWdCoVfcNukplKp66W5oKJO5d7MOaV0oeXA1ZFh
         ATPQ==
X-Gm-Message-State: AOAM530gNit7qlqiln63uVSWFNnr6bTAcgFRvY6mj9R9UrMtrXXi4BfC
        F20y0UiDylLTbct4nQUCWucR9a1LiPfTlqdzxoDCUVxk/pjei78Ruma9Vg0C/XvE3y8QihrqroF
        wXxWcS666fF68
X-Received: by 2002:adf:c188:: with SMTP id x8mr768742wre.201.1600881950496;
        Wed, 23 Sep 2020 10:25:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJweA4UIVDqrBa8klaAhnYfCz2jzaYiNy5uleWDnL5Yjd+2tBftjci1mcBnYVbOtL3Z1QEI1qg==
X-Received: by 2002:adf:c188:: with SMTP id x8mr768727wre.201.1600881950299;
        Wed, 23 Sep 2020 10:25:50 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:15f1:648d:7de6:bad9? ([2001:b07:6468:f312:15f1:648d:7de6:bad9])
        by smtp.gmail.com with ESMTPSA id o4sm436030wrv.86.2020.09.23.10.25.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 10:25:49 -0700 (PDT)
Subject: Re: [PATCH 4/4] KVM: VMX: Add a helper and macros to reduce
 boilerplate for sec exec ctls
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200923165048.20486-1-sean.j.christopherson@intel.com>
 <20200923165048.20486-5-sean.j.christopherson@intel.com>
 <784480fd-3aeb-6c08-30f9-ac474bb23b6c@redhat.com>
 <20200923172237.GA32044@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7d7daea0-57be-83be-a0d4-8a481249ef85@redhat.com>
Date:   Wed, 23 Sep 2020 19:25:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200923172237.GA32044@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/20 19:22, Sean Christopherson wrote:
> On Wed, Sep 23, 2020 at 07:20:17PM +0200, Paolo Bonzini wrote:
>> On 23/09/20 18:50, Sean Christopherson wrote:
>>> Add a helper function and several wrapping macros to consolidate the
>>> copy-paste code in vmx_compute_secondary_exec_control() for adjusting
>>> controls that are dependent on guest CPUID bits.
>>>
>>> No functional change intended.
>>>
>>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>>> ---
>>>  arch/x86/kvm/vmx/vmx.c | 128 +++++++++++++----------------------------
>>>  1 file changed, 41 insertions(+), 87 deletions(-)
>>
>> The diffstat is enticing but the code a little less so...  Can you just
>> add documentation above vmx_adjust_secondary_exec_control that explains
>> the how/why?
> 
> Ya, I'd be more than happy to add a big comment.
> 

Ok, I'll wait for v2 of this patch only.

Paolo

