Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03945E288D
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 04:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437257AbfJXC7t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 22:59:49 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44995 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437254AbfJXC7s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Oct 2019 22:59:48 -0400
Received: by mail-pg1-f195.google.com with SMTP id e10so13297582pgd.11
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2019 19:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=LE8w3pyqU76DAP4xR30uHDtqfromXDndAwO/Vc6n+9M=;
        b=eJ56Z4bMFkhzFkEVn5DSfxhKW29W/fl6Oug1lV2wIrgXSPyvydna/XC16gsBwt2JAl
         BO6oCWqr45zOHjchit4DLTscLqLTr7ZOq4ws7nvoFJQ0fvrYprNGyO0gRIsKccoFGxRp
         adUU0PXusJJWNRMGTLkSi/ZSvjgh0IcuJhL6pzkrTMIBamM8SPIUoh3C8szRWVFJIUef
         US6W05gGKXX6UahVtRd9aVwB//O3ZmrBU/QeY+UOi2IslXFINZwQDWhzY9myNQ1Sa0nb
         EhRu92H4P2pnTOywNdf7HNx+sEeEqhzKyjGUyvK+lgbU5bnmR0vI20vfKo5WiZOBM7nO
         3bCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=LE8w3pyqU76DAP4xR30uHDtqfromXDndAwO/Vc6n+9M=;
        b=VCxtp6HN2GhCtxryq3/qLn/Ttg+YR6s5wX2IqNWYUDEEhoIccjVICPSjYYOJaprIqJ
         aW2FGLeUVxPesPJyPTwakAHZOnNWUYQldUw4rGkoFADCl6WM+r5wvqGCxCzIiVZyNZkK
         W3H2OaJkFDfbpWj5jMqQxzYFThggeKOVMgy28lnEkCN1XJHY1n0lZPqXHY7Ua1pZr48J
         Z/IAhvKSYRhvMmCDjND+7Vsos2khkjeI2Ua6V6bO8gcEk7A6U2LVCodpwYLvmPlw41o4
         E9fWkQROzVzZaVOocBUexqVDFgXR4ZxFp28JuvCqLZAco6lh+WkwexDOCM8vEa0QUhe/
         ma3w==
X-Gm-Message-State: APjAAAWq3ORLUf33efR0ZNGXzOBp6Mhb3tpqYx3jcQDpVgv4MqCccqEt
        iRb0XqGbL/JoO1EaTb259cQsIg==
X-Google-Smtp-Source: APXvYqwBAmS/zLcoeEDNWpOGhC/vif7EYFe1pdIGjQrQtkI+jETrQ52qT9mBstVKXyJLwRsW192rig==
X-Received: by 2002:a65:498a:: with SMTP id r10mr14120372pgs.131.1571885987541;
        Wed, 23 Oct 2019 19:59:47 -0700 (PDT)
Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:2:5e41:bb1f:98fb:39da])
        by smtp.gmail.com with ESMTPSA id y17sm35657186pfo.171.2019.10.23.19.59.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Oct 2019 19:59:46 -0700 (PDT)
Subject: Re: [PATCH] kvm: call kvm_arch_destroy_vm if vm creation fails
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        John Sperbeck <jsperbeck@google.com>
References: <20191023171435.46287-1-jmattson@google.com>
 <20191023182106.GB26295@linux.intel.com>
From:   Junaid Shahid <junaids@google.com>
Openpgp: preference=signencrypt
Autocrypt: addr=junaids@google.com; keydata=
 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
 iWogGkOc4UGfcj87Lt9ivHEsVoo/lwCTIiQ=
Organization: Google
Message-ID: <7e1fe902-65e3-5381-1ac8-b280f39a677d@google.com>
Date:   Wed, 23 Oct 2019 19:59:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191023182106.GB26295@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/23/19 11:21 AM, Sean Christopherson wrote:
>>  out_err_no_disable:
>>  	refcount_set(&kvm->users_count, 0);
>> +	kvm_arch_destroy_vm(kvm);
> 
> Calling destroy_vm() after zeroing the refcount could lead to a refcount
> underrun (and a WARN with CONFIG_REFCOUNT_FULL=y) if an arch were to do
> kvm_put_kvm() in destroy_vm() to pair with a kvm_get_kvm() in create_vm().
> I doubt any arch actually does that, but it's technically possible since
> kvm_arch_create_vm() is called with users_count=1.
> 
> If we wanted to be paranoid, a follow-up patch could change refcount_set()
> to WARN_ON(!refcount_dec_and_dest()), e.g.:
> 
> 	kvm_arch_destroy_vm(kvm);
> 	WARN_ON(!refcount_dec_and_dest(&kvm->users_count));
> 

AFAICT the kvm->users_count is already 0 before kvm_arch_destroy_vm() is called from kvm_destroy_vm() in the normal case. So there really shouldn't be any arch that does a kvm_put_kvm() inside kvm_arch_destroy_vm(). I think it might be better to keep the kvm_arch_destroy_vm() call after the refcount_set() to be consistent with the normal path.
