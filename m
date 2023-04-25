Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF1B6EE002
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 12:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233273AbjDYKKR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 06:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233615AbjDYKKO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 06:10:14 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB9F7AA6
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 03:10:12 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3f178da219bso55528125e9.1
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 03:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682417411; x=1685009411;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vtb03uUaqFAyvT9+8dESXEX2UjRUYdJ1jXmqidOzMXM=;
        b=ZqMHdUxKJmH1qXKvO4J6mJkh9bFteuP+JMCXJqQx2Nkz9aM6UuDKBupegNznU+1zuK
         1n852jUfRQDWIm7S3JAlA9cmktkU4icPF9l6NzvHooOEUwk2vPHbuaYk8/Dz5xgHU4nL
         XEVDNKeRXGjXP543GQgLt+WbuOP/NpKD5RvZ2q9xGSZfFsgWoRl4TQpmqxN9byH/AST+
         n2MI+XHKp4Ejc17U5C0DXi5USHDL+deQO6eMp9QLUkOKVhtwnmEfCKvrtRttnTIUSmlR
         IxKXn75EnRQz+uMcFfASNAo70TcG7Kx6yYK4LiFNmYf6DikFXiL6oEeoQPQvV3JYgGms
         se3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682417411; x=1685009411;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vtb03uUaqFAyvT9+8dESXEX2UjRUYdJ1jXmqidOzMXM=;
        b=j+T/S0QZG8zxSrbH6A8/TfHpElPq9DbvLEh5TdKvOS/IfoVZwBk+gwSTSVg6/23jKL
         o1/aOZrdRF/yrqfi0mKSPf+k3WqVn4byoszwBA12mHqWDB5BOMnr+a+sgsx9WKjaFJEu
         9bHLW2o42pRQgzmhS53EufVpOQI/TOJ4AuOr+Pv1Um7uTJJbilsdr77Z8nYEgei98yoF
         1BphLd/FiusybAhj8I+yNmS6/XlWC922c5ZyB4PhZ+QgVMYOh/phHm4QEbSDhy4d+GbO
         6hc6Te+ZOFwU9qYxYNk9e27HRB2xxH/kdnYP+DkYVWhszCIcH39k2c8x2Kat/r9Dfkvi
         djWw==
X-Gm-Message-State: AAQBX9ftHlaHbFB+aHBAlLZnPj8GrbOvUzfh9JeNEMMSMqwaFcNYR0xv
        2olvn40hhYa2xS3FfJpYdpNGKq3bm8HEDIZuRQ0=
X-Google-Smtp-Source: AKy350YY51gL0bSWTuGORc5mQ2lzbPSz24CoqCqdoR+Dij2QcFTnHXFTFvsf9DzleLi0lFZEQvZI2A==
X-Received: by 2002:a1c:e901:0:b0:3f1:7bac:d411 with SMTP id q1-20020a1ce901000000b003f17bacd411mr9539348wmc.39.1682417411181;
        Tue, 25 Apr 2023 03:10:11 -0700 (PDT)
Received: from myrica (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id p13-20020a7bcc8d000000b003ee63fe5203sm14539095wma.36.2023.04.25.03.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 03:10:10 -0700 (PDT)
Date:   Tue, 25 Apr 2023 11:10:11 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org, suzuki.poulose@arm.com
Subject: Re: [PATCH kvmtool 14/16] Factor epoll thread
Message-ID: <20230425101011.GB976713@myrica>
References: <20230419132119.124457-1-jean-philippe@linaro.org>
 <20230419132119.124457-15-jean-philippe@linaro.org>
 <20230421181129.182396a7@donnerap.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230421181129.182396a7@donnerap.cambridge.arm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 21, 2023 at 06:11:29PM +0100, Andre Przywara wrote:
> > +	read(epoll->stop_fd, &stop, sizeof(stop));
> > +	write(epoll->stop_fd, &stop, sizeof(stop));
> 
> read(2) and write(2) (sys)calls without checking the return value upsets
> Ubuntu's compiler:
> 
> epoll.c: In function ‘epoll__thread’:
> epoll.c:27:2: error: ignoring return value of ‘read’, declared with attribute warn_unused_result [-Werror=unused-result]
>    27 |  read(epoll->stop_fd, &stop, sizeof(stop));
>       |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> (same for the write in the line after)
> Since we use -Werror, this is fatal.
> 
> I fixed it for now with:
> 	if (read(epoll->stop_fd, &stop, sizeof(stop)) < 0)
> 		return NULL;
> 
> Not sure if there is a more meaningful way to bail out at this point.

Ah right, previous code did `tmp = write(fd, &tmp, sizeof(tmp))` which
seemed too silly to keep, and my compilers didn't complain. I'll add
pr_warnings here.

Thanks,
Jean

