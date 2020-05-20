Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 272551DBFF6
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 22:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgETUOy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 16:14:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21628 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726860AbgETUOx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 16:14:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590005692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TmIeOpvSLXXYOJ6jQiUjdVDS8jI79jLrqdKnHe80e6k=;
        b=RU4s/erRaYX5Z2m/bWJjvPNmsj2frBTkT2mpESzTy6YuCuFjU7Dl5tnYP9gJ/r5q4GbVrz
        3KjaCpG9cwezbdaXczyN86Z6vXZTVG6yp0HjavZZt0uwauzV7IcxPw9Kzs/ImC164pEgVh
        4K5uY+0oEcXiA5D2olUVbDf8PbpQudo=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-PQhL-BdlMbqXNHJSLdZM7A-1; Wed, 20 May 2020 16:14:50 -0400
X-MC-Unique: PQhL-BdlMbqXNHJSLdZM7A-1
Received: by mail-ej1-f71.google.com with SMTP id lk22so1805407ejb.15
        for <kvm@vger.kernel.org>; Wed, 20 May 2020 13:14:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TmIeOpvSLXXYOJ6jQiUjdVDS8jI79jLrqdKnHe80e6k=;
        b=Bpm+l8L6GIvfw9d4COTavWUn3QyuRBmk5agXw83jcHHS09HbiJB8joHwgz55EE9i4S
         m7U3QhPPGFdjGH0pSplOGYp6jonfFfyUpPN+p30GOcBP1Dd9XzI82aG9B7T1mB17vVJH
         37BrOIto2M0vhiIPUS2ohpHuezAtz16T3whOns4lczmQr3Ae6F/5Jj/+NB60e2pWR1hP
         KxYricu2BQtIxcxQPSPqBaF0GYLCS1Gt0Cuhzgt+tfm2PmvduETspk4IvnPc1imKV6BL
         eWvokosxneEcCIkEDWg+XXC3WU5/vxbzB/Jh0+o0pMzpYsaud6TxsEtXfzInVZ+oqhjG
         MJ9g==
X-Gm-Message-State: AOAM533sUM9ENPd/sh0wTXHWCN8GN1OxGOJNekVpb9ksBl2+B1zppgdN
        rV0pBbml2+cfRBIULIqDLggG4OnR+n3Md/9gYYcvDPcRV2phXd597vILiS+6usGJngVge6aAGII
        hm2cLkNhCiIXm
X-Received: by 2002:aa7:d312:: with SMTP id p18mr2277872edq.88.1590005689543;
        Wed, 20 May 2020 13:14:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy9E4xDxfsyPrMh6r2RGpLUE9EPbfiGAvLfUmVbbGop5ohjJ6Ao+kQ7cZJbxuKy3kLG3IUc8A==
X-Received: by 2002:aa7:d312:: with SMTP id p18mr2277856edq.88.1590005689332;
        Wed, 20 May 2020 13:14:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:30f5:232:d7f0:1e71? ([2001:b07:6468:f312:30f5:232:d7f0:1e71])
        by smtp.gmail.com with ESMTPSA id be12sm2584241edb.11.2020.05.20.13.14.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 13:14:48 -0700 (PDT)
Subject: Re: [PATCH 21/24] KVM: x86: always update CR3 in VMCB
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
References: <20200520172145.23284-1-pbonzini@redhat.com>
 <20200520172145.23284-22-pbonzini@redhat.com>
 <20200520182202.GB18102@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d85c2e1d-93b3-186d-7df4-80ae6aa03618@redhat.com>
Date:   Wed, 20 May 2020 22:14:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200520182202.GB18102@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/05/20 20:22, Sean Christopherson wrote:
> As an alternative fix, what about marking VCPU_EXREG_CR3 dirty in
> __set_sregs()?  E.g.
> 
> 		/*
> 		 * Loading vmcs02.GUEST_CR3 is handled by nested VM-Enter, but
> 		 * it can be explicitly dirtied by KVM_SET_SREGS.
> 		 */
> 		if (is_guest_mode(vcpu) &&
> 		    !test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_dirty))
> 
> There's already a dependency on __set_sregs() doing
> kvm_register_mark_available() before kvm_mmu_reset_context(), i.e. the
> code is already a bit kludgy.  The dirty check would make the kludge less
> subtle and provide explicit documentation.

A comment in __set_sregs is certainly a good idea.  But checking for
dirty seems worse since the caching of CR3 is a bit special in this
respect (it's never marked dirty).

This patch should probably be split too, so that the Fixes tags are
separate for Intel and AMD.

Paolo

>>  			guest_cr3 = vcpu->arch.cr3;
> 
> The comment that's just below the context is now stale, e.g. replace
> vmcs01.GUEST_CR3 with vmcs.GUEST_CR3.
> 
>> -- 
>> 2.18.2
>>
>>
> 

