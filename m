Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F12052540A
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 19:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357066AbiELRsS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 13:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357249AbiELRsR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 13:48:17 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4B4703CB
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 10:48:16 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id s14so5608708plk.8
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 10:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yMD4uNcX7nwJRnfdov6l+Is8lhR7QoKly26xhU/0yCM=;
        b=a2DxECy3eU2zyy4MddAkOcv2PBd76rNd44QMgMnvMmwYbizg7/qmN6Qry+idDfEa36
         z517rwt2kQOpPDjXoea53NJy/Myh6GWaa/TkS4GWoL64X8z0bzz5/jeeDx29hbvSWGfh
         WfNuOrkWFieGm4hfYIE0zCBngCJ9QfNm33QnCImYHgYmtySHb/olqw7UlScYH7sGOFLJ
         8lHE8hmDdpBWW3equ5E3jC4nyLnAuUrz9H/uHxc0uMUzJxtU6i6o2BadFo69ERA1vlBF
         S2e2yRCeqBj67pm1pblK+nlk2eDgIEDWMHsfwi0V4f2kZ5g5E+8yTmAd8GP7H2C5WDwh
         A0KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yMD4uNcX7nwJRnfdov6l+Is8lhR7QoKly26xhU/0yCM=;
        b=b/bC8UC8gkrRPeeoxaaf+PDwT2Jj//0Gq8nYmOWdEjwzsikg3Rxr6hLVytwKiofBIF
         ChmqlV7PIYjy8e8ytl9xzPx9Bqu6547DQD2zet25n0KyCGsgDUMF5ziD/X/kBUXG7odx
         5m8AzvOZlqlGU1QsgEr7qPHLRBcY/CQTkqu+Ikh8vsr9hA+ACXzWUP2SuHqyHv7xPXuB
         +xRDoJxf88T7shkapoPew1P32eRc/OyU0AYEnYSSIG8y0kjxLuYB+qRmJxjtGUUcG2gK
         NEMimpJdeYnNiu1osBPuZIh5e/l4G619ec/OiSGshiAfvPCMtnNHeZ67I2HGu5cQF0ws
         3pew==
X-Gm-Message-State: AOAM530LgIKFNiR4oZRnCOmm1Ss0/xvhq7GLwb6mLiLwG6mP4UWjNUzS
        3kSp28FAIdaJ299FB5X+JYo=
X-Google-Smtp-Source: ABdhPJzw+EbrJ6LJX96DmLzDfijMzsCp2s5e8tWVo6Nucj0Rqn9n2uyDg0zvF4QPYr4qTymAJVRNsw==
X-Received: by 2002:a17:902:7d89:b0:15e:e999:6b88 with SMTP id a9-20020a1709027d8900b0015ee9996b88mr1005914plm.98.1652377696104;
        Thu, 12 May 2022 10:48:16 -0700 (PDT)
Received: from localhost ([192.55.54.48])
        by smtp.gmail.com with ESMTPSA id i15-20020a655b8f000000b003c14af505fesm25838pgr.22.2022.05.12.10.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 10:48:15 -0700 (PDT)
Date:   Thu, 12 May 2022 10:48:14 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com, Gerd Hoffmann <kraxel@redhat.com>,
        Daniel P =?utf-8?B?LiBCZXJyYW5nw6k=?= <berrange@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com
Subject: Re: [RFC PATCH v4 10/36] i386/kvm: Move architectural CPUID leaf
 generation to separate helper
Message-ID: <20220512174814.GE2789321@ls.amr.corp.intel.com>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-11-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220512031803.3315890-11-xiaoyao.li@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 12, 2022 at 11:17:37AM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
> index b434feaa6b1d..5c7972f617e8 100644
> --- a/target/i386/kvm/kvm_i386.h
> +++ b/target/i386/kvm/kvm_i386.h
> @@ -24,6 +24,10 @@
>  #define kvm_ioapic_in_kernel() \
>      (kvm_irqchip_in_kernel() && !kvm_irqchip_is_split())
>  
> +#define KVM_MAX_CPUID_ENTRIES  100

In Linux side, the value was bumped to 256.  Opportunistically let's make it
same.

3f4e3eb417b1 KVM: x86: bump KVM_MAX_CPUID_ENTRIES

> +uint32_t kvm_x86_arch_cpuid(CPUX86State *env, struct kvm_cpuid_entry2 *entries,
> +                            uint32_t cpuid_i);
> +
>  #else
>  
>  #define kvm_pit_in_kernel()      0
> -- 
> 2.27.0
> 
> 

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
