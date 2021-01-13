Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F552F44D5
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 08:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725811AbhAMHGu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 02:06:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56213 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726493AbhAMHGu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 02:06:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610521524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kY0zJaLLaAZfbU7u5cifFOLBnqgQbzx/khQ/RPfZ2U4=;
        b=SceOld+XABU88UbMqhWKYWM8dhAeKy2YcukWjyydqH61wthMUVC7cCkT3TVkriQ3c7jD65
        jE1MFnhwP2QYEIswBruMRihlXS2vkwxsck6SeNcRO43uIHwGq9DPM1EuEPO58KjRCqDJsQ
        9mjNMK1C4xDLG7Jl4vm3k8o5yFhcHVs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-i0jsS_qiMoi_ifAcjqZjJQ-1; Wed, 13 Jan 2021 02:05:21 -0500
X-MC-Unique: i0jsS_qiMoi_ifAcjqZjJQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BAAF8066E2;
        Wed, 13 Jan 2021 07:05:19 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-122.ams2.redhat.com [10.36.112.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DAA2B1C956;
        Wed, 13 Jan 2021 07:05:11 +0000 (UTC)
Subject: Re: [PATCH 3/9] configure/meson: Only check sys/signal.h on non-Linux
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
        David Gibson <david@gibson.dropbear.id.au>
References: <20201221005318.11866-1-jiaxun.yang@flygoat.com>
 <20201221005318.11866-4-jiaxun.yang@flygoat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <fb676594-d25d-5f13-ef1e-0e4a7e77ca63@redhat.com>
Date:   Wed, 13 Jan 2021 08:05:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201221005318.11866-4-jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/12/2020 01.53, Jiaxun Yang wrote:
> signal.h is equlevant of sys/signal.h on Linux, musl would complain
> wrong usage of sys/signal.h.
> 
> In file included from /builds/FlyGoat/qemu/include/qemu/osdep.h:108,
>                   from ../tests/qemu-iotests/socket_scm_helper.c:13:
> /usr/include/sys/signal.h:1:2: error: #warning redirecting incorrect #include <sys/signal.h> to <signal.h> [-Werror=cpp]
>      1 | #warning redirecting incorrect #include <sys/signal.h> to <signal.h>
>        |  ^~~~~~~
> 
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
>   meson.build | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/meson.build b/meson.build
> index 372576f82c..1ef8722b3a 100644
> --- a/meson.build
> +++ b/meson.build
> @@ -841,7 +841,10 @@ config_host_data.set('HAVE_DRM_H', cc.has_header('libdrm/drm.h'))
>   config_host_data.set('HAVE_PTY_H', cc.has_header('pty.h'))
>   config_host_data.set('HAVE_SYS_IOCCOM_H', cc.has_header('sys/ioccom.h'))
>   config_host_data.set('HAVE_SYS_KCOV_H', cc.has_header('sys/kcov.h'))
> -config_host_data.set('HAVE_SYS_SIGNAL_H', cc.has_header('sys/signal.h'))
> +if targetos != 'linux'
> +  # signal.h is equlevant of sys/signal.h on Linux
> +  config_host_data.set('HAVE_SYS_SIGNAL_H', cc.has_header('sys/signal.h'))
> +endif

Seems like it sys/signal.h was introduced for OpenBSD once (see commit 
128ab2ff50a), so this new check should be fine.

Reviewed-by: Thomas Huth <thuth@redhat.com>

