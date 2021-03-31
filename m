Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB2E3508AC
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 23:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhCaVAp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 17:00:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46301 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230284AbhCaVA1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 31 Mar 2021 17:00:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617224427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2LQqUVLUZYdl8RcTGPBOfvhnoH130Hf3/RpFvvu9duY=;
        b=LygfMteufjDOoCwfEYkC2x8VvYk8LX3FbgkDA1/Bs0ggKwf0rqgabZabBpNHe91pELQ7In
        cqLsUGBosN3suqR7TPJ4wYLbbkD7/VUhgWoRAV6w+oUkpai1uxWYEgUPqh9Et4+ADO6sFc
        LpFSpHgXv4MBAMEdWAF8IsBmCWncAYA=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-O1fyjCVpMg-z7FR27Dpq0Q-1; Wed, 31 Mar 2021 17:00:22 -0400
X-MC-Unique: O1fyjCVpMg-z7FR27Dpq0Q-1
Received: by mail-ej1-f69.google.com with SMTP id v27so1358746ejq.0
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 14:00:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2LQqUVLUZYdl8RcTGPBOfvhnoH130Hf3/RpFvvu9duY=;
        b=WMmvY3I1gfCqsvz/HeO6YKiAOUXEPGPpdstPhjzGG01jDN9vnqF6d6Y96tetOMBuxK
         veIHM1eEb3OrSX46SvxT1FNck6gdCTfjXeONFxYa8lomQHd98yDv1qVcXBvUu5sH9mZ7
         09BOaVApoh/RAQ8RiY3zPZXaIERYQusc4SfQGWnq4IsVUy9pOVYHMZEzKnPwPyZAG98w
         m/VimPH+XZI9LgVfaQp62NCnJEFG9syFi4ZJE9tWlY9dPXNFYGwGKI4371v2HNm1ZOdA
         AA7H/PEaTBJrtMaQwaNHrtKhjLFefhXVfqdlNQ4v3s9Emp2S/djJs9JemQq6BacQZhdu
         n5Ng==
X-Gm-Message-State: AOAM531uLt3/a6HktY0wQRciCTVsUkZ8AGnit2GFx6SX+n8smhqlRzsp
        zCWsmb0z11xSAKGUdbKrNtb6E9GwrX+LAoGaunmOnahxKGzoN0YIyH8xam4WUlRHdeHfa9GeAyt
        +qotXfu7sgLQN
X-Received: by 2002:aa7:d3ca:: with SMTP id o10mr6104414edr.374.1617224421720;
        Wed, 31 Mar 2021 14:00:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw50R87T4Vu7z/jVciLQACACQ+dsOT5/iwXfrDvSvIyaxglINHwXnv99OCNOBQhJmcFA6BI0w==
X-Received: by 2002:aa7:d3ca:: with SMTP id o10mr6104376edr.374.1617224421543;
        Wed, 31 Mar 2021 14:00:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x21sm2291820eds.53.2021.03.31.14.00.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Mar 2021 14:00:20 -0700 (PDT)
Subject: Re: [PATCH 16/18] KVM: Don't take mmu_lock for range invalidation
 unless necessary
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-17-seanjc@google.com>
 <6e7dc7d0-f5dc-85d9-1c50-d23b761b5ff3@redhat.com>
 <YGTg/AWdieMM/mS7@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <60357fd0-d412-fe47-8023-8107a60ade7e@redhat.com>
Date:   Wed, 31 Mar 2021 23:00:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YGTg/AWdieMM/mS7@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/03/21 22:52, Sean Christopherson wrote:
> 100% agree with introducing on_lock separately from the conditional locking.
> 
> Not so sure about introducing conditional locking and then converting non-x86
> archs.  I'd prefer to keep the conditional locking after arch conversion.
> If something does go awry, it would be nice to be able to preciesly bisect to
> the conditional locking.  Ditto if it needs to be reverted because it breaks an
> arch.

Ok, that sounds good too.

Paolo

