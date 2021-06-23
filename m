Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4D43B1F4B
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 19:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhFWRU6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 13:20:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49631 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229831AbhFWRU5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 13:20:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624468719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6avEDBgEg/m6epnbR31G0pmFV1cXbC29MU0UeyyuH4I=;
        b=RgXTjOGxB6OPhCZsXN1OApL/GYftXYA+0vkUneX2TaDNL90accdND8LQ7bBhohAmKEmd5s
        DI8Xabj6LBlgI812ypuUHSqCEWPb/vBtt9R8E6jgHbKO4atnYQVzmgAzIHCYFtEip8bAp9
        QouK37B41Zbblu45BJz1Ga0L70KQbpc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-XBGOHbNZPVuQx_Ac3fDwRQ-1; Wed, 23 Jun 2021 13:18:36 -0400
X-MC-Unique: XBGOHbNZPVuQx_Ac3fDwRQ-1
Received: by mail-ed1-f71.google.com with SMTP id v8-20020a0564023488b0290393873961f6so1693666edc.17
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 10:18:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6avEDBgEg/m6epnbR31G0pmFV1cXbC29MU0UeyyuH4I=;
        b=AYvwQk8rvxQh7c211lAEWktgeKYBphhJ9KIRNjmzL2P5LRNaZ72UJd/f5Sb1KV+1f3
         B56H4sNuJNO6ro1y0Om9lslL6brs4lj+CCbYM442e6sjZFc0XkF1PsYGR8q6abgEGwUD
         Rym8oH4q4TnQ7MeuWv0Qk+uQWUoBa4GoFgT5uC0qhum9ODZ7hFKAvQ0l5qMVnPS0abIJ
         RAy64lfcD9AaWhY/mRtL/Not6v42oPCryeSwgXiawet95QgW5cFpaJmGu3541zvzfzkx
         iQj6alh83ryb9fyJxOvQTF1mInzIDbtreppXWSDLTjafQWaJjww6l32kAlktmI15ZouU
         VXcw==
X-Gm-Message-State: AOAM531llTYOIrk3LESs+EEa35z31UoQqaABSfxXZJC6VnqpO5RFju9Z
        7zGNdPrNfQlYKlo06JdsnWlZssNDF5NphQwSDfqLrrN1iOTgjHfoUmf9BnpJu0O4X7GWHej6+nU
        NOG54YM9QSkKh
X-Received: by 2002:a17:907:6fd:: with SMTP id yh29mr1168042ejb.432.1624468715232;
        Wed, 23 Jun 2021 10:18:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyzz2Z2ugg1KGq4OmFuDAXL2mGlkfLATWN6gvMvTiBP+rn9k965qo/kW3qBks/ZBZ+QfZ8PyQ==
X-Received: by 2002:a17:907:6fd:: with SMTP id yh29mr1168025ejb.432.1624468715091;
        Wed, 23 Jun 2021 10:18:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n13sm380399edx.30.2021.06.23.10.18.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 10:18:34 -0700 (PDT)
Subject: Re: [PATCH 20/54] KVM: x86/mmu: Add struct and helpers to retrieve
 MMU role bits from regs
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-21-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7e1a0bb6-cd73-70c7-0b94-4a52f5b04577@redhat.com>
Date:   Wed, 23 Jun 2021 19:18:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210622175739.3610207-21-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/21 19:57, Sean Christopherson wrote:
> +/*
> + * Yes, lot's of underscores.  They're a hint that you probably shouldn't be
> + * reading from the role_regs.  Once the mmu_role is constructed, it becomes
> + * the single source of truth for the MMU's state.
> + */
> +#define BUILD_MMU_ROLE_REGS_ACCESSOR(reg, name, flag)			\
> +static inline bool ____is_##reg##_##name(struct kvm_mmu_role_regs *regs)\
> +{									\
> +	return !!(regs->reg & flag);					\
> +}

Ok, that's a decent reason to have these accessors in the first place. :)

Paolo

