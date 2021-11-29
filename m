Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1804462727
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 23:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236947AbhK2XBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 18:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237093AbhK2XAn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 18:00:43 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582CCC1A0D1D
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 10:36:36 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id j5-20020a17090a318500b001a6c749e697so12240126pjb.1
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 10:36:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tlAzD3aQxZNbhH82DiZEqP09YfqX3PXGzrFEKOt1BUE=;
        b=VMyEtGnE90jgPkfdArsfFQ73biEKasoDaOcmKYoZKhQrm4TkNFsD5TTOC+i1xSw4IA
         QwSOEIYqYFet0ZZuJcRlz/K5uFQE/fenSx0d0EnnQ6oZbMNHkjflfqpu20QoV/0Nih3R
         nMzQUwHTrrLjS0cxhTgTVwhC7ZASBaqm1glT2gMVZ9zfl+0rqU/1lxZr1KBKehahtfy9
         cXLL/bvyEMQd0qujLL/xmH/ESnBM3510+1Nuicl2fKEThRU8WVOA8JCJKg3STPnXD26P
         DDqxVmJCx2aXGJ6DArW+HHKb8MeCVbRgGp2m7sZZjJfZ78gCHNoKusXy9dix+Y0oTbAR
         QSXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tlAzD3aQxZNbhH82DiZEqP09YfqX3PXGzrFEKOt1BUE=;
        b=aCqWqlP+M5rLm42auFx5fXRSCgiztHgg3L5pRjnHT9cEDsa0BFDam9zJedBTl71AwU
         KQ+JlsvXbBgH9NCWw6tjfoRx0ZGgr2B3AuiGF8ce1hd3fRD7ReqIC8p/I4/21bsgckI3
         Y2Yfd2JsNpKDHJl8YeP3hbBTl49PGlrgpwf9vtkXt297uydl8Bo4gb6qN3MtFLeFFpN9
         v88PX7tkdrbX1GxmrGqDSthZ8jcdAVUK0y4kALvcdD/XijA6bJGxYujBabxsbU3OTiy6
         amUVTNAJt2mioazMhvd5OIDdXFdHuCvl0dwJNr3+n1bwh3e63OvBMdHA1SWZ9Vz45Va+
         Gu6w==
X-Gm-Message-State: AOAM5333aNnHTM52yzB8XuOdJk6v+H1Qm5fjTnvq2kxskfFqq5Jw80lv
        7SqV3OaBM4hZBfcCGD0ImV6yKg==
X-Google-Smtp-Source: ABdhPJx8WtPK3FSjNprjLl/l1toByBy/n2qpSmC6t2XTOO85rqwFTlV9d2tAz2CyzikyPU9sLpNeRg==
X-Received: by 2002:a17:902:aa43:b0:143:e20b:f37f with SMTP id c3-20020a170902aa4300b00143e20bf37fmr61456504plr.65.1638210995742;
        Mon, 29 Nov 2021 10:36:35 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 95sm62436pjo.2.2021.11.29.10.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 10:36:35 -0800 (PST)
Date:   Mon, 29 Nov 2021 18:36:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     isaku.yamahata@intel.com, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [RFC PATCH v3 47/59] KVM: TDX: Define TDCALL exit reason
Message-ID: <YaUdr5tL7d+kpsX5@google.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <eb5dd2a1d02c7afe320ab3beb6390da43a9bf0bc.1637799475.git.isaku.yamahata@intel.com>
 <87k0gwhttc.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0gwhttc.ffs@tglx>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 25, 2021, Thomas Gleixner wrote:
> On Wed, Nov 24 2021 at 16:20, isaku yamahata wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> >
> > Define the TDCALL exit reason, which is carved out from the VMX exit
> > reason namespace as the TDCALL exit from TDX guest to TDX-SEAM is really
> > just a VM-Exit.
> 
> How is this carved out? What's the value of this word salad?
> 
> It's simply a new exit reason. Not more, not less. So what?

The changelog is alluding to the fact that KVM should never directly see a TDCALL
VM-Exit.  For TDX, KVM deals only with "returns" from the TDX-Module.  The "carved
out" bit is calling out that the transition from SEAM Non-Root (the TDX guest) to
SEAM Root (the TDX Module) is actually a VT-x/VMX VM-Exit, e.g. if TDX were somehow
implemented without relying on VT-x/VMX, then the TDCALL exit reason wouldn't exist.

> > Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> I'm pretty sure that it does not take two engineers to add a new exit
> reason define, but it takes at least two engineers to come up with a
> convoluted explanation for it.

Nah, just one ;-)
