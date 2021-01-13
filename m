Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55D582F44E2
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 08:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbhAMHKT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 02:10:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52070 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726215AbhAMHKT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 02:10:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610521732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8eAI57pJ3zxOCZ/AfaPs/PP4XVJRFb7Zj25N+2rObR0=;
        b=HF4vvssKSCOQoJ3pAn99ELH0Chu+T5CIZoiZ6kDvifyn3kiyI9YDtqP8p1grnOFB4TET05
        /Kk55uA0G+oxqTCvEFe8enXjIFY79tOKaDLMd1FD5zi4I9a198bnOVl1WXNEpmn56D4AWE
        uO2DzToI8Jw+YZQzmSMZAgFlEUFGnHU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-9ffbBb3VNLiwHuorjnBhmQ-1; Wed, 13 Jan 2021 02:08:49 -0500
X-MC-Unique: 9ffbBb3VNLiwHuorjnBhmQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC9B7107ACF7;
        Wed, 13 Jan 2021 07:08:47 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-122.ams2.redhat.com [10.36.112.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A70E36F97C;
        Wed, 13 Jan 2021 07:08:34 +0000 (UTC)
Subject: Re: [PATCH 4/9] libvhost-user: Include poll.h instead of sys/poll.h
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>, qemu-devel@nongnu.org,
        QEMU Trivial <qemu-trivial@nongnu.org>
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
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
References: <20201221005318.11866-1-jiaxun.yang@flygoat.com>
 <20201221005318.11866-5-jiaxun.yang@flygoat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <a7c9dee2-0f9d-283b-0c66-f34db51fe345@redhat.com>
Date:   Wed, 13 Jan 2021 08:08:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201221005318.11866-5-jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/12/2020 01.53, Jiaxun Yang wrote:
> Musl libc complains about it's wrong usage.
> 
> In file included from ../subprojects/libvhost-user/libvhost-user.h:20,
>                   from ../subprojects/libvhost-user/libvhost-user-glib.h:19,
>                   from ../subprojects/libvhost-user/libvhost-user-glib.c:15:
> /usr/include/sys/poll.h:1:2: error: #warning redirecting incorrect #include <sys/poll.h> to <poll.h> [-Werror=cpp]
>      1 | #warning redirecting incorrect #include <sys/poll.h> to <poll.h>
>        |  ^~~~~~~
> 
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
>   subprojects/libvhost-user/libvhost-user.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/subprojects/libvhost-user/libvhost-user.h b/subprojects/libvhost-user/libvhost-user.h
> index 7d47f1364a..3d13dfadde 100644
> --- a/subprojects/libvhost-user/libvhost-user.h
> +++ b/subprojects/libvhost-user/libvhost-user.h
> @@ -17,7 +17,7 @@
>   #include <stdint.h>
>   #include <stdbool.h>
>   #include <stddef.h>
> -#include <sys/poll.h>
> +#include <poll.h>
>   #include <linux/vhost.h>
>   #include <pthread.h>
>   #include "standard-headers/linux/virtio_ring.h"
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

