Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2CA52ED76E
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 20:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729231AbhAGTXl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 14:23:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729210AbhAGTXl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 14:23:41 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F022CC0612F5
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 11:23:00 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id v19so5602095pgj.12
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 11:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3wrW8bC9EnSUFScXbr/v1leWj3QIh7CSNlwlnFbie1M=;
        b=AYXeBLs8Mp9jAufPJAEkHwPbo7oWnP4zD/TmgHizl0fFC1aR1DR1uOY4xIpsjCgi0A
         m4OwMr0Cx4k5s8Wv8ucVMFYiLTW/bBQiPoJAL7RufPo38Jnj1I//ZRX9CfCdEqsPPHPC
         nty1ovjql/WZnFde6JR8JD6pEtSxh7V1CDFKjSOiXugNDVTpe7NvVYXPEOFZgWJWIDgT
         p63EmFMRQvVHWdPaCLRlKR8tKzvPqokZTVyatBjJJCH167Uc/8ONofml8vm3H0yj/kre
         ztFCwCRHZ73ulC1cqIINOu0ASrUAXHAA/qbBq1SNHxCp4tRiJ6UgMadtfggbvNkcHBmV
         DCHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3wrW8bC9EnSUFScXbr/v1leWj3QIh7CSNlwlnFbie1M=;
        b=sji09mQrdCtAl/mbxpyojDVtu4jnk0zl66Poaj9o+ycHhFJ1MF8v4G3Rq1VE7sswbL
         4LL9a7dxbbCHnItYVTEVsF1ulxt662frzc7FjdOaxH87VE3bX+Apddcuazana6Mv0+II
         2/ubUtMK/Qgg7R9zg4vpLO7TGJPbrUE9wnGs7LATF/2HgUtSCooMWBmXRAilRtKIH/qR
         rmwZraeq3BkAcuvoKrCc4XLcdcDIqJltH9qnDfK/MDgaqCddFAJCzuMHdTip9MzlWa6E
         IpylT1o1RaYuDQRYD5LWEI4LaqFYYoLJmXepQNU09gbgTPD1ravgd9BpBZxw1OPYSZ5I
         I7+Q==
X-Gm-Message-State: AOAM531tExOC5Zd4PolKFO7qR8Oh8/06s4RTHWyqqcD6yrJDTEwj0sgu
        J548gPp7hCiU03jC9TYcVNFhDw==
X-Google-Smtp-Source: ABdhPJwdkbpZp9YH3Tf5cchCh0a7A1tc5kRjDb7subKVPJG/66CrcN6nDTfNCUbuJ1HyKW6taotgCA==
X-Received: by 2002:aa7:8b51:0:b029:1ae:687f:d39b with SMTP id i17-20020aa78b510000b02901ae687fd39bmr275421pfd.50.1610047380296;
        Thu, 07 Jan 2021 11:23:00 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id a141sm6378449pfa.189.2021.01.07.11.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 11:22:59 -0800 (PST)
Date:   Thu, 7 Jan 2021 11:22:52 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Steve Rutherford <srutherford@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "dovmurik@linux.vnet.ibm.com" <dovmurik@linux.vnet.ibm.com>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "frankeh@us.ibm.com" <frankeh@us.ibm.com>, jon.grimm@amd.com
Subject: Re: [PATCH v2 1/9] KVM: x86: Add AMD SEV specific Hypercall3
Message-ID: <X/dfjElmMpiEvr9B@google.com>
References: <20201211225542.GA30409@ashkalra_ubuntu_server>
 <20201212045603.GA27415@ashkalra_ubuntu_server>
 <20201218193956.GJ2956@work-vm>
 <E79E09A2-F314-4B59-B7AE-07B1D422DF2B@amd.com>
 <20201218195641.GL2956@work-vm>
 <20210106230555.GA13999@ashkalra_ubuntu_server>
 <CABayD+dQwaeCnr5_+DUpvbQ42O6cZBMO79pEEzi5WXPO=NH3iA@mail.gmail.com>
 <20210107170728.GA16965@ashkalra_ubuntu_server>
 <X/dEQRZpSb+oQloX@google.com>
 <20210107184125.GA17388@ashkalra_ubuntu_server>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107184125.GA17388@ashkalra_ubuntu_server>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 07, 2021, Ashish Kalra wrote:
> On Thu, Jan 07, 2021 at 09:26:25AM -0800, Sean Christopherson wrote:
> > On Thu, Jan 07, 2021, Ashish Kalra wrote:
> > > Hello Steve,
> > > 
> > > On Wed, Jan 06, 2021 at 05:01:33PM -0800, Steve Rutherford wrote:
> > > > Avoiding an rbtree for such a small (but unstable) list seems correct.
> > > > 
> > > > For the unencrypted region list strategy, the only questions that I
> > > > have are fairly secondary.
> > > > - How should the kernel upper bound the size of the list in the face
> > > > of malicious guests, but still support large guests? (Something
> > > > similar to the size provided in the bitmap API would work).
> > > 
> > > I am thinking of another scenario, where a malicious guest can make
> > > infinite/repetetive hypercalls and DOS attack the host. 
> > > 
> > > But probably this is a more generic issue, this can be done by any guest
> > > and under any hypervisor, i don't know what kind of mitigations exist
> > > for such a scenario ?
> > > 
> > > Potentially, the guest memory donation model can handle such an attack,
> > > because in this model, the hypervisor will expect only one hypercall,
> > > any repetetive hypercalls can make the hypervisor disable the guest ?
> > 
> > KVM doesn't need to explicitly bound its tracking structures, it just needs to
> > use GFP_KERNEL_ACCOUNT when allocating kernel memory for the structures so that
> > the memory will be accounted to the task/process/VM.  Shadow MMU pages are the
> > only exception that comes to mind; they're still accounted properly, but KVM
> > also explicitly limits them for a variety of reasons.
> > 
> > The size of the list will naturally be bounded by the size of the guest; and
> > assuming KVM proactively merges adjancent regions, that upper bound is probably
> > reasonably low compared to other allocations, e.g. the aforementioned MMU pages.
> > 
> > And, using a list means a malicious guest will get automatically throttled as
> > the latency of walking the list (to merge/delete existing entries) will increase
> > with the size of the list.
> 
> Just to add here, potentially there won't be any proactive
> merging/deletion of existing entries, as the only static entries will be
> initial guest MMIO regions, which are contigious guest PA ranges but not
> necessarily adjacent. 

My point was that, if the guest is malicious, eventually there will be adjacent
entries, e.g. the worst case scenario is that the encrypted status changes on
every 4k page.  Anyways, not really all that important, I mostly thinking out
loud :-)
