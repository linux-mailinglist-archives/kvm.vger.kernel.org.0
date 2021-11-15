Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142A9451595
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 21:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352180AbhKOUn3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 15:43:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345175AbhKOT1V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 14:27:21 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7507EC09E003
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 10:44:53 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id c4so15843495pfj.2
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 10:44:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YnA5RxswdR0pXIdDfw42jEIDMfa1Anknf8jHYLDLebQ=;
        b=b2wJRkAtOs8VLbM0lZNMe/RxwW3htbsJhf+JSJaqKtTxUt1keDFKRzlcUNWyPRBoxr
         LBU9Tn21V6eNtb8W2Ualydb/xatXcwyrVl137vORscIWpZaHyqhtaJ4PL//nGRBuvlVf
         5Lk0OB2dy54Hh7saCw2v3Mzu3qwwaI2j4DGdC76QW8zGmrexY7HRIYzc4TLXnHc/XzER
         piGaJLzdwxwiNPpaBVCWww3uXt8XWY3x2Qzr69DlQN7DsLjKBaIJfEtq5ll5aehSHh79
         9DNaDrov5aBJp9lHbu2laW/mwNkbPco4mg1trxgMYI0j2IaFvXiSMYscDWB6oXCmZKp4
         AdyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YnA5RxswdR0pXIdDfw42jEIDMfa1Anknf8jHYLDLebQ=;
        b=b88Y7v+c+udXCgi/q3Pb144p45pcUtgjmyznlWKSZOhKtlkjL5RpMLFT5uxmXSLyW/
         9lffSAKZMExSjI6sKbyaFMWNjxZn3rg01xbzba53BfKatuzCGSu1O/+MPk+xO5gg53kJ
         ytdrwHYIP03ICA1b5GPpuS5RTlGR9+Z/XVywKNGdApfQ+ViuuRN8fmnz4f9yixBLX/c9
         /2h6bLxzvUy0c1ax0OVYlCBzwh/BZWB5YE7Ed/H4I8ewXFn9pMeN5Wyvs6sUQYTuuGhO
         ziDDLl8a5bu/GsbzkbijU6O7boDgUSpvlh6RX1bb3t4H4ccy89Ne3+SZoKqqXrjKJF+e
         dxFw==
X-Gm-Message-State: AOAM531DJPJQg5jagkBbgjAvplG2Lwga1+V6Yp6sz4gfG4SuLbIRY5qs
        koaGryoBx0jHmyYzc8461z0w5g==
X-Google-Smtp-Source: ABdhPJwv65aVu6kpZNGGw0N7gTXRvONlRDhXoyAUv+VgR6kFzqLSM/NP5wts15+VyzsP2RdH5A+iaA==
X-Received: by 2002:a63:33cc:: with SMTP id z195mr669715pgz.339.1637001892769;
        Mon, 15 Nov 2021 10:44:52 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id on6sm72382pjb.47.2021.11.15.10.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 10:44:52 -0800 (PST)
Date:   Mon, 15 Nov 2021 18:44:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Gonda <pgonda@google.com>, x86@kernel.org,
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
Message-ID: <YZKqoPAoMCqPZymh@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com>
 <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com>
 <YY7I6sgqIPubTrtA@zn.tnic>
 <YY7Qp8c/gTD1rT86@google.com>
 <f2edf71e-f3b5-f8e3-a75e-e0f811fe6a14@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2edf71e-f3b5-f8e3-a75e-e0f811fe6a14@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021, Brijesh Singh wrote:
> 
> On 11/12/21 2:37 PM, Sean Christopherson wrote:
> > This is the direction KVM TDX support is headed, though it's obviously still a WIP.
> > 
> 
> Just curious, in this approach, how do you propose handling the host
> kexec/kdump? If a kexec/kdump occurs while the VM is still active, the new
> kernel will encounter the #PF (RMP violation) because some pages are still
> marked 'private' in the RMP table.

There are two basic options: a) eagerly purge the RMP or b) lazily fixup the RMP
on #PF.  Either approach can be made to work.  I'm not opposed to fixing up the RMP
on #PF in the kexec/kdump case, I'm opposed to blindly updating the RMP on _all_
RMP #PFs, i.e. the kernel should modify the RMP if and only if it knows that doing
so is correct.  E.g. a naive lazy-fixup solution would be to track which pages have
been sanitized and adjust the RMP on #PF to a page that hasn't yet been sanitized.
