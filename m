Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 885777CC848
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 18:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344236AbjJQQDT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 12:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344026AbjJQQDR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 12:03:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E7FB0
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 09:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697558548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v32pfxRKc//f3UunzAZaeCMCVvlHLiZlto1dwpElIM8=;
        b=aoCIP00tIqwHkW4DXrtBYn0T34lbrZy/5As+vggzcqBah52H2BTi3m5CbXrQCL3YQZvxPn
        //UVnKhSd3QhaJSsdNGHVeFMp+bat4XtKC01qzhCsjoENqMU4NcEco15Txz8M63+aqO+Ts
        euaRl4uknl5iPBQtKxhTZn99lb5crvg=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-290-VA_VtJQkOTS9mChPTZoaig-1; Tue, 17 Oct 2023 12:02:27 -0400
X-MC-Unique: VA_VtJQkOTS9mChPTZoaig-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-9bf8678af70so218158966b.2
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 09:02:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697558546; x=1698163346;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v32pfxRKc//f3UunzAZaeCMCVvlHLiZlto1dwpElIM8=;
        b=GS/++oRycO1FgYoLt328j2+b1JPRGIQFDzpGC/Wo7PD3JKCJ5mYSdBBhXnbCKgrXfI
         L2Frz192tqYnziPRlWtOEAzWamMn8AAHYO7PMD1cwKZJpKcWBc9tJt4T41Xme+nfKGGV
         l9ObT3fmJDNjfDxyCis4QtAgA71Ei6T0j8P/YEaimEqwZn2eRQdTzaNQUG4jsWPBn6Qx
         228+3X0I6j0ftXWfv2GGgdFTJ1ww6JbzULwNszUKYnanrwn4ivsQLq9H4wKs8E7f2Ifq
         F2SuIbI1DUisTgBo9WO3LEKVuTVB3a53wnqtumT0KEFhFhbW9uYZ0iTRG/6HTcofOIbq
         cAUA==
X-Gm-Message-State: AOJu0YzKjoSl0380jTjTy3XKhnOd7euFjxuMR/92gnV0u9VfInaJdS8L
        SL/ORdL+kSTJakqjaoY0P4LBh2D0Seufk95M7fzrb/z2w655cYDXt625Jju7xH/Ppykq0dWraaP
        zKmDc+nOVXKNx
X-Received: by 2002:a17:907:74a:b0:9bf:3c7d:5f53 with SMTP id xc10-20020a170907074a00b009bf3c7d5f53mr2303159ejb.45.1697558545976;
        Tue, 17 Oct 2023 09:02:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH6u+YkM3Mn4mY5m0JE4EmeTMcr1spCDJTZAgrcNpYakD0TJhi5C2Vg0AdgT26flpr51EkaMQ==
X-Received: by 2002:a17:907:74a:b0:9bf:3c7d:5f53 with SMTP id xc10-20020a170907074a00b009bf3c7d5f53mr2303143ejb.45.1697558545676;
        Tue, 17 Oct 2023 09:02:25 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id ci11-20020a170906c34b00b009ae587ce135sm53162ejb.223.2023.10.17.09.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 09:02:25 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Nicolas Saenz Julienne <nsaenz@amazon.com>, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, graf@amazon.de, rkagan@amazon.de,
        linux-kernel@vger.kernel.org, anelkz@amazon.de,
        Nicolas Saenz Julienne <nsaenz@amazon.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] KVM: x86: hyper-v: Don't auto-enable stimer on write
 from user-space
In-Reply-To: <20231017155101.40677-1-nsaenz@amazon.com>
References: <20231017155101.40677-1-nsaenz@amazon.com>
Date:   Tue, 17 Oct 2023 18:02:24 +0200
Message-ID: <87bkcx6xv3.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nicolas Saenz Julienne <nsaenz@amazon.com> writes:

> Don't apply the stimer's counter side effects when modifying its
> value from user-space, as this may trigger spurious interrupts.
>
> For example:
>  - The stimer is configured in auto-enable mode.
>  - The stimer's count is set and the timer enabled.
>  - The stimer expires, an interrupt is injected.
>  - The VM is live migrated.
>  - The stimer config and count are deserialized, auto-enable is ON, the
>    stimer is re-enabled.
>  - The stimer expires right away, and injects an unwarranted interrupt.
>
> Cc: stable@vger.kernel.org
> Fixes: 1f4b34f825e8 ("kvm/x86: Hyper-V SynIC timers")
> Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
> ---
>
> Changes since v2: 
> - reword commit message/subject.
>
> Changes since v1:
> - Cover all 'stimer->config.enable' updates.
>
>  arch/x86/kvm/hyperv.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 7c2dac6824e2..238afd7335e4 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -727,10 +727,12 @@ static int stimer_set_count(struct kvm_vcpu_hv_stimer *stimer, u64 count,
>  
>  	stimer_cleanup(stimer);
>  	stimer->count = count;
> -	if (stimer->count == 0)
> -		stimer->config.enable = 0;
> -	else if (stimer->config.auto_enable)
> -		stimer->config.enable = 1;
> +	if (!host) {
> +		if (stimer->count == 0)
> +			stimer->config.enable = 0;
> +		else if (stimer->config.auto_enable)
> +			stimer->config.enable = 1;
> +	}
>  
>  	if (stimer->config.enable)
>  		stimer_mark_pending(stimer, false);

LGTM, thanks!

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

