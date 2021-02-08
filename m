Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B62313CC6
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 19:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235282AbhBHSJy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 13:09:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235437AbhBHSGT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 13:06:19 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3145C06178A
        for <kvm@vger.kernel.org>; Mon,  8 Feb 2021 10:04:19 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id q20so10204826pfu.8
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 10:04:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vqBTy5Z1R7u/iLq38ng3aUddH37slkPbc8QUCtAKPsQ=;
        b=FtevjA5bCw6VWdP7SFi293r0Lidhb4fwXnnngO7N3Rxtqqy8jS75FGRBfjbZlHCRvT
         lrJ/i0LieWmYgUI3jy5a44RAlCtB7lvGyHH1cHraejyIs4uyWKwou7wK+Tk3gDzsPiYI
         HTtnWN828PBmccKU2gPX284MajUXfG5+eL5HZGhoKjKy+pOlLnbuVE04Iy7tnBVm8+0o
         us7miHaWbk14aJSB46Ur8WNkG6FN8OU9vdVvEGa4CoV1QrYI+ItdOFN0FJksCqMlqOPg
         7/sTcMflMAEA/cpx7+5U+kR+XjUx7b5pnu5DO+won9Hyw/PHZeqWbZ0ydHyG9yNmx7SX
         Komw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vqBTy5Z1R7u/iLq38ng3aUddH37slkPbc8QUCtAKPsQ=;
        b=DcuqNDX/gHJKWdjVjavEcjiMyEZP3WSnxzJ6SBKYWHnLrvxWDpDr/muF/l9+fWJjpS
         B/SmFNYXvfYH9RTIX7v7mpy8P3yHDOy2xY6ARuciwx7bNI90HYNkLNeiTdRG1blR0nEh
         lLtzguh6HscPYFxayfTSMjEDmHMeWir2X6dVcBGqPx8hmjsKeV2AFWQyje4daDkKLWsl
         cEHoq7ueuFG+fz//lKFXlEYoTF2dTsoM6VTa57MRxPI82tN8QemPbARRTaDL1cBIjuJ/
         JNVjxtjnI7e5P7jwduVhPDAGJ1YzkcTpU0GdycUYoaF0KF8vwqHqckL6tww54D8bm/5L
         u/GA==
X-Gm-Message-State: AOAM5320v4qHZ3jhndXHPjvVZ2eHdsi0JXXD1iIXmtPK2XmwBFiMsGNX
        tbRZLxnTHBaQtKMTZ9g8Er+vLA==
X-Google-Smtp-Source: ABdhPJxFrze8G+mo95UHCssyAzYuK7lSxLIPCuPvweYya2uspvD8XPQxNcyQSbIoyTzalhhNX76T4Q==
X-Received: by 2002:a65:624a:: with SMTP id q10mr18192825pgv.2.1612807459130;
        Mon, 08 Feb 2021 10:04:19 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e4db:abc1:a5c0:9dbc])
        by smtp.gmail.com with ESMTPSA id v2sm5501183pjr.23.2021.02.08.10.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 10:04:18 -0800 (PST)
Date:   Mon, 8 Feb 2021 10:04:11 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jing Liu <jing2.liu@linux.intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jing2.liu@intel.com
Subject: Re: [PATCH RFC 3/7] kvm: x86: XSAVE state and XFD MSRs context switch
Message-ID: <YCF9GztNd18t1zk/@google.com>
References: <20210207154256.52850-1-jing2.liu@linux.intel.com>
 <20210207154256.52850-4-jing2.liu@linux.intel.com>
 <ae5b0195-b04f-8eef-9e0d-2a46c761d2d5@redhat.com>
 <YCF1d0F0AqPazYqC@google.com>
 <77b27707-721a-5c6a-c00d-e1768da55c64@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77b27707-721a-5c6a-c00d-e1768da55c64@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 08, 2021, Paolo Bonzini wrote:
> On 08/02/21 18:31, Sean Christopherson wrote:
> > On Mon, Feb 08, 2021, Paolo Bonzini wrote:
> > > On 07/02/21 16:42, Jing Liu wrote:
> > > > In KVM, "guest_fpu" serves for any guest task working on this vcpu
> > > > during vmexit and vmenter. We provide a pre-allocated guest_fpu space
> > > > and entire "guest_fpu.state_mask" to avoid each dynamic features
> > > > detection on each vcpu task. Meanwhile, to ensure correctly
> > > > xsaves/xrstors guest state, set IA32_XFD as zero during vmexit and
> > > > vmenter.
> > > 
> > > Most guests will not need the whole xstate feature set.  So perhaps you
> > > could set XFD to the host value | the guest value, trap #NM if the host XFD
> > > is zero, and possibly reflect the exception to the guest's XFD and XFD_ERR.
> > > 
> > > In addition, loading the guest XFD MSRs should use the MSR autoload feature
> > > (add_atomic_switch_msr).
> > 
> > Why do you say that?  I would strongly prefer to use the load lists only if they
> > are absolutely necessary.  I don't think that's the case here, as I can't
> > imagine accessing FPU state in NMI context is allowed, at least not without a
> > big pile of save/restore code.
> 
> I was thinking more of the added vmentry/vmexit overhead due to
> xfd_guest_enter xfd_guest_exit.
> 
> That said, the case where we saw MSR autoload as faster involved EFER, and
> we decided that it was due to TLB flushes (commit f6577a5fa15d, "x86, kvm,
> vmx: Always use LOAD_IA32_EFER if available", 2014-11-12). Do you know if
> RDMSR/WRMSR is always slower than MSR autoload?

RDMSR/WRMSR may be marginally slower, but only because the autoload stuff avoids
serializing the pipeline after every MSR.  The autoload paths are effectively
just wrappers around the WRMSR ucode, plus some extra VM-Enter specific checks,
as ucode needs to perform all the normal fault checks on the index and value.

On the flip side, if the load lists are dynamically constructed, I suspect the
code overhead of walking the lists negates any advantages of the load lists.

TL;DR: it likely depends on the exact use case.  My primary objection to using
the load lists is that people tend to assume they are more performant that raw
RDMSR/WRMSR, and so aren't as careful/thoughtful as they should be about adding
MSRs to the save/restore paths.

Note, the dedicated VMCS fields, e.g. EFER and SYSENTER, are 1-2 orders of
magnitude faster than raw RDMSR/WRMSR or the load lists, as they obviously have
dedicated handling in VM-Enter ucode.
