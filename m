Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9AE6C5255
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 18:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjCVRVv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 13:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjCVRVt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 13:21:49 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559A61DBBC
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 10:21:27 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5417f156cb9so194924897b3.8
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 10:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679505683;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=76O02WUE0g6eJOczr8cqfk1ma9BWKFaFBJ26R68A8wg=;
        b=k7inNZWz7vd/OQCF1Z4fDIHKAdlxFRy3qWK9TuqXeo+KhaokHQVARHM+S0ZTtZIhyU
         mSv7IAVJKzONelUwXnP4lJUL/f0+mV97k/0f7n2vsjSp1vQ+2cOW+44Hg58HcV/Uw3B5
         N17vxLXKUyY6/0136SUIqFRqIp6bNmlAQaXKZ7mwnhsAJ0bpWsS3xq2H9HceSuHje4zz
         EknGjj2qy26yf+8wjNxrENhzST3sXkeBdNr4ycaqXHURIjUzYatoGy4uC8H9pnrdGF9+
         U14MkM6znsON/GpzzItOmbAIx+dVUXM1uNxkKThrCjpMtqIJ7RImwwkxkXFWjJCnHv/+
         7xEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679505683;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=76O02WUE0g6eJOczr8cqfk1ma9BWKFaFBJ26R68A8wg=;
        b=03odZOsAam0WxLj61QLVyWGS915OIJpa4uV/4CpBTdeva5MyyymWU88XSJALUP9XAv
         gxmBenoRqWwYDmkCbilV1PZ55AP4F+/I0i22kUvoCrtetvO5bnMfOHeX94Kj+gvw1U98
         KaZecQMvRlbHiJivlhV+a+i56+aHPOFfnRM7dEbu08gfoyGl4nkT33tZA4y9iDivPah5
         jSjagZa0fOxDPbbQlRN24c60kgckXrL638kDSxve6C1V5Zf36bPPY2sKM69lh2kXaniR
         ysutPYBq6Sq7CpzcGSuKXWR2Z/nnHkBo7NJJyMHC01IOdyDH0Wv35eVa853p96A6DgAF
         fSJA==
X-Gm-Message-State: AAQBX9did3QcMBdhrsmZcatdGItU+NMM8MSZ+6o4kQbaiBSOtsWEL7uA
        80M2msFCuylVFH3gzOC92odgEwPXEM4=
X-Google-Smtp-Source: AKy350bJEJhNLbUTpql+V2P2dh5ZRNTp0zjzWhBiiWZxxRPIx42ttF/hOxoPB3QRlQqpRBYU47o9eG5UvMM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:a782:0:b0:541:a17f:c77d with SMTP id
 e124-20020a81a782000000b00541a17fc77dmr307985ywh.10.1679505683599; Wed, 22
 Mar 2023 10:21:23 -0700 (PDT)
Date:   Wed, 22 Mar 2023 10:21:22 -0700
In-Reply-To: <20230322045824.22970-3-binbin.wu@linux.intel.com>
Mime-Version: 1.0
References: <20230322045824.22970-1-binbin.wu@linux.intel.com> <20230322045824.22970-3-binbin.wu@linux.intel.com>
Message-ID: <ZBs5Eh0LrN/TMErj@google.com>
Subject: Re: [PATCH 2/4] KVM: x86: Replace kvm_read_{cr0,cr4}_bits() with kvm_is_{cr0,cr4}_bit_set()
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, robert.hu@linux.intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 22, 2023, Binbin Wu wrote:
> Replace kvm_read_{cr0,cr4}_bits() with kvm_is_{cr0,cr4}_bit_set() when only
> one bit is checked and bool is preferred as return value type.
> Also change the return value type from int to bool of is_pae(), is_pse() and
> is_paging().

I'm going to squash the obvious/direct changes with the introduction of the helpers,
and isolate is_{pae,pse,paging}() as those are more risky due to the multiple
casts (ulong=>int=>bool), and because the end usage isn't visible in the patch.

Case in point, there is a benign but in svm_set_cr0() that would be silently
fixed by converting is_paging() to return a bool:

	bool old_paging = is_paging(vcpu);

	...

	vcpu->arch.cr0 = cr0;

	if (!npt_enabled) {
		hcr0 |= X86_CR0_PG | X86_CR0_WP;
		if (old_paging != is_paging(vcpu))

The "old_paging != is_paging(vcpu)" compares a bool (1/0) against an int that
was an unsigned long (X86_CR0_PG/0), i.e. gets a false positive when paging is
enabled.

I'll post a fix and slot it in before this patch, both so that there's no silent
fixes and so that this changelog can reference the commit.

> ---
>  arch/x86/kvm/cpuid.c      |  4 ++--
>  arch/x86/kvm/mmu.h        |  2 +-
>  arch/x86/kvm/vmx/nested.c |  2 +-
>  arch/x86/kvm/vmx/vmx.c    |  2 +-
>  arch/x86/kvm/x86.c        | 20 ++++++++++----------
>  arch/x86/kvm/x86.h        | 16 ++++++++--------

This misses a few conversions in kvm_pmu_rdpmc(), I'll fix those when applying too.
