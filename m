Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47EBD573A57
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 17:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236708AbiGMPlL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 11:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiGMPlK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 11:41:10 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008323335C
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 08:41:08 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id f65so1535605pgc.12
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 08:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UT9udr50GJyKecsX3LcPCWE8RWAbvRVT9oWgYzDIcoI=;
        b=N/vz09RBgdWROPujBdceXyeBj9//LIn7VgkL1kKVPjyw7AHYvpVidq1atlGd09WNGf
         GLogGH3KycLY6csUZJ1od98eTTmv6klSKuLEb5ZQMcEz/HpLm99idSsBrnPjwru5ncrj
         ODJNP029hxSgU8MF/bxgX4T5u3IQaw0XHtcPePOqAhPtFSEonJFwRfaiZ9N7P7fog/3m
         kIawcWMHNTT4gpMqdZcYaehLMp+1eVWobTXsl1prvqgm8O0bjfCC82rdrS6iMtybZ//q
         qqUKI/joS2+cRs2bdeBQCpocHIMG5EGLBXa7Agf1aE7L4bbsJA+lDS2N5iCA8B2AtpVk
         h7SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UT9udr50GJyKecsX3LcPCWE8RWAbvRVT9oWgYzDIcoI=;
        b=RXJq5hiqrhWulhMbdMPlhLQTqnhNSGM37Termitoimi1uZbjBVm+ENAr7F43HafMsv
         tvx7PCsCGbhfksytmEUce4WO7Ttkx8lB3gckGyMtlNqIl+r3XpdzoDKsnAHKRSb6g0oH
         CnQMizyPHUxI4/G8s7UnCGgHnpjQmQ+PY0B4pWmCJOvueTxAY3Am/LvfNlNowG0vCtVg
         AzYL26UFaJ1tG6Z7FOvkZyWYt8cbuulR2tNdzbrjzy9ewpLmqURoFKyl6YdQG4JEylbh
         1afrJjg796Iqwg7my34fKtkLA+IRhfdWq4F62tJL1F4VlUoUoYM7suNXyCoQrilrd3R8
         /K6A==
X-Gm-Message-State: AJIora+yn3dDAJRER2GAimBELSZgq1aAsJi+ia5YLYt6nHP8Z7GZesmD
        m6h8wYa3C1TB91po+sgKqcxLMA==
X-Google-Smtp-Source: AGRyM1tPCkg0z8Kca+zmBEg/o3uMJ/7f3MFzfn93JX1PyykFLy92b+ibQxZRHEFJ7WItU7DNR66iaw==
X-Received: by 2002:a63:eb0f:0:b0:419:a843:aa29 with SMTP id t15-20020a63eb0f000000b00419a843aa29mr794459pgh.314.1657726868237;
        Wed, 13 Jul 2022 08:41:08 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id s4-20020a17090ad48400b001ec85441515sm1752965pju.24.2022.07.13.08.41.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 08:41:07 -0700 (PDT)
Date:   Wed, 13 Jul 2022 15:41:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] KVM: selftests: Fix wrmsr_safe()
Message-ID: <Ys7nkBcfYlSuF7rt@google.com>
References: <20220713150532.1012466-1-vkuznets@redhat.com>
 <20220713150532.1012466-3-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220713150532.1012466-3-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 13, 2022, Vitaly Kuznetsov wrote:
> It seems to be a misconception that "A" places an u64 operand to
> EAX:EDX, at least with GCC11.

It's not a misconception, it's just that the "A" trick only works for 32-bit
binaries.  For 64-bit, the 64-bit integer fits into "rax" without needing to spill
into "rdx".

I swear I had fixed this, but apparently I had only done that locally and never
pushed/posted the changes :-/

> While writing a new test, I've noticed that wrmsr_safe() tries putting
> garbage to the upper bits of the MSR, e.g.:
> 
>   kvm_exit:             reason MSR_WRITE rip 0x402919 info 0 0
>   kvm_msr:              msr_write 40000118 = 0x60000000001 (#GP)
> ...
> when it was supposed to write '1'. Apparently, "A" works the same as
> "a" and not as EAX/EDX. Here's the relevant disassembled part:
> 
> With "A":
> 
> 	48 8b 43 08          	mov    0x8(%rbx),%rax
> 	49 b9 ba da ca ba 0a 	movabs $0xabacadaba,%r9
> 	00 00 00
> 	4c 8d 15 07 00 00 00 	lea    0x7(%rip),%r10        # 402f44 <guest_msr+0x34>
> 	4c 8d 1d 06 00 00 00 	lea    0x6(%rip),%r11        # 402f4a <guest_msr+0x3a>
> 	0f 30                	wrmsr
> 
> With "a"/"d":
> 
> 	48 8b 43 08          	mov    0x8(%rbx),%rax
> 	48 89 c2             	mov    %rax,%rdx
> 	48 c1 ea 20          	shr    $0x20,%rdx
> 	49 b9 ba da ca ba 0a 	movabs $0xabacadaba,%r9
> 	00 00 00
> 	4c 8d 15 07 00 00 00 	lea    0x7(%rip),%r10        # 402fc3 <guest_msr+0xb3>
> 	4c 8d 1d 06 00 00 00 	lea    0x6(%rip),%r11        # 402fc9 <guest_msr+0xb9>
> 	0f 30                	wrmsr
> 
> I was only able to find one online reference that "A" gives "eax and
> edx combined into a 64-bit integer", other places don't mention it at
> all.
> 
> Fixes: 3b23054cd3f5 ("KVM: selftests: Add x86-64 support for exception fixup")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  tools/testing/selftests/kvm/include/x86_64/processor.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 79dcf6be1b47..3d412c578e78 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -612,7 +612,7 @@ static inline uint8_t rdmsr_safe(uint32_t msr, uint64_t *val)
>  
>  static inline uint8_t wrmsr_safe(uint32_t msr, uint64_t val)
>  {
> -	return kvm_asm_safe("wrmsr", "A"(val), "c"(msr));
> +	return kvm_asm_safe("wrmsr", "a"((u32)val), "d"(val >> 32), "c"(msr));
>  }
>  
>  uint64_t vm_get_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
> -- 
> 2.35.3
> 
