Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF5B474198
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 12:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbhLNLjE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 06:39:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27025 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231611AbhLNLjD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Dec 2021 06:39:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639481942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0j8FhG3Pdijo+JlLzqQ4wiB6x9V3flBlZRvgbDc00+M=;
        b=OcPMK34HRGnZSkyndtCMK7nyX9U9M6v0K44X8/tD4YWMRjtYVVaaSTJEZ0cVf5mmRpAf8j
        nEWdXEoHAinw2WPjyg3HMKFdSKGtVKHZOJ5JCZrOtopmIFsW5iM82rU9WKhf5/4/2QpO+G
        4h11n1QPMMI9ONeIq+5ehKxYTpR222A=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-fGAX9Ix0Mq2oSGHVpf65HQ-1; Tue, 14 Dec 2021 06:36:16 -0500
X-MC-Unique: fGAX9Ix0Mq2oSGHVpf65HQ-1
Received: by mail-ed1-f69.google.com with SMTP id m17-20020aa7d351000000b003e7c0bc8523so16743505edr.1
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 03:36:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=0j8FhG3Pdijo+JlLzqQ4wiB6x9V3flBlZRvgbDc00+M=;
        b=0peN+FduZXo0auPRqfp69s0sA8h+uPHtIYStXSLBT/7Fs/dGlxGhazc5nz8Q3PHQ7O
         901Ev5OgUDzOTIzFykOWks8IRDZpuwu/oDac6XA2swNTQQwaWbSmI8lam6uWoWrvskzp
         O8oqBDdWFcXmp6+wpdC19B3mCGNt+vJ3qYWRvuFIK0518WnePCwlKo1F2Vh1+lKJISki
         6IkvLYZsmI9rWpEt653AZLAZafSp5AGneRe1AY1PKqKk1CcP7XBP36TG6HxUEzlsV6+y
         uukmgmgVmDOrt/SCWMIJBvFnF/7H42LUKhpJhu5sG4BMcxEJJuWvHdR3A3VbQXwwRmz9
         3spQ==
X-Gm-Message-State: AOAM531QspyRJPRF+ihwaZgimnpQIb6/V95qykUInivUrPrLDIyORdB5
        LpjK/ql6Iox4N3YQQKfIenjMhSU8sSy++/a6asqtQbV8D/aeH9SlVJ38Yy4Uo+mwX7v1FdDPkRh
        l1SnPkVzZRtJn
X-Received: by 2002:a17:906:9b92:: with SMTP id dd18mr5231691ejc.425.1639481775726;
        Tue, 14 Dec 2021 03:36:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy17sRiPWDlXNBUvaRGW9SLydlz3ExkOE8Neh75tU8W0vHEviUmeW4FhT9rtciIvEhPs0GjWg==
X-Received: by 2002:a17:906:9b92:: with SMTP id dd18mr5231671ejc.425.1639481775578;
        Tue, 14 Dec 2021 03:36:15 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id ck12sm4885009edb.53.2021.12.14.03.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 03:36:14 -0800 (PST)
Date:   Tue, 14 Dec 2021 12:36:12 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc:     pbonzini@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
        qemu-arm@nongnu.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, christoffer.dall@arm.com,
        maz@kernel.org
Subject: Re: [kvm-unit-tests PATCH v9 3/9] Makefile: add GNU global tags
 support
Message-ID: <20211214113612.u7g6n3ye4auj56s7@gator.home>
References: <20211202115352.951548-1-alex.bennee@linaro.org>
 <20211202115352.951548-4-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211202115352.951548-4-alex.bennee@linaro.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 02, 2021 at 11:53:46AM +0000, Alex Bennée wrote:
> If you have ctags you might as well offer gtags as a target.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> Message-Id: <20211118184650.661575-4-alex.bennee@linaro.org>
> ---
>  Makefile | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index b80c31f8..0b7c03ac 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -122,6 +122,9 @@ cscope:
>  		-name '*.[chsS]' -exec realpath --relative-base=$(CURDIR) {} \; | sort -u > ./cscope.files
>  	cscope -bk
>  
> -.PHONY: tags
> +.PHONY: tags gtags
>  tags:
>  	ctags -R
> +
> +gtags:
> +	gtags
> -- 
> 2.30.2
>

We should also add gtags' generated files to .gitignore

Thanks,
drew 

