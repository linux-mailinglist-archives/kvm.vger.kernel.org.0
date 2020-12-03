Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B20A2CDC89
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 18:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728151AbgLCRiG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 12:38:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41735 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726264AbgLCRiD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 12:38:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607016996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IqCBpFSft+AbjyuMAKdWaJ7NxQe9CDa5oWKrC6azTtM=;
        b=gHoZ2sP2Zg6KJKAqS7chrj896BeMxH9jD2zQ+tyeTRNGGsRxNnXskqd54+2o0vhQFOJmcU
        fNGx0daARBMNtJr/oRI9kgKmS+9lD+Bbwi/A50Mz+P/qIpQnqxWK565IeotbNHEbY+O3YR
        veSLyOzGnSotQH4drB8WgN2KjjIllz0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-Zts2foNDMYC1BiIAa21-WA-1; Thu, 03 Dec 2020 12:36:34 -0500
X-MC-Unique: Zts2foNDMYC1BiIAa21-WA-1
Received: by mail-ed1-f70.google.com with SMTP id f19so1231733edq.20
        for <kvm@vger.kernel.org>; Thu, 03 Dec 2020 09:36:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IqCBpFSft+AbjyuMAKdWaJ7NxQe9CDa5oWKrC6azTtM=;
        b=aCRSKgAdX2EpbrAcDcaurP3SW6XBSWmzA2PbOMR705t4f3uxApqak7wff7Lj6gkBb/
         NCacVKg7gcXYiK2PfNrcUEx0/xnsQ2wsgc4+ajWs9ggKd9lbhEZ4ISBawT+/hWSZXYKy
         ODKFMgqxk8jkpcYb0wq10T1PL/RA/Hi7fM4OpcrJtESXRr5SDUg4W6e2zcR1bB9kUg3z
         F4VsijLA6ONIdTOuRDSvnnVwzp327lKBCZxR4xU0rWFv8G3KMW5EfQi/aQnu21PRFjYT
         bFEo1cojgKElkLJn121Ps58EJa6BE5wiX4L1x3FU53r8POwMmsinoXiChkjsUGMpCx1m
         EGWw==
X-Gm-Message-State: AOAM531AkIGUSTuwc+PV+bD5Bo6c9sCCcP2sgWyld+kTbrAn3Zdy4+HF
        HHYkOO3AyBg1p41szkvvb2HZHQOhHaFhG2p5nXgGve+BcAnAfvtlL1JgiQneUx76FOe7/npq9NQ
        NlN84Gqztg96R
X-Received: by 2002:a05:6402:1352:: with SMTP id y18mr3823759edw.378.1607016993715;
        Thu, 03 Dec 2020 09:36:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyZtf7leIUjlCKW3mVpZK5Zf5Gzy0qRNmOzFPFv7FInmFiAzlC18SOvJCT9vjRyuy5VZMtFxw==
X-Received: by 2002:a05:6402:1352:: with SMTP id y18mr3823731edw.378.1607016993456;
        Thu, 03 Dec 2020 09:36:33 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j7sm1672932edp.52.2020.12.03.09.36.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Dec 2020 09:36:32 -0800 (PST)
Subject: Re: [PATCH 1/1] KVM: x86: ignore SIPIs that are received while not in
 wait-for-sipi state
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <20201203143319.159394-1-mlevitsk@redhat.com>
 <20201203143319.159394-2-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <62e9c59f-29a4-d69f-5d02-a5da11cdbd15@redhat.com>
Date:   Thu, 3 Dec 2020 18:36:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201203143319.159394-2-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/12/20 15:33, Maxim Levitsky wrote:
> In the commit 1c96dcceaeb3
> ("KVM: x86: fix apic_accept_events vs check_nested_events"),
> 
> we accidently started latching SIPIs that are received while the cpu is not
> waiting for them.
> 
> This causes vCPUs to never enter a halted state.
> 
> Fixes: 1c96dcceaeb3 ("KVM: x86: fix apic_accept_events vs check_nested_events")
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/lapic.c | 15 ++++++++-------


Indeed, it was done by the xchg before that commit, even if 
vcpu->arch.mp_state != KVM_MP_STATE_INIT_RECEIVED.

Paolo

