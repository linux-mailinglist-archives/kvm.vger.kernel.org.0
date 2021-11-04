Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9440744575F
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 17:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbhKDQnm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 12:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbhKDQnl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 12:43:41 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5273C061714
        for <kvm@vger.kernel.org>; Thu,  4 Nov 2021 09:41:03 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id d70so6664433iof.7
        for <kvm@vger.kernel.org>; Thu, 04 Nov 2021 09:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n89uubugbDSS31fmjZBPGlZmDbloGpPz8qHQD795FjI=;
        b=KNVu5VlvLHC8LhEZJ1GeRcJxuhRBVKjlxW5S2JjtSy5YETOQgBq1h80cs+LZg6Jrqq
         66dkdvi1vERwy7tSwNjJJVnGC2YPONc/uMbJ8F9Wt//VhGN6Bgfy8P2/BCYZxXwZk3R1
         7jjndXad3DE+ZzFuwchi2YDL6NCF1UmgjvK3EPTDCGF0KzmaGIJ/cw9u2JnrLEGcIgDg
         cihXdT1LQ2nQkR3V/olZ2iTMpBSX9YF6CSg3qCUxleBhwC0c3O7A8Lxw++Oo16bEWP0T
         uWk4JRKXYmVcJKvDWra+KeLtBtGZVMafA4/kDPlmmu698FI0WE5rTmE9w86bcHEGsQeS
         mO2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n89uubugbDSS31fmjZBPGlZmDbloGpPz8qHQD795FjI=;
        b=QpUZCliC/KBaJn9pHwUAPT46E4QYIqWX8/RpMmrSZrwDvrMlOe6WLvpwBSOXt+HH0V
         nynkEN4W52V9v+R7p4R8Zb0jM7rZkW0FaOvhrg/pyEz0If8qv/P+r/6LMXnyTjTncMud
         Io8ktO1xPWILCtrYLjkEnLuAROwzL3VyPnsWYzitNFa7536UKEWd6PREFQA/LtmjW0Qf
         gZ68qdpU0sc6hO5WlZMy7HuJ77dU+ahZaWR8xaotZ+alBKh9NpaYctq1as9k/6EzQk2U
         aTnaUM6ts8xbHB0ISpMBVQWGh7Z1uqr+0hDUGPx6Huzp3TdMHK/7OD3h7liLjpO8yVrM
         IZFg==
X-Gm-Message-State: AOAM533S7AdGxlkNARTVPIXEuTCvxL3cUq3bEXMmemFToGxU/yOPjXFp
        D39/iPZQx+c7g0UYiTKbpsKceQ==
X-Google-Smtp-Source: ABdhPJzhfKc56+AGehB6rwlydFBdwcHeviUbHIFnDTRU6KIyTbtZIkuuDhw1XuIj5pRTYfxo6B4M8Q==
X-Received: by 2002:a5e:8c05:: with SMTP id n5mr6480970ioj.0.1636044062919;
        Thu, 04 Nov 2021 09:41:02 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id u12sm1074124iop.52.2021.11.04.09.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 09:41:02 -0700 (PDT)
Date:   Thu, 4 Nov 2021 16:40:58 +0000
From:   Oliver Upton <oupton@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [RFC PATCH v2 18/28] KVM: arm64: Introduce
 KVM_CAP_ARM_ID_REG_WRITABLE capability
Message-ID: <YYQNGqpy1NiUEXYD@google.com>
References: <20211103062520.1445832-1-reijiw@google.com>
 <20211103062520.1445832-19-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103062520.1445832-19-reijiw@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 02, 2021 at 11:25:10PM -0700, Reiji Watanabe wrote:
> Introduce a new capability KVM_CAP_ARM_ID_REG_WRITABLE to indicate
> that ID registers are writable by userspace.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 8 ++++++++
>  arch/arm64/kvm/arm.c           | 1 +
>  include/uapi/linux/kvm.h       | 1 +
>  3 files changed, 10 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index a6729c8cf063..f7dfb5127310 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7265,3 +7265,11 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
>  of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
>  the hypercalls whose corresponding bit is in the argument, and return
>  ENOSYS for the others.
> +
> +8.35 KVM_CAP_ARM_ID_REG_WRITABLE
> +--------------------------------

ID registers are technically already writable, KVM just rejects any
value other than what it derives from sanitising the host ID registers.
I agree that the nuance being added warrants a KVM_CAP, as it informs
userspace it can deliberately configure ID registers with a more limited
value than what KVM returns.

KVM_CAP_ARM_ID_REG_CONFIGURABLE maybe? Naming is hard :)

--
Thanks,
Oliver
