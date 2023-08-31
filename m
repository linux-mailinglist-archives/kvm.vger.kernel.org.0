Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD7878EF9B
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 16:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344625AbjHaOeE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 10:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237750AbjHaOeC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 10:34:02 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D9BD1BB
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 07:33:59 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-99de884ad25so107322366b.3
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 07:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1693492437; x=1694097237; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=U0lR03pMKmi5rn6arMgwDOzh6T75DnnrTWH9F/+12is=;
        b=pXKKPB9lkIEseG7s31oAOxv2JL4p4TIgTwdibdVtbiooioBKgCLOY8wY7snhvxYw6h
         9nUGmteH6bmN3huVS2pxoVsVqFjHU91axAmLWt8RBbiyduPpqCU8nOiFGcSfdD1Lnt2O
         ci3OBheFrt+nyDnWLA6gEadRZzBhBG0/GL91HA6UhlESlWRspaTVFPUd8KlzGZrmift2
         bBhYHfF6mnENZ6qBT2HGOvbX3PrlK/i42deLeI3ShQJ1EDB9ujI/E9glIkXwhAb10ETt
         y8/s36oryaNY+V29Zj5yg2QjumhNXGLATQn93Lz+qew+UF3qPXXaXfWG2mkbg6mPB6C9
         Nw7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693492437; x=1694097237;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U0lR03pMKmi5rn6arMgwDOzh6T75DnnrTWH9F/+12is=;
        b=BDDUmk3SDnGcqmvucEtkCQAQb14ZMwc5CeeEgfuU6Bs6PUA4zuqazSWi8KDdExHBXP
         SHuFoIkI3Gs0tFB3gk6Bxb7zZhkaAC9zzBAdSvrsnsxvcFEEg5E7ROD6QfurSF3+gHul
         19yvpcWJxWtppFb8t6wDnte6RvVHXPztFCDgfxHaPlVJs+JQfXotDC+XrecIqfoMYgem
         HWvW2k0AJdi+IqkpuH3UxrLqrjzuU/5EnoIVfnvA/7er3ZBH08fAdWo00We9j3h+8FV0
         v4TFgjb8Zx8HG8fdR9yS0BuUwRdIwmM3r7pbw5So8ekhKjwSf1Rdf4AVl6HPuibwgpnn
         j0fA==
X-Gm-Message-State: AOJu0Yxb7ySoy7XcJT+pcBRuRaVcz8wmdj/yDpFBiQkJ4Vj9HiRsY1E4
        KE5+EcrX8yXeOZONBOFOCU865w==
X-Google-Smtp-Source: AGHT+IFPiPm6qDuv2UYpzsVgeByiC3x+4/nQDwmBqR7OZbcdlxK2cZocYnLJHl9+SbBpCbqsqvRL5w==
X-Received: by 2002:a17:907:2ccc:b0:9a1:fab3:ee3f with SMTP id hg12-20020a1709072ccc00b009a1fab3ee3fmr4622377ejc.40.1693492437655;
        Thu, 31 Aug 2023 07:33:57 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id a6-20020a170906244600b0099cce6f7d50sm827834ejb.64.2023.08.31.07.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Aug 2023 07:33:57 -0700 (PDT)
Date:   Thu, 31 Aug 2023 16:33:56 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Maciej =?utf-8?Q?Wiecz=C3=B3r-Retman?= 
        <maciej.wieczor-retman@intel.com>
Cc:     Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Reinette Chatre <reinette.chatre@intel.com>,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] selftests/kvm: Replace attribute with macro
Message-ID: <20230831-ada633c2cf0a9ff1df74e8c6@orel>
References: <cover.1693216959.git.maciej.wieczor-retman@intel.com>
 <82ed62dd7070203701b4ca326e62862404dd5f72.1693216959.git.maciej.wieczor-retman@intel.com>
 <fc618e8c-f8b-c339-9aa6-1d2c2865b42e@linux.intel.com>
 <fw6nuuhzmkp36bumrn6xuy7etxslr2iybazigaoo57iy22x2k7@nord6jkch73n>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fw6nuuhzmkp36bumrn6xuy7etxslr2iybazigaoo57iy22x2k7@nord6jkch73n>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 30, 2023 at 03:40:10PM +0200, Maciej Wieczór-Retman wrote:
> On 2023-08-30 at 15:22:57 +0300, Ilpo Järvinen wrote:
> >On Mon, 28 Aug 2023, Wieczor-Retman, Maciej wrote:
> >
> >> The __printf() macro is used in many tools in the linux kernel to
> >> validate the format specifiers in functions that use printf. Some
> >> selftests use it without putting it in a macro definition and some tests
> >> import the kselftests.h header.
> >
> >"Some" and yet this only converts one? Please be more precise in the 
> >wording.
> 
> Okay, I'll mention them by subsystem.
> 
> >> Use __printf() attribute instead of the full attribute since the macro
> >> is inside kselftests.h and the header is already imported.
> >
> >IMO, this would be enough:
> >
> >Use __printf() from kselftests.h instead of the full attribute.
> 
> Fair enough, I'll change the paragraph to that.

There are two in kvm selftests. test_assert(), a few lines down, also uses
the attribute.

Thanks,
drew

> 
> >Was there a reason why you didn't convert mm/pkey-helpers.h one?
> 
> Sorry, must have just missed it somehow. Thank you for pointing it out.
> 
> -- 
> Kind regards
> Maciej Wieczór-Retman
