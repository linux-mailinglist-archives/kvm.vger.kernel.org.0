Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9FD8D0C4
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 12:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfHNKgp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 06:36:45 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43026 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbfHNKgp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 06:36:45 -0400
Received: by mail-wr1-f66.google.com with SMTP id y8so4657359wrn.10
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2019 03:36:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bYq5NeY+nFd1EyYN2MN3ouVDKMlchwpO7oJ9X8ypRos=;
        b=teIf/zlYf1BuaLhNRI9wTBmOb+Dq50T45N/IZqa6d2N0jjLvsXC79dxj04pDR+zKT5
         JgoRqofHK+N1sqsnZ6u0FcSmBCCf9JKY5be3dwMDbCwhwJJ0eNh6n9u1CScD5uI9ICEf
         +QwwKwSIvREpfHH+WKLqPtBguTsEyOPW/NvbCmXSgn0zdqGkdhJNzGxLb7HONNb+vvlM
         o9++sR/kp6lTCjc9pX9sdoFd6JED1IuwIIgYLT2X9Ed0lh9StIV/XrX2Iuj6BUmVkHqO
         lAPlCTBzDQ0LFJYmwYBMG/dFnKOuRCII24+nm+8PZe01nwGKHcpypoZhzZA4qS1iYSlR
         ov6Q==
X-Gm-Message-State: APjAAAVAxdq7hnoh8iv6ywz9FGCbBiPBXpHXdteMvgcfyaxUvcOh+mVe
        hbWl+BxpFQv/BWRmdHH0sNfRWQ==
X-Google-Smtp-Source: APXvYqzZW0UYXnedU97p1rYCOZhyFk5P1do2MIJV7Gv4OdneysiD2+Iy6BRSGYX5Z9NJ73+b/AI1Pw==
X-Received: by 2002:adf:ab18:: with SMTP id q24mr23220449wrc.354.1565779003235;
        Wed, 14 Aug 2019 03:36:43 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:2cae:66cd:dd43:92d9? ([2001:b07:6468:f312:2cae:66cd:dd43:92d9])
        by smtp.gmail.com with ESMTPSA id m6sm20013638wrq.95.2019.08.14.03.36.42
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 03:36:42 -0700 (PDT)
Subject: Re: [RFC PATCH v6 76/92] kvm: x86: disable EPT A/D bits if
 introspection is present
To:     =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>
Cc:     kvm@vger.kernel.org,
        =?UTF-8?Q?Adalbert_Laz=c4=83r?= <alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-77-alazar@bitdefender.com>
 <9f8b31c5-2252-ddc5-2371-9c0959ac5a18@redhat.com>
 <0550f8d65bb97486e98d88255ea45d490da6b802.camel@bitdefender.com>
 <662761e1-5709-663f-524f-579f8eba4060@redhat.com>
 <3f22404e0d1b7dff45d81516318787c79b7d7eec.camel@bitdefender.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <05df5f1d-3542-11a8-2229-77d75b11bf42@redhat.com>
Date:   Wed, 14 Aug 2019 12:36:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <3f22404e0d1b7dff45d81516318787c79b7d7eec.camel@bitdefender.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/08/19 10:53, Mihai Donțu wrote:
> On Tue, 2019-08-13 at 23:05 +0200, Paolo Bonzini wrote:
>> On 13/08/19 20:36, Mihai Donțu wrote:
>>>> Why?
>>> When EPT A/D is enabled, all guest page table walks are treated as
>>> writes (like AMD's NPT). Thus, an introspection tool hooking the guest
>>> page tables would trigger a flood of VMEXITs (EPT write violations)
>>> that will get the introspected VM into an unusable state.
>>>
>>> Our implementation of such an introspection tool builds a cache of
>>> {cr3, gva} -> gpa, which is why it needs to monitor all guest PTs by
>>> hooking them for write.
>>
>> Please include the kvm list too.
> 
> I apologize. I did not notice I trimmed the CC list.
> 
>> One issue here is that it changes the nested VMX ABI.  Can you leave EPT
>> A/D in place for the shadow EPT MMU, but not for "regular" EPT pages?
> 
> I'm not sure I follow. Something like this?
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 48e3cdd7b009..569e8f4d5dd7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2853,7 +2853,7 @@ u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa)
>         eptp |= (get_ept_level(vcpu) == 5) ? VMX_EPTP_PWL_5 : VMX_EPTP_PWL_4;
>  
>         if (enable_ept_ad_bits &&
> -           (!is_guest_mode(vcpu) || nested_ept_ad_enabled(vcpu)))
> +           ((!is_guest_mode(vcpu) && !kvmi_is_present()) || nested_ept_ad_enabled(vcpu)))
>                 eptp |= VMX_EPTP_AD_ENABLE_BIT;
>         eptp |= (root_hpa & PAGE_MASK);

Almost, because you also have to change the accessed/dirty bits for
mmu.c.  Probably by moving the call to kvm_mmu_set_mask_ptes from
vmx_enable_tdp to vmx_set_cr3.

Paolo

>> Also, what is the state of introspection support on AMD?
> 
> The way we'd like to do introspection is not currently possible on AMD
> CPUs. The reasons being:
>  * the NPT has the behavior I talked above (guest PT walks translate to
>    writes)
>  * it is not possible to mark a guest page as execute-only
>  * there is no equivalent to Intel's MTF, though it can _probably_ be
>    emulated using a creative trick involving the debug registers
> 
> If, however, none of the above are of importance for other users,
> everything else should work. I have to admit, though, we have not done
> any tests.
> 
> Regards,
> 

