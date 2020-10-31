Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6752A180E
	for <lists+kvm@lfdr.de>; Sat, 31 Oct 2020 15:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727746AbgJaOHH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 31 Oct 2020 10:07:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35639 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727535AbgJaOHG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 31 Oct 2020 10:07:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604153225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xMiipHhMwnl5lpPS75itYpq+OfzfMobaQ3Fe/heX+4E=;
        b=YM/5mknq39hDqAzOlc746qTI7wlyMgquTqPFHzgIJur/p9TIlNC5OQ2emj7t/VycGIAjVM
        glaV+jPzYt1S+QV7QvIpFc3G0V6ph1knAV4QoaoWnN1i+nmTocxYU6U6cj9UxIud1tjpN0
        R+EhAZwbtOp6tgDXJ+hcXp5Xt3eZoEo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-2V0-0rieM7O24fR9kIAq-w-1; Sat, 31 Oct 2020 10:07:03 -0400
X-MC-Unique: 2V0-0rieM7O24fR9kIAq-w-1
Received: by mail-wr1-f71.google.com with SMTP id t17so4054538wrm.13
        for <kvm@vger.kernel.org>; Sat, 31 Oct 2020 07:07:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xMiipHhMwnl5lpPS75itYpq+OfzfMobaQ3Fe/heX+4E=;
        b=h491ZzRh3FhJT9ZUD+/JbVjnhleEAIakxWdgkgwuTVxCRJY0DvCD07kjzH1VevUXlq
         gzGKyNSbcWjZh3A6ouKWkdXJmU9kM9+hE6+75r02+K9pCb2Vf0fwTrd0+C3HPU0On+ij
         P0curEKoZqTer3El+Erowhgp8nzzJ7+FhW68cZc6+1BnzR0N69vhnWHA+dvGe6ANjHt3
         k3KkKAB0UPqSThD7CwOl6beZCX7TM5GUCg/L/uYQcAHUdnkQ8NSlaF2h5xWFzwFepP6S
         8i5DZnhuMi7GAJ6QNvXdHLI6t66Y1MeCfCHz2rkHjfqLhv6QyacumUbHb0hcG2cCKQEF
         Vhog==
X-Gm-Message-State: AOAM530gYvVPJkR5q+UjJG09aSd8L+VHg03SbkvUaywgAVowRAn/kRZw
        qBfgJNWRA0svGiw/B2PooWXvDijjhPni7ze/JeLQ0psbyUkZIeEAfTL1Y1FOF0sVDZ1EQvmbEGZ
        URkqZY1Qwt4i1
X-Received: by 2002:a5d:63c3:: with SMTP id c3mr9385758wrw.315.1604153221971;
        Sat, 31 Oct 2020 07:07:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzkJpxxa2iscAGu8SNcNjP75DAejMNfb47sfZpoaSDn3Ceet8CtSjjL+8fUI8eGR41Z3xuORA==
X-Received: by 2002:a5d:63c3:: with SMTP id c3mr9385742wrw.315.1604153221815;
        Sat, 31 Oct 2020 07:07:01 -0700 (PDT)
Received: from [192.168.178.64] ([151.20.250.56])
        by smtp.gmail.com with ESMTPSA id c10sm6473164wrx.13.2020.10.31.07.07.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2020 07:07:01 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: X86: Fix null pointer reference for KVM_GET_MSRS
To:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Steffen Dirkwinkel <kernel-bugs@steffen.cc>
References: <20201025185334.389061-1-peterx@redhat.com>
 <20201025185334.389061-3-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c20d7c85-b2f3-608a-833f-093363fac5f5@redhat.com>
Date:   Sat, 31 Oct 2020 15:06:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201025185334.389061-3-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/10/20 19:53, Peter Xu wrote:
> kvm_msr_ignored_check() could trigger a null pointer reference if ignore_msrs=Y
> and report_ignore_msrs=Y when try to fetch an invalid feature msr using the
> global KVM_GET_MSRS.  Degrade the error report to not rely on vcpu since that
> information (index, rip) is not as important as msr index/data after all.
> 
> Fixes: 12bc2132b15e0a96
> Reported-by: Steffen Dirkwinkel <kernel-bugs@steffen.cc>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ce856e0ece84..5993fbd6d2c5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -259,8 +259,8 @@ static int kvm_msr_ignored_check(struct kvm_vcpu *vcpu, u32 msr,
>  
>  	if (ignore_msrs) {
>  		if (report_ignored_msrs)
> -			vcpu_unimpl(vcpu, "ignored %s: 0x%x data 0x%llx\n",
> -				    op, msr, data);
> +			kvm_pr_unimpl("ignored %s: 0x%x data 0x%llx\n",
> +				      op, msr, data);
>  		/* Mask the error */
>  		return 0;
>  	} else {
> 

I committed Takashi Iwai's very similar patch.  Please resend 1/2 with
reviewer comments addressed, thanks!

Paolo

