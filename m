Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0427279595
	for <lists+kvm@lfdr.de>; Sat, 26 Sep 2020 02:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728935AbgIZAcZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 20:32:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42794 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726149AbgIZAcZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 20:32:25 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601080343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GGED/SP06qDpxxhBcwD9SA9XdIHBfiiFTtiKfufvWL0=;
        b=e7sctZXbBitLnHWiNDFTxcd+fqxIxlUdJFR3d3Db1QoO6I3QLjU0vtb9igL4QplQ81xYdL
        hHzXLGgYMLF1HkA1UAJU24dKhw0IzR4OntSzLnFYIeoTu2Nn7biJo/ruc7dEHnF5Mx8guO
        vyheVlwWo5oo4uJhcOZUHjBog/3SXaA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-Yvn4AbSoP8eQLqNHYbS2UQ-1; Fri, 25 Sep 2020 20:32:21 -0400
X-MC-Unique: Yvn4AbSoP8eQLqNHYbS2UQ-1
Received: by mail-wr1-f72.google.com with SMTP id y3so1721577wrl.21
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 17:32:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GGED/SP06qDpxxhBcwD9SA9XdIHBfiiFTtiKfufvWL0=;
        b=C2+uHkPYtg45pmxxcn2RhpeMAH3xu0NSWYNvNB0FDd3mPn07qhtXUWNzSY/0FuxJ7h
         Quc9bGyIipYAicyqsytTziNMutQqh4mneCaIzzYoxjKYUcLxsJdvxM5GLxT8OMJtIBJq
         S7lwUq4j+PpjiKNy3l3RtyG/BBwE0ggg65lYC1ioJd+/xVCTTzbf/LLSm7u2w7g3C0YI
         Uj6pLkpAULTqgcQlt+vIWO31OYnffbws6RQSLE2aDBEt2WnESnNXibHSWVgR+00NCsCQ
         QCS3CG31b8+XijmoPFuaQKXdLn1Vf5/VKho519lweYGM/3iEYxMu3GyG9D4wPxHiDqV3
         Tgcw==
X-Gm-Message-State: AOAM5324pRe703FQdIQIYEnZzuLGbKILDxcgWy/6JvMJjresNsrQYYsQ
        IzPmYo/GIFlF3ExzJYuJLcc4tYyNvQObRi7BmSDeOYBGanRdiqo1peqhZZb3k102S02cPlu11vi
        Hr5McuRqt3wZ4
X-Received: by 2002:a1c:7714:: with SMTP id t20mr144581wmi.55.1601080340505;
        Fri, 25 Sep 2020 17:32:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwEvSQR1X+gcWu2eaDsj1njEoatXZVeek8n0YilAr8OsyMpskkzs898k3FWW0lDKy0KoCJplw==
X-Received: by 2002:a1c:7714:: with SMTP id t20mr144565wmi.55.1601080340270;
        Fri, 25 Sep 2020 17:32:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id h2sm4678148wrp.69.2020.09.25.17.32.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 17:32:19 -0700 (PDT)
Subject: Re: [PATCH 14/22] kvm: mmu: Add access tracking for tdp_mmu
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
 <20200925212302.3979661-15-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d7964716-8949-a4ac-93ce-a71f3aebbd12@redhat.com>
Date:   Sat, 26 Sep 2020 02:32:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200925212302.3979661-15-bgardon@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/20 23:22, Ben Gardon wrote:
> @@ -332,7 +331,7 @@ static inline bool kvm_vcpu_ad_need_write_protect(struct kvm_vcpu *vcpu)
>  	return vcpu->arch.mmu == &vcpu->arch.guest_mmu;
>  }
>  
> -static inline bool spte_ad_enabled(u64 spte)
> +inline bool spte_ad_enabled(u64 spte)
>  {
>  	MMU_WARN_ON(is_mmio_spte(spte));
>  	return (spte & SPTE_SPECIAL_MASK) != SPTE_AD_DISABLED_MASK;
> @@ -607,7 +606,7 @@ int is_last_spte(u64 pte, int level)
>  	return 0;
>  }
>  
> -static bool is_executable_pte(u64 spte)
> +bool is_executable_pte(u64 spte)
>  {
>  	return (spte & (shadow_x_mask | shadow_nx_mask)) == shadow_x_mask;
>  }
> @@ -791,7 +790,7 @@ static bool spte_has_volatile_bits(u64 spte)
>  	return false;
>  }
>  
> -static bool is_accessed_spte(u64 spte)
> +bool is_accessed_spte(u64 spte)
>  {
>  	u64 accessed_mask = spte_shadow_accessed_mask(spte);
>  
> @@ -941,7 +940,7 @@ static u64 mmu_spte_get_lockless(u64 *sptep)
>  	return __get_spte_lockless(sptep);
>  }
>  
> -static u64 mark_spte_for_access_track(u64 spte)
> +u64 mark_spte_for_access_track(u64 spte)
>  {
>  	if (spte_ad_enabled(spte))
>  		return spte & ~shadow_accessed_mask;

More candidates for inlining, of course.

Paolo

