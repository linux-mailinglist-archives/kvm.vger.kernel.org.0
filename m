Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09DA3175891
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 11:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbgCBKl1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 05:41:27 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37225 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726654AbgCBKl0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 05:41:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583145685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W/No+zSqneGbjc27RGNY0R0gIKfmegvgk6I94PCXiQI=;
        b=Jb59s3/MuVttVOpl+gBeLwdTafjUpK8T1oMgbKeQRp6GJmoJ8Vyh5Su98GextM3cG2Xv9d
        aBPAp8TRVRDETYGMvN7If9YSRvM51yLoU5whVNGOtkY+8zWcLP1MsIiJlAXXOt/CrxVZeh
        AAQt2hksGGEEzuzDupGH/+pq888WnPc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-aeS6HzSoM9Srvb4FwdZyxQ-1; Mon, 02 Mar 2020 05:41:24 -0500
X-MC-Unique: aeS6HzSoM9Srvb4FwdZyxQ-1
Received: by mail-wm1-f70.google.com with SMTP id b23so648699wmj.3
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2020 02:41:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W/No+zSqneGbjc27RGNY0R0gIKfmegvgk6I94PCXiQI=;
        b=dq7DNOjJs18qFSUwoatX4wtw6Gqjt2Oq+8OpT+QJftk1Vg4NOwMeBb26jXcKiVZVVr
         HQ/2nv86xknIYSkjnTPXDfBdTnDPFl2NreUc7cjhuLOOcxeK+Fj7ATqWeCcdxGGz26+7
         XAwU3oLrCnfWqf7yPDf+tEEy5BKr107Aydtq/m4gzwNcTbbrTQYMDw/okQXQW0yFFR/S
         bhOTMiDWEKoj6sRURC+m+JUuLYaWpaQ7MqIYPlow8aTlRbLAzG7SPkrPNiiwWpnBxoF9
         2SMhxk7yP83dCROF7WkSUEka79ACTMR8TZKVq7vh+xJzZUxJVjs3HlVx08SNqjd+/Ukd
         PxOg==
X-Gm-Message-State: APjAAAUDyy0OnZbOq0+TJjuqxEJwquGyNIxLQW0iqsl1yvL8BeRAI0IF
        iCpK+xKnnoxzq7NRIw1BgXTmiVp4X7egnnVsLpkIGmdNrWmfU5CSAm9OvmD5IEkiZi6gFPmO/C0
        5NKgFCde74nlZ
X-Received: by 2002:adf:ec0e:: with SMTP id x14mr20684970wrn.270.1583145682637;
        Mon, 02 Mar 2020 02:41:22 -0800 (PST)
X-Google-Smtp-Source: APXvYqxr5BG762XJibpFKMG4qKy++MMibwFPZUGzvUBIxE+6bF6Hv9ol6loBGjhblNJ67DPHLJxYFQ==
X-Received: by 2002:adf:ec0e:: with SMTP id x14mr20684948wrn.270.1583145682375;
        Mon, 02 Mar 2020 02:41:22 -0800 (PST)
Received: from [192.168.178.40] ([151.30.85.6])
        by smtp.gmail.com with ESMTPSA id o18sm23121454wrv.60.2020.03.02.02.41.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 02:41:21 -0800 (PST)
Subject: Re: [PATCH v2] x86/kvm: Handle async page faults directly through
 do_page_fault()
To:     Nadav Amit <nadav.amit@gmail.com>,
        Andy Lutomirski <luto@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>
References: <53626d08de5df34eacce80cb74f19a06fdc690c6.1582998497.git.luto@kernel.org>
 <34082A11-321D-4DF0-A076-7BBF332DCA66@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <328119b6-38a3-8b74-9e89-629977316ff4@redhat.com>
Date:   Mon, 2 Mar 2020 11:41:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <34082A11-321D-4DF0-A076-7BBF332DCA66@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/03/20 10:28, Nadav Amit wrote:
> 
> Yet, this might be a slippery slope, making Linux optimized to run on KVM
> (and maybe Xen). In other words, I wonder whether a similar change was
> acceptable for a paravirtual feature that is only supported by a proprietary
> hypervisor, such as Hyper-V or VMware.

Your concern is understandable.  I think in this case Andy's patch makes
sense since there is a hooking mechanism that is used in exactly one
case and there are no performance issues in removing it.  In fact if
more hypervisors implemented a #PF extension I would keep the static
branch, but use it to choose between a pvop and the default case; this
would be a much more localized change, so arguably better than trap_init.

Paolo

