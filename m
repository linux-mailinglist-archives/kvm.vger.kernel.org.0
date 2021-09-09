Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33502405E01
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 22:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345323AbhIIU3Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 16:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345192AbhIIU3Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 16:29:24 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F091C061574
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 13:28:15 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id w6so1860951pll.3
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 13:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KkIQUN6UVWVDGVs7gQUvenivKjOnMibWM6lN26FSefU=;
        b=FVbJMuxsPdMboW3fGRpeknq9uQRgiNFYMkfTDCp+yIJU/r8SnfixFRLOMHCuS02TXV
         RwGohEECz7j1XeRtYg7gQzlcG+vLV6rsHNncc7O4uYVacKrMziWXHeyXi3ToHSI5Krci
         dAtD/keu37A2un94zex2UJJKhbPBH+ZA+1B3gpOkZmfN9W4RivrlV4R9/tQ/9cnZUrgu
         RzQYH2dMHu7mQiJ40p9ZTab+fVOUV0+TFBglNS4NUUQKTHkf9HLIB/mCNlTcORWAPzSS
         K/4cGRMB01MOZSLT6KTLNPsQp2b002EpBhgBufLFsJW1FvkHgofIBfja7U+61OoYFw47
         vXng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KkIQUN6UVWVDGVs7gQUvenivKjOnMibWM6lN26FSefU=;
        b=NVnOQV4LMco+7oYP5d9e6lNFZzr6POb8/Ab+jKg1im30+UGaRynxqcViU72hfSaB0o
         cD9y7O0nxwmJDMEE7iIZYTaZnjWmqtGPjHa8XoeQloJyfqrQR/X24M57zh8QSGDqGdbs
         G0Wf+I7Bv0efunTCfDvoQuB/Nj9as1JfBw82ofZ2YBMgHSAv+eC5ReD17X30XDbLAiiG
         7cXtUnKZnk9Hc/eqonbMUJXw7pRo+dIoZvCeZgHbbXaHXaC8Z7Wp116S6/TJOIMhxBMQ
         CgWefCfN+Grad/9wJ5LTKiEBWbmUXAlUkrhCGnu7sOkANqJhQj8uiEt0txkroNg1OBqc
         qqTg==
X-Gm-Message-State: AOAM530zGyOlD7svXodmo7zCV9SdzcHEgU3xTlIpmfDWds8itjRlt/1b
        Qbji3v8XYN+omXyExCe36yh6uQ==
X-Google-Smtp-Source: ABdhPJyAc4CRr9tF0y4feLojYbdHTKlOemQgA2iiZMpEO+mvtfr+51OjqPfvtnvGWSxrmgXGK89LBw==
X-Received: by 2002:a17:90a:428e:: with SMTP id p14mr5632154pjg.92.1631219294432;
        Thu, 09 Sep 2021 13:28:14 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b4sm3124696pga.69.2021.09.09.13.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 13:28:14 -0700 (PDT)
Date:   Thu, 9 Sep 2021 20:28:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Juergen Gross <jgross@suse.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, ehabkost@redhat.com,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v2 5/6] kvm: allocate vcpu pointer array separately
Message-ID: <YTpuWl3Uhu4qpC1U@google.com>
References: <20210903130808.30142-1-jgross@suse.com>
 <20210903130808.30142-6-jgross@suse.com>
 <871r65wwk7.wl-maz@kernel.org>
 <37699e98-9a47-732d-8522-daa90f35c52f@suse.com>
 <87eea2c9zu.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eea2c9zu.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 06, 2021, Marc Zyngier wrote:
> On Mon, 06 Sep 2021 05:33:35 +0100,
> Juergen Gross <jgross@suse.com> wrote:
> > 
> > On 03.09.21 16:41, Marc Zyngier wrote:
> >
> > > At this stage, I really wonder why we are not using an xarray instead.
> > > 
> > > I wrote this [1] a while ago, and nothing caught fire. It was also a
> > > net deletion of code...
> > 
> > Indeed, I'd prefer that solution!
> > 
> > Are you fine with me swapping my patch with yours in the series?
> 
> Of course, feel free to grab the whole series. You'll probably need
> the initial patches to set the scene for this. On their own, they are
> a nice cleanup, and I trust you can write a decent commit message for
> the three patches affecting mips/s390/x86.

It would also be a good idea to convert kvm_for_each_vcpu() to use xa_for_each(),
I assume that's more performant than 2x atomic_read() + xa_load().  Unless I'm
misreading the code, xa_for_each() is guaranteed to iterate in ascending index
order, i.e. preserves the current vcpu0..vcpuN iteration order.
