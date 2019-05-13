Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B29D1B760
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 15:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbfEMNu7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 09:50:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39298 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726866AbfEMNu7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 09:50:59 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A9628307D91E;
        Mon, 13 May 2019 13:50:59 +0000 (UTC)
Received: from flask (unknown [10.40.205.238])
        by smtp.corp.redhat.com (Postfix) with SMTP id 947E05BBA1;
        Mon, 13 May 2019 13:50:57 +0000 (UTC)
Received: by flask (sSMTP sendmail emulation); Mon, 13 May 2019 15:50:56 +0200
Date:   Mon, 13 May 2019 15:50:56 +0200
From:   Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] x86: Halt on exit
Message-ID: <20190513135055.GA8697@flask>
References: <20190509195023.11933-1-nadav.amit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509195023.11933-1-nadav.amit@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Mon, 13 May 2019 13:50:59 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

2019-05-09 12:50-0700, Nadav Amit:
> In some cases, shutdown through the test device and Bochs might fail.
> Just hang in a loop that executes halt in such cases.
> 
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>  lib/x86/io.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/lib/x86/io.c b/lib/x86/io.c
> @@ -99,6 +99,10 @@ void exit(int code)
>  #else
>          asm volatile("out %0, %1" : : "a"(code), "d"((short)0xf4));
>  #endif
> +	/* Fallback */
> +	while (1) {
> +		asm volatile ("hlt" ::: "memory");
> +	}
>  	__builtin_unreachable();

Looks good, we can also drop the __builtin_unreachable() now.
