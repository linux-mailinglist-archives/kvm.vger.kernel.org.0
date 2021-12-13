Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21760472369
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 10:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbhLMJB2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 04:01:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231772AbhLMJB1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 04:01:27 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E4BC061748;
        Mon, 13 Dec 2021 01:01:27 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id x10so32269202edd.5;
        Mon, 13 Dec 2021 01:01:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CR75fK/LU5VxKAcUyjQTvhGDV/ZY9kpeodVRSprVuA8=;
        b=fFXPFUDKDJngOpm5GYKXQt98kIqMolFEF+NQhpGOKEtqUJFL/orLbECLPJWIYq5NOJ
         FHnm6qBZ53kuGmOwEknnmj3SWDy1Q2Yx+jswNfpmm+JT3FkZo/ZVhptCImO56gyQuyaZ
         1J4xzctqXFFYlVBqGY6rY2narFowxj71pdUpaS/JnYlV3RoxLg8BzFeoX5qnCvenwfBw
         v/xyEXzkIYgixwDiJs/bsPDP1Jspfxu8GaeBp5hoVtjrbGTPyfZyvDVj10JO8yYYIZiy
         3nNlCwTw7LFAOL/5rlMg6/xNR/UQmVtXSxAlUVv0PCLm8gIwXGr0/o6j34sjR8J9Oqb6
         zDWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CR75fK/LU5VxKAcUyjQTvhGDV/ZY9kpeodVRSprVuA8=;
        b=5jkvE3uBMfF3ihRMdR8sbl0jw2t03woQatHXMn/2QtPwH2YZBFlGNbR4xgxFmD6Rdp
         d9T5yXGGKjzzt2KCJVFoaHqABYPDZU2L/fpZTeZzf6T3DdpgbwXqChsKwWwa50JgMicV
         U32Urr7dy0rbKqaAbt33VLOiJ50xaHH6lfNuFaSM+U78hd51raX8lBCvlZUDXtO32AUG
         bI4WERYXQ9DeGtNv1RpmEWgU1G2eSV/ayM68Z2EPMy2X2rpgTyq6Do8KuW7xvbKLNQ6K
         KrbreAkddfD9KuccRIXN4GJQMQQuvwSreJ76taMe27fH7Nagnoe6HN4WG3IahjESXdXG
         gWaw==
X-Gm-Message-State: AOAM531c9U0vnRatKxm0UYohIfWpfQQtSf+qxEzirDsdKKO4dz2hLqie
        Z+5Evzo+HmysXoDp6Nb/xP2FiP4338s=
X-Google-Smtp-Source: ABdhPJwV5BETtKCcxFQWK5P0KGO8i9sykZ84Ui0u3OoJwWlF8y3+lY3qi4V7zT1gjhyLngzG7WCF2w==
X-Received: by 2002:a05:6402:35cc:: with SMTP id z12mr61896976edc.393.1639386085596;
        Mon, 13 Dec 2021 01:01:25 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:48f9:bea:a04c:3dfe? ([2001:b07:6468:f312:48f9:bea:a04c:3dfe])
        by smtp.googlemail.com with ESMTPSA id h7sm6354080ede.40.2021.12.13.01.01.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 01:01:25 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <7de6b755-3cf9-4d1c-11e8-3458e6764545@redhat.com>
Date:   Mon, 13 Dec 2021 10:01:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 10/19] kvm: x86: Emulate WRMSR of guest IA32_XFD
Content-Language: en-US
To:     "Liu, Jing2" <jing2.liu@intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Cc:     "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jing2.liu@linux.intel.com" <jing2.liu@linux.intel.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-11-yang.zhong@intel.com>
 <fd16797c-b80f-c414-a731-0b9b73a3732e@redhat.com>
 <MWHPR11MB1245F7730D9BF0DA251D302DA9749@MWHPR11MB1245.namprd11.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <MWHPR11MB1245F7730D9BF0DA251D302DA9749@MWHPR11MB1245.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/13/21 08:51, Liu, Jing2 wrote:
> On 12/11/2021 12:02 AM, Paolo Bonzini wrote:
>>
>> Also:
>>
>> On 12/8/21 01:03, Yang Zhong wrote:
>>>
>>> +		if (!guest_cpuid_has(vcpu, X86_FEATURE_XFD))
>>> +			return 1;
>>
>> This should allow msr->host_initiated always (even if XFD is not part of
>> CPUID).
> Thanks Paolo.
> 
> msr->host_initiated handling would be added in next version.
> 
> I'd like to ask why always allow msr->host_initiated even if XFD is not part of
> CPUID, although guest doesn't care that MSR?  We found some MSRs
>   (e.g. MSR_AMD64_OSVW_STATUS and MSR_AMD64_OSVW_ID_LENGTH )
> are specially handled so would like to know the consideration of allowing
> msr->host_initiated.
> 
> if (!msr_info->host_initiated && !guest_cpuid_has(vcpu, X86_FEATURE_XFD))
>          return 1;

Because it's simpler if userspace can just take the entire list from 
KVM_GET_MSR_INDEX_LIST and pass it to KVM_GET/SET_MSR.  See for example 
vcpu_save_state and vcpu_load_state in 
tools/testing/selftests/kvm/lib/x86_64/processor.c.

>>  However, if XFD is nonzero and kvm_check_guest_realloc_fpstate
>> returns true, then it should return 1.
>
> If XFD is nonzero, kvm_check_guest_realloc_fpstate() won't return true. So
> may not need this check here?

It can't for now, because there's a single dynamic feature, but here:

+	if ((xfd & xcr0) != xcr0) {
+		u64 request = (xcr0 ^ xfd) & xcr0;
+		struct fpu_guest *guest_fpu = &vcpu->arch.guest_fpu;
+
+		/*
+		 * If requested features haven't been enabled, update
+		 * the request bitmap and tell the caller to request
+		 * dynamic buffer reallocation.
+		 */
+		if ((guest_fpu->user_xfeatures & request) != request) {
+			vcpu->arch.guest_fpu.realloc_request = request;
+			return true;
+		}
+	}

it is certainly possible to return true with nonzero XFD.

Paolo
