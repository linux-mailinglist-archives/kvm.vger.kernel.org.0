Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E46D11D8B17
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 00:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgERWke (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 18:40:34 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:33610 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727831AbgERWkd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 May 2020 18:40:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589841632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zk6i9dtggpOFkaugjj5c+MXBxvEu5wGUbXo96pP70JY=;
        b=FSXnicYp8686ZwUYQ0f1Hr0C6Na+CGl0LlpkjkxxqN25PFEmKY78HD/2vB9oemx8uLeUqN
        1fPa6Ar/ehblxCxEnFeTC38uC0ATcgTOXMNl6/P+3KzjL002+dI+sNYJnPag32ClR/xoHD
        FQ7/8pNkKfHpNpsmHh2aNorUywNlMS0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-KSUxfFQEP--CMvRfxtFiIQ-1; Mon, 18 May 2020 18:40:29 -0400
X-MC-Unique: KSUxfFQEP--CMvRfxtFiIQ-1
Received: by mail-wr1-f72.google.com with SMTP id g10so6308540wrr.10
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 15:40:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zk6i9dtggpOFkaugjj5c+MXBxvEu5wGUbXo96pP70JY=;
        b=YSNwFt3CvYO5ZR9ZHFRnzTh3gXcx3Xclmpy5JulwKaubjOl3QeNpI8LZJpkVIMcoEF
         ktJvDQkQvSQA+scp2fADqdSkvGK3mZJ/IknQHrUCvbJ1rRVwuBKOA5+UCiJXprourjbi
         i2YBOh/NeGFjUx72FJQd1nB3qvMJFrD0v72V4ya3gRrdF2Nw9tyFdAiLfW6T7oTpr7eE
         6mZgbktt97zrsJoxfr9ZR3hc2XFHnRGVuVBV4ySoH39k8UZ9KbZi60UaguO0QMOEDA3F
         MU1AsLWWlcA7RwvvxForjaz5jOUGq1RqAmNtvpn6LkI2MiaKetJwi13Qzlgt9lAykaEp
         VEkQ==
X-Gm-Message-State: AOAM531ru5yymnJutRgtmCaqxjmLGP2Iima1deAQDc6X9KBq4snKnB+z
        j7dNtaJ1r96FnS2bM1GVE2nwzGG1cksUKU6CdQlUzs8Vt9X8kMiFQs67Bhc+f167hq5TUCNO9I7
        2a3x1rDUAdFOe
X-Received: by 2002:a1c:541e:: with SMTP id i30mr1672176wmb.120.1589841627800;
        Mon, 18 May 2020 15:40:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxQY8kAtkTYp0bwDBDlqhZOjSveAZMvd9tWu4uC7M+9koEfu2GVNcldVgZco9vgHy07saywwg==
X-Received: by 2002:a1c:541e:: with SMTP id i30mr1672157wmb.120.1589841627542;
        Mon, 18 May 2020 15:40:27 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id w82sm1264494wmg.28.2020.05.18.15.40.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 15:40:26 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: respect singlestep when emulating instruction
To:     Felipe Franciosi <felipe@nutanix.com>
Cc:     kvm@vger.kernel.org, stable@vger.kernel.org
References: <20200518213620.2216-1-felipe@nutanix.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <babce5c7-16d6-7f46-1fd2-21b4b9bac83c@redhat.com>
Date:   Tue, 19 May 2020 00:38:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200518213620.2216-1-felipe@nutanix.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/05/20 23:36, Felipe Franciosi wrote:
>  		    exception_type(ctxt->exception.vector) == EXCPT_TRAP) {
>  			kvm_rip_write(vcpu, ctxt->eip);
> -			if (r && ctxt->tf)
> +			if ((r && ctxt->tf) || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP))
>  				r = kvm_vcpu_do_singlestep(vcpu);

Almost:

	if (r && (ctxt->tf || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP))

This is because if r == 0 you have to exit to userspace with KVM_EXIT_MMIO
and KVM_EXIT_IO before completing execution of the instruction.  Once
this is done, you'll get here again and you'll be able to go through
kvm_vcpu_do_singlestep.

Thanks,

Paolo

