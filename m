Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74EA21A67B
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 20:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbgGIR76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 13:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbgGIR76 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 13:59:58 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E6EC08C5CE;
        Thu,  9 Jul 2020 10:59:57 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id z2so3342842wrp.2;
        Thu, 09 Jul 2020 10:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:from:to:cc:references:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G5/LZYok9Ot596aBDzl+DsLC/89WtoHYBw1Y5X78RcY=;
        b=smFS6YGVBVHn0kQlkrNb89yRG+cidQayeMC4Kyk+4fTMgUNdy/5dC4CMFv929NaO1v
         XjeZgwP+JdEv8iKHlKhkU964iFFrBUosK7rS8HujfqowefVkipwsQwQxmHoS4swLqiWR
         1jyFF2+m8hLg8WBp+MRtwCTBQJjWxVtOg7G9DLyG+GLC4DboP9Q5CI1bmAQgMNnMSKL+
         vBDDa9J1ZHE4YdS8zuS8y/rUV/o65p0hNRNNd+WPERuQ6kzpO5a5r7orwPx+kM+qwRtF
         T6tbocQwGAxq6o9TkdeRBgAu11vOiiKYzejnf6v53+Sa2dl+SxYGyl0yU81IZf1ty0LF
         rMAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=G5/LZYok9Ot596aBDzl+DsLC/89WtoHYBw1Y5X78RcY=;
        b=D+kv6OU71rXgJ4XcxDvvg5+YyANRkSerZ9wN7mgHsGC97Ru2E7XCXnuFSoy9DWUhHA
         XqTKZXwLJqhTsga6ZoH4u28bwCNSW8TYDyEKsY/Vg4TtjQBlG8DUztJvchwxTC0fpbQr
         K/DbbHFi+tGtt7aQWLB2+81g93xxVEruTnik6fZZEJ2txyM130tX+njpqWP1TRcrKLyv
         lH8dkCZWwJVPJ78+jj0PVFnDYaHfx4dzRrtQLMdDjpDSvPcSl37fVfQqGtVAoxL68Io2
         mOjjAUCUZA5l/Ux6hdvyTxN0NdhwYNXufblq1iykuMeRHOsCkt9goHUHO+K/pXk/6/RD
         oXRA==
X-Gm-Message-State: AOAM533BNq/eoZZyAFjVszud/eyg8/B9ifEho/ywqulJjNxYAvLLTT+t
        cK6y/xEyk1S+GMM6um4uHg+Ezmh8mR0=
X-Google-Smtp-Source: ABdhPJzg1nWUE/Rrqi23SFhuve76Wead79b35yPIm+H96NJF+9BfHkR/C42hLJGW/FxvCuDz3BKt/g==
X-Received: by 2002:adf:f04c:: with SMTP id t12mr61240472wro.382.1594317596226;
        Thu, 09 Jul 2020 10:59:56 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.googlemail.com with ESMTPSA id y6sm854214wrr.74.2020.07.09.10.59.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 10:59:55 -0700 (PDT)
