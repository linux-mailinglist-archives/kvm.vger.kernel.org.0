Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3954244ED86
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 20:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235326AbhKLTvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 14:51:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232474AbhKLTvM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 14:51:12 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1F5C061766
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 11:48:21 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id n8so9265373plf.4
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 11:48:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=zr5FgjktMhow+NOFcAQVViEc+ANJI2M0r6r48QGgVI4=;
        b=ju07XZYoPBdZerGoypJVNunlreP0szj3eP3wBUKtjj3PgeSmreG3NLWofDNDwV6K29
         FsSfNhHPjnLQwrYJbcInKVbPImCmeaSbNg1PrGgCt/txR88PNm1nU0RTbPjM3JdC3wf3
         uZ85zCueTnCAB+k9Pw+WeIIKYWLJn2vZxUaWaMXx1CvRCQcsZjqW9kwUlCANJLD9YPbf
         TOq6qB/AcWNguhQgpAU6PKmtZwvGrzVt2V5i98njwxtUv/Qc7NCreMhve1otMefuO7y8
         W2WfbjoI5XZ/n45uufMVitUf7PZW+0Okf36r5AIHuD1vpBBTL6m1a0mtY/OWfjjaOpfP
         oGnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=zr5FgjktMhow+NOFcAQVViEc+ANJI2M0r6r48QGgVI4=;
        b=ArTUv2urKhddqLXOu+DCzA5XCU/BZWeXr2fsU4Fv8tjH8gSffeGi+uwHpGILUprF1U
         9JSvY3EsN7e/aK6N1SMIRYdDruWv+t2ocpNsesZ1OdiWDxSyBtRAzB6IxPCfR039kJzh
         9Z5wQ54Nux9rmh3rNta7RsY4ZLjUkelz1uT033PGdD8+QqUDLAGrWUh1ECwmnPbuDvOf
         zXQy8HT/TJ50bX4cxIo7dRkfSv21dT0Te8pLhHzXwt2iC7HOtkNv+Wbhg2CnkermwB+s
         xcu9bnyaJbRaRXrOrP+EWdFXqwDsu0lah9TNWCCpG290mr2/2A0Cnak1g0liNmyD8e5/
         ML5A==
X-Gm-Message-State: AOAM533kTeiR33nDhzV1h7osF0wqnrg+qxlFpdH1BFhWaafPB4WwjXFU
        QH6ZIi9UYkvZ1u3tMHL+VbPVKw==
X-Google-Smtp-Source: ABdhPJy4Qx6b+7+ByFpOdO4v0MJjsrHOwn6ocVpZeRM8XbBpXpi+sLPnEs6oezsNOzfZQuqOUI4/kw==
X-Received: by 2002:a17:90b:1b07:: with SMTP id nu7mr21351128pjb.140.1636746501253;
        Fri, 12 Nov 2021 11:48:21 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y6sm7644847pfi.154.2021.11.12.11.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 11:48:20 -0800 (PST)
Date:   Fri, 12 Nov 2021 19:48:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
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
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Message-ID: <YY7FAW5ti7YMeejj@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com>
 <YY6z5/0uGJmlMuM6@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YY6z5/0uGJmlMuM6@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 12, 2021, Borislav Petkov wrote:
> On Fri, Nov 12, 2021 at 09:59:46AM -0800, Dave Hansen wrote:
> > Or, is there some mechanism that prevent guest-private memory from being
> > accessed in random host kernel code?

Or random host userspace code...

> So I'm currently under the impression that random host->guest accesses
> should not happen if not previously agreed upon by both.

Key word "should".

> Because, as explained on IRC, if host touches a private guest page,
> whatever the host does to that page, the next time the guest runs, it'll
> get a #VC where it will see that that page doesn't belong to it anymore
> and then, out of paranoia, it will simply terminate to protect itself.
> 
> So cloud providers should have an interest to prevent such random stray
> accesses if they wanna have guests. :)

Yes, but IMO inducing a fault in the guest because of _host_ bug is wrong.

On Fri, Nov 12, 2021, Peter Gonda wrote:
> Here is an alternative to the current approach: On RMP violation (host
> or userspace) the page fault handler converts the page from private to
> shared to allow the write to continue. This pulls from s390’s error
> handling which does exactly this. See ‘arch_make_page_accessible()’.

Ah, after further reading, s390 does _not_ do implicit private=>shared conversions.

s390's arch_make_page_accessible() is somewhat similar, but it is not a direct
comparison.  IIUC, it exports and integrity protects the data and thus preserves
the guest's data in an encrypted form, e.g. so that it can be swapped to disk.
And if the host corrupts the data, attempting to convert it back to secure on a
subsequent guest access will fail.

The host kernel's handling of the "convert to secure" failures doesn't appear to
be all that robust, e.g. it looks like there are multiple paths where the error
is dropped on the floor and the guest is resumed , but IMO soft hanging the guest 
is still better than inducing a fault in the guest, and far better than potentially
coercing the guest into reading corrupted memory ("spurious" PVALIDATE).  And s390's
behavior is fixable since it's purely a host error handling problem.

To truly make a page shared, s390 requires the guest to call into the ultravisor
to make a page shared.  And on the host side, the host can pin a page as shared
to prevent the guest from unsharing it while the host is accessing it as a shared
page.

So, inducing #VC is similar in the sense that a malicious s390 can also DoS itself,
but is quite different in that (AFAICT) s390 does not create an attack surface where
a malicious or buggy host userspace can induce faults in the guest, or worst case in
SNP, exploit a buggy guest into accepting and accessing corrupted data.

It's also different in that s390 doesn't implicitly convert between shared and
private.  Functionally, it doesn't really change the end result because a buggy
host that writes guest private memory will DoS the guest (by inducing a #VC or
corrupting exported data), but at least for s390 there's a sane, legitimate use
case for accessing guest private memory (swap and maybe migration?), whereas for
SNP, IMO implicitly converting to shared on a host access is straight up wrong.

> Additionally it adds less complexity to the SNP kernel patches, and
> requires no new ABI.

I disagree, this would require "new" ABI in the sense that it commits KVM to
supporting SNP without requiring userspace to initiate any and all conversions
between shared and private.  Which in my mind is the big elephant in the room:
do we want to require new KVM (and kernel?) ABI to allow/force userspace to
explicitly declare guest private memory for TDX _and_ SNP, or just TDX?
