Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1430A3FEF9A
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 16:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345546AbhIBOoa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 10:44:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55689 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345401AbhIBOo2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Sep 2021 10:44:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630593809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fHO5Tzwhao5TiABrZCBAUisQfo436W0ONUMzhgH6h6s=;
        b=BxSroMcTIYvGGurcloBi3/Gy8HT2smMkbMhawo9LdyNrH+OoMXcEuQpqtW4f1tGLVfYN2M
        IGzkPC4KBNmxDZ/Ulk7crT/xQeXUahX87g9dJ8l60/suvU72I0JypwBc2orvQcT8AVG5LF
        kflVBJlblGu5mB3pxWipQfE74o/6GK4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-577-zo0MmISaNDiblYBgnOHqXw-1; Thu, 02 Sep 2021 10:43:28 -0400
X-MC-Unique: zo0MmISaNDiblYBgnOHqXw-1
Received: by mail-wm1-f69.google.com with SMTP id p5-20020a7bcc85000000b002e7563efc4cso783486wma.4
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 07:43:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fHO5Tzwhao5TiABrZCBAUisQfo436W0ONUMzhgH6h6s=;
        b=jBFHHowSPBNZqoHVGgnbRIBuO+10tBrsK6ghiBDqvav3uxCJQoxYmOox85lQLkpZ1F
         xsPKbCqv5zvtHE0pH5FE+ou74GWv1jywhbDDNVPfPgtO0m6+fwxqVxThKxAzyVlB4dWs
         vGGAmR4Zef44u4vE2jHtpbIDBiF9WBT1sBIergSawLjm38JCA5xAVhDXyAr16ryl+S55
         kYZvrPnKluQnHpCARnUiObZZd9PNKLnpraHl6bZ9Bv5kYm3++3mILpMKFcwCzLoVcR8G
         DtbvHF1lYFiXyzEF2nKsJ2Rf1mT+1V70uSfNOed+X+PwrMxvaAUZVP7IDfLw7jSAxHfC
         16vg==
X-Gm-Message-State: AOAM533esX0VQWYv15GSShKRefkdUte2PhWZrC0Y0bIBVfe8Gd/bAqx/
        gp/5T3geRncx4RmKpqJCvtjyURATkrUuAbCiqTfGGHmxuybHIJzCKc+2iJoIyW0yyPtM4L6YGE2
        cXCZim4ScmtD0
X-Received: by 2002:adf:d185:: with SMTP id v5mr4114897wrc.378.1630593807497;
        Thu, 02 Sep 2021 07:43:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwAITxf/zsmp3O/FLDDlzAAMda3pWOdK4AMw/uZTLp2t5nLI+RKcceAMXP4cp6k6aVrvMWRkw==
X-Received: by 2002:adf:d185:: with SMTP id v5mr4114878wrc.378.1630593807374;
        Thu, 02 Sep 2021 07:43:27 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id p4sm1786988wmc.11.2021.09.02.07.43.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 07:43:27 -0700 (PDT)
Date:   Thu, 2 Sep 2021 16:43:25 +0200
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
Subject: Re: [PATCH v3 06/12] KVM: arm64: selftests: Add support to disable
 and enable local IRQs
Message-ID: <20210902144325.c3beg3qqnfdwj6um@gator>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-7-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901211412.4171835-7-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 01, 2021 at 09:14:06PM +0000, Raghavendra Rao Ananta wrote:
> Add functions local_irq_enable() and local_irq_disable() to
> enable and disable the IRQs from the guest, respectively.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../testing/selftests/kvm/include/aarch64/processor.h  | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

