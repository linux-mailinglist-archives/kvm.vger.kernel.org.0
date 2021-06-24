Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037B13B2CB0
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 12:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbhFXKp4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 06:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232253AbhFXKpy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 06:45:54 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09BA0C061574;
        Thu, 24 Jun 2021 03:43:36 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id pf4-20020a17090b1d84b029016f6699c3f2so5658934pjb.0;
        Thu, 24 Jun 2021 03:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=Ntmvbr4Rsn/lopxAADIIDgcNErNmU/zbadQcByBiYK4=;
        b=Uzc43caEhY2Ti31+lpHHW0AZ5sLCVj6W+n4t/ez5IgVzQkVZOibK2DIWQ0+CAuzt9U
         PpuIA4kDsyK3chDvHhxE+YawXhAPb2eWGecCvYilJeif5bW1AWaPBDm7W4vYjxTYq4eX
         vsAbVyUYfQJDK46zRrnjfoRU3RdSuUfndWfij+20vPjPzE9a8Ky+gzwBiWuGHYujrH97
         b1g8G9j+MqQ6oKRgvSqRRvZdf9oww+7IytooiBQtjKLAdCQfMAXpO/dc/FMWyHkr12JS
         ZqabhMCopqc94H8G+WPpptqvIqeO4Wfi2qlPKFQXomh5RWpLJ4WGRgIbJ4SL7OebaZ9b
         Cu7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=Ntmvbr4Rsn/lopxAADIIDgcNErNmU/zbadQcByBiYK4=;
        b=eFyxICiHRI7bWqzwL/86eToP3VqrqX/XH9cZ9pfZrrc4HrpvyX09PGs8Q8iZakxK5f
         OcAmkDRzYGQ1t558DgOX3HCKGbdKme0AvcZa2nNJPsc9vdohgZqBBc6W2agfv4k5xgAh
         Nsq+Pb2vYB+D48bJv2fb/51+mcVVJUrS+sUZcq4XM0z/nYqFc9ocphXL6N1bZLiIjeZW
         iZYA1EXhGC8lB16+tNZrn+E4r0xA1tHHehrfzoLo/2wbpaGXE0llHEX2QANsTCFlnjiG
         ueYZTCItJ1vIbycJ6plOilans8J3qBidR9lPHVIT6F37GO5n6y8PhsDeUEJBHU+VeRuj
         3SgA==
X-Gm-Message-State: AOAM531ugFbTbb8f5C74MnWI6Tc/L6Ak47WBDQB9gNY0dfn1iheLj8ML
        EQLKMUz856uli34pERus2Cc=
X-Google-Smtp-Source: ABdhPJwSbcPeLeFEknq5SPs1K9/7wAZ9//Y8XUJsBm0HOgxDXNJ+d8W1kIX2/TWCimMS0wf9W28w6Q==
X-Received: by 2002:a17:90a:ce87:: with SMTP id g7mr14492750pju.189.1624531415692;
        Thu, 24 Jun 2021 03:43:35 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id n12sm2540624pfu.5.2021.06.24.03.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 03:43:35 -0700 (PDT)
Date:   Thu, 24 Jun 2021 20:43:29 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 3/6] KVM: x86/mmu: avoid struct page in MMU
To:     Marc Zyngier <maz@kernel.org>
Cc:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        James Morse <james.morse@arm.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvmarm@lists.cs.columbia.edu,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Stevens <stevensd@chromium.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Will Deacon <will@kernel.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
References: <20210624035749.4054934-1-stevensd@google.com>
        <20210624035749.4054934-4-stevensd@google.com>
        <1624524744.2sr7o7ix86.astroid@bobo.none> <87mtrfinks.wl-maz@kernel.org>
In-Reply-To: <87mtrfinks.wl-maz@kernel.org>
MIME-Version: 1.0
Message-Id: <1624531381.4bht02wxsj.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Excerpts from Marc Zyngier's message of June 24, 2021 8:06 pm:
> On Thu, 24 Jun 2021 09:58:00 +0100,
> Nicholas Piggin <npiggin@gmail.com> wrote:
>>=20
>> Excerpts from David Stevens's message of June 24, 2021 1:57 pm:
>> > From: David Stevens <stevensd@chromium.org>
>> >  out_unlock:
>> >  	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
>> >  		read_unlock(&vcpu->kvm->mmu_lock);
>> >  	else
>> >  		write_unlock(&vcpu->kvm->mmu_lock);
>> > -	kvm_release_pfn_clean(pfn);
>> > +	if (pfnpg.page)
>> > +		put_page(pfnpg.page);
>> >  	return r;
>> >  }
>>=20
>> How about
>>=20
>>   kvm_release_pfn_page_clean(pfnpg);
>=20
> I'm not sure. I always found kvm_release_pfn_clean() ugly, because it
> doesn't mark the page 'clean'. I find put_page() more correct.
>=20
> Something like 'kvm_put_pfn_page()' would make more sense, but I'm so
> bad at naming things that I could just as well call it 'bob()'.

That seems like a fine name to me. A little better than bob.

Thanks,
Nick
