Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A46716297A
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 16:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgBRPdx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 10:33:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36749 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726373AbgBRPdx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 10:33:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582040032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wcuVY7kYjAiaGruZIaqVS5hTIYdIF7Sz5fz0+avlUjQ=;
        b=Ri5sOXsGRyRK/7FqdXfQmvIrJw97vAMlNVjb6kds5BIer1OJFUFl4X76iAdhkVgEkVfm2n
        sZlW9PNE3y5215lJ7W1GZDASoi6nR65gMLr4ooa+guhPrqr6bSXqUkmmWQhstDi/W9JCee
        b6r07TKAGES8fjZ267Ev1yFtT1dyC9A=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-y6DkTAIGOIakpFM82Bfs2w-1; Tue, 18 Feb 2020 10:33:48 -0500
X-MC-Unique: y6DkTAIGOIakpFM82Bfs2w-1
Received: by mail-wr1-f70.google.com with SMTP id s13so10934129wru.7
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2020 07:33:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wcuVY7kYjAiaGruZIaqVS5hTIYdIF7Sz5fz0+avlUjQ=;
        b=tYVTvFTHX0+2ORIt7yUNMIVgQPfqwiRoY4KIKu/n+oSFc9lIX7hCTQsvzhmfOq/RJC
         v9vd7ua0Cfu1IxluexLwR15aTZtvppbCD3eR1jyvFWwGoz38cgz2NYNa0WZrVXS/3XGX
         URf4kxYbh6xfAuTx4MDR0mvSjzFAtV8q04oTIKUnUJ/luUwBYzXmb97864O8pEgi4Yqr
         mZQtGOVlI76OxDaQahD2dI2Mo4GmF8wNmb/m9ujzQXPTS9h6S2uOIGGM2/mQqRc47asd
         /COs4CDAfd/k0YemrIK86lL+eZSNiNtqwUOFLK/A7mcHPzyPWVFHPD0Po/G2igjQZTYP
         VIkQ==
X-Gm-Message-State: APjAAAVRccQCGvDf9BVCmMWhrRJgZC3zgzHM+FandwHEpxhd5zxMR8rK
        /oFAgKV9Ot8NUz5yhJlaoL1wJsnmvnpayj9Vu1T2MK81KC4HR0CR/OkeObsSOpZ/mYSa0xfPZ8t
        3DvMP22Zcfb0P
X-Received: by 2002:adf:dc8d:: with SMTP id r13mr30717634wrj.357.1582040027401;
        Tue, 18 Feb 2020 07:33:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqw9u1DnkOPCdRW6cVeA5bmWDKs4XoNSD+yppiDGAQJFcUF0rXlT8L1PPZOthPVch2bV7Rhidg==
X-Received: by 2002:adf:dc8d:: with SMTP id r13mr30717607wrj.357.1582040027200;
        Tue, 18 Feb 2020 07:33:47 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:59c7:c3ee:2dec:d2b4? ([2001:b07:6468:f312:59c7:c3ee:2dec:d2b4])
        by smtp.gmail.com with ESMTPSA id c15sm6405828wrt.1.2020.02.18.07.33.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 07:33:46 -0800 (PST)
Subject: Re: [PATCH v4 1/2] KVM: X86: Less kvmclock sync induced vmexits after
 VM boots
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <1581988630-19182-1-git-send-email-wanpengli@tencent.com>
 <87r1ys7xpk.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e6caee13-f8f7-596c-fb37-6120e7c25f99@redhat.com>
Date:   Tue, 18 Feb 2020 16:33:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <87r1ys7xpk.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/02/20 15:54, Vitaly Kuznetsov wrote:
>> -	schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
>> -					KVMCLOCK_SYNC_PERIOD);
>> +	if (vcpu->vcpu_idx == 0)
>> +		schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
>> +						KVMCLOCK_SYNC_PERIOD);
>>  }
>>  
>>  void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
> Forgive me my ignorance, I was under the impression
> schedule_delayed_work() doesn't do anything if the work is already
> queued (see queue_delayed_work_on()) and we seem to be scheduling the
> same work (&kvm->arch.kvmclock_sync_work) which is per-kvm (not
> per-vcpu).

No, it executes after 5 minutes.  I agree that the patch shouldn't be
really necessary, though you do save on cacheline bouncing due to
test_and_set_bit.

Paolo

> Do we actually happen to finish executing it before next vCPU
> is created or why does the storm you describe happens?

