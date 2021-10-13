Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5E642CCB3
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 23:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbhJMVWT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 17:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbhJMVWS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 17:22:18 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196ACC061746
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 14:20:15 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id q10-20020a17090a1b0a00b001a076a59640so4344359pjq.0
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 14:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RGN5XybAu/ZhV4g4WKdQdjzcI3C7PMTK/Om4cnVrUpo=;
        b=URyt4OiWOZC9rK5oCCWsfUHOqUulNfj8PNGEdBZtuq6KCLHghJJH1K2XFPqHe+8A7y
         56MHd6S8jFcLp7x91lXskW43i/kaf10KdqkU+LjqEdBmY1cKnBADOUyg4E/e4bVlRSQp
         sXUn2UHFAJtGCxOdV+33RGRos4gvcpAsM+/EJTmf+5mshqUfa6AWpZCOYewLATdcJgXI
         TxHeqzIogq3Ec9tg0+7AUlZcDaZe7URCgnMuLvWHocz/izBx/kV3wTyYKYYLhxcPOZto
         2M98Jb9p2C4x5nYV+q1yvkyuEtlMcPzrwMzIvIq0Trd1MB/16Mx/Re0M5DPMChi+vAnM
         rtUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RGN5XybAu/ZhV4g4WKdQdjzcI3C7PMTK/Om4cnVrUpo=;
        b=2RQMDzxrR83tB8FzGL5jsj4uZsHYdbUXZdl9OXIB8C436b/uTqLYvw5NUWkfyl/a/t
         l9kz1KgM1pujohU375749CERTzfikSAXLFBp+GRl65VtljkXnNRHAgQylPX/8AIHb7Uu
         pNRkb8jNHGytDrVC6x/wKvrsQaqycbhk52WynK/kNn4Gx0faB/jv1o20hpfPJpyQqrjs
         MjibrJxQOjcE342kpB5MrhtlZhbkpWwf3Nw2D5xIrspxudjbE5J/WAoQzSKCmIHiUAu0
         VyY/b36W3u6THVayGCCOxD2IEZ/ohN3wIqCRh+sBGlXWn6DFcJFrpZyFOSH2pYlNTjeL
         wAxQ==
X-Gm-Message-State: AOAM533IWndVQLANp8fclWVK4Ili6GSHh4Bf/NzxZXTIc/QITRarSibO
        FYy2T5yMftrl0otvwjS3IeYVnA==
X-Google-Smtp-Source: ABdhPJychxbBPRopo44Q5l2xzCuClhpOoVGj+sul7kS1bgtgKxWbFsqery8BnwMw41xY+QTD3uOz7w==
X-Received: by 2002:a17:90b:30d6:: with SMTP id hi22mr16321219pjb.4.1634160014413;
        Wed, 13 Oct 2021 14:20:14 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u12sm414951pgi.21.2021.10.13.14.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 14:20:13 -0700 (PDT)
Date:   Wed, 13 Oct 2021 21:20:10 +0000
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
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 34/45] KVM: SVM: Do not use long-lived GHCB map
 while setting scratch area
Message-ID: <YWdNisk78f5BVNv3@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-35-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820155918.7518-35-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 20, 2021, Brijesh Singh wrote:
> The setup_vmgexit_scratch() function may rely on a long-lived GHCB
> mapping if the GHCB shared buffer area was used for the scratch area.
> In preparation for eliminating the long-lived GHCB mapping, always
> allocate a buffer for the scratch area so it can be accessed without
> the GHCB mapping.

Would it make sense to post this patch and the next (Remove the long-lived GHCB
host map) in a separate mini-series?  It's needed for SNP, but AFAICT there's
nothing that depends on SNP.  Getting this merged ahead of time would reduce the
size of the SNP series by a smidge.
