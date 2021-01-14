Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584C42F670B
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 18:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbhANRKa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 12:10:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728532AbhANRKQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 12:10:16 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E31C061575
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 09:09:36 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id y8so3215681plp.8
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 09:09:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rulcIsdiEGHNoW8ESlRghH9XVhQcLihfLdJxeao6dAE=;
        b=gPEudKMXiAnTUPllVqz5JHuXDPhrkPRyyDCP6TWhPkV2VLEFPJeo4+7QYRUuu47tJ4
         GGOBJGFXB7VczYpqJbHYqVKgX8pHp1aisSoUyuAxYzDAHfQJxN75INWVjrE9Wis+WJct
         HSyB/2vpVRGT2DeeUAon0m5LA087hcv2a2ewT32VsCMOVWRs5KAsCnozzkv9B0qczr9Q
         BBq5qABuLvTJJ/Kxpg2a069K1TbUgRVT+igbE0GZ3x2q2aVKeWLPfgXiJTkKvZI5aaij
         yx1HGaBNLh04MTMahsQ7Adotscw+8sVTFTv0ftXn8mB4KcPBPN72ZCmYoW2qiqjixsnx
         gxcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rulcIsdiEGHNoW8ESlRghH9XVhQcLihfLdJxeao6dAE=;
        b=PDamrjFUV8Sv3c+J7YpuKveEZWuzB/sivqo2GFaPd+qOk6pVNYWX3Y8rfyXzpfchPE
         v9kluTjWZ5KFhfpjP+bTKEN0srqwiFlsYvnV4yBoTipBmNqhRbC1qIu3+CxelK4TBeXL
         h2Bd9B3mwZHkNR8pVrhSx6p9yq33k8RVtCmenQrM/d2my2fnzLA2nqpEbC5HptZumWtG
         Z8YQX6oTZiQM5gAgxtNx0BCuVGcLhAaNA961OebaT7e03w9ciXnZ+wEjPmLI7WpLEkci
         HVrBz9g8lFH9aWuQkbKVnfs2iJSWAWwusDrcUJB9EcyG6c4QwpMKZfNMnDXcGLxSuhJi
         Inhg==
X-Gm-Message-State: AOAM530domZKcgU6ttT8akgaN8s5Iu8115dfI1i/HrcnIqyj/SFOejgs
        dIwl+2aaos/2JVSoxckuDbVK7Q==
X-Google-Smtp-Source: ABdhPJw9a7WfTeQn8qt/saCDAUnxMeN0A7NX4FlAbbluPW1chLkS17Vyeas5y/0R1QlD+3at+3w5VA==
X-Received: by 2002:a17:902:b587:b029:de:23ed:88b1 with SMTP id a7-20020a170902b587b02900de23ed88b1mr8504338pls.61.1610644175995;
        Thu, 14 Jan 2021 09:09:35 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id d36sm5952404pgm.77.2021.01.14.09.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 09:09:35 -0800 (PST)
Date:   Thu, 14 Jan 2021 09:09:28 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@suse.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v2 04/14] x86/cpufeatures: Assign dedicated feature word
 for AMD mem encryption
Message-ID: <YAB6yLXb4Es+pJ8G@google.com>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-5-seanjc@google.com>
 <20210114113528.GC13213@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114113528.GC13213@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 14, 2021, Borislav Petkov wrote:
> On Wed, Jan 13, 2021 at 04:36:58PM -0800, Sean Christopherson wrote:
> > Collect the scattered SME/SEV related feature flags into a dedicated
> > word.  There are now five recognized features in CPUID.0x8000001F.EAX,
> > with at least one more on the horizon (SEV-SNP).  Using a dedicated word
> > allows KVM to use its automagic CPUID adjustment logic when reporting
> > the set of supported features to userspace.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> 
> Subject should be:
> 
> x86/cpufeatures: Assign dedicated feature word for CPUID_0x8000001F[EAX]
> 
> but other than that, LGTM.
> 
> Anything against me taking it through tip now?

Hmm, patch 05/14 depends on the existence of the new word.  That's a non-issue
if you're planning on taking this for 5.11.  If it's destined for 5.12, maybe
get an ack from Paolo on patch 05 and take both through tip?  I can drop them
from this series when I send v3.  In hindsight, I should have split these two
patches into a separate mini-series from the get-go.

Thanks!
