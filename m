Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A22B45FBB36
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 21:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiJKTPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 15:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiJKTPl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 15:15:41 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4DF5FF58
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 12:15:39 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id c24so14110790pls.9
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 12:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gyuABnJw/T589iuhSb5mht/YLLE+xLjud9zjMiPRJI4=;
        b=mHljrkmgI8NGzkYjKAyz3szyp2BEF52+qwqaVnORtSZMYF+dhEncTMEL7eIQQSX5aw
         8GFwqpOJYQ97b2P7GU352b62eUOIxPu/9NlmXwY0t2oh9AUgkkufZOTT8TNAAmgL+6ZM
         T3YqlbNiW1zSg1TUrnm9yONL4mc+raRqs9G4y9vYNprVKRbDdtAu9D7H/jZ2TZJYqSpy
         uw8gDr4RGrkWNZgiUGAWg0gEmaWtjh0k2tyWMhXJmTkxkZd7VZYWMZ4nxf4fnB0FQ79J
         fHQer3d3HP6qCqNRWpLfQ30QItCMRiheraiau6EzHjPb+GCS0hQjaLIP9JsbmbPV7lQv
         u2cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gyuABnJw/T589iuhSb5mht/YLLE+xLjud9zjMiPRJI4=;
        b=Jq7vF/yUqvXvYre+CkK6Q03n/YxYDKWEwudZRxWBVX1CsQOv1jxXYzb6Y6xv/i5Asx
         tAf0stUYG/Enu1b+3hNFOBUO4ARyVNZ6nPH7REVVEnpZWG26x8k7dTAAbJgMNAWcvT3e
         2WAsY8WJ1tmwkSnbtD4yZotGC1qph0ln5Qu6tlJrXiPPtTrlnGGX/GaFdGQlxi+25KLD
         VmiE0ar+4q9k+G0jz09i5Es4krmu4XQ05SAsnDeXL6Twv84uPpBVU+9zzLF9WxfFWoti
         9aJMGX0NnPFBmeMtYPX0LhQTrI4sam2aLKWQ85Mfufj+eDL20Vq8c/r7697f2g5+98Mg
         SzEA==
X-Gm-Message-State: ACrzQf29I1lyf19iVydkdQmll4obpgMU2LwB4mKA0NdEeDXixxak0VsT
        S9SyfM+CpGpJBxQVUwHV+DEVbQ==
X-Google-Smtp-Source: AMsMyM6r7Mgl+VA2MqserQBZOFIzFB2iRK0PYyXc5YH0R7A5S8wz05QJ76hddhlqdl7inBV2w7raWQ==
X-Received: by 2002:a17:903:2616:b0:17f:8042:723a with SMTP id jd22-20020a170903261600b0017f8042723amr26791188plb.106.1665515737936;
        Tue, 11 Oct 2022 12:15:37 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b8-20020a17090a7ac800b00205d70ccfeesm11134681pjl.33.2022.10.11.12.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 12:15:37 -0700 (PDT)
Date:   Tue, 11 Oct 2022 19:15:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/6] KVM: x86: Introduce CPUID_8000_0007_EDX
 'scattered' leaf
Message-ID: <Y0XA1f+H8NxzcMW4@google.com>
References: <20220922143655.3721218-1-vkuznets@redhat.com>
 <20220922143655.3721218-3-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922143655.3721218-3-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022, Vitaly Kuznetsov wrote:
> diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
> index a19d473d0184..a5514c89dc29 100644
> --- a/arch/x86/kvm/reverse_cpuid.h
> +++ b/arch/x86/kvm/reverse_cpuid.h
> @@ -12,7 +12,8 @@
>   * "bug" caps, but KVM doesn't use those.
>   */
>  enum kvm_only_cpuid_leafs {
> -	CPUID_12_EAX	 = NCAPINTS,
> +	CPUID_12_EAX		= NCAPINTS,
> +	CPUID_8000_0007_EDX	= NCAPINTS + 1,

No need to explicitly initialize the new leaf, only the first enum entry needs
explicit initialization to NCAPINTS, i.e. let all other entries automatically
increment.  The order doesn't matter, so not caring about the exact value will
avoid bugs due to mismerge and/or bad copy+paste.
