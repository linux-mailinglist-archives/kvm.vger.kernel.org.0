Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D00971C8376
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 09:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbgEGHbG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 7 May 2020 03:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725802AbgEGHbG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 03:31:06 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE34C061A10;
        Thu,  7 May 2020 00:31:06 -0700 (PDT)
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1jWayM-0002td-RD; Thu, 07 May 2020 09:29:34 +0200
Date:   Thu, 7 May 2020 09:29:34 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Babu Moger <babu.moger@amd.com>, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        x86@kernel.org, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, mchehab+samsung@kernel.org,
        changbin.du@intel.com, namit@vmware.com,
        yang.shi@linux.alibaba.com, asteinhauser@google.com,
        anshuman.khandual@arm.com, jan.kiszka@siemens.com,
        akpm@linux-foundation.org, steven.price@arm.com,
        rppt@linux.vnet.ibm.com, peterx@redhat.com,
        dan.j.williams@intel.com, arjunroy@google.com, logang@deltatee.com,
        thellstrom@vmware.com, aarcange@redhat.com, justin.he@arm.com,
        robin.murphy@arm.com, ira.weiny@intel.com, keescook@chromium.org,
        jgross@suse.com, andrew.cooper3@citrix.com,
        pawan.kumar.gupta@linux.intel.com, fenghua.yu@intel.com,
        vineela.tummalapalli@intel.com, yamada.masahiro@socionext.com,
        sam@ravnborg.org, acme@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] arch/x86: Rename config
 X86_INTEL_MEMORY_PROTECTION_KEYS to generic x86
Message-ID: <20200507072934.d5l6cpqyy54lrrla@linutronix.de>
References: <158880240546.11615.2219410169137148044.stgit@naples-babu.amd.com>
 <158880253347.11615.8499618616856685179.stgit@naples-babu.amd.com>
 <4d86b207-77af-dc5d-88a4-f092be0043f6@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4d86b207-77af-dc5d-88a4-f092be0043f6@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-05-06 15:21:29 [-0700], Dave Hansen wrote:
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 1197b5596d5a..8630b9fa06f5 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -1886,11 +1886,11 @@ config X86_UMIP
> >  	  specific cases in protected and virtual-8086 modes. Emulated
> >  	  results are dummy.
> >  
> > -config X86_INTEL_MEMORY_PROTECTION_KEYS
> > -	prompt "Intel Memory Protection Keys"
> > +config X86_MEMORY_PROTECTION_KEYS
> > +	prompt "Memory Protection Keys"
> >  	def_bool y
> >  	# Note: only available in 64-bit mode
> > -	depends on CPU_SUP_INTEL && X86_64
> > +	depends on X86_64 && (CPU_SUP_INTEL || CPU_SUP_AMD)
> >  	select ARCH_USES_HIGH_VMA_FLAGS
> >  	select ARCH_HAS_PKEYS
> >  	---help---
> 
> It's a bit of a bummer that we're going to prompt everybody doing
> oldconfig's for this new option.  But, I don't know any way for Kconfig
> to suppress it if the name is changed.  Also, I guess the def_bool=y
> means that menuconfig and olddefconfig will tend to do the right thing.

You could add a new option (X86_MEMORY_PROTECTION_KEYS) which is
def_bool X86_INTEL_MEMORY_PROTECTION_KEYS and avoiding the prompt line.
Soo it is selected based on the old option and the user isn't bother. A
few cycles later you could remove intel option and add prompt to other.
But still little work for…

> Do we *really* need to change the Kconfig name?  The text prompt, sure.
>  End users see that and having Intel in there is massively confusing.
> 
> If I have to put up with seeing 'amd64' all over my Debian package
> names, you can put up with a Kconfig name. :P

:) Right. On AMD you also use the crc32c-intel (if possible) and I
haven't seen people complain about this one.

> I'm really just wondering what the point of the churn is.

Sebastian
