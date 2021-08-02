Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8283DDFD1
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 21:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhHBTFc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 15:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbhHBTFb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 15:05:31 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4982C06175F
        for <kvm@vger.kernel.org>; Mon,  2 Aug 2021 12:05:20 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so1384700pjb.2
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 12:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wgfgMVxCPBQ0GIYZVwRvz6smg5/pTXTIka/+zBBpuZk=;
        b=RG3wQlQziA+GjMEr81FaBBAaGIIW8dPtnvEJ9EWW+U3G3ykNoUxbSQfGCTghxJ7qx5
         QYm8bwpA/Hr2tZ7Noc+uAMCeCktweksMH1VyqPEMrrskx66UCoNCX/LJDzyN1uXixhX8
         c65KywHQsOQFSgrSOA/fIBLcSLdPpPgGc1ZFsOqdBfcKSoSj3+BuL9KiE1r5KEF/+eSa
         bjVzu8Bu8F66mmRAJaVEj9OpIvLtSAQgpYyvZBjJj46HxsokfUSEUYyxn6H6ALCyeisN
         ccfxLzNePC8I9IgQsjx35VDbDogXXHEPlkZ3uF6DZquLH24KjTflmTI91hbQ/WmY0URI
         aK2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wgfgMVxCPBQ0GIYZVwRvz6smg5/pTXTIka/+zBBpuZk=;
        b=Vh5Yb4NuVOZMIzSiTGGhZtlb+w1Zv3aZteJgC+QItuvphJrvzdDMLISRv7pmPPVm6D
         gQkQYPb/w1DVWRY94gsL85RDxG2jTfhA9DOS95FSsQhwTtdzbjZWLuFW2yArsK9VNCi+
         JHnszoPmvJV+VgJ/lxvt5fh9HQ1UlWa1Rw5BOgaDyD2jvG9qAvLgrAksyTBqzRBZZgvG
         F9ylGvcCxUu03bYzUfU2P/1jgE+ksibV2uBZtWvHgTWkkmOnc+EMS8ukgg3/DHQ2NybX
         rgBQwbO6gK/7BbubDF34VLNOb8Vpv1eSGmUWHNS95GUsVnEbO76jazgZG4U8M+FPUn5T
         15cw==
X-Gm-Message-State: AOAM530XRblooe7OWA6JDlfLE+LE06HUKZL0i0swE4TCGbPuU7BeC9dx
        10REfJ8tm0GtBsrNRYjWPGiK4g==
X-Google-Smtp-Source: ABdhPJy4lW5VvswSn/50aGr5nBPbX5BezfjcGcMRQmajbM/t5mzCcanvKADCE20jv86zq7xao538fA==
X-Received: by 2002:a17:902:dad0:b029:12c:83ca:fdd4 with SMTP id q16-20020a170902dad0b029012c83cafdd4mr15265788plx.77.1627931120160;
        Mon, 02 Aug 2021 12:05:20 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x19sm9439006pgk.37.2021.08.02.12.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 12:05:19 -0700 (PDT)
Date:   Mon, 2 Aug 2021 19:05:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: Don't take mmu_lock for range invalidation
 unless necessary
Message-ID: <YQhB690YQ04nAS32@google.com>
References: <20210727171808.1645060-1-pbonzini@redhat.com>
 <20210727171808.1645060-3-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727171808.1645060-3-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 27, 2021, Paolo Bonzini wrote:
> @@ -605,8 +597,13 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
>  
>  	/*
>  	 * .change_pte() must be surrounded by .invalidate_range_{start,end}(),
> +	 * If mmu_notifier_count is zero, then start() didn't find a relevant
> +	 * memslot and wasn't forced down the slow path; rechecking here is
> +	 * unnecessary.

Critiquing my own comment...

Maybe elaborate on what's (not) being rechecked?  And also clarify that rechecking
the memslots on a false positive (due to a second invalidation) is not problematic?

	 * If mmu_notifier_count is zero, then no in-progress invalidations,
	 * including this one, found a relevant memslot at start(); rechecking
	 * memslots here is unnecessary.  Note, a false positive (count elevated
	 * by a different invalidation) is sub-optimal but functionally ok.
	 */

Thanks for doing the heavy lifting!

>  	 */
>  	WARN_ON_ONCE(!READ_ONCE(kvm->mn_active_invalidate_count));
> +	if (!kvm->mmu_notifier_count)
> +		return;
>  
>  	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_set_spte_gfn);
>  }
