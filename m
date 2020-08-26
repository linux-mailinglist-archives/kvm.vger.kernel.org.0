Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35EF02537DC
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 21:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgHZTHq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 15:07:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45492 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726753AbgHZTHp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Aug 2020 15:07:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598468863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4sUMH0Xc8mgPBEvhkAmZXhGliqOnaQmpumzAyZJMZ78=;
        b=NtTzK8WBAqVxVc3XEju4ElAWtz9TiIkarS4ANFnVmPwIn9uoeEOPRPyYa9KYD+t8WkH6zW
        CCWQJH4fd1vly5ONZsj1Zb/kI6iJRD/LWanpLs1vS93U3vuP/3p8T6kbdNQH57DA6I8utC
        E/l9Y0dd3W4UebBuHoO7CkIgCvubsp8=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-lHMeYrMXOHyhL7U_Olagkw-1; Wed, 26 Aug 2020 15:07:41 -0400
X-MC-Unique: lHMeYrMXOHyhL7U_Olagkw-1
Received: by mail-qv1-f71.google.com with SMTP id d1so2333668qvs.21
        for <kvm@vger.kernel.org>; Wed, 26 Aug 2020 12:07:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4sUMH0Xc8mgPBEvhkAmZXhGliqOnaQmpumzAyZJMZ78=;
        b=nyAoPjPsCcOXJYTRkxS2MmFwa1pU/EvrPvUWaOMeJPTJi5yEVegqJy+jURh1WK+mlW
         t8vYDMufBaiqL1PXls2bv+9z6cJSEx3vdQ1vyHrHcs2TmlEkOoGYjS5VjJ2rQ9HWEEHK
         5TRj/298WMJ/E0gzjIb5AhnZTe3Blr6UYiVwogHhCinKFre3cAegEDHBG8kp5WUKGGRt
         99EpxdxP/pXH+qPR9xkDU/8drwoPQrtlbWSRTBFE/KhFqanKQYPh/xh8wlLunTh37XPj
         7P414W8hpNFNGxFb29su9izXkuqDiIA6YoNwD4ZAQNyluWyhj/lk+FNH5cd9+TjCoQKJ
         F/4Q==
X-Gm-Message-State: AOAM532sO3h6pg42lnPi5K3UbtMu/7ghRWzByydvzLxkaxY1DgIhHwBb
        c2TwVZ083pI9Rs8bMhWRxkpsfuLKuwyKJP6JwoBpIT816xrmHAWdb8AyGJp+7sWnTYzFNOCFB9/
        QbttWSRQy5gnc
X-Received: by 2002:a37:8047:: with SMTP id b68mr14399217qkd.299.1598468861202;
        Wed, 26 Aug 2020 12:07:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx5cHxFPUe5202vRGt9razTTlpB35IPi0HtjYlGzmZufevEkVNsScqAhuMUFxWmpAofpBMY9Q==
X-Received: by 2002:a37:8047:: with SMTP id b68mr14399193qkd.299.1598468860945;
        Wed, 26 Aug 2020 12:07:40 -0700 (PDT)
Received: from [192.168.0.172] (ip68-103-222-6.ks.ok.cox.net. [68.103.222.6])
        by smtp.gmail.com with ESMTPSA id d8sm2628402qtr.12.2020.08.26.12.07.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 12:07:40 -0700 (PDT)
Subject: Re: [PATCH 2/4] sev/i386: Allow AP booting under SEV-ES
To:     Tom Lendacky <thomas.lendacky@amd.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
References: <cover.1598382343.git.thomas.lendacky@amd.com>
 <a3fc1bfb697a85865710fa99a3e1169e7d355a18.1598382343.git.thomas.lendacky@amd.com>
From:   Connor Kuehl <ckuehl@redhat.com>
Message-ID: <93275d7f-1bfd-c115-be4b-3d20952bf376@redhat.com>
Date:   Wed, 26 Aug 2020 14:07:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a3fc1bfb697a85865710fa99a3e1169e7d355a18.1598382343.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/20 2:05 PM, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> When SEV-ES is enabled, it is not possible modify the guests register
> state after it has been initially created, encrypted and measured.
> 
> Normally, an INIT-SIPI-SIPI request is used to boot the AP. However, the
> hypervisor cannot emulate this because it cannot update the AP register
> state. For the very first boot by an AP, the reset vector CS segment
> value and the EIP value must be programmed before the register has been
> encrypted and measured.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>   accel/kvm/kvm-all.c    | 60 ++++++++++++++++++++++++++++++++++++++++++
>   accel/stubs/kvm-stub.c |  5 ++++
>   hw/i386/pc_sysfw.c     | 10 ++++++-
>   include/sysemu/kvm.h   | 16 +++++++++++
>   include/sysemu/sev.h   |  2 ++
>   target/i386/kvm.c      |  2 ++
>   target/i386/sev.c      | 47 +++++++++++++++++++++++++++++++++
>   7 files changed, 141 insertions(+), 1 deletion(-)

Just a heads-up: ./scripts/checkpatch.pl does report a couple of style 
errors. I've seen other series go by where maintainers didn't mind the 
line length errors, but there are a couple that have to do with braces 
around if-statement contents that may need to be addressed.

