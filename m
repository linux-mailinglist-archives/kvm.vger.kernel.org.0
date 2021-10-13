Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D784742CCBB
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 23:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhJMVZN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 17:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbhJMVZN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 17:25:13 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2F8C061746
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 14:23:09 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id lk8-20020a17090b33c800b001a0a284fcc2so5413587pjb.2
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 14:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jJvcs17LLVFEQhgYWiSuKw3a7LUuxCQxSGq7VTL24ss=;
        b=YgR3hhIUzzM3MmB/VqCp5RF1lyCBvwRrbqY6X36NmMS5JkVl3bwQO5XZTIrKqSqpQL
         nU/XHW3zmal1getVVHqEBwvdmoxMZH6gtYctnZhb9aC6o5In2TIYlj7SOlQW93VIMfcc
         pC1BcIUjIz6qn/eZmMybLYpJHP7nZKwSpRCYoCslShBF/b8DQi//NBPTQ/g4m4dgEIOp
         75uc6tqFBgYWKq0pKycSl9qygSI3Ap+f3B3VN2lvZPN17V/of6FzkX6KFwKoIMSmU/f0
         ATq7U4ALPcWbykyiTNdSSkYBi4cb8uKCPL2efB3rojmfYwG5o6gGE0OmSXmzBWvL15Mb
         ZODg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jJvcs17LLVFEQhgYWiSuKw3a7LUuxCQxSGq7VTL24ss=;
        b=sFUHHpq6UIZAG7Cdsd4RUzHopJjU1GAwcczmmicW39XtHbUO3alFl5FPXpPfYl3XEX
         kCblITLVGmI8qdPDk/yThGE5Bkpjnlo0ViKTW1u4ZlruYaOSll2bPkw9AUQxpFH5Rh2H
         gNWW9bjqFQLtsDZOfNYHY+SW63U0KDpImvlywUxexcELsxebnWde83TjbrQwE52lgdvx
         PpsY+dg9IrHZ45vnwSVSa9uGyr02B3U/GkMiwMt0m1Y+TNRttDEH0SVkb5YIeCqikayC
         1PeLErTThRFobusqML7f56aPCWR0dHUylv2iZxFrteoPfaWnjj5DIwJYfogLhal7yxrQ
         z9Gw==
X-Gm-Message-State: AOAM532czMA4IDhg/ZtjKu+EyZSJZy31Ejdv22+AV9TK2c6mJfiLERuz
        MjEfuaO8f5CZ4VWyONgKpThDTw==
X-Google-Smtp-Source: ABdhPJw2M6O5Yc3sL2L0DOrlSc3azMTGw+iud61+sJ6lIpuqStpgI3xY9tPsA1NcNb6zm+oeFxyRcg==
X-Received: by 2002:a17:90b:1041:: with SMTP id gq1mr1854168pjb.31.1634160188901;
        Wed, 13 Oct 2021 14:23:08 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 21sm6804567pjg.57.2021.10.13.14.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 14:23:08 -0700 (PDT)
Date:   Wed, 13 Oct 2021 21:23:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        stable@kernel.org
Subject: Re: [PATCH Part2 v5 33/45] KVM: x86: Update page-fault trace to log
 full 64-bit error code
Message-ID: <YWdONpbG9xg3p77C@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-34-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820155918.7518-34-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 20, 2021, Brijesh Singh wrote:
> The #NPT error code is a 64-bit value but the trace prints only the
> lower 32-bits. Some of the fault error code (e.g PFERR_GUEST_FINAL_MASK)
> are available in the upper 32-bits.
> 
> Cc: <stable@kernel.org>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

Paolo, can you grab this one sooner than later?  Alternatively, maybe post this
separately Brijesh?
