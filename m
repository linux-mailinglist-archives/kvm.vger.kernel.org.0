Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA7076F670
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 02:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbjHDAQM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 20:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjHDAQJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 20:16:09 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864CA3AA9
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 17:16:08 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5646868b9e7so939865a12.3
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 17:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691108168; x=1691712968;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=agmPysnaJArBgaIxmD2TyQicW110PYrTwSQYjf3MXfk=;
        b=BpNXL6AGfNZFXydbfsISPAovkVFJghYqAHc3PPnvqg0WTatFjh0NJai3FrgcQbu6SV
         1QJ5PkJOIORcR46z1stEc6IPk42rNyPv/3tMZqhlET6y5ir6oFuLczDVv9BBj9Illkvg
         v4rvERlnslrAxuC1xfXljQVLx5ibZmSRXUk6WEvj0QROXHq16X3X1TGus/EdXu4UpZv/
         0rOkcj1+nIYfskqD5d7G+4siDgjfOiOMJ6QOzpOmZBrS8/F3+5+PE9JK7z/IYqcOisFk
         rINJ5Uf8rTw8DIPxhb0/INvEQvJF4l5lCMXl2hdk9CfsJsD24HBV6iL/6bCEmVBN8FFR
         TBJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691108168; x=1691712968;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=agmPysnaJArBgaIxmD2TyQicW110PYrTwSQYjf3MXfk=;
        b=Xvvrr7gC1hkA7HdqDNI+RqWs4PdCJj47mtzNqb82wpY8BtwWgjBs1qOIMYvQo2Litv
         +/Xu343Q4EERJ58Wr4b2KSGUCLA2IqnMP78Uc3e3DlrXlr+3J/ZryBq5VdbGOKHNXN9n
         lYXLz0uSp12BxRD/34ONKJPqeGtBBGDP23jl1vVQzokob4Va8Z5xthgkoNWCOEQVFE8Q
         Qrra9kixkJbiiUlwwT9vws2FMPEptTmJZf7SbSFmxYbr/E+ej56tNfb190TIt4+zhrAn
         oZYRyhXPc1ix9Bo+Gkfj5X4By9Kkphi6vYCTkYVSvO5/2YWBijHgyQaHsROlA3SdfWqM
         fnEg==
X-Gm-Message-State: AOJu0YyRikUx0tqj04+uLojY6UtBKez13Na5GFq7rhcRw+zqnBpFGc8C
        NHXcEN5i82FV40aY+l5EL2M0z7mU9p8=
X-Google-Smtp-Source: AGHT+IFRpf5OgL0zapFGlyxuhg8durZAk3I2JSW968+7xT720t8hqSWIEk7o5kImdCPLem/CxOeqst3ilhk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2284:b0:1b5:2b14:5f2c with SMTP id
 b4-20020a170903228400b001b52b145f2cmr1040plh.4.1691108167942; Thu, 03 Aug
 2023 17:16:07 -0700 (PDT)
Date:   Thu, 3 Aug 2023 17:16:06 -0700
In-Reply-To: <20230728071857.29991-1-metikaya@amazon.co.uk>
Mime-Version: 1.0
References: <20230728071857.29991-1-metikaya@amazon.co.uk>
Message-ID: <ZMxDRg6gWsVLeYFL@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86/access: Use HVMOP_flush_tlbs hypercall
 instead of invlpg() for Xen
From:   Sean Christopherson <seanjc@google.com>
To:     Metin Kaya <metikaya@amazon.co.uk>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, dwmw@amazon.co.uk
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

*sigh*

First off, thanks for the test, much appreciated.

However, the purpose of adding test code is to be able to actually run the damn
test.  Yeah, I got there in the end by hacking the QEMU command line generated
by KUT, but holy moly I should not have had to do that.  E.g. swapping out
"-machine accel=kvm" for "-accel kvm" just to be able to enable xen-version=0x4000a
was not a detail I wanted to find out on my own.

And the real kicker: after upgrading QEMU and figuring out the right command line,
the test fails.  Specifically, it hangs in the focused check_smep_andnot_wp() test.

