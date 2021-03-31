Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2818350A32
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 00:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbhCaW1q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 18:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbhCaW1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 18:27:36 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC1AC06175F
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 15:27:35 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id a12so34972pfc.7
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 15:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WpLA/8+oNDyuMS3mRjh7CIaKNZs3vVlk+cUQzEEw+V0=;
        b=rSblG82rx/HZ2AiRUDoBIpQUlWfYIRlhssFYQBQP3Rf4waNr1zlMADu9Yc7DIMqk45
         eZzdBd+QD0SBjyUPJbkAakPUoVu+xKWadHTrDjKulfRheuEXsn1PZuO08QRDCGGbDoNB
         8d5hJghzXoYOC1CCSCgUC8g/C2wxb0v0yaZWai+R8LVzfzO+T8X8s118gAFgNRKJMWA3
         zEMzpqAX6HQ4LYpAeHc6KVW3UVBdoYL3oUYwruEPAw4UWDpBzFvKPHCkBX95emRe1an8
         5/DIHIXxdxhtbL+KR0mj0NaofnhgrrpUVFk2VsFdEy4p9x1OVkV7cR9EA3C2xXNSXIMY
         nKKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WpLA/8+oNDyuMS3mRjh7CIaKNZs3vVlk+cUQzEEw+V0=;
        b=aTOaHpDe6WgWNiV9ZTL0dOrQggu0VVnkMRhykf5+oFCqPKzWDGX/gYpuW8kEx3kc2W
         ok5uHaRrTEnSeSZz3F8CuGCRqMt5NeybdnrTMKGqP2vZGm/qG7rj9Ve17EL/uvOspgvW
         fVbUBjanQm5hzmcxUTDzfEWGm3ee8tcdN3XuMZCF6FPrHxEyOjpUknuvq0hOSxBm7zB5
         pCwtq0wxGdnqWgPvC1iiKy0m+LXARoyocgEV39qYZ5kbYyyb5GCT2cxCBeLVutAQ31QZ
         WbRXsPJGK2Xk+bpGWIWqcKxeEwggEdn86HWN7BpSqicPnkxwoUBjoy4dhcSvZbrNVTgf
         Wd4g==
X-Gm-Message-State: AOAM532SOL4tpBU4dDmdZjGHGwlkH/B+TWcuAw2UnX4DDjpsGglJwQxN
        B5B5eE0/dFWXcefhT3/6YHb76Q==
X-Google-Smtp-Source: ABdhPJz/NNSLb+31u+PTD2jSbK2k/r80/7e6SA3cFJYq2N69TCi83el/dCjQj51hSg3AXxUO0r5Dqw==
X-Received: by 2002:a63:d43:: with SMTP id 3mr5029669pgn.5.1617229655137;
        Wed, 31 Mar 2021 15:27:35 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id ds3sm3120454pjb.23.2021.03.31.15.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 15:27:34 -0700 (PDT)
Date:   Wed, 31 Mar 2021 22:27:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH 12/13] KVM: x86/mmu: Fast invalidation for TDP MMU
Message-ID: <YGT3UmSKVQFaY1Fd@google.com>
References: <20210331210841.3996155-1-bgardon@google.com>
 <20210331210841.3996155-13-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210331210841.3996155-13-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 31, 2021, Ben Gardon wrote:
> Provide a real mechanism for fast invalidation by marking roots as
> invalid so that their reference count will quickly fall to zero
> and they will be torn down.
> 
> One negative side affect of this approach is that a vCPU thread will
> likely drop the last reference to a root and be saddled with the work of
> tearing down an entire paging structure. This issue will be resolved in
> a later commit.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---

...

> +/*
> + * This function depends on running in the same MMU lock cirical section as
> + * kvm_reload_remote_mmus. Since this is in the same critical section, no new
> + * roots will be created between this function and the MMU reload signals
> + * being sent.

Eww.  That goes beyond just adding a lockdep assertion here.  I know you want to
isolate the TDP MMU as much as possible, but this really feels like it should be
open coded in kvm_mmu_zap_all_fast().  And assuming this lands after as_id is
added to for_each_tdp_mmu_root(), it's probably easier to open code anyways, e.g.
use list_for_each_entry() directly instead of bouncing through an iterator.

> + */
> +void kvm_tdp_mmu_invalidate_roots(struct kvm *kvm)
> +{
> +	struct kvm_mmu_page *root;
> +
> +	for_each_tdp_mmu_root(kvm, root)
> +		root->role.invalid = true;
> +}
