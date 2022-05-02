Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA6245173BE
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 18:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241030AbiEBQKs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 12:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234025AbiEBQKq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 12:10:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 853AD55AF
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 09:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651507636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s70MT6Y6b+EWzPq4TYtvjBhW+c7gKt8WCUmst+yWMcA=;
        b=NOoPok6F3YLUvVYVKt0qwJG6RoU5PWdXFGSPb9ePPBDnF6dxQn3TlXsrV4i0w/NbtB6mG6
        +OHYXJTom6VrDI5UcXv0MxtAklLUkuXb6tgcBc3hFOe1xuxBvuh6eq80E3f76Cz0ieGcGQ
        +Raf/RLlEpAe0C5hcIlJSERBXN0UnZI=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-91pxlsGIPLqzX23KjoXRKw-1; Mon, 02 May 2022 12:07:15 -0400
X-MC-Unique: 91pxlsGIPLqzX23KjoXRKw-1
Received: by mail-ej1-f72.google.com with SMTP id nb10-20020a1709071c8a00b006e8f89863ceso7027297ejc.18
        for <kvm@vger.kernel.org>; Mon, 02 May 2022 09:07:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=s70MT6Y6b+EWzPq4TYtvjBhW+c7gKt8WCUmst+yWMcA=;
        b=kdHCN4EVaBuzFGlHe0OA3fBKLCbPkeukGaxM60MZm0FY039J+Zico/vjOmiH1NzY3j
         kwloWHXsCKW1z2VZaKrQFslX4w2NMWOCOWuREtSTs1TrbgGicMz6zmK6qSq35eSFpvx4
         F4on9jlql77vlj/DZeEKQtWheFaPfF/clCfR5KR9plABsD9s5S7WLMlCfRSj80t9MJ3E
         cWaOKEdFgHDYsNL7Tv7HbWUek9VX/D7Ao6+CVwf299EyCVh7ZyO+FbgABIsvWEMX0icJ
         vWXyxU2JoYPEU9lH7p8n6N33L+X9/qOF/M0Ws2TXm3i7h+ZUqRhl6vKc//7wuk1aYBs/
         uuOg==
X-Gm-Message-State: AOAM5323XlMeHAtvbokpEMGonnHGTmEy8MAzQxtI87NBSU7BTHrovzDx
        WBII/YpztKwxPvJP/Hk5glqLBEPgGbuXA42/+QZq3OJfb7JaZGVOGDoHsi81c6B3NX/BsN0rUsK
        yNmL7QJxQIO+q
X-Received: by 2002:a17:907:72d4:b0:6f4:7b2:1dea with SMTP id du20-20020a17090772d400b006f407b21deamr12049366ejc.532.1651507634269;
        Mon, 02 May 2022 09:07:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxHV9JQOzWXQ2/EuMLNL2Sk7plhApTBZcA1FAn/4yisC7DdLA+Ho0CT7zFqHqrSbD0Bufb/EQ==
X-Received: by 2002:a17:907:72d4:b0:6f4:7b2:1dea with SMTP id du20-20020a17090772d400b006f407b21deamr12049334ejc.532.1651507634023;
        Mon, 02 May 2022 09:07:14 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id zp1-20020a17090684e100b006f3ef214df0sm3710399ejb.86.2022.05.02.09.07.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 May 2022 09:07:13 -0700 (PDT)
Message-ID: <a06997fe-8dd7-e91a-2017-912827f554e7@redhat.com>
Date:   Mon, 2 May 2022 18:07:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v9 8/9] KVM: x86: Allow userspace set maximum VCPU id for
 VM
Content-Language: en-US
To:     Zeng Guang <guang.zeng@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>, Gao Chao <chao.gao@intel.com>
References: <20220419154444.11888-1-guang.zeng@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220419154444.11888-1-guang.zeng@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/19/22 17:44, Zeng Guang wrote:
> +Userspace is able to calculate the limit to APIC ID values from designated CPU
> +topology. This capability allows userspace to specify maximum possible APIC ID
> +assigned for current VM session prior to the creation of vCPUs. By design, it
> +can set only once and doesn't accept change any more. KVM will manage memory
> +allocation of VM-scope structures which depends on the value of APIC ID.
> +
> +Calling KVM_CHECK_EXTENSION for this capability returns the value of maximum APIC
> +ID that KVM supports at runtime. It sets as KVM_MAX_VCPU_IDS by default.

Better:

This capability allows userspace to specify maximum possible APIC ID
assigned for current VM session prior to the creation of vCPUs, saving
memory for data structures indexed by the APIC ID.  Userspace is able
to calculate the limit to APIC ID values from designated
CPU topology.

The value can be changed only until KVM_ENABLE_CAP is set to a nonzero
value or until a vCPU is created.  Upon creation of the first vCPU,
if the value was set to zero or KVM_ENABLE_CAP was not invoked, KVM
uses the return value of KVM_CHECK_EXTENSION(KVM_CAP_MAX_VCPU_ID) as
the maximum APIC ID.

>   	case KVM_CAP_MAX_VCPU_ID:
> -		r = KVM_MAX_VCPU_IDS;
> +		if (!kvm->arch.max_vcpu_ids)
> +			r = KVM_MAX_VCPU_IDS;
> +		else
> +			r = kvm->arch.max_vcpu_ids;

I think returning the constant KVM_CAP_MAX_VCPU_IDS is better.

Paolo

