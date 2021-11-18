Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F0C455E5E
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 15:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbhKROlp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 09:41:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41059 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229957AbhKROlo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 09:41:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637246323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CRQoJO+AcQGP2FqOYnaDKbQVEGRVzlVuSSKNk+R736s=;
        b=EW88W7TUbiaZkwiD3P3i6oEW2YQEmP3V43liUV2iyvXH5hD7vRbKTl8X4mrf/nku3qo8Yf
        fPmlOLlvb85JWrFnC6ME1ele0wUXFcDMy6jOfcXVpYwEFkB7O5tOQ9fJGDf1w2yp6vZ+P6
        ljb8IuVbz9SIcK1puhcoUxA9oAQ58pA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-196-GtsSBbZNMqaG2tAzcJc_zw-1; Thu, 18 Nov 2021 09:38:38 -0500
X-MC-Unique: GtsSBbZNMqaG2tAzcJc_zw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B36E1006AA3;
        Thu, 18 Nov 2021 14:38:36 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2CACE5F4ED;
        Thu, 18 Nov 2021 14:38:32 +0000 (UTC)
Message-ID: <42820429-f09d-2576-50c4-5ecb74f49891@redhat.com>
Date:   Thu, 18 Nov 2021 15:38:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 02/15] KVM: VMX: Avoid to rdmsrl(MSR_IA32_SYSENTER_ESP)
Content-Language: en-US
To:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20211118110814.2568-1-jiangshanlai@gmail.com>
 <20211118110814.2568-3-jiangshanlai@gmail.com>
 <94d4b7d8-1e56-69e9-dd52-d154bee6c461@redhat.com>
 <e2c646a1-7e02-5dc5-0f02-1b4247772a69@linux.alibaba.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <e2c646a1-7e02-5dc5-0f02-1b4247772a69@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/18/21 15:17, Lai Jiangshan wrote:
> 
> The change in vmx_vcpu_load_vmcs() handles only the percpu constant case:
> (cpu_entry_stack(cpu) + 1), it doesn't handle the case where
> MSR_IA32_SYSENTER_ESP is NULL.
> 
> The change in vmx_set_constant_host_state() handles the case where
> MSR_IA32_SYSENTER_ESP is NULL, it does be constant host state in this case.
> If it is not the case, the added code in vmx_vcpu_load_vmcs() will override
> it safely.
> 
> If an else branch with "vmcs_writel(HOST_IA32_SYSENTER_ESP, 0);" is 
> added to
> vmx_vcpu_load_vmcs(), we will not need to change 
> vmx_set_constant_host_state().

We can change vmx_set_constant_host_state to write 0.

Paolo