Subject: Re: [PATCH v3 7/9] KVM: nSVM: implement nested_svm_load_cr3() and use
 it for host->guest switch
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
References: <20200709145358.1560330-1-vkuznets@redhat.com>
 <20200709145358.1560330-8-vkuznets@redhat.com>
 <4d3f5b01-72d9-c2c5-08e8-c2b1e0046e5e@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 mQHhBFRCcBIBDqDGsz4K0zZun3jh+U6Z9wNGLKQ0kSFyjN38gMqU1SfP+TUNQepFHb/Gc0E2
 CxXPkIBTvYY+ZPkoTh5xF9oS1jqI8iRLzouzF8yXs3QjQIZ2SfuCxSVwlV65jotcjD2FTN04
 hVopm9llFijNZpVIOGUTqzM4U55sdsCcZUluWM6x4HSOdw5F5Utxfp1wOjD/v92Lrax0hjiX
 DResHSt48q+8FrZzY+AUbkUS+Jm34qjswdrgsC5uxeVcLkBgWLmov2kMaMROT0YmFY6A3m1S
 P/kXmHDXxhe23gKb3dgwxUTpENDBGcfEzrzilWueOeUWiOcWuFOed/C3SyijBx3Av/lbCsHU
 Vx6pMycNTdzU1BuAroB+Y3mNEuW56Yd44jlInzG2UOwt9XjjdKkJZ1g0P9dwptwLEgTEd3Fo
 UdhAQyRXGYO8oROiuh+RZ1lXp6AQ4ZjoyH8WLfTLf5g1EKCTc4C1sy1vQSdzIRu3rBIjAvnC
 tGZADei1IExLqB3uzXKzZ1BZ+Z8hnt2og9hb7H0y8diYfEk2w3R7wEr+Ehk5NQsT2MPI2QBd
 wEv1/Aj1DgUHZAHzG1QN9S8wNWQ6K9DqHZTBnI1hUlkp22zCSHK/6FwUCuYp1zcAEQEAAbQj
 UGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT6JAg0EEwECACMFAlRCcBICGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRB+FRAMzTZpsbceDp9IIN6BIA0Ol7MoB15E
 11kRz/ewzryFY54tQlMnd4xxfH8MTQ/mm9I482YoSwPMdcWFAKnUX6Yo30tbLiNB8hzaHeRj
 jx12K+ptqYbg+cevgOtbLAlL9kNgLLcsGqC2829jBCUTVeMSZDrzS97ole/YEez2qFpPnTV0
 VrRWClWVfYh+JfzpXmgyhbkuwUxNFk421s4Ajp3d8nPPFUGgBG5HOxzkAm7xb1cjAuJ+oi/K
 CHfkuN+fLZl/u3E/fw7vvOESApLU5o0icVXeakfSz0LsygEnekDbxPnE5af/9FEkXJD5EoYG
 SEahaEtgNrR4qsyxyAGYgZlS70vkSSYJ+iT2rrwEiDlo31MzRo6Ba2FfHBSJ7lcYdPT7bbk9
 AO3hlNMhNdUhoQv7M5HsnqZ6unvSHOKmReNaS9egAGdRN0/GPDWr9wroyJ65ZNQsHl9nXBqE
 AukZNr5oJO5vxrYiAuuTSd6UI/xFkjtkzltG3mw5ao2bBpk/V/YuePrJsnPFHG7NhizrxttB
 nTuOSCMo45pfHQ+XYd5K1+Cv/NzZFNWscm5htJ0HznY+oOsZvHTyGz3v91pn51dkRYN0otqr
 bQ4tlFFuVjArBZcapSIe6NV8C4cEiSS5AQ0EVEJxcwEIAK+nUrsUz3aP2aBjIrX3a1+C+39R
 nctpNIPcJjFJ/8WafRiwcEuLjbvJ/4kyM6K7pWUIQftl1P8Woxwb5nqL7zEFHh5I+hKS3haO
 5pgco//V0tWBGMKinjqntpd4U4Dl299dMBZ4rRbPvmI8rr63sCENxTnHhTECyHdGFpqSzWzy
 97rH68uqMpxbUeggVwYkYihZNd8xt1+lf7GWYNEO/QV8ar/qbRPG6PEfiPPHQd/sldGYavmd
 //o6TQLSJsvJyJDt7KxulnNT8Q2X/OdEuVQsRT5glLaSAeVAABcLAEnNgmCIGkX7TnQF8a6w
 gHGrZIR9ZCoKvDxAr7RP6mPeS9sAEQEAAYkDEgQYAQIACQUCVEJxcwIbAgEpCRB+FRAMzTZp
 scBdIAQZAQIABgUCVEJxcwAKCRC/+9JfeMeug/SlCACl7QjRnwHo/VzENWD9G2VpUOd9eRnS
 DZGQmPo6Mp3Wy8vL7snGFBfRseT9BevXBSkxvtOnUUV2YbyLmolAODqUGzUI8ViF339poOYN
 i6Ffek0E19IMQ5+CilqJJ2d5ZvRfaq70LA/Ly9jmIwwX4auvXrWl99/2wCkqnWZI+PAepkcX
 JRD4KY2fsvRi64/aoQmcxTiyyR7q3/52Sqd4EdMfj0niYJV0Xb9nt8G57Dp9v3Ox5JeWZKXS
 krFqy1qyEIypIrqcMbtXM7LSmiQ8aJRM4ZHYbvgjChJKR4PsKNQZQlMWGUJO4nVFSkrixc9R
 Z49uIqQK3b3ENB1QkcdMg9cxsB0Onih8zR+Wp1uDZXnz1ekto+EivLQLqvTjCCwLxxJafwKI
 bqhQ+hGR9jF34EFur5eWt9jJGloEPVv0GgQflQaE+rRGe+3f5ZDgRe5Y/EJVNhBhKcafcbP8
 MzmLRh3UDnYDwaeguYmxuSlMdjFL96YfhRBXs8tUw6SO9jtCgBvoOIBDCxxAJjShY4KIvEpK
 b2hSNr8KxzelKKlSXMtB1bbHbQxiQcerAipYiChUHq1raFc3V0eOyCXK205rLtknJHhM5pfG
 6taABGAMvJgm/MrVILIxvBuERj1FRgcgoXtiBmLEJSb7akcrRlqe3MoPTntSTNvNzAJmfWhd
 SvP0G1WDLolqvX0OtKMppI91AWVu72f1kolJg43wbaKpRJg1GMkKEI3H+jrrlTBrNl/8e20m
 TElPRDKzPiowmXeZqFSS1A6Azv0TJoo9as+lWF+P4zCXt40+Zhh5hdHO38EV7vFAVG3iuay6
 7ToF8Uy7tgc3mdH98WQSmHcn/H5PFYk3xTP3KHB7b0FZPdFPQXBZb9+tJeZBi9gMqcjMch+Y
 R8dmTcQRQX14bm5nXlBF7VpSOPZMR392LY7wzAvRdhz7aeIUkdO7VelaspFk2nT7wOj1Y6uL
 nRxQlLkBDQRUQnHuAQgAx4dxXO6/Zun0eVYOnr5GRl76+2UrAAemVv9Yfn2PbDIbxXqLff7o
 yVJIkw4WdhQIIvvtu5zH24iYjmdfbg8iWpP7NqxUQRUZJEWbx2CRwkMHtOmzQiQ2tSLjKh/c
 HeyFH68xjeLcinR7jXMrHQK+UCEw6jqi1oeZzGvfmxarUmS0uRuffAb589AJW50kkQK9VD/9
 QC2FJISSUDnRC0PawGSZDXhmvITJMdD4TjYrePYhSY4uuIV02v028TVAaYbIhxvDY0hUQE4r
 8ZbGRLn52bEzaIPgl1p/adKfeOUeMReg/CkyzQpmyB1TSk8lDMxQzCYHXAzwnGi8WU9iuE1P
 0wARAQABiQHzBBgBAgAJBQJUQnHuAhsMAAoJEH4VEAzNNmmxp1EOoJy0uZggJm7gZKeJ7iUp
 eX4eqUtqelUw6gU2daz2hE/jsxsTbC/w5piHmk1H1VWDKEM4bQBTuiJ0bfo55SWsUNN+c9hh
 IX+Y8LEe22izK3w7mRpvGcg+/ZRG4DEMHLP6JVsv5GMpoYwYOmHnplOzCXHvmdlW0i6SrMsB
 Dl9rw4AtIa6bRwWLim1lQ6EM3PWifPrWSUPrPcw4OLSwFk0CPqC4HYv/7ZnASVkR5EERFF3+
 6iaaVi5OgBd81F1TCvCX2BEyIDRZLJNvX3TOd5FEN+lIrl26xecz876SvcOb5SL5SKg9/rCB
 ufdPSjojkGFWGziHiFaYhbuI2E+NfWLJtd+ZvWAAV+O0d8vFFSvriy9enJ8kxJwhC0ECbSKF
 Y+W1eTIhMD3aeAKY90drozWEyHhENf4l/V+Ja5vOnW+gCDQkGt2Y1lJAPPSIqZKvHzGShdh8
 DduC0U3xYkfbGAUvbxeepjgzp0uEnBXfPTy09JGpgWbg0w91GyfT/ujKaGd4vxG2Ei+MMNDm
 S1SMx7wu0evvQ5kT9NPzyq8R2GIhVSiAd2jioGuTjX6AZCFv3ToO53DliFMkVTecLptsXaes
 uUHgL9dKIfvpm+rNXRn9wAwGjk0X/A==
