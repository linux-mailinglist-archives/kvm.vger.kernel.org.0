Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83B9864E05A
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 19:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiLOSMN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 13:12:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiLOSML (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 13:12:11 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD052ED5C
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 10:12:10 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id c13so152843pfp.5
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 10:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=44wPBJHMzNhyX/AAPpFtXoVHvuAOAeLVHAd9v4kfyfk=;
        b=oQbLfsmhc/G0OJn6VfhXCwK4K+Q++I9g8Ek7Ow3JL25sNin9dV5XdkkT5fRn4eA0V7
         8sUEQ6i160A7+YQthiBbX+q53fUQvDQeoZETj5gqOukdCzKKXHb9hGqHsSseiuFeb4yV
         TVO+uBy2Q0TdbwWTeqypVdoues/X7o262uLhBTvmg7cpPsz5GKK9HZCUiJIlUJZEfApi
         mZtHbvntYoFaGOrTKD72Wc9k6eRnLa0TiCF7kTHBZ33xRIScUJHuGdF/A9CxaV49Rb5g
         t5kd97gmF+BVcJNSZsapAQii587lNHuDG3okxe9itFHJTk8Xzt7okaPUIUJmisHJj4KB
         uUlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=44wPBJHMzNhyX/AAPpFtXoVHvuAOAeLVHAd9v4kfyfk=;
        b=7P98qMp/XIbR6+/rIup+lSOJsPyfw/ktFowsWPiwthu74lCf5/8HITNJyZrAtJzziO
         Z3fv5RLnGKHZpS7wpwSv42xrGkkAPcQHit4ZnIbfKQzm/4V4nGRwYgYcAKahJDdQ7l5G
         9cMNkXfN5NuViaVMVqiQ9g4ffAhDsAEc+3NEsbiES9F21fpb4lgjEQbL4J5G2BmanUr1
         tUlnaUg8UmBG/fIonELBqr8e8RwNG/XwEtMz02XrX0h+AxfY3xUOGuhOEJ1zgazlb9wu
         jhpXTZFd2Chbr6nmFhsDxM3JR8MWw4euzx1xO7tEGOJwRTRw965HlxtYQ+rN1KNpppV/
         Nwcg==
X-Gm-Message-State: AFqh2kojj2hkP8etMTXXnzjRO3DeKXsCXXSvS8LM1jkw/mPjo6xbMOzP
        E2UfTdWeeDrOya6R4Pm//xNP2w==
X-Google-Smtp-Source: AMrXdXstWHhMXomeOXys+CMrPMBz+Nk2ZO0j1YcX3ARTSyKfvRnX6trWY97Li0WShtGEeQQ0tCKf6A==
X-Received: by 2002:a05:6a00:1a8d:b0:577:36ba:6a86 with SMTP id e13-20020a056a001a8d00b0057736ba6a86mr143967pfv.1.1671127929840;
        Thu, 15 Dec 2022 10:12:09 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x74-20020a62864d000000b005764c8f8f15sm2026398pfd.73.2022.12.15.10.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 10:12:09 -0800 (PST)
Date:   Thu, 15 Dec 2022 18:12:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, oliver.upton@linux.dev,
        catalin.marinas@arm.com, will@kernel.org, dwmw2@infradead.org,
        paul@xen.org
Subject: Re: [PATCH v3] KVM: MMU: Make the definition of 'INVALID_GPA' common.
Message-ID: <Y5tjdeMk2jJCX8Co@google.com>
References: <20221215095736.1202008-1-yu.c.zhang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215095736.1202008-1-yu.c.zhang@linux.intel.com>
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

Nit, terminating punction (the period) isn't usually included in the shortlog.

On Thu, Dec 15, 2022, Yu Zhang wrote:
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

This should be a separate commit.  Yes, it's trivial and a nop, but there's no
reason to surprise readers/blamers that assumed the shortlog tells the whole
story.  E.g. add and use INVALID_GFN where appropriate in patch 1, then switch
to INVALID_GPA in patch 2.  Then you can also add a "Suggested-by: David ..." for
patch 1.
