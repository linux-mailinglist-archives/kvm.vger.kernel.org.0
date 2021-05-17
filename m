Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03664383BD5
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 20:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236729AbhEQSEL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 14:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236372AbhEQSEL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 14:04:11 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA963C061756
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 11:02:54 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id b9-20020a17090a9909b029015cf9effaeaso48016pjp.5
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 11:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=US+ZHUqvwSWcl6nmtFYdA4IjAezUz41XYjRgC8na4fg=;
        b=NMqzEIt1ko7mRiqXkcP0iSbOZLVLBMBCtABhDbLOPKI1LeZlnpKWLTz0mAzYRGkEU5
         pO6sy7F101gqXnb4NPLh8zwGUFPVs9Cz/g5vDPLOCIOtffSoPJzk++Fs7AJ0cygw1w+E
         jNr2Z46nW636r+hmNsgfKgqEfrRdQUhSkduNzguyJ0hZo7DqhdwcZ0dxbPG4Xim06Lrk
         S3Qkp0wJZXzbyXxCorzv/2gwAu9W1X2YZFyghxIQjupSmDnBdB0bzXc+CxLJH/+m9IzR
         +HFfc5Gh5K5VJMklRaMK7KEknd9mMWtKrSoGNgvgi+C5srsN32At5qOIzSCBWbcTN0kk
         q06A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=US+ZHUqvwSWcl6nmtFYdA4IjAezUz41XYjRgC8na4fg=;
        b=FfYxIhfKAhS05J5R+UBSydU+zvr3+1EXjib4OP7V6mAL2sOu2WbVh86IzVFBuzE30C
         9BCKbwckGYLBbrqk4N/xn2zlCqmgwLzSxOx6YvP+OrgazNNZZmz1Ccb4q/7k+lMFlrbe
         mdi7UVTiyhu5KoOif+h0qJ1j54K1gfSMYBppOruwRbqtp6hG++O8d0G9++2SXATORH13
         pVFb2qXMyL7mhzSW+zDhAAUXjj3J5xE1Ujrww4ZkOdfwTUgGunnWDhBF5mLYEkObYW5n
         L8atpdoBzAhYKq0j+jotwqa2VMKpZljuQPobsL/rtl4KoOjeaxHT9nCdvUQxxJECy9/L
         1pCQ==
X-Gm-Message-State: AOAM532XBoMqmg7wnZZV9iVpcXAOl/+3MYMlN8SwYFsMGaDRyabFPBvK
        CopQjVniZqIcyiuhjnJdk8tuVA==
X-Google-Smtp-Source: ABdhPJx3EHDta9pwU4Er2wdXnJ5xBb13PYuHD1cgsrQ5auSd13bmZ2coJ/6RtaVhfwnmIDWh+Ngh1Q==
X-Received: by 2002:a17:90a:d903:: with SMTP id c3mr395701pjv.34.1621274574023;
        Mon, 17 May 2021 11:02:54 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id w127sm10354642pfw.4.2021.05.17.11.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 11:02:53 -0700 (PDT)
Date:   Mon, 17 May 2021 18:02:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jon Kohler <jon@nutanix.com>, Babu Moger <babu.moger@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Petteri Aimonen <jpa@git.mail.kapsi.fi>,
        Kan Liang <kan.liang@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Benjamin Thiel <b.thiel@posteo.de>,
        Fan Yang <Fan_Yang@sjtu.edu.cn>,
        Juergen Gross <jgross@suse.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: add hint to skip hidden rdpkru under
 kvm_load_host_xsave_state
Message-ID: <YKKvychM0nYV8pOJ@google.com>
References: <20210507164456.1033-1-jon@nutanix.com>
 <CALCETrW0_vwpbVVpc+85MvoGqg3qJA+FV=9tmUiZz6an7dQrGg@mail.gmail.com>
 <5e01d18b-123c-b91f-c7b4-7ec583dd1ec6@redhat.com>
 <YKKqQZH7bX+7PDjX@google.com>
 <d568276b-5eda-80db-146e-273066aa6793@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d568276b-5eda-80db-146e-273066aa6793@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 17, 2021, Dave Hansen wrote:
> On 5/17/21 10:39 AM, Sean Christopherson wrote:
> > On Mon, May 17, 2021, Paolo Bonzini wrote:
> >> On 14/05/21 07:11, Andy Lutomirski wrote:
> >>> I don't even want to think about what happens if a perf NMI hits and
> >>> accesses host user memory while the guest PKRU is live (on VMX -- I
> >>> think this can't happen on SVM).
> >> This is indeed a problem, which indeed cannot happen on SVM but is there on
> >> VMX.  Note that the function above is not handling all of the xstate, it's
> >> handling the *XSAVE state*, that is XCR0, XSS and PKRU.  Thus the window is
> >> small, but it's there.
> >>
> >> Is it solvable at all, without having PKRU fields in the VMCS (and without
> >> masking NMIs in the LAPIC which would be too expensive)?  Dave, Sean, what
> >> do you think?
> > The least awful solution would be to have the NMI handler restore the host's
> > PKRU.  The NMI handler would need to save/restore the register, a la CR2, but the
> > whole thing could be optimized to run if and only if the NMI lands in the window
> > where the guest's PKRU is loaded.
> 
> What were you thinking about?  Something like:
> 
> 	*this_cpu_ptr(&need_nmi_wpkru) = 1
> 	// Enter Guest
> 	__write_pkru(vcpu->arch.pkru);
> 	*this_cpu_ptr(&need_nmi_wpkru) = 0
> 
> And then in the NMI handler:
> 
> 	u32 pkru;
> 
> 	if (*this_cpu_ptr(&need_nmi_wpkru)) {
> 		pkru = rdpku();
> 		__write_pkru(vcpu->arch.pkru);

This isn't correct, vcpu->arch.pkru holds the guest value, the NMI handler needs
to load the host value.  I was thinking KVM would stash away the current host
value, and the NMI handler would check the saved value against rdpkru().

> 	}
> 	...
> 	copy_*_user_nmi(... whatever ...);
> 	...
> 	if (*this_cpu_ptr(&need_nmi_wpkru))
> 		__write_pkru(pkru);
> 
> ?
> 
> I was thinking we could just blow away PKRU without saving/restoring it
> in the NMI handler, but that might clobber PKRU in the window between
> need_nmi_wpkru=1 and entering the guest.

Yep.  It would also blow away the guest's value if the guest did WRPKU while it
was running since KVM would never get a chance to read/save the guest's new value.
 
> But, the save/restore seems doable especially since we can do it in C
> and don't have to mess with the NMI stack or anything.
