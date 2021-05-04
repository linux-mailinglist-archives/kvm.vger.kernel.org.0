Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974E9373155
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 22:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbhEDUYA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 16:24:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51517 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231380AbhEDUX7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 May 2021 16:23:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620159783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LZKovbJ8lKtotNg9ShvdPO02WF5aXDGNpj87pCUgbWM=;
        b=acGWK4G6g2NXiHyfiPSFyeVyynJiXbRYWOkSN74PgCUxWNbK/PeEPgUU0zpKPf/onImLL8
        367ke7noPmRiHQjxpy9DLh7SZEHAu4a0dB9UvB/fhm+lVHcgFYIc9ZkGFtKHKd4O5DMnky
        65RPlKx3oiurh42ZVf+0s9I7lTuHZhE=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-vDoheUEXMeKFJUm6S5HgsQ-1; Tue, 04 May 2021 16:23:02 -0400
X-MC-Unique: vDoheUEXMeKFJUm6S5HgsQ-1
Received: by mail-ed1-f69.google.com with SMTP id y17-20020a0564023591b02903886c26ada4so6976124edc.5
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 13:23:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LZKovbJ8lKtotNg9ShvdPO02WF5aXDGNpj87pCUgbWM=;
        b=i899Y14Qlmu1gR75Cq8842ia7KLzg7NT5QAEQVYDYF2W+3z6nrPmDGC5hRtFHQ2hfQ
         J70nS2eZbLl4Oesrm3MO9l7NFzWSCuqqdcLFuzUF1qctyyIK/WRE6adX+BQlDVn82u9/
         Jtbjc9w1js47VTBrHzHHs39REhPhJtPCAXXJDZGY5nL2IKyVdWdKD2S+GnJC5hCmQgNH
         CR2iMJb2biaJCZupCO1supU1ourAmFLG0ay6DCZRSoU01GHyPBAsYvxXrg4RIVvt6JG2
         ZJz93zXMnujzxGpDkvirZnWlE6z6SkOG9EKpG8yaFnjH1GDNCAxbxQy/5yDGoAyv7CJK
         3+NA==
X-Gm-Message-State: AOAM5326JzYT1Hzs7seFdcXnHPH3YHuqTWt4YgpvPQSHz1TxrGRbP5lc
        NM7vt0hW7juXlFLoH0wVKT3LvfcsmYk5/5LLB9zUQODsY+mG7M7BQfxqzWIvgedn7ejjzn5FTRZ
        USetG98yYpHMy
X-Received: by 2002:a17:906:a295:: with SMTP id i21mr23568684ejz.160.1620159780863;
        Tue, 04 May 2021 13:23:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/ehuSnSyvhjGI2eJylw4RSt91+go0x6ZX/64OwCIMlzvvHaAvwWoFTchd058/nFJcvnoIXw==
X-Received: by 2002:a17:906:a295:: with SMTP id i21mr23568673ejz.160.1620159780652;
        Tue, 04 May 2021 13:23:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id p22sm15250338edr.4.2021.05.04.13.22.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 May 2021 13:23:00 -0700 (PDT)
Subject: Re: [PATCH v2 7/7] KVM: x86/mmu: Lazily allocate memslot rmaps
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210429211833.3361994-1-bgardon@google.com>
 <20210429211833.3361994-8-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1e50ae22-16a3-c43d-594a-a20d2ea3caa5@redhat.com>
Date:   Tue, 4 May 2021 22:22:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210429211833.3361994-8-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/04/21 23:18, Ben Gardon wrote:
> +	/*
> +	 * If set, the rmap should be allocated for any newly created or
> +	 * modified memslots. If allocating rmaps lazily, this may be set
> +	 * before the rmaps are allocated for existing memslots, but
> +	 * shadow_mmu_active will not be set until after the rmaps are fully
> +	 * allocated.
> +	 */
> +	bool alloc_memslot_rmaps;

Let's remove the whole sentence starting with "If allocating rmaps 
lazily".  The part about shadow_mmu_active should go there, while the 
rest is pointless as long as we just say that this flag will be accessed 
only under slots_arch_lock.

(Regarding shadow_mmu_active, I think I know what Sean will be 
suggesting because I had a similar thought and decided it introduced 
extra unnecessary complication... but maybe not, so let's see what he says).

Paolo

