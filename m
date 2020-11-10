Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABCB92AD2ED
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 10:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730234AbgKJJ4Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 04:56:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbgKJJ4Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 04:56:24 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C81AC0613CF;
        Tue, 10 Nov 2020 01:56:24 -0800 (PST)
Received: from nazgul.tnic (unknown [78.130.214.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7DC091EC036C;
        Tue, 10 Nov 2020 10:56:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1605002181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=O9Bf9QLEbMBCh3z4FMbn5eGBAmMtLb75UrKmj7Nq7SI=;
        b=m+RDHKP/Ex24UiFTamOj49F4H2/hL8AXpVG75G8sd3WsutOCUJ0Mx2NvCwySCSJjS4Gbv+
        jF6ih5lAXSJYigPn7StVpu05cXsuuNplokLLvLoheG2aKh6nLn655620aoSzj7rr4LSXcU
        hiCX2L5O7hP3q1FNM53MDHKW5G440tM=
Date:   Tue, 10 Nov 2020 10:56:15 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Luck, Tony" <tony.luck@intel.com>,
        Jim Mattson <jmattson@google.com>, Qian Cai <cai@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
        <linux-tip-commits@vger.kernel.org>, x86 <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] x86/mce: Check for hypervisor before enabling additional
 error logging
Message-ID: <20201110095615.GB9450@nazgul.tnic>
References: <20201030190807.GA13884@agluck-desk2.amr.corp.intel.com>
 <160431588828.397.16468104725047768957.tip-bot2@tip-bot2>
 <3f863634cd75824907e8ccf8164548c2ef036f20.camel@redhat.com>
 <bfc274fc27724ea39ecac1e7ac834ed8@intel.com>
 <CALMp9eTFaiYkTnVe8xKzg40E4nZ3rAOii0O06bTy0+oLNjyKhA@mail.gmail.com>
 <a22b5468e1c94906b72c4d8bc83c0f64@intel.com>
 <20201109232402.GA25492@agluck-desk2.amr.corp.intel.com>
 <20201110063151.GB7290@nazgul.tnic>
 <094c2395-b1b3-d908-657c-9bd4144e40ac@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <094c2395-b1b3-d908-657c-9bd4144e40ac@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 10, 2020 at 09:50:43AM +0100, Paolo Bonzini wrote:
> 1) ignore_msrs _cannot_ be on by default.  You cannot know in advance that
> for all non-architectural MSRs it's okay for them to read as zero and eat
> writes.  For some non-architectural MSR which never reads as zero on real
> hardware, who knows that there isn't some code using the contents of the MSR
> as a divisor, and causing a division by zero exception with ignore_msrs=1?

So if you're emulating a certain type of hardware - say a certain CPU
model - then what are you saying? That you're emulating it but not
really all of it, just some bits?

Because this is what happens - the kernel checks that it runs on a
certain CPU type and this tells it that those MSRs are there. But then
comes virt and throws all assumptions out.

So if it emulates a CPU model and the kernel tries to access those MSRs,
then the HV should ignore those MSR accesses if it doesn't know about
them. Why should the kernel change everytime some tool or virtualization
has shortcomings?

> 2) it's not just KVM.  _Any_ hypervisor is bound to have this issue for some
> non-architectural MSRs.  KVM just gets the flak because Linux CI
> environments (for obvious reasons) use it more than they use Hyper-V or ESXi
> or VirtualBox.

It's not flak - I'm trying to find a solution which is workable for
both. The kernel is not at fault here.

> 3) because of (1) and (2), the solution is very simple.  If the MSR is
> architectural, its absence is a KVM bug and we'll fix it in all stable
> versions.  If the MSR is not architectural (and 17Fh isn't; not only it's
> not mentioned in the SDM,

It is mentioned in the SDM.

> even Google is failing me), never ever assume that the CPUID
> family/model/stepping implies a given MSR is there, and just use
> rdmsr_safe/wrmsr_safe.

Yes, we don't have a choice, as always. ;-\

But maybe we should have a choice and maybe qemu/kvm should have a way
to ignore certain MSRs for certain CPU types, regardless of them being
architectural or not.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
