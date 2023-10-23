Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4BB27D2F5A
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 12:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjJWJ7y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 05:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233618AbjJWJ7g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 05:59:36 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AFF41993
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 02:59:29 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-53e70b0a218so4615506a12.2
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 02:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1698055167; x=1698659967; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=F2RqADPHi/ODAXFTyOZSWwkmYe5FsXVHIx8g7uPzN3k=;
        b=TxzHXgFnllwfWEQGStaMkXTLsJzqZy7uSwFyIB2YKCiVqAk8sIO63vab/4J3mPvPS0
         vC18Om7qqbvbqBCVaOWvzeo6vl1dNRSNZqqB9DvCgeZYCNBSS+j4CNklulQ+SYfU+ECm
         fP8YZt9/nGGR3w9A5hvdHnRQYb498lbiLaqaHiGtPc8yBkkP2IhQWdKJ0X2jY+EXh+65
         ha8BClBS/cQIabJG43sz7UR0fsBTMKZy/uYdnQKHUmd889vnnMwdx26Qs2p266zJh6lC
         ElkUg0eDtVUPzHQNLcaez6uzOijA+5D6uW3mbwQIe52Vj2qGcK3tbT1rd4nZrbbOtjK6
         cLwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698055167; x=1698659967;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F2RqADPHi/ODAXFTyOZSWwkmYe5FsXVHIx8g7uPzN3k=;
        b=N6TeywFJZzZZWm06bLlb2vJ5uKS/p93jtoubVW3Dgqc0h9N9WxP35c0RxfFLVKzRxj
         VdQZ7XFqjdUdbp9sxffFGbuLn62NiZTcDS5YZ4TkIMZ89wGTu1Wz0h4sevVyt246uZfd
         w0XXHxOROxkwO2QKLqqxMvkOxzHnlhzppGA1+X45whp1zfBxe5D2/HfPQ/PB/u+eZ50o
         nYgCoBxU07JM5V/sOudZvFnKnA7rZmTXDMB4yyw6RNvg82obSLO4aU2pyB8O77SqCpjY
         edYKG/HkOqukjfM3RtspVJ28gLHm3Jptsn/mItkoy2Pm/csGun+wyXf/3Q+EIK24UosK
         pjcA==
X-Gm-Message-State: AOJu0YyaJBqOQN/rg6+/yt/4qPiqP/b0tK9g5cxmnesL61T9WKffSJ+S
        v+Ts96/jDhIcJ5CrCmUHRs36nA==
X-Google-Smtp-Source: AGHT+IEaFDXbVnpKg4vFgDf/2pwx6Ih0ZQZiABFfnw7I7V0bf3GiPKkismdRN7VeOpN7PH5sK8Co7w==
X-Received: by 2002:a05:6402:51cf:b0:53e:4cd9:2df6 with SMTP id r15-20020a05640251cf00b0053e4cd92df6mr7118888edd.25.1698055167819;
        Mon, 23 Oct 2023 02:59:27 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id x7-20020aa7d6c7000000b0053ebafe7a60sm6153661edr.59.2023.10.23.02.59.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 02:59:27 -0700 (PDT)
Date:   Mon, 23 Oct 2023 11:59:26 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH 1/5] riscv: use ".L" local labels in assembly when
 applicable
Message-ID: <20231023-8397e25545716f7f168e9007@orel>
References: <20231004143054.482091-1-cleger@rivosinc.com>
 <20231004143054.482091-2-cleger@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231004143054.482091-2-cleger@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 04, 2023 at 04:30:50PM +0200, Clément Léger wrote:
> For the sake of coherency, use local labels in assembly when
> applicable. This also avoid kprobes being confused when applying a
> kprobe since the size of function is computed by checking where the
> next visible symbol is located. This might end up in computing some
> function size to be way shorter than expected and thus failing to apply
> kprobes to the specified offset.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  arch/riscv/kernel/entry.S  | 10 +++----
>  arch/riscv/kernel/head.S   | 18 ++++++-------
>  arch/riscv/kernel/mcount.S | 10 +++----
>  arch/riscv/lib/memmove.S   | 54 +++++++++++++++++++-------------------
>  4 files changed, 46 insertions(+), 46 deletions(-)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
