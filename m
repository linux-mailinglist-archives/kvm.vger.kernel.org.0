Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD30B417C65
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 22:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348439AbhIXUge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 16:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343775AbhIXUge (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 16:36:34 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2120C061571
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 13:35:00 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id mv7-20020a17090b198700b0019c843e7233so8383812pjb.4
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 13:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K0QGfXbDo/9jSYc9oFGWVgMEDWdPMfRJtz7Klt7Okmk=;
        b=oOyHBBZDhLSsYFR5G5wMFH9vsp2Eek7ZwpIf0x0xkvI52/9u8q4RDsIm4GTYKAGqhs
         0/KYkaeYQITIshlellRFX4R+BpGOT+UuI3VV6EKq29s4YcEl05nTlIpGt8dhIBzFdD9u
         2jkQZvLZQqHep8HXidiPnowSvZhpNqH2RLJyo+6EWoZqwjUB0kFycg3h1vdF065X0yiY
         wnZIxKSh/MyGgdEdv3lV3dCXqaLuyUCgIi+d0m+LslxSXcYpVIK/z2qW1W7nXzUmxto4
         ACeD7A2aXRXiR7G46JAh3Eoup9eqNtOi/Ttx0pxR06nG1y9yiLjJWjZ2LIPHGItsx5fW
         qdHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K0QGfXbDo/9jSYc9oFGWVgMEDWdPMfRJtz7Klt7Okmk=;
        b=RyXcbdEIVRQuZk+ElCLvWriilZ4PFPrzaAz71/taAIueimhjZaOin+WLDcwyrD79kM
         bZJkqU5ky2BUVI15x5LdsfHEQOnPj/NjShiNYMegUt9UJJ/OnLavNSUeWPosant4BFEf
         xKdN3WaLgtlIcPmC5G1YNRY0sJS3xFHJ760S+0ICDE7Kst82LBCaMtebeKbeJtG+LXk4
         S8RCiNJ3g47V3qMWGDlVu1GDUy34hStCtk1XQtg8e53eRyOMiygwL3U9vqX3G+TST+Ie
         txtvSOPyuUUC2YDLUBSqbuWKmXV1Iu94sVh1qvy58vNJ3nSBiwfyzgBMD9fA7CQ6m2d1
         QDCA==
X-Gm-Message-State: AOAM5336OK7VvWywUoGxRTp+xc+3IZcfHNtUb0wj42Lt3SvdGRD5R7g5
        mSpNaeqwp7C81O+6hYe/d9qoI124nllPIQ==
X-Google-Smtp-Source: ABdhPJyG2CvQBu3oBk64yqmXJnoPnykVy0sI58Kt4Zp/AyhpldzSAdl6lanCBzbZLyYgwyAwJSvBHA==
X-Received: by 2002:a17:902:db0a:b0:13b:b984:8094 with SMTP id m10-20020a170902db0a00b0013bb9848094mr10729592plx.43.1632515699798;
        Fri, 24 Sep 2021 13:34:59 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v12sm675255pjl.1.2021.09.24.13.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 13:34:58 -0700 (PDT)
Date:   Fri, 24 Sep 2021 20:34:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, linux-kernel@vger.kernel.org, joe.jin@oracle.com
Subject: Re: [PATCH RFC 1/1] kvm: export per-vcpu exits to userspace
Message-ID: <YU42b1iwIpZS0iCp@google.com>
References: <20210908000824.28063-1-dongli.zhang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210908000824.28063-1-dongli.zhang@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 07, 2021, Dongli Zhang wrote:
> People sometimes may blame KVM scheduling if there is softlockup/rcu_stall
> in VM kernel. The KVM developers are required to prove that a specific VCPU
> is being regularly scheduled by KVM hypervisor.
> 
> So far we use "pidstat -p <qemu-pid> -t 1" or
> "cat /proc/<pid>/task/<tid>/stat", but 'exits' is more fine-grained.

Sort of?  Yes, counts _almost_ every VM-Exit, but it's also measuring something
completely different.

> Therefore, the 'exits' is exported to userspace to verify if a VCPU is
> being scheduled regularly.

The number of VM-Exits seems like a very cumbersome and potentially misinterpreted
indicator, e.g. userspace could naively think that a guest that is generating a
high number of exits is getting more runtime.  With posted interrupts and other
hardware features, that doesn't necessarily hold true.

I'm not saying don't count exits, they absolutely can be a good triage tool, but
they're not the right tool to verify tasks are getting scheduled.

> I was going to export 'exits', until there was binary stats available.
> Unfortunately, QEMU does not support binary stats and we will need to
> read via debugfs temporarily. This patch can also be backported to prior
> versions that do not support binary stats.

Adding temporary code to the _upstream_ kernel to work around lack of support in
the userspace VMM does not seem right to me.  Especially in debugfs, which is
very explicitly not intended to be used for thing like monitoring in production.
