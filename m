Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A5E4723B8
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 10:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233698AbhLMJYS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 04:24:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbhLMJYS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 04:24:18 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA6DC061574;
        Mon, 13 Dec 2021 01:24:17 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id r11so49248730edd.9;
        Mon, 13 Dec 2021 01:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HLW76J5PEt7J1GoBBihVAIt4TiNO//XHYLno2t/6AgY=;
        b=T5r6cMZeAzaEuvEcgMjQ/OhrBwnvuOL0g+wzytDrGuYHD1Gv1ENPbpgZ1YJtUCyoJh
         y3gH6LR3OlJYLG15hIi/xbvbaPv3iqyTE5P2AQ4sI7qF/Al9Vdgxd0DZrasGuPlmouxn
         jkwDR9VMnYn1rJiRVyhQy1o5ES+dcZwRAlFkfakRw27UKv7z27p0HI070EWIaG9kEKmw
         1Q0G7O11Cg2FR88wHlI7YIlszr0DPIUUFauuudA8NKJj3sVj0JK6Pgg4gQfCz+ZlWvhd
         7/iaQ3FpdXBQEU/STS1Ge3MgNg0DvZbS8G3g15xn1P7ueTT9h29Z+LWJ6bZhLdY7Uj1r
         S4uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HLW76J5PEt7J1GoBBihVAIt4TiNO//XHYLno2t/6AgY=;
        b=vdIGqfcs0eVz9oKCfgeKBL4rDj119OW7CPMELgfMOdWaSb9zXErOvotdxGJo47VdhC
         dlYWnS9TzAsCztA9BkJo9jMPXa4c/g6lFpSjQ2FJgv/EvrhY93tNMqVO3BKZLPZ1snMX
         aNvfv4pj0Z+X4kOPXKiIfS8EgSDEkof0jqGhK1vZR6UDNrZpWX/gHUyaLUwsrv46znWr
         B18kg8NJGlMB7XopgoOpgGBVEUy7d5s1F6x5Cb98VVugj+R8BCBeB7tT/wz6IebU+lYA
         d0InPqNQVw+SRJPd+r281VOercFnz8DLJE8DKl2uLq8aorDLnSMj69lQPylSIUwJr2ah
         MLdw==
X-Gm-Message-State: AOAM532XzOoOyNBbiUAidIrf0k+sVyXdCbKQ70cHxWBX5nH5YXLaUOVJ
        e1EFRLkTwnYGZ/3KcGwI1IA=
X-Google-Smtp-Source: ABdhPJw1mv60R5U4YGc2UhrCcfpfO47LPupZm/36HMjS9nQOEKQ8OowZWI2YzBNywiMrbd0EQnC/VA==
X-Received: by 2002:a17:907:1b0d:: with SMTP id mp13mr42278055ejc.29.1639387456334;
        Mon, 13 Dec 2021 01:24:16 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:48f9:bea:a04c:3dfe? ([2001:b07:6468:f312:48f9:bea:a04c:3dfe])
        by smtp.googlemail.com with ESMTPSA id p4sm1707031eju.98.2021.12.13.01.24.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 01:24:15 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <bdda79b5-79e4-22fd-9af8-ec6e87a412ab@redhat.com>
Date:   Mon, 13 Dec 2021 10:24:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 16/19] kvm: x86: Introduce KVM_{G|S}ET_XSAVE2 ioctl
Content-Language: en-US
To:     "Wang, Wei W" <wei.w.wang@intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Cc:     "seanjc@google.com" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jing2.liu@linux.intel.com" <jing2.liu@linux.intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-17-yang.zhong@intel.com>
 <d16aab21-0f81-f758-a61e-5919f223be78@redhat.com>
 <26ea7039-3186-c23f-daba-d039bb8d6f48@redhat.com>
 <86d3c3a5d61649079800a2038370365b@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <86d3c3a5d61649079800a2038370365b@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/13/21 09:23, Wang, Wei W wrote:
> On Saturday, December 11, 2021 6:13 AM, Paolo Bonzini wrote:
>>
>> By the way, I think KVM_SET_XSAVE2 is not needed.  Instead:
>>
>> - KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2) should return the size of the
>> buffer that is passed to KVM_GET_XSAVE2
>>
>> - KVM_GET_XSAVE2 should fill in the buffer expecting that its size is
>> whatever KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2) passes
>>
>> - KVM_SET_XSAVE can just expect a buffer that is bigger than 4k if the
>> save states recorded in the header point to offsets larger than 4k.
> 
> I think one issue is that KVM_SET_XSAVE works with "struct kvm_xsave" (hardcoded 4KB buffer),
> including kvm_vcpu_ioctl_x86_set_xsave. The states obtained via KVM_GET_XSAVE2 will be made
> using "struct kvm_xsave2".
> 
> Did you mean that we could add a new code path under KVM_SET_XSAVE to make it work with
> the new "struct kvm_xsave2"?

There is no need for struct kvm_xsave2, because there is no need for a 
"size" argument.

- KVM_GET_XSAVE2 *is* needed, and it can expect a buffer as big as the 
return value of KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2)

- but KVM_SET_XSAVE2 is not needed, because KVM_SET_XSAVE can use 
copy_from_user to read the XSTATE_BV, use it to deduce the size of the 
buffer, and use copy_from_user to read the full size of the buffer.

For this to work you can redefine struct kvm_xsave to

	struct kvm_xsave {
		__u32 region[1024];

		/*
		 * KVM_GET_XSAVE only uses 4096 bytes and only returns
		 * user save states up to save state 17 (TILECFG).
		 *
		 * For KVM_GET_XSAVE2, the total size of region + extra
		 * must be the size that is communicated by
		 * KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2).
		 *
		 * KVM_SET_XSAVE uses the extra field if the struct was
		 * returned by KVM_GET_XSAVE2.
		 */
		__u32 extra[];
	}

Paolo
