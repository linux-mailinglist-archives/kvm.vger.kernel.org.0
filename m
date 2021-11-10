Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7ED944C38E
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 16:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbhKJPEy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 10:04:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32707 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231593AbhKJPEy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Nov 2021 10:04:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636556526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qYakPG8m8nj7mUbHHgIj188615K8TQbntmqQ4hJteXU=;
        b=K6jKdZ7kVukyLYn1d/TEXZGY7Ybyp7fXTPmie4J20Pc9ukTeq4ktPuYW1WsTyOIPs3ewhK
        gPwkhaU2usabaKvyWuc4ozrkyyoNzXmVpdEduGcSergc/c9uqgO/uHPt+2SymMV/T/8JPk
        SqPQAdKxMzmJJK/ltbmyuNTZSo0fX0M=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-r1aWc9EpO62Z5_h0PTn_ug-1; Wed, 10 Nov 2021 10:01:59 -0500
X-MC-Unique: r1aWc9EpO62Z5_h0PTn_ug-1
Received: by mail-ed1-f72.google.com with SMTP id f20-20020a0564021e9400b003e2ad3eae74so2580171edf.5
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 07:01:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qYakPG8m8nj7mUbHHgIj188615K8TQbntmqQ4hJteXU=;
        b=qGIH0eXvng+Ej/7U15uZeyN9iIX6VpXiqecuVR8GeftLmbfHoi2N2nqTVoqIYSzukr
         1xgxtXxpEDyT3VQU1/5oKJ/lGBt2b807MT2/8rY+RuTOtBSroB2D5+dlJX+A0lUwfYQ8
         Oug4KcArpo0l9uB4bJBMQfUZO2QWtEd9zQxUiL2DSVjKgY8GYJv6xInAHvk9lMWquyML
         bOagZYXiiuk3Z0olahokWKrgEup9qYpz9KhiiIu6PTOgjlCNZONQJYlxpZ3BlP8BuJfW
         vDE42QrXvsgRm492Rs8JU54US53W5yvkVoEvynvBsdnR4psi6YJ7UxZ8HF3SWc0NAEkT
         xtMw==
X-Gm-Message-State: AOAM53393XPLh55dvEAfPHb2qZSm4pvkfe7iAvMhYIvvPwMjVzb9NtJC
        StPmR47uyAgLkIppwXnVgCym+3L6N0yFeFD+g8p1/aLSYWlr9ORmY9oEC+c2hKOAPJoI4rbWjDt
        pw9leKxZu21Js
X-Received: by 2002:a17:906:6c83:: with SMTP id s3mr281948ejr.13.1636556518416;
        Wed, 10 Nov 2021 07:01:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxvOjbPA69/eXXMSlLUDWi54zKelckxROYRUebWhGzQfts3OilQ4IdFnDoQ94kyo5jRzBnNOQ==
X-Received: by 2002:a17:906:6c83:: with SMTP id s3mr281910ejr.13.1636556518180;
        Wed, 10 Nov 2021 07:01:58 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id h7sm19403edt.37.2021.11.10.07.01.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 07:01:57 -0800 (PST)
Message-ID: <e6d4e268-da50-c55f-1485-f4a871afdff0@redhat.com>
Date:   Wed, 10 Nov 2021 16:01:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 2/3] KVM: nVMX: restore L1's EFER prior to setting the
 nested state
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>
References: <20211110100018.367426-1-mlevitsk@redhat.com>
 <20211110100018.367426-3-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211110100018.367426-3-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/10/21 11:00, Maxim Levitsky wrote:
> +	/*
> +	 * The vcpu might currently contain L2's IA32_EFER, due to the way
> +	 * some userspace kvm users (e.g qemu) restore nested state.
> +	 *
> +	 * To fix this, restore its IA32_EFER to the value it would have
> +	 * after VM exit from the nested guest.
> +	 *
> +	 */
> +
> +	vcpu->arch.efer = nested_vmx_get_vmcs12_host_efer(vcpu, vmcs12);
> +

In principle the value of LOAD_HOST_EFER on exit need not be the same as 
on entry.  But you don't need all of EFER, only EFER.LME/EFER.LMA, and 
those two bits must match ("the values of the LMA and LME bits in the 
field must each be that of the “host address-space size” VM-exit 
control" from the "Checks on Host Control Registers, MSRs, and SSP"; 
plus the "Checks Related to Address-Space Size").

At least it's worth adjusting the comment to explain that.  But the root 
cause of the issue is just nested_vmx_check_* accessing vcpu->arch.  So 
you can instead:

- split out of nested_vmx_check_host_state a new function 
nested_vmx_check_address_state_size that does

#ifdef CONFIG_X86_64
	if (CC(!!(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE) !=
	       !!(vcpu->arch.efer & EFER_LMA)))
		return -EINVAL;
#endif
	return 0;

- call it from vmentry but not from migration

- in nested_vmx_check_host_state, assign ia32e from 
vmcs12->vm_exit_controls instead of vcpu->arch.efer

Paolo

