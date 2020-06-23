Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832C6204E95
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 11:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732023AbgFWJ4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 05:56:51 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:58580 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731947AbgFWJ4v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Jun 2020 05:56:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592906210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O5UM4TxpB5bC6Dy8amOmH4CUbYXrhb2b+a7VlTQZxUA=;
        b=X+vgAxYlagdTrCZQOqdsL1z2H6LZ/wa1T8e7yrYzey1Xl6rJ9U1TcdaQQ7ldR6+djnEXkc
        4zLaLTa363POuKjHCDJJPL90PKsj4ABMSgz7eZhDFG/PGqXgr0Rhe4wZHDCicGa73FXprl
        rSDUrNN2PO/PMnYFNwynhsIhuxzktZg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-MHvLdN2kOIC4OxcwXAUQMg-1; Tue, 23 Jun 2020 05:56:48 -0400
X-MC-Unique: MHvLdN2kOIC4OxcwXAUQMg-1
Received: by mail-wm1-f72.google.com with SMTP id g124so3273536wmg.6
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 02:56:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O5UM4TxpB5bC6Dy8amOmH4CUbYXrhb2b+a7VlTQZxUA=;
        b=P+eaqwyfinrtOh2zuxsD1wGms1vULgqRY1Gjpjuc7nDbOAnfTrKsE0JUUrNAIX2lwt
         5P874y6xrCZULYZbY1Rw4AnIvthgjLr9adL3oi1gYQBnaNglwDe+wMHe36+7mjNkW4Na
         F4QpjRg3Y64+klCCs0uCY44rEDAjkct5G52/Z8bIqXooNYCQ0w16izvXeQyyiwLtehLy
         oY2ZY1bw+4l8sTx7oqejFSwwYOGodwTP20uhBHTvPTEh+Rq5M6UBY8HLodDh1mcBEJIy
         a5ywUNnlDVm+1Kx6yi/Za2urrjlM7XdPnqcn/n70NiSbVx1A5X0j/hBn63TJLY4b2/Oi
         G3Uw==
X-Gm-Message-State: AOAM533smbPDkJMGKhp9Pn4gnMKE/P3IOX4reW5sUKalxwa/CLnV5Egt
        b5UhQG2DK0yKU9G7orjSPSF0xiQU4ZfCUhDR7YZbRAUkTovDacSEritu9lIHP1f3JehPXpMnhUy
        vDK2BOLyYU9y9
X-Received: by 2002:a1c:ba0b:: with SMTP id k11mr10510640wmf.140.1592906204306;
        Tue, 23 Jun 2020 02:56:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJylY3afAUQoiCksBpGJmv7AlVnH4Hk70VV+F+Mv6dQYJCxz+xelf4xdNtjl3Ex3cr8Q25X2kw==
X-Received: by 2002:a1c:ba0b:: with SMTP id k11mr10510630wmf.140.1592906204096;
        Tue, 23 Jun 2020 02:56:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:24f5:23b:4085:b879? ([2001:b07:6468:f312:24f5:23b:4085:b879])
        by smtp.gmail.com with ESMTPSA id n16sm15588381wrq.39.2020.06.23.02.56.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 02:56:43 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: x86: allow TSC to differ by NTP correction bounds
 without TSC scaling
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm-devel <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20200615115952.GA224592@fuller.cnet>
 <646f0beb-e050-ed2f-397b-a9afa2891e4f@redhat.com>
 <20200616114741.GA298183@fuller.cnet>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <86cdffd8-a894-7e14-70f7-e5b0b3aceeda@redhat.com>
Date:   Tue, 23 Jun 2020 11:56:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200616114741.GA298183@fuller.cnet>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/06/20 13:47, Marcelo Tosatti wrote:
> v2: improve changelog (Paolo Bonzini)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3156e25..39a6664 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1772,6 +1772,8 @@ static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
>  
>  	/* TSC scaling supported? */
>  	if (!kvm_has_tsc_control) {
> +		if (!scale)
> +			return 0;

This cannot happen, there is an "if (!scale) right above.

>  		if (user_tsc_khz > tsc_khz) {
>  			vcpu->arch.tsc_catchup = 1;
>  			vcpu->arch.tsc_always_catchup = 1;
> @@ -4473,7 +4475,8 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  		r = -EINVAL;
>  		user_tsc_khz = (u32)arg;
>  
> -		if (user_tsc_khz >= kvm_max_guest_tsc_khz)
> +		if (kvm_has_tsc_control &&
> +		    user_tsc_khz >= kvm_max_guest_tsc_khz)
>  			goto out;
>  
>  		if (user_tsc_khz == 0)
> 

Queued this second hunk.

Paolo

