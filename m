Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C05F524D47
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 14:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353865AbiELMpy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 08:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351628AbiELMpv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 08:45:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6526EDEC7
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 05:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652359546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GE6JfwZBCORMKMiuFLLmROx+N1+Jhd1whG8cx/zsZ9o=;
        b=c0KG44EWDCp4K5TxMPVuYxnkKECpgFTY7BBOHYdQ4j+PN1RhXyViybthGyu2VeZFVUA601
        ZKqt92T2YhdkmieqDZg5aGg0N3orRJKcctrRihFuJhhf7CLrwMYoLGmWFKm/N2y3r0G0hl
        Yytj+aPXeHVpmG32TIci6cXx6hrqXgs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-Gm5MycUkOwiOagl_8nhyhg-1; Thu, 12 May 2022 08:45:45 -0400
X-MC-Unique: Gm5MycUkOwiOagl_8nhyhg-1
Received: by mail-wr1-f72.google.com with SMTP id t17-20020adfa2d1000000b0020ac519c222so2024380wra.4
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 05:45:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=GE6JfwZBCORMKMiuFLLmROx+N1+Jhd1whG8cx/zsZ9o=;
        b=7umlr0Z+G4q98FbnlCYGBjMicCPQXmT2zIxGQgslwCuygjUQMY3t50emDYGQtejKwH
         um9FB1ducDOICuBATdf738YNg+FX8dJ9xFtjiE+vdv79di3hMQ7XTWKbIy/TegP7cNuY
         TF+Yft4Q7rgifsfO62XILpR2lVBFUguXe9mN9Qf52kkTB1cB2fedPa+q+EWfyy/gMNqP
         W9VSW5fmDUIMvdYw2fDrAEG0ScRqHETJZAb2Fxg0b9vX29HrpSZOfZ46OxOK+bLr3Ra6
         pu5QU+2VVKIcYOeziFfFRTxnf+j6qzGDV+zgDSDYTNle96fjrlAKO54/jw5BD2DiCTMn
         zccQ==
X-Gm-Message-State: AOAM5328VacAiPMFJfXo9xR6vnf0bQx616hznkPPDHastsMXLuhGe4Ue
        zbSy8KX34tE1gwl2Ie7duRsdMae6cv6ZOsZX3oQrYIOq/PFbOOmqaIVr8dgi5jEHH7x1hZTUj37
        6jb2jWEmPsq3j
X-Received: by 2002:a05:6000:2a2:b0:20c:999d:bdec with SMTP id l2-20020a05600002a200b0020c999dbdecmr27231152wry.36.1652359544477;
        Thu, 12 May 2022 05:45:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJztqWcgGDjjW9D8ehcA9/U1thvNGr5ujzH+lSg/D+ZXL9ikdaMlxHzDCdO8wke/OBeILi4NnA==
X-Received: by 2002:a05:6000:2a2:b0:20c:999d:bdec with SMTP id l2-20020a05600002a200b0020c999dbdecmr27231131wry.36.1652359544195;
        Thu, 12 May 2022 05:45:44 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id p190-20020a1c29c7000000b003942a244ee7sm2617058wmp.44.2022.05.12.05.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 05:45:43 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH] KVM: x86: fix a typo in __try_cmpxchg_user that caused
 cmpxchg to be not atomic
In-Reply-To: <20220512101420.306759-1-mlevitsk@redhat.com>
References: <20220202004945.2540433-5-seanjc@google.com>
 <20220512101420.306759-1-mlevitsk@redhat.com>
Date:   Thu, 12 May 2022 14:45:42 +0200
Message-ID: <875ymayl55.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> Fixes: 1c2361f667f36 ("KVM: x86: Use __try_cmpxchg_user() to emulate atomic accesses")
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Yes, this is the root cause of the TDP mmu leak I was doing debug of in the last week.
> Non working cmpxchg on which TDP mmu relies makes it install two differnt shadow pages
> under same spte.

In case the fix is not squashed with 1c2361f667f36, the above should
really go before '---'.

>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8ee8c91fa7625..79cabd3d97d22 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7329,7 +7329,7 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
>  		goto emul_write;
>  
>  	hva = kvm_vcpu_gfn_to_hva(vcpu, gpa_to_gfn(gpa));
> -	if (kvm_is_error_hva(addr))
> +	if (kvm_is_error_hva(hva))

Looks like a typo indeed, so

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

>  		goto emul_write;
>  
>  	hva += offset_in_page(gpa);

-- 
Vitaly

