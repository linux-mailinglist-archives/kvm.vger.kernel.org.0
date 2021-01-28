Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188DD307CFC
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 18:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbhA1RtJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 12:49:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22980 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232697AbhA1Rqk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 12:46:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611855913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2ia40WvOilz7nSgwNJj+1gY05Fmsq3ciD2xdjd10Q8I=;
        b=FqHgysWPB9Y5fyLNHtEC75kXP2nsYhx0Xwk1XbbjB+ZHHkkL7sUXc+47zTH1SC000o0bJ9
        kOBug6fiUWePrqarC6M3oZmc+h8+rNfpnelUA+sBGVDGY28U61wCW4ZZC9EEMFpnbOzouw
        F+dsegq8N+lQng5IQBOiBOCQhf7di/Q=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-U6xM1CohOTKoz1dIeiVx3g-1; Thu, 28 Jan 2021 12:45:12 -0500
X-MC-Unique: U6xM1CohOTKoz1dIeiVx3g-1
Received: by mail-ed1-f69.google.com with SMTP id u19so3551237edr.1
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 09:45:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2ia40WvOilz7nSgwNJj+1gY05Fmsq3ciD2xdjd10Q8I=;
        b=oIgZyG6LGFDlpnyAjxJxEKHa51H0vPjTzIuvUTlxv8b+aJnkvjNymmsoHK8hd9YXuR
         uLwJPnoz57huESTrFcAujRATpJ5K1EYVQ8w8PIgqygZyE66pMEYmtniPuCbiWGTnfvSX
         JMMbVjBRtMHn6k9aMnGAr9PcmIRkcVntHTwVQ6SeW9vugI54XzlGX9w0W+sMJkXIU7Ay
         WFldbiM4noWHzRjlEORUGA5YYkZkwA9DetIaDzAvyLBPpWcghz8QTOuDrtzSgOsi6I0m
         f3CFbGQ7K9kXuciwT5vY/W9ZTz9fAkZvXBDJWfYUFRi71pEKWS1YT55JckAeTb0rnVx4
         TVzg==
X-Gm-Message-State: AOAM532HWQFNKLoWIKzwVTK/x4jHCv7P5O48BzDE+5T9pJnEZ9L2C6YM
        Kp1RBiPPEoytlRJUI9C3IDMgOeySrm5vqFELMcqo03do2BxO2GmlzhN4D316i2p6meqfsTEo0lF
        toxYN8GQsmYDb
X-Received: by 2002:aa7:dace:: with SMTP id x14mr779787eds.300.1611855910448;
        Thu, 28 Jan 2021 09:45:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzBGPiVvzjEVC+Ug1YWET/SGcYt3kNFgRVkbAbpEE+scOYjuDSh4WNQDHXnLmx6pMYRluRHsg==
X-Received: by 2002:aa7:dace:: with SMTP id x14mr779759eds.300.1611855910266;
        Thu, 28 Jan 2021 09:45:10 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id bc6sm3348248edb.52.2021.01.28.09.45.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 09:45:09 -0800 (PST)
Subject: Re: [PATCH v14 07/13] KVM: VMX: Emulate reads and writes to CET MSRs
To:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com
References: <20201106011637.14289-1-weijiang.yang@intel.com>
 <20201106011637.14289-8-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a73b590d-4cd3-f1b3-bea2-e674846595b3@redhat.com>
Date:   Thu, 28 Jan 2021 18:45:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201106011637.14289-8-weijiang.yang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/11/20 02:16, Yang Weijiang wrote:
> 
> +static bool cet_is_ssp_msr_accessible(struct kvm_vcpu *vcpu,
> +				      struct msr_data *msr)
> +{
> +	u64 mask;
> +
> +	if (!kvm_cet_supported())
> +		return false;
> +
> +	if (msr->host_initiated)
> +		return true;
> +
> +	if (!guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
> +		return false;
> +
> +	if (msr->index == MSR_IA32_INT_SSP_TAB)
> +		return false;

Shouldn't this return true?

Paolo

> +	mask = (msr->index == MSR_IA32_PL3_SSP) ? XFEATURE_MASK_CET_USER :
> +						  XFEATURE_MASK_CET_KERNEL;
> +	return !!(vcpu->arch.guest_supported_xss & mask);
> +}

