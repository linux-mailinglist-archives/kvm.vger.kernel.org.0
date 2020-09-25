Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A44E627921C
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 22:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727651AbgIYUeM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 16:34:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36862 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729162AbgIYUdv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 16:33:51 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601066029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8CNcnb3n+KdyBOQho9S5pKb/zqoSoF9W9ked0uYAcmc=;
        b=dChX87IZWe+8pvgcLwUpKa37/HgOWs4U61MjnU5WJnoMDmLZw9ILtGhk/N+gPu2thEy5qg
        F+JZCYZ7oEOwEvc2ccP2cO+DGXIkpKN9ZW0kYuBP//kFCQzs3AZBwV2sbWbKbnVwxi2F9I
        t6dXOBiOesaIU3mEBbRT6OA6DBcVzwQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-0UDJLz6QPUG1RKME4A2fSg-1; Fri, 25 Sep 2020 16:32:43 -0400
X-MC-Unique: 0UDJLz6QPUG1RKME4A2fSg-1
Received: by mail-wr1-f71.google.com with SMTP id h4so1533691wrb.4
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 13:32:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8CNcnb3n+KdyBOQho9S5pKb/zqoSoF9W9ked0uYAcmc=;
        b=aaDh1wkGOI1RCW2tRygwjNnGi5RWmu1TTu0sK4rGuD+ctQrsX261FQQw1juyTTcJvj
         9pwESNoxqNcjY9c3u11dXTxmTcf/ILAPpy10OZB9FOG6pv8XKLYQIes6y2g25QHw89BX
         TGo7JK1LGI5LnXVhgILUEMXyDQQs1EIPyLsQw1qPog6F01GPJZmmVtn0smhT7u0dEJzx
         g6XO8z7VGXDaQRCMBlPNptx4YmR8d5dg8wjY7Fn2KvkBW35uwniwFPQ3jBoui7HdGMVJ
         vks1X5+bLH/gvvMufOhOE2hj3AlY60Eb0fse+7aznbDFZT14s9NPmVO2tRR0MZAe5YdJ
         ZuVQ==
X-Gm-Message-State: AOAM533RADPhbniCbG6VLUBY/quPsMxL1l7Hv8NRRPCLsQDvvEGlt2uf
        Etl2XNUCZ+j0UKppq70jhadkDcp/VW8lfeI8Qu6Nlla+FjJSx7EV36eM4urbOl/8X1+UoeJjjJX
        paa5sxrEv4R8X
X-Received: by 2002:adf:b306:: with SMTP id j6mr6018633wrd.279.1601065962222;
        Fri, 25 Sep 2020 13:32:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxnkK9zsMt/7q2uPxgua54UuDtFWZMx1WmAZOktl7Tyb51oYojKEWN52KhVGGR41w6kV4Hn/Q==
X-Received: by 2002:adf:b306:: with SMTP id j6mr6018616wrd.279.1601065962004;
        Fri, 25 Sep 2020 13:32:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id b187sm190321wmb.8.2020.09.25.13.32.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 13:32:40 -0700 (PDT)
Subject: Re: [PATCH v2 4/7] KVM: x86: hyper-v: always advertise
 HV_STIMER_DIRECT_MODE_AVAILABLE
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jon Doron <arilou@gmail.com>, linux-kernel@vger.kernel.org
References: <20200924145757.1035782-1-vkuznets@redhat.com>
 <20200924145757.1035782-5-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ded79131-bef1-cb56-68ca-d2bc596a4425@redhat.com>
Date:   Fri, 25 Sep 2020 22:32:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200924145757.1035782-5-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/20 16:57, Vitaly Kuznetsov wrote:
> HV_STIMER_DIRECT_MODE_AVAILABLE is the last conditionally set feature bit
> in KVM_GET_SUPPORTED_HV_CPUID but it doesn't have to be conditional: first,
> this bit is only an indication to userspace VMM that direct mode stimers
> are supported, it still requires manual enablement (enabling SynIC) to
> work so no VMM should just blindly copy it to guest CPUIDs. Second,
> lapic_in_kernel() is a must for SynIC. Expose the bit unconditionally.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/hyperv.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 6da20f91cd59..503829f71270 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -2028,13 +2028,7 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  			ent->ebx |= HV_DEBUGGING;
>  			ent->edx |= HV_X64_GUEST_DEBUGGING_AVAILABLE;
>  			ent->edx |= HV_FEATURE_DEBUG_MSRS_AVAILABLE;
> -
> -			/*
> -			 * Direct Synthetic timers only make sense with in-kernel
> -			 * LAPIC
> -			 */
> -			if (lapic_in_kernel(vcpu))
> -				ent->edx |= HV_STIMER_DIRECT_MODE_AVAILABLE;
> +			ent->edx |= HV_STIMER_DIRECT_MODE_AVAILABLE;
>  
>  			break;
>  
> 

Sorry for the late reply.  I think this is making things worse.  It's
obviously okay to add a system KVM_GET_SUPPORTED_HV_CPUID, and I guess
it makes sense to have bits in there that require to enable a
capability.  For example, KVM_GET_SUPPORTED_CPUID has a couple bits such
as X2APIC, that we return even if they require in-kernel irqchip.

For the vCPU version however we should be able to copy the returned
leaves to KVM_SET_CPUID2, meaning that unsupported features should be
masked.

Paolo

