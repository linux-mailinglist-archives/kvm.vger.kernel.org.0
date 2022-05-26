Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49E1853517B
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 17:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347951AbiEZPdJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 11:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347948AbiEZPdI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 11:33:08 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB9B6899E
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 08:33:06 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id r71so1665488pgr.0
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 08:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FhSHAPuv3/q3I8JH5CgOANOnHgoQYal4YSK2ZHhUT9M=;
        b=jNgR2ONfSzMi5sF8c4lE4rL1KM+VXFqG7UB32z+dY14/d7GlVOZ+B3Ba6u4kZmWVlK
         pJ2yoS0cdUZmmznc1Cz3izQuNut/YzdRMIp2i3+sBoq0+69IqfnRCrqcvDs3nfTDYohx
         2yxGU4pzxh4mGE0pV9ckE+7x2JlobK98t/uSI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FhSHAPuv3/q3I8JH5CgOANOnHgoQYal4YSK2ZHhUT9M=;
        b=nxRje3bRpriAVSKOsdknryhttbV2uZYz8nYo2LCz2vKuc3ZeEYfl5d3FJCi9Adv+yu
         ccQcDXqgnd7QLRl39h+iID2Kn7radwHTTwWHiFRoMgwD+AUmJ+12CyN0dbDlLlCohR/V
         4eoQZ5hwB3aG4MpucgNw/Rb+14q/XuWqek6KcStMv4jNWgLGoODGk1BAcRmcGh015L9f
         raK5i0+yu9gb/SWyjjWmaTXCKuNFblQamQAznN7uVvwcuhx+lWHNcwue7M3xNXTCbAsy
         7YmmZoXvarhG9DRam0D1hgWPtF5W4TqXYT2H3miLlRDJPC23sbk61XW/1+gXTPGLzX6+
         7kbw==
X-Gm-Message-State: AOAM532yxa+41FW+eUmqMiZhHegnOBTXbbMsGDAIvCJO7MKThJZZR32Z
        klmDrbJEyCZzd8oW6S81ZSjkSg==
X-Google-Smtp-Source: ABdhPJy3+zSfp7T4ICC3r6iccs66TjUXP7l4W4HM1gJbsh0zao1O+3KFT+JZ476f2vorLGCLmzbWfQ==
X-Received: by 2002:a62:484:0:b0:50d:a020:88e5 with SMTP id 126-20020a620484000000b0050da02088e5mr39006814pfe.51.1653579186420;
        Thu, 26 May 2022 08:33:06 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id s8-20020a17090302c800b0015e8d4eb29esm1728109plk.232.2022.05.26.08.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 08:33:06 -0700 (PDT)
Date:   Thu, 26 May 2022 08:33:03 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Dinse <nanook@eskimo.com>
Subject: Re: [PATCH 1/4] KVM: x86: Grab regs_dirty in local 'unsigned long'
Message-ID: <202205260832.0301216FB6@keescook>
References: <20220525222604.2810054-1-seanjc@google.com>
 <20220525222604.2810054-2-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525222604.2810054-2-seanjc@google.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 25, 2022 at 10:26:01PM +0000, Sean Christopherson wrote:
> Capture ctxt->regs_dirty in a local 'unsigned long' instead of casting
> ctxt->regs_dirty to an 'unsigned long *' for use in for_each_set_bit().
> The bitops helpers really do read the entire 'unsigned long', even though
> the walking of the read value is capped at the specified size.  I.e. KVM
> is reading memory beyond ctxt->regs_dirty.  Functionally it's not an
> issue because regs_dirty is in the middle of x86_emulate_ctxt, i.e. KVM
> is just reading its own memory, but relying on that coincidence is gross
> and unsafe.

Right; there have bean a handful of other bitops-using-stuff-cast-to-ulong
that has been recently fixed elsewhere. Better to get them all squashed.
:)

> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
