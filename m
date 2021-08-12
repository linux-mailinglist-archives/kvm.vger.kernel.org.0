Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE643EA9F3
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 20:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237432AbhHLSKd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 14:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237374AbhHLSKc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 14:10:32 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130F3C0613D9
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 11:10:07 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id a20so8378954plm.0
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 11:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=N2dWSLSbLjgvwtcICDrMscnb8WmsPjpe/if0pvyyNis=;
        b=jbRVdF0HUZEmLetXKhzfsy/ysCJz2gavsf2bevGNRLbJkso7bGeDYJdSUek/IXEc2F
         sUCuz61EFRUtTC0igW+jIWtH/AMmRQ/l6q2TmhFMJ8lxDr/2RijgQVpDy9CCzbj/CiSq
         KQ3GYdga1vgAxcrPj5T07EO5GQnjt4nADuVX5DvrhYWfSztBwVNoo2jomfQr52jRGzV6
         oDsdewfDeXDozQA/MLk9VevKqZAm4yNgDJj1J0ihnkJ+0TWwbzszYIXJ0NkzX1QaHioT
         Vt6HPPGzi7T/bnsEfNcOBmPVQWvHUK7M6xmAQC1hZbFjxb7Ki2peLi89h8JwQgbIj3w3
         qEqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N2dWSLSbLjgvwtcICDrMscnb8WmsPjpe/if0pvyyNis=;
        b=ZMKgnixJRy9mUy6A4ITYM9z7ApNMgmI9Vs/TtLHEdLyowaLsKtOg1IQkUSc9a0Ge06
         4bBEkQvvmbziXNSmmW0tCl1ZxVipWbGsz2mt5cm97WndO9kDQgOAZ2/37S1e81YZkzaS
         ZBLuo47SHYdrwW/wZ1WfkWT8cXTvBq9PvJMeBJpqUoAqNfRolMebhcVqShkJJV84iRp6
         HxA/8JkP9atXZKywEOFWJRKEAsYivb5X9Y93emq/LjIgxGQ2Voru1RvLM/MLuKu5R0q+
         XqNB1E5S9toFYPW6KqGOClYeBiurXHWZfkMrHgBDiLrahBMCkfxID+MrDWqTeKg/Gz4f
         Nopw==
X-Gm-Message-State: AOAM53018wY1QGGaIj0rROA3BczTE89Rv0byPyaEba6AVFIkVguia+YZ
        YLNRbuMx1yigJ1fL5JljBcul9Q==
X-Google-Smtp-Source: ABdhPJwd+RmktKVVt21eiBLulY34PfVu38z11uoaiIc5FIlhrUDNTdquM9efVeRVWbCQz257dwXMDg==
X-Received: by 2002:a65:690c:: with SMTP id s12mr4943068pgq.401.1628791806320;
        Thu, 12 Aug 2021 11:10:06 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i5sm10776583pjk.47.2021.08.12.11.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 11:10:05 -0700 (PDT)
Date:   Thu, 12 Aug 2021 18:09:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Don't skip non-leaf SPTEs when zapping
 all SPTEs
Message-ID: <YRVj94P6it0ow8J+@google.com>
References: <20210812050717.3176478-1-seanjc@google.com>
 <20210812050717.3176478-2-seanjc@google.com>
 <01b22936-49b0-638e-baf8-269ba93facd8@redhat.com>
 <YRVPxCv2RtyXi+XO@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRVPxCv2RtyXi+XO@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 12, 2021, Sean Christopherson wrote:
> On Thu, Aug 12, 2021, Paolo Bonzini wrote:
> > On 12/08/21 07:07, Sean Christopherson wrote:
> > > @@ -739,8 +749,16 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> > >   			  gfn_t start, gfn_t end, bool can_yield, bool flush,
> > >   			  bool shared)
> > >   {
> > > +	bool zap_all = (end == ZAP_ALL_END);
> > >   	struct tdp_iter iter;
> > > +	/*
> > > +	 * Bound the walk at host.MAXPHYADDR, guest accesses beyond that will
> > > +	 * hit a #PF(RSVD) and never get to an EPT Violation/Misconfig / #NPF,
> > > +	 * and so KVM will never install a SPTE for such addresses.
> > > +	 */
> > > +	end = min(end, 1ULL << (shadow_phys_bits - PAGE_SHIFT));
> > 
> > Then zap_all need not have any magic value.  You can use 0/-1ull, it's
> > readable enough.  ZAP_ALL_END is also unnecessary here if you do:
> > 
> > 	gfn_t max_gfn_host = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
> > 	bool zap_all = (start == 0 && end >= max_gfn_host);
> 
> Aha!  Nice.  I was both too clever and yet not clever enough.

And as a bonus, this also works for kvm_post_set_cr0(), which calls the common
kvm_zap_gfn_range() with 0 - ALL_ONES.
