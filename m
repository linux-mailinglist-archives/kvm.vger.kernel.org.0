Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4EA856C6E0
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 06:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiGIE0i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Jul 2022 00:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiGIE0b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Jul 2022 00:26:31 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A60EDFB8;
        Fri,  8 Jul 2022 21:26:30 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id f11so380493plr.4;
        Fri, 08 Jul 2022 21:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wblxU4ocX/6b7hDTeD8JaMDf+To2t7CvwCLO5H9GvsE=;
        b=EeqPE2CrKN+kONWxDFSM7+E3+N5RHT+v5JkHhvJIPY8wOjsSUwXCrWaGuzRtlk05zm
         GGin0I+CEMC18DH9ZDL/k+cuGRbO6TF5Bg5P6RHBmh5xI8oglkgQLbbUdveOCcfHd6Cc
         HUIr3SrOPsaPHx/5evo00JtyP3HjCRRKK2Ech5WDoMYfECR67CBOcFLI+NHyIR9dY3Zy
         qYxezJCG6MeuIIwvLtdscAO9K+uB0qAAzcPhs4/MFQNw0E8ZkvK/AuSm7/OFACXXgrdf
         CXSbPtjTp9f53F35kRSInDk6XyH8USHI2zDGIMdhoMtw4zj8dmz8m1zlboC9giV4PFdr
         VW1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wblxU4ocX/6b7hDTeD8JaMDf+To2t7CvwCLO5H9GvsE=;
        b=Q38YGyTNAAP2GDKASITtaw4zlQhBKaORKYqmxNenvTpsUt8ZAEvYYOd4ClF41EDuLn
         Cr5vU8OD6QRfGrAJBSgTik3857XAtiIXSKB/yB3fWBt9hMeIgyhnG/HPDuYRbkE54hZ8
         yghXzcZ+rnhAWkCmBveYd6EL+drCUztEzmzJ28L2WAHlVKNlYompP0be9s75FzPw5pOC
         NVTkRqVMKN2MxdOOLwsfEWGIPcETurp9NiMpOqpORQDnY2/0eh0HaEbd0WxLVT7L1DRY
         /Km9Oj9yzhEeuN7RytsnD8FmtVgAmOqnv2tZ2+4wGGLBM0clttr3/K/O++EXGcKBFi/4
         w4TQ==
X-Gm-Message-State: AJIora+Snn+yQpVa1Gi135Quq4nUAOq/JFegcJSLHQXcS7ugBmBcIrWe
        2WRThDBW4ODyLUusHu0dO+ZXUZqjo5U=
X-Google-Smtp-Source: AGRyM1thrTlZvy977uJjAuibEgWKaF0aYWH3JEJQJHBkWlP6wtka5PCgbctI/8N1WZ+bJgc75RNu4Q==
X-Received: by 2002:a17:902:9301:b0:16a:1c68:f8d6 with SMTP id bc1-20020a170902930100b0016a1c68f8d6mr7105053plb.72.1657340789768;
        Fri, 08 Jul 2022 21:26:29 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-88.three.co.id. [180.214.232.88])
        by smtp.gmail.com with ESMTPSA id f8-20020a17090ab94800b001ef42b3c5besm254697pjw.23.2022.07.08.21.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 21:26:29 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 4CC9C100151; Sat,  9 Jul 2022 11:26:26 +0700 (WIB)
Date:   Sat, 9 Jul 2022 11:26:26 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/12] Documentation: kvm: tdx-tdp-mmu: Properly format
 nested list for EPT state machine
Message-ID: <YskDcli+Lg6uKzYX@debian.me>
References: <20220709042037.21903-1-bagasdotme@gmail.com>
 <20220709042037.21903-9-bagasdotme@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220709042037.21903-9-bagasdotme@gmail.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 09, 2022 at 11:20:34AM +0700, Bagas Sanjaya wrote:
>  The state machine of EPT entry
>  ------------------------------
> -(private EPT entry, shared EPT entry) =
> -        (non-present, non-present):             private mapping is allowed
> -        (present, non-present):                 private mapping is mapped
> -        (non-present | SPTE_SHARED_MASK, non-present | SPTE_SHARED_MASK):
> -                                                shared mapping is allowed
> -        (non-present | SPTE_SHARED_MASK, present | SPTE_SHARED_MASK):
> -                                                shared mapping is mapped
> -        (present | SPTE_SHARED_MASK, any)       invalid combination
> +* (private EPT entry, shared EPT entry)
>  
> -* map_gpa(private GPA): Mark the region that private GPA is allowed(NEW)
> -        private EPT entry: clear SPTE_SHARED_MASK
> -          present: nop
> -          non-present: nop
> -          non-present | SPTE_SHARED_MASK -> non-present (clear SPTE_SHARED_MASK)
> +  * (non-present, non-present):
> +       private mapping is allowed
> +  * (present, non-present):
> +       private mapping is mapped
> +  * (non-present | SPTE_SHARED_MASK, non-present | SPTE_SHARED_MASK):
> +       shared mapping is allowed
> +  * (non-present | SPTE_SHARED_MASK, present | SPTE_SHARED_MASK):
> +       shared mapping is mapped
> +  * (present | SPTE_SHARED_MASK, any):
> +       invalid combination
>  
> -        shared EPT entry: zap the entry, clear SPTE_SHARED_MASK
> -          present: invalid
> -          non-present -> non-present: nop
> -          present | SPTE_SHARED_MASK -> non-present
> -          non-present | SPTE_SHARED_MASK -> non-present
> +* map_gpa (private GPA): Mark the region that private GPA is allowed(NEW)
>  
> -* map_gpa(shared GPA): Mark the region that shared GPA is allowed(NEW)
> -        private EPT entry: zap and set SPTE_SHARED_MASK
> -          present     -> non-present | SPTE_SHARED_MASK
> -          non-present -> non-present | SPTE_SHARED_MASK
> -          non-present | SPTE_SHARED_MASK: nop
> +  * private EPT entry: clear SPTE_SHARED_MASK
>  
> -        shared EPT entry: set SPTE_SHARED_MASK
> -          present: invalid
> -          non-present -> non-present | SPTE_SHARED_MASK
> -          present | SPTE_SHARED_MASK -> present | SPTE_SHARED_MASK: nop
> -          non-present | SPTE_SHARED_MASK -> non-present | SPTE_SHARED_MASK: nop
> +    * present: nop
> +    * non-present: nop
> +    * non-present | SPTE_SHARED_MASK -> non-present (clear SPTE_SHARED_MASK)
>  
> -* map(private GPA)
> -        private EPT entry
> -          present: nop
> -          non-present -> present
> -          non-present | SPTE_SHARED_MASK: nop. looping on EPT violation(NEW)
> +  * shared EPT entry: zap the entry, clear SPTE_SHARED_MASK
>  
> -        shared EPT entry: nop
> +    * present: invalid
> +    * non-present -> non-present: nop
> +    * present | SPTE_SHARED_MASK -> non-present
> +    * non-present | SPTE_SHARED_MASK -> non-present
>  
> -* map(shared GPA)
> -        private EPT entry: nop
> +* map_gpa (shared GPA): Mark the region that shared GPA is allowed(NEW)
>  
> -        shared EPT entry
> -          present: invalid
> -          present | SPTE_SHARED_MASK: nop
> -          non-present | SPTE_SHARED_MASK -> present | SPTE_SHARED_MASK
> -          non-present: nop. looping on EPT violation(NEW)
> +  * private EPT entry: zap and set SPTE_SHARED_MASK
>  
> -* zap(private GPA)
> -        private EPT entry: zap the entry with keeping SPTE_SHARED_MASK
> -          present -> non-present
> -          present | SPTE_SHARED_MASK: invalid
> -          non-present: nop as is_shadow_present_pte() is checked
> -          non-present | SPTE_SHARED_MASK: nop as is_shadow_present_pte() is
> -                                          checked
> +    * present     -> non-present | SPTE_SHARED_MASK
> +    * non-present -> non-present | SPTE_SHARED_MASK
> +    * non-present | SPTE_SHARED_MASK: nop
>  
> -        shared EPT entry: nop
> +  * shared EPT entry: set SPTE_SHARED_MASK
>  
> -* zap(shared GPA)
> -        private EPT entry: nop
> +    * present: invalid
> +    * non-present -> non-present | SPTE_SHARED_MASK
> +    * present | SPTE_SHARED_MASK -> present | SPTE_SHARED_MASK: nop
> +    * non-present | SPTE_SHARED_MASK -> non-present | SPTE_SHARED_MASK: nop
>  
> -        shared EPT entry: zap
> -          any -> non-present
> -          present: invalid
> -          present | SPTE_SHARED_MASK -> non-present | SPTE_SHARED_MASK
> -          non-present: nop as is_shadow_present_pte() is checked
> -          non-present | SPTE_SHARED_MASK: nop as is_shadow_present_pte() is
> -                                          checked
> +* map (private GPA)
> +
> +  * private EPT entry
> +
> +    * present: nop
> +    * non-present -> present
> +    * non-present | SPTE_SHARED_MASK: nop. looping on EPT violation(NEW)
> +
> +  * shared EPT entry: nop
> +
> +* map (shared GPA)
> +
> +  * private EPT entry: nop
> +
> +  * shared EPT entry:
> +
> +    * present: invalid
> +    * present | SPTE_SHARED_MASK: nop
> +    * non-present | SPTE_SHARED_MASK -> present | SPTE_SHARED_MASK
> +    * non-present: nop. looping on EPT violation(NEW)
> +
> +* zap (private GPA)
> +
> +  * private EPT entry: zap the entry with keeping SPTE_SHARED_MASK
> +
> +    * present -> non-present
> +    * present | SPTE_SHARED_MASK: invalid
> +    * non-present: nop as is_shadow_present_pte() is checked
> +    * non-present | SPTE_SHARED_MASK: nop as is_shadow_present_pte() is
> +      checked
> +
> +  * shared EPT entry: nop
> +
> +* zap (shared GPA)
> +
> +  * private EPT entry: nop
> +
> +  * shared EPT entry: zap
> +
> +    * any -> non-present
> +    * present: invalid
> +    * present | SPTE_SHARED_MASK -> non-present | SPTE_SHARED_MASK
> +    * non-present: nop as is_shadow_present_pte() is checked
> +    * non-present | SPTE_SHARED_MASK: nop as is_shadow_present_pte() is
> +      checked

IMO, the state machine lists above should have used tables instead.

-- 
An old man doll... just what I always wanted! - Clara