Message-ID: <c7c65e0e-0c8f-106b-6249-ac706e702259@redhat.com>
Date:   Thu, 9 Jul 2020 19:59:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <4d3f5b01-72d9-c2c5-08e8-c2b1e0046e5e@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/07/20 19:57, Paolo Bonzini wrote:
> On 09/07/20 16:53, Vitaly Kuznetsov wrote:
>> +	if (nested_npt_enabled(svm))
>> +		nested_svm_init_mmu_context(&svm->vcpu);
>> +
>>  	ret = nested_svm_load_cr3(&svm->vcpu, nested_vmcb->save.cr3,
>>  				  nested_npt_enabled(svm));
> 
> This needs to be done in svm_set_nested_state, so my suggestion is that
> the previous patch includes a call to nested_svm_load_cr3 in
> svm_set_nested_state, and this one adds the "if" inside
> nested_svm_load_cr3 itself.

Actually no, that doesn't work after the next patch.  So the best option
is probably to extract nested_svm_init_mmu as a separate step in
enter_svm_guest_mode.  This also leaves nested_prepare_vmcb_save as a
void function.

Paolo

> 
> Paolo
> 
>> @@ -364,13 +388,6 @@ static int nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_vm
>>  static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
>>  {
>>  	const u32 mask = V_INTR_MASKING_MASK | V_GIF_ENABLE_MASK | V_GIF_MASK;
>> -	if (nested_npt_enabled(svm))
>> -		nested_svm_init_mmu_context(&svm->vcpu);
>> -
>> -	/* Guest paging mode is active - reset mmu */
>> -	kvm_mmu_reset_context(&svm->vcpu);
>> -
>> -	svm_flush_tlb(&svm->vcpu);
>>  
> 

