Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7898A339383
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 17:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbhCLQfl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 11:35:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbhCLQfd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 11:35:33 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2066EC061761
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 08:35:32 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id d23so8955298plq.2
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 08:35:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=M1oLZJqjtjwriizT550dV/7keuNI0itwOyJW5hn/1TE=;
        b=YTqBDZIhkQErgpRLDruA3lP9/gm2v8Qn0iE5L6hMzg8tMD/nd48sg2lBf23FoveqNe
         HDQi3Hl1lMVHUKqZXwGWRgIUPkHc0J6+qa0ltdv56aZHsDAIJEEewqMbm0O+H14t2gtv
         1LJZofXL9gnCePFSuQJHttqNqT52+DpFt+5s5zgBAP87R2mgUr6mt9BaV+HA3rXiEPRC
         oCRcam9d2oXPyYOOelSFqpjvZLYwHl8qLUgntLR1uQRS6iU4X3jY168c49pkEsIInr5e
         T3gf/O+y7orlUEGOOZxfCn961VFqEAe9PzBwGQUg0JwzbbyYpzqpFqMZVvDP0/NKDHMl
         T7hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M1oLZJqjtjwriizT550dV/7keuNI0itwOyJW5hn/1TE=;
        b=Uyc7Bv+nyzQi8RAq2aOR8SFcgHhU/MnaMa52f/j49NbCswCX7Oh19PcBNgQBhusTeL
         51+PtJPB+flyAE2ESKsz/+2y6CVczmquKN/IH7JK26tuYDOX1mG8y1WXiNn+fZIubWDk
         bSnGbMW/VZgHRAKITV/rF2NUl5yBH3U3j3/J1kVizPq7gUU852irbYVN9zMdzFQlPwQB
         lMudC3lxZS59E0HHGGeog1EKQRJe3EPSvgnVL/sd02/jluqmyBJQGwk2g55kzWTL3zm+
         08vpm2GHPZ8d8na3f/em92Yh6uCjBN5yxbw727EpcMBDVbkVxPNLA4BDawjcS6nYR0dp
         CO6A==
X-Gm-Message-State: AOAM5322xYHxxzg5UkUDWosYaLkMC2gIGhRVKvfCDCsuvPFVSaNwyd6v
        rYILH6/YtolMsOzYtLvGCeCuEM4d89EH0w==
X-Google-Smtp-Source: ABdhPJxheV+DKT6kR8vMi7FN/wSbPyRX3UcrIbZenKRHnBu/7oIdrg89nNYJ/BWwNrTukQUvMyOYFg==
X-Received: by 2002:a17:90a:516:: with SMTP id h22mr14325622pjh.222.1615566931518;
        Fri, 12 Mar 2021 08:35:31 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1a6:2eeb:4e45:756])
        by smtp.gmail.com with ESMTPSA id h23sm5971681pfn.118.2021.03.12.08.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 08:35:30 -0800 (PST)
Date:   Fri, 12 Mar 2021 08:35:24 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 4/4] KVM: x86/mmu: Factor out tdp_iter_return_to_root
Message-ID: <YEuYTF3mzzMCkz5c@google.com>
References: <20210311231658.1243953-1-bgardon@google.com>
 <20210311231658.1243953-5-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311231658.1243953-5-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 11, 2021, Ben Gardon wrote:
> In tdp_mmu_iter_cond_resched there is a call to tdp_iter_start which
> causes the iterator to continue its walk over the paging structure from
> the root. This is needed after a yield as paging structure could have
> been freed in the interim.
> 
> The tdp_iter_start call is not very clear and something of a hack. It
> requires exposing tdp_iter fields not used elsewhere in tdp_mmu.c and
> the effect is not obvious from the function name. Factor a more aptly
> named function out of tdp_iter_start and call it from
> tdp_mmu_iter_cond_resched and tdp_iter_start.

What about calling it tdp_iter_restart()?  Or tdp_iter_resume()?  Or something
like tdp_iter_restart_at_next() if we want it to give a hint that the next_last
thing is where it restarts.

I think I like tdp_iter_restart() the best.  It'd be easy enough to add a
function comment clarifying from where it restarts, and IMO the resulting code
in tdp_mmu_iter_cond_resched() is the most intutive, e.g. it makes it very clear
that the walk is being restarted in some capacity after yielding.
