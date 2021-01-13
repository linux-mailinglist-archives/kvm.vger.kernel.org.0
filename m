Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610FD2F451D
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 08:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbhAMHUp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 02:20:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24267 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726570AbhAMHUp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 02:20:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610522359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TGPeJYUnIMFEoxP1qOfM2rSvoX/Q+cx3KBot9HbxzzM=;
        b=NgdfHvmaOgijahzNH/XZBz/ANRZOesLEHEVJGEH2m9+/0GI2UOVM4otE4qE4WKQ2eSbeNv
        nOfShn/ivKvLWanC3GtNprT+M1W6R+6f7prXcSRVh1NQUWodsGzCUij9UaMu5B3aJ/IwKM
        zKL47eVGeY3Vy3k/shqEmyDFFmRGl8A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-FCBYT3PxPTqES4y9iGTyEA-1; Wed, 13 Jan 2021 02:19:15 -0500
X-MC-Unique: FCBYT3PxPTqES4y9iGTyEA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B49EC107ACF7;
        Wed, 13 Jan 2021 07:19:13 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-122.ams2.redhat.com [10.36.112.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A23F13470;
        Wed, 13 Jan 2021 07:19:06 +0000 (UTC)
Subject: Re: [PATCH 7/9] accel/kvm: avoid using predefined PAGE_SIZE
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>, qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Fam Zheng <fam@euphon.net>,
        kvm@vger.kernel.org,
        Viktor Prutyanov <viktor.prutyanov@phystech.edu>,
        Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        Greg Kurz <groug@kaod.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Max Reitz <mreitz@redhat.com>, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-block@nongnu.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>
References: <20201221005318.11866-1-jiaxun.yang@flygoat.com>
 <20201221005318.11866-8-jiaxun.yang@flygoat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <c108febd-1fce-c66d-2140-002d8feb0db9@redhat.com>
Date:   Wed, 13 Jan 2021 08:19:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201221005318.11866-8-jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/12/2020 01.53, Jiaxun Yang wrote:
> As per POSIX specification of limits.h [1], OS libc may define
> PAGE_SIZE in limits.h.
> 
> To prevent collosion of definition, we discard PAGE_SIZE from
> defined by libc and take QEMU's variable.
> 
> [1]: https://pubs.opengroup.org/onlinepubs/7908799/xsh/limits.h.html
> 
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
>   accel/kvm/kvm-all.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 389eaace72..3feb17d965 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -58,6 +58,9 @@
>   /* KVM uses PAGE_SIZE in its definition of KVM_COALESCED_MMIO_MAX. We
>    * need to use the real host PAGE_SIZE, as that's what KVM will use.
>    */
> +#ifdef PAGE_SIZE
> +#undef PAGE_SIZE
> +#endif
>   #define PAGE_SIZE qemu_real_host_page_size

If I get that right, the PAGE_SIZE macro is only used one time in this 
file... so it's maybe easier to get rid of the macro completely and replace 
the single occurance with qemu_real_host_page_size directly?

  Thomas

