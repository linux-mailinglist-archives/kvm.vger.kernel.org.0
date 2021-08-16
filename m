Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F47C3ED3C1
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 14:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232991AbhHPMQZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 08:16:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23535 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229836AbhHPMQZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 08:16:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629116153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TtYSIBToB+BmD+CawxpOkHBAy0xx9e6INa/j+nR9EVA=;
        b=bwBIshdD+NLhzrNXvsUiXXTaEsegYTgLoxrpK6+Df3GgJnAV9dgNJFvfBjfEtHqml80FGy
        /ViVowtfvhcUiFDTOzMpoV/VJ5A6xl/zJkvWYUcvXyO+XvZK2o3VSGG3LI0YVCLUAk/XL8
        y1C6jtsFu1Kr/70sCQ9Wh7MGrzUApqs=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-P5PcQzl-M4qByP9yx_GL5A-1; Mon, 16 Aug 2021 08:15:52 -0400
X-MC-Unique: P5PcQzl-M4qByP9yx_GL5A-1
Received: by mail-ej1-f70.google.com with SMTP id x5-20020a1709064bc5b02905305454f5d1so4581219ejv.10
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 05:15:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TtYSIBToB+BmD+CawxpOkHBAy0xx9e6INa/j+nR9EVA=;
        b=EMZEQBUKrgJXNggDC/ncGJPfTiAMRqnKyAEPfMaP7XaAeoCY9jWI1oP7qZTtQiHsBb
         eq/ecEWKaFo5A2F2UprayPeiBZX6BYENGBKrsqU1Gvh4tq+Hcf4Q3BckUKrQR3nR4ct4
         GFNGHNBiBfwhF8XDLdpVqx9DL5nCzczKmZ371111lsZrS+6hmC2WsNmLtcRy1j0XNamo
         m1blqMhlWvEV21FTad0DLcSzq+81qqYVKABk+bqBnlTTrYHUi26VOZOz2qRhvR0qtUS1
         JgU+VoKZNkM/IJOgo+8ekLqqafGqpoqvSltcnKL1j/V3xC484juggk8HzazeWeALUQBs
         AGLQ==
X-Gm-Message-State: AOAM5315DFG0GwdANzss5PWO6MFxe+gZ8hSFehebj+G4cIdYmjfowbyv
        LMD82SkJ0GhOettpE/o5FSHNrJL7EkFFqBp2pnYzpVRa9Q5Qkc4AOhKimzsKvmZSGwNeEWqCGFs
        oeDRm+MyOgAMx
X-Received: by 2002:aa7:d4d3:: with SMTP id t19mr19498070edr.131.1629116150790;
        Mon, 16 Aug 2021 05:15:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyfEaBs2MuLXmF0DrS7/u9PwEaM1QS6mBptDHXsF4n5KvyWlM5xu2nsqC6r+jAqSDuEOjSG1Q==
X-Received: by 2002:aa7:d4d3:: with SMTP id t19mr19498046edr.131.1629116150580;
        Mon, 16 Aug 2021 05:15:50 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id ck17sm4786345edb.88.2021.08.16.05.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 05:15:50 -0700 (PDT)
Date:   Mon, 16 Aug 2021 14:15:48 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH 00/10] KVM: arm64: selftests: Introduce arch_timer
 selftest
Message-ID: <20210816121548.y5w624yhrql2trzt@gator.home>
References: <20210813211211.2983293-1-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813211211.2983293-1-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 13, 2021 at 09:12:01PM +0000, Raghavendra Rao Ananta wrote:
> Hello,
> 
> The patch series adds a KVM selftest to validate the behavior of
> ARM's generic timer (patch-10). The test programs the timer IRQs
> periodically, and for each interrupt, it validates the behaviour
> against the architecture specifications. The test further provides
> a command-line interface to configure the number of vCPUs, the
> period of the timer, and the number of iterations that the test
> has to run for.
> 
> Since the test heavily depends on interrupts, the patch series also
> adds a basic support for ARM Generic Interrupt Controller v3 (GICv3)
> to the KVM's aarch64 selftest framework (patch-9).
> 
> Furthermore, additional processor utilities such as accessing the MMIO
> (via readl/writel), read/write to assembler unsupported registers,
> basic delay generation, enable/disable local IRQs, spinlock support,
> and so on, are also introduced that the test/GICv3 takes advantage of.
> These are presented in patches 1 through 8.
> 
> The patch series, specifically the library support, is derived from the
> kvm-unit-tests and the kernel itself.
> 

Hi Raghavendra,

I appreciate the new support being added to aarch64 kselftests in order to
support new tests. I'm curious as to why the kvm-unit-tests timer test
wasn't extended instead, though. Also, I'm curious if you've seen any
room for improvements to the kvm-unit-tests code and, if so, if you plan
to submit patches for those improvements.

Thanks,
drew

