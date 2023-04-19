Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0D236E7DAB
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 17:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbjDSPKW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 11:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233016AbjDSPKS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 11:10:18 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF317A88
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 08:10:14 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-2f4c431f69cso2093249f8f.0
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 08:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681917012; x=1684509012;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RTp707aoq2VL3Qyls5q+vhYkSC8xhwbjxcwGksIlGTY=;
        b=dZ86B+B5bMwEcC77US6b5/zYCbLxclMJHYVW5xDtcjFsJh/EgrerjrkrLev2QR5r9F
         fpmsFERfV9fddrwYIkWRcc0g3lAtQ5I2i8sMPvQUfU+ecXjhXQVVaep/SWiiZVQz12OJ
         lSClOWmmaIxLTE8OZwR5S5JuOPNoU3nqFOm+ucByMGxl7hfhucq8agstJCwpof9BWgjG
         MtYIPhKD+R/a/Q4EP3qwnQrtUrfZR/odd/zMMDX18/QGYJaOTr3NM3qor9tNoedsNs7i
         R2ozDpgb3MUZjT1UBd/L2vkqyWoJLKZQ59XdSvPvh3nlsj/Tjh33XZYK4gHZrA0mFa4z
         ZWbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681917012; x=1684509012;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RTp707aoq2VL3Qyls5q+vhYkSC8xhwbjxcwGksIlGTY=;
        b=FPLNBaUgX0hio92UBuWsovV0RxR2s9VFBI4pjTdDcrFE/SV+H4S97Tt/4KrXnYYgwe
         9G7AoepESTU7CZ0yFoFYWO+G3Ys4+LAYwCIKkzeEfSPbgt+eJLTlC+RnRhBhWRjOkCI4
         98hS15Wkp1l0J7gbvPvIYI5UXRfnrRBUnrMA3BXyW2VXfeGYIZDqIwededB7LppiGIIz
         AIUtLSr7zjmriTO3ZNRVh0d8+/qyu0fwFsEwnwNBtC2aTUDomMBh5NzqwtgNdrq8MLX2
         9pLkBnYeEnobzkWcGbzGc7JfuZ2NoEEDN6EcZK8lcwfAgi2LmV0YcKPd9Q/oPKKudmix
         il+Q==
X-Gm-Message-State: AAQBX9e32ISV8iEU8lWfRawXGzLRX3Ai2zpzz0QfyIToJaktb2fZJ81R
        4S8uD5x4MqUzNZRsEFhB1XDUJA==
X-Google-Smtp-Source: AKy350YioTZMIEYukG65amYT6Pbt32IBNWH269Y0PdowtyZTAcEtmKnkX8eeN9uEaQWRGjCjqgMrCg==
X-Received: by 2002:a5d:6dd0:0:b0:2f8:4e37:4eeb with SMTP id d16-20020a5d6dd0000000b002f84e374eebmr5110801wrz.17.1681917012410;
        Wed, 19 Apr 2023 08:10:12 -0700 (PDT)
Received: from myrica (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id t5-20020adfeb85000000b002e71156b0fcsm15985375wrn.6.2023.04.19.08.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 08:10:12 -0700 (PDT)
Date:   Wed, 19 Apr 2023 16:10:13 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kvm@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>,
        Sami Mujawar <sami.mujawar@arm.com>
Subject: Re: [PATCH kvmtool 0/2] Fix virtio/rng handling in low entropy
 situations
Message-ID: <20230419151013.GC94027@myrica>
References: <20230413165757.1728800-1-andre.przywara@arm.com>
 <20230419135832.GB94027@myrica>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419135832.GB94027@myrica>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 19, 2023 at 02:58:32PM +0100, Jean-Philippe Brucker wrote:
> On Thu, Apr 13, 2023 at 05:57:55PM +0100, Andre Przywara wrote:
> > I am not sure we now really need patch 2 anymore (originally I had this
> > one before I switched to /dev/urandom). I *think* even a read from
> > /dev/urandom can return early (because of a signal, for instance), so
> > a return with 0 bytes read seems possible.
> 
> Given that this should be very rare, maybe a simple loop would be better
> than switching the blocking mode?  It's certainly a good idea to apply the
> "MUST" requirements from virtio.

Digging a bit more, the manpage [1] is helpful:

	The O_NONBLOCK flag has no effect when opening /dev/urandom.
	When calling read(2) for the device /dev/urandom, reads of up to
	256 bytes will return as many bytes as are requested and will not
	be interrupted by a signal handler. Reads with a buffer over
	this limit may return less than the requested number of bytes or
	fail with the error EINTR, if interrupted by a signal handler.

So I guess you can also drop the O_NONBLOCK flag in patch 1. And for the
second one, maybe we could fallback to a 256 bytes read if the first one
fails

Thanks,
Jean

[1] https://man7.org/linux/man-pages/man4/urandom.4.html

