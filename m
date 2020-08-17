Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEC724615E
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 10:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728460AbgHQIxL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 04:53:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26751 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727921AbgHQIxK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 04:53:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597654389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0YghR5Mms8jHBUWQxThuVTLlaBCYQmrwY5aHeC7UwVY=;
        b=an7O0aBsWCgLmaoRMMhgf6p/ja2PpOG8Nk++ie1nAq9bqqUbxqpoPJ9tnlhrxt4kqMBvfB
        LCiZTEW+21OkbA63xkBlfh3CI24KPUP0CcUHz9G3RMmYq7czqgH5rdXYOfdEcp4zo5BM5Q
        riF8PydvAgO/07SJqJOXVknF0lUvFss=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-M9b1GrjmO6u9o76KkD9vjw-1; Mon, 17 Aug 2020 04:53:05 -0400
X-MC-Unique: M9b1GrjmO6u9o76KkD9vjw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E445425EF;
        Mon, 17 Aug 2020 08:53:03 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.210])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B4A4100EBA4;
        Mon, 17 Aug 2020 08:53:00 +0000 (UTC)
Date:   Mon, 17 Aug 2020 10:52:57 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Steven Price <steven.price@arm.com>, wanghaibin.wang@huawei.com
Subject: Re: [PATCH 3/3] KVM: arm64: Use kvm_write_guest_lock when init
 stolen time
Message-ID: <20200817085257.k3i2nyhqn2nwdotx@kamzik.brq.redhat.com>
References: <20200817033729.10848-1-zhukeqian1@huawei.com>
 <20200817033729.10848-4-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200817033729.10848-4-zhukeqian1@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 17, 2020 at 11:37:29AM +0800, Keqian Zhu wrote:
> There is a lock version kvm_write_guest. Use it to simplify code.
> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  arch/arm64/kvm/pvtime.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
> index f7b52ce..2b24e7f 100644
> --- a/arch/arm64/kvm/pvtime.c
> +++ b/arch/arm64/kvm/pvtime.c
> @@ -55,7 +55,6 @@ gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu)
>  	struct pvclock_vcpu_stolen_time init_values = {};
>  	struct kvm *kvm = vcpu->kvm;
>  	u64 base = vcpu->arch.steal.base;
> -	int idx;
>  
>  	if (base == GPA_INVALID)
>  		return base;
> @@ -66,10 +65,7 @@ gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu)
>  	 */
>  	vcpu->arch.steal.steal = 0;
>  	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
> -
> -	idx = srcu_read_lock(&kvm->srcu);
> -	kvm_write_guest(kvm, base, &init_values, sizeof(init_values));
> -	srcu_read_unlock(&kvm->srcu, idx);
> +	kvm_write_guest_lock(kvm, base, &init_values, sizeof(init_values));
>  
>  	return base;
>  }
> -- 
> 1.8.3.1
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

