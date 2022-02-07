Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64A654ACB0F
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 22:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235715AbiBGVRz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 16:17:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235483AbiBGVRy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 16:17:54 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786EDC061355
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 13:17:54 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id om7so993029pjb.5
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 13:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XY5k5ljBVWI5bMAb85HmCNvhkpfmLes+ATs89jNP/QA=;
        b=TAyfrufdEb8vTWJ73nm+nXkCBYdX/FahzxrqD0CkMO54xV9EJi/a/zGYo+0yG91LfJ
         i3aBZP1lw9kqGLhYAvj3w8pIOYUyDP88OTinW8BzpwGuaBUOwWyRcxmELLcRNZLtveu7
         4gKkngUgCT/Xy1lJ6GFo4U45trhWalknkm78iCcoRjYWrYVFurISErFsj+hynXjw3xVY
         vzP7XEjPkBSwF/Dm9QUE9aVb0DGhWfzArYUq45bj3p4qHUzEoqjh68HyuWQzaI9U3mXF
         WzBDkHEe861iU5sazX/Pf2YgP8Q29AInnB7ycpyvtWPEZpxO6PsF4xDjfs9topFevQDJ
         tzOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XY5k5ljBVWI5bMAb85HmCNvhkpfmLes+ATs89jNP/QA=;
        b=f7NskQpQQnpjWqPgt3YAZm/TWH6zrwO7ozOmVSyFa0x0M+mqp3dU+fAXBrF3CGUhxv
         rQifZnpkw6egjQ8ALdU3YjBF7OvvmQ0LcX1lv3EhjlZzm+GYRAIaNpSrRctk9ns7qku1
         hD9JaqXTMPuY74Ap/NH7mjWZOdx6lXlcvKzMryqEs/f5Q4O88ixsGPXwoupOVK1/tGqK
         eq2RN3zUrDARW/vUB7RmGIhezJa7XSW7Z9v8YHajbD0i/jwzzcwzAhRijZbiusSFghir
         5Do0TUKdGAM8yuphmFmG6lk61QyN4Lhc+vBYtkJ5nlhfEPEJkg4GvZoOqagkpIow0ku1
         pQZA==
X-Gm-Message-State: AOAM5329Y6PhsKXoHUXoObACiNGfZhZRvAA9DtdPeSX1CYhxu4mHBB4M
        AQtuHyTbJJEhsZ/IK7cE7fqolg==
X-Google-Smtp-Source: ABdhPJwD7jjb8FcQmLRMulYkhW96uRcozsypFHalpD/NUB7N/F8oWD12DQzVN15dsBaCTOtL6ztX5w==
X-Received: by 2002:a17:90b:2342:: with SMTP id ms2mr859377pjb.109.1644268673819;
        Mon, 07 Feb 2022 13:17:53 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f8sm13320314pfe.204.2022.02.07.13.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 13:17:53 -0800 (PST)
Date:   Mon, 7 Feb 2022 21:17:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de
Subject: Re: [kvm-unit-tests 10/13] x86: AMD SEV-ES: Handle RDTSC/RDTSCP #VC
Message-ID: <YgGMfsfJ2y8T0OBD@google.com>
References: <20220120125122.4633-1-varad.gautam@suse.com>
 <20220120125122.4633-11-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120125122.4633-11-varad.gautam@suse.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 20, 2022, Varad Gautam wrote:
> Using Linux's RDTSC #VC processing logic.

I vote we drop this patch and instead treat #VC on RDTSC{,P} as a failure.  KVM
should never intercept RDTSC or RDTSCP except to inject #UD on RDTSCP, and IMO
any hypervisor that deviates from the behavior for an SEV-ES guest is being
malicious.  That the SEV spec even allows reflecting them as #VC is ridiculous.
