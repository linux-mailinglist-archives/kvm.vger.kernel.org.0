Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2754365E70
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 19:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbhDTRZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 13:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbhDTRZN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 13:25:13 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A1FC06174A
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 10:24:42 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so22746657pjh.1
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 10:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PnZ51Qd4+D79y2/gD6y/WyaSioVJc0ih2t9nxA6F6kM=;
        b=VILXmoHbYdOcoS7gaVFYsjv/gO9NOzSTHUygV+Obvzv+cpL/AV3lRwHj633aZsD/rG
         GTFRNbKKPs1xFwtfTeLLx36VCTW4wA9uR9NYVSbZFxsMYNuAJVdIqt9s85KKRDiOrQI3
         DLrkNYr2tpueMObp9opVu0pNlhtQ7LOaDX1FlkeS8nXv8AF3pbc546K2ttI2fud9n4hh
         rqLZZLN2SvFScsysSPEvOCNlYt9opIOdtXR01PeLUyXJomgW6baXTZqIpnJzh8o2KRAt
         DohlkYxihUkJCq6q6dVJubjejdGAK26x4+I1vmUD59Wvod7tsNALaPMxYEAlKInATLAV
         ntuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PnZ51Qd4+D79y2/gD6y/WyaSioVJc0ih2t9nxA6F6kM=;
        b=reGF4PTdKOMUvFmhqLzZxgoUxYsq8S/oAoUj2cYjDJ4ThUBVDCAf3ZNM7hz+gysaHY
         tR8a5u8IVYLjDbhoZgdouKRsu/sANoCPE35KAW3d4TmCEbA51pzQFVBxsw4G2fMCXpRv
         G10Zeb+tbmXFj1ZmAHp80QkJNsw/RcIiOztULOfle5y5ZeFMRfvfFGJx7lgf2rMlozW/
         OJsxMOvzb1MBdu6tTSRGa7ow29MDO4YlxRaEW8uyEqGNMy3Cc0lBTbu75HqeuM2sfdA7
         gXqNAo5aU7hnihF0g2tW422nQxfZaFTIuFJJTrcKXscnrbgsbDxkEa4yPdIhSrDblXrY
         IDQw==
X-Gm-Message-State: AOAM533WnRvod+JMoLJbGjiEUcEPybIiJZqf+goH8qRcm6Sx57SDRZcV
        tC7bsPB4Z9dsl1VxCRLW+NNFSg==
X-Google-Smtp-Source: ABdhPJw7ahnfQfpN51Mjb9qWbHH4S619d9FY1A1Cc43GiB1HOdM5iHlzUznNKCqB2B1z9VqwvsPGaQ==
X-Received: by 2002:a17:90a:7893:: with SMTP id x19mr6284897pjk.3.1618939481849;
        Tue, 20 Apr 2021 10:24:41 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id m9sm16483754pgt.65.2021.04.20.10.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 10:24:41 -0700 (PDT)
Date:   Tue, 20 Apr 2021 17:24:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: Re: [PATCH v13 08/12] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
Message-ID: <YH8OVZTZG7rOstr0@google.com>
References: <cover.1618498113.git.ashish.kalra@amd.com>
 <93d7f2c2888315adc48905722574d89699edde33.1618498113.git.ashish.kalra@amd.com>
 <6e6b4e8c-bbfa-fd58-c1e8-895a157762fe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e6b4e8c-bbfa-fd58-c1e8-895a157762fe@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 20, 2021, Paolo Bonzini wrote:
> On 15/04/21 17:57, Ashish Kalra wrote:
> > From: Ashish Kalra <ashish.kalra@amd.com>
> > 
> > This hypercall is used by the SEV guest to notify a change in the page
> > encryption status to the hypervisor. The hypercall should be invoked
> > only when the encryption attribute is changed from encrypted -> decrypted
> > and vice versa. By default all guest pages are considered encrypted.
> > 
> > The hypercall exits to userspace to manage the guest shared regions and
> > integrate with the userspace VMM's migration code.
> 
> I think this should be exposed to userspace as a capability, rather than as
> a CPUID bit.  Userspace then can enable the capability and set the CPUID bit
> if it wants.
> 
> The reason is that userspace could pass KVM_GET_SUPPORTED_CPUID to
> KVM_SET_CPUID2 and the hypercall then would break the guest.

Right, and that's partly why I was advocating that KVM emulate the MSR as a nop.
