Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2636EC763
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 09:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbjDXHsb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 03:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbjDXHsa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 03:48:30 -0400
Received: from out-19.mta1.migadu.com (out-19.mta1.migadu.com [95.215.58.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C551E7C
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 00:48:29 -0700 (PDT)
Date:   Mon, 24 Apr 2023 09:48:22 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682322507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Ge4j3gnxTmU0ngzIXY8tQ8YNEDBfnZ9iXMgdclq1/c=;
        b=nRmmKVoklorS7KkWjTw51dGMctVusVFHpuZF3WD73ZFcFBP0KdkgvVscr9/QCrdEOjC1N6
        w5AzMD0OHj73Z22qF6rh5+NbUaPjPprsZ9zQ8AtmNjYqEHP1Ku3HLS5kmfP5+Wsq6UyKNl
        +XHpdpy163xoZCB0ow2XdXrp5IPR7y4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     =?utf-8?B?5Lu75pWP5pWPKOiBlOmAmumbhuWbouiBlOmAmuaVsOWtl+enkeaKgOaciQ==?=
         =?utf-8?B?6ZmQ5YWs5Y+45pys6YOoKQ==?= <renmm6@chinaunicom.cn>
Cc:     kvm <kvm@vger.kernel.org>, rmm1985 <rmm1985@163.com>,
        pbonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] arch-run: Fix run_qemu return correct
 error code
Message-ID: <hzn5rocplnouiuemnxnvznhvvqbvwepqggymgevfwiqal24zt7@62nemxepzzqo>
References: <20230423043437.3018665-1-renmm6@chinaunicom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230423043437.3018665-1-renmm6@chinaunicom.cn>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Apr 23, 2023 at 12:34:36PM +0800, 任敏敏(联通集团联通数字科技有限公司本部) wrote:
> From: rminmin <renmm6@chinaunicom.cn>
> 
> run_qemu should return 0 if logs doesn't
> contain "warning" keyword.

Why? What are you trying to fix?

> 
> Fixes: b2a2aa5d ("arch-run: reduce return code ambiguity")
> Signed-off-by: rminmin <renmm6@chinaunicom.cn>
> ---
>  scripts/arch-run.bash | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 51e4b97..9878d32 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -61,7 +61,7 @@ run_qemu ()
>                 # Even when ret==1 (unittest success) if we also got stderr
>                 # logs, then we assume a QEMU failure. Otherwise we translate
>                 # status of 1 to 0 (SUCCESS)
> -               if [ -z "$(echo "$errors" | grep -vi warning)" ]; then
> +               if [ -z "$(echo "$errors" | grep -i warning)" ]; then

This will now filter out all the errors, leaving only warnings or nothing.
If you want the check to include warnings, then it should be

 if [ -z "$(echo "$errors")" ]

>                         ret=0
>                 fi
>         fi
> --
> 2.33.0
>

Thanks,
drew
