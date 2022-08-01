Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8670A587453
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 01:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234368AbiHAXUd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 19:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbiHAXUa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 19:20:30 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BFC81705B
        for <kvm@vger.kernel.org>; Mon,  1 Aug 2022 16:20:29 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id x10so11149543plb.3
        for <kvm@vger.kernel.org>; Mon, 01 Aug 2022 16:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=oH+8etKuIM6aBousCne/v0+DDKXUI5egfWCxKIjJmOQ=;
        b=J3Zgk4LK/fWlvilZiNNGzMPE6ezjMVZkvbcW0nyF5Hb/uZdApCNUCgvPzErVgwm8zr
         xrHnneSy/rokZY8o//WCQ+qH8zUyl4XH8jcCO2SRyqKjKasel6AKZ/80N08jnGZmKyXH
         eWjPh6Sk+7DoTkRbIOyYd1xnddXOM+TfC+svuekpHFEhiWuortbzPpNDoBT3XXtMiP61
         CBF1hxIQcJWWtitta92C0lQ31TV+jauAGWIeMwwYfjTG3SZ3yVR3zLTBuyrxtMSoAItu
         gR/7H4UcFvFAnU79/JT2UtuOF0iWF3Uw4/kmeFs7NukWdu/V1cs8XhgVWBrlN7mHhk6/
         qBJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=oH+8etKuIM6aBousCne/v0+DDKXUI5egfWCxKIjJmOQ=;
        b=ciLKJMl1F3wJkNZ3cDGAwhnKeEMbE5+5UzIPd4coSjTMZM3idOUD6Q1rGJeVlWzi/5
         6aSCIJWGyY5vHVnZVfQkafFSAQSx73FqgUlXxvCySksMsFNyeg+XHHD61gvr80lhK5Ly
         +s1wOOP86ObN+Ab4uIj9B4BXcdSGEc3KDDgjicIFk9OrfNp0mPMGYyYTRqYjGpaRFYPl
         VFoV1UPH1evS/cNGuCmqnpM0mgeRag67i8ePCyuMh+MgksG51g0ySoT7ieIEOPghSDxT
         XzmLJRsb2EtUmMbjtp+qK9walVis9wsU47rnxVT+70+NMBrJxZjERYU00yqWGjUTthcr
         CJYg==
X-Gm-Message-State: ACgBeo2fclScVhQ7k/ZzPA2yjtaDi0u9dBVe8phnMjfIhq+BJblkuMlb
        XT0YI9Y9gSYjSAdWY4GTOOCsCg==
X-Google-Smtp-Source: AA6agR58cYnI8PKVRkgy6gjbtVEerZK2gDoKSF33ntb6xOVQe07A20qTrcKm1/K/E1USixg410o7Eg==
X-Received: by 2002:a17:90b:4c4e:b0:1f0:48e7:7258 with SMTP id np14-20020a17090b4c4e00b001f048e77258mr21488831pjb.223.1659396029066;
        Mon, 01 Aug 2022 16:20:29 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i4-20020a056a00004400b00525343b5047sm2452341pfk.76.2022.08.01.16.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 16:20:28 -0700 (PDT)
Date:   Mon, 1 Aug 2022 23:20:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 2/4] KVM: x86/mmu: Fully re-evaluate MMIO caching when
 SPTE masks change
Message-ID: <YuhfuQbHy4P9EZcw@google.com>
References: <20220728221759.3492539-1-seanjc@google.com>
 <20220728221759.3492539-3-seanjc@google.com>
 <9104e22da628fef86a6e8a02d9d2e81814a9d598.camel@intel.com>
 <YuP3zGmpiALuXfW+@google.com>
 <f313c41ed50e187ae5de87b32325c6cd4cc17c79.camel@intel.com>
 <YufgCR9CpeoVWKF7@google.com>
 <244f619a4e7a1c7079830d12379872a111da418d.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <244f619a4e7a1c7079830d12379872a111da418d.camel@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 02, 2022, Kai Huang wrote:
> On Mon, 2022-08-01 at 14:15 +0000, Sean Christopherson wrote:
> > Another thing to note is that only the value needs to be per-VM, the mask can be
> > KVM-wide, i.e. "mask = SUPPRESS_VE | RWX" will work for TDX and non-TDX VMs when
> > EPT is enabled.
> 
> Yeah, but is more like VMX and TDX both *happen* to have the same mask? 
> Theoretically,  VMX only need RWX to trigger EPT misconfiguration but doesn't
> need SUPPRESS_VE.

Right, SUPPRESS_VE isn't strictly necessary, but KVM already deliberately avoids
bit 63 because it has meaning, e.g. SUPPRESS_VE for EPT and NX for PAE and 64-bit
paging.  

> I don't see making mask/value both per-vm is a big issue?

Yes and no.

No, in the sense that it's not a big issue in terms of code.  

Yes, because of the connotations of having a per-VM mask.  While having SUPPRESS_VE
in the mask for non-TDX EPT isn't strictly necessary, it's also not strictly necessary
to _not_ have it in the mask.  In other words, having a per-VM mask incorrectly
implies that TDX _must_ have a different mask.

It's also one more piece of information that developers have to track down and
account for, i.e. one more thing we can screw up.

The other aspect of MMIO SPTEs are that the mask bits must not overlap the generation
bits or shadow-present bit, and changing any of those bits requires careful
consideration, i.e. defining the set of _allowed_ mask bits on a per-VM basis would
incur significant complexity without providing meaningful benefit.  As a result,
it's highly unlikely that we'll ever want to opportunsitically "reclaim" bit 63
for MMIO SPTEs, so there's practically zero cost if it's included in the mask for
non-TDX EPT.
