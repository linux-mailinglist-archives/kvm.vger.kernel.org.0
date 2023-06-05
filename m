Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69647722337
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 12:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbjFEKQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 06:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbjFEKQu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 06:16:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F8BED
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 03:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685960163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DBJVxv+2bbU/jFEAEgHMvkuGix33HBO2Y8Ion9Bk6UQ=;
        b=XhrXDPh7qhN61WT0/kni93Whgjh4Ph4pahNBdYH3+pSKDx25RKNF45Q+RDFS+Xj2qA8m3K
        N8BGrwUEvuDwr79Z0emIJhkGEukDDdTdtF4NnPo8REhWPD14cQAEWGZfCXErSmuMPWPzEU
        87F6Z71oeu7bZQuH+wXSCMk6Abzueps=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-axSy2fl8OgWoktm21MA0aQ-1; Mon, 05 Jun 2023 06:15:58 -0400
X-MC-Unique: axSy2fl8OgWoktm21MA0aQ-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9715654ab36so331225466b.0
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 03:15:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685960157; x=1688552157;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DBJVxv+2bbU/jFEAEgHMvkuGix33HBO2Y8Ion9Bk6UQ=;
        b=ZnaYxteI6J1M8pT013znFBjUDGOpCb/jZBh3UckSbWSIwcbFkl1k4fLlb6I4J85K/8
         JLnkVWrO/kJYVMbw8zuU6wLnUtCCBPdCe/l5qPHGfS9BPUNGy+fQYD10sy35wfOuwt0X
         bcfnp+GsXPfE5uOodL+se4g1GXJnllDQCdrOEEMXPscrZyLpXmwdV0rIJ08xw0vFuEqy
         nBeZgBSebxxCeitBAWoPpg1R5IrOyd66sJy3X5jVecvLF4e2GtVVNn/Qg1dMx35dyn3L
         vTEPaOooofQ9irjFqA/VGxtw1t+9/vhBCEgEvO9Wdm+91pjbUHVCA5lq0UYRuWt0HkkM
         WeWQ==
X-Gm-Message-State: AC+VfDyyRA/McM0fZCOS5JTjG6j0a0x3sbGyIkKKIwks1XTJAwLzfJIh
        cWN9WSszllL9aXJ6npvl5HzqXUmIpAjqS//mKu6fF3Dg96xVWOpU3jUGd9PyCinBpGr8n0Ee0NG
        yCpis/jxYlf9M
X-Received: by 2002:aa7:d783:0:b0:50c:52d:7197 with SMTP id s3-20020aa7d783000000b0050c052d7197mr5994949edq.2.1685960157058;
        Mon, 05 Jun 2023 03:15:57 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4e/IZPp1mjvhFMHTvwSjaT+N1xcUUcHvSCTdIZXEODIoJzthHrh7LfdDG3WENCGNvap1pqlA==
X-Received: by 2002:aa7:d783:0:b0:50c:52d:7197 with SMTP id s3-20020aa7d783000000b0050c052d7197mr5994942edq.2.1685960156767;
        Mon, 05 Jun 2023 03:15:56 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id b26-20020aa7dc1a000000b005166663b8dcsm458765edu.16.2023.06.05.03.15.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 03:15:56 -0700 (PDT)
Message-ID: <36fd1a0b-3dc5-973f-b367-5da5776fed74@redhat.com>
Date:   Mon, 5 Jun 2023 12:15:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 0/3] KVM: x86: Use "standard" mmu_notifier hook for APIC
 page
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
References: <20230602011518.787006-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230602011518.787006-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/2/23 03:15, Sean Christopherson wrote:
> Convert VMX's handling of mmu_notifier invalidations of the APIC-access page
> from invalidate_range() to KVM's standard invalidate_range_{start,end}().
> 
> KVM (ab)uses invalidate_range() to fudge around not stalling vCPUs until
> relevant in-flight invalidations complete.  Abusing invalidate_range() works,
> but it requires one-off code in KVM, sets a bad precedent in KVM, and is
> blocking improvements to mmu_notifier's definition of invalidate_range()
> due to KVM's usage diverging wildly from the original intent of notifying
> IOMMUs of changes to shared page tables.
> 
> Clean up the mess by hooking x86's implementation of kvm_unmap_gfn_range()
> and stalling vCPUs by re-requesting KVM_REQ_APIC_PAGE_RELOAD until the
> invalidation completes.
> 
> Sean Christopherson (3):
>    KVM: VMX: Retry APIC-access page reload if invalidation is in-progress
>    KVM: x86: Use standard mmu_notifier invalidate hooks for APIC access
>      page
>    KVM: x86/mmu: Trigger APIC-access page reload iff vendor code cares
> 
>   arch/x86/kvm/mmu/mmu.c   |  4 ++++
>   arch/x86/kvm/vmx/vmx.c   | 50 ++++++++++++++++++++++++++++++++++++----
>   arch/x86/kvm/x86.c       | 14 -----------
>   include/linux/kvm_host.h |  3 ---
>   virt/kvm/kvm_main.c      | 18 ---------------
>   5 files changed, 49 insertions(+), 40 deletions(-)
> 
> 
> base-commit: 39428f6ea9eace95011681628717062ff7f5eb5f


Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

