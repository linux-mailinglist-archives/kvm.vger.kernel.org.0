Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4034D535190
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 17:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347991AbiEZPlR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 11:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbiEZPlP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 11:41:15 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585EF4EDE1
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 08:41:14 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id f18so1786023plg.0
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 08:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=23OJjTUh5xwHpjuXiYbwYomXhh3uJlf0iwZIOQOyt2s=;
        b=NA8SaUFDNl8nTnTqtWYzl3ZbAlHtcsDamTXlmyHrWe1F/BfU7Yfgkef4nlXqbSU7t8
         V51hamIq15W9OsXlY/8eIVWET0y/3L5JZ7H53eDcaHgMywS3RlEpxopX6g/hyT/Yr0is
         ZOagcgpDKAdcKEjsgTcAC5hwI7xCmUXyxjMog=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=23OJjTUh5xwHpjuXiYbwYomXhh3uJlf0iwZIOQOyt2s=;
        b=26YnTWv7GOLlLn/WNN+WLndfiJDMD18Zli+iPGLb5HvtYYTyyXGfuxVbNuJnO4uPrl
         zbktoHgTS9vxCozgbvujBb8CZPakiiX0NahJWCEcJMlvsJOhVHCkzFtUAC1nKjSYQKmV
         3Ao/i0N6k8IcRappqL4SPR/xwb0uVbOccMshZDysIUfGmLaBJvy9ntTD7pcpMDU/pdAn
         RE8A7deEAnj7wL9pUCC13adKvPd7KERo3PJ2SrLDPhHlVkL3916yvqrngbhn3uHog2M4
         iyjQK69ZKVocJVUUlFNG0TUZ1pO4Wr+SvrLaSVHe9sHyZB3JnpO+iEkmgCVPpRHmlgq4
         MosA==
X-Gm-Message-State: AOAM532OITP2PN4U7RYV4MJ9hn8dzNd4+O/0gS2+6GSne/v/NyL2ZTOl
        t0PRkClnEnAjoGfrPjvihq9+8A==
X-Google-Smtp-Source: ABdhPJzvsr60TSXtvArR65FA0PrLJPETHYX9aikzao9zJAi3b5W/nsv023pCuS1IIdsB2yXTJW2m6g==
X-Received: by 2002:a17:90a:6441:b0:1e0:b413:c290 with SMTP id y1-20020a17090a644100b001e0b413c290mr3231414pjm.179.1653579673888;
        Thu, 26 May 2022 08:41:13 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id a16-20020a170902ecd000b0015e8d4eb228sm1787207plh.114.2022.05.26.08.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 08:41:08 -0700 (PDT)
Date:   Thu, 26 May 2022 08:41:04 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Dinse <nanook@eskimo.com>
Subject: Re: [PATCH 4/4] KVM: x86: Use 16-bit fields to track dirty/valid
 emulator GPRs
Message-ID: <202205260840.3B83593@keescook>
References: <20220525222604.2810054-1-seanjc@google.com>
 <20220525222604.2810054-5-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525222604.2810054-5-seanjc@google.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 25, 2022 at 10:26:04PM +0000, Sean Christopherson wrote:
> Use a u16 instead of a u32 to track the dirty/valid status of GPRs in the
> emulator.  Unlike struct kvm_vcpu_arch, x86_emulate_ctxt tracks only the
> "true" GPRs, i.e. doesn't include RIP in its array, and so only needs to
> track 16 registers.
> 
> Note, having 16 GPRs is a fundamental property of x86-64 and will not
> change barring a massive architecture update.  Legacy x86 ModRM and SIB
> encodings use 3 bits for GPRs, i.e. support 8 registers.  x86-64 uses a
> single bit in the REX prefix for each possible reference type to double
> the number of supported GPRs to 16 registers (4 bits).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
