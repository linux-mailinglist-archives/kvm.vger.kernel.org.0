Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 052DF2F672A
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 18:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbhANROP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 12:14:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728374AbhANROO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 12:14:14 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8E7C061575
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 09:13:33 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id b3so3740944pft.3
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 09:13:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OKPnLLplhRNmeoV6NY+JrG/2XUXd3Jl9oyOtg+gZeHA=;
        b=jpipB+9kIff5Tv0vnTnurZDN7yGTOeueru9cS/LH34OKylQIyB8U8q3N03m6SRSeJn
         vM3LPmrRoBl94FX7ZPC/TMselOSAz+Bnb60lS1YG9B5BuBuhvTpWtJDeRd41BU132lXV
         JiPJsPZY1mdZ89zZQXDPCUZR1rDzd+uy4R4qFidRwDsx9lK7QxCZA2938Lc1Ta2SYTdJ
         3nXilJeBCQqHByOHmI4GUNIy4h/S4LgwitTotXTMf2jHrgLtVoefeT26J5pHbbbm4SF0
         MPxvRgllVc7ORWs3SxWuGlO0CI8p/no5Qas3zLe//zNO0Y5FIihbU34bG07ufdXFnLJp
         vlMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OKPnLLplhRNmeoV6NY+JrG/2XUXd3Jl9oyOtg+gZeHA=;
        b=dNYCs/W8EgzBm2sQ+rrH5Scc+1Eljs/8w0sHXDrIkjegR+BZCoFMuK1c3c0ccrR3DV
         96QPhrKANaikEnLN2c4wVlNZWsWUdS2nmtjMDK/2dD6KauzwAEA1ju9VifodBdhERljV
         GTui1X1nX46RAdJ0tudnj2oIrVAMc4LvCIKI0ehdAr0d/rfUp0sWbWAUR+FQ40Y4QoCx
         9fH2PdSMe5/bOQ9msogwFVe2R23SojmgC998sSKSTj3iqVfkP5pMALwU8hl6nKLX4BXk
         //0zAYWvCPiRgqGev3J+mFsZIs9caULmTo2ZnKjEnnNnku9DErIHglnpBDETQ/JoIytr
         mkvg==
X-Gm-Message-State: AOAM533PivjywuLS7M+fuaE4PhJcpD4xrVfDYnHKB76Ar/mwmQBAl0WZ
        qxMQgze/keCp3CTJSL6W0cbwBA==
X-Google-Smtp-Source: ABdhPJwUbPwHAM0ys8f0iS52iICwmmGFVz58imXchuP4PQsYRnq24zsPYrz4sUFvEEtZT8tTHG4geg==
X-Received: by 2002:a63:eb0c:: with SMTP id t12mr8488528pgh.7.1610644413234;
        Thu, 14 Jan 2021 09:13:33 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id 19sm5707564pfn.133.2021.01.14.09.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 09:13:32 -0800 (PST)
Date:   Thu, 14 Jan 2021 09:13:25 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v2 01/14] KVM: SVM: Zero out the VMCB array used to track
 SEV ASID association
Message-ID: <YAB7tckzbZUrRbf5@google.com>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-2-seanjc@google.com>
 <3d41137e-e8e0-8139-3050-eac58ad82a4f@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d41137e-e8e0-8139-3050-eac58ad82a4f@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 14, 2021, Tom Lendacky wrote:
> On 1/13/21 6:36 PM, Sean Christopherson wrote:
> > Zero out the array of VMCB pointers so that pre_sev_run() won't see
> > garbage when querying the array to detect when an SEV ASID is being
> > associated with a new VMCB.  In practice, reading random values is all
> > but guaranteed to be benign as a false negative (which is extremely
> > unlikely on its own) can only happen on CPU0 on the first VMRUN and would
> > only cause KVM to skip the ASID flush.  For anything bad to happen, a
> > previous instance of KVM would have to exit without flushing the ASID,
> > _and_ KVM would have to not flush the ASID at any time while building the
> > new SEV guest.
> > 
> > Cc: Borislav Petkov <bp@suse.de>
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > Cc: Brijesh Singh <brijesh.singh@amd.com>
> > Fixes: 70cd94e60c73 ("KVM: SVM: VMRUN should use associated ASID when SEV is enabled")
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/svm/svm.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 7ef171790d02..ccf52c5531fb 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -573,7 +573,7 @@ static int svm_cpu_init(int cpu)
> >   	if (svm_sev_enabled()) {
> >   		sd->sev_vmcbs = kmalloc_array(max_sev_asid + 1,
> >   					      sizeof(void *),
> > -					      GFP_KERNEL);
> > +					      GFP_KERNEL | __GFP_ZERO);
> 
> Alternatively, this call could just be changed to kcalloc().

Agreed, kcalloc() is a better option.  I'll do that in v3.
