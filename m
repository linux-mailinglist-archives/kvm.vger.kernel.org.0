Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5771EC0C98
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 22:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbfI0UYl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 16:24:41 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41189 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbfI0UYl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 16:24:41 -0400
Received: by mail-pf1-f193.google.com with SMTP id q7so2181831pfh.8
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 13:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=av8uQTzC5kAZ04adK2jUzugM4hsPl2jUpES0RTtperI=;
        b=fOt4rEu6WT8wmVxdYRnJ5ZS/3wY9TTML1Y6MVTtId1t6nLAYoWvXz6fmKAFPqs+mKo
         ZA3BjyNtKIj11n5uTvytcNvyA7XeEokpO/MzutnuoG5QJI1kWN1/YwV4twGddY3JDHDu
         RzKU8tvzIixQ23Is9KezC3Lc3CVs9C3ZELa9UeAF8y7CB6srtOXhCV0RWf7zyF7Mo2iI
         68qI11EL5VsmZ5SuQH9uB/MaD6PRt6Tuek+8zTVk7TSNNAtALCggtOy3zC4cydScB+PM
         O/8YmwGUfZYeGNowVOONCOp8Zj6UB2RiJ93SDjb3jh6vVTFsLmYK4I6QBsc0cXxPvqC8
         lI/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=av8uQTzC5kAZ04adK2jUzugM4hsPl2jUpES0RTtperI=;
        b=FLCWvWw03rU34bj6wpEWmjwcjH4mVo0G/GzW+tBD0hhOYt0uHFs5g6Rz/A3W793B+h
         FGgHm7dNuSWO3MjFf5dmsrEqnc9rJkyFiZJX8uREWKvnL9vGs/QAZOUYpxBtilpiOk+z
         IjXCwJEFwhKI0KCGClG2uIYsz4vQZ2eGbOOJOeHfqXR4SqS0jdby/ahoboV/zJn2PuQy
         Bbmf5t+2EovrgxFj/lPCWbZE/GPMMDqu3TONL99JZh+ZO6o40B9sxXw8lbmmnIIYklLF
         ByjouhFNESQKbBoOSQF16Z07b1dC6XSfpxhtKas7ipM+CKRKUSz4RG3xpDRlereQp8Go
         UywA==
X-Gm-Message-State: APjAAAX6poQZ++QTDs1SUuEci2aqDMt7DfPGkK9bh6gdCnnFlv50IibC
        4YsiQRSn7gJFXXgHsFdGTvZevQ==
X-Google-Smtp-Source: APXvYqwJQvt389v7itLWsRH7wK5uJv4VwzElBVKJOw/6JIjr8ATfdDL8RmFn0F1a0Swpg/916AirEg==
X-Received: by 2002:a17:90a:80c9:: with SMTP id k9mr11914360pjw.68.1569615879390;
        Fri, 27 Sep 2019 13:24:39 -0700 (PDT)
Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:2:5e41:bb1f:98fb:39da])
        by smtp.gmail.com with ESMTPSA id d1sm3421894pfc.98.2019.09.27.13.24.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Sep 2019 13:24:38 -0700 (PDT)
Subject: Re: [PATCH v2 2/3] KVM: x86: fix nested guest live migration with PML
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <1569582943-13476-1-git-send-email-pbonzini@redhat.com>
 <1569582943-13476-3-git-send-email-pbonzini@redhat.com>
From:   Junaid Shahid <junaids@google.com>
Openpgp: preference=signencrypt
Autocrypt: addr=junaids@google.com; keydata=
 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
 iWogGkOc4UGfcj87Lt9ivHEsVoo/lwCTIiQ=
Organization: Google
Message-ID: <0b6701ed-8eac-1f52-8fdd-c06d2289ce11@google.com>
Date:   Fri, 27 Sep 2019 13:24:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1569582943-13476-3-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/27/19 4:15 AM, Paolo Bonzini wrote:
> Shadow paging is fundamentally incompatible with the page-modification
> log, because the GPAs in the log come from the wrong memory map.
> In particular, for the EPT page-modification log, the GPAs in the log come
> from L2 rather than L1.  (If there was a non-EPT page-modification log,
> we couldn't use it for shadow paging because it would log GVAs rather
> than GPAs).
> 
> Therefore, we need to rely on write protection to record dirty pages.
> This has the side effect of bypassing PML, since writes now result in an
> EPT violation vmexit.
> 
> This is relatively easy to add to KVM, because pretty much the only place
> that needs changing is spte_clear_dirty.  The first access to the page
> already goes through the page fault path and records the correct GPA;
> it's only subsequent accesses that are wrong.  Therefore, we can equip
> set_spte (where the first access happens) to record that the SPTE will
> have to be write protected, and then spte_clear_dirty will use this
> information to do the right thing.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Junaid Shahid <junaids@google.com>
