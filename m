Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE12930E131
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 18:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbhBCRhN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 12:37:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbhBCRhL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 12:37:11 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC28C0613ED
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 09:36:31 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id v19so186938pgj.12
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 09:36:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oSCtPYvB36c/3FOI/pxSNY8EAQ3LNUiqVCd8tQQiPLM=;
        b=KhgGhrQk+3cC//ayOQ3/op7AdpEY30jmoaslxHSRlYdwS3DQ/JGHFhPdb9mEfZBM3K
         BEX6Cqskgo+bSNo9x1+EutpSyeCaJOzxe672z9FFmXCZF3330254BTSXAEUKEF44QJYa
         wzTHylKN4kZE/nCsOT7x7bAc6bBkGKV3MlHhoCf1PPAsVXf8W3/Onaqc1Uo/RNNyqm5y
         qL3lF25/dpM88jMnizkrL+8V3gmbQafUoAyyOlEtW4ulJMsBKFIq5NsfnGddFpq/KaGM
         eaxcabUtf9ZUxlSN49vMNVY2VmteYbkpcnGWzuUrhLnd3KT4/X263pmMxRQlJQduWPZn
         q+6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oSCtPYvB36c/3FOI/pxSNY8EAQ3LNUiqVCd8tQQiPLM=;
        b=mfQ8/D970v+Hsmn54yYB/Isi0tocCoh2Ru3MmakdbCvklkNRXbZctulroG9FUhcAbB
         dM5j56sMZUf2UOodO5oRqmMOM/r5NtY8VOc/YxRLjibaJ8YdLFuIolBjb/ijLyh75jfj
         zXE61fZ/q+C6ZT+bDb7MG5pSeOu5HhCneewaNVk5HEXFPvR7a7k59s3O0CkhrdwMOkok
         07FO+jeLRJUm76uuOEYmVoyIRPdGC9Lc+tLZEPYT4gDV5sLS89b7OzEjD9Gf5QCLWOw2
         /g9RV42NLWhk2viRYd7DkOoDTU2jdsGsRlcomCqdoG+wX/nZoRn4dygEudqHoXQR+tKn
         7n4A==
X-Gm-Message-State: AOAM531ZSDCWABctJy7vLv4LrfFdkvHc+ZxYc67VhaY5CpNS0/AFaNM3
        mns5Ak32OAvAjH960Bt2+i81Lg==
X-Google-Smtp-Source: ABdhPJzsMatZaLu/NQVLK6WFvASbdeHEpy0+n8eRwulpfnE3JpbAqDmFbOgU3KJO1DaxmZipUa9Tiw==
X-Received: by 2002:a63:f447:: with SMTP id p7mr4664831pgk.243.1612373790529;
        Wed, 03 Feb 2021 09:36:30 -0800 (PST)
Received: from google.com ([2620:15c:f:10:a9a0:e924:d161:b6cb])
        by smtp.gmail.com with ESMTPSA id a188sm3056358pfb.108.2021.02.03.09.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 09:36:29 -0800 (PST)
Date:   Wed, 3 Feb 2021 09:36:23 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "luto@kernel.org" <luto@kernel.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "b.thiel@posteo.de" <b.thiel@posteo.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "Huang, Haitao" <haitao.huang@intel.com>
Subject: Re: [RFC PATCH v3 00/27] KVM SGX virtualization support
Message-ID: <YBrfF0XQvzQf9PhR@google.com>
References: <cover.1611634586.git.kai.huang@intel.com>
 <4b4b9ed1d7756e8bccf548fc41d05c7dd8367b33.camel@intel.com>
 <YBnTPmbPCAUS6XNl@google.com>
 <99135352-8e10-fe81-f0dc-8d552d73e3d3@intel.com>
 <YBnmow4e8WUkRl2H@google.com>
 <f50ac476-71f2-60d4-5008-672365f4d554@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f50ac476-71f2-60d4-5008-672365f4d554@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 03, 2021, Dave Hansen wrote:
