Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492FE3C787A
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 23:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236285AbhGMVF6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 17:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236230AbhGMVFy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 17:05:54 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B794DC0613F0
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 14:03:03 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id k20so15676400pgg.7
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 14:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/+a0nOAUvmFDk9sQMqBodRLs3dk1rTDWSs7A8bhW4R4=;
        b=iA0rtUSvo2J+Q0KFs9VeHEfWPCZ8DBG+LqtWDHZyagCTcEzWpYCjPE4wfvRNUVRF7u
         9Ki2NkyU53QgVvw8hFtNPqw61MFpsNaDTlck0X1PjcjPQqbYGgFSqk+gC9543wfuqxqP
         0Lq7YzT4LxZrqcAOKEMdShDcVjej34X2egWDr8PXR/EdiJ9jJLWjBGn2t8J4HWtp6HEX
         4cX1hGyRCCgbQcYp+Iolkk0VjDull+k8vpcQ+zrZIUtDhLmDBnom3Y7BG3xV+NYW/tsD
         7ty0z8TzhI2oSJgLoNEoCJYA76zZyptM0gzanVZu3sUAA94xvw653dRzaS/ggc6v9EAC
         k9Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/+a0nOAUvmFDk9sQMqBodRLs3dk1rTDWSs7A8bhW4R4=;
        b=hWX03U+yYiFCc/b9wyLdIuYJV80M1gabor3vJaz7wjKLjVPoyHuF6xli7cA/y07URq
         j0Aane3YSUALuGRCz3MouerGUuzleqDpB0AhYRJf3TcrK4eUYR79PmfDe8WusrW3/DlD
         HHkWQpsqKedZH90WHxuuKw+5n4Jz7VNZ1W479yq6oGWlCfliaPc8dwJq4l9l7gx3JWa7
         70Z//Vyc9ICVJMHNtNm8Bt0K1yF6s5ORrdEEOPTE4N/pvdlFRJ2iDsvKIMq75ig7weeQ
         By/RPWgFxRCAeyztGlS624UTufsAqHYKL4UGW7sK/8JrDn1kjYjwr7saE/weDy8YTfIF
         L1kg==
X-Gm-Message-State: AOAM53318tCcz2d3qMBNo9jEEZNWKwE9zBOapCAZufQcZtnpzN8HMetn
        P7s1E1KkzH/8V4MeLIgOCJZB6w==
X-Google-Smtp-Source: ABdhPJww8g05J8+aQcowzYH6Gd3XLQf/mwD1z0IQ5Ql/naKK2SPiOd1YyZMnANZGrw2dUw7d8cZfFA==
X-Received: by 2002:a65:4109:: with SMTP id w9mr5888848pgp.24.1626210183074;
        Tue, 13 Jul 2021 14:03:03 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a20sm3604319pjh.46.2021.07.13.14.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 14:03:02 -0700 (PDT)
Date:   Tue, 13 Jul 2021 21:02:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH v2 51/69] KVM: x86/mmu: Allow per-VM override of the
 TDP max page level
Message-ID: <YO3/gvK9A3tgYfT6@google.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <e2521b4c48c582260454764e84a057a2da99ac3c.1625186503.git.isaku.yamahata@intel.com>
 <89d1ff17-dc48-0f39-257a-4cf11a98f435@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89d1ff17-dc48-0f39-257a-4cf11a98f435@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 06, 2021, Paolo Bonzini wrote:
> On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > TODO: This is tentative patch.  Support large page and delete this patch.
> > 
> > Allow TDX to effectively disable large pages, as SEPT will initially
> > support only 4k pages.

...

> Seems good enough for now.

Looks like SNP needs a dynamic check, i.e. a kvm_x86_ops hook, to handle an edge
case in the RMP.  That's probably the better route given that this is a short-term
hack (hopefully :-D).
