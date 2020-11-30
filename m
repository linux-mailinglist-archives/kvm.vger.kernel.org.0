Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9EB22C8C81
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 19:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388066AbgK3SRv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 13:17:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60136 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728584AbgK3SRu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 13:17:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606760183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GB+QDvrrhr+2OQoEfVEhq3uj15zijuotos8Vv+hlIcU=;
        b=J+7BuJXUBW4t3j747wie6Pg66BgZp3x4Oyu3LMzKIAfuF8ncIi05rkAFqwbvJ8rGC67uys
        Cw8wD4u2eI24NOOIzBzi4AQXoslw3vl7W+usz1Y7vcIlhIBPHj8OgJqDYo09PXhVXBh8hv
        ARV+IuY8OA9ioSfgg1glDcac6Z1NIpU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-CdzUTfABNqKE56ZiLi1qZA-1; Mon, 30 Nov 2020 13:16:21 -0500
X-MC-Unique: CdzUTfABNqKE56ZiLi1qZA-1
Received: by mail-ed1-f72.google.com with SMTP id w24so3585892edt.11
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 10:16:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GB+QDvrrhr+2OQoEfVEhq3uj15zijuotos8Vv+hlIcU=;
        b=qlLtmPSgmw9rQtCydi55+rfcIB4nJjA1TSo+Zw0Gc4wd0R/l98PjHn5hcX8woaj6sI
         tP9bM2UQg4aN0f+O5PV4/ED1VCnOGWEQePjWu3CjZX6wN+zxxOlY0wjOE39qJx/SzhEl
         M+c18nWFHCp3wmhUr6IsuIYGxbjYdQBL98iikEIe+2Z0M+fYps4eE+qXAknWch2TyxIf
         gELsRYhDMY020CYyKRuYZBl9kGlxDjMol9UXC2UTAz/LMGVMMLAIrvT5p+g2T7isekMd
         jpfLprKds08JQ4qdJhNQvNrTjABMwC/gLZPZvMcjkVHFGFg87l6kFrSiimgiVJL1TtZt
         1Tfw==
X-Gm-Message-State: AOAM531RQ25A4az0WmFjVkoQYBYPsAMMu+Ynrz0ZL+so714CPuODuG1g
        MNHz/gx2L6b5n0YPr/Djv0ALQqqraeJY0/UPE1lcD0+/BexiB6u/7RSuoM77ONyXgz54KJTje3E
        3CGX5u9aZxlHD
X-Received: by 2002:a17:906:3899:: with SMTP id q25mr7080033ejd.173.1606760180681;
        Mon, 30 Nov 2020 10:16:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx7tWtX+gRI/5P/ITr2Ls+Wj+e/A2iUFFZPdasfKzTJ61HjH/APuSl1lLqoHewiuQeismEZVw==
X-Received: by 2002:a17:906:3899:: with SMTP id q25mr7079999ejd.173.1606760180400;
        Mon, 30 Nov 2020 10:16:20 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q23sm1533459edt.32.2020.11.30.10.16.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 10:16:19 -0800 (PST)
Subject: Re: [RFC PATCH 23/35] KVM: SVM: Add support for CR4 write traps for
 an SEV-ES guest
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <97f610c7fcf0410985a3ff4cd6d4013f83fe59e6.1600114548.git.thomas.lendacky@amd.com>
 <20200914221651.GK7192@sjchrist-ice>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <263f5485-7e99-3db0-3234-f5ea02d1e119@redhat.com>
Date:   Mon, 30 Nov 2020 19:16:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20200914221651.GK7192@sjchrist-ice>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/09/20 00:16, Sean Christopherson wrote:
>> +int kvm_track_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>> +{
>> +	unsigned long old_cr4 = kvm_read_cr4(vcpu);
>> +	unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
>> +				   X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE;
>> +
>> +	if (kvm_x86_ops.set_cr4(vcpu, cr4))
>> +		return 1;
> Pretty much all the same comments as EFER and CR0, e.g. call svm_set_cr4()
> directly instead of bouncing through kvm_x86_ops.  And with that, this can
> be called __kvm_set_cr4() to be consistent with __kvm_set_cr0().

I agree with calling svm_set_cr4 directly, but then this should be 
kvm_post_set_cr4.

Paolo

>> +
>> +	if (((cr4 ^ old_cr4) & pdptr_bits) ||
>> +	    (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)))
>> +		kvm_mmu_reset_context(vcpu);
>> +
>> +	if ((cr4 ^ old_cr4) & (X86_CR4_OSXSAVE | X86_CR4_PKE))
>> +		kvm_update_cpuid_runtime(vcpu);
>> +
>> +	return 0;
>> +}