My host is a HSW.  I haven't tried another host.  AFAICT, the test unexpectedly
ends up at RIP 0x0 and loops indefinitely on a page fault (the test has a nop
page fault handler so it doesn't die).

E.g. with EPT disabling so that KVM intercepts #PF:

stable-4247    [007] .....   456.192867: kvm_page_fault: vcpu 0 rip 0x0 address 0x0000000000000000 error_code 0x10
stable-4247    [007] .....   456.192868: kvm_inj_exception: #PF (0x11)
stable-4247    [007] d....   456.192868: kvm_entry: vcpu 0, rip 0x0


On Fri, Jul 28, 2023, Metin Kaya wrote:
> @@ -250,12 +251,90 @@ static void set_cr0_wp(int wp)
>  	}
>  }
>  
> +uint8_t *hypercall_page;
> +
> +#define __HYPERVISOR_hvm_op	34
> +#define HVMOP_flush_tlbs	5
> +
> +static inline int do_hvm_op_flush_tlbs(void)
> +{
> +	long res = 0, _a1 = (long)(HVMOP_flush_tlbs), _a2 = (long)(NULL);
> +
> +	asm volatile ("call *%[offset]"
> +#if defined(__x86_64__)
> +		      : "=a" (res), "+D" (_a1), "+S" (_a2)
> +#else
> +		      : "=a" (res), "+b" (_a1), "+c" (_a2)
> +#endif
> +		      : [offset] "r" (hypercall_page + (__HYPERVISOR_hvm_op * 32))
> +		      : "memory");

Can this be easily extracted to a generic-ish xen_hypercall() helper?  I.e. make
the inline assembly reusable.

> +
> +	if (res)
> +		printf("hvm_op/HVMOP_flush_tlbs failed: %ld.", res);
> +
> +	return (int)res;
> +}
> +
> +#define XEN_CPUID_FIRST_LEAF    0x40000000
> +#define XEN_CPUID_SIGNATURE_EBX 0x566e6558 /* "XenV" */
> +#define XEN_CPUID_SIGNATURE_ECX 0x65584d4d /* "MMXe" */
> +#define XEN_CPUID_SIGNATURE_EDX 0x4d4d566e /* "nVMM" */
> +
> +static void init_hypercalls(void)
> +{
> +	struct cpuid c;
> +	u32 base;
> +	bool found = false;
> +
> +	for (base = XEN_CPUID_FIRST_LEAF; base < XEN_CPUID_FIRST_LEAF + 0x10000;
> +			base += 0x100) {
> +		c = cpuid(base);
> +		if ((c.b == XEN_CPUID_SIGNATURE_EBX) &&
> +		    (c.c == XEN_CPUID_SIGNATURE_ECX) &&
> +		    (c.d == XEN_CPUID_SIGNATURE_EDX) &&
> +		    ((c.a - base) >= 2)) {
> +			found = true;
> +			break;
> +		}
> +	}
> +	if (!found) {
> +		printf("Using native invlpg instruction\n");
> +		return;
> +	}
> +
> +	hypercall_page = alloc_pages_flags(0, AREA_ANY | FLAG_DONTZERO);
> +	if (!hypercall_page)
> +		report_abort("failed to allocate hypercall page");
> +
> +	memset(hypercall_page, 0xc3, PAGE_SIZE);
> +
> +	c = cpuid(base + 2);
> +	wrmsr(c.b, (u64)hypercall_page);
> +	barrier();
> +
> +	if (hypercall_page[0] == 0xc3)
> +		report_abort("Hypercall page not initialised correctly\n");
> +
> +	/*
> +	 * Fall back to invlpg instruction if HVMOP_flush_tlbs hypercall is
> +	 * unsupported.
> +	 */
> +	if (do_hvm_op_flush_tlbs()) {
> +		printf("Using native invlpg instruction\n");
> +		free_page(hypercall_page);
> +		hypercall_page = NULL;
> +		return;
> +	}
> +
> +	printf("Using Xen HVMOP_flush_tlbs hypercall\n");
> +}

All of the Xen stuff belongs in "library" code, e.g. add xen.{c,h} and prefix
the public functions with xen_.  And drop the HVMOP_flush_tlbs probing from
xen_init_hypercalls(), i.e. make it a generic helper.

And I think it also makes sense to have a separate testcase for the Xen hypercall,
e.g. so that we test both cases when Xen is present, eliminate flakiness from Xen
setup failing, make it easy to run or skip the Xen test, make it easy to see which
flavor is running (checking the log is annoying), etc.

That way you can have x86/access_test.c's main() pivot on a command line param
and skip the test if do_hvm_op_flush_tlbs() fails (though I would call it something
like xen_flush_tlbs()).

>  static void clear_user_mask(pt_element_t *ptep, int level, unsigned long virt)
>  {
>  	*ptep &= ~PT_USER_MASK;
>  
>  	/* Flush to avoid spurious #PF */
> -	invlpg((void*)virt);
> +	hypercall_page ? do_hvm_op_flush_tlbs() : invlpg((void *)virt);

And rather than hypercall_page, end up with "bool use_xen_pv_tlb_flush" or so.