> On 2/2/21 3:56 PM, Sean Christopherson wrote:
> >> I seem to remember much stronger language in the SDM about this.  I've
> >> always thought of SGX as a big unrecoverable machine-check party waiting
> >> to happen.
> >>
> >> I'll ask around internally at Intel and see what folks say.  Basically,
> >> should we be afraid of a big bad EPC access?
> > If bad accesses to the EPC can cause machine checks, then EPC should never be
> > mapped into userspace, i.e. the SGX driver should never have been merged.
> 
> The SDM doesn't define the behavior well enough.  I'll try to get that
> fixed.
> 
> But, there is some documentation of the abort page semantics:
> 
> > https://download.01.org/intel-sgx/sgx-linux/2.10/docs/Intel_SGX_Developer_Reference_Linux_2.10_Open_Source.pdf
> 
> Basically, writes get dropped and reads get all 1's on all the
> implementations in the wild.  I actually would have much rather gotten a
> fault, but oh well.
> 
> It sounds like we need to at least modify KVM to make sure not to map
> and access EPC addresses.

Why?  KVM will read garbage, but KVM needs to be careful with the data it reads,
irrespective of SGX, because the data is user/guest controlled even in the happy
case.

I'm not at all opposed to preventing KVM from accessing EPC, but I really don't
want to add a special check in KVM to avoid reading EPC.  KVM generally isn't
aware of physical backings, and the relevant KVM code is shared between all
architectures.

> We might even want to add some VM_WARN_ON()s in the code that creates kernel
> mappings to catch these mappings if they happen anywhere else.

One thought for handling this would be to extend __ioremap_check_other() to flag
EPC in some way, and then disallow memremap() to EPC.  A clever way to do that
without disallowing SGX's initial memremap() would be to tap into SGX's
sgx_epc_sections array, as the per-section check would activate only after each
section is initialized/map by SGX.

Disallowing memremap(), without warning, would address the KVM flow (the
memremap() in __kvm_map_gfn()) without forcing KVM to explicitly check for EPC.

E.g. something like:

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index c519fc5f6948..f263f3554f27 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -26,6 +26,19 @@ static LIST_HEAD(sgx_active_page_list);

 static DEFINE_SPINLOCK(sgx_reclaimer_lock);

+bool is_sgx_epc(resource_size_t addr, unsigned long size)
+{
+       resource_size_t end = addr + size - 1;
+       int i;
+
+       for (i = 0; i < sgx_nr_epc_sections; i++) {
+               if (<check for overlap with sgx_epc_sections[i])
+                       return true;
+       }
+
+       return false;
+}
+
 /*
  * Reset dirty EPC pages to uninitialized state. Laundry can be left with SECS
  * pages whose child pages blocked EREMOVE.
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 9e5ccc56f8e0..145fc6fc6bc5 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -34,6 +34,7 @@
  */
 struct ioremap_desc {
        unsigned int flags;
+       bool sgx_epc;
 };

 /*
@@ -110,8 +111,14 @@ static unsigned int __ioremap_check_encrypted(struct resource *res)
  * The EFI runtime services data area is not covered by walk_mem_res(), but must
  * be mapped encrypted when SEV is active.
  */
-static void __ioremap_check_other(resource_size_t addr, struct ioremap_desc *desc)
+static void __ioremap_check_other(resource_size_t addr, unsigned long size,
+                                 struct ioremap_desc *desc)
 {
+       if (sgx_is_epc(addr, size)) {
+               desc->sgx_epc = true;
+               return;
+       }
+
        if (!sev_active())
                return;

@@ -155,7 +162,7 @@ static void __ioremap_check_mem(resource_size_t addr, unsigned long size,

        walk_mem_res(start, end, desc, __ioremap_collect_map_flags);

-       __ioremap_check_other(addr, desc);
+       __ioremap_check_other(addr, size, desc);
 }

 /*
@@ -210,6 +217,13 @@ __ioremap_caller(resource_size_t phys_addr, unsigned long size,
                return NULL;
        }

+       /*
+        * Don't allow mapping SGX EPC, it's not accessible via normal reads
+        * and writes.
+        */
+       if (io_desc.epc)
+               return NULL;
+
        /*
         * Mappings have to be page-aligned
         */

