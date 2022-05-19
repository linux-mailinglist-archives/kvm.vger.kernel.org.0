Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8AD852CAE7
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 06:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbiESEZI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 00:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbiESEZH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 00:25:07 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455AE506F0
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 21:25:05 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id o16so2895441ilq.8
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 21:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YTrr1nUWysdYXc7WuM/wpP2cN90f/4jJY4FwZqSrNtA=;
        b=nu/Y8LdWfMl684PpqUBrKSgVOfArcxWKcEuRonl078IfuXQlcUUKHm43egxlBfQSFI
         TWfMwZw3hYahKUD2FcoCGqDTuOkwZxGVxYQzWbwz1kCIX/aHTw4A2H33rT5lss6fw7wU
         mDiDKUC5qlp+o98w6LMUcBqkwI8YUH4KdytF6hy/SYMoSPSz7zSOGgyP3t6Bj71TV52p
         gJi1bcJjkjTbpqw3WdGuZ+OGWgbmKHWFpV75D4xjz2OSIz3Vo8Q+i1+fmoPjvqBNg9Nh
         KyEjMtDB1Foo3B6tC1yuM6ZPT+z2DpVjkt1ba0HOhV/PMk7ZmFZZQ+Jg4NTOElp4an7F
         Oqpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YTrr1nUWysdYXc7WuM/wpP2cN90f/4jJY4FwZqSrNtA=;
        b=VtOsljYTyRoJAYe4VXEJxNejhTL5YycvIHW+rWIWSSUc8kqdW0NQTA2JCmmvOG+wRA
         EHJYWs8RdmPdht6UjwDg5tRJTVR+OIpb+/ZuVZE6gHn5DA11rmtXvdg3nBAqKW6fkXHr
         AzoALCmi52yc+EzPrU+QUz8sza6xtQsr8+vyXOFtfSB2f4vNSci9R+mSSp3ciJ0uWzZm
         2NDPhZWHqRMxjzLZvdD2RTBh8MYGIID8Q1pYLzo3UrFMrobhPd4svdZg3Ou2HkwhUM3t
         wMmkJcQIvDObR3gdtC6qLtqwqOAmCP01o8hI6JkQ3+f92TVrIXHqG8ESD1C3cljeiutA
         VjbA==
X-Gm-Message-State: AOAM530yiq7vv6/1tjod7U2Lbfhs53JwuzPqyyn4gkIUXKJCZJvN5aAi
        xke/kRVojXxCr6gcfS0Kd0oUNg==
X-Google-Smtp-Source: ABdhPJz+VoJsRmPaKm0zNc9Js7DTy0qnRh4V0wyLMDcv+EscqirsHBjIR/337qjsTduEohB1A15/4A==
X-Received: by 2002:a92:602:0:b0:2d1:1497:7235 with SMTP id x2-20020a920602000000b002d114977235mr1621476ilg.242.1652934304470;
        Wed, 18 May 2022 21:25:04 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id y13-20020a6bd80d000000b00657b1ff6556sm455210iob.2.2022.05.18.21.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 21:25:03 -0700 (PDT)
Date:   Thu, 19 May 2022 04:25:00 +0000
From:   Oliver Upton <oupton@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, axelrasmussen@google.com,
        Jakub Kicinski <kuba@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH v3 08/13] tools: Copy bitfield.h from the kernel sources
Message-ID: <YoXGnBi3+2OS3j/u@google.com>
References: <20220408004120.1969099-1-ricarkol@google.com>
 <20220408004120.1969099-9-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408004120.1969099-9-ricarkol@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 07, 2022 at 05:41:15PM -0700, Ricardo Koller wrote:
> Copy bitfield.h from include/linux/bitfield.h. It defines some
> FIELD_{GET,PREP} macros that will be needed in the next patch in the
> series. The header was copied as-is, no changes needed.

nit: this commit could be the parent of several other descendants.
Perhaps ambigiously state "A subsequent change will make use ..."

Reviewed-by: Oliver Upton <oupton@google.com>
