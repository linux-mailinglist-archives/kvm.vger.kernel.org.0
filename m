Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF73C3E56BC
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 11:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238977AbhHJJYW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 05:24:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42844 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238936AbhHJJYQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 05:24:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628587433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A/TaMuDq9rc/wgUkDC5taSVgSHRGlTMP2mW3Lj4nlK0=;
        b=TdBxhdKYuxVzJ2lFemXsp7u3EwUNVkBn8w/4PUGtxwr3gI3CM3OPP9kMIHVV0+VOW+2AJT
        1wmSZR6pdj48mOUD65I5hoKbBL3piCoDjAUTqcfC589TeGyPy4Oh5dxTB9YcQzhCBc+x3U
        YdPeOnItKMIU0D/qmm2SRALjJuKKnYs=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-XjBuFKoCOmiA_DAj-2XlpQ-1; Tue, 10 Aug 2021 05:23:52 -0400
X-MC-Unique: XjBuFKoCOmiA_DAj-2XlpQ-1
Received: by mail-ed1-f72.google.com with SMTP id y22-20020a0564023596b02903bd9452ad5cso10436379edc.20
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 02:23:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A/TaMuDq9rc/wgUkDC5taSVgSHRGlTMP2mW3Lj4nlK0=;
        b=c7ylSQF5fdBMsYEa5f/7qe9GuBFhcCGAXfOZeBtoLZqfU8apvg0bTynvqSVY4AcZo9
         faoOBJ5WyawxR0qOIp2bPa//bQlPG6RlDMV1ifbvER05bSU523VwFdWcCXOhY8+D6Ma1
         VlCF4bjqSw8tTrkIH8q0QBwlTqxGvv1BSxeaGvI9DzWwzyu1ayJ10N7dS1+WlAnV1sbM
         kV5vGexaYMUrxyzBmpoq4FmNcHc+aitMMqZbmAvAoYaga6i8iiXtCF8ZIdUTs3kVLLlJ
         oz3xkJI26h1rMAa7TkTqe37a8DIPnmx35D73jBLA9A/GSstd7aDravevFdv1ZZkThUzf
         nvjg==
X-Gm-Message-State: AOAM531P3JLF9W9+2WfiLrl+inv7zB5MTcTzNxD0Fw7aKPMUt3YRtKFo
        CuU+JyOrQFDyoiM//Y1mK1Guw6Yc7Y3Xq9d7kFj+KgV6NKa97OMgmvq4hZ5gS3Y9v/vApn2fPJt
        ogCeTFEJ1MivM
X-Received: by 2002:a05:6402:452:: with SMTP id p18mr3795476edw.34.1628587430913;
        Tue, 10 Aug 2021 02:23:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy8PXtMO2e19p2OPoYOrnLEV4qDAC/gOcR888De9nrRlKF6wNXdDkTjBvD0jcpOd8sYsOWqHA==
X-Received: by 2002:a05:6402:452:: with SMTP id p18mr3795455edw.34.1628587430750;
        Tue, 10 Aug 2021 02:23:50 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id u23sm4545368edr.42.2021.08.10.02.23.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 02:23:50 -0700 (PDT)
To:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        wanpengli@tencent.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com
References: <20210808192658.2923641-1-wei.huang2@amd.com>
 <20210808192658.2923641-2-wei.huang2@amd.com>
 <20210809035806.5cqdqm5vkexvngda@linux.intel.com>
 <c6324362-1439-ef94-789b-5934c0e1cdb8@amd.com>
 <20210809042703.25gfuuvujicc3vj7@linux.intel.com>
 <73bbaac0-701c-42dd-36da-aae1fed7f1a0@amd.com>
 <20210809064224.ctu3zxknn7s56gk3@linux.intel.com>
 <YRFKABg2MOJxcq+y@google.com>
 <CALMp9eRfuntBFz=gnsvEuTXAXZorWJFAPq0ZdwZePxxQYGzdQA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 1/3] KVM: x86: Allow CPU to force vendor-specific TDP
 level
Message-ID: <400f8ca7-8f82-308b-3427-b644144cfa5c@redhat.com>
Date:   Tue, 10 Aug 2021 11:23:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eRfuntBFz=gnsvEuTXAXZorWJFAPq0ZdwZePxxQYGzdQA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/21 23:49, Jim Mattson wrote:
> Doesn't this break legacy type 2 hypervisors that don't know anything
> about 5-level NPT and don't have any control over whether or not the
> host uses 5-level paging?

Yes, where "legacy" probably means "all released versions of all of 
them", including KVM.  Host support for LA57 was merged in 4.13, while 
KVM started supporting 5-level page tables in EPT in 4.14 and even then 
just returned PT64_ROOT_LEVEL (i.e. 4) for the maximum NPT level.

So all Linux versions up to 5.13, which has "KVM: x86: Prevent KVM SVM 
from loading on kernels with 5-level paging", will break horribly. 
Better backport that patch to stable...

Paolo

