Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7CA494550
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 02:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345659AbiATBGe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 20:06:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240699AbiATBGd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 20:06:33 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE69C061574
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 17:06:33 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id t32so4215162pgm.7
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 17:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Cn8y2MduSfxpaUqgG70M6OfS7ciqUGnpG7newRRVGPo=;
        b=l9//kvAqzr4TuZQOO5YZKMU5K+Nz/XqA2W8mABc4KeB0yGrfqBBq4kx2YfXYRGnmr6
         U27+GMDDLWM+9p1myl0pCQNxtGLVjmwRvs7Q58qRhTHaNtAbqWG7kF3z1/TXbFni3YQx
         BKZXCgPFF54pw4BZTc8lZvGrjxCHFz3eRBg5IjXWkiZ7qSdDgjBKujwCswcM7n+ftqli
         qzk/694Fo7qKRGCoEb5H+i0aMcf8iDbIjutDmDpYDN11368ebUpJUC8oMadzTD0s766P
         MluaYOSWQlvvG/YRm0yfhQK1z/go8/OpbmPHDk7XKforxsXh6aM2m/YPHRnEkd4BBbae
         1a9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Cn8y2MduSfxpaUqgG70M6OfS7ciqUGnpG7newRRVGPo=;
        b=EpUB+FTr6eAw1nJ8oapCVqCLXusFczVVwWTImPwYGyJdgxPodoc0v4N7fUY5bf2BJt
         /iGO6D1od6upfdkXjTyZJOm0X919vcXPhDS2s+X2LeRVXbXTuat8Srb1KJNjPX70qbKj
         X+F9Xp6cfrvBUxERyhT6r8Wdk+BEEBP4QeBPR23PXvra2G7qhwlGiDcMV9qGleexN2WA
         1NOQHbQlmbBamozDz6aljFSRQRSvXfmieFnFweZWj5nrqAcu5dmzWVFUPSkcz7w3IkGT
         EVPkPxlm/n8jGKi0MtI6XBRmhtX0CV67pq+N4SgvnGuqDh1GseWwn1XqfJxpCsKnXbcI
         eL5w==
X-Gm-Message-State: AOAM532dC7tmsVLPkSx2yicqR36AMnkcuwMrqDIuBS6gBy0mqTgIbnUV
        bZJj22pFFIet+4Jt1CY5ry5N9w==
X-Google-Smtp-Source: ABdhPJwhpHGT8KOOuEPAQImew6soTRUO2yMGEdyts2hB/E1RwOriB5vWheLq4HUU+aewl1urvRc1oA==
X-Received: by 2002:a63:fe10:: with SMTP id p16mr29143931pgh.546.1642640792646;
        Wed, 19 Jan 2022 17:06:32 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m17sm843462pfk.62.2022.01.19.17.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 17:06:31 -0800 (PST)
Date:   Thu, 20 Jan 2022 01:06:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: Re: [PATCH v5 4/8] KVM: VMX: dump_vmcs() reports
 tertiary_exec_control field as well
Message-ID: <Yei1lODnpQTZLa7s@google.com>
References: <20211231142849.611-1-guang.zeng@intel.com>
 <20211231142849.611-5-guang.zeng@intel.com>
 <YeCTsVCwEkT2N6kQ@google.com>
 <7fd4cb11-9920-6432-747e-633b96db0598@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7fd4cb11-9920-6432-747e-633b96db0598@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 14, 2022, Zeng Guang wrote:
> On 1/14/2022 5:03 AM, Sean Christopherson wrote:
> > Can you provide a sample dump?  It's hard to visualize the output, e.g. I'm worried
> > this will be overly log and harder to read than putting tertiary controls on their
> > own line.
> 
> Sample dump here.
> *** Control State ***
> 
>  PinBased=0x000000ff CPUBased=0xb5a26dfa SecondaryExec=0x061037eb
> TertiaryExec=0x0000000000000010

That's quite the line.  What if we reorganize the code to generate output like:

  CPUBased=0xb5a26dfa SecondaryExec=0x061037eb TertiaryExec=0x0000000000000010
  PinBased=0x000000ff EntryControls=0000d1ff ExitControls=002befff

That keeps the lines reasonable and IMO is better organization too, e.g. it captures
the relationship between primary, secondary, and tertiary controls.

>  EntryControls=0000d1ff ExitControls=002befff
>  ExceptionBitmap=00060042 PFECmask=00000000 PFECmatch=00000000
>  VMEntry: intr_info=00000000 errcode=00000000 ilen=00000000
>  VMExit: intr_info=00000000 errcode=00000000 ilen=00000003
>          reason=00000030 qualification=0000000000000784
> > >   	pr_err("EntryControls=%08x ExitControls=%08x\n", vmentry_ctl, vmexit_ctl);
> > >   	pr_err("ExceptionBitmap=%08x PFECmask=%08x PFECmatch=%08x\n",
> > >   	       vmcs_read32(EXCEPTION_BITMAP),
> > > -- 
> > > 2.27.0
> > > 
