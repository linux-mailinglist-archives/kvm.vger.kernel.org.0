Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35C3498857
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 19:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235753AbiAXS3p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 13:29:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235727AbiAXS3e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 13:29:34 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BE3C06173D
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 10:29:34 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id h20-20020a17090adb9400b001b518bf99ffso13987907pjv.1
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 10:29:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+ojo5vmZmAEo5D+AXsO6f2F4MVZII2JMeKhkJKY+E6Y=;
        b=sZ/ZUta5MpfLpdkUZyqOneo8PaD1DPbdJDOHIR/2i/K9yedhPFgDzeKWR4hOn8sp6Z
         J30KLhdtkNmhbgTBAPhhKia86hjLWOJkS7wzwYjy3RCb9tWWEYefbL56QfcYloyyBN0G
         BvhWIa1BCkCed1LuiUZCH4kQrz4UlJm/8FW+SiMJ1fEo7UK4BYU94Qyjoi5LFan91fhA
         U38vrhOJ3XSIJmXwaJsyH2ShcX6u+iiqhkr8wROu9VhE195pVWhQBKNjMNiL7krAIaSR
         2vXCrdQG4gvOWuP3hUQ2VH9D+qAthAsY5FmC7gR8Mlfuz758zOF5M2RPHIJBG/gmqyDn
         QZtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+ojo5vmZmAEo5D+AXsO6f2F4MVZII2JMeKhkJKY+E6Y=;
        b=1OLAfuS4Sn449JG9TujqRrEj1bv8Yg8TncH10tTgwYNxSJTdGQOHB7fFIPuACYymUJ
         UxhSyOC/r5h7wkYqNqjuxfSHWMsNLNf91B1u1IxZSKWAXnh1PkMpJGMoQ6jPH3Z5ZNBu
         7Tfu15JDikU0ERYmx5M3ZbvZh3DcS/Xwb59o9u8psIdei9ly9JIxbNkIrXRGi0lgL2ao
         E5ljILouWel/bgno2v/5e/XiHtdLCCHH27/ILatK3RIPgEEnQE7Rs86BJPjLe5Jj87Y4
         9M8ja0Funh1Cv9Mhp1sjz50XuJpOickjqOAaq+HDJthiDvWn87HhWvp6UJBwTojeBOXD
         tJKw==
X-Gm-Message-State: AOAM533H/MCAYU3Guvqg+ivA+9JoJk+chs8sWSnN3jVPgW0OO7zzNQG7
        uSt3oQQxaQFAQToYs/ddSKor72iG4/W+dA==
X-Google-Smtp-Source: ABdhPJwZWYuoD5Ra/J2WD0r1/BxFIRZRvCa33Na5W6BqnRCs7NShFC/ruEiMcLu9HuoqqQdS5QfBPQ==
X-Received: by 2002:a17:90a:9b0e:: with SMTP id f14mr3121940pjp.205.1643048973786;
        Mon, 24 Jan 2022 10:29:33 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p18sm18491086pfh.98.2022.01.24.10.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 10:29:33 -0800 (PST)
Date:   Mon, 24 Jan 2022 18:29:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com
Subject: Re: [PATCH RESEND] KVM: x86/mmu: fix UAF in
 paging_update_accessed_dirty_bits
Message-ID: <Ye7wCbRpcbU2G4qH@google.com>
References: <20220124172633.103323-1-tadeusz.struk@linaro.org>
 <6fd96538-b767-41e8-0cca-5b9be1dbb1c9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6fd96538-b767-41e8-0cca-5b9be1dbb1c9@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 24, 2022, Paolo Bonzini wrote:
> On 1/24/22 18:26, Tadeusz Struk wrote:
> > Syzbot reported an use-after-free bug in update_accessed_dirty_bits().
> > Fix this by checking if the memremap'ed pointer is still valid.
> 
> access_ok only checks that the pointer is in the userspace range.  Is this
> correct?  And if so, what are the exact circumstances in which access_ok
> returns a non-NULL but also non-userspace address?

I "objected" to this patch in its initial posting[*].  AFAICT adding access_ok()
is just masking a more egregious bug where interpretation of vm_pgoff as a PFN
base is flat out wrong except for select backing stores that use VM_PFNMAP.  In
other words, the vm_pgoff hack works for the /dev/mem use case, but it is wrong
in general.

[*] https://lore.kernel.org/all/Ybp0naX%2FZTG9FNEa@google.com
> 
> Thanks,
> 
> Paolo
> 
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Sean Christopherson <seanjc@google.com>
> > Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> > Cc: Wanpeng Li <wanpengli@tencent.com>
> > Cc: Jim Mattson <jmattson@google.com>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > Cc: x86@kernel.org
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: kvm@vger.kernel.org
> > Cc: <stable@vger.kernel.org>
> > Fixes: bd53cb35a3e9 ("X86/KVM: Handle PFNs outside of kernel reach when touching GPTEs")
> > Link: https://syzkaller.appspot.com/bug?id=6cb6102a0a7b0c52060753dd62d070a1d1e71347
> > Reported-by: syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com
> > Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
> > ---
> >   arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> > index 5b5bdac97c7b..d25b72d7b1b1 100644
> > --- a/arch/x86/kvm/mmu/paging_tmpl.h
> > +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> > @@ -174,7 +174,7 @@ static int FNAME(cmpxchg_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> >   		pfn = ((vaddr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
> >   		paddr = pfn << PAGE_SHIFT;
> >   		table = memremap(paddr, PAGE_SIZE, MEMREMAP_WB);
> > -		if (!table) {
> > +		if (!table || !access_ok(table, PAGE_SIZE)) {
> >   			mmap_read_unlock(current->mm);
> >   			return -EFAULT;
> >   		}
> 
