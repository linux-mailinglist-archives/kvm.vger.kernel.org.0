Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930DC47E664
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 17:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349198AbhLWQdB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 11:33:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:22294 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244178AbhLWQdA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Dec 2021 11:33:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640277179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0L0+tsspM3Sr4bIkDveJ5wOCn0r+niWRUrhQ1sw4e1M=;
        b=ddLsS/AqpzRNltj2Ld+2azrfZk99QVsaYU0LP+8YDReo6ffe/1GMV1xxLWV6neyfDqk7P9
        XXdioVvh20fNRlQrSxtauVUq8ZQAmOS2UiF6UgnaqZUSJz6vUrWFAP4Sx3NQL7vmr8UVPW
        eHlanHejAB9cvnzfRA5Kl7A1CfoqelE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-85-ogT73SOTN_a9nmQOdpEbiQ-1; Thu, 23 Dec 2021 11:32:58 -0500
X-MC-Unique: ogT73SOTN_a9nmQOdpEbiQ-1
Received: by mail-ed1-f70.google.com with SMTP id c19-20020a05640227d300b003f81c7154fbso4898723ede.7
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 08:32:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0L0+tsspM3Sr4bIkDveJ5wOCn0r+niWRUrhQ1sw4e1M=;
        b=H0svp5OLMTLkwEMUB24X7XG9/YWfDIurW6ffKOznwS6Pe7IaovalwZ2IuGUQJnM1+9
         C5Dp2EjzRFdOxSICC5qerZ3t40yYtSsewMuhBYJ+3c4mLltxE1i8GLYFkk+6cge5PR1L
         cEc3zUyWQfA/xl/SI1CtLhxXZdz2/IQDJYuF8lPT2Gmcxxq4kFEqq/nlyqhxCwJc3Y4X
         NQT/aX1aUYcQboVlVrq7EwxBnLvf568Jb+uQuUUQDo9bWIF5BsXVUmPkZ8v5nceinAGJ
         R1dlXF5NuiY9Db194zYOlMEL8EXb6QCUL7fjydPEp4VQOOkunepX8ikVeHgSTAPZsmeu
         FJew==
X-Gm-Message-State: AOAM531ulOGCGRuDGY7/lpdQUIZExV6EkBxMCrtJbPj5uSiyZHz9vW/n
        sdlQidNAfHezaivX3KmrCSSNYfOdbHR76dlTBUZEnBVtYn6vfAKBKhq5b1t8qCgKRlo4+bIH0m1
        b+wnix4bk+mmt
X-Received: by 2002:a17:906:794c:: with SMTP id l12mr2664829ejo.300.1640277177611;
        Thu, 23 Dec 2021 08:32:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJykALJDGO3IeZ2oWghmdAmCC8/3tAVh7kAZddXvgesDgLY3AvQZPm7lC8xcpGxYNve1X+MJEA==
X-Received: by 2002:a17:906:794c:: with SMTP id l12mr2664815ejo.300.1640277177399;
        Thu, 23 Dec 2021 08:32:57 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id u21sm2164756eds.8.2021.12.23.08.32.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 08:32:57 -0800 (PST)
Date:   Thu, 23 Dec 2021 17:32:55 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: Re: [PATCH 5/5] KVM: selftests: arm64: Add support for
 VM_MODE_P36V48_{4K,64K}
Message-ID: <20211223163255.vzjvlwkicsvgzfbx@gator.home>
References: <20211216123135.754114-1-maz@kernel.org>
 <20211216123135.754114-6-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211216123135.754114-6-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 16, 2021 at 12:31:35PM +0000, Marc Zyngier wrote:
> Some of the arm64 systems out there have an IPA space that is
> positively tiny. Nonetheless, they make great KVM hosts.
> 
> Add support for 36bit IPA support with 4kB pages, which makes
> some of the fruity machines happy. Whilst we're at it, add support
> for 64kB pages as well, though these boxes have no support for it.
> 
> 16kB is left as a exercise for the eager reviewer.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h      | 2 ++
>  tools/testing/selftests/kvm/lib/aarch64/processor.c | 8 ++++++++
>  tools/testing/selftests/kvm/lib/guest_modes.c       | 4 ++++
>  tools/testing/selftests/kvm/lib/kvm_util.c          | 6 ++++++
>  4 files changed, 20 insertions(+)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

