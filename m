Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A31A727E212
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 09:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgI3HIe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 03:08:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55646 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728416AbgI3HId (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Sep 2020 03:08:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601449712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7kUs5d+Zsd2wY/LnTcUI6w/pXXOgggi3joJfi847hNg=;
        b=cvhd22dhumvZ/cUjQgTWsVVhyi93SZsfDRfnqyYb0OJ5ZbzpmGyQ5Ewk9gAJPYrXJrA3gd
        ERO10zIcoYcPOhE67Mxx3bCUb9/+FP1135WbmfzYshrNgG9jGxLa40bzt/JB16oNcz144S
        KZjAngELpC5VbesOZiigKuqd49gBR98=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-e6i0tfBfOgCcVxw46at20Q-1; Wed, 30 Sep 2020 03:08:30 -0400
X-MC-Unique: e6i0tfBfOgCcVxw46at20Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9EBD51005E64;
        Wed, 30 Sep 2020 07:08:28 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-148.ams2.redhat.com [10.36.112.148])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 34D5473678;
        Wed, 30 Sep 2020 07:08:25 +0000 (UTC)
Subject: Re: [PATCH v4 01/12] accel/tcg: Add stub for cpu_loop_exit()
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>,
        Keith Packard <keithp@keithp.com>
References: <20200929224355.1224017-1-philmd@redhat.com>
 <20200929224355.1224017-2-philmd@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <b8a687c8-248f-abc5-a046-37e6d84a21c8@redhat.com>
Date:   Wed, 30 Sep 2020 09:08:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200929224355.1224017-2-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/09/2020 00.43, Philippe Mathieu-Daudé wrote:
> Since the support of SYS_READC in commit 8de702cb67 the
> semihosting code is strongly depedent of the TCG accelerator
> via a call to cpu_loop_exit().
> 
> Ideally we would only build semihosting support when TCG
> is available, but unfortunately this is not trivial because
> semihosting is used by many targets in different configurations.
> For now add a simple stub to avoid link failure when building
> with --disable-tcg:
> 
>   hw/semihosting/console.c:160: undefined reference to `cpu_loop_exit'
> 
> Cc: Keith Packard <keithp@keithp.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  accel/stubs/tcg-stub.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/accel/stubs/tcg-stub.c b/accel/stubs/tcg-stub.c
> index e4bbf997aa..1eec7fb90e 100644
> --- a/accel/stubs/tcg-stub.c
> +++ b/accel/stubs/tcg-stub.c
> @@ -29,3 +29,8 @@ void *probe_access(CPUArchState *env, target_ulong addr, int size,
>       /* Handled by hardware accelerator. */
>       g_assert_not_reached();
>  }
> +
> +void cpu_loop_exit(CPUState *cpu)
> +{
> +    g_assert_not_reached();
> +}
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

