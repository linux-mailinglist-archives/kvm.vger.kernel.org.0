Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305E049D0A8
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 18:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237147AbiAZRXe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 12:23:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiAZRXc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 12:23:32 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F8AC06161C;
        Wed, 26 Jan 2022 09:23:32 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id k18so206185wrg.11;
        Wed, 26 Jan 2022 09:23:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=V0Tp1GHHecUi/P4l2E9yO+GMXfgnTyE6j4Sd+guldZs=;
        b=b3BDIRCil9T9ZDhSv45ih/ZPe1l6qgT2LuWBqoLTgaOUBz4yEfEXvR3ubcvBZelIz1
         ubY3XJVpkUXsrnLgqj0a27BnBOFsu9osesEptKM6a16oMZpMSP8jMO3ik0h9SLI5cBPi
         OWkZr9mlnifMg2H0npgLaVf1FGwwQI7yNTKKb2Ib8k/kVBTtJLXUiI4XwjL5pMB8yAb9
         xcJgigsdZbZB+2qDgQqZ5vftMBdQaGe3T+xMH+NGU094Rwn1WtYFUwzE71L/B5+OZtZV
         ZvS3ycz81BmzAi4lmhT8NR01dZdyd5tcHtBzkOWau81sdLXQbCboxuHponxTrglCplb+
         sHLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=V0Tp1GHHecUi/P4l2E9yO+GMXfgnTyE6j4Sd+guldZs=;
        b=uLePghoA/ZZAG9NSX9NW2HkCOA4OQBGoc2rPmo4WzeJm5VNTKCLPQMvERYmlFhupT+
         oVKiZ0tNWlJUB84p5r55ZxdrfokXwBNcuro6rM8VFRfgiUPQcycbcbAqnBlXjxkKH2ro
         wEqFEc4VEGMTbndEO8ccBfUVjj/ZwjPgzPqr73qFlpwYXiQvOeFwGy8K0n+b5g+yE5Op
         WV+SCl4T0sOJ2wKGarWAWf+3fBXeYtWFapTqlkPhKOd3qoAFFuvai+IVtNL7wc58sKRb
         uMOaMUJBymV+4VU8nVXZZDniwCsgiuKSuvbOnkrlK9J/oVZvkSFuEibT4b/WRvMOhdRf
         XrSw==
X-Gm-Message-State: AOAM532GOUK70qqvo3+rGBB9AnF8UJO1Ux4nPxU8s+dHoBgZJYOxyTpw
        2ER10gK+fIndikf6nhmLbIE=
X-Google-Smtp-Source: ABdhPJyUGT6cmmBLvD2d7e1C35Ip1UeTxiYVLX4XhgDDbLr7mgXII1Y8s38ffNbkAuVdFqaJYU3wtw==
X-Received: by 2002:adf:f249:: with SMTP id b9mr22627050wrp.623.1643217810791;
        Wed, 26 Jan 2022 09:23:30 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id t1sm7826436wre.45.2022.01.26.09.23.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 09:23:30 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <40d65efe-69dc-f1d6-b26c-a5cd243002a6@redhat.com>
Date:   Wed, 26 Jan 2022 18:23:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: x86: skip host CPUID call for hypervisor leaves
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220120175015.1747392-1-pbonzini@redhat.com>
 <87r191jqh9.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87r191jqh9.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/21/22 12:08, Vitaly Kuznetsov wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
> 
>> Hypervisor leaves are always synthesized by __do_cpuid_func.  Just return
>> zeroes and do not ask the host, it would return a bogus value anyway if
>> it were used.
> 
> Why always bogus? Nested virtualization is a thing, isn't it? :-) It
> is, however, true that __do_cpuid_func() will throw the result away.

Well, bogus because all hypercalls and MSRs would go through us so it 
makes little if any sense (given the current hypercall and MSR code) for 
the host values to be used in KVM_GET_SUPPORTED_CPUID.

> FWIW, 0x40000XXX leaves are not the only ones where we don't use
> do_host_cpuid() result at all, e.g. I can see that we also return
> constant values for 0x3, 0x5, 0x6, 0xC0000002 - 0xC0000004.
> 
> Out of pure curiosity, what's the motivation for the patch? We seem to
> only use __do_cpuid_func() to serve KVM_GET_SUPPORTED_CPUID/KVM_GET_EMULATED_CPUID,
> not for kvm_emulate_cpuid() so these few CPUID calls we save here should
> not give us any performace gain..

I just have it in queue because of another change that I have not 
submitted yet.

Paolo

>> +
>> +	default:
>> +		break;
>> +	}
>>   
>>   	cpuid_count(entry->function, entry->index,
>>   		    &entry->eax, &entry->ebx, &entry->ecx, &entry->edx);
> 
> The patch seems to be correct, so
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 

