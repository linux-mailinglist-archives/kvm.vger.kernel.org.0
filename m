Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03B2407CF3
	for <lists+kvm@lfdr.de>; Sun, 12 Sep 2021 12:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbhILKyE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Sep 2021 06:54:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43552 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229635AbhILKyD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 12 Sep 2021 06:54:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631443969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yDakpUmSFyXjuIlV4mL/N0HP20GQTBep5L0kF3rwf+E=;
        b=JYk0pXTen/MYMNNNyeEqwL8qoiUYjbjHPEKNWRpqL3O5lu5e1wcfcdvi5YISGr2tHcAL0X
        h9NWiB50apZ0i56g4u1ZDGUhaKZjzDfY8jPv/CQWOs8Z4X5Nxtgn91qyujB/eROjXOZxEf
        61YFzFWqaYdqO/HUyhTjO1KqjlYGras=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-LKrH9b1dNC25uY-OaPMMww-1; Sun, 12 Sep 2021 06:52:48 -0400
X-MC-Unique: LKrH9b1dNC25uY-OaPMMww-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7205801B3D;
        Sun, 12 Sep 2021 10:52:46 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA8FB5D9D5;
        Sun, 12 Sep 2021 10:52:44 +0000 (UTC)
Message-ID: <71a6464fa0bca675e079f6171296ff5f63cab05c.camel@redhat.com>
Subject: Re: [PATCH 2/2] KVM: x86: Identify vCPU0 by its vcpu_idx instead of
 walking vCPUs array
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sun, 12 Sep 2021 13:52:43 +0300
In-Reply-To: <20210910183220.2397812-3-seanjc@google.com>
References: <20210910183220.2397812-1-seanjc@google.com>
         <20210910183220.2397812-3-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-09-10 at 11:32 -0700, Sean Christopherson wrote:
> Use vcpu_idx to identify vCPU0 when updating HyperV's TSC page, which is
> shared by all vCPUs and "owned" by vCPU0 (because vCPU0 is the only vCPU
> that's guaranteed to exist).  Using kvm_get_vcpu() to find vCPU works,
> but it's a rather odd and suboptimal method to check the index of a given
> vCPU.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 86539c1686fa..6ab851df08d1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2969,7 +2969,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>  				       offsetof(struct compat_vcpu_info, time));
>  	if (vcpu->xen.vcpu_time_info_set)
>  		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_time_info_cache, 0);
> -	if (v == kvm_get_vcpu(v->kvm, 0))
> +	if (!v->vcpu_idx)
>  		kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
>  	return 0;
>  }
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

