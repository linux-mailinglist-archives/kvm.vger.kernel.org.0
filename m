Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60224225BE
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 13:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbhJELzn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 07:55:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55328 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232658AbhJELzm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 07:55:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633434832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ipJvJT+v6yt9zU5Ii84mTzCzbNo7bGPcsz8IZtbMm48=;
        b=ZxqEVFbMWsECC3B5BKGHLJi7TOns+1JCLWFSpQ7SL3oicF7MG6B5CTc75yXr3HRqLBbTQN
        tTPon3mvTQR7wGRWnK2Uv6Xvx+ZpzcVQFi1nV3Nrnnr1LOfn5VZr20awZ9PTusORSz7Jer
        GHP/X5bM2QOEuKskMwm6FaMKwOe/UWY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-YvNca_vLOL-WQYpTIV77aQ-1; Tue, 05 Oct 2021 07:53:51 -0400
X-MC-Unique: YvNca_vLOL-WQYpTIV77aQ-1
Received: by mail-ed1-f69.google.com with SMTP id 14-20020a508e4e000000b003d84544f33eso20415011edx.2
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 04:53:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ipJvJT+v6yt9zU5Ii84mTzCzbNo7bGPcsz8IZtbMm48=;
        b=GBhZth6+C6v+mpdk+J5IN4FkZz4wD5Hhu5Y5orDX7PN/ogVutve1Y51L99Rhki1SXd
         Dm/7PPFqktU8IPUJYcJL5Euo5kMhglK5aP/ZQAx4HzkPLwc4PW5QyamMH5Q38uqxfHtf
         LwcpahaSfpHQGKCsZp312HfjpPx7+rM0c13pPijrtCf8mBmz5dX2NSJtKxKLi8oE80V8
         Nov6wmspUFpVcvfrUKSConTA/Jb16ca1gVxSo4cRILikeBUOjOITWPymGzk1tVDn1L/Z
         3LCHro6Vkz55NNtanpjMTFf46snQ/+xjzFa2eVRdQ4Ewd1WF50Aq5O8GAkRIULAQgcX6
         Qd6Q==
X-Gm-Message-State: AOAM532/Gw3OsezaYzTvtGRZQ3uhHWZymNJZa3jF7Dw+cscSCM8KoI17
        vbncDxCaX5CfTn7wPNPMWbcIBeNBzhfqRx4od3MOL1xRHDW1QViF70FlUPgSmqP66mWoXl9TVdB
        z3i31r2Ey28KH
X-Received: by 2002:a17:907:2896:: with SMTP id em22mr10275625ejc.365.1633434829524;
        Tue, 05 Oct 2021 04:53:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy7NZJRS3nsuSLLPnAGmTBCi5hvPKn3TAype/v0D2huOK2oa40DJK7oTvG3x1UAoFyI07HuFw==
X-Received: by 2002:a17:907:2896:: with SMTP id em22mr10275596ejc.365.1633434829202;
        Tue, 05 Oct 2021 04:53:49 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id t20sm7636612ejc.105.2021.10.05.04.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 04:53:48 -0700 (PDT)
Date:   Tue, 5 Oct 2021 13:53:47 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 4/5] Use report_fail(...) instead of
 report(0/false, ...)
Message-ID: <20211005115347.palt5njjhopxvtsg@gator.home>
References: <20211005090921.1816373-1-scgl@linux.ibm.com>
 <20211005090921.1816373-5-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005090921.1816373-5-scgl@linux.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 05, 2021 at 11:09:20AM +0200, Janis Schoetterl-Glausch wrote:
> Whitespace is kept consistent with the rest of the file.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>  lib/s390x/css_lib.c |  30 ++++----
>  x86/vmx.h           |  25 ++++---
>  arm/psci.c          |   2 +-
>  arm/timer.c         |   2 +-
>  s390x/css.c         |  18 ++---
>  s390x/spec_ex.c     |   7 +-
>  x86/asyncpf.c       |   4 +-
>  x86/hyperv_stimer.c |   6 +-
>  x86/hyperv_synic.c  |   2 +-
>  x86/svm_tests.c     | 163 ++++++++++++++++++++++----------------------
>  x86/vmx.c           |  17 +++--
>  x86/vmx_tests.c     | 136 ++++++++++++++++++------------------
>  12 files changed, 200 insertions(+), 212 deletions(-)
>

Hi Janis,

Thank you for this cleanup.

Reviewed-by: Andrew Jones <drjones@redhat.com>

