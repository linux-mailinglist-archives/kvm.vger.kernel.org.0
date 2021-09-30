Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E7E41E35E
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 23:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240862AbhI3V3a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 17:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbhI3V31 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 17:29:27 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F90C06176A
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 14:27:44 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id 187so1728283pfc.10
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 14:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r0i+4oh5ttmvKzGJaF4duXEtIwD8cGanxYr+JafZRCc=;
        b=Lepz8HOPy8gYGMfKpd+iWWTvMcOMxwafkPOVcPvRlPcbhH7cbzDgC6rXgoDcB+zVgB
         Ff3KhLPBGGD3uVIja2Dm3jbPkzC+TeUU8IrXKlsd3i5Zeah4yYApRrNVxE5PepUh/zlo
         tkV+otCyCWwkHESL4eOLtedqPje8r8uYpgjKn4zlF+aynH+jiFhv8hGsPGXohQefpwnx
         kCEUKtsw2XiAqQ4B1eW8J1udWHntxC5pW0LHt518UNkkS5HK1bIfRaONCerOCQvBsNiW
         4kALVECg/PGMffjjw+V2LK2jp5wiSqNJ5/XaWD36qrHeXxtzdBFgKL7KX7HcOWcKVklx
         gE4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r0i+4oh5ttmvKzGJaF4duXEtIwD8cGanxYr+JafZRCc=;
        b=Ja1wwDvZbTgLGDUbOP0JGQJs8D5Bhbje8SlywclrG9dFizJGeRaLUPaajvCSnmQ9JY
         yf93anm0BRffF3lDjoW7m2HzPzZM4pRQ8nHeXUq6KMjNGqewTP4lZNX4EmvXuKRMhUO5
         SsiKRy+LQM9uL/kZkTpiMiYylGaoUBUtPlDiGZixWe/uUiQ3mK8wIlVPxoQfa3ZVrY+3
         O9xD3hJJ4UPiRg0UrjK7kEu28o2WRZ2DE2PXNq/WTVPP9OSGjF/d+EEKMM+dtKS3YVFO
         ZL/HrR5dy36TDEZVQr0gVyzc4XILn7Kh/caCjg4cyOq99PFOhf6/E2LOQDCNW60Ha4lp
         FoKg==
X-Gm-Message-State: AOAM533DPtxfTT3qfNlbB6eh90WEryh5VGvit7LgeGCV56WrfyfUlK8a
        IoOU6c9l8goLTiC49zF76abKXw==
X-Google-Smtp-Source: ABdhPJwokKb25gzszvdtUECo3bG3lRZr0uuSLd4XCMxKvvZtnpPLwddgYcgZEB3a0Ltdd5ZnEaTyGQ==
X-Received: by 2002:a63:40c:: with SMTP id 12mr6830835pge.406.1633037263905;
        Thu, 30 Sep 2021 14:27:43 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id n3sm5723593pjv.15.2021.09.30.14.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 14:27:43 -0700 (PDT)
Date:   Thu, 30 Sep 2021 14:27:39 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     eric.auger@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
        alexandru.elisei@arm.com, Paolo Bonzini <pbonzini@redhat.com>,
        oupton@google.com, james.morse@arm.com, suzuki.poulose@arm.com,
        shuah@kernel.org, jingzhangos@google.com, pshier@google.com,
        rananta@google.com, reijiw@google.com
Subject: Re: [PATCH v3 05/10] KVM: arm64: selftests: Make vgic_init gic
 version agnostic
Message-ID: <YVYrywHjwhzgfmBz@google.com>
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-6-ricarkol@google.com>
 <a629c99e-cb41-fb2d-d551-6397774ba765@redhat.com>
 <87ee96trnl.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ee96trnl.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 30, 2021 at 09:05:18AM +0100, Marc Zyngier wrote:
> On Wed, 29 Sep 2021 18:12:59 +0100,
> Eric Auger <eric.auger@redhat.com> wrote:
> > 
> > If the GICv3 supports compat with GICv2, I think you could be able to
> > run both tests consecutively. So maybe don't return?
> 
> You'll need to recreate a full VM though. Even if the HW supports the
> compat mode, our GICv3 emulation doesn't.

I'm not sure how much work would that entail, but sounds like it might
be too much for a selftest.

Thanks,
Ricardo

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
