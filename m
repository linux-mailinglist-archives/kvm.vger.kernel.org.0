Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8C914C8C9
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2020 11:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbgA2KgO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 05:36:14 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30907 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726116AbgA2KgN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 05:36:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580294172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J2ELfdfmeOLb/CT6GrrCevIO+CxmbSz5WWZ5pC+6QHI=;
        b=X+Ds/bEPpfQgjnDjkVOUaN2gQChyR7rSwXrN72Jk2OOg2+grnbYyltGygpDcVCmnnOcP6l
        Y4WLC8YmOILiBBrYW6WMxxhUCRKaGYjdH/olfdF0aBPtshGd8wUWC2VzJy3IT6wXPFWBzg
        Ol/ocwlF37L6feNDzbFnmADwzbmftNM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-7D92Wv5INA26rUST7q5yGQ-1; Wed, 29 Jan 2020 05:36:10 -0500
X-MC-Unique: 7D92Wv5INA26rUST7q5yGQ-1
Received: by mail-wr1-f71.google.com with SMTP id f17so9863421wrt.19
        for <kvm@vger.kernel.org>; Wed, 29 Jan 2020 02:36:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J2ELfdfmeOLb/CT6GrrCevIO+CxmbSz5WWZ5pC+6QHI=;
        b=XN/zXIYhasag3IhFY0owbpCaZaGLzePFoDExdoRLwmSqZwi+Rec0hNz13zsweVsQue
         eW/fKGwPufPduAyByOUdOdUhJIQcn/XSFJ5g8WBaSnhrkta/v5XMVWcOliXYCGWiJvsd
         ybQBI06smHpl8e4OjLlLkUYvZV+/p4I6i/9D5UZMySK/egd1XG7ISFdy18s2T0Qw+cVW
         Abb3iqqbow9lka85luAWiBSapFFsKsW5BuuRhYIfrC24nYsXANhWINYS6aSuVMpsxxJb
         y/R5pZGnUpzwA8BCdXZV0jFNzF+gx60veJHwJu5YJeSqrCTNhp4ZFBfsSyAb3Exk8g4j
         LcBA==
X-Gm-Message-State: APjAAAWoNQVWeSIVwiSiLyT7lOejNIU2UYhiCpv4sNY9ZnIPRUpjVFA/
        1t9h6uqbjmS+yebZd/AByViBHCfzPUM/p4Lmd/JpGtXKKNaKGgErTDMTiArZspuZdKKvzIR6Ho6
        0NECntBEIH8iR
X-Received: by 2002:adf:e448:: with SMTP id t8mr6809316wrm.224.1580294169568;
        Wed, 29 Jan 2020 02:36:09 -0800 (PST)
X-Google-Smtp-Source: APXvYqwyGUSnZ951MOEhC0vpWncAdy7BLZiUBINFhZRmdX3WwGLbYkpXpkpM5qyjRh4C9RpFDiLfIg==
X-Received: by 2002:adf:e448:: with SMTP id t8mr6809295wrm.224.1580294169324;
        Wed, 29 Jan 2020 02:36:09 -0800 (PST)
Received: from [10.200.153.153] ([213.175.37.12])
        by smtp.gmail.com with ESMTPSA id z19sm1684563wmi.35.2020.01.29.02.36.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2020 02:36:08 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: Fix perfctr WRMSR for running counters
To:     Eric Hankland <ehankland@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200127212256.194310-1-ehankland@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2a394c6d-c453-6559-bf33-f654af7922bd@redhat.com>
Date:   Wed, 29 Jan 2020 11:36:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200127212256.194310-1-ehankland@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/01/20 22:22, Eric Hankland wrote:
> Correct the logic in intel_pmu_set_msr() for fixed and general purpose
> counters. This was recently changed to set pmc->counter without taking
> in to account the value of pmc_read_counter() which will be incorrect if
> the counter is currently running and non-zero; this changes back to the
> old logic which accounted for the value of currently running counters.
> 
> Signed-off-by: Eric Hankland <ehankland@google.com>
> ---
>  arch/x86/kvm/vmx/pmu_intel.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 34a3a17bb6d7..9bdbe05b599c 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -264,9 +264,10 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  				pmc->counter = data;
>  			else
>  				pmc->counter = (s32)data;
> +			pmc->counter += pmc->counter - pmc_read_counter(pmc);

I think this best written as it was before commit 2924b52117:

			if (!msr_info->host_initiated)
				data = (s64)(s32)data;
			pmc->counter += data - pmc_read_counter(pmc);

Do you have a testcase?

Paolo

>  			return 0;
>  		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
> -			pmc->counter = data;
> +			pmc->counter += data - pmc_read_counter(pmc);
>  			return 0;
>  		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
>  			if (data == pmc->eventsel)
> 

