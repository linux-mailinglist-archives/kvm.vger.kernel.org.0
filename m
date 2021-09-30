Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351E341E32A
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 23:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349204AbhI3VVE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 17:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348770AbhI3VVE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 17:21:04 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3298CC06176A
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 14:19:21 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id j4so3460374plx.4
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 14:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gsPJp6nywuIUGRL9wTTnUa2vydmRNYrvFxZGIzkhV+A=;
        b=J9xCjEqIH6BGsP72TtweSlq+uJYAp9hG5KQCUPFPbspycFHSs4Lsc6oYt//4e6lDBS
         ayT1JY+20Y9MYOCVyAtzlgHTpf6OJOIXieKjZteN40pzNcXrVdXMagupLd1Yn6dEL/N3
         ha81XbJFBVhrQ9B4tZmvTAM0XXNEqGrVMdoTZWD/++V5FK6SWw7z+Xf8sYZFHWE4Iub/
         S3ADOafRDiDYqSYll37tqVRpnWVln4cahERMNS8SzmNupRDOLbjm+0PIRtIzJsGOEOdV
         NPcSc5W9N+O19ZhttqKU+d0cTIjpEc+LVMQNb5elZmgWp6QLANC6o4cjQRJg1Kx2Ymh/
         i/NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gsPJp6nywuIUGRL9wTTnUa2vydmRNYrvFxZGIzkhV+A=;
        b=71Cl4DTMj6J4xuVvqRRQPDGZuygOxqwgNb3A3vboJLqoLjoz6nLhRWNuy4r9+YG2Gu
         DVnTh0SpkjCbaC4VcgwQNHEVT5gVs+5WE0yrawSxWbNRUQrnKdBcG6gBZnnISv0i8HHO
         2pAqe/wqJm+9uYpw2u/a5M1SfIKGVjGOxdlQv1Hc5/TpRRg5bEm+P7HRU+60raQDlAxi
         rNx02DHsnMhgUOZ8TCLR53y2NpgCfJwKRZo6c/nGolLYrV4GX3oP4WEGLZ9/lxV9U47j
         nJTjKYR/qbaEh586O3wDCdEyfnqhnOBaJ6WcRWAujixs24QXyXvUHi9JJJJhUhRQOxlI
         aklw==
X-Gm-Message-State: AOAM531HVqhUre2SoEe/a5Q/XyI75dnoxzLdrIGZcpMxqg3d6SDJy17A
        Elrxp+hlMt06iPtCwAAQNgjvaw==
X-Google-Smtp-Source: ABdhPJzk8BjwQeVCWpAv95Os14ZqKXwc6O/38qXjPwSrMgWbFGfkCrIkEUnvcxCi7OrzgfN9aTUPog==
X-Received: by 2002:a17:90b:1e4d:: with SMTP id pi13mr15532660pjb.96.1633036760458;
        Thu, 30 Sep 2021 14:19:20 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id k12sm4006534pfp.25.2021.09.30.14.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 14:19:19 -0700 (PDT)
Date:   Thu, 30 Sep 2021 14:19:16 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, alexandru.elisei@arm.com,
        Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Subject: Re: [PATCH v3 01/10] kvm: arm64: vgic: Introduce vgic_check_iorange
Message-ID: <YVYp1E7bqIFttXF+@google.com>
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-2-ricarkol@google.com>
 <4ab60884-e006-723a-c026-b3e8c0ccb349@redhat.com>
 <YVTX1L8u8NMxHAyE@google.com>
 <1613b54f-2c4b-a57a-d4ba-92e866c5ff1f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1613b54f-2c4b-a57a-d4ba-92e866c5ff1f@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 30, 2021 at 09:02:12AM +0200, Eric Auger wrote:
> Hi,
> 
> On 9/29/21 11:17 PM, Ricardo Koller wrote:
> > On Wed, Sep 29, 2021 at 06:29:21PM +0200, Eric Auger wrote:
> >> Hi Ricardo,
> >>
> >> On 9/28/21 8:47 PM, Ricardo Koller wrote:
> >>> Add the new vgic_check_iorange helper that checks that an iorange is
> >>> sane: the start address and size have valid alignments, the range is
> >>> within the addressable PA range, start+size doesn't overflow, and the
> >>> start wasn't already defined.
> >>>
> >>> No functional change.
> >>>
> >>> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> >>> ---
> >>>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 22 ++++++++++++++++++++++
> >>>  arch/arm64/kvm/vgic/vgic.h            |  4 ++++
> >>>  2 files changed, 26 insertions(+)
> >>>
> >>> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> >>> index 7740995de982..f714aded67b2 100644
> >>> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> >>> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> >>> @@ -29,6 +29,28 @@ int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
> >>>  	return 0;
> >>>  }
> >>>  
> >>> +int vgic_check_iorange(struct kvm *kvm, phys_addr_t *ioaddr,
> >>> +		       phys_addr_t addr, phys_addr_t alignment,
> >>> +		       phys_addr_t size)
> >>> +{
> >>> +	int ret;
> >>> +
> >>> +	ret = vgic_check_ioaddr(kvm, ioaddr, addr, alignment);
> >> nit: not related to this patch but I am just wondering why we are
> >> passing phys_addr_t *ioaddr downto vgic_check_ioaddr and thus to
> >>
> >> vgic_check_iorange()? This must be a leftover of some old code?
> >>
> > It's used to check that the base of a region is not already set.
> > kvm_vgic_addr() uses it to make that check;
> > vgic_v3_alloc_redist_region() does not:
> >
> >   rdreg->base = VGIC_ADDR_UNDEF; // so the "not already defined" check passes
> >   ret = vgic_check_ioaddr(kvm, &rdreg->base, base, SZ_64K);
> Yes but I meant why a pointer?

I can't think of any good reason. It must be some leftover as you said.

> 
> Eric
> >
> > Thanks,
> > Ricardo
> >
> >>> +	if (ret)
> >>> +		return ret;
> >>> +
> >>> +	if (!IS_ALIGNED(size, alignment))
> >>> +		return -EINVAL;
> >>> +
> >>> +	if (addr + size < addr)
> >>> +		return -EINVAL;
> >>> +
> >>> +	if (addr + size > kvm_phys_size(kvm))
> >>> +		return -E2BIG;
> >>> +
> >>> +	return 0;
> >>> +}
> >>> +
> >>>  static int vgic_check_type(struct kvm *kvm, int type_needed)
> >>>  {
> >>>  	if (kvm->arch.vgic.vgic_model != type_needed)
> >>> diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> >>> index 14a9218641f5..c4df4dcef31f 100644
> >>> --- a/arch/arm64/kvm/vgic/vgic.h
> >>> +++ b/arch/arm64/kvm/vgic/vgic.h
> >>> @@ -175,6 +175,10 @@ void vgic_irq_handle_resampling(struct vgic_irq *irq,
> >>>  int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
> >>>  		      phys_addr_t addr, phys_addr_t alignment);
> >>>  
> >>> +int vgic_check_iorange(struct kvm *kvm, phys_addr_t *ioaddr,
> >>> +		       phys_addr_t addr, phys_addr_t alignment,
> >>> +		       phys_addr_t size);
> >>> +
> >>>  void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
> >>>  void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
> >>>  void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr);
> >> Besides
> >> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> >> Eric
> >>
> 
