Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B943F43563E
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 01:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhJTXDs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 19:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhJTXDq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 19:03:46 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 013E2C061749
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 16:01:31 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id np13so3518189pjb.4
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 16:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=h+RFC7eotFhOqFJGWOoMWVQg50r4LBG0z2sivzZSrgk=;
        b=pma9xTPAAozGlLfkB9sflNKGCaUTlYDPKd78LbYcHoBUpBRdiQpZNG/Cc1nZw9vI4s
         VTSD/474dW5dlNqhL8p1TXmulQIJQRdwQd35Hq/TvTJHLS+D754q5dwalnSMpnNallp6
         QEE6REP3UMdDQd9t5/eTDAwqCT3kSq7TIRlSMz5dG+F3C0cAQG5Of9T0co/dFDVodtCw
         LDtGnlp14OoIc4w9aY2VNUN730bG1epxV1fC8y0RW9O5Yzg6agArEPev3CeYeo6QWUHe
         cjwF0FLqkskp8GARImJVl4T0BDlhURPzNIkeGgRFvjb/C72VmjO4rjSXV0a8d2SsN1L+
         DK7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=h+RFC7eotFhOqFJGWOoMWVQg50r4LBG0z2sivzZSrgk=;
        b=TpDukQ5C3/dGq8FDttgHAE9+WaByZTz0shGocTP4H7b/w7+hJednU3N9BXbkYHWGfa
         LwpG/aQp5hoxwO/cq95QJG6xfcg88Ey55JaKdsnrDp+7+XOO73HfUhEhBxR2x/Dr4AG8
         bpkL5DWYn36nIIG/efkqrfDiqaMA808TxOPVSaqilIifQ1TkOBvFH3vkSBMY01+uFvFQ
         vo7qWEHkUaBkGnXhge+ue70eSVkc/W/Si2rAeCvW1QnRtgjzQ8uy4KfZhRLMSsfZ8cGZ
         O4uIRE0MFsaeQgkqb1jTerNXqxdLiREI7i8uB2QUwh4nVpo108pNuEVftRBDfo8QeqRh
         mX9Q==
X-Gm-Message-State: AOAM532oEO/n7xBofTWLGfkbmI2xbrthZEkEMd4ISpm6ykgZIyBbwaOx
        UBoAL+/xBpM0BN8iHPSJZcxFXZLAD1k=
X-Google-Smtp-Source: ABdhPJwAYmwtedqpowu2BAnkunIqrQX+jLSp7mbf/jJKomExPMM30rDS5HiPAzzKOhqXTZ7V/PFb/Q==
X-Received: by 2002:a17:90a:b314:: with SMTP id d20mr2168217pjr.174.1634770891214;
        Wed, 20 Oct 2021 16:01:31 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k1sm3356698pjj.54.2021.10.20.16.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 16:01:30 -0700 (PDT)
Date:   Wed, 20 Oct 2021 23:01:27 +0000
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
Subject: Re: [PATCH Part2 v5 44/45] KVM: SVM: Support SEV-SNP AP Creation NAE
 event
Message-ID: <YXCfxyfQBix8+As+@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-45-brijesh.singh@amd.com>
 <YWnbfCet84Vup6q9@google.com>
 <a7944441-f279-a809-8817-2e4b38a0e309@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7944441-f279-a809-8817-2e4b38a0e309@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 20, 2021, Brijesh Singh wrote:
> 
> On 10/15/21 2:50 PM, Sean Christopherson wrote:
> > And digging through the guest patches, this gives the guest _full_ control over
> > the VMSA contents.  That is bonkers.  At _best_ it gives the guest the ability to
> > fuzz VMRUN ucode by stuffing garbage into the VMSA.
> 
> If guest puts garbage in VMSA then VMRUN will fail. I am sure ucode is
> doing all kind of sanity checks to ensure that VMSA does not contain
> invalid value before the run.

Oh, I'm well aware of the number of sanity checks that are in VM-Enter ucode, and
that's precisely why I'm of the opinion that letting the guest fuzz VMRUN is a
non-trivial security risk for the host.  I know of at least at least two VMX bugs
(one erratum that I could find, one that must have been fixed with a ucode patch?)
where ucode failed to detect invalid state.  Those were "benign" in that they
caused a missed VM-Fail but didn't corrupt CPU state, but it's not a stretch to
imagine a ucode bug that leads to corruption of CPU state and a system crash.

The sheer number of checks involved, combined with the fact that there likely
hasn't been much fuzzing of VM-Enter outside of the hardware vendor's own
validation, means I'm not exactly brimming with confidence that VMRUN's ucode
is perfect.

I fully acknowledge that the host kernel obviously "trusts" CPU ucode to a great
extent.  My point here is that the design exposes the host to unnecessary risk.
