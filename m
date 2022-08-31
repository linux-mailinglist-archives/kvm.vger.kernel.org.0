Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6EB5A898C
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 01:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiHaXmS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 19:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiHaXmQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 19:42:16 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52876E3430
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 16:42:15 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-11ee4649dfcso21454593fac.1
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 16:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Gbm2YDpQFjBB1C/MWGwxozhGDn3//MPNQbYc8/MnpoE=;
        b=sv9KHad0cGJmeFGaf+ztBX4dGte7jbjk12BGsqagdw6/6nJv9XOTZ9/sJAS4nx286i
         +crmGCs/+kfmV1tOSy25eInQxv899WJiLA4AcqJlJn6mVknCPa4dZ1v9iwMavURrTqtu
         86WJSYXKDHX27MZJYwC265oE7nZVOIrHUw5GwYPANm9iwRIQluBoVdT9rRkRB7SsIUHZ
         UOIqzitSK5fGiH7Yvs/QVF0jMZyB7UxOy0NstjpSsLyqttn0w7dcEDpiHsRxyA0OwbF8
         NfyDy5CLQa2u0Cn2rg0SUELBVVzxKOn/Om8OqKj/70sQ/TrGFZhx/NEOYJlMNeil8emJ
         p+eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Gbm2YDpQFjBB1C/MWGwxozhGDn3//MPNQbYc8/MnpoE=;
        b=O4EqOpsSX3pxDwBr0D7CUWgeZZbK3W0siLZlA/TBv/R6BnB2FUiSOwPpPiBkGpY49/
         WlbOf243HkVdgW9HEM4Mg9UJhYWcXj9iqpGGKpBZNi+5KyAHBSy4b/qCWqg2fA0FjZ7q
         vzqREYXxIb7D/4E5gYfQ/0j2ikW/r0XmP8WRl3shfkb6aEWYG8y6KaiI/oLyjgB4QE1O
         dXSTFJPll795+Z7pxxeXI9ujzzwEgDoa/3r/TO7YdY6aljbARzR0j+mBcIcCIFr9WzD4
         e4eEIrSmhHElLbBq+hwlYhw1l7EGe/tMXNt36XwAOBEKhunsRUZoexABr6TqjOayYdDD
         oxyQ==
X-Gm-Message-State: ACgBeo0QCf31kQES9DvJ+DdE8osJgHPfbZEcns97WdTdGg3LAtoHo3IG
        Bt0eRiDZHCjxocOwu3hLeU6KojNiw+7TiQVnSTbISg==
X-Google-Smtp-Source: AA6agR793of2eSi6hkm3OSxzP8r3isyPimVdewi75reSxnQQZJbBYzdZG8VQmDhfZhM8j82TPUYrgl/5v6iD8rMSisk=
X-Received: by 2002:a05:6870:5a5:b0:122:5662:bee6 with SMTP id
 m37-20020a05687005a500b001225662bee6mr756255oap.181.1661989334489; Wed, 31
 Aug 2022 16:42:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220829100850.1474-1-santosh.shukla@amd.com> <20220829100850.1474-2-santosh.shukla@amd.com>
In-Reply-To: <20220829100850.1474-2-santosh.shukla@amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 31 Aug 2022 16:42:03 -0700
Message-ID: <CALMp9eTrz2SkK=CjTSc9NdHvP4qsP+UWukFadbqv+BA+KdtMMg@mail.gmail.com>
Subject: Re: [PATCHv4 1/8] x86/cpu: Add CPUID feature bit for VNMI
To:     Santosh Shukla <santosh.shukla@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mlevitsk@redhat.com,
        mail@maciej.szmigiero.name
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 29, 2022 at 3:09 AM Santosh Shukla <santosh.shukla@amd.com> wrote:
>
> VNMI feature allows the hypervisor to inject NMI into the guest w/o
> using Event injection mechanism, The benefit of using VNMI over the
> event Injection that does not require tracking the Guest's NMI state and
> intercepting the IRET for the NMI completion. VNMI achieves that by
> exposing 3 capability bits in VMCB intr_cntrl which helps with
> virtualizing NMI injection and NMI_Masking.
>
> The presence of this feature is indicated via the CPUID function
> 0x8000000A_EDX[25].
>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index ef4775c6db01..33e3603be09e 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -356,6 +356,7 @@
>  #define X86_FEATURE_VGIF               (15*32+16) /* Virtual GIF */
>  #define X86_FEATURE_X2AVIC             (15*32+18) /* Virtual x2apic */
>  #define X86_FEATURE_V_SPEC_CTRL                (15*32+20) /* Virtual SPEC_CTRL */
> +#define X86_FEATURE_V_NMI              (15*32+25) /* Virtual NMI */
>  #define X86_FEATURE_SVME_ADDR_CHK      (15*32+28) /* "" SVME addr check */

Why is it "V_NMI," but "VGIF"?

Reviewed-by: Jim Mattson <jmattson@google.com>
