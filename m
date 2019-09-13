Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C09AB1A77
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 11:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387904AbfIMJHn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 05:07:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22663 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387896AbfIMJHn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 05:07:43 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 65D8A80F7C
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2019 09:07:42 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id s25so408731wmh.1
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2019 02:07:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qe4KPycV+UzlvJmLvwk1EReg91l2Z/bcR8TGK9fZmqA=;
        b=dsvmyw0T+P//woH9YGlzaDhWL9C5P5x3tM3y8pLgwt0Q0cxsakeLp2IM/EnwUS9s38
         gtpiINPSBYqtAgwA0WaYUZHllpQXfi5s7a8PE0A1SeO+7CjNUeoe0oMBe20e6y0N+5Sd
         Qs11NG5P/MLqU20ZCM9Cqod8/b6d2HBgNWHGXJXziDe+Hg6Y0ES6tYKeTjRGYcDvgxb6
         9ScIW8xfCu+X1022UO8MUua7/z7RaHoMIVCGAOhmmMY0sPDWt6lEr7LrMHmNHTewXpnI
         Z6Qxy8s2pLhe06m3zszp4teIxkCnc6c964cEh2CzDIB6j3j97xS6N4Mjo/JfBbn9dTPR
         QQ8A==
X-Gm-Message-State: APjAAAXlCztg49EUCajYz/xvk2vEwRYsb7bcjBzuEfRhv94zBJfX2s+Y
        7A0gbQKz9OJlogbXbuk1X59tm+yVklicC1BlhMdjFwuuO++kcYyTOifK+Xs/kGpZglurrkgoF++
        4WJG+nZCos8ou
X-Received: by 2002:a5d:4146:: with SMTP id c6mr18435474wrq.205.1568365661019;
        Fri, 13 Sep 2019 02:07:41 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxlnaw7Jh/UetuoAl7hxs212HyDNcPxkK6HJqeW3MFDhAjj9O8Pv9sx9Kb1JTnjDquBuPnETw==
X-Received: by 2002:a5d:4146:: with SMTP id c6mr18435449wrq.205.1568365660691;
        Fri, 13 Sep 2019 02:07:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3166:d768:e1a7:aab8? ([2001:b07:6468:f312:3166:d768:e1a7:aab8])
        by smtp.gmail.com with ESMTPSA id n4sm1784880wmd.45.2019.09.13.02.07.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Sep 2019 02:07:40 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: work around leak of uninitialized stack
 contents
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Fuqian Huang <huangfq.daxian@gmail.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20190912041817.23984-1-huangfq.daxian@gmail.com>
 <CALMp9eSL_rDdWmgeWNwuqP_J_yu7x5Gs8DUBpJFdie18NEz=ow@mail.gmail.com>
 <20190912235205.GA6588@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5916292d-a687-5890-6012-054c34cccda7@redhat.com>
Date:   Fri, 13 Sep 2019 11:07:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190912235205.GA6588@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/09/19 01:52, Sean Christopherson wrote:
>>>
>> Perhaps you could also add a comment like the one Paolo added when he
>> made the same change in kvm_read_guest_virt?
>> See commit 353c0956a618 ("KVM: x86: work around leak of uninitialized
>> stack contents (CVE-2019-7222)").
> I have a better hack-a-fix, we can handle the unexpected MMIO using master
> abort semantics, i.e. reads return all ones, writes are dropped.  It's not
> 100% correct as KVM won't handle the case where the address is legit MMIO,
> but it's at least sometimes correct and thus better than a #PF.

That's still hacky though.  I agree with Jim that
KVM_EXIT_INTERNAL_ERROR is basically "math is hard, let's go shopping"
but it's better than making up our own behavior (of either the chipset
or the processor).

I'll add the comment and commit Fuqiang's patch.

Paolo
