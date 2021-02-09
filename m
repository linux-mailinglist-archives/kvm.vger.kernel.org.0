Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 056BA3154AA
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 18:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbhBIRID (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 12:08:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232990AbhBIRH7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Feb 2021 12:07:59 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D37C061574
        for <kvm@vger.kernel.org>; Tue,  9 Feb 2021 09:07:18 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id z9so2019240pjl.5
        for <kvm@vger.kernel.org>; Tue, 09 Feb 2021 09:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NYn0hIXEI1Dd7es1MA3rMU4kotjM8jzL+1QZgKfs5N0=;
        b=d9usAGL29F/qZldLYA3EJ7uPSzbSHy3kB9GW/Sthmsw4HRaH1PXk43WAZIJYkdjOCJ
         rCuCbA8s5G20hMqlG8ZhY/Veu2r/9fnvdTESTvcGQfCjGNzPO2WggZ5qKQGb/2IUcrjj
         O7dABTJ2DQFKLk14lWAG5ucxHLMS/KPMaR90a5d6XUbfjaWk9wsKjnk3pHc4s8glHoOR
         39Xy5zTC5g2DoDeGVFKj3hill/w4A7cRYasw3EPS/0/FyWgTHOGp/V9iKSwy8xb9uth3
         t8EV107UkAZ2JLH1645lcaNRqlqyb7l9n1DQ8F/hpiPRGswdzSJ5Fkyfy9tAAwAQFYkR
         kjaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NYn0hIXEI1Dd7es1MA3rMU4kotjM8jzL+1QZgKfs5N0=;
        b=o+/9l1LAWA+mjFxqGTExgz9p8lEOOyyOQUZKXFsa170kCrb28lBipbRP/yElHF4rPO
         fwc9nqf9eh/2Pmup7f1ng02o0C7adINSGeWSxIDHsoVCSty5hJJOTzUMZ1Vbk2q0/zKu
         +D2TDDL/Sjnmc6/ft4o0/at3B9rYfBw4w2ViOF68ftJjDur3K7A30/TdbFZvDrmMhAxj
         0Do/AhMjX+M3KxnOfr9i/CUAxiicEUrBudlbC2hKRm+Kr073bwx3vZhxs1R0dfWj//QG
         jjQLi0OrBFfNnCeGxMgU3sYLBbQLuFZ+tDU1E/rqJPAk1M+OyqjccF75vXKdNF6OmVFu
         XjKA==
X-Gm-Message-State: AOAM531plAY/NZb1gil4lERl+jRnP1KHXI7fGy1qUcWpUzDjfbYYDDuW
        kwnt9la0/dPFlkbS+kZkayao/A==
X-Google-Smtp-Source: ABdhPJxA47uSfwPY5CZ8jMym5yNQ34qyJTE7CkZ260kgwKGkj1O9fzpD81uk18+T/6xQ5Wc18Sn6Pg==
X-Received: by 2002:a17:90a:70c8:: with SMTP id a8mr4844995pjm.209.1612890437612;
        Tue, 09 Feb 2021 09:07:17 -0800 (PST)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id lw4sm2681793pjb.16.2021.02.09.09.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 09:07:16 -0800 (PST)
Date:   Tue, 9 Feb 2021 17:07:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v4 04/26] x86/sgx: Add SGX_CHILD_PRESENT hardware
 error code
Message-ID: <YCLBQYq2HaA7MFKH@google.com>
References: <cover.1612777752.git.kai.huang@intel.com>
 <3c1edb38e95843eb9bf3fcbbec6cf9bdd9b3e7b1.1612777752.git.kai.huang@intel.com>
 <b9e8a9a0-6a53-6523-4ea8-347c67e7ba86@intel.com>
 <YCK81Zcz++PfGPnw@google.com>
 <af80db88-9097-0947-e05d-9508daee18df@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af80db88-9097-0947-e05d-9508daee18df@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 09, 2021, Dave Hansen wrote:
> On 2/9/21 8:48 AM, Sean Christopherson wrote:
> > On Tue, Feb 09, 2021, Dave Hansen wrote:
> >> On 2/8/21 2:54 AM, Kai Huang wrote:
> >> ...
> >>> Add SGX_CHILD_PRESENT for use by SGX virtualization to assert EREMOVE
> >>> failures are expected, but only due to SGX_CHILD_PRESENT.
> >> This paragraph broke my brain when I read it.  How about:
> >>
> >> 	Add a definition of SGX_CHILD_PRESENT.  It will be used
> >> 	exclusively by the SGX virtualization driver to suppress EREMOVE
> >> 	warnings.
> > Maybe worth clarifying that the driver isn't suppressing warnings willy-nilly?
> > And the error code isn't about suppressing warnings, it's about identifying the
> > expected EREMOVE failure scenario.  The patch that creates the separate helper
> > for doing EREMOVE without the WARN is what provides the suppression mechanism.
> > 
> > Something like this?
> > 
> >   Add a definition of SGX_CHILD_PRESENT.  It will be used exclusively by
> >   the SGX virtualization driver to handle recoverable EREMOVE errors when
> >   saniziting EPC pages after they are reclaimed from a guest.
> 
> Looks great to me.  One nit: to a me, "reclaim" is different than
> "free".  Reclaim is a specific operation where a page is taken from one
> user and reclaimed for other use.  "Free" is the more general case
> (which includes reclaim) when a physical page is no longer being used
> (because the user is done *or* had the page reclaimed) and may be either
> used by someone else or put in a free pool.
> 
> I *think* this is actually a "free" operation, rather than a "reclaim".
>  IIRC, this code gets used at munmap().

It does.  I used reclaim because userspace, which does the freeing from this
code's perspective, never touches the EPC pages.  The SGX_CHILD_PRESENT case is
handling the scenario where userspace has for all intents and purposed reclaimed
the EPC from a guest.  If the guest cleanly tears down its enclaves, EREMOVE
will not fail.

"free" is probably better though, the above is far from obvious and still not
guaranteed to be a true reclaim scenario.  If using "freed", drop the "from a
guest" part.
