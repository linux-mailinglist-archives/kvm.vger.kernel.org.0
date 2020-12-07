Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 524292D130F
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 15:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgLGOEv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 09:04:51 -0500
Received: from forward100o.mail.yandex.net ([37.140.190.180]:48485 "EHLO
        forward100o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725781AbgLGOEu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 09:04:50 -0500
X-Greylist: delayed 8191 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Dec 2020 09:04:49 EST
Received: from mxback7g.mail.yandex.net (mxback7g.mail.yandex.net [IPv6:2a02:6b8:c03:7aa:0:640:45d7:caab])
        by forward100o.mail.yandex.net (Yandex) with ESMTP id CF4B04AC127F;
        Mon,  7 Dec 2020 17:04:07 +0300 (MSK)
Received: from iva5-057a0d1fbbd8.qloud-c.yandex.net (iva5-057a0d1fbbd8.qloud-c.yandex.net [2a02:6b8:c0c:7f1c:0:640:57a:d1f])
        by mxback7g.mail.yandex.net (mxback/Yandex) with ESMTP id pJAP5gGgmz-46fKf9Xm;
        Mon, 07 Dec 2020 17:04:07 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1607349847;
        bh=VXJ2WV+3oLwe/kgu65fZ3NuyXn0BmMomcXwcCXAMr2w=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=eJY4echNoHLad24zI5CP/ahAx3mrc73JIzGocX6iKLjJqoKf85I6IEj0Nukcnzyzh
         vMflNyfmNCDHMv+OqMW4geZLAIo+3gkEIx1V8p+xKptfrlqguoH1yOQVLvnYen1/OQ
         282CPmgsHL2emMqad0JolKr0guiao+lV1M6AO4PQ=
Authentication-Results: mxback7g.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by iva5-057a0d1fbbd8.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id VLMtVEr4V8-46m4olwu;
        Mon, 07 Dec 2020 17:04:06 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: KVM_SET_CPUID doesn't check supported bits (was Re: [PATCH 0/6]
 KVM: x86: KVM_SET_SREGS.CR4 bug fixes and cleanup)
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201007014417.29276-1-sean.j.christopherson@intel.com>
 <99334de1-ba3d-dfac-0730-e637d39b948f@yandex.ru>
 <20201008175951.GA9267@linux.intel.com>
 <7efe1398-24c0-139f-29fa-3d89b6013f34@yandex.ru>
 <20201009040453.GA10744@linux.intel.com>
 <5dfa55f3-ecdf-9f8d-2d45-d2e6e54f2daa@yandex.ru>
 <20201009153053.GA16234@linux.intel.com>
 <b38dff0b-7e6d-3f3e-9724-8e280938628a@yandex.ru>
 <c206865e-b2da-b996-3d48-2c71d7783fbc@redhat.com>
 <c0c473c1-93af-2a52-bb35-c32f9e96faea@yandex.ru>
 <CABgObfYS57_ez-t=eu9+3S2bhSXC_9DTj=64Sna2jnYEMYo2Ag@mail.gmail.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <9201e8ac-68d2-2bb3-1ef3-efd698391955@yandex.ru>
Date:   Mon, 7 Dec 2020 17:03:55 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <CABgObfYS57_ez-t=eu9+3S2bhSXC_9DTj=64Sna2jnYEMYo2Ag@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

07.12.2020 16:35, Paolo Bonzini пишет:
>
>
> Il lun 7 dic 2020, 12:47 stsp <stsp2@yandex.ru 
> <mailto:stsp2@yandex.ru>> ha scritto:
>
>     So am I right that KVM_SET_CPUID only "lowers"
>     the supported bits? In which case I don't need to
>     call it at all, but instead just call KVM_GET_SUPPORTED_CPUID
>     and see if the needed bits are supported, and
>     exit otherwise, right?
>
>
> You always have to call KVM_SET_CPUID2, but you can just pass in 
> whatever you got from KVM_GET_SUPPORTED_CPUID.
OK, done that, thanks.
(after checking that KVM_GET_SUPPORTED_CPUID
actually has the needed features itself, otherwise exit).

Perhaps it would be good if guest cpuid to
have a default values of KVM_GET_SUPPORTED_CPUID,
so that the user doesn't have to do the needless
calls to just copy host features to guest cpuid.
