Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A481C15066D
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 13:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgBCMzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 07:55:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26327 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727363AbgBCMzr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Feb 2020 07:55:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580734546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PKYTrZ2l9XDKCKxWTKQUHgKqQscinAEepYElS6s2GdY=;
        b=HaBiy+harC8QOQvwgxRoYFK9UU29EtYB7TqLQI+IwIWaTQsjzl004H9vjcfVSyW+NFJ3vd
        BaMSnyeY2lTR9WYgNEWR7bnypZrc5BPEXN7PpXllVhDvpx5afVCiQG8xNp9VlRimLx7f9P
        PJA+dvggHqggvYlRX0e2NcxffglUZ9U=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-0lhrlk7oNs6Thd3hDJE4zg-1; Mon, 03 Feb 2020 07:55:43 -0500
X-MC-Unique: 0lhrlk7oNs6Thd3hDJE4zg-1
Received: by mail-wr1-f69.google.com with SMTP id a12so6508101wrn.19
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2020 04:55:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=PKYTrZ2l9XDKCKxWTKQUHgKqQscinAEepYElS6s2GdY=;
        b=rB0mq0A8WQRBfI6r/g3ZI4oFSQ7MK3WIx1zheE1JiwdRPOhs0fPMkQQq5EdtwGm+Oz
         hJRwClpY5tAQOLv2yCp9vFP7H8imIvqGxsdNM2r+JFSNEsvCsJcrA+kYuBbLA4ZwsiR2
         9uP6rXUEEUzoRv5ftpEdmf7x5iOg6BKHMw1LmRrQ+LtRSHfMzVqFMVnJYiNlYUPxsDEr
         W2Q9OudtHmb7cuWHzkMHJM2eK/O43ac8/0dcDZ0CM1z9N00J6VDiqC3An95BsHab4Npp
         Gjczt8Jfw/voZ6xS1J8qGxvtJJaCSh2e2iVFjOpFjQ7cbBcPZybkn1eUK1jxZIU5wZcd
         Zp/Q==
X-Gm-Message-State: APjAAAUJHme97NDlDnC8VUAy0mgb1A+MhOqnKubX9ADfr/rL6RyQQriA
        BAQORfJ2FgjCXY3hiG4xplp4hhW2d9Fixjzr7rKcAVOr4YCGBwkEexNVi3CQQXEWgnqRnhTTfLW
        rGrX16crzp4BN
X-Received: by 2002:adf:fd8d:: with SMTP id d13mr15561238wrr.208.1580734541933;
        Mon, 03 Feb 2020 04:55:41 -0800 (PST)
X-Google-Smtp-Source: APXvYqzuXwumKXy69ZvsnWkYM1n/3TsEHbX5cfQn3xjEJOebm44QI5GW+cGW67maRdHtBrct5bZLYg==
X-Received: by 2002:adf:fd8d:: with SMTP id d13mr15561190wrr.208.1580734541492;
        Mon, 03 Feb 2020 04:55:41 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id r5sm25434161wrt.43.2020.02.03.04.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 04:55:40 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 01/61] KVM: x86: Return -E2BIG when KVM_GET_SUPPORTED_CPUID hits max entries
In-Reply-To: <20200201185218.24473-2-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-2-sean.j.christopherson@intel.com>
Date:   Mon, 03 Feb 2020 13:55:40 +0100
Message-ID: <87mu9zomnn.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Fix a long-standing bug that causes KVM to return 0 instead of -E2BIG
> when userspace's array is insufficiently sized.
>
> Note, while the Fixes: tag is accurate with respect to the immediate
> bug, it's likely that similar bugs in KVM_GET_SUPPORTED_CPUID existed
> prior to the refactoring, e.g. Qemu contains a workaround for the broken
> KVM_GET_SUPPORTED_CPUID behavior that predates the buggy commit by over
> two years.  The Qemu workaround is also likely the main reason the bug
> has gone unreported for so long.
>
> Qemu hack:
>   commit 76ae317f7c16aec6b469604b1764094870a75470
>   Author: Mark McLoughlin <markmc@redhat.com>
>   Date:   Tue May 19 18:55:21 2009 +0100
>
>     kvm: work around supported cpuid ioctl() brokenness
>
>     KVM_GET_SUPPORTED_CPUID has been known to fail to return -E2BIG
>     when it runs out of entries. Detect this by always trying again
>     with a bigger table if the ioctl() fills the table.
>
> Fixes: 831bf664e9c1f ("KVM: Refactor and simplify kvm_dev_ioctl_get_supported_cpuid")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index b1c469446b07..47ce04762c20 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -908,9 +908,14 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
>  			goto out_free;
>  
>  		limit = cpuid_entries[nent - 1].eax;
> -		for (func = ent->func + 1; func <= limit && nent < cpuid->nent && r == 0; ++func)
> +		for (func = ent->func + 1; func <= limit && r == 0; ++func) {
> +			if (nent >= cpuid->nent) {
> +				r = -E2BIG;
> +				goto out_free;
> +			}
>  			r = do_cpuid_func(&cpuid_entries[nent], func,
>  				          &nent, cpuid->nent, type);
> +		}
>  
>  		if (r)
>  			goto out_free;

Is fixing a bug a valid reason for breaking buggy userspace? :-)
Personally, I think so. In particular, here the change is both the
return value and the fact that we don't do copy_to_user() anymore so I
think it's possible to meet a userspace which is going to get broken by
the change.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

