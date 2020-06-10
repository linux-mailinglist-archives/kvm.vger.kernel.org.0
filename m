Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 742AF1F5EE9
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 01:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbgFJXxq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 19:53:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51544 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726912AbgFJXxo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 19:53:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591833222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WI0+NbsJ1zacj1DISmUqJe9tzBi7AdJpLzC1uFJh4Cs=;
        b=H0wzv/v3BWCPA2djtVukAHnf43Pm8dLaD6+Et3jfxbDmP4FuIwbFwCMIEuY9usi+PEpbXC
        WdhJ3liVgdMjRxLivYm9TZx7lKWlk2KQUcb9qtIwTATOaQJ2TeN1e+Xyzf2KJvpDB6Gebo
        +1OVm/gTCN4T5FykoBS8irKMgjI5lfs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-d6_KBfBfP1Oa8SHpBlVcMA-1; Wed, 10 Jun 2020 19:53:40 -0400
X-MC-Unique: d6_KBfBfP1Oa8SHpBlVcMA-1
Received: by mail-wr1-f69.google.com with SMTP id x15so388813wru.21
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 16:53:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WI0+NbsJ1zacj1DISmUqJe9tzBi7AdJpLzC1uFJh4Cs=;
        b=KXaeInxLrz/Kb9cfdpcb7nX2Mntwpfji/kDITwgqIIpPA9OjtToao5NB8cSdKqUYnY
         0Kh2OsrQD8hbtOjSN9gzcVWjy1SF5SEK8BOCUINKwGXS8ZU6tLjjQ3oFeTN4OXldd6uM
         1ddssnFVz3cUWat026E01FP4jD6tt2dTIreUNyqm/ClyVQoDXsnj+aqkYa2U93RSxjWD
         RMnm4mRIo1b4Ja7y6UfJ4VgHhm2TmVlpYgftYsQD6QUj+A8bkm1mJ0LZ9785OFQpjZhk
         nH0gtAVo69EZ/pD1ctnwMkVR+okRIwXSVkGKv4t6tqzYBUJpQDaQCpwRYGybivSLSGEy
         RHhA==
X-Gm-Message-State: AOAM530h6Jb/4xR9Fgdx1WnOzoJEJQMDCB5ExbPrap1hoetyWae4gfQq
        2zQsE54+Px7n0W27ebsdYy8PYhFTA/kKw3k0B+vEr6wqd1c4jC2oaW14nlclGXUMK43RFbvTO8t
        Nyqeh3lq+OOYW
X-Received: by 2002:a5d:6789:: with SMTP id v9mr6785867wru.124.1591833219411;
        Wed, 10 Jun 2020 16:53:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGyH+9QSFaUyuUyAYSrKWRjuZk8Y1vF202/B03IwIpUI+dw/51oImN2L3Z89rIzK3JWB8I0g==
X-Received: by 2002:a5d:6789:: with SMTP id v9mr6785853wru.124.1591833219187;
        Wed, 10 Jun 2020 16:53:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:29ed:810e:962c:aa0d? ([2001:b07:6468:f312:29ed:810e:962c:aa0d])
        by smtp.gmail.com with ESMTPSA id b132sm1588022wmh.3.2020.06.10.16.53.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 16:53:38 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: async_pf: Inject 'page ready' event only if
 'page not present' was previously injected
To:     Vivek Goyal <vgoyal@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
References: <20200610175532.779793-1-vkuznets@redhat.com>
 <20200610175532.779793-2-vkuznets@redhat.com>
 <20200610193211.GB243520@redhat.com> <20200610194738.GE18790@linux.intel.com>
 <20200610195725.GA263462@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <91bf7843-ec23-e89e-a61f-1e36a32af09c@redhat.com>
Date:   Thu, 11 Jun 2020 01:53:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200610195725.GA263462@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/06/20 21:57, Vivek Goyal wrote:
> I personally find it better that initialization of
> work->notpresent_injected is very explicit at the site where this 
> structure has been allocated and being initialized. (Instead of a
> a callee function silently initializing a filed of this structure).

I agree.

Paolo

