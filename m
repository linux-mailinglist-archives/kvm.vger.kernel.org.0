Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4169C52DA6C
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 18:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242088AbiESQii (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 12:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240934AbiESQih (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 12:38:37 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64822DFF45
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 09:38:33 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id nk9-20020a17090b194900b001df2fcdc165so9305797pjb.0
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 09:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5R5CIsenxtrkxTKlA3MXRGhcGTe2bd3z24V2JTX79wc=;
        b=qKiBkzaLa8x6UswSmJfUjwYZA/+8KqTAJth5R0NSkIFDS+OYa4KsG2uOIOgIGEQdP4
         F8mf2P2TCB85o7/umxXqrhR9Y71M26PoV9VW5PCToTGFtrBnh84Ox36EcDFBLWVp71jD
         XUqHHJtkU1aIZoAcr/4yG0jh3rkr4iZ6nyVh6EgEC+gAcHqOjsaXpiFmpOLk1JBJsMqF
         Dy47hm/WdCkWyLrEe65dUCuQzyzmf/ZvJxQxRDY8dIqoUHYIFuyJWOvXaxPmG2/nZQaw
         4q2fomKvJhevs2t2VPjRs0pMPgC3OMNtFLTy1febiE8+FpKTb9FgypUFQEX5dL8geTIh
         bWJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5R5CIsenxtrkxTKlA3MXRGhcGTe2bd3z24V2JTX79wc=;
        b=U6L4Z7KT3/p6W0KsIPLBtVy5WTMkfTPl7JtwlFZrFl+YGofVY5NXHNoJDvCxBloEws
         rf+11c53iVAvDhmlc6eyVMC4BvrNQq/pxznh4c3YKIMusPNBRjH84sNXamgNm25KdAQO
         Zaaz+RHAlA7Jy5k+5l/E/uHdcAUrgzjU7ZaP41MEY3FhXaXFdwMpmKT17KzwXfxRewyC
         UvjBi89VxuSK9NJI1k0h3z4ucIut+GrFpjSD1QKT2drAO0ELVYppdq029wCEDVGfeNkR
         EN4N94r7kPHupZ8fhPOXPfz1sLQUEFouqzXEnBsFrbxyaHoLwXY30dU+MJwz+p2d9Zo/
         rGOA==
X-Gm-Message-State: AOAM532oIpNrRoLBFIxXT5vN2jFV76ZG0r1aqAjP0iboPLRxJtL1KOmy
        pImJPV3BDiOUtj/aveOHCQjMSQ==
X-Google-Smtp-Source: ABdhPJxiRsm84/7Erm3zrVNXQjVrfgfFlxyNelaI6knzQLt/AHi12NfjLuBHc0kegGIYgOlMcbZmkQ==
X-Received: by 2002:a17:902:db11:b0:161:9513:da41 with SMTP id m17-20020a170902db1100b001619513da41mr5545300plx.145.1652978312706;
        Thu, 19 May 2022 09:38:32 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a32-20020a056a001d2000b0050dc762819bsm4173554pfx.117.2022.05.19.09.38.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 09:38:32 -0700 (PDT)
Date:   Thu, 19 May 2022 16:38:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH v3 05/19] x86: KVMGT: use
 kvm_page_track_write_tracking_enable
Message-ID: <YoZyhIuvxNZBOdko@google.com>
References: <20220427200314.276673-1-mlevitsk@redhat.com>
 <20220427200314.276673-6-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427200314.276673-6-mlevitsk@redhat.com>
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

On Wed, Apr 27, 2022, Maxim Levitsky wrote:
> @@ -1948,6 +1949,10 @@ static int kvmgt_guest_init(struct mdev_device *mdev)
>  	if (__kvmgt_vgpu_exist(vgpu, kvm))
>  		return -EEXIST;
>  
> +	ret = kvm_page_track_write_tracking_enable(kvm);
> +	if (ret)
> +		return ret;

If for some reason my idea to enable tracking during kvm_page_track_register_notifier()
doesn't pan out, it's probably worth adding a comment saying that enabling write
tracking can't be undone.

> +
>  	info = vzalloc(sizeof(struct kvmgt_guest_info));
>  	if (!info)
>  		return -ENOMEM;
> -- 
> 2.26.3
> 
