Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16E6E64EF41
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 17:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbiLPQgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 11:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiLPQgP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 11:36:15 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDA32DAB9
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 08:36:14 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id 4so2854030plj.3
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 08:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aEd4hKGMppKGZVeq5JM+IYpIXDRgajRRp4xQvAHAPrs=;
        b=sDR58jXvqAnFxfz6nUsattzIR3FgaTrEZLc3SFVs6tVsQFda9WUt5qN0vBqRMyuBV/
         ylWoMO2VpbGmNq2Q5NPTf2/GsyzInjATOQ+whttomZ3GUAa2O6BwdRV3sYYQ6SQWg1oJ
         kOIohW0FYJ/frJnW6GbI89iK2ePP+8S5gNJGH1yf49Cj5fuJYxHwGRcKpqlGe9FEjv8N
         RZ3AKTU8g24v/Tvja9Fmo8jJ1W2ng7EldrQYCB/7XjYmYOVe3+rvCnkyh3FJ2T1PZ5li
         OhqZC7oSyvZfzDbx/r1Jb6tDJ1vkY+q9npj3paMELCpm/0YrdXH0d0hMsHoBd/VryA00
         l3Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aEd4hKGMppKGZVeq5JM+IYpIXDRgajRRp4xQvAHAPrs=;
        b=yxjyi9Y5rqH5fKUh3dYmIVf2gd0sNyLNTrofX3ewP/YztzTbHfHMqZMkRFHtmnsdpf
         XAGEhzWXnrRq3lIPUPtrW+03J791ra96RGVHUfGKDJVQqw0eybrO0W4RrA8qhPkqT4n0
         Nhc/ZnItA5MhrKIQhgDF0pImX2bgXkh0tbRlD90j/a6eto1YmgL+aK47BZC8MEA0Poav
         aXUfy9/Jp8oeH3SGBv/+xm/RTA4aYYAN/GNMwTSXjmJbgVvIvUhQkkQMQbOuMCRBNW4V
         gkCJbSBATUepRbd+D90f82FxlqyAN7ymlWyj/4IBZgq7SLhYD097Lb28SaLQABIvSigC
         eZhw==
X-Gm-Message-State: AFqh2kp7vce+En2B+QzALTRGvUHlPAcogCPZxAtCdgcu9DjZeBwEotoE
        dpFHE5lwc0ocNBYsfzVyHMrryA==
X-Google-Smtp-Source: AMrXdXuQz7i01sD8Q5EezaX4XeTScr0FwM3U0UcP2WMfl+IYHhQ/nytk6+MONGvaOiWhqKk7VOdAdQ==
X-Received: by 2002:a17:90a:77c5:b0:219:d1eb:b8ad with SMTP id e5-20020a17090a77c500b00219d1ebb8admr617309pjs.2.1671208573991;
        Fri, 16 Dec 2022 08:36:13 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g19-20020a17090a579300b002191ffeac8esm1600996pji.20.2022.12.16.08.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 08:36:12 -0800 (PST)
Date:   Fri, 16 Dec 2022 16:36:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, oliver.upton@linux.dev,
        catalin.marinas@arm.com, will@kernel.org, dwmw2@infradead.org,
        paul@xen.org
Subject: Re: [PATCH v4 2/2] KVM: MMU: Make the definition of 'INVALID_GPA'
 common
Message-ID: <Y5yeeJR5utT1GSab@google.com>
References: <20221216085928.1671901-1-yu.c.zhang@linux.intel.com>
 <20221216085928.1671901-3-yu.c.zhang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221216085928.1671901-3-yu.c.zhang@linux.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 16, 2022, Yu Zhang wrote:
> KVM already has a 'GPA_INVALID' defined as (~(gpa_t)0) in
> kvm_types.h, and it is used by ARM and X86 xen code. We do
> not need a specific definition of 'INVALID_GPA' for X86.
> 
> Instead of using the common 'GPA_INVALID' for X86, replace
> the definition of 'GPA_INVALID' with 'INVALID_GPA', and
> change the users of 'GPA_INVALID', so that the diff can be
> smaller. Also because the name 'INVALID_GPA' tells the user
> we are using an invalid GPA, while the name 'GPA_INVALID'
> is emphasizing the GPA is an invalid one.
> 
> Also, add definition of 'INVALID_GFN' because it is more
> proper than 'INVALID_GPA' for GFN variables.

Please wrap closer to ~75 chars, ~60 is too aggressive.

> No functional change intended.
> 
> Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> Reviewed-by: Paul Durrant <paul@xen.org>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
