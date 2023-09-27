Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9217B0432
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 14:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbjI0Mb5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 08:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbjI0Mb4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 08:31:56 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395E812A
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 05:31:54 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-405459d9a96so99765e9.0
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 05:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695817912; x=1696422712; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gwbl0iLwHz3I+kTOQpC9LO2gOmIgGycm8pp63oFZIuQ=;
        b=m4rFIJr0/USAx9QvRrge2ZK62Oij4zkxQWGXMifNXe9vpL2v6NyWk3gFmMyKiLLyRe
         VmN9YbR37Hwj7hqdZrVY5db/tYg0NutAuwiSACA/RD/vYC8oEbR+Gc0WH1KHTuEiiwak
         uCmzMFpwwzprYOcrCXB/f9TH5DmY6EGjLHTF07hUKNPakcnPHIJ63rX7S7dxhnKPhUcf
         I+Hxes/XFftQPRYf+n3v4ezybgN4tLnU2Uu6I5Ccc1X/cSZlb5wVoDH8jAsGagozlMJN
         ZJWKBGNsYYLSOjZfSrgFi2QQch8TmQEys/MfzZQAUz6K342OgS25YCg7394SbAbpGpOw
         l0Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695817912; x=1696422712;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gwbl0iLwHz3I+kTOQpC9LO2gOmIgGycm8pp63oFZIuQ=;
        b=QQVmzjc+fR2SJlNcCk9SDVSeChRTBqSEOEK8IAaa5ge+xQgHD5r/Qtjt0OGsnEUs55
         6ZeIXTQFS1T6Rpt9C/Wr29lP/uyV+KOb+SJR3YdG5igIV1G4zghkbON2snD96LwPKkcU
         nBTgJW4068+KyB8JLiM+ZGZiIqfrz0AwwAOqCplw0rmgG64SFhxFj0rBPQF7yWUIst8q
         aUSyzyuqLGqrJuU3a+7Xj4n1/luBCzpz2qf5Y3COabbU09ZqPifTJr2lNjcKMGz34m6f
         Tb9ztdbRbTbunXYRgn2qhkUkg2K64S4nOLbRhTiuD6jdiLN1Gul2+CgRY5+myc1wSMpy
         UDDw==
X-Gm-Message-State: AOJu0Yzn2xIoEWfOrmLnHxVlQQPPzObs0tgtauEg8k36NzJ3JNvkUUDv
        VpBG6SdzkXOu7rB0F54iOvi/Xg==
X-Google-Smtp-Source: AGHT+IEsM1qpqrNdx8nJvRZ2nWWGAhqp/8kTCJYF+oYMEqweh28KzH9Tig7ntSRsLUHF3Pn/2YHAEw==
X-Received: by 2002:a05:600c:3b8c:b0:3fe:f32f:c57f with SMTP id n12-20020a05600c3b8c00b003fef32fc57fmr220093wms.0.1695817912479;
        Wed, 27 Sep 2023 05:31:52 -0700 (PDT)
Received: from google.com (203.75.199.104.bc.googleusercontent.com. [104.199.75.203])
        by smtp.gmail.com with ESMTPSA id 21-20020a05600c029500b004063ea92492sm3262251wmk.22.2023.09.27.05.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Sep 2023 05:31:51 -0700 (PDT)
Date:   Wed, 27 Sep 2023 12:31:47 +0000
From:   Mostafa Saleh <smostafa@google.com>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     kvm@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com
Subject: Re: [PATCH kvmtool] arm: Initialize target in kvm_cpu__arch_init
Message-ID: <ZRQgs_jGXe8ASQGU@google.com>
References: <20230927112117.3935537-1-smostafa@google.com>
 <14f6ab95-7de0-9c4d-3d90-5c98923dbd77@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <14f6ab95-7de0-9c4d-3d90-5c98923dbd77@huawei.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On Wed, Sep 27, 2023 at 08:21:47PM +0800, Zenghui Yu wrote:
> On 2023/9/27 19:21, Mostafa Saleh wrote:
> > arm/kvm-cpu.c: In function ‘kvm_cpu__arch_init’:
> > arm/kvm-cpu.c:119:41: error: ‘target’ may be used uninitialized [-Werror=maybe-uninitialized]
> >   119 |         vcpu->cpu_compatible    = target->compatible;
> >       |                                   ~~~~~~^~~~~~~~~~~~
> > arm/kvm-cpu.c:40:32: note: ‘target’ was declared here
> >    40 |         struct kvm_arm_target *target;
> >       |                                ^~~~~~
> 
> Already addressed by 426e875213d3 ("arm/kvm-cpu: Fix new build
> warning").

Oh, I see that now, I was on the wrong branch, thanks for pointing
this!

> Zenghui

Thanks,
Mostafa
