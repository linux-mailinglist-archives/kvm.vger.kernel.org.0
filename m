Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70ADF3DAAD5
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 20:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhG2SRF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 14:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbhG2SRC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 14:17:02 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A13C061765
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 11:16:57 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d17so7909423plh.10
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 11:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QcT13ioi7Udva2v8xy7VeLWfKV+j8bNd/FwGrC91o0U=;
        b=lQMP3cDFPKZ8xlFcPqczF1/tYUNJ8XQbVOyl5sgdq8YD1lbmSAqbRy4Yqh7/kd8tag
         WAvK0fWXX6IBAifWgdo6pPDSBXhhwEd4vLh4lpETMHUNw5orLWkUS2Jx6y4Bq618MIkJ
         IT+zD+l7fRHEb9bv3gmfkOZAOSbQTmuPk9/8B6+RBgpCTDHpxqkXNb9kwpoB915n2tzD
         0kDAsuVVL+s6ISQxaY2sZQXceXaZeEu/pmx16Ig+G4R4FhfjvjnxisF5X3mbt027jgjP
         sJ+w/4SBb3pjtj6i/eLFxxC2rNjNvORKLFmW+reRQN/RYUz3beInyiEDzNe7avclDUNq
         daGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QcT13ioi7Udva2v8xy7VeLWfKV+j8bNd/FwGrC91o0U=;
        b=lXsw0UxpB11h2wgyHMgreah29b12zU1mQ52QtwfMWt6ax9OCk5QhLgMcJYL0IKb2JJ
         Eh2Q9WckWAx+DdSdTQPcMf7uyaUgNFdod8hFZmz35ghleV5o/HyUJztFNir3BKRndGlW
         YdiEZTyYql2NlkgKnMxI4Rc2t+HqiqE4guHZWy0DxqBRxoDcjw9Y/YSr2XGG13BO0bSn
         P68uzcMcrCFtNjW1GN8Y2fReSotRxlr3FDCfhaLtepfjeD9HYLgye6eKz5aN0TTo6oRg
         22fSC+V7Y01SH7VMYWcyZniBkWr7C9Y/PahETUbkAw+nzN9RRwKIkkkEpwLlsAcoch+6
         zm8A==
X-Gm-Message-State: AOAM532BKVjgHv9isHDIGObFEXcqKJucJGrG+Wc/KMYVwJcCp8N1B+bj
        F/toTzT6oxDi0aKNmlbSUq+7jQ==
X-Google-Smtp-Source: ABdhPJxEefGqvCgiv/uyAlzKsO6/AN450gS22ti6+7oyI1PVQ9RAGM2MedXS440jd017Tk/uRGpufQ==
X-Received: by 2002:a17:902:eb43:b029:12c:76bc:d85f with SMTP id i3-20020a170902eb43b029012c76bcd85fmr4030830pli.23.1627582616701;
        Thu, 29 Jul 2021 11:16:56 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 21sm4146091pfh.103.2021.07.29.11.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 11:16:55 -0700 (PDT)
Date:   Thu, 29 Jul 2021 18:16:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v2 1/3] KVM: x86/mmu: Remove redundant spte present check
 in mmu_set_spte
Message-ID: <YQLwlP2aW8aarqNM@google.com>
References: <20210726175357.1572951-1-mizhang@google.com>
 <20210726175357.1572951-2-mizhang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726175357.1572951-2-mizhang@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 26, 2021, Mingwei Zhang wrote:
> Drop an unnecessary is_shadow_present_pte() check when updating the rmaps
> after installing a non-MMIO SPTE.  set_spte() is used only to create
> shadow-present SPTEs, e.g. MMIO SPTEs are handled early on, mmu_set_spte()
> runs with mmu_lock held for write, i.e. the SPTE can't be zapped between
> writing the SPTE and updating the rmaps.
> 
> Opportunistically combine the "new SPTE" logic for large pages and rmaps.
> 
> No functional change intended.
> 
> Suggested-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
