Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD73219D1D
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 12:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbgGIKLs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 06:11:48 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57817 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726140AbgGIKLs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jul 2020 06:11:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594289507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L3LOABQZfanvD1gLTv79zBx1EWnFuqzfDG4sVWnQIEA=;
        b=IEv7eKIeg6iogFwgFm816n8HYVYy2MMplWq8N+CB+eGvlio5vaNzLvx35om/XCUgzdPgM5
        jau1ssug0SjS5bm8U7zm8xgGWbFrRTNLvF4Iv3mootI3mZMkoeOBVLq6FeT+V/BS2JR/DD
        kFQtNfb4FAxjmsfwUqN0PRpXtSPeLCw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-ufEFgvunN8Sy6SGWNkfKnQ-1; Thu, 09 Jul 2020 06:11:46 -0400
X-MC-Unique: ufEFgvunN8Sy6SGWNkfKnQ-1
Received: by mail-wm1-f71.google.com with SMTP id u68so1788612wmu.3
        for <kvm@vger.kernel.org>; Thu, 09 Jul 2020 03:11:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L3LOABQZfanvD1gLTv79zBx1EWnFuqzfDG4sVWnQIEA=;
        b=kxouTXrEjxyHZ4eJv3uR5ZyFetduSsLELKL+cwI0w1qTOQHZ+1u5Id3nlxrYEk2v5Q
         ZXrOcoM2vquJbGYyggr1iU4Ii2ZdQTFnTYes+FGBvIS+4UdsNxsA/fESRoD1OZjAW2KM
         kdnVsSo5D0nES07XWiT9bFk4huqOeVVTed2Y1FovwDExWZGtlQRzWCHPMg+LucX1a0XQ
         culCEfOS9wWgBRay8FId7PkUmVV01cNpdpCBdvTKYFxA/tDylI10eDHUVGSnMQchYeRq
         qSNY60Gcqm5k86x3QQwNsku0r4RMH/Mg7RKhWB1gva019QtxjPAySxnitM0vcwWRNeQZ
         3v0Q==
X-Gm-Message-State: AOAM532QQQ924+W+vVoodWpFADBAW/AVXmFeJ2YQ5QUs/o7JcJAFONZB
        okAcYUN3nk9w6n/c3+2DYQo0/jqj/02e3mLg8H8tEKCp6WR16H9Q/B1VcNn+SC2T83JzOhyuj5n
        FvkJElWg2oKR0
X-Received: by 2002:adf:ecc8:: with SMTP id s8mr63561673wro.317.1594289504597;
        Thu, 09 Jul 2020 03:11:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyGPWAhbR1dQfzcHSvUvPl+es2gcwjD/rPtFt+Q4iK/eWDgs8nAz8mGGQ6YFGC802OkBVyVlw==
X-Received: by 2002:adf:ecc8:: with SMTP id s8mr63561644wro.317.1594289504399;
        Thu, 09 Jul 2020 03:11:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id z1sm4893109wru.30.2020.07.09.03.11.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 03:11:42 -0700 (PDT)
Subject: Re: [PATCH 2/2] x86/cpu: Handle GUEST_MAXPHYADDR < HOST_MAXPHYADDR
 for hosts that don't support it
To:     Mohammed Gamal <mgamal@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     Eduardo Habkost <ehabkost@redhat.com>, mtosatti@redhat.com,
        Pedro Principeza <pedro.principeza@canonical.com>,
        kvm@vger.kernel.org, libvir-list@redhat.com,
        Dann Frazier <dann.frazier@canonical.com>,
        Guilherme Piccoli <gpiccoli@canonical.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>,
        qemu-devel@nongnu.org, Laszlo Ersek <lersek@redhat.com>,
        fw@gpiccoli.net, rth@twiddle.net
References: <20200619155344.79579-1-mgamal@redhat.com>
 <20200619155344.79579-3-mgamal@redhat.com>
 <20200708171621.GA780932@habkost.net> <20200708172653.GL3229307@redhat.com>
 <20200709094415.yvdh6hsfukqqeadp@sirius.home.kraxel.org>
 <8ed00a46daec6b41e7369123e807342e0ecfe751.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2c9ec76e-7cfc-f613-ef9b-cb1e7cc54ade@redhat.com>
Date:   Thu, 9 Jul 2020 12:11:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <8ed00a46daec6b41e7369123e807342e0ecfe751.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/07/20 11:55, Mohammed Gamal wrote:
>> Ideally we would simply outlaw (3), but it's hard for backward
>> compatibility reasons.  Second best solution is a flag somewhere
>> (msr, cpuid, ...) telling the guest firmware "you can use
>> GUEST_MAXPHYADDR, we guarantee it is <= HOST_MAXPHYADDR".
> Problem is GUEST_MAXPHYADDR > HOST_MAXPHYADDR is actually a supported
> configuration on some setups. Namely when memory encryption is enabled
> on AMD CPUs[1].
> 

It's not that bad since there's two MAXPHYADDRs, the one in CPUID and
the one computed internally by the kernel.  GUEST_MAXPHYADDR greater
than the host CPUID maxphyaddr is never supported.

Paolo

