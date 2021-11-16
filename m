Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 978CE453682
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 16:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238406AbhKPP7d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 10:59:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49236 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238600AbhKPP7Z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 10:59:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637078188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IYjmDSV8dzVk4xxOpkYTr8JcJ3dKIZk0CzJQ1P41h54=;
        b=QLZhkerjMuiJalVA/vKV4NpouehHrnKPCzMiAnFWmF0y1fzaA2E6Gnqa6sR6gyMMSfCvy/
        yylLETNTFHAlW5Fw6OeyjsiERnYIEma0Ul7U5YPVnTbdvnxsVqU6x44ZpWHOWPZ3Fg66zb
        F//sxosPZi61YZnyG+pBVIrjqqAQnwo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-fsGljFwzPNmdcylU3ASwkQ-1; Tue, 16 Nov 2021 10:56:26 -0500
X-MC-Unique: fsGljFwzPNmdcylU3ASwkQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8F16420E7;
        Tue, 16 Nov 2021 15:56:25 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0048C5F4EE;
        Tue, 16 Nov 2021 15:56:24 +0000 (UTC)
Message-ID: <8881d7b4-0c31-cafd-1158-0d42c1c7f43a@redhat.com>
Date:   Tue, 16 Nov 2021 16:56:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] KVM: Fix the warning by the min()
Content-Language: en-US
To:     zhaoxiao <zhaoxiao@uniontech.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211116121014.1675-1-zhaoxiao@uniontech.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211116121014.1675-1-zhaoxiao@uniontech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 13:10, zhaoxiao wrote:
> Fix following coccicheck warning:
> virt/kvm/kvm_main.c:4995:10-11: WARNING opportunity for min()
> virt/kvm/kvm_main.c:4924:10-11: WARNING opportunity for min()
> 
> Signed-off-by: zhaoxiao <zhaoxiao@uniontech.com>

No, this is unreadable for two reasons:

First, the code in parentheses for min(func(), 0) is very long.  Usually 
min has very short arguments. By the time you have reached the closing 
parentheses, you have completely forgotten that there was a min() at the 
beginning.  So perhaps one possibility could be

	return min(r, 0);

However, the second reason is that "r < 0" is a very common way to 
express "if there was an error".  In this case that would be

	r = __kvm_io_bus_write(vcpu, bus, &range, val);
	if (r < 0)		// "if __kvm_io_bus_write failed"
		return r;

	return 0;

That "r < 0" is what will catch the attention of the person that is 
reading the code, no matter if it is an "if" or (as in the existing 
code), a "return".  Using "min" removes the idiom that tells the person 
"this is checking for errors".

Thanks,

Paolo

> ---
>   virt/kvm/kvm_main.c | 10 ++++------
>   1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d31724500501..bd646c64722d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4910,7 +4910,6 @@ int kvm_io_bus_write(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
>   {
>   	struct kvm_io_bus *bus;
>   	struct kvm_io_range range;
> -	int r;
>   
>   	range = (struct kvm_io_range) {
>   		.addr = addr,
> @@ -4920,8 +4919,8 @@ int kvm_io_bus_write(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
>   	bus = srcu_dereference(vcpu->kvm->buses[bus_idx], &vcpu->kvm->srcu);
>   	if (!bus)
>   		return -ENOMEM;
> -	r = __kvm_io_bus_write(vcpu, bus, &range, val);
> -	return r < 0 ? r : 0;
> +
> +	return min(__kvm_io_bus_write(vcpu, bus, &range, val), 0);
>   }
>   EXPORT_SYMBOL_GPL(kvm_io_bus_write);
>   
> @@ -4981,7 +4980,6 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
>   {
>   	struct kvm_io_bus *bus;
>   	struct kvm_io_range range;
> -	int r;
>   
>   	range = (struct kvm_io_range) {
>   		.addr = addr,
> @@ -4991,8 +4989,8 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
>   	bus = srcu_dereference(vcpu->kvm->buses[bus_idx], &vcpu->kvm->srcu);
>   	if (!bus)
>   		return -ENOMEM;
> -	r = __kvm_io_bus_read(vcpu, bus, &range, val);
> -	return r < 0 ? r : 0;
> +
> +	return min(__kvm_io_bus_read(vcpu, bus, &range, val), 0);
>   }
>   
>   /* Caller must hold slots_lock. */
> 

