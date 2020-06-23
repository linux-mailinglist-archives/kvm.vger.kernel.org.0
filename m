Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC6B204EAE
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 12:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732201AbgFWKBL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 06:01:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22347 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732056AbgFWKBJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 06:01:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592906468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u1ZMbB/9nLT7AEeDFZo4BOmzf6TAec2bOyX4Xc71HDc=;
        b=KthzeApE0ZHApi9MwsGRuVdBzGcIE/eDnr19qpdQiUGdubVwon/qlmXI47u0tmDC50ysXl
        zDoEaLZIig8XvPDg9ZivFdLsP5yoosRM7eiYpghsFC6YmhIIG4+pb+FLDFgYe6TOJUCUCj
        ag1UyTVmfVH7FN3rD8r/lg73wF+0QME=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429--qsXY9RlNWOrGWBAOYTR8w-1; Tue, 23 Jun 2020 06:01:06 -0400
X-MC-Unique: -qsXY9RlNWOrGWBAOYTR8w-1
Received: by mail-wm1-f71.google.com with SMTP id a18so3284519wmm.3
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 03:01:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u1ZMbB/9nLT7AEeDFZo4BOmzf6TAec2bOyX4Xc71HDc=;
        b=X+OZlNZySU8OrAuGdNGaeT+ZyMLs9JMYe2Gu9i1c1ITcjXP1+4UW7RcQ+PLFWoriR/
         nd++cUuWuIWCLZK0HpVFO1ssIkW+90K1cEtoYYqVLEDFdQSSA1z4DlVbCtf1nTiUL3Uk
         JLATAdvIZrTtfc/S8qxSL2k2a+nD0VDIiDPwbN881UdmNUov8W/i2aGRkpyjrQJvo+4r
         j70brBMYGxd7KTN+4H+HwpdwlM6UOW+IExopb/xWwr90HydBjORHEdFqETX+IeE+9Gep
         vcEWTuFI847mXr1xYH2jWHtQAulg0yZraPGRpMX4bZuZTMIctyR2EwGCitY/OurpQRKW
         4y7Q==
X-Gm-Message-State: AOAM532brgCH/W2X9X8V2Rg9rW6vU8MuK34iXa00Seqt/3E4lA1gC80E
        DhZxgyVEJ57C+YpYXipmhI+L/TMJaHwMtdW/Rg3h7qK2jQevAMoKXRrteERsrc6vwfw5ZgOlKnN
        DLwaPd2Yilr2m
X-Received: by 2002:a1c:a993:: with SMTP id s141mr23161652wme.174.1592906465236;
        Tue, 23 Jun 2020 03:01:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw6Klqi+ChpmYXj/U3wPJCEvd+sIvt5GbPl7+KEwbGRq0VcWfSbiK8Noa4n5Vj59gWIbUnRTA==
X-Received: by 2002:a1c:a993:: with SMTP id s141mr23161581wme.174.1592906464462;
        Tue, 23 Jun 2020 03:01:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:24f5:23b:4085:b879? ([2001:b07:6468:f312:24f5:23b:4085:b879])
        by smtp.gmail.com with ESMTPSA id v24sm25096994wrd.92.2020.06.23.03.01.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 03:01:03 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: skip hyperv_clock test when host
 clocksource is not TSC
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
References: <20200617152139.402827-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d04351b2-1bb1-2bb8-0588-534315dbd4bb@redhat.com>
Date:   Tue, 23 Jun 2020 12:01:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200617152139.402827-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/06/20 17:21, Vitaly Kuznetsov wrote:
> Hyper-V TSC page clocksource is TSC based so it requires host to use TSC
> for clocksource. While TSC is more or less standard for x86 hardware
> nowadays, when kvm-unit-tests are run in a VM the clocksource tends to be
> different (e.g. kvm-clock).
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  x86/unittests.cfg | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 504e04e5f2b5..3a7915143479 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -334,6 +334,7 @@ smp = 2
>  extra_params = -cpu kvm64,hv_time
>  arch = x86_64
>  groups = hyperv
> +check = /sys/devices/system/clocksource/clocksource0/current_clocksource=tsc
>  
>  [intel_iommu]
>  file = intel-iommu.flat
> 

Queued, thanks.

Paolo

