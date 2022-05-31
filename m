Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E955395D4
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 20:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346790AbiEaSEW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 14:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346789AbiEaSEU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 14:04:20 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986D28AE74
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 11:04:18 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id s68so13501255pgs.10
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 11:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LpmMdysyC4EuwmfUpWYT4g8ctBwXLvzk07Qi2XK7JsM=;
        b=gX4P7zYcwxNMt3f/51KHmhU4a/ISIuExFCNA7tcwcFzpCqu49cJoSabKE1yXibyL9L
         mt6nfYUihQGZidZh0975O37DUTCCaC8YINroUYIbfuKxl3jJC1kW1zn3PrHOU0/HhGXF
         CXhSPA759RdAF+9XlYXeT8lK8Np4X62fd1iak=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LpmMdysyC4EuwmfUpWYT4g8ctBwXLvzk07Qi2XK7JsM=;
        b=GxFmNU/YwP/XT3je/DDeMHvcCGb82n6sl3znuY3iHLQnnT1nWyJ1l9TweNwxSqt2t8
         zmXzNKxjmFF4IBr7ucerm1MdnKgk3TTXzCTPbyUUvRQypINpdmEX/ultIHGDrCSHSat6
         xUNYn9KC9NnNoMi2iDjKL9mHhTGF+R92DnKYw8gaVX9oxESlG+gsN1iqjz+cI5lWlW9k
         VgfrS9wCHZrud0Gvk4Dn4lhQrr5O1oFxt5SbJqDDE6TH+7i5VI1iQLZGIcEAwYkCGVnC
         JYMCobciPBbIyutspSlSGR/q6opX7blT3y8Q2+y8mGZtm8wI5nLM9UJVau33NvCu/e3M
         Ysiw==
X-Gm-Message-State: AOAM530QL8Vk3AfAhoFvjP/DmM4TSVPJPrdD7Qb2zgh66+zwA6qr/Rtq
        zoeFOOXFoBLUnyfUoO2a6Cnjpw==
X-Google-Smtp-Source: ABdhPJzV8AW8cb7WymazRj58+zWlWGSrmquLGFfkOVWBvwJf0m1IVdQvtmejbHeVC9pF/EbsbvpqQA==
X-Received: by 2002:aa7:8432:0:b0:518:98a7:dbf9 with SMTP id q18-20020aa78432000000b0051898a7dbf9mr45813014pfn.28.1654020258084;
        Tue, 31 May 2022 11:04:18 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id u21-20020a056a00099500b0050dc76281bcsm11231926pfg.150.2022.05.31.11.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 11:04:17 -0700 (PDT)
Date:   Tue, 31 May 2022 11:04:17 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Dinse <nanook@eskimo.com>
Subject: Re: [PATCH v2 5/8] KVM: x86: Reduce the number of emulator GPRs to
 '8' for 32-bit KVM
Message-ID: <202205311104.381834A@keescook>
References: <20220526210817.3428868-1-seanjc@google.com>
 <20220526210817.3428868-6-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526210817.3428868-6-seanjc@google.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 26, 2022 at 09:08:14PM +0000, Sean Christopherson wrote:
> Reduce the number of GPRs emulated by 32-bit KVM from 16 to 8.  KVM does
> not support emulating 64-bit mode on 32-bit host kernels, and so should
> never generate accesses to R8-15.
> 
> Opportunistically use NR_EMULATOR_GPRS in rsm_load_state_{32,64}() now
> that it is precise and accurate for both flavors.
> 
> Wrap the definition with full #ifdef ugliness; sadly, IS_ENABLED()
> doesn't guarantee a compile-time constant as far as BUILD_BUG_ON() is
> concerned.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
