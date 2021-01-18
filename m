Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8722FA7CB
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 18:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436683AbhARRnp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 12:43:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25682 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436673AbhARRno (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 12:43:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610991738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q4cQmVB7rPkKN0lIyTwBigmFg7vXKmiWuiy12Zgd5T0=;
        b=dlrPaj5J8S27zF99ZuJI2fggaWUnQWPuPuC4NqKWjZBtwsXEfBtCajJXFRb8qU/3ruNeBm
        rSnsFScqDaza0vBTHkh17eCy0QLVH7ZSiozB+Ba/OIhIyYsklwHiHQSynwCf86BGOodfgI
        ssWxYryioreSoWZ+MA6snxg15A2Jrig=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-Vc0eruBmOHS-WwcGBksmMQ-1; Mon, 18 Jan 2021 12:42:14 -0500
X-MC-Unique: Vc0eruBmOHS-WwcGBksmMQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05422B8101;
        Mon, 18 Jan 2021 17:42:13 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-189.ams2.redhat.com [10.36.112.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6FB718F15;
        Mon, 18 Jan 2021 17:42:11 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] fix a arrayIndexOutOfBounds in function
 init_apic_map, online_cpus[i / 8] when i in 248...254.
To:     Xinpeng Liu <liuxp11@chinatelecom.cn>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
References: <1608642049-21007-1-git-send-email-liuxp11@chinatelecom.cn>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <247c12f5-ba85-e24d-3747-ba561db96551@redhat.com>
Date:   Mon, 18 Jan 2021 18:42:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1608642049-21007-1-git-send-email-liuxp11@chinatelecom.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/12/2020 14.00, Xinpeng Liu wrote:
> refer to x86/cstart64.S:online_cpus:.fill (max_cpus + 7) / 8, 1, 0
> 
> Signed-off-by: Xinpeng Liu <liuxp11@chinatelecom.cn>
> ---
>   lib/x86/apic.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/x86/apic.c b/lib/x86/apic.c
> index f43e9ef..da8f301 100644
> --- a/lib/x86/apic.c
> +++ b/lib/x86/apic.c
> @@ -232,7 +232,7 @@ void mask_pic_interrupts(void)
>       outb(0xff, 0xa1);
>   }
>   
> -extern unsigned char online_cpus[MAX_TEST_CPUS / 8];
> +extern unsigned char online_cpus[(MAX_TEST_CPUS + 7) / 8];

According to apic-defs.h, MAX_TEST_CPUS is set to 255, so this makes sense, 
indeed!

Reviewed-by: Thomas Huth <thuth@redhat.com>

