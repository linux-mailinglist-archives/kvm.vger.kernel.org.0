Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA14450D1D
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 18:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238217AbhKORtk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 12:49:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238824AbhKORrl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 12:47:41 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392A5C079794
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 09:25:49 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id r5so9254506pgi.6
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 09:25:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zTcl/CA5Ev6UODKtmHkLeIkZrDlcXRolMIEi+XRmo/4=;
        b=Ecl0cR1xR7V7WnPSUzOs7tEPw8P6cyZ335nnh7QMRz62gsdjjFoubmdkPQZg9HWsC6
         V/p1WnKw07yMKVmnJmySSdDW4RE2A8/YHpHDZkgGWtFrFcjQxO8t5+Aqi/pjzl1GgOkC
         hrDk+k2oXpUzuuJwg1XiLvM/suOqVOj/YAIJU+NLl0gyY5fArOTbfTJhWw1CjosHBRdR
         FpLALiKVdw8LRNvx5HjfNzYxjm9es2xaaoMx8A7aRY5FWbzRyNhpQ2IH7aBoPzPLBnoY
         CfbfwKnxMlD3rKWI+D0BUnzoJghtxM0gtp8RpaEsc8Hno8aJzxPRsck0OCTmhfDuEdJV
         gMJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zTcl/CA5Ev6UODKtmHkLeIkZrDlcXRolMIEi+XRmo/4=;
        b=XWEohQCIxHB3NEJZeIwzSFly5E/3rQwrjDtjZh+LgVr4w5GluIRDrUAIwYu0QB/ROP
         2ODNvwlU3qbqGR/tvGSN2Rm80htcyf7rPhnDaJgaU3jvbUWuNgQB540wIWWcUr9vkE5y
         0BO16tgxcLmvWOuQpLx1OH5zZYHjiv13eX8WPucPJ+VRuzalFNvWG5FX0lnM+/RzStvP
         34im3JRdU49YvD0uI7i05WgxImC6hzmb16eLmW1rLNwhDWFDdb784dTlae0tQZ0aEZj6
         4EpbGrbbqIgQfb3P7tf2aO+zq4IGtj+DChWbBTKRMMP9WzcwGgs0OhBb8QhTADMI057u
         x/2A==
X-Gm-Message-State: AOAM530JOhV1Muqp1zItoCffnOUk2rNvlMVddcvSW6uOLZtJ9Fd2lyCs
        NWZ1PKopHyoKJz4Z0JbC8XyXEg==
X-Google-Smtp-Source: ABdhPJxWeWGi2U9i9fC6X4OCa+G3zMGesVsvaMbNPJ+jfguhVVFtD+RJxF8y7Z6fLKMDMarAgB7c6Q==
X-Received: by 2002:aa7:888d:0:b0:47c:128b:ee57 with SMTP id z13-20020aa7888d000000b0047c128bee57mr34630009pfe.81.1636997148447;
        Mon, 15 Nov 2021 09:25:48 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j6sm12238880pgf.60.2021.11.15.09.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 09:25:47 -0800 (PST)
Date:   Mon, 15 Nov 2021 17:25:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Joerg Roedel <jroedel@suse.de>
Cc:     Marc Orr <marcorr@google.com>, Peter Gonda <pgonda@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Michael Roth <Michael.Roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Message-ID: <YZKYF5DSjUmWJDEI@google.com>
References: <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com>
 <YY7I6sgqIPubTrtA@zn.tnic>
 <YY7Qp8c/gTD1rT86@google.com>
 <YY7USItsMPNbuSSG@zn.tnic>
 <CAMkAt6o909yYq3NfRboF3U3V8k-2XGb9p_WcQuvSjOKokmMzMA@mail.gmail.com>
 <YY8AJnMo9nh3tyPB@google.com>
 <CAA03e5G=fY7_qESCuoHW3_VdVbDWekqQxmvLPzWNepBqJjyCXg@mail.gmail.com>
 <YZAFTBXtC/yS7xtq@google.com>
 <YZKMmciB+wJyrmFI@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZKMmciB+wJyrmFI@suse.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021, Joerg Roedel wrote:
> On Sat, Nov 13, 2021 at 06:34:52PM +0000, Sean Christopherson wrote:
> > I'm not treating it nonchalantly, merely acknowledging that (a) some flavors of kernel
> > bugs (or hardware issues!) are inherently fatal to the system, and (b) crashing the
> > host may be preferable to continuing on in certain cases, e.g. if continuing on has a
> > high probablity of corrupting guest data.
> 
> The problem here is that for SNP host-side RMP faults it will often not
> be clear at fault-time if it was caused by wrong guest or host behavior. 
> 
> I agree with Marc that crashing the host is not the right thing to do in
> this situation. Instead debug data should be collected to do further
> post-mortem analysis.

Again, I am not saying that any RMP #PF violation is an immediate, "crash the
host".  It should be handled exactly like any other #PF due to permission violation.
The only wrinkle added by the RMP is that the #PF can be due to permissions on the
GPA itself, but even that is not unique, e.g. see the proposed KVM XO support that
will hopefully still land someday.

If the guest violates the current permissions, it (indirectly) gets a #VC.  If host
userspace violates permissions, it gets SIGSEGV.  If the host kernel violates
permissions, then it reacts to the #PF in whatever way it can.  What I am saying is
that in some cases, there is _zero_ chance of recovery in the host and so crashing
the entire system is inevitable.   E.g. if the host kernel hits an RMP #PF when
vectoring a #GP because the IDT lookup somehow triggers an RMP violation, then the
host is going into triple fault shutdown.

[*] https://lore.kernel.org/linux-mm/20191003212400.31130-1-rick.p.edgecombe@intel.com/
