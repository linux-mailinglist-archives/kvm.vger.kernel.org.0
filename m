Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E49C1BB89C
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 10:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbgD1IOY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 04:14:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42101 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726377AbgD1IOY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 04:14:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588061663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oPW61kBz1I0R0EHokW8Sa4UdTA6e6gKbGRUXp8tLgek=;
        b=FO6Atm6hoMlT9UnOz9yla0rAsRW1iBDZxC34Z1AxtCtydLFcEpltPJipJkMtE4gxCvDu/E
        RtsZlacrTp2cfy/h1s6TkloiK4GzCacfigUy4pcDPY84h1VK/Gt9dvP4nh2KrWR1Yvo7C8
        z+645NsEl3gi8V5VAyCD/jm02Sf73x8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-lgQZ13jBMKWOSS0XCV29gA-1; Tue, 28 Apr 2020 04:14:21 -0400
X-MC-Unique: lgQZ13jBMKWOSS0XCV29gA-1
Received: by mail-wr1-f70.google.com with SMTP id g7so11890028wrw.18
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 01:14:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oPW61kBz1I0R0EHokW8Sa4UdTA6e6gKbGRUXp8tLgek=;
        b=We6ubgapV2E6YUjaZYFxfdoIoxU2Obe6f72rWqlkxXGKcvYEQs50ZKeQ+YGE8g8KrB
         l/tPUpqLOOuiBKEUQ7S5UcfyQbf8506z6IitP2YQJMQODNiJ6Za90aaAyqmEfPo0sQEF
         ZGsYcp0b+M2oDPKRrUCwurUhUtmUgfuQyfg0UP8dsJjifgQcN0q660JF0iUv08lvJwNM
         Yavx8vvVw5h0oEoquGro6pfS+xMsTfz/CaJNbeTQPLG6+HMXyPaJ8Oc/qOjJagfdUJ1k
         rQ4CNjupQNQ9igQyDFo6AEXKyRqZJIPXy3S8fL0mcIyl1DyEiBBdPokMRdKumJnhI3Qg
         txOw==
X-Gm-Message-State: AGi0PuZTtPhSlHzjnPAShto3Stm67TZkjJS5tBaTw0KNDVW9l5H5HcQj
        XHLsZgHVodw0m+wxHq7gk/MwzX7jLGdleJrcFyb8+FKZ0R/0Yd96vWdgHgPZzlMgtwmdPlh8Stv
        7nYvH8R3fkNIA
X-Received: by 2002:a5d:65d2:: with SMTP id e18mr32394317wrw.104.1588061659750;
        Tue, 28 Apr 2020 01:14:19 -0700 (PDT)
X-Google-Smtp-Source: APiQypJlzI9hy4ZJGKbYHcxzy4sLrqXQToqKzTHgHw2jkyDd0CKNs1nrgeSLjPu85ZndC+EXjN1LJA==
X-Received: by 2002:a5d:65d2:: with SMTP id e18mr32394282wrw.104.1588061659432;
        Tue, 28 Apr 2020 01:14:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac19:d1fb:3f5f:d54f? ([2001:b07:6468:f312:ac19:d1fb:3f5f:d54f])
        by smtp.gmail.com with ESMTPSA id y10sm2226626wma.5.2020.04.28.01.14.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2020 01:14:18 -0700 (PDT)
Subject: Re: [PATCH 1/2 v2] KVM: nVMX: KVM needs to unset "unrestricted guest"
 VM-execution control in vmcs02 if vmcs12 doesn't set it
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>
References: <20200415183047.11493-1-krish.sadhukhan@oracle.com>
 <20200415183047.11493-2-krish.sadhukhan@oracle.com>
 <20200415193016.GF30627@linux.intel.com>
 <CALMp9eRvZEzi3Ug0fL=ekMS_Weni6npwW+bXrJZjU8iLrppwEg@mail.gmail.com>
 <0b8bd238-e60f-b392-e793-0d88fb876224@redhat.com>
 <d49ce960-92f9-85eb-4cfb-d533a956223e@oracle.com>
 <20200418015545.GB15609@linux.intel.com>
 <c37b9429-0cb8-6514-44a7-65544873dba0@redhat.com>
 <02a49d40-fe80-2715-d9a8-17770e72c7a3@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <11ce961c-d98c-3c4c-06a7-3c0f8336a340@redhat.com>
Date:   Tue, 28 Apr 2020 10:14:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <02a49d40-fe80-2715-d9a8-17770e72c7a3@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/04/20 09:25, Krish Sadhukhan wrote:
>>>
>> Absolutely.  Unrestricted guest requires EPT, but EPT is invisible to
>> the guest.  (Currently EPT requires guest MAXPHYADDR = host MAXPHYADDR,
>> in the sense that the guest can detect that the host is lying about
>> MAXPHYADDR; but that is really a bug that I hope will be fixed in 5.8,
>> relaxing the requirement to guest MAXPHYADDR <= host PHYADDR).
> 
> Should EPT for the nested guest be set up in the normal way (PML4E ->
> PDPTE-> PDE -> PTE) when GUEST_CR0.PE is zero ? Or does it have to be a
> special set up like only the PTEs are needed because no protection and
> no paging are used ?

I don't understand.  When EPT is in use, the vmcs02 CR3 is simply set to
the vmcs12 CR3.

Paolo

