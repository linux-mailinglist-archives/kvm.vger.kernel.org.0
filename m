Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 555DF4504DA
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 14:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbhKONFH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 08:05:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32023 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231508AbhKONEm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Nov 2021 08:04:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636981252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fNHR/4EKA1J8JSmTNFejCsQ+Ytekp9kmZceJTflwDKc=;
        b=K71Dz7PS+WUylpAV2iwXBgm2kkvmz41PDjnIT3gMJ64TJ6lzPCiHF1bCI9prAresrqWSBu
        32xtgKorLNdd6XXcJt1sDEZiclrSY6//SFEHpCTPicy5DH8qPzTT6Ci87GsqARfhEWt23q
        JitsW9CFL6GyBCAwFON8klsVPGnk2w8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-TqJHyn1qNVGkA0lR0ADlGA-1; Mon, 15 Nov 2021 08:00:51 -0500
X-MC-Unique: TqJHyn1qNVGkA0lR0ADlGA-1
Received: by mail-wr1-f70.google.com with SMTP id r12-20020adfdc8c000000b0017d703c07c0so3540098wrj.0
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 05:00:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=fNHR/4EKA1J8JSmTNFejCsQ+Ytekp9kmZceJTflwDKc=;
        b=GIgrqNoMbndFgfF0zyheZnU1MvPAyq7ZLccBBycNSTYMG29A1X4zVERFLtrjqHFpwe
         gWwOATRH2Zv9uWrb9fYCViSdnWPWQtuR7yvIWGpXCMTBo79hBSKvmoRjH6OYFzIp8GjE
         rDS0Gvlxsjnw7JKcafAcdrEf4WFo957umh8+wd+h7QB5zwSrUm5//knW0pJ29vrUkPCg
         bhE5nVrYXDUZ8t7+a/vJftL4wziX2idEq3fXE3588J/IQ7aqTH3zxCS2H+k8PDAi0qer
         TjKyZBmdczDcMmFpAooAsJLw68A/8peFKwmttqtQRcOu/Fz2RLSiMmMIRgbULoyYKF5y
         2JsA==
X-Gm-Message-State: AOAM533/ZZIYgfpDt/hpQ3nEA+MdJCuPR+6mYsANArT8xVLQaeQNH4SV
        jLmYUBKIwd07cRTJgW1HHVCUFXgixhX07T8B22TpKWibX1lsx3oTe1WPA25Et1H/edhd8uYympg
        ij0KoQ847gs9Z
X-Received: by 2002:a5d:6902:: with SMTP id t2mr48286154wru.317.1636981250404;
        Mon, 15 Nov 2021 05:00:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyksSkAyNqlPH0unAflPwLe/0xyM9aEOqPn8ztJiP3iIOBdvhurRV64rjvGcWEiuYSq5VU+dQ==
X-Received: by 2002:a5d:6902:: with SMTP id t2mr48286129wru.317.1636981250253;
        Mon, 15 Nov 2021 05:00:50 -0800 (PST)
Received: from fedora (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o25sm15107809wms.17.2021.11.15.05.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 05:00:49 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     =?utf-8?B?6buE5LmQ?= <huangle1@jd.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH] KVM: x86: Fix uninitialized eoi_exit_bitmap usage
 in vcpu_load_eoi_exitmap()
In-Reply-To: <567b276444f841519e42c91f43f5acd7@jd.com>
References: <567b276444f841519e42c91f43f5acd7@jd.com>
Date:   Mon, 15 Nov 2021 14:00:48 +0100
Message-ID: <877dd9efpb.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

=E9=BB=84=E4=B9=90 <huangle1@jd.com> writes:

>> =E9=BB=84=E4=B9=90 <huangle1@jd.com> writes:
>>=20
>> > In vcpu_load_eoi_exitmap(), currently the eoi_exit_bitmap[4] array is
>> > initialized only when Hyper-V context is available, in other path it is
>> > just passed to kvm_x86_ops.load_eoi_exitmap() directly from on the sta=
ck,
>> > which would cause unexpected interrupt delivery/handling issues, e.g. =
an
>> > *old* linux kernel that relies on PIT to do clock calibration on KVM m=
ight
>> > randomly fail to boot.
>> >
>> > Fix it by passing ioapic_handled_vectors to load_eoi_exitmap() when Hy=
per-V
>> > context is not available.
>> >
>> > Signed-off-by: Huang Le <huangle1@jd.com>
>>=20
>> Fixes: f2bc14b69c38 ("KVM: x86: hyper-v: Prepare to meet unallocated Hyp=
er-V context")
>> Cc: stable@vger.kernel.org
>
> Commit f2bc14b69c38 is not in stable tree I guess, it was merged in from =
5.12,
> do we still need Cc this patch to stable maintainers?
>

There are multiple stable trees, one for each major release. Not all of
them are still supported but you don't need to care about it, 'Cc:
stable@vger.kernel.org' is just an indication for everyone who has
f2bc14b69c38 in his tree (5.12+) that there's a fix available.

--=20
Vitaly

