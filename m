Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1FF63DAAF4
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 20:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhG2Se7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 14:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbhG2Se6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 14:34:58 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53822C0613C1
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 11:34:55 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id b6so11531148pji.4
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 11:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FjblcnAL1F0aR+MZbbpGjWsRwRTKiIvSrT/0NGSt3+I=;
        b=nt9DNGMEFjiB4wpXsI70TwscttxExMZzW/a/RhpGNhuraJtM+ybGM0wHnFZWHYdKS9
         Rh/S3ZbxiWOoBouqr+Ih+m0hn1Sx6Dyu7wHwfUtmLYFRnpoBci3YL7EBG445G9wVhz9d
         WJz7y3JuAyKC1UNgNOMQJCTiqQVT0Sacold172ir9tfZNnAEI9iFGx7N3AkJxaLhTkq4
         vHDYig6FPRFJ0Veiqp4nuBT3Tx2e25IpggZaOhLRg0ZNa30uZxB0wDLP+cS7EH5SWle3
         Xe718VAzdOmLSqDFL0UjW3Qkl++oszsnAK/ZL+mNXBxmi3NXR6cwOB5J7bRN6NOLMH9O
         LTyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FjblcnAL1F0aR+MZbbpGjWsRwRTKiIvSrT/0NGSt3+I=;
        b=fq+1DML70bUkWAfgGMNwZEo9Kp/4quu7WL+zH1kkThXpJ/hcPPS9J4UAZ8Oz/x6Eku
         rqNHW4q7lfWxoCtbjF5eqg4DOY5yosQfMu3cXvaEkU8SwoBFaC4EJSmjhu1m8jBddzeW
         wC/kyoxeBgNO4Ai4MnjXAo2ktJWiHkhdiFlQPah0MsRlkia2dYv+ZC9EnmD//23LhfGP
         /jXPd3jMhxBSpmvoZYgNQ+WGocJq1C+jMaoA6o/a43SeiX3bSBmiOGblzLvYVcPga90M
         LrWkdv7olXrdT0kTf81XQGNBSTMqxs3kGQFv7NKpjoMEVjA8iZF2ULnzd+DGktGgS2oJ
         Oz9g==
X-Gm-Message-State: AOAM532LVqxbzIy3kz5y/8YCCYm2eowb9GY23dfo5qleN3R9Qti3KVmw
        r8J+58M70fLd+vKyYjmj/eaPUw==
X-Google-Smtp-Source: ABdhPJxUjem26RBTJNQlHTYHwsPkTqsWbqnLi1r51MVSPxydecNwkncG1GXgl7vkGg519fHMu3d7Qw==
X-Received: by 2002:a63:cd4c:: with SMTP id a12mr4882452pgj.449.1627583694654;
        Thu, 29 Jul 2021 11:34:54 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s31sm4817959pgm.27.2021.07.29.11.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 11:34:54 -0700 (PDT)
Date:   Thu, 29 Jul 2021 18:34:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v2 2/3] KVM: x86/mmu: Avoid collision with !PRESENT SPTEs
 in TDP MMU lpage stats
Message-ID: <YQL0yjwYzJKJ0pTe@google.com>
References: <20210726175357.1572951-1-mizhang@google.com>
 <20210726175357.1572951-3-mizhang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726175357.1572951-3-mizhang@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 26, 2021, Mingwei Zhang wrote:
> Factor in whether or not the old/new SPTEs are shadow-present when
> adjusting the large page stats in the TDP MMU. A modified MMIO SPTE can
> toggle the page size bit, as bit 7 is used to store the MMIO generation,
> i.e. is_large_pte() can get a false positive when called on a MMIO SPTE.
> Ditto for nuking SPTEs with REMOVED_SPTE, which sets bit 7 in its magic
> value.
> 
> Opportunistically move the logic below the check to verify at least one
> of the old/new SPTEs is shadow present.
> 
> Use is/was_leaf even though is/was_present would suffice.  The code
> generation is roughly equivalent since all flags need to be computed
> prior to the code in question, and using the *_leaf flags will minimize
> the diff in a future enhancement to account all pages, i.e. will change
> the check to "is_leaf != was_leaf".
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>

There's no hard rule for when to use Suggested-by vs. giving Author credit, but
in this case, since you took the patch and changelog verbatim[*] (sans the missing
tags below), it's more polite to take the full patch (with me as Author in
this case) and add your SOB since you're posting the patch.

  Fixes: 1699f65c8b65 ("kvm/x86: Fix 'lpages' kvm stat for TDM MMU")
  Cc: stable@vger.kernel.org

[*] https://lkml.kernel.org/r/YPho0ME5pSjqRSoc@google.com

> Signed-off-by: Mingwei Zhang <mizhang@google.com>
