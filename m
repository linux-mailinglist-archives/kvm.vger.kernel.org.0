Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9143A38B9A
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 15:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbfFGN06 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 09:26:58 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40526 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727840AbfFGN06 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 09:26:58 -0400
Received: by mail-wr1-f67.google.com with SMTP id p11so2170696wre.7
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2019 06:26:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2dMz2NJ/7HO6pFLN6dEl0ihvGkE/MfsGYJHU5qf6pcc=;
        b=HsmPaxUmoO/ScGfNlpbcTL/78yTz+nI0+oZ7eKBRAtM80dA0rym72NT2vIhCu9Wmzo
         aBEf4Pa80tXPNXH6E8R6JkIUNqk/KJR2FQlVpsL13r1S96DhwQsPRi0qDeeR659bs+F8
         KPiMziQ9aEd7MvurmZjN/eVrUlJgISwStbBIo8gS577HoLp9+Vng3CDomBKXrf2NS5PD
         WKq0BSnxqRBeXtCGIBFU0E4t3dzb2Ia13ev+vuwi6EXg2lhWp64tI2FFxUumLrvPUaPI
         ryC4lZIFMSLMCYw4wX988LbKJqm8aXCU40eBMlMn7ykfuPjHCYwUb2vtEEK6UpqaZzlU
         vTdw==
X-Gm-Message-State: APjAAAVEQ7dhgjxu3oIpsLBCT7fuQ+veQ6prId8yaScNDJgpHfDnTxvg
        myhXx706yS1tXaiWZmE2CM7ifLyNHsE=
X-Google-Smtp-Source: APXvYqyWsYP+u61zsBEW+/bXpBQssLN1eO6muKxhEd7Gk22HQJ/Eh8582yPTBVzkyPBCUD1EhvnYgQ==
X-Received: by 2002:adf:ea92:: with SMTP id s18mr11067722wrm.257.1559914016783;
        Fri, 07 Jun 2019 06:26:56 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id j123sm2332089wmb.32.2019.06.07.06.26.54
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 06:26:56 -0700 (PDT)
Subject: Re: [PATCH 2/2] Revert "KVM: nVMX: always use early vmcs check when
 EPT is disabled"
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
References: <20190520201029.7126-1-sean.j.christopherson@intel.com>
 <20190520201029.7126-3-sean.j.christopherson@intel.com>
 <40c7c3ee-9c49-1df6-c80b-1bc7811ccf69@redhat.com>
 <20190606170837.GC23169@linux.intel.com>
 <eea2b956-2c58-ad2d-7b47-45858c887c03@redhat.com>
 <20190606174939.GF23169@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <53423366-f839-9225-2016-dfa36d82da08@redhat.com>
Date:   Fri, 7 Jun 2019 15:26:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190606174939.GF23169@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/06/19 19:49, Sean Christopherson wrote:
> On Thu, Jun 06, 2019 at 07:31:13PM +0200, Paolo Bonzini wrote:
>> On 06/06/19 19:08, Sean Christopherson wrote:
>>>> This hunk needs to be moved to patch 1, which then becomes much easier
>>>> to understand...
>>> I kept the revert in a separate patch so that the bug fix could be
>>> easily backported to stable branches (commit 2b27924bb1d4 ("KVM: nVMX:
>>> always use early vmcs check when EPT is disabled" wasn't tagged for
>>> stable).
>>>
>>
>> Yeah, I didn't mark it because of the mess involving the vmx.c split
>> (basically wait and see if someone report it).  There was quite some
>> churn so I am a bit wary to do stable backports where I haven't
>> explicitly tested the backport on the oldest affected version.
> 
> Do you want me to send a v2 as a single patch?  If so, presumably without
> cc'ing stable?

Yes, please do, adding in the comment as well.

Paolo

