Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E14D4279554
	for <lists+kvm@lfdr.de>; Sat, 26 Sep 2020 02:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729493AbgIZAE6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 20:04:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36005 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729424AbgIZAE6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 20:04:58 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601078696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g/jVyKCHdiUdwT2omZ/si8Q+ldjywRkoeikE7XbBhZc=;
        b=OLqbmHSI04JA4+EfbYL4y/xFlN6ycwYbpUP5twsgnZJoSMWwPBwelq13oLQKWiEUOXDUXx
        iuF0D97sGla5C8FOKJjTHvSwH3eRNmbsdwAuQ2dOVhIPdK2w1yLu0cR2VmIG7pbpnGM+ex
        gVUbaD+/MPQDu7ccThgracyRA/ymqx0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-32h5coQEO9G-RmMdmVNGfA-1; Fri, 25 Sep 2020 20:04:52 -0400
X-MC-Unique: 32h5coQEO9G-RmMdmVNGfA-1
Received: by mail-wm1-f71.google.com with SMTP id b14so282486wmj.3
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 17:04:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g/jVyKCHdiUdwT2omZ/si8Q+ldjywRkoeikE7XbBhZc=;
        b=HWltCG4IBrO6aj4e9/2z/FAZuIsSSx/g+1ypkdYmDWyemHc2+q23uWqWDsYoHV5ixo
         RVGkPdntfOj3gDIp2WT+4MAkvdABLPeDvrNplT4NJcyST20ymBK89AT9FSWlfGQvwpsX
         fNPKpfwCWdrARcBDp9mq+pPmKJeT6Saunm2qspnch/25SW5Jh2jCSy50GBYfI2VPo9K7
         /sM2HXP0DtZ4Hr/YocbtK2r21HJmlD2eOTX3CFSNHmWfAQoWSlfvI18IOpybp6RQndiF
         GIv87F1j4cZxvKF/A/Il0eXpvXia9mQ/effBYErp14kJi7sF4cD0D16TimYRrW+N7CyQ
         yBVg==
X-Gm-Message-State: AOAM530m23R3PayLvxQLdoYl6Qy+9Xsu1MolzaU8pDTZz7rIFeiYKv1Z
        ijlt+xuISOItMC4OqZA+7yqLWMIHQ8qXUi+2+CMNIIpWygkhspdtMiJb33rk4jDBDIgkeIMLNhW
        mABpw573cNHGa
X-Received: by 2002:a7b:c76d:: with SMTP id x13mr92190wmk.10.1601078691400;
        Fri, 25 Sep 2020 17:04:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxGBAvaCNQErNJYTzJQEmRHf/xK2hlpdhyCQ11FDFXNkdVOeTXhZO7tNGmZibFBSirqsyw3DA==
X-Received: by 2002:a7b:c76d:: with SMTP id x13mr92180wmk.10.1601078691197;
        Fri, 25 Sep 2020 17:04:51 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id v4sm590254wml.46.2020.09.25.17.04.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 17:04:50 -0700 (PDT)
Subject: Re: [PATCH 02/22] kvm: mmu: Introduce tdp_iter
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-3-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9ebecd06-950c-e7ee-c991-94e63ecec4a2@redhat.com>
Date:   Sat, 26 Sep 2020 02:04:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200925212302.3979661-3-bgardon@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/20 23:22, Ben Gardon wrote:
>  EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
>  
> -static bool is_mmio_spte(u64 spte)
> +bool is_mmio_spte(u64 spte)
>  {
>  	return (spte & SPTE_SPECIAL_MASK) == SPTE_MMIO_MASK;
>  }
> @@ -623,7 +612,7 @@ static int is_nx(struct kvm_vcpu *vcpu)
>  	return vcpu->arch.efer & EFER_NX;
>  }
>  
> -static int is_shadow_present_pte(u64 pte)
> +int is_shadow_present_pte(u64 pte)
>  {
>  	return (pte != 0) && !is_mmio_spte(pte);
>  }
> @@ -633,7 +622,7 @@ static int is_large_pte(u64 pte)
>  	return pte & PT_PAGE_SIZE_MASK;
>  }
>  
> -static int is_last_spte(u64 pte, int level)
> +int is_last_spte(u64 pte, int level)
>  {
>  	if (level == PG_LEVEL_4K)
>  		return 1;
> @@ -647,7 +636,7 @@ static bool is_executable_pte(u64 spte)
>  	return (spte & (shadow_x_mask | shadow_nx_mask)) == shadow_x_mask;
>  }
>  
> -static kvm_pfn_t spte_to_pfn(u64 pte)
> +kvm_pfn_t spte_to_pfn(u64 pte)
>  {
>  	return (pte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
>  }

Should these be inlines in mmu_internal.h instead?

Paolo

