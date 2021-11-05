Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE1A4465DA
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 16:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233525AbhKEPjg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 11:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbhKEPjf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Nov 2021 11:39:35 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D3EBC061714
        for <kvm@vger.kernel.org>; Fri,  5 Nov 2021 08:36:56 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id t5-20020a17090a4e4500b001a0a284fcc2so3608520pjl.2
        for <kvm@vger.kernel.org>; Fri, 05 Nov 2021 08:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=byGIoYkr0QhWpJdm4ULxfBziUavg2KJpzYT4Nf5tt3s=;
        b=ET3VcrdlIP9HQjIDJYvleAng264LiCDGiockoUj9mbSqEWzbMx4qIQqWOTpsiVOMoe
         1h2RLIl/OmPIwSOfCYZVSooUajDezEagxfrmhvnSAX1xfHGuq/m77W/pZRoFHyKMSlt5
         yghjjy59VBDJDhvOJe9UqC78t4dhwZS9Gyxc6r4vGnDdtp5dvtrNEPZ9Ntd9zPYISgBq
         AzttVafq5l13ol9SzSy7qAv3CfpcPU1NRHg9G6aPGFcGz262CLVN9y0Je8jmJoSbbieX
         BzSEdjHVz15M4iIto1KnnO6AtzngJaBOluJrVaLxSk/P/QHyY3SeXcFmHNfkNCyYwVx6
         3llw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=byGIoYkr0QhWpJdm4ULxfBziUavg2KJpzYT4Nf5tt3s=;
        b=jPi2sblVGs9CEjPQjdw5i+JSCi7/SSJVTIUzCJoeGdTRxrfk9svn4fTtsM8i1X0YaO
         B4g13Gba579UTkLhWhlS7ZMg3DJ3Us2e0BfsX/apnQBEjUF2zVRDogD1tWxxOkBZj3/0
         /xzAy2ggIEXHWGUHsrxL0CzyK1F6VsLJhCxfUi+VjzB0YBs5nMRhpYnxWacuCRzyS0kN
         BaEEIB2pxDYLT6y+SRd7/vbM4FJmGhkFcbY+BctSzp2Jpw5TkkrGFeXrGx324OfYV2mM
         Dr3lr05zSAj9kvlqQ/dR/s3ycdeih/htVGGC8dmFyWEL+gMLtxzFv76mmE+gQsOgb+QI
         u7BA==
X-Gm-Message-State: AOAM531aN61bpglWdSit90RY2wcF2A2QSPNbT7uq0A/jpDj01hfv2hct
        WiO0PKwGSzb15Tv4JNgsa+prAw==
X-Google-Smtp-Source: ABdhPJyjTdlXsCOkbpOSgeDygiSkroH08OzEE8JdWsTeAhXCHJdw3tjx8Y7g2DtY2QJHapZWTB8UIg==
X-Received: by 2002:a17:902:aa08:b0:13f:eb2e:8ce8 with SMTP id be8-20020a170902aa0800b0013feb2e8ce8mr52619170plb.0.1636126615651;
        Fri, 05 Nov 2021 08:36:55 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w192sm2422905pfd.21.2021.11.05.08.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 08:36:54 -0700 (PDT)
Date:   Fri, 5 Nov 2021 15:36:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: x86: Copy kvm_pmu_ops by value to eliminate
 layer of indirection
Message-ID: <YYVPkxVeQO4VFGCZ@google.com>
References: <20211103070310.43380-1-likexu@tencent.com>
 <20211103070310.43380-2-likexu@tencent.com>
 <YYVODdVEc/deNP8p@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYVODdVEc/deNP8p@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 05, 2021, Sean Christopherson wrote:
> On Wed, Nov 03, 2021, Like Xu wrote:
> I would also say land this memcpy() above kvm_ops_static_call_update(), then the
> enabling patch can do the static call updates in kvm_ops_static_call_update()
> instead of adding another helper.

Ugh, kvm_ops_static_call_update() is defined in kvm_host.h.  That's completely
unnecessary, it should have exactly one caller, kvm_arch_hardware_setup().  As a
prep match, move kvm_ops_static_call_update() to x86.c, then it can reference the
pmu ops.
