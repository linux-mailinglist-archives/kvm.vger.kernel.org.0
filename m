Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2557406E13
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 17:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234371AbhIJPUk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 11:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234130AbhIJPUi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Sep 2021 11:20:38 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8A2C061574
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 08:19:27 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id k17so1381968pls.0
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 08:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Zjxt7+clbNQQvd9ZPDVPHwVKwjpRnv02bpP5uIHrJKg=;
        b=BSW0AkLpwHwkLPCavwIQLHhDqfV4NbmcpdKNa4qAiJDDR/Ffmb+Wtwbx8Bt8ZxeJE3
         PjjR+Zv7tQgVQH034Xo+cOhBsPJF3yz3KcAEgkfiIMAcW9cZVhZ1bjCheh03AUfM2krn
         zgR4r5kqqKYO9t3WRupK2hVksv8E0rAmND5cCmXJ4NH4M8dHpbMJhI3jBZeqO93A5oVo
         FE3gtrzBJgzXiswBs2iMADjPPntjctFg88v3Oz0jEgbPnXOs+nH9kp2yTOsF5RRW+Eiy
         H0MSH/7khZbRjKSU2TiyHxP2u6xlns1Rf01Ck3a0xD7t0qGYPU3jAXy+So4mt+j6IVLe
         miVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Zjxt7+clbNQQvd9ZPDVPHwVKwjpRnv02bpP5uIHrJKg=;
        b=y78c9n/viSYMYaxt1QPjYOeZkl+VziCN231mLTCmO9puUSahjgl6DzOAl+OMnMgttK
         Trvsw5bcq5dmMmDryEocr+P8poWu67gfI8JP2DOVu0oqKs6/sQ8Y2LHxFwQrjQVw8elK
         bi0UN+swDk5zJt3Iaou3PX3xO4cAX7GhjM4fEfJniPwFHYeaC7cfWD9cBwEgafibXZFq
         KZaIPerrievyCrJ0ZiGbrimFaK5+wNamCnXeMIp5T8ediZ4N5jqPPP3RDjuj0fUmj486
         u4soDTk6RgGa655PtIayAeX6XLUBo7lPV5Tf+IQWY/Qlxw2XOLQI5eMpxydaCvRrq8Wd
         qqFw==
X-Gm-Message-State: AOAM533uu0EhnB4BleWZsbc4x7goYtIWNucCPI52dOK0a+wVVbdGR2Sn
        3P/mnvZJcWygrGymdgRJ4L32nA==
X-Google-Smtp-Source: ABdhPJx0LplRfx25sKT8ANeINOGLOmRhkwpXlJkZIuK/9ZEaK+VT6H/9FHBkxlc67h4EVYpANLx2VA==
X-Received: by 2002:a17:90a:19c3:: with SMTP id 3mr8938575pjj.23.1631287166324;
        Fri, 10 Sep 2021 08:19:26 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g18sm5027871pfj.80.2021.09.10.08.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 08:19:25 -0700 (PDT)
Date:   Fri, 10 Sep 2021 15:19:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Fix nested bus lock VM exit
Message-ID: <YTt3elxQPbo5JXb3@google.com>
References: <20210827085110.6763-1-chenyi.qiang@intel.com>
 <YS/BrirERUK4uDaI@google.com>
 <0f064b93-8375-8cba-6422-ff12f95af656@intel.com>
 <YTpLmxaR9zLbcyxx@google.com>
 <56fa664d-c4e5-066b-2bc8-2f1d2e74b35a@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56fa664d-c4e5-066b-2bc8-2f1d2e74b35a@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 10, 2021, Xiaoyao Li wrote:
> On 9/10/2021 1:59 AM, Sean Christopherson wrote:
> > No, nested_vmx_l0_wants_exit() is specifically for cases where L0 wants to handle
> > the exit even if L1 also wants to handle the exit.  For cases where L0 is expected
> > to handle the exit because L1 does _not_ want the exit, the intent is to not have
> > an entry in nested_vmx_l0_wants_exit().  This is a bit of a grey area, arguably L0
> > "wants" the exit because L0 knows BUS_LOCK cannot be exposed to L1.
> 
> No. What I wanted to convey here is exactly "L0 wants to handle it because
> L0 wants it, and no matter L1 wants it or not (i.e., even if L1 wants it) ",
> not "L0 wants it because the feature not exposed to L1/L1 cannot enable it".
> 
> Even for the future case that this feature is exposed to L1, and both L0 and
> L1 enable it. It should exit to L0 first for every bus lock happened in L2
> VM and after L0 handles it, L0 needs to inject a BUS LOCK VM exit to L1 if
> L1 enables it. Every bus lock acquired in L2 VM should be regarded as the
> bus lock happened in L1 VM as well. L2 VM is just an application of L1 VM.
> 
> IMO, the flow should be:
> 
> if (L0 enables it) {
> 	exit to L0;
> 	L0 handling;
> 	if (is_guest_mode(vcpu) && L1 enables it) {
> 		inject BUS_LOCK VM EXIT to L1;
> 	}
> } else if (L1 enables it) {
> 	BUS_LOCK VM exit to L1;
> } else {
> 	BUG();
> }

Ah, we've speculated differently on how nested support would operate.  Let's go
with the original patch plus a brief comment stating it's never exposed to L1.
Since that approach doesn't speculate, it can't be wrong. :-)

Thanks!
