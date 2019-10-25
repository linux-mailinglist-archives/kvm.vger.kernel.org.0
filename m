Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50A93E47A0
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 11:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438883AbfJYJn5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 05:43:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33820 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436857AbfJYJn4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 05:43:56 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 521525AFDE
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 09:43:56 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id k10so726536wrl.22
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 02:43:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tQMby8CZSJniqh4uopuVoL0d2iSgxdS4fKi9gs56q5c=;
        b=t7Ix+jJd9c6VTDjj/LZkxu+qk/+nXBdU4cFIVSUv6BRfvCBeK+74mJGV3H6OiOHOqV
         x+soHBzUg5yRtZ1TvMHJXzK+d0OUzvUCiR6jUb3uW7bPoTvLoaugiLHN0x/1i3SQHYBk
         g1xvTmkF7ah2PDCHAyTbtn4Si0DDuhImTSyJR2rxOagaGpwc8U6ymP8UGt2obFrJ4sVx
         TnO9LbJjlWxnNCaolNYDd94fEEMApcDXJcsT5xCjyfExsK/+tm7ZMoOlYUUNr0I/rDGJ
         soSkM+vURdfVdcjLJGCmGQz3HQz6g4jOAm3ANXxhRTij5nglHKo/lQahKxie0T5NFGYb
         QuXg==
X-Gm-Message-State: APjAAAVQN9Vszy8AIGlpfjt/DcSiTWwevzmTezMOjw5k575U3ZbB2x9M
        CU7BlC9pJJKHa8ZYlb+LKXCmnFSBFbscQWSAh1wOkMBuMvuQwIwjFh18A0YuadjvvivQ3xxx9fa
        l8LQagtVL0QRV
X-Received: by 2002:a1c:7e57:: with SMTP id z84mr2736422wmc.84.1571996634784;
        Fri, 25 Oct 2019 02:43:54 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy4P0x3HWNFBaL87i3kllo1EHrbNDatuCnfoVLYIXHeIIElpykyGmW+yCU7P+vw8tejmbzgmw==
X-Received: by 2002:a1c:7e57:: with SMTP id z84mr2736400wmc.84.1571996634474;
        Fri, 25 Oct 2019 02:43:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:302c:998e:a769:c583? ([2001:b07:6468:f312:302c:998e:a769:c583])
        by smtp.gmail.com with ESMTPSA id u1sm1850401wru.90.2019.10.25.02.43.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Oct 2019 02:43:54 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: get rid of odd out jump label in pdptrs_changed
To:     Miaohe Lin <linmiaohe@huawei.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1571968878-10437-1-git-send-email-linmiaohe@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ecd5eb9a-938b-a8f3-ed69-76d2343bfdcc@redhat.com>
Date:   Fri, 25 Oct 2019 11:43:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1571968878-10437-1-git-send-email-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/10/19 04:01, Miaohe Lin wrote:
> -	if (r < 0)
> -		goto out;
> -	changed = memcmp(pdpte, vcpu->arch.walk_mmu->pdptrs, sizeof(pdpte)) != 0;
> -out:
> +	if (r >= 0)
> +		changed = memcmp(pdpte, vcpu->arch.walk_mmu->pdptrs,
> +				 sizeof(pdpte)) != 0;
>  
>  	return changed;

Even better:

	if (r < 0)
		return true;

	return memcmp(...) != 0;

Paolo
