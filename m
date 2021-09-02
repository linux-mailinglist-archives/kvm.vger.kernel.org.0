Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F79A3FEEE5
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 15:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345226AbhIBNpP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 09:45:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55242 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345156AbhIBNpJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Sep 2021 09:45:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630590248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PRM8lYGUmpsg4gH1Jz3PJxIAnZtJDS7+em5ACTDkhkU=;
        b=QjPcRUqmyKU0TRfpc1WtY2E0oI9voSL5YQt8sUQXITY+gHNOOCIU625KW5WVTTCfLpqumv
        5hE+ybfs+t3MLTbiuRRz1zoTOnHTrSV1kQZ7NtB1XBUsj7ey2KO9DATE3xWEgrKhQWNs0a
        6TVvW8q5M9e0w7s3yItaMekQVezFAiY=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-obSgRkcIN46_TwDHPixLBA-1; Thu, 02 Sep 2021 09:44:07 -0400
X-MC-Unique: obSgRkcIN46_TwDHPixLBA-1
Received: by mail-qk1-f198.google.com with SMTP id h186-20020a3785c3000000b00425f37f792aso1627300qkd.22
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 06:44:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PRM8lYGUmpsg4gH1Jz3PJxIAnZtJDS7+em5ACTDkhkU=;
        b=t9wKFn8KHPDyy0gTb/TALDjsiKsDKBaYsPr3mSVO3awPMMnVm/QviFkRDjDG3jwtC+
         tpx6Vuw5vG+yIXHsahgzliq7EQEKSqf6ApnNnvtbfgVwl2kWt0v2VoT7OJiED4k0Shp/
         ch3b9MRrWQSiHNlwsFi5qKX4WnI5MW/V+cuoTqHqYcobqQrUm0aEtNZ713/1fz7DCgaZ
         iihgQAfJJ2CRn/S6nSWhz8VETSBqgeuNRVR53I/m++0cRBTF/BeUqkNTlNbjSxAagMeY
         k3kSYG60IyhqZ19KjkOer304vULkWjxOcphVb85TTY6NLj/p6hHkpuoTsBXQkoFDsV1i
         Gi3g==
X-Gm-Message-State: AOAM532qW/VBMU1urQQJMZ9q30U6yFcd3bf7fItMth4Jg0NPE7D/ssRC
        S9hxTLQEw/9W56CbbNEiC18WQNZk4RjveDhSXttwiWyp0gfKX6bS4kcE/zNHB35udpYJCs/K4qM
        e0b+pToBLH913
X-Received: by 2002:ae9:ef48:: with SMTP id d69mr3231871qkg.232.1630590246611;
        Thu, 02 Sep 2021 06:44:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzdTmtzmIqhqv1SiL46ML/7VojNuDfGcPgaJcYW31JCHc0kbak0ynOg7JISUhtrJ42VKof4iA==
X-Received: by 2002:ae9:ef48:: with SMTP id d69mr3231851qkg.232.1630590246376;
        Thu, 02 Sep 2021 06:44:06 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id w11sm1412416qkp.49.2021.09.02.06.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 06:44:06 -0700 (PDT)
Date:   Thu, 2 Sep 2021 15:44:02 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 02/12] KVM: arm64: selftests: Add write_sysreg_s and
 read_sysreg_s
Message-ID: <20210902134402.zihdyigplaxm432o@gator>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-3-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901211412.4171835-3-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 01, 2021 at 09:14:02PM +0000, Raghavendra Rao Ananta wrote:
> For register names that are unsupported by the assembler or the ones
> without architectural names, add the macros write_sysreg_s and
> read_sysreg_s to support them.
> 
> The functionality is derived from kvm-unit-tests and kernel's
> arch/arm64/include/asm/sysreg.h.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../selftests/kvm/include/aarch64/processor.h | 61 +++++++++++++++++++
>  1 file changed, 61 insertions(+)

If we don't replace with an import of arch/arm64/include/asm/sysreg.h

Reviewed-by: Andrew Jones <drjones@redhat.com>

