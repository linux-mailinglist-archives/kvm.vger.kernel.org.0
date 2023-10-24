Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3216F7D4FC6
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 14:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbjJXMbA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 08:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233116AbjJXMa6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 08:30:58 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A30A129
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 05:30:56 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id 38308e7fff4ca-2c4fe37f166so63315981fa.1
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 05:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698150654; x=1698755454; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qkkKPtB+0MYb68gtsi8LcLr9VZV4vaP8LHEM7IjFw7M=;
        b=HGrA54cpO2V0fbpk2wT71VEodXfUamDV/VeWBc6EehN5TdmTZ724uYACcsx7WjUz0n
         25eWWD+pPLl2Pqd233ybKAaevJDGGfXwJhYNWdVT7YlbhD+sRYZuiCavyDruYzIioKoN
         9WPk17IP4iStHg/8P0oZRuAaNRlip2jODX9lblH0NgGMgrSTOGLVOvpOK+G2VAuN0O6H
         3PC7hpeKHGMvwLn3hOICGAUbH0H/kis1lO1MJKPM2SbeEzcSP+bjS+qTT6nNw9NPnaGF
         UfkP64VTpaI4/Qazww6Kzg8v2DH91u/cL7JZleFjgqXPKFVCOr2fr9RiScNR5eKwhwdJ
         Vi1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698150654; x=1698755454;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qkkKPtB+0MYb68gtsi8LcLr9VZV4vaP8LHEM7IjFw7M=;
        b=IA2gIUUAXriujw69qf7WtGdzb3KGI19SbCV2o1iExKMu4Ah3oriA8nASZqlsxY+qEX
         mgH5zHFPNBQhI2gVY4wT6KFqhScqfnWeHLjeYnQUjcUDw8PTnX/Zof23y1m4gh16l/Vb
         1RKU8+24CQMMbIr52WepqpdOYMMOcwC8ho54CO4520zPA9NDo7H62xijvHnyPNdfLljj
         r7+azTthpmQWJb86iVS/cyDLhW6OPEpdjX8y1nyc3oMHc0VdOUqv3KFZGJ0W4LpfLDzv
         9JzHV0J5okgi4FTyAIw9IXBaYh8sy/RL2RiBgC0bOjDOHRB83NBJ/RAWeuNPQmrzzB32
         lYWg==
X-Gm-Message-State: AOJu0Yxhe0DRDSrI9QN6oZy+arOIbdCD3HVVXIbX+wetdyfUJqdjDyAl
        tqMC7BuX8l+PS9OOds8YtI0=
X-Google-Smtp-Source: AGHT+IE/mzlKG6p6MNuMkl5KdeR+gdKt/64A9xubv6BdiuV2Bc68YaEih+Wh7ICweIO/TGve36ruQA==
X-Received: by 2002:a2e:a7cc:0:b0:2c5:fb9:49b6 with SMTP id x12-20020a2ea7cc000000b002c50fb949b6mr11630710ljp.10.1698150654333;
        Tue, 24 Oct 2023 05:30:54 -0700 (PDT)
Received: from [192.168.6.66] (54-240-197-238.amazon.com. [54.240.197.238])
        by smtp.gmail.com with ESMTPSA id x22-20020a05600c189600b004083a105f27sm16404394wmp.26.2023.10.24.05.30.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 05:30:53 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <d6db2c5d-da65-4f93-a340-2ca4772e86db@xen.org>
Date:   Tue, 24 Oct 2023 13:30:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 03/12] include: update Xen public headers to Xen 4.17.2
 release
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org
References: <20231016151909.22133-1-dwmw2@infradead.org>
 <20231016151909.22133-4-dwmw2@infradead.org>
Organization: Xen Project
In-Reply-To: <20231016151909.22133-4-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/2023 16:19, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> ... in order to advertise the XEN_HVM_CPUID_UPCALL_VECTOR feature,
> which will come in a subsequent commit.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   hw/i386/kvm/xen_xenstore.c                    |  2 +-
>   include/hw/xen/interface/arch-arm.h           | 37 +++++++-------
>   include/hw/xen/interface/arch-x86/cpuid.h     | 31 +++++-------
>   .../hw/xen/interface/arch-x86/xen-x86_32.h    | 19 +------
>   .../hw/xen/interface/arch-x86/xen-x86_64.h    | 19 +------
>   include/hw/xen/interface/arch-x86/xen.h       | 26 ++--------
>   include/hw/xen/interface/event_channel.h      | 19 +------
>   include/hw/xen/interface/features.h           | 19 +------
>   include/hw/xen/interface/grant_table.h        | 19 +------
>   include/hw/xen/interface/hvm/hvm_op.h         | 19 +------
>   include/hw/xen/interface/hvm/params.h         | 19 +------
>   include/hw/xen/interface/io/blkif.h           | 27 ++++------
>   include/hw/xen/interface/io/console.h         | 19 +------
>   include/hw/xen/interface/io/fbif.h            | 19 +------
>   include/hw/xen/interface/io/kbdif.h           | 19 +------
>   include/hw/xen/interface/io/netif.h           | 25 +++-------
>   include/hw/xen/interface/io/protocols.h       | 19 +------
>   include/hw/xen/interface/io/ring.h            | 49 ++++++++++---------
>   include/hw/xen/interface/io/usbif.h           | 19 +------
>   include/hw/xen/interface/io/xenbus.h          | 19 +------
>   include/hw/xen/interface/io/xs_wire.h         | 36 ++++++--------
>   include/hw/xen/interface/memory.h             | 30 +++++-------
>   include/hw/xen/interface/physdev.h            | 23 ++-------
>   include/hw/xen/interface/sched.h              | 19 +------
>   include/hw/xen/interface/trace.h              | 19 +------
>   include/hw/xen/interface/vcpu.h               | 19 +------
>   include/hw/xen/interface/version.h            | 19 +------
>   include/hw/xen/interface/xen-compat.h         | 19 +------
>   include/hw/xen/interface/xen.h                | 19 +------
>   29 files changed, 124 insertions(+), 523 deletions(-)
> 

Acked-by: Paul Durrant <paul@xen.org>

