Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8140F2DFFD6
	for <lists+kvm@lfdr.de>; Mon, 21 Dec 2020 19:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgLUSdX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Dec 2020 13:33:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55788 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726605AbgLUSdX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Dec 2020 13:33:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608575516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K9FeuGmQgyv7B/8HpfW7JWOxHabUVt0zhGvyltedBTw=;
        b=gGcP59z+4tbX7Hii9YN6Rw03XoG1iagZmMMWgHm7UaDUfLJ4RGehJU42tbymdBAi3H0Afh
        jvf8GcinZ5orwS/i5aUJ2LyW91Mr099gV2lqKcec0L0YV4k8oDtt+gd0iGylVLvP7G5Zcd
        eODSsQJMIaeRCrkogGMvkUH5fPfeWzw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-P77aQcgkPeqSf75tOvCc7g-1; Mon, 21 Dec 2020 13:31:54 -0500
X-MC-Unique: P77aQcgkPeqSf75tOvCc7g-1
Received: by mail-wr1-f71.google.com with SMTP id r11so9292616wrs.23
        for <kvm@vger.kernel.org>; Mon, 21 Dec 2020 10:31:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K9FeuGmQgyv7B/8HpfW7JWOxHabUVt0zhGvyltedBTw=;
        b=VxGEoySoy2ckMCCmu0DYVgn02XiLCAgG0Bap45aMKzQFWHuUzLDyWp49+zIjaWATpm
         zMGVbpQQT8mRfutzm2H+9gbzgMuDDVx8BehQ1ZPOwqKfkchDek1V5PN32vQu+/4/oAOy
         lyIC7cKWw3T+YdDZk+ek3iL3KpVC63C1L3hnq5HggLIW44IXjvi1TOo63nawTMxE1tk0
         77KnMV3Zy4zI9XxBlFlE1vZBdDN6OR41KK/amvXWOK9ZptziLziHN6B4WDuAB0lxOJT8
         Jk7tPO5ToNPjMkmqE5I7zLnD1pwFviGoUXLeaP0BO9FxFA907jbqYyAkbdvvaruepOEg
         UlOg==
X-Gm-Message-State: AOAM533FWZ3okSePaAPc26AC0tmx3RM31mGjZR+LvOrBpmrBQ4mCn8SK
        JPGEKQ47ifmbaGW71tOS9/ZNbKgQ5+kinT/ad6BkoKk+L9/KN8CX5Np2u4P1DyToHZNJVFXVH4i
        4t2z07nO+OhNt
X-Received: by 2002:a5d:62c8:: with SMTP id o8mr20536520wrv.51.1608575513735;
        Mon, 21 Dec 2020 10:31:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwSeg8I2cfYyaGyf0kM/XC//Jnj5R+Jg+aS41jlXlZ40yng81myXCqLuP6DCmIHPLCq7CfQHA==
X-Received: by 2002:a5d:62c8:: with SMTP id o8mr20536508wrv.51.1608575513589;
        Mon, 21 Dec 2020 10:31:53 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u83sm11568628wmu.12.2020.12.21.10.31.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Dec 2020 10:31:52 -0800 (PST)
Subject: Re: [PATCH V3] kvm: check tlbs_dirty directly
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>, stable@vger.kernel.org
References: <X9kEAh7z1rmlmyhZ@google.com>
 <20201217154118.16497-1-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8c5f3503-860d-b3c0-4838-0a4a04f64a47@redhat.com>
Date:   Mon, 21 Dec 2020 19:31:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201217154118.16497-1-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/12/20 16:41, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> In kvm_mmu_notifier_invalidate_range_start(), tlbs_dirty is used as:
>          need_tlb_flush |= kvm->tlbs_dirty;
> with need_tlb_flush's type being int and tlbs_dirty's type being long.
> 
> It means that tlbs_dirty is always used as int and the higher 32 bits
> is useless.  We need to check tlbs_dirty in a correct way and this
> change checks it directly without propagating it to need_tlb_flush.
> 
> Note: it's _extremely_ unlikely this neglecting of higher 32 bits can
> cause problems in practice.  It would require encountering tlbs_dirty
> on a 4 billion count boundary, and KVM would need to be using shadow
> paging or be running a nested guest.
> 
> Cc: stable@vger.kernel.org
> Fixes: a4ee1ca4a36e ("KVM: MMU: delay flush all tlbs on sync_page path")
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
> Changed from V1:
>          Update the patch and the changelog as Sean Christopherson suggested.
> 
> Changed from v2:
> 	don't change the type of need_tlb_flush
> 
>   virt/kvm/kvm_main.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2541a17ff1c4..3083fb53861d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -482,9 +482,8 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
>   	kvm->mmu_notifier_count++;
>   	need_tlb_flush = kvm_unmap_hva_range(kvm, range->start, range->end,
>   					     range->flags);
> -	need_tlb_flush |= kvm->tlbs_dirty;
>   	/* we've to flush the tlb before the pages can be freed */
> -	if (need_tlb_flush)
> +	if (need_tlb_flush || kvm->tlbs_dirty)
>   		kvm_flush_remote_tlbs(kvm);
>   
>   	spin_unlock(&kvm->mmu_lock);
> 

Queued, thanks.

Paolo

