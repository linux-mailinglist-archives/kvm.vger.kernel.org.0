Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E76A46E785
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 12:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236627AbhLIL00 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 06:26:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235679AbhLIL0Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 06:26:25 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5601AC061746;
        Thu,  9 Dec 2021 03:22:52 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id y13so18324648edd.13;
        Thu, 09 Dec 2021 03:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rBgKd//ugvog+zMB81XepWQ5SSNkSmCsR0N1AvYk8Ck=;
        b=obJasgqNOElxh1Wb5ygC8wWmrj3fiMpQt6Xzm3aN042RWYx58tBVndRV/un2Qw7o5s
         aDeuDKQNOpHiGzKqRdS0GIbHXIaeL6q599egRHhlqjNsrtVSOo2Z+OiuAr2/4ddi5kbH
         VzU7kIKPhRHqJ6jGXfw5jm5sFQV3XByMC7BlKDSo6RZ89j0H2zEDsu83LgIiExuXHjJP
         726/JoPn+zNfyW+494ApYIBEq0p9bmMovvd+sWBtH1pXVmHzyBGf3IhZ9Vv8R6clT18k
         APml5NgJhfJexJ2YnulQ6z96JpSaG1uhLv3OtHBfhOYEXscqsvSNlUkqq5kdclE2O8l9
         9JXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rBgKd//ugvog+zMB81XepWQ5SSNkSmCsR0N1AvYk8Ck=;
        b=Ms+nPmNyvBGUKN7Q3DZ7n6aVJEZaJBb6WsawDNMHae0H1CDcP5rua45Xj/eiTm4Kw5
         OoiO9EkPDhdVFmTf+txDZTWMH9lzjImYb01KNUt8PvQ+2mbU3fX5/TTCYHfQ/skWFJHX
         SaQLWovIEOXVMBnoL3c32dxBDPRh+hNdF/lu1FNw7Pt6Avkx82HAn3rmaGWzhVyTHxpY
         krFVtOtZZgUPBIPJE5DQbT4+DdM7GC91g+ULgoAE5GqNB322YR8Ae9Ql/Qg4iz3nDy9w
         3NfjZibYMh+SzIjx1n3aF26sL/q3Uu6HtfBiHexXCLqI08gncPDSLItHmDLvzRoux798
         nhGw==
X-Gm-Message-State: AOAM531X87i7QAMOtcGT8PAMwDHCWbzCRnANxH1iF8R6eRhKgAYNMOKa
        J2C0E3qZaEtr4ef72g2ZBjE=
X-Google-Smtp-Source: ABdhPJyjheFHR4D4XLt4NDmcxerB9zuiEfrit8/gGLiXAg9UbsRjtlnut0Fl5/P1yG9abeH8mqBBGQ==
X-Received: by 2002:a17:907:3c7:: with SMTP id su7mr15169796ejb.87.1639048970900;
        Thu, 09 Dec 2021 03:22:50 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id jy28sm2641457ejc.118.2021.12.09.03.22.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 03:22:50 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <57c83b62-675f-d368-e09f-7f97d3a7e3fb@redhat.com>
Date:   Thu, 9 Dec 2021 12:22:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 0/2] KVM: x86: Rep string I/O WARN removal and test
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211025201311.1881846-1-seanjc@google.com>
 <YbGYuDgaqcRH/CZo@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YbGYuDgaqcRH/CZo@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/21 06:48, Sean Christopherson wrote:
> On Mon, Oct 25, 2021, Sean Christopherson wrote:
>> Remove a WARN that was added as part of the recent I/O overhaul to play
>> nice with SEV-ES string I/O.
>>
>> For the record, my FIXME in lieu of a WARN was deliberate, as I suspected
>> userspace could trigger a WARN ;-)
>>
>> Based on kvm/master, commit 95e16b4792b0 ("KVM: SEV-ES: go over the
>> sev_pio_data buffer in multiple passes if needed").
>>
>> Sean Christopherson (2):
>>    KVM: x86: Don't WARN if userspace mucks with RCX during string I/O
>>      exit
>>    KVM: selftests: Add test to verify KVM doesn't explode on "bad" I/O
>>
>>   arch/x86/kvm/x86.c                            |   9 +-
>>   tools/testing/selftests/kvm/.gitignore        |   1 +
>>   tools/testing/selftests/kvm/Makefile          |   1 +
>>   .../selftests/kvm/x86_64/userspace_io_test.c  | 114 ++++++++++++++++++
>>   4 files changed, 123 insertions(+), 2 deletions(-)
>>   create mode 100644 tools/testing/selftests/kvm/x86_64/userspace_io_test.c
> 
> Ping.  I completely forgot about this too, until I unintentionally ran a
> userspace_io_test that was lying around.
> 

Queued now, thanks.  I don't know if I want the honor of having KVM 
singled out again on the -rc release message, but these are bugs 
nevertheless...

Paolo
