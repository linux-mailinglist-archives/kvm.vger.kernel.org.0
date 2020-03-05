Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87FA717A8CD
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 16:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgCEPZg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 10:25:36 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27515 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726390AbgCEPZg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Mar 2020 10:25:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583421935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vy5/EiEAp0wCHefyZwq4zlhiKyPciLoRoXRp/gwmNyU=;
        b=IbuNu3uLB97iMmC6KF4ifFqQq13NatV+OQjJYrlroJ5nvad9WPkOCS6+rPfGk3HXUALP7X
        L6xrqme3uBaOEbiHjrv/BHq8fUC80t+7QHVxUw0X5ujsu1KpbiikLU1WNghxT7YkStXDTI
        z0R6rv8e2z4FPiwCi/uJlqZrrAwfPTU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-mtyEnOm3NF-jnugvLieUsw-1; Thu, 05 Mar 2020 10:25:34 -0500
X-MC-Unique: mtyEnOm3NF-jnugvLieUsw-1
Received: by mail-wr1-f70.google.com with SMTP id w18so2456736wro.2
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 07:25:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vy5/EiEAp0wCHefyZwq4zlhiKyPciLoRoXRp/gwmNyU=;
        b=phBhlQ8UVd3lTAYLxyGaLhOKgG4+Nqiz6y9OQN3bnsLF+Rntbe/Ak/5iwBLHgPWUOD
         7rVSiuq8THYjPGDw7iKhSpzIFTdQ22TAAAHLkQOc2a3PbTUWnBFivxSyKgJBmS5nDPTD
         0qJVbgIczSnRhaObV3KricLOvdtlApBNIhiLzqKj+qXxedliQr2k2CR5aA4MkhIELOGL
         HovdfNB9E5qnT1qMsxL8kolqBZe6H2H0cjjTuDV8OslsOM2TqUn6Axoe08/+RAd/CM7Q
         MT39hHQx1A0zPh13lzKAPAIEIL7mTTBSGjpJST8cg9+s0yWe3I/ZhTGCujmyCw+7j3Zt
         Tw3A==
X-Gm-Message-State: ANhLgQ1Dmiszm8ewfKo5v62wqqmQ5N8uZ0Jh4fybadMDtodGDGE+31k2
        3WZBk87CBlALWHvYbGUc4KsGD+2Y8E46kPyHlhOe9TGUdU7lXW/6z8dpwupw9Se3AwVkCouitWx
        GuWulS/5WWwRQ
X-Received: by 2002:a7b:cb46:: with SMTP id v6mr10012831wmj.0.1583421931388;
        Thu, 05 Mar 2020 07:25:31 -0800 (PST)
X-Google-Smtp-Source: ADFU+vtQWnJAQ64di79lN3HKkN0FhLCIQPUPAt48JNuzax0K/0I7UfpL5czy4vwD/j2Yo0yF954fWw==
X-Received: by 2002:a7b:cb46:: with SMTP id v6mr10012811wmj.0.1583421931138;
        Thu, 05 Mar 2020 07:25:31 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:9def:34a0:b68d:9993? ([2001:b07:6468:f312:9def:34a0:b68d:9993])
        by smtp.gmail.com with ESMTPSA id b24sm9503524wmj.13.2020.03.05.07.25.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2020 07:25:30 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: small optimization for is_mtrr_mask calculation
To:     David Laight <David.Laight@ACULAB.COM>,
        linmiaohe <linmiaohe@huawei.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
References: <1583376535-27255-1-git-send-email-linmiaohe@huawei.com>
 <2b678644-fcc0-e853-a53c-2651c1f6a327@redhat.com>
 <dc1870b0ea164015b1c1b6bc4d3248fe@AcuMS.aculab.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2129995e-3441-f362-aed1-7c247189c136@redhat.com>
Date:   Thu, 5 Mar 2020 16:25:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <dc1870b0ea164015b1c1b6bc4d3248fe@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/03/20 16:10, David Laight wrote:
>>>  	index = (msr - 0x200) / 2;
>>> -	is_mtrr_mask = msr - 0x200 - 2 * index;
>>> +	is_mtrr_mask = (msr - 0x200) % 2;
>>>  	cur = &mtrr_state->var_ranges[index];
>>>
>>>  	/* remove the entry if it's in the list. */
>>> @@ -424,7 +424,7 @@ int kvm_mtrr_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
>>>  		int is_mtrr_mask;
>>>
>>>  		index = (msr - 0x200) / 2;
>>> -		is_mtrr_mask = msr - 0x200 - 2 * index;
>>> +		is_mtrr_mask = (msr - 0x200) % 2;
>>>  		if (!is_mtrr_mask)
>>>  			*pdata = vcpu->arch.mtrr_state.var_ranges[index].base;
>>>  		else
>>>
>> If you're going to do that, might as well use ">> 1" for index instead
>> of "/ 2", and "msr & 1" for is_mtrr_mask.
> Provided the variables are unsigned it makes little difference
> whether you use / % or >> &.
> At least with / % the two values are the same.

Yes, I'm old-fashioned, but also I prefer ">>" and "&" for both signed
and unsigned, because if ever I need to switch from unsigned to signed I
will get floor-division instead of round-to-zero division (most likely
the code doesn't expect negative remainders if it was using unsigned).

(That perhaps also reflects on me working a lot with Smalltalk long
before switching to the kernel...).

Paolo

