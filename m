Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0DAC524F87
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 16:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355064AbiELOLt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 10:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355060AbiELOLr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 10:11:47 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4929A62113;
        Thu, 12 May 2022 07:11:46 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id g6so10550838ejw.1;
        Thu, 12 May 2022 07:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vDfWle9etWMCmQNVGzMruoXlBGLrPBNQ0jQnmtdNAT4=;
        b=lbH/a60vTfH0YMoCYxaNMx4khmhaEAiJpnijLbVIse7l464HPTBpnDgXMA3JP0r5Zt
         wosR3ndq5qim2RZCTPu15TxZ5hOjBgq2gI+dbLdqRNPJFrNBbNDZ1GDDkXaJZC8ZkFyg
         h085ul/kM5bnupa0Vp1/NjiqfAykEL8jTgvW1M2lep43rtLzaH+edEFfPes6jgt1rzhb
         /JIbNkYBko57rbX8wxKrIjTF8NLorE6v8/iwHl1/1fFP/LmB33ed7DIedW1PHl60rXvm
         M07TS+SjmrfIWG7Qpcxb+Hsbko/YzMQs3XMGN53QPKWe1IFwIj6OnjZOsXq1cAocONFN
         S46A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vDfWle9etWMCmQNVGzMruoXlBGLrPBNQ0jQnmtdNAT4=;
        b=EPf3Z0NG7KrGIprZkKT9Lf4gE7z5RIpJjJ4Gstyz7WjNNerlVGJYi5APUNhb95kHoc
         /FxY1Jb0EMFct3ihj6bM9HzL0/oj57Q1wDgJTh8aEk72CEa9K14egzVllsme6bmUgMTG
         eQ39TG1RUU04k1COM44obYv1Qx9GYeFDqK3AQNH3vhg+v89+iReayakGXcHLH9KkQlka
         sGC810qYrdyJrV8CcIavNSTIS2A3OHjnOAYDW41KakYUkXPwpGXzq5fvWIAaoOTZfaL4
         ur/2zO1945Bx3Jds3mFn2SdfujPHWPXQ4o/3mil2GGWt8HqlhycsgbeuNW3DxS4N3pKt
         56cQ==
X-Gm-Message-State: AOAM531I2Y07T2UTbdZoVexOxBziUI7LG0qyVOcyJDMEEU1GMArMYY5s
        4WJWOnBabehAxiiz8CAE+DI=
X-Google-Smtp-Source: ABdhPJy4SV46Fw946eFm0yov5HwLW2Bb91us5NM7wZC9tAYmquJgB+/RwuH491Qkvgkl0aY1W35C5Q==
X-Received: by 2002:a17:906:1b1b:b0:6f3:9044:5fb4 with SMTP id o27-20020a1709061b1b00b006f390445fb4mr50087ejg.763.1652364704686;
        Thu, 12 May 2022 07:11:44 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id y18-20020aa7ccd2000000b0042617ba6394sm2565060edt.30.2022.05.12.07.11.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 07:11:44 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <c21a5891-06fa-1d0b-360f-54b8711fd23b@redhat.com>
Date:   Thu, 12 May 2022 16:11:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3] KVM: x86/mmu: Update number of zapped pages even if
 page list is stable
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
References: <20220511145122.3133334-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220511145122.3133334-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/11/22 16:51, Sean Christopherson wrote:
> When zapping obsolete pages, update the running count of zapped pages
> regardless of whether or not the list has become unstable due to zapping
> a shadow page with its own child shadow pages.  If the VM is backed by
> mostly 4kb pages, KVM can zap an absurd number of SPTEs without bumping
> the batch count and thus without yielding.  In the worst case scenario,
> this can cause a soft lokcup.
> 
>   watchdog: BUG: soft lockup - CPU#12 stuck for 22s! [dirty_log_perf_:13020]
>     RIP: 0010:workingset_activation+0x19/0x130
>     mark_page_accessed+0x266/0x2e0
>     kvm_set_pfn_accessed+0x31/0x40
>     mmu_spte_clear_track_bits+0x136/0x1c0
>     drop_spte+0x1a/0xc0
>     mmu_page_zap_pte+0xef/0x120
>     __kvm_mmu_prepare_zap_page+0x205/0x5e0
>     kvm_mmu_zap_all_fast+0xd7/0x190
>     kvm_mmu_invalidate_zap_pages_in_memslot+0xe/0x10
>     kvm_page_track_flush_slot+0x5c/0x80
>     kvm_arch_flush_shadow_memslot+0xe/0x10
>     kvm_set_memslot+0x1a8/0x5d0
>     __kvm_set_memory_region+0x337/0x590
>     kvm_vm_ioctl+0xb08/0x1040
> 
> Fixes: fbb158cb88b6 ("KVM: x86/mmu: Revert "Revert "KVM: MMU: zap pages in batch""")
> Reported-by: David Matlack <dmatlack@google.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Reviewed-by: David Matlack <dmatlack@google.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> v3:
>   - Collect David's review.
>   - "Rebase".  The v2 patch still applies cleanly, but Paolo apparently has
>     a filter configured to ignore all emails related to the v2 submission.
> 
> v2:
>   - https://lore.kernel.org/all/20211129235233.1277558-1-seanjc@google.com
>   - Rebase to kvm/master, commit 30d7c5d60a88 ("KVM: SEV: expose...")
>   - Collect Ben's review, modulo bad splat.
>   - Copy+paste the correct splat and symptom. [David].
> 
>   arch/x86/kvm/mmu/mmu.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 909372762363..7429ae1784af 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5665,6 +5665,7 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
>   {
>   	struct kvm_mmu_page *sp, *node;
>   	int nr_zapped, batch = 0;
> +	bool unstable;
>   
>   restart:
>   	list_for_each_entry_safe_reverse(sp, node,
> @@ -5696,11 +5697,12 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
>   			goto restart;
>   		}
>   
> -		if (__kvm_mmu_prepare_zap_page(kvm, sp,
> -				&kvm->arch.zapped_obsolete_pages, &nr_zapped)) {
> -			batch += nr_zapped;
> +		unstable = __kvm_mmu_prepare_zap_page(kvm, sp,
> +				&kvm->arch.zapped_obsolete_pages, &nr_zapped);
> +		batch += nr_zapped;
> +
> +		if (unstable)
>   			goto restart;
> -		}
>   	}
>   
>   	/*
> 
> base-commit: 2764011106d0436cb44702cfb0981339d68c3509

Queued, thanks.

Paolo
