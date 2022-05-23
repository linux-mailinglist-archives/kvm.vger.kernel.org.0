Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60409531960
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 22:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239669AbiEWRJo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 13:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239688AbiEWRJR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 13:09:17 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE976C551
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 10:08:44 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id v5-20020a17090a7c0500b001df84fa82f8so14277313pjf.5
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 10:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uK7zWhPgTviXqXYHmjcU5HgKkTwKfvMNEivVJxrokqI=;
        b=I4mZzxpnMdtl5r/OI2mro7EONXLGZYUzgGE6EpecIch+Vd92UnwKLr5YrnQhp9eLzV
         NqE92M8A3p1dFTEDn8rGNC7GNhJImeycnrvrI6N88C8WZqOyt47rombESxxU3Uy/6YzQ
         6VYvtRgbrwRxAn54GzIj0fjlnm1WnKePpY+rO6zItfXsQKiXKxKFb+K2j15lisDgeRlu
         2mYWOLr4hg9ZhX4YsBLzcL2U3CNyMjIy6iPbCuqpziXrozXfdxvQSxT0Ic9u3ohkMnLn
         nR0MzaDm7OEzGSbg888rfsTpK2JDt5x4ch1/lOLkkRRSJaDJJ3XfATUlGtAYkBciy8km
         cosw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uK7zWhPgTviXqXYHmjcU5HgKkTwKfvMNEivVJxrokqI=;
        b=3f+jtVB4N9BjjqZjhW5UCo4Lk1FgurxypUm0TRQx6ewkwwEU59qT1Avi22tREMS30p
         BpIBG4E+aYmLMACVNU+NpYsP6LcCDk7VpZ1O8f1vWZS2PL2W3OQPfdTPG9yuQ9P8uPOe
         lTcUz36DiWyEUUKbrdqLtPRFebWjUsnNc5uJK6XRU32cPjhlSPVgbDRS3C9sIQWUxQZu
         r+H0qDkJV8oTY6VFEbG8dM8gKVMkd3EHKwFkFxzMA/AL7afuswbs58Vj8vXzicVNnteb
         yiE2hRfmdxUbC404SPP3BdcLLabElK/P9aHsHL/jeO8SXKFpX5G3xhd3lX0WShl0/AXe
         lDtQ==
X-Gm-Message-State: AOAM532iZccJJNAwg+PfW9KIKSMcArBp1qFbXkklE9rY276y0SeYSAxs
        vFulHFe6nuy1P9TgYwmdTkAUWg==
X-Google-Smtp-Source: ABdhPJx84osU8G9CwYuEgl2LS8dR4q+OA2gnCMyACiHeyWSm7YhzSZUNLZKU05NbcS4jeMvX/KERXg==
X-Received: by 2002:a17:902:e3d4:b0:162:23a7:a7e7 with SMTP id r20-20020a170902e3d400b0016223a7a7e7mr6182211ple.32.1653325718537;
        Mon, 23 May 2022 10:08:38 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u8-20020a170903124800b0016196bd15f4sm5492264plh.15.2022.05.23.10.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 10:08:38 -0700 (PDT)
Date:   Mon, 23 May 2022 17:08:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lev Kujawski <lkujaw@member.fsf.org>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: set_msr_mce: Permit guests to ignore single-bit ECC
 errors
Message-ID: <You/kms+AnKE1t0L@google.com>
References: <20220521081511.187388-1-lkujaw@member.fsf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220521081511.187388-1-lkujaw@member.fsf.org>
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

"KVM: x86:" for the shortlog scope.

On Sat, May 21, 2022, Lev Kujawski wrote:
> Certain guest operating systems (e.g., UNIXWARE) clear bit 0 of
> MC1_CTL to ignore single-bit ECC data errors.

Not that it really matters, but is this behavior documented anywhere?  I've searched
a variety of SDMs, APMs, and PPRs, and can't find anything that documents this exact
behavior.  I totally believe that some CPUs behave this way, but it'd be nice to
document exactly which generations of whose CPUs allow clearing bit zero.

> Single-bit ECC data errors are always correctable and thus are safe to ignore
> because they are informational in nature rather than signaling a loss of data
> integrity.
> 
> Prior to this patch, these guests would crash upon writing MC1_CTL,
> with resultant error messages like the following:
> 
> error: kvm run failed Operation not permitted
> EAX=fffffffe EBX=fffffffe ECX=00000404 EDX=ffffffff
> ESI=ffffffff EDI=00000001 EBP=fffdaba4 ESP=fffdab20
> EIP=c01333a5 EFL=00000246 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
> ES =0108 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
> CS =0100 00000000 ffffffff 00c09b00 DPL=0 CS32 [-RA]
> SS =0108 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
> DS =0108 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
> FS =0000 00000000 ffffffff 00c00000
> GS =0000 00000000 ffffffff 00c00000
> LDT=0118 c1026390 00000047 00008200 DPL=0 LDT
> TR =0110 ffff5af0 00000067 00008b00 DPL=0 TSS32-busy
> GDT=     ffff5020 000002cf
> IDT=     ffff52f0 000007ff
> CR0=8001003b CR2=00000000 CR3=0100a000 CR4=00000230
> DR0=00000000 DR1=00000000 DR2=00000000 DR3=00000000
> DR6=ffff0ff0 DR7=00000400
> EFER=0000000000000000
> Code=08 89 01 89 51 04 c3 8b 4c 24 08 8b 01 8b 51 04 8b 4c 24 04 <0f>
> 30 c3 f7 05 a4 6d ff ff 10 00 00 00 74 03 0f 31 c3 33 c0 33 d2 c3 8d
> 74 26 00 0f 31 c3
> 
> Signed-off-by: Lev Kujawski <lkujaw@member.fsf.org>
> ---
>  arch/x86/kvm/x86.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4790f0d7d40b..128dca4e7bb7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3215,10 +3215,13 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			/* only 0 or all 1s can be written to IA32_MCi_CTL
>  			 * some Linux kernels though clear bit 10 in bank 4 to
>  			 * workaround a BIOS/GART TBL issue on AMD K8s, ignore
> -			 * this to avoid an uncatched #GP in the guest
> +			 * this to avoid an uncatched #GP in the guest.
> +			 *
> +			 * UNIXWARE clears bit 0 of MC1_CTL to ignore
> +			 * correctable, single-bit ECC data errors.
>  			 */
>  			if ((offset & 0x3) == 0 &&
> -			    data != 0 && (data | (1 << 10)) != ~(u64)0)
> +			    data != 0 && (data | (1 << 10) | 1) != ~(u64)0)
>  				return -1;

If KVM injects a #GP like it's supposed to[*], will UNIXWARE eat the #GP and continue
on, or will it explode?  If it continues on, I'd prefer to avoid more special casing in
KVM.

If it explodes, I think my preference would be to just drop the MCi_CTL checks
entirely.  AFAICT, P4-based and P5-based Intel CPus, and all? AMD CPUs allow
setting/clearing arbitrary bits.  The checks really aren't buying us anything,
and it seems like Intel retroactively defined the "architectural" behavior of
only 0s/1s.

[*] https://lore.kernel.org/all/20220512222716.4112548-2-seanjc@google.com
