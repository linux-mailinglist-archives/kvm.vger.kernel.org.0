Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69686466185
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 11:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345449AbhLBKg3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 05:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232856AbhLBKg2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Dec 2021 05:36:28 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC511C06174A;
        Thu,  2 Dec 2021 02:33:05 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id e3so114111517edu.4;
        Thu, 02 Dec 2021 02:33:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4m3VwJ9WhhdROt6v8EIOFSgzDDwDL8rCZ4oAsHIXiOU=;
        b=fHea44NA+PGomU+e+wD4iihdc90D+e+ZEIy9NPHR9DdmfE2qGcZ/TksQnv/aq/EwiD
         H4+aRpbf5bwDIIVhyvE4qpggNZ86GFwdWviFsqWDk0adO5qhib5UuJYfTnHARSDHshxN
         tU5Nzr9QW6p6YXugswlSU1McUyOmxHCrCsk7iMIrr06/CI7TdRt6/5YI+vGxpaM4ICsz
         zaa2v+QN02LmPJPltOrDCuBksnIQm5bHOesBPaoNYh617DlORws97Y6GA1L+fWPGs5UU
         jHZKDhW9QWfxJofwCQVZli2PaCSD4B1mRhwOtysuWy7Wy1083CcOfwJnCzX20dGZR7qd
         /xPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4m3VwJ9WhhdROt6v8EIOFSgzDDwDL8rCZ4oAsHIXiOU=;
        b=37MMypLEsoKwY3GxxeC8T4/JvZMclGPln3IHFkJ9V6fMhLFwdOwJwXf4Vmk4ZAxi7Y
         ikFmlYSmyxkWPmVBx3maBj71gVUCBsZkDYNbzyHdpOgvEpAsuDHrDidYDX/eXfJn59il
         S2Z5yH3vGGVNwdjkPGRsJTQahmxd2HKC1hH7uIMAAONzH/VJeDmLiTAVc9ErA8A9Pd90
         tsXtpyc2HF6CSAaIlj+4xw7FBUzvcY+b8M3hhPk5THSAfcqLyAGu9bOGl0smLItizz/2
         F/Ecopbg2yOuSjlLkZ/8l6PFH4VyYdHow5MwIbzVh2FxDQST2p1d30nfKU5LClNA8ccK
         hDmQ==
X-Gm-Message-State: AOAM531TTeA4VG0B3lrmxkWSjgFwnavE4uyRpOTIr6BiimzsbPA38guo
        gq8pzeUTQfkqaBN1syfiQGw=
X-Google-Smtp-Source: ABdhPJx3PKQ2dnlclzC1jNn+xb9lOEQvNkiheReh6e31JOtEste1qX+KLsByazubsgcUsUzgab9u0g==
X-Received: by 2002:a05:6402:1768:: with SMTP id da8mr17096258edb.252.1638441184484;
        Thu, 02 Dec 2021 02:33:04 -0800 (PST)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id h7sm2171240ede.40.2021.12.02.02.32.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 02:33:04 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <71055dda-d745-b0bb-dca1-d1dd157e25e4@redhat.com>
Date:   Thu, 2 Dec 2021 11:32:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v6 03/29] KVM: Resync only arch fields when
 slots_arch_lock gets reacquired
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1638304315.git.maciej.szmigiero@oracle.com>
 <a47c93c2fe40e7ed27eb0ff6ac2b173254058b6c.1638304315.git.maciej.szmigiero@oracle.com>
 <YabK7IOM74ag2CcS@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YabK7IOM74ag2CcS@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/1/21 02:07, Sean Christopherson wrote:
>> Signed-off-by: Maciej S. Szmigiero<maciej.szmigiero@oracle.com>
>> [sean: tweak shortlog, note INVALID flag in changelog, revert comment]
>> Signed-off-by: Sean Christopherson<seanjc@google.com>
> Heh, I think you can drop my SoB?  This is new territory for me, I don't know the
> rules for this particular situation.

I'll add a co-developed-by for all patches that you two worked on together.

Paolo

> Reviewed-by: Sean Christopherson<seanjc@google.com>
> 

