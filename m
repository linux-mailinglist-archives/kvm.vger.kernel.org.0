Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE0CA10C584
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 09:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbfK1I5H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 03:57:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24743 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727305AbfK1I5H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 03:57:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574931426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UTqyxfqplr5cCVGYbvk1+6dr+xn0FSeXRHiQCzbM5Do=;
        b=gLy9OlMfaMj5GVvF5/GIc3JFmn9VlDnDDzCGMETRVFHDBgwHwyw+NDQgXrVB2QWM5QZwHV
        kwqhyYHvVmQ9b08JPAA44jEpVJ0xLLJUjNyj/YTN+EZ9qHIlNOT8i+sTQj2fjeqxXRLBvh
        ApAYcVboUsuv3v5B+RgsboaMkeruG68=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-tdG362LsNXq1vxkm-wtRyA-1; Thu, 28 Nov 2019 03:57:04 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5381018B9FC1;
        Thu, 28 Nov 2019 08:57:02 +0000 (UTC)
Received: from [10.36.116.37] (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B57B600C8;
        Thu, 28 Nov 2019 08:56:56 +0000 (UTC)
Subject: Re: [PATCH] KVM: arm64: eliminate unnecessary var err and jump label
 in set_core_reg()
To:     linmiaohe <linmiaohe@huawei.com>, maz@kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        christoffer.dall@arm.com, catalin.marinas@arm.com,
        gregkh@linuxfoundation.org, will@kernel.org,
        andre.przywara@arm.com, tglx@linutronix.de
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <1574910598-14468-1-git-send-email-linmiaohe@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <7210b73f-66a0-e276-74b4-83d011b57d21@redhat.com>
Date:   Thu, 28 Nov 2019 09:56:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1574910598-14468-1-git-send-email-linmiaohe@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: tdG362LsNXq1vxkm-wtRyA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 11/28/19 4:09 AM, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> The var err and jump label out isn't really needed in
> set_core_reg(). Clean them up.
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  arch/arm64/kvm/guest.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 3b836c91609e..88eb6e5399ed 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -159,7 +159,6 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  	__uint128_t tmp;
>  	void *valp = &tmp;
>  	u64 off;
> -	int err = 0;
>  
>  	/* Our ID is an index into the kvm_regs struct. */
>  	off = core_reg_offset_from_id(reg->id);
> @@ -173,10 +172,8 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  	if (KVM_REG_SIZE(reg->id) > sizeof(tmp))
>  		return -EINVAL;
>  
> -	if (copy_from_user(valp, uaddr, KVM_REG_SIZE(reg->id))) {
> -		err = -EFAULT;
> -		goto out;
> -	}
> +	if (copy_from_user(valp, uaddr, KVM_REG_SIZE(reg->id)))
> +		return -EFAULT;
>  
>  	if (off == KVM_REG_ARM_CORE_REG(regs.pstate)) {
>  		u64 mode = (*(u64 *)valp) & PSR_AA32_MODE_MASK;
> @@ -200,14 +197,12 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  				return -EINVAL;
>  			break;
>  		default:
> -			err = -EINVAL;
> -			goto out;
> +			return -EINVAL;
>  		}
>  	}
>  
>  	memcpy((u32 *)regs + off, valp, KVM_REG_SIZE(reg->id));
> -out:
> -	return err;
> +	return 0;
>  }
>  
>  #define vq_word(vq) (((vq) - SVE_VQ_MIN) / 64)
> 

