Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F350021890A
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 15:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729607AbgGHNaT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 09:30:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49296 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728148AbgGHNaS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 09:30:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594215017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a08tCz9a1g45saZxljOnL0qxpDHyPSBjoSq9y4YxEWM=;
        b=Uf2kJMOYavwgANMqpsbsqZ4Mh1PqU0A1vL1pFrtFlgXSLcaUHbxrSkYB8RjuSVTUUb4T1M
        Ev40Qvd3xj1aFfF/vtCAd90V/p6aa/Y9gQbm0BlizBXhnAbRjPnG9LcnYM+mmBTlkV/hni
        5snHGyr6wBQCGfqI25BMGdg95E8GJ38=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-kbWR9lbZOOiiRN-0meMcEQ-1; Wed, 08 Jul 2020 09:30:15 -0400
X-MC-Unique: kbWR9lbZOOiiRN-0meMcEQ-1
Received: by mail-wr1-f70.google.com with SMTP id v3so22351911wrq.10
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 06:30:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a08tCz9a1g45saZxljOnL0qxpDHyPSBjoSq9y4YxEWM=;
        b=RDIpQvFPBiCExKQHDT3WmEg9OVgLSXzs0PcM3hShT7ZfixGhfmOdB8UiQoQdspX8sl
         ttuZ0OW6BBMxITM+DSG1bfRUYdH4TJQA5TI/z6tYzR3sujKkI+fiYdzZrngB7A/pZenz
         EAcWV3tRftMRWvE1ePb3wldG2s3R1ouGEpB94GDHw78jxSdiyVT0+Dif5f8Eyf3Q4pq2
         MGNzeuloy9Rdas8wOamJEQmO8l61Xvbt8StNul8tcTWaiPDzz/Mw//+3kIN0tOOgulNU
         Ml3uApMM7HxSnqGwtiiDFocVAhXWSf7v2gPaO8j1roPGa4PFRptLU3ycySoYDuO8G/yr
         9YGA==
X-Gm-Message-State: AOAM531iGyBYe6fkEGVlhmvLgCW8sJdedU+nZgaXdN8SAetAf1JqTFYU
        AhXlj5QAEBB7OofXsj+N6znFcc75v/FPEtkeHAcG54hMx0lzfOW4f0oBkP7E7NTPoPbaOiLAGk1
        +CSHoORuQZWnY
X-Received: by 2002:adf:ff8d:: with SMTP id j13mr56984370wrr.11.1594215014789;
        Wed, 08 Jul 2020 06:30:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy2jwWB+l1X8VbjFRDf1YAE71QxQJDyFYFq4dReBrjCyTz5nBbkC7IeqeRu5cmIiqtwLk5JWA==
X-Received: by 2002:adf:ff8d:: with SMTP id j13mr56984349wrr.11.1594215014525;
        Wed, 08 Jul 2020 06:30:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id e23sm5715619wme.35.2020.07.08.06.30.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 06:30:13 -0700 (PDT)
Subject: Re: [PATCH v3 4/8] KVM: X86: Split kvm_update_cpuid()
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20200708065054.19713-1-xiaoyao.li@intel.com>
 <20200708065054.19713-5-xiaoyao.li@intel.com>
 <ad349b28-bc62-e478-c610-e829974a8342@redhat.com>
 <92184f05-ca27-268c-ea72-f939fb1a0ab2@intel.com>
 <4123eb60-d89a-9112-dd7e-1a7627a0fc70@redhat.com>
 <0c0084cb-92c0-23fe-dc5a-441e4b04742c@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <50a4b50e-0143-06dd-c75d-b76f1bbbe5ba@redhat.com>
Date:   Wed, 8 Jul 2020 15:30:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <0c0084cb-92c0-23fe-dc5a-441e4b04742c@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/07/20 15:27, Xiaoyao Li wrote:
>>
> 
> I'm ok with kvm_vcpu_after_set_cpuid().
> 
> BTW there is an unknown for me regarding enter_smm(). Currently, it
> calls kvm_update_cpuid(). I'm not sure which part it really needs,
> update CPUID or update vcpu state based on CPUID?

It needs to update CPUID because it affects CR4.OSXSAVE among others.

Paolo

