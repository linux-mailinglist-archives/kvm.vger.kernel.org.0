Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65E44045DE
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 08:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351201AbhIIG52 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 02:57:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20442 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234638AbhIIG51 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 02:57:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631170577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qscILqSOiDtHr2K06miwU5XrXdXBp14iQB45BddDnqs=;
        b=Pi9IH1dd2snhxt33vMQURL0Q6o0jDjkJZMBo8k6Mz5Xcnzvj0Ym8mU3uH8FgEo4qIj6KPq
        CtKHd0WcV6nLStStidN/Trj2raBHqngalcxGE8zmxG4Z0Ij7sd3E0MqfqWGwDBbMiYni+V
        34kdSCZqf656uxr5PN0JcJBe7le+GdM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-Xvtn3jhOO3K6aHmroD5jVw-1; Thu, 09 Sep 2021 02:56:16 -0400
X-MC-Unique: Xvtn3jhOO3K6aHmroD5jVw-1
Received: by mail-ed1-f71.google.com with SMTP id g4-20020a056402180400b003c2e8da869bso472740edy.13
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 23:56:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qscILqSOiDtHr2K06miwU5XrXdXBp14iQB45BddDnqs=;
        b=MSPh/izh6X79OB2eaZQHxz6V0nMo5bcLZpHMb8172TwQblJlYrhSCDKG19pZCbotrc
         VpuF45epV/0WU1rH0ekB/PXwwFmuvf9+NdWrPECua7ESALDtEtqqWBvFCATQfL5Jv1OF
         FgHXdrEjwXbQrJIk0w/KUpLIw8BvApWNFcshyKM+GSUfSMEGh3yo4jS6H1QkwblnFYr9
         eq20ORWnIO9JmX/SyFc7fqz6dtgrNDQnap2YvPeooYbfIK/r2tbco2IEpo6VBxtt7FOb
         b6aLZHNrBKz28mRraFnAIfsXAh5KOIdLID1WTG+AR+fTZJM4Mw/IHotsQTvj7pOGwfwI
         EI5w==
X-Gm-Message-State: AOAM533L8hdFMDwYmdIbIJHKw08DYKKRId11O/5Aj3yI5raBLb5/WDii
        X7KVbb8DwKNYSxio1ub/9jBpeU6dGq8WRhJ3morr6hQkfmHjMsRTenL4yp3rK9i0V2wxUoYRgSL
        rhGR/c42dnXcb
X-Received: by 2002:a17:906:adb:: with SMTP id z27mr1768630ejf.235.1631170575550;
        Wed, 08 Sep 2021 23:56:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzpo2+DqJ1Q+SdKK5uQrU7ZDb5hL1qYXbG3ULjiHa/exReDGCf5X1iUjVNkVgI9sq45uc1HcA==
X-Received: by 2002:a17:906:adb:: with SMTP id z27mr1768615ejf.235.1631170575371;
        Wed, 08 Sep 2021 23:56:15 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id c21sm381830ejz.69.2021.09.08.23.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 23:56:15 -0700 (PDT)
Date:   Thu, 9 Sep 2021 08:56:12 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 03/18] KVM: arm64: selftests: Use read/write
 definitions from sysreg.h
Message-ID: <20210909065612.d36255fur5alf6sl@gator>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-4-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909013818.1191270-4-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 09, 2021 at 01:38:03AM +0000, Raghavendra Rao Ananta wrote:
> Make use of the register read/write definitions from
> sysreg.h, instead of the existing definitions. A syntax
> correction is needed for the files that use write_sysreg()
> to make it compliant with the new (kernel's) syntax.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../selftests/kvm/aarch64/debug-exceptions.c  | 28 +++++++++----------
>  .../selftests/kvm/include/aarch64/processor.h | 13 +--------
>  2 files changed, 15 insertions(+), 26 deletions(-)
>

Same comment as Oliver, otherwise

Reviewed-by: Andrew Jones <drjones@redhat.com>

