Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4CC3F7F0A
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 01:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233792AbhHYXcQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 19:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbhHYXcP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 19:32:15 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59365C061757
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 16:31:29 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id q21so551551plq.3
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 16:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bgT/xeyKOXnNMIg+PdpIMek16t1MpqSR/AfuX+wgSrA=;
        b=gOsmZJmwz/1EotD/4o/+JOTvdKprAHG3QXqP2jWFxCkc65Jxlox1da9kyvbK/kw++V
         5iI/gbkrqst0NPvnibea0EzhlDUs5ix+e9h35hL4a/ESj2hCHHXzjwpFAsMSg4+HLfkr
         YL0Zxzp/cZLuMp68sm9woEizpwi9sDAR1cVayIwrAPt3DDKxx/npH0YS1bSZ8DgzGJUi
         +cwe7Sjsr67qJLqTdy1agguGlgNKZAnwPmND4EiXsJyVI0/p8t26zYHUAuSaBm8SzQj2
         mA1zXZGzUnXpknTG5xTs79zPPmjnkEgHY6itsAwcndriwvehWI3NlB1KYrSDMjE2YpvN
         yYXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bgT/xeyKOXnNMIg+PdpIMek16t1MpqSR/AfuX+wgSrA=;
        b=K59L+0b+NMJOJwGDV6yZM/mzFv+bPCvsVbVbRLLNeBRi7i3W/yx+aX2Uu948a02ep0
         ZmRtMFRap5KIctX1p3yZ90NpfMTNkpQqq/wo2ghigCc+cuHfbN3BrkDz7EH1B9N4G3p9
         eqIHn+1OEYPCQzJtt12K3Dy4xccJMUDNU/6O+j5doEU1JwOeH8qvRM0m+Q2A9t1G6kbh
         Tot3ej7R8BT1lMcP15MdXE1SgVsECewOC/SWUSfkwv0oKUC/6T3KkMFhwOk6djmikxCU
         dUG4zr5LceOGsbZED+YW5v9Wz6BYqxoEb2tqrJ2KAUSnbODjoF9YFBTUcACP2BZCNaP0
         ErrQ==
X-Gm-Message-State: AOAM531h6bjpuF2jzplCrIV1rr2tqfWJ/YURrhJS4sNibfSf/mAvL+Km
        7o+x09BTNv2BOkIr5ZcHTZ8VikPD8+fSdQ==
X-Google-Smtp-Source: ABdhPJw6SDAriO2g5V8ktvD46t9dMsDkD/rs6uDbktv6l47zN/mFXV+bDpC3wfJm5Q6WGnRJbeG9yA==
X-Received: by 2002:a17:902:ab52:b0:12d:92b8:60c7 with SMTP id ij18-20020a170902ab5200b0012d92b860c7mr746208plb.44.1629934288610;
        Wed, 25 Aug 2021 16:31:28 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n32sm879724pgl.69.2021.08.25.16.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 16:31:27 -0700 (PDT)
Date:   Wed, 25 Aug 2021 23:31:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH] KVM: x86/mmu: Refactor slot null check in
 kvm_mmu_hugepage_adjust
Message-ID: <YSbSzKt8m05/PO0J@google.com>
References: <20210824233407.1845924-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824233407.1845924-1-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021, David Matlack wrote:
> The current code is correct but relies on is_error_noslot_pfn() to
> ensure slot is not null. The only reason is_error_noslot_pfn() was
> checked instead is because we did not have the slot before
> commit 6574422f913e ("KVM: x86/mmu: Pass the memslot around via struct
> kvm_page_fault") and looking up the memslot is expensive.
> 
> Now that the slot is available, explicitly check if it's null and
> get rid of the redundant is_error_noslot_pfn() check.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
