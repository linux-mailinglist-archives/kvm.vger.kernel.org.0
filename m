Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16CF972322A
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 23:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbjFEVXI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 17:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjFEVXG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 17:23:06 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6BE1D9;
        Mon,  5 Jun 2023 14:23:05 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-64d57cd373fso4629350b3a.1;
        Mon, 05 Jun 2023 14:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686000185; x=1688592185;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fzeZkrlpXedAtX9zdkw2APzq4njcn3CbLsY5JQUPv/E=;
        b=LcWPNPiFdDNEam3MgEvXZJysFMGjW0Uymb6gNIOGgQFEu+NORbzBEdr1tU/ddkywXG
         so5o+glctNhw8fcdXV/8I9YMsNRvehFTLsE5WmAyFkoz5E0kQBhqZ1VpLhMcbmr6Clry
         YHF6e/RuNM8flkHRpxU+sfO8RHdblJb15c5sTEuqHuTPr6REOdCfKK3d1KFOWTq0xZ9i
         PRFwW2li65f8aoU1M087kkNpuHHROwzNGregTHPHePyf6N1svx/dhqvbVHwJflUnzlFA
         qLmIUXFlbtF6u6tIXvJZ4FvYlZgVZQlR1/qpmVpxRllJVRDcEMFido+bA70pls4USDNs
         wnXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686000185; x=1688592185;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fzeZkrlpXedAtX9zdkw2APzq4njcn3CbLsY5JQUPv/E=;
        b=CPpDUvky/ho3jz1MMrOyjkpJ9U2hLzltVcYPhGtjM5u95ypRp6Wxv1bbPFLRfwa2+5
         iCsZ+L9DhreRhMcx72LNeM8GAeSCj6U6qf7HLwJzgqpKtrfKRX3HxNeK7noseqRog7od
         TgO0Tayv6Polq00Rd2XvV/aIjKthop8oGXW/62eHBYgvlV9bBsrwpwbTUfXt5qAlRAGO
         FrFXNpmJgX1P3S+e3K9jzwDkApKAMlARhfaWLN5gUtBUa5oqDV636crYrxlK7dDmKpNf
         1901qjZoG4s1QNnjpEP92ksmMsQXvc5qWDgc9tiT0S/HFgwYTCVSjyebfizC0jGLTHVw
         n1hg==
X-Gm-Message-State: AC+VfDys3WmEMvbX4tpMP9q0/tCRx1+TtDMOMCekx0oKqHOIO+r/X/S2
        v6C91gQzgrLdkE3xpLDdoVg=
X-Google-Smtp-Source: ACHHUZ7Ag4FEFdhlo/sRHRCtwhPl5JAsLXJ7S3PP2Q54h6gfKU5gCeBO9z20RSJRwX6F1YVDWFuEIw==
X-Received: by 2002:a05:6a20:8f1f:b0:105:2e9e:b13a with SMTP id b31-20020a056a208f1f00b001052e9eb13amr253759pzk.8.1686000185056;
        Mon, 05 Jun 2023 14:23:05 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id d16-20020aa78690000000b006519b6ba20bsm5655054pfo.3.2023.06.05.14.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 14:23:04 -0700 (PDT)
Date:   Mon, 5 Jun 2023 14:23:03 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, isaku.yamahata@gmail.com
Subject: Re: [PATCH v11 07/20] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Message-ID: <20230605212303.GA2244082@ls.amr.corp.intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
 <21b3a45cb73b4e1917c1eba75b7769781a15aa14.1685887183.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <21b3a45cb73b4e1917c1eba75b7769781a15aa14.1685887183.git.kai.huang@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 02:27:20AM +1200,
Kai Huang <kai.huang@intel.com> wrote:

> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index b489b5b9de5d..03f74851608f 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -102,8 +102,12 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
>  
>  #ifdef CONFIG_INTEL_TDX_HOST
>  bool platform_tdx_enabled(void);
> +int tdx_cpu_enable(void);
> +int tdx_enable(void);
>  #else	/* !CONFIG_INTEL_TDX_HOST */
>  static inline bool platform_tdx_enabled(void) { return false; }
> +static inline int tdx_cpu_enable(void) { return -ENODEV; }
> +static inline int tdx_enable(void)  { return -ENODEV; }
>  #endif	/* CONFIG_INTEL_TDX_HOST */
>  
>  #endif /* !__ASSEMBLY__ */

Please include errno.h.
In the case of !INTEL_TDX_HOST && INTEL_TDX_GUEST,
drivers/virt/coco/tdx-guest/tdx-guest.c results in compile error.

Although there are other files that include asm/tdx.h, they seem to luckily
include errno.h directly or indirectly.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
