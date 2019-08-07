Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAC5484EBF
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2019 16:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388338AbfHGO2y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Aug 2019 10:28:54 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:46147 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388144AbfHGO2x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Aug 2019 10:28:53 -0400
Received: by mail-ed1-f66.google.com with SMTP id d4so86509754edr.13
        for <kvm@vger.kernel.org>; Wed, 07 Aug 2019 07:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AK75Iich5LWx3hmzjSJRalUSa9mHCHUU+BYMHbZIZMc=;
        b=1kfH0kuKZirattxRfWIXAb8r/8XsqrwQ5+d4RJ0mmXY7DEH4SwvLktRN8ao5mQqeIV
         Y3ts078FX51cmkr90vSJtL/7kpBoPXXkQupeiLZiWKerWAGmgFJ5Zvn2S/5gBdKtsK7G
         gF0VS9r1jf+JhGubMnetDvc2e92Z6Z5+z4U8O8JMtfrTP/Llowbkfpl8b3oqAvhid7ve
         8wnfPsAKUAEzIX6F9HxCD3lF0DRbTNLYuN6fS7wGv7dIqOlhNFeAz1z8FZ5C16HANqQj
         /iY4mVqDeK/M8VJxQ2dSgEi0eZ/FsqFz9IbyUsa9c4zxZs+yPBtOzLgGcVj2gGvMJA17
         Vpqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AK75Iich5LWx3hmzjSJRalUSa9mHCHUU+BYMHbZIZMc=;
        b=tc9dv/sV5x4KuQbm9ILFEYJOlF3OHS7RlmIez3AYpPk4reAxpf44ltmmA7/fedPBMc
         jeBFaSx+2O+F3/ZxairP8Oa0BNWpNrDu78rx+nUQXox/7rDZMXj2QRLdSe7rOn2pPzfi
         +jbJ/a5XutAKeLVHWn0xnmu+H/7EQo0ZxnDO3GiyB/keYn0RVTQJlQPIztnxdpt+VIqf
         INZARnuRsCAx+nXdLst8n/L/E7DlZfAr4gyU9pb6XEOfZmwgTk9MnhzXTNkbjwHWH68B
         x+LYCSRl0hoVGlENme9YabAeuLtTyW8JDkTMiT4aOaGvBJ8ScFUCi7k9OBHd1xSmIQ0H
         28hg==
X-Gm-Message-State: APjAAAXCSN1xDwf4PjGkmJAvNHrN9cUCmNAIm/djG9bL/bcPfFoHeA60
        g1n4zoL+ewXGZmZr3FAQ2DgDeg==
X-Google-Smtp-Source: APXvYqwSHTgb4vN8z+yJxmNxZpsglNgVTEuyS2yIdiGBZDefygaCQHxYo93g2XFzgfEA6Rl1wRLUyg==
X-Received: by 2002:a50:84a1:: with SMTP id 30mr10145054edq.44.1565188131065;
        Wed, 07 Aug 2019 07:28:51 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id oh24sm15018422ejb.35.2019.08.07.07.28.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 07:28:50 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 81A7010073F; Wed,  7 Aug 2019 17:28:50 +0300 (+03)
Date:   Wed, 7 Aug 2019 17:28:50 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCHv2 47/59] kvm, x86, mmu: setup MKTME keyID to spte for
 given PFN
Message-ID: <20190807142850.mjp4ctqc7wttpser@box>
References: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
 <20190731150813.26289-48-kirill.shutemov@linux.intel.com>
 <a3aee9ea-a3ce-1219-b7ff-5a1b291bffdd@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3aee9ea-a3ce-1219-b7ff-5a1b291bffdd@amd.com>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 06, 2019 at 08:26:52PM +0000, Lendacky, Thomas wrote:
> On 7/31/19 10:08 AM, Kirill A. Shutemov wrote:
> > From: Kai Huang <kai.huang@linux.intel.com>
> > 
> > Setup keyID to SPTE, which will be eventually programmed to shadow MMU
> > or EPT table, according to page's associated keyID, so that guest is
> > able to use correct keyID to access guest memory.
> > 
> > Note current shadow_me_mask doesn't suit MKTME's needs, since for MKTME
> > there's no fixed memory encryption mask, but can vary from keyID 1 to
> > maximum keyID, therefore shadow_me_mask remains 0 for MKTME.
> > 
> > Signed-off-by: Kai Huang <kai.huang@linux.intel.com>
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > ---
> >  arch/x86/kvm/mmu.c | 18 +++++++++++++++++-
> >  1 file changed, 17 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> > index 8f72526e2f68..b8742e6219f6 100644
> > --- a/arch/x86/kvm/mmu.c
> > +++ b/arch/x86/kvm/mmu.c
> > @@ -2936,6 +2936,22 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
> >  #define SET_SPTE_WRITE_PROTECTED_PT	BIT(0)
> >  #define SET_SPTE_NEED_REMOTE_TLB_FLUSH	BIT(1)
> >  
> > +static u64 get_phys_encryption_mask(kvm_pfn_t pfn)
> > +{
> > +#ifdef CONFIG_X86_INTEL_MKTME
> > +	struct page *page;
> > +
> > +	if (!pfn_valid(pfn))
> > +		return 0;
> > +
> > +	page = pfn_to_page(pfn);
> > +
> > +	return ((u64)page_keyid(page)) << mktme_keyid_shift();
> > +#else
> > +	return shadow_me_mask;
> > +#endif
> > +}
> 
> This patch breaks AMD virtualization (SVM) in general (non-SEV and SEV
> guests) when SME is active. Shouldn't this be a run time, vs build time,
> check for MKTME being active?

Thanks, I've missed this.

This fixup should help:

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 00d17bdfec0f..54931acf260e 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2947,18 +2947,17 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
 
 static u64 get_phys_encryption_mask(kvm_pfn_t pfn)
 {
-#ifdef CONFIG_X86_INTEL_MKTME
 	struct page *page;
 
+	if (!mktme_enabled())
+		return shadow_me_mask;
+
 	if (!pfn_valid(pfn))
 		return 0;
 
 	page = pfn_to_page(pfn);
 
 	return ((u64)page_keyid(page)) << mktme_keyid_shift();
-#else
-	return shadow_me_mask;
-#endif
 }
 
 static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
-- 
 Kirill A. Shutemov
