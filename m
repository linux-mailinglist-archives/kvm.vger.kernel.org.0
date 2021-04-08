Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFDEA358840
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 17:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbhDHPZC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 11:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232164AbhDHPZA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 11:25:00 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F849C061762
        for <kvm@vger.kernel.org>; Thu,  8 Apr 2021 08:24:49 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id q6-20020a17090a4306b02900c42a012202so1563743pjg.5
        for <kvm@vger.kernel.org>; Thu, 08 Apr 2021 08:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eq6Itc9aMiGMsim8WMHVwgalEukilZgAEStTZoS6ofQ=;
        b=Ws1ziVf1pL/fFefKj9jo0zyWYm3rscnZH7xWcUVj7d7hOwPQ2zCLCi/G59RoNdlxDF
         R4YrUFf83zW0yw6vX9POslVVw1pGYIFl7wLG9AtM097bxq3O32wSDDGSYzar0/j0cR/B
         BGKteoOVjjOZUcPY503PAj4/d0QlWyOJbQl1roVlf9Uy3Vl/BI4CRRFNqALE7Za4N2cx
         +/KosYABy2h3fwdmF1Cvucjf4dbmNVAQoHPZFN/6IVPJIxz1OD6VJ8aCH8QV+3r+qatE
         ZcZaDds1lD4sKrU1z+CL0IloRD19KqnMdC2+6C6VoWAYRELbVqTM7cEeCQg50vTmhZtX
         5HNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eq6Itc9aMiGMsim8WMHVwgalEukilZgAEStTZoS6ofQ=;
        b=kVsebktEuu16uUcYPXR75H+PcrLKJNyIc2c1Z7a8s6iKufiFltAgZhoUEwLswloINd
         ShgWOeKG2bC70mm4bs1AofScKbRJtQ+1iyatoONJ/OkaVfpSs28duR2IcSCSow5riC7m
         w8sBWGlshyeptaNKDZ/UHl3Tpo0KlUvmDzu18f1KyddML5Ud5qKGQbR/YmV9onOs0FUv
         0148zZCA8CRbwxEJptNShax6J4bEEMHPff55DG8a2jfSgHyxeJjxKD5IbPkY1XO5unso
         8vctvbpmHCXBKC1vPDjkx4ccsJB4ZRtwgVftyU3H6PZO7F2rw3sAneK/98i/zoG44TF+
         e/zw==
X-Gm-Message-State: AOAM5309FVQrQ/5OqQXa5PoxES6T0c1M7yq0Hyto/Jwkubk5YVXgp75S
        6oN93QjRDKPSX68yAIg9k2k5NQ==
X-Google-Smtp-Source: ABdhPJyEuEnbYSjOZscxK5PLwE9AEUgL/8wG4Tau3gpnma1pMGX7qkuX05AdiIrzN13uyWEnok00DQ==
X-Received: by 2002:a17:902:988d:b029:e8:dd65:e2b5 with SMTP id s13-20020a170902988db02900e8dd65e2b5mr8342923plp.36.1617895488546;
        Thu, 08 Apr 2021 08:24:48 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id f20sm8362398pfv.126.2021.04.08.08.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 08:24:47 -0700 (PDT)
Date:   Thu, 8 Apr 2021 15:24:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vineeth Pillai <viremana@linux.microsoft.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/7] hyperv: Detect Nested virtualization support for SVM
Message-ID: <YG8gPI6NZHGBc3Zl@google.com>
References: <cover.1617804573.git.viremana@linux.microsoft.com>
 <e14dac75ff1088b2c4bea361954b37e414edd03c.1617804573.git.viremana@linux.microsoft.com>
 <87lf9tavci.fsf@vitty.brq.redhat.com>
 <af87c25e-78c6-5859-e1c1-2aa07d087a25@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af87c25e-78c6-5859-e1c1-2aa07d087a25@linux.microsoft.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 08, 2021, Vineeth Pillai wrote:
> Hi Vitaly,
> 
> On 4/8/21 7:06 AM, Vitaly Kuznetsov wrote:
> > -	if (ms_hyperv.hints & HV_X64_ENLIGHTENED_VMCS_RECOMMENDED) {
> > +	/*
> > +	 * AMD does not need enlightened VMCS as VMCB is already a
> > +	 * datastructure in memory.
> > Well, VMCS is also a structure in memory, isn't it? It's just that we
> > don't have a 'clean field' concept for it and we can't use normal memory
> > accesses.

Technically, you can use normal memory accesses, so long as software guarantees
the VMCS isn't resident in the VMCS cache and knows the field offsets for the
underlying CPU.  The lack of an architecturally defined layout is the biggest
issue, e.g. tacking on dirty bits through a PV ABI would be trivial.

> Yes, you are right. I was referring to the fact that we cant use normal
> memory accesses, but is a bit mis-worded.

If you slot in "architectural" it will read nicely, i.e. "VMCB is already an
architectural datastructure in memory".
