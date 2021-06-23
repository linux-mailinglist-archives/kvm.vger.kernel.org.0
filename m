Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC8E3B2210
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 22:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhFWUz0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 16:55:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29460 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229660AbhFWUzZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 16:55:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624481586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9n3NgC3GAu3lDi6hAVapBvNOzF/zUAHWZGT/SQUjfn8=;
        b=arf5DbcBcm92Nv7Ac/acwSDw6/wUpxUeZt8M71eWhwzie5rEFtQqIiS1P7f1kvMsspoie6
        QGCp8uCInzqH3SrLkqTyp3DkBlfh+4wx+U3VM9L6QpAhqAN17NdihFADC7XK0NBZS0p8XP
        t62vIOYz3LuB9b2xs9IgwHSW6BKKJKg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-fkm2CC9iOYqxkAoRvU098w-1; Wed, 23 Jun 2021 16:53:05 -0400
X-MC-Unique: fkm2CC9iOYqxkAoRvU098w-1
Received: by mail-ed1-f71.google.com with SMTP id p23-20020aa7cc970000b02903948bc39fd5so1991718edt.13
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 13:53:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9n3NgC3GAu3lDi6hAVapBvNOzF/zUAHWZGT/SQUjfn8=;
        b=GbryFkCrO8LdH9d4zBTbocIb7ydg4oe+nPDTZYlIRZa3dnokU7FunBAm5KLYlynBqm
         i+7Cb1a1tdoZYxQzXnvRkhRw2aSei8OgdE+TXgtxPdVFWDrps3T0Z+4qQ3Dlax8dignA
         AwkiwwSjaZogRkzRbE3E5QsaeVphJ+ciK5PQ4AUC9Zk2RMxkdp+Kl1oPEjNrZgQHngsI
         GjCPkHxh+gLhWRu5FNPgn+stwPjV9Vu3+xds+NtwoFL/9znBZUCDKnNvu3nEbgz4566o
         rnGdqPCOL+O9HTVhLOZNuHkhMqCBLns6DZ0YJPpRmPkWWXkQR1HdiI6vDkCtvAuR/O0G
         UgyA==
X-Gm-Message-State: AOAM532lPm9HGTwqmMMfuuVqYT3l2xQAXfJsAUTyGwG09j3VjeiyTFat
        qffZEmf1lvKRvOpZ/v6XUpLNKcWqPU52MgbOS69N2DPPvdz+R/RkmEKrVVOEKgU+bnh8JuvBxM8
        BVuSB2BpI96el
X-Received: by 2002:a17:907:9854:: with SMTP id jj20mr1868386ejc.365.1624481584366;
        Wed, 23 Jun 2021 13:53:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwMe8FJ9wIRFyAgHMyMvQXoIdX9CLLTCkw4YE+5D5Tm+jGV+RsdTr7SgoZV9o6Y/HIs60T5nQ==
X-Received: by 2002:a17:907:9854:: with SMTP id jj20mr1868376ejc.365.1624481584214;
        Wed, 23 Jun 2021 13:53:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s5sm613146edi.93.2021.06.23.13.53.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 13:53:03 -0700 (PDT)
Subject: Re: [PATCH 25/54] KVM: x86/mmu: Add helpers to query mmu_role bits
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-26-seanjc@google.com>
 <1babfd1c-bee1-12e5-a9d9-9507891efdfd@redhat.com>
 <YNOd/0RxSnqmDBvd@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1c1cc822-4604-9e04-dd4c-e5005bfee7c5@redhat.com>
Date:   Wed, 23 Jun 2021 22:53:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YNOd/0RxSnqmDBvd@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/21 22:47, Sean Christopherson wrote:
>> What do you think about calling these is_mmu_##name?  The point of having
>> these helpers is that the register doesn't count, and they return the
>> effective value (e.g. false in most EPT cases).
>
> I strongly prefer to keep <reg> in the name, both to match the mmu_role bits and
> to make it a bit more clear that it's reflective (modified) register state, as
> opposed to PTEs or even something else entirely.  E.g. I always struggled to
> remember the purpose of mmu->nx flag.

No problem.  I do disagree that it's register state ("modified" seems to 
be more than a parenthetical remark), but not enough to argue about it 
and even less to do the work to rename the accessors.

Paolo

