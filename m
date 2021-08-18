Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD8D3F0DA3
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 23:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234331AbhHRVpq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 17:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234045AbhHRVpp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 17:45:45 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0713C061764
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 14:45:10 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id m24-20020a17090a7f98b0290178b1a81700so3327374pjl.4
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 14:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=muQCcqaPenKykG4PGOy+YxdceqzyYMRDPJOUz8KbyH0=;
        b=TexX8C3gmVxHzDuCEwQRrA5o/2oXdFco2ACSFpQmgmxiHjLGxJI3P5NtFHwrAo7JSQ
         4e1LI98IUf45La8KMqOqirtwGyAayWFz/u2zn6V7H2zMBiJZgLKuoTMHeS3A9KUyZn/G
         OPKZdImH3sH8BQQNACUqUrOjxwfBrNA1T34tHRAbVubPFhasl+HWOPmhsHntGlW6ar6e
         XcG0O64PG81S8SXwSC8Op0rH5qvnG8AfcRchXmfeGXC+UMF2CkfpgvNPNkkhQyqhpETE
         /Qh4oCmGyopz9nlk65pUw42LtQ1hIoPAZSg3m0dlsJy3sk4k4Me0/mrAgJUC71QujBTH
         EV2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=muQCcqaPenKykG4PGOy+YxdceqzyYMRDPJOUz8KbyH0=;
        b=ILeLgEzS9G2Q2GkYJeq+3Vv0kGBX/89rvmZ4tXE2LZ7TvTMuc2+t1iKav8zRaJ/MnQ
         sN7QE6rs+atTZWgbVO41o9qHwkK2M5+9VorYytoa3PFYTP25qmKmgvLjAGuwjFLxT56L
         X/vpP0aXFnTvdA9uqLguQKLCN8a2WJ/rayMUZCe1Uu+j2eFCMFPCkNUyXzMTAhtI18Ag
         GFrMy+NrWge+49StVueuWLONe5MOqY/ZFfpBmoP3QL/plLJGFMJBN16o5TAA2hXpchow
         9crMhNSHrw1NnlqsrdgzTZxNdTDrRu4ebPrEIEeCea6Yn/qWEjD5lcd13jcfqFcvm3LG
         iAwQ==
X-Gm-Message-State: AOAM532z8sJ/T4V0yIXnR9yBJiE7FETs4XRnq4cGbxAJhDDK7CBoibXN
        uIz0WVzzG13ZGRNeVHthL+aejQ==
X-Google-Smtp-Source: ABdhPJyBiBhnl7bejibYMgU7hymcLriNmoYbU76Tnmv+ZM5Ar+/vDRcYxghD3weIQN8BHvvxpxxKlg==
X-Received: by 2002:a17:90a:2845:: with SMTP id p5mr11221708pjf.96.1629323109999;
        Wed, 18 Aug 2021 14:45:09 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id y1sm829132pga.50.2021.08.18.14.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 14:45:09 -0700 (PDT)
Date:   Wed, 18 Aug 2021 14:45:04 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, maz@kernel.org,
        james.morse@arm.com, Alexandru.Elisei@arm.com, drjones@redhat.com,
        catalin.marinas@arm.com, suzuki.poulose@arm.com,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Subject: Re: [PATCH] KVM: arm64: vgic: drop WARN from vgic_get_irq
Message-ID: <YR1/YEY8DX+r05nt@google.com>
References: <20210818213205.598471-1-ricarkol@google.com>
 <CAOQ_QshVenuri8WdZdEis4szCv03U0KRNt4CqDNtvUBsqBqUoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ_QshVenuri8WdZdEis4szCv03U0KRNt4CqDNtvUBsqBqUoA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 18, 2021 at 02:34:03PM -0700, Oliver Upton wrote:
> Hi Ricardo,
> 
> On Wed, Aug 18, 2021 at 2:32 PM Ricardo Koller <ricarkol@google.com> wrote:
> >
> > vgic_get_irq(intid) is used all over the vgic code in order to get a
> > reference to a struct irq. It warns whenever intid is not a valid number
> > (like when it's a reserved IRQ number). The issue is that this warning
> > can be triggered from userspace (e.g., KVM_IRQ_LINE for intid 1020).
> >
> > Drop the WARN call from vgic_get_irq.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arch/arm64/kvm/vgic/vgic.c | 1 -
> >  1 file changed, 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> > index 111bff47e471..81cec508d413 100644
> > --- a/arch/arm64/kvm/vgic/vgic.c
> > +++ b/arch/arm64/kvm/vgic/vgic.c
> > @@ -106,7 +106,6 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
> >         if (intid >= VGIC_MIN_LPI)
> >                 return vgic_get_lpi(kvm, intid);
> >
> > -       WARN(1, "Looking up struct vgic_irq for reserved INTID");
> 
> Could we maybe downgrade the message to WARN_ONCE() (to get a stack)
> or pr_warn_ratelimited()? I agree it is problematic that userspace can
> cause this WARN to fire, but it'd be helpful for debugging too.
> 

Was thinking about that, until I found this in bug.h:

	/*
	 * WARN(), WARN_ON(), WARN_ON_ONCE, and so on can be used to report
	 * significant kernel issues that need prompt attention if they should ever
	 * appear at runtime.
	 *
	 * Do not use these macros when checking for invalid external inputs
	 * (e.g. invalid system call arguments, or invalid data coming from
	 * network/devices),

Just in case, KVM_IRQ_LINE returns -EINVAL for an invalid intid (like
1020). I think it's more appropriate for the vmm to log it. What do you
think?

Thanks,
Ricardo

> --
> Thanks,
> Oliver
> 
> >         return NULL;
> >  }
> >
> > --
> > 2.33.0.rc2.250.ged5fa647cd-goog
> >
