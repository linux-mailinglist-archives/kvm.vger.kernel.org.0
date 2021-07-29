Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9C63DA926
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 18:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbhG2Qdx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 12:33:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56324 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229565AbhG2Qdx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 12:33:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627576429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FjcH7sCGB66RKzqPeaDWjgM8tAnh9bdebcMjCL2pj+c=;
        b=AZMgn07nZDnWk6ZmC6UevS+2QDxOnllRT7nBFZ+Vy0zxVauxY0qwb2CoQM+QD/p0kGYU1t
        YYEGPi9+AQT3dvmsMreQmUkKOPv9tmyM4r9F3vI5+GVLvUSb0RWDLp4Z2ftx62SmB96f0r
        gmeAiRZdY5RlLL0PLHg5nkUrjL4cisM=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-K5nHX24RM_-xyGjx10ADkg-1; Thu, 29 Jul 2021 12:33:48 -0400
X-MC-Unique: K5nHX24RM_-xyGjx10ADkg-1
Received: by mail-io1-f72.google.com with SMTP id c18-20020a0566023352b0290523c137a6a4so4168836ioz.8
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 09:33:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FjcH7sCGB66RKzqPeaDWjgM8tAnh9bdebcMjCL2pj+c=;
        b=VD5wzvc92lazXc21RDsIgNaOLjaUfWqZ2HFzvAkujd0xBbbCZvaPc2r2+sJuk2DjHP
         ru8ZlVKcwBxvireb754gDTlsMd/REpwIftr5GCiIysfqznrCWoVSsoxxPVktV8zXY1FB
         KOW4hGC/mgvGAH6B6gskFC3KCS4V+EgqEDtkiQxiA8hPP2zT4uORX4XfuQhaz3gluduS
         /kg0vv7WQq02IsmwGmu1OyptMhwAnKVHbEOhqOVhFPCGyl3Qarpw90ar87vG04qwTXOx
         h+YPwMx7FEV+YjEiYroRYCV+HqtnQzQYHf7Mig5Avyp928iMfwq26uFVuZ1uVAgxlRBi
         JISw==
X-Gm-Message-State: AOAM5309ZGUUZzouB7xzzDpiTNPxiXxJbvqhqP9qnYOjAEYtX9YCdy84
        A5U3dW6/6NzJPXtb47rnH4pC3OAGP3KT1/T2vstLui54UARSIaEcc3hGHer2f1M1Nubh7mzsmsH
        4ppFWlIvZz4X4
X-Received: by 2002:a02:8241:: with SMTP id q1mr5172581jag.134.1627576427833;
        Thu, 29 Jul 2021 09:33:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4d115XMfSVHnaViBRH7zqO/+JS3UA9k8rGTp/h+c0mtFXHxXJNO0ZZi3gMSV04nJNqZsx0Q==
X-Received: by 2002:a02:8241:: with SMTP id q1mr5172569jag.134.1627576427690;
        Thu, 29 Jul 2021 09:33:47 -0700 (PDT)
Received: from gator ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id f16sm2147192ilc.53.2021.07.29.09.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 09:33:47 -0700 (PDT)
Date:   Thu, 29 Jul 2021 18:33:44 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 11/13] KVM: arm64: Provide userspace access to the
 physical counter offset
Message-ID: <20210729163344.bojsdqw4z6pjdg3g@gator>
References: <20210729001012.70394-1-oupton@google.com>
 <20210729001012.70394-12-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729001012.70394-12-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 29, 2021 at 12:10:10AM +0000, Oliver Upton wrote:
> Presently, KVM provides no facilities for correctly migrating a guest
> that depends on the physical counter-timer. While most guests (barring
> NV, of course) should not depend on the physical counter-timer, an
> operator may still wish to provide a consistent view of the physical
> counter-timer across migrations.
> 
> Provide userspace with a new vCPU attribute to modify the guest physical
> counter-timer offset. Since the base architecture doesn't provide a
> physical counter-timer offset register, emulate the correct behavior by
> trapping accesses to the physical counter-timer whenever the offset
> value is non-zero.
> 
> Uphold the same behavior as CNTVOFF_EL2 and broadcast the physical
> offset to all vCPUs whenever written. This guarantees that the
> counter-timer we provide the guest remains architectural, wherein all
> views of the counter-timer are consistent across vCPUs. Reconfigure
> timer traps for VHE on every guest entry, as different VMs will now have
> different traps enabled. Enable physical counter traps for nVHE whenever
> the offset is nonzero (we already trap physical timer registers in
> nVHE).
> 
> FEAT_ECV provides a guest physical counter-timer offset register
> (CNTPOFF_EL2), but ECV-enabled hardware is nonexistent at the time of
> writing so support for it was elided for the sake of the author :)
> 
> Cc: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  Documentation/virt/kvm/devices/vcpu.rst   | 22 +++++++
>  arch/arm64/include/asm/kvm_host.h         |  1 +
>  arch/arm64/include/asm/kvm_hyp.h          |  2 -
>  arch/arm64/include/asm/sysreg.h           |  1 +
>  arch/arm64/include/uapi/asm/kvm.h         |  1 +
>  arch/arm64/kvm/arch_timer.c               | 72 ++++++++++++++---------
>  arch/arm64/kvm/arm.c                      |  4 +-
>  arch/arm64/kvm/hyp/include/hyp/switch.h   | 23 ++++++++
>  arch/arm64/kvm/hyp/include/hyp/timer-sr.h | 26 ++++++++
>  arch/arm64/kvm/hyp/nvhe/switch.c          |  2 -
>  arch/arm64/kvm/hyp/nvhe/timer-sr.c        | 21 +++----
>  arch/arm64/kvm/hyp/vhe/timer-sr.c         | 27 +++++++++
>  include/kvm/arm_arch_timer.h              |  2 -
>  13 files changed, 158 insertions(+), 46 deletions(-)
>  create mode 100644 arch/arm64/kvm/hyp/include/hyp/timer-sr.h
>

 
Reviewed-by: Andrew Jones <drjones@redhat.com>

