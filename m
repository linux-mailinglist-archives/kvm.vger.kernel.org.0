Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA841D4DCA
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 14:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgEOMgy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 08:36:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24207 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726141AbgEOMgx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 08:36:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589546212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bQaod8vGDpKnxBDT/DSVGXYoEa6QxJoF5n7AJqNgJqw=;
        b=Vf9OJbDDt4FmclmTTY/L91OmtvRbMMngrlllYTxYmYtiwXSFu17TPYjCuH6qb041WxFxay
        QvAh+8dqn7hAQck0sahqSnh/mYo7ppQlMeoXQ8crN4yj0QzaNHf3DdE1cOGxDZUfGDozBs
        Gs+uRa/o2uMkfKbM2vDnHcplUwRQm58=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-CNW53sncPnCC0TsCFStkrQ-1; Fri, 15 May 2020 08:36:50 -0400
X-MC-Unique: CNW53sncPnCC0TsCFStkrQ-1
Received: by mail-wr1-f71.google.com with SMTP id z10so1143045wrs.2
        for <kvm@vger.kernel.org>; Fri, 15 May 2020 05:36:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=bQaod8vGDpKnxBDT/DSVGXYoEa6QxJoF5n7AJqNgJqw=;
        b=p/EfnRO5hDJJesGn3cAG25zORbyBNs73FVatC/4IPkNHWvLQBxZKxpgpviyA8tmkZ3
         BFnnb5DfIUOdC9En/2gT6SxMp+oKnioF2BwdJzed1u11z5OltrnQCaePn4dkba1+pd/S
         JfpZODSBpmbYohbCq+37FO+RpJGeZan/z7AQL5sIAxigSQWPRsdrRJ68b9WXo5Obg0a2
         XNsSMwxDJRDeGzNHcF+/USgTRDJax+pM/UgikNeG2X/hPnkK06JGxSlXj5ObkDkE3ocZ
         fS08KohPV0iiNlJyfdFbYb+d1iiqog18kmfbN5uUCErZr7o9kXmEF2i/+PrUYbA/Kz3y
         zSyg==
X-Gm-Message-State: AOAM531X8l1YCGSmEEi8xyfUNmwXBdK8z0hln8+8MLqnb0fHzg6O08Ig
        qUK9uSXxd4gnnHGf9hTgjQKt0sqZnyjnPmEZOXjbPBQeYXOhC9bkGfYq2MxhyFlxL2XatWyzo+z
        sS9mrdv99q7N+
X-Received: by 2002:adf:e4d0:: with SMTP id v16mr4096100wrm.294.1589546209299;
        Fri, 15 May 2020 05:36:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzeMMyqdlzuB7PvPoi+m+xniBWrqnLTHm+Xr6vdTaGCm4Hb7EFsNHBdsrNneEPGUsF1ivayEg==
X-Received: by 2002:adf:e4d0:: with SMTP id v16mr4096082wrm.294.1589546209118;
        Fri, 15 May 2020 05:36:49 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id 37sm3604512wrk.61.2020.05.15.05.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 05:36:48 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Jue Wang <juew@google.com>, Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86: Fix off-by-one error in kvm_vcpu_ioctl_x86_setup_mce
In-Reply-To: <20200511225616.19557-1-jmattson@google.com>
References: <20200511225616.19557-1-jmattson@google.com>
Date:   Fri, 15 May 2020 14:36:47 +0200
Message-ID: <87r1vlv0gw.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim Mattson <jmattson@google.com> writes:

> Bank_num is a one-based count of banks, not a zero-based index. It
> overflows the allocated space only when strictly greater than
> KVM_MAX_MCE_BANKS.
>
> Fixes: a9e38c3e01ad ("KVM: x86: Catch potential overrun in MCE setup")
> Signed-off-by: Jue Wang <juew@google.com>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d786c7d27ce5..5bf45c9aa8e5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3751,7 +3751,7 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
>  	unsigned bank_num = mcg_cap & 0xff, bank;

/* it would be great to get rid of bare unsigned-s in
kvm_vcpu_ioctl_x86_setup_mce/kvm_vcpu_ioctl_x86_set_mce ... */

>  
>  	r = -EINVAL;
> -	if (!bank_num || bank_num >= KVM_MAX_MCE_BANKS)
> +	if (!bank_num || bank_num > KVM_MAX_MCE_BANKS)
>  		goto out;
>  	if (mcg_cap & ~(kvm_mce_cap_supported | 0xff | 0xff0000))
>  		goto out;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

