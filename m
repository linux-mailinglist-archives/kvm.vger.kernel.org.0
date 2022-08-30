Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD445A6F23
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 23:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbiH3V36 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 17:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbiH3V3y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 17:29:54 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C3A6597
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 14:29:52 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id f12so12165084plb.11
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 14:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=5WLsBYjCbkwGCKMGaY8eL7UthKdutIGZNyDAn0hGpS0=;
        b=kNBGhWae7luRn0hrtktFtHSOouZPD2AgvcYa2UTj8TdvoVCoxEvre+RHdEwHcaEgEe
         OMIkzzBbaDGYEstUyi9LGxq5Nowdel36Ma4Qx8DIzN7EsoqmuZqovdwafOYvTiFFrmNR
         mUmvMt18tMCakau+TsIWOVrLRzDEsT2HZ7kXpNQ5ktyBSlMoP0xstMjz7BWHBr0iYDWi
         63tU4gyP1g6l0KuwDjNq+L3oe9yjX17Z0YTrun/3ALdbwqPWA1GN7Of6bO4InS778mjM
         B3j5wCBYWk2mquKfCFekiQ6mCk6ZRWf1+HaQtyGx7c4KehkoqFyjPTO/IK4uppVcHFDI
         CotA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=5WLsBYjCbkwGCKMGaY8eL7UthKdutIGZNyDAn0hGpS0=;
        b=2Chc+gvtqzmC3/Sty0DNBqJ4Nr8HQPdFi9dcXkEoI/IoLavsBVqnYA+cc9lJPPOtXZ
         l4wkz9wwnG93VJAKeT6RHSC5jHPyAvsarD4P2ej4fKBGcgk9W9QqqjZ2KxghtBaBFotn
         8NdkDDVPRjhI3WTr6dgN/zira/QYstu3Inil7IRTJUzYOkwDaqeWtRcCthUb0PqFK/9D
         NCjaPB1bAZqnobSc1jqjGED7FELZVoJkMDfWtUzJohQdk01/CN/FCJ89AJJcndA6icgP
         z1HaVJWXSg9RQEyuc4BaMEqu02mdtd+KBnFg1xP+ZfJzj4MvLG8AzCFZm80tgTg2rD1C
         DI7Q==
X-Gm-Message-State: ACgBeo1ltvdG51B+bUtipadZfYEr4Fpm66BM385945raJwXZTFZqn1LY
        zmNBbUr8+pOEEGeDea//C63n+w==
X-Google-Smtp-Source: AA6agR7t11ERimIUvAcQpNmwsKWH+5w/jqpScqI7wrOTu+HPiopoeTQJslR1Bprh2yWOY7qDacnVOw==
X-Received: by 2002:a17:903:1250:b0:172:614b:5f01 with SMTP id u16-20020a170903125000b00172614b5f01mr23279463plh.103.1661894992374;
        Tue, 30 Aug 2022 14:29:52 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b11-20020a170902d50b00b0016dc2366722sm10296184plg.77.2022.08.30.14.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 14:29:52 -0700 (PDT)
Date:   Tue, 30 Aug 2022 21:29:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v4 3/3] KVM: x86: Print guest pgd in kvm_nested_vmenter()
Message-ID: <Yw6BTJ1HpPdYR2E0@google.com>
References: <20220825225755.907001-1-mizhang@google.com>
 <20220825225755.907001-4-mizhang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825225755.907001-4-mizhang@google.com>
X-Spam-Status: No, score=-14.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 25, 2022, Mingwei Zhang wrote:
> ---
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index e7f0da9474f0..b2be0348bb14 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -591,9 +591,10 @@ TRACE_EVENT(kvm_pv_eoi,
>   */
>  TRACE_EVENT(kvm_nested_vmenter,
>  	    TP_PROTO(__u64 rip, __u64 vmcb, __u64 nested_rip, __u32 int_ctl,
> -		     __u32 event_inj, bool tdp_enabled, __u32 isa),
> +		     __u32 event_inj, bool tdp_enabled, __u64 guest_tdp,

s/guest_tdp_pgd to differentiate it from "tdp_enabled"


>         TP_printk("rip: 0x%016llx %s: 0x%016llx nested_rip: 0x%016llx "
> -                 "int_ctl: 0x%08x event_inj: 0x%08x nested_%s: %s",
> +                 "int_ctl: 0x%08x event_inj: 0x%08x nested_%s: %s, "
> +                 "guest_pgd: 0x%016llx",

It's a little gross, but this can spit out nested_eptp vs. nested_cr3 vs. guest_cr3.

>                 __entry->rip,
>                 __entry->isa == KVM_ISA_VMX ? "vmcs" : "vmcb",
>                 __entry->vmcb,

> @@ -624,7 +628,8 @@ TRACE_EVENT(kvm_nested_vmenter,
>  		__entry->int_ctl,
>  		__entry->event_inj,
>  		__entry->isa == KVM_ISA_VMX ? "ept" : "npt",
> -		__entry->tdp_enabled ? "on" : "off")
> +		__entry->tdp_enabled ? "on" : "off",

To keep things aligned, and because "on nested_eptp" reads as a combined
snippet

  event_inj: 0x00000000 nested_ept: off guest_cr3: 0x0000000001007000
  event_inj: 0x00000000 nested_ept: off guest_cr3: 0x0000000001007000
  event_inj: 0x00000000 nested_ept: on nested_eptp: 0x0000000007ec501e
  event_inj: 0x00000000 nested_ept: on nested_eptp: 0x0000000007ec501e

what about teaking the format so that the output looks like this?

  event_inj: 0x00000000 nested_ept=n guest_cr3: 0x0000000001007000
  event_inj: 0x00000000 nested_ept=n guest_cr3: 0x0000000001007000
  event_inj: 0x00000000 nested_ept=y nested_eptp: 0x0000000007ec501e
  event_inj: 0x00000000 nested_ept=y nested_eptp: 0x0000000007ec501e

Deviating from the ": " style bothers me, but I find this difficult to read.
Again, letters delimited by whitespace get visually clumped together.

  event_inj: 0x00000000 nested_ept: n guest_cr3: 0x0000000001007000
  event_inj: 0x00000000 nested_ept: n guest_cr3: 0x0000000001007000
  event_inj: 0x00000000 nested_ept: y nested_eptp: 0x0000000007ec501e
  event_inj: 0x00000000 nested_ept: y nested_eptp: 0x0000000007ec501e

And this looks like a typo

  event_inj: 0x00000000 nested_ept:n guest_cr3: 0x0000000001007000
  event_inj: 0x00000000 nested_ept:n guest_cr3: 0x0000000001007000
  event_inj: 0x00000000 nested_ept:y nested_eptp: 0x0000000007ec501e
  event_inj: 0x00000000 nested_ept:y nested_eptp: 0x0000000007ec501e

We could leave off the nested_{ept/npt} entirely and leave the differentation to
the nested_eptp vs. nested_cr3 vs. guest_cr3, but I don't think that's worth
shaving a few chars.
