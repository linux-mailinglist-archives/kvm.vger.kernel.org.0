Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 324F6DED22
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 15:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728764AbfJUNJh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 09:09:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51044 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728081AbfJUNJf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 09:09:35 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0B145C057E9F
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 13:09:35 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id 92so1927403wro.14
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 06:09:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I5TfDqwP3GoBFi7aXPlCU/8+7pDpDx0r2JS4CfEtHxg=;
        b=XVRo95JLfRoVbwdjHNUBNPsLaYSoGBm7jEaLWGUymTBDnsQL3lmEdaXANlTrRWMcpD
         OJTEc+kHGQ7UPZtnDTMjUjVBpj/5gp1eQByVsAOxMr9S1qkYHO58d8oWT6yua7mXw4kH
         MQuQLyUKEujTi3VXqZBfs7rcXz3MvrLCglWkPxjdOeRlX3S79hStWl9VEL6qlx4EPUoP
         iHTwevDU/nOm54AaDI5b5lBtAaQJgzpgWzXNfqCdnYu8AL3iS/k/0bYq7RITvhiJHr++
         e82rRIEr4BywSldSdxX+BTjKLbjP/xVNGWxb23/IDulc7hLAkpv/q7jFtSMdAhCJd7ck
         i0NA==
X-Gm-Message-State: APjAAAVOafv0pXxlXHw0ipL6WNYavll6LXNUOvsjrU0KsYyCJxL608ft
        rP2tX9eb8oE+utKlV6IXdgJ3Fqf1ySbrxDY9n91nC6L1b+614AIZD4SB0Ia1cjZnGWoz/qHI9gd
        oPoNwkFpUZUqZ
X-Received: by 2002:a7b:c4d3:: with SMTP id g19mr6879885wmk.24.1571663373341;
        Mon, 21 Oct 2019 06:09:33 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwdfuBdeAwNUF9K0Edxm6DaLP4wj3yivSMIHRIOq6f468UL6EjyTuW5I6laVCpJfdImZK6ycw==
X-Received: by 2002:a7b:c4d3:: with SMTP id g19mr6879867wmk.24.1571663373087;
        Mon, 21 Oct 2019 06:09:33 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id g5sm12740898wmg.12.2019.10.21.06.09.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 06:09:32 -0700 (PDT)
Subject: Re: [PATCH] KVM: X86: Make fpu allocation a common function
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jim Mattson <jmattson@google.com>
References: <20191014162247.61461-1-xiaoyao.li@intel.com>
 <87y2xn462e.fsf@vitty.brq.redhat.com>
 <d14d22e2-d74c-ed73-b5bb-3ed5eb087deb@redhat.com>
 <6cc430c1-5729-c2d3-df11-3bf1ec1272f8@intel.com>
 <245dcfe2-d167-fdec-a371-506352d3c684@redhat.com>
 <11318bab-a377-bb8c-b881-76331c92f11e@intel.com>
 <10300339-e4cb-57b0-ac2f-474604551df0@redhat.com>
 <20191017160508.GA20903@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <c2e40175-4d17-f2c5-4d92-94cedd5ff49c@redhat.com>
Date:   Mon, 21 Oct 2019 15:09:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191017160508.GA20903@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/10/19 18:05, Sean Christopherson wrote:
> On Wed, Oct 16, 2019 at 11:41:05AM +0200, Paolo Bonzini wrote:
>> On 16/10/19 09:48, Xiaoyao Li wrote:
>>> BTW, could you have a look at the series I sent yesterday to refactor
>>> the vcpu creation flow, which is inspired partly by this issue. Any
>>> comment and suggestion is welcomed since I don't want to waste time on
>>> wrong direction.
>>
>> Yes, that's the series from which I'll take your patch.
> 
> Can you hold off on taking that patch?  I'm pretty sure we can do more
> cleanup in that area, with less code.
> 

Should I hold off on the whole "Refactor vcpu creation flow of x86 arch"
series then?

Paolo
