Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07863432F49
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 09:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbhJSHZv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 03:25:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53648 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229584AbhJSHZv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Oct 2021 03:25:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634628218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P9lMPKELEtAjTfOQS27eJYanNr/naiOHvH+IE9qUoS0=;
        b=KoQt/FOMYHTnt1UHCGR5rNzTEHmrJThSLbOJ27cyERYGREFCGw0CgQUd7YQOVWwIYNNe+w
        aYeKj384GhiB5l+GLmflTXVWwKXFtAgx9GBhWyyI/0XGCKN7pIEiXNRxYziHMnohxqZwrn
        dpw6+x1kfG3NV13W2XgrhaT8cTC/MzI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-peetV-5XM0CbaLLtYkWHiw-1; Tue, 19 Oct 2021 03:23:37 -0400
X-MC-Unique: peetV-5XM0CbaLLtYkWHiw-1
Received: by mail-wm1-f70.google.com with SMTP id c5-20020a05600c0ac500b0030dba7cafc9so2393143wmr.5
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 00:23:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=P9lMPKELEtAjTfOQS27eJYanNr/naiOHvH+IE9qUoS0=;
        b=Pne8u+EgTi1YKPDE0afvfDfwKwSafwB1TccEBlf3RRzsbPVdCh2LN4yKD2K2I29fWA
         MqCMd7P0TYDwT9IkA61flHdZ5znYOZ19JYwy6HEuGTQgeOqzDmPd/qxaoFIp4IcuffHU
         yhJjBocqYYi02Wx12FYy3p7zgvdMQ/KVz0pdfwXpoN4IKzErLOlVbR7TbGvfNQO+D5l/
         y1JVpr7ky46TDoO4uuOVq7gBfcFuebeKbDJJ/2vX4MDBayNmDMEzmoAS9PARuyneHcE0
         +35rGGGTJt+yU3JoAy/ujUzdciBZKuG1aip9JKKZXlRBg002qPBEbrlob0KAi0mroOQQ
         PqRQ==
X-Gm-Message-State: AOAM531+x+UTfRWQ3f4lZHQhXZvxjjjrX+qR7yQsBh5eah1KrW+B+zvz
        qHolGQMBkGbMBLwrczDhej5jp+VGf264fKtJAHYM4zWSyCPVqsbaUL6bpFXIAeH1+yuvqFbCYcl
        it+2lZkmW2ZDaScnYah47DRkULzZoA3OTXlg40BheszUaDP8ce3QhMwp+tBOuUVPH
X-Received: by 2002:a5d:4b43:: with SMTP id w3mr43177665wrs.404.1634628215973;
        Tue, 19 Oct 2021 00:23:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPV1aEquHgPsVaxUuUUZKa7hrm+MRBb7HTkmPQpEVImwI0weO8Cf79y4ZagW2EunRqzKh27Q==
X-Received: by 2002:a5d:4b43:: with SMTP id w3mr43177629wrs.404.1634628215616;
        Tue, 19 Oct 2021 00:23:35 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id r27sm14179532wrr.70.2021.10.19.00.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 00:23:35 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     lirongqing@baidu.com, pbonzini@redhat.com, seanjc@google.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: Clear pv eoi pending bit only when it is set
In-Reply-To: <1634609144-28952-1-git-send-email-lirongqing@baidu.com>
References: <1634609144-28952-1-git-send-email-lirongqing@baidu.com>
Date:   Tue, 19 Oct 2021 09:23:33 +0200
Message-ID: <87y26pwk96.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Li RongQing <lirongqing@baidu.com> writes:

> clear pv eoi pending bit only when it is set, to avoid calling
> pv_eoi_put_user()
>
> and this can speed pv_eoi_clr_pending about 300 nsec on AMD EPYC
> most of the time
>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  arch/x86/kvm/lapic.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 76fb009..c434f70 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -694,9 +694,9 @@ static void pv_eoi_set_pending(struct kvm_vcpu *vcpu)
>  	__set_bit(KVM_APIC_PV_EOI_PENDING, &vcpu->arch.apic_attention);
>  }
>  
> -static void pv_eoi_clr_pending(struct kvm_vcpu *vcpu)
> +static void pv_eoi_clr_pending(struct kvm_vcpu *vcpu, bool pending)

Nitpick (and probably a matter of personal taste): pv_eoi_clr_pending()
has only one user and the change doesn't make its interface much nicer,
I'd suggest we just inline in instead. (we can probably do the same to
pv_eoi_get_pending()/pv_eoi_set_pending() too).

>  {
> -	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_DISABLED) < 0) {
> +	if (pending && pv_eoi_put_user(vcpu, KVM_PV_EOI_DISABLED) < 0) {
>  		printk(KERN_WARNING "Can't clear EOI MSR value: 0x%llx\n",
>  			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
>  		return;
> @@ -2693,7 +2693,8 @@ static void apic_sync_pv_eoi_from_guest(struct kvm_vcpu *vcpu,
>  	 * While this might not be ideal from performance point of view,
>  	 * this makes sure pv eoi is only enabled when we know it's safe.
>  	 */
> -	pv_eoi_clr_pending(vcpu);
> +	pv_eoi_clr_pending(vcpu, pending);
> +
>  	if (pending)
>  		return;
>  	vector = apic_set_eoi(apic);

Could you probably elaborate a bit (probably by enhancing the comment
above pv_eoi_clr_pending()) why the race we have here (even before the
patch) doesn't matter? As far as I understand it, the guest can change
PV EOI status from a different CPU (it shouldn't do it but it still can)
at any time: e.g. between pv_eoi_get_pending() and pv_eoi_clr_pending()
but also right after we do pv_eoi_clr_pending() so the patch doesn't
really change much in this regard.

-- 
Vitaly

