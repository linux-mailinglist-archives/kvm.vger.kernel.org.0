Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE3172DC62
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 10:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241151AbjFMI0G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 04:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238988AbjFMI0F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 04:26:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E40126
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 01:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686644725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P1syNaBAKkffiLL0bv/EmGcINY+iq9kUOB1DQ8J5+wk=;
        b=Mlnr2tBHCS9FCF+KIzjkXpuVGxCRUuJNv4sULCh5+5efmp3g6vKJDiu3BQ8p9/6GpkLgNu
        cbof2Wyl/MGS3qp3rsyFy/5yv82LKzLwHmGMbLw4fdmWVHDHvPVEKA1+icUJ6sHp9zT0DC
        LpjSaEJv752VEE6MjAQ7ZGuLVz0Y1UM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-WL1x4YEyOwO8Zd7TUQ1E8A-1; Tue, 13 Jun 2023 04:25:22 -0400
X-MC-Unique: WL1x4YEyOwO8Zd7TUQ1E8A-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-30fb7b82e15so469916f8f.0
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 01:25:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686644721; x=1689236721;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P1syNaBAKkffiLL0bv/EmGcINY+iq9kUOB1DQ8J5+wk=;
        b=AmkwDY19f5qarSXCEEsmT0GRI1NNg83BO+7ttuROfDi9zOGZsnuPxHTfcGqw88cECf
         O5HGg2KOghNOPDwm4bwL8KHn4Bv20/1QBSE3+Bt2H5V9kRRrBST1HYHOuib36yVNPzXI
         BRkPBoXGX+QpCOa1Jejavp2zBS9vLIuNgAL81KNdTCWqFb3SP5t/+iQSepBKBZRFbAVu
         WIqEibleqtKe4vuAZc7VEk54pqiLpx5p7pdLvqb5+oQQdjjfmlTtGVGNAaJvWtMGMm7y
         Z22VtVZ+qc9Gfm9gjY8rgZFuitqtvvLy1t1Op6E7mM67L4WoAX0ECkVH53POJGBsahVc
         k1pg==
X-Gm-Message-State: AC+VfDwTiIt1yGAb5oO1BMd7NdBWTNBPkxntR7R4d0E8UIQ7I5Wl/Nae
        cPxQDQ5ZNCR0jk+7eiTrl7uYT4cpDLMccFfoM2DAkPiCE6Xa6v2xOa4tILMZ2RXzOg7ZKcSHeZk
        Pxs6YtWs63dCf
X-Received: by 2002:a5d:630b:0:b0:30f:c0a8:973c with SMTP id i11-20020a5d630b000000b0030fc0a8973cmr4182807wru.7.1686644721768;
        Tue, 13 Jun 2023 01:25:21 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ54+a0ZNqCyRceTdBNOPN8n0EMFWs7KGngnKpklEwP2qo3zBges6I9cDMRiOnw/znCcScLd0Q==
X-Received: by 2002:a5d:630b:0:b0:30f:c0a8:973c with SMTP id i11-20020a5d630b000000b0030fc0a8973cmr4182787wru.7.1686644721492;
        Tue, 13 Jun 2023 01:25:21 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id h14-20020a5d6e0e000000b003078354f774sm14594095wrz.36.2023.06.13.01.25.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jun 2023 01:25:21 -0700 (PDT)
Message-ID: <02f40638-0230-ab06-6ccd-6bdbab814000@redhat.com>
Date:   Tue, 13 Jun 2023 16:25:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3 02/17] arm64: Prevent the use of
 is_kernel_in_hyp_mode() in hypervisor code
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
References: <20230609162200.2024064-1-maz@kernel.org>
 <20230609162200.2024064-3-maz@kernel.org>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230609162200.2024064-3-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/10/23 00:21, Marc Zyngier wrote:
> Using is_kernel_in_hyp_mode() in hypervisor code is a pretty bad
> mistake. This helper only checks for CurrentEL being EL2, which
> is always true.
> 
> Make the compilation fail if using the helper in hypervisor context
> Whilst we're at it, flag the helper as __always_inline, which it
> really should be.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/virt.h | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
> index 4eb601e7de50..21e94068804d 100644
> --- a/arch/arm64/include/asm/virt.h
> +++ b/arch/arm64/include/asm/virt.h
> @@ -110,8 +110,10 @@ static inline bool is_hyp_mode_mismatched(void)
>   	return __boot_cpu_mode[0] != __boot_cpu_mode[1];
>   }
>   
> -static inline bool is_kernel_in_hyp_mode(void)
> +static __always_inline bool is_kernel_in_hyp_mode(void)
>   {
> +	BUILD_BUG_ON(__is_defined(__KVM_NVHE_HYPERVISOR__) ||
> +		     __is_defined(__KVM_VHE_HYPERVISOR__));
>   	return read_sysreg(CurrentEL) == CurrentEL_EL2;
>   }
>   

-- 
Shaoqin

