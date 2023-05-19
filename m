Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69DB8709E9A
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 19:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbjESRz3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 13:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbjESRz2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 13:55:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C7FD1
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 10:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684518885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xY5DdzJZ+tlOEiTm+AjVxU9GWuiQ7xHZ1fBRd1/mcD4=;
        b=amraDaqI6fqzQnAL8fonAZMAI5cdYNGhLutcA/bafMrinrK8fXtVZYjZ+UlTyChREOZiQ8
        i03eiBIY2PejOGuFsVzISjW4xWeO3UySEUPjsuZWk5zj5mnizxCtER6el2ng3RYmuj503i
        C72H2hzcW4GBYMNMzbNLQqwzddGB4Ng=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-3gb-asLJNlGxFHJGdE8f6A-1; Fri, 19 May 2023 13:54:40 -0400
X-MC-Unique: 3gb-asLJNlGxFHJGdE8f6A-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-510ec47c66aso1954658a12.0
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 10:54:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684518878; x=1687110878;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xY5DdzJZ+tlOEiTm+AjVxU9GWuiQ7xHZ1fBRd1/mcD4=;
        b=h8+WOi7P4PAyHALbtkQ5DDMKlnV/uB0UICV2QseMugFdVMmUfutm2HYQ8uZLNjn7wN
         XIh6kX91WJMSbTZQbKvUZ5e2LTfrH3Pv5GoO1zWDSadNo9kQHkIanPGXZ9wABouLLtAe
         pU/BzTDsRvtrmAVrppYULZ2q9GX1BgkiztF7e+JyKwNunHLCyDM/xdtbO/xea1VwNto0
         3ao1akfGknkch9v1RY/dqtejqBL6ZGw8l97dYb5iNO4AbWXJVgf+o+cNL8SJjS3vrL5M
         yINxMLhlgIFl5JLSJ0itMczK2jtRJmRZgKDYYD+QsDbLt7F2RSL0jEmUE+8uBbtf+LIb
         PvOQ==
X-Gm-Message-State: AC+VfDxgCWizz4j5hmoMRVplQZ1KoLYgS/+wQUQd8MTTEl2k9RD+yO9u
        JulfoTsCI9/uLRIJs2+3QgiuwZNnBvDrsJ2z0aR+NcVoJjKrOddT/a5oOaxU2XTvTjZoH6uGr+x
        fSa0lgzK7AlRQqn5O5uml
X-Received: by 2002:a17:907:72cf:b0:962:9ffa:be19 with SMTP id du15-20020a17090772cf00b009629ffabe19mr2943444ejc.5.1684518878580;
        Fri, 19 May 2023 10:54:38 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6k+lSmFhwFt9ODv52zCJC2W5+1YXpeZwuhQQgCCONXKzc2wDPXKpayvsMJ4YjV4aXwHMTRtA==
X-Received: by 2002:a17:907:72cf:b0:962:9ffa:be19 with SMTP id du15-20020a17090772cf00b009629ffabe19mr2943429ejc.5.1684518878240;
        Fri, 19 May 2023 10:54:38 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id l18-20020a170906a41200b00965a52d2bf6sm2548561ejz.88.2023.05.19.10.54.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 May 2023 10:54:37 -0700 (PDT)
Message-ID: <10abe213-54bb-e637-7ea2-c088bca4726d@redhat.com>
Date:   Fri, 19 May 2023 19:54:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 0/3] KVM: x86: SGX vs. XCR0 cleanups
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>
References: <20230503160838.3412617-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230503160838.3412617-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/3/23 18:08, Sean Christopherson wrote:
> Stop adjusting the guest's CPUID info for the allowed XFRM (a.k.a. XCR0)
> for SGX enclaves.  Past me didn't understand the roles and responsibilities
> between userspace and KVM with respect to CPUID leafs, i.e. I thought I was
> being helpful by having KVM adjust the entries.
> 
> This is clearly an ABI change, but QEMU does the right thing and AFAIK no
> other VMMs support SGX (yet), so I'm hopeful/confident that we can excise
> the ugly before userspace starts depending on the bad behavior.
>   
> v2:
>   - Collect reviews/testing. [Kai]
>   - Require FP+SSE to always be set in XFRM, and exempt them from the XFRM
>     vs. XCR0 check. [Kai]
> 
> v1: https://lore.kernel.org/all/20230405005911.423699-1-seanjc@google.com
> 
> Sean Christopherson (3):
>    KVM: VMX: Don't rely _only_ on CPUID to enforce XCR0 restrictions for
>      ECREATE
>    KVM: x86: Don't adjust guest's CPUID.0x12.1 (allowed SGX enclave XFRM)
>    KVM: x86: Open code supported XCR0 calculation in
>      kvm_vcpu_after_set_cpuid()
> 
>   arch/x86/kvm/cpuid.c   | 43 ++++++++++--------------------------------
>   arch/x86/kvm/vmx/sgx.c | 11 +++++++++--
>   2 files changed, 19 insertions(+), 35 deletions(-)
> 
> 
> base-commit: 5c291b93e5d665380dbecc6944973583f9565ee5

Queued, thanks.  But why patch 3?  Small functions are nice and remove 
the need to remember what is in EDX:EAX of CPUID[0xD,0].

Paolo

