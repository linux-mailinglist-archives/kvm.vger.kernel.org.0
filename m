Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 132A36880D8
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 16:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232448AbjBBPAA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 10:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbjBBO7w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 09:59:52 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8CF561A3
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 06:59:50 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id a2so1686117wrd.6
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 06:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VJXuWjYMjwbPFa35qXTKy9wFE4zpb2ewjJThLel4jN4=;
        b=hEKVsotfgGwf8yGzpusX0UAczutUtO5B0oucd0f+sO6U22rwODuHT4QkfqfwXvXhRg
         ho/hVYSxWsOOI4MtY5IEwid4NilUewQPoJhgCscO6YQ1sJs2szr9Vfl9+JwHnnMoGJNP
         1LLz+f5X6JBhw3vRAg97eGYG3skaaB/QLtYEgEFTor0iQUkZCIJ5GaDMOCcsCS+G6+CX
         LwfZW+gRluBew25jNu+y4Wr5Jn/yYcRYi5bQF8bxIutnZgPQwmO+um5AhF50V9Yg+YT9
         1VYgRWehKaYWvqFxyiCKaljmDjrlnf4hBStjS75iDHDtYNajiXE+a+5nMZljdsrg5HxR
         NL7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VJXuWjYMjwbPFa35qXTKy9wFE4zpb2ewjJThLel4jN4=;
        b=y8I/x8TMv/Ti5CpiAKF3zZUI1F+dZH9zQeiEqh43LoA/xvPWYI9JeZ8M9p+g2BW+2R
         l4D8ud+sJm8KAvE5Gk8luORxqmCad4fJWZ0kI4H15hIZo8Q4WyqJPooaXn1YzeOUd2YK
         auUw76uISv/xdotQrl/KBC4fhYFioLQnxVa6UYNwF8iSCC5eCpUomQMYibsF8eD9BUM6
         UsR7cKI7hVaR3xYOoMc6XmacP0H568vvMUnuI2/KoPqawV33nm5xGsFqrQdcDmNkWhqf
         F3Ygi7f8bzkCDUfvetvTLr9Ar9Q7xMpqfOiOss0xs56wh0RolXcQV6DCHGUj/i9YVNEz
         aAQw==
X-Gm-Message-State: AO0yUKWNbfJW5DxIE86rSju/TKj1cScNw9rSOR2E7x7gl/tXiIiSv0X6
        YlMnulg9Q2PVPhNv3ZYfMmOpHQ==
X-Google-Smtp-Source: AK7set+ScVRXdqzlp1+dJn9JBWeb9vWKiXkVq/8dz7Cx+fQgfPHbJR8lRGbMgjKGu92H6umfh9m2Lw==
X-Received: by 2002:adf:f702:0:b0:2bc:8074:b702 with SMTP id r2-20020adff702000000b002bc8074b702mr5883218wrp.19.1675349989348;
        Thu, 02 Feb 2023 06:59:49 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id t16-20020adfe450000000b002bbdcd15e44sm19646402wrm.37.2023.02.02.06.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 06:59:48 -0800 (PST)
Date:   Thu, 2 Feb 2023 15:59:48 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atishp@atishpatra.org>,
        Eric Lin <eric.lin@sifive.com>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 01/14] perf: RISC-V: Define helper functions expose
 hpm counter width and count
Message-ID: <20230202145948.jrgjc27t2tbney2l@orel>
References: <20230201231250.3806412-1-atishp@rivosinc.com>
 <20230201231250.3806412-2-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201231250.3806412-2-atishp@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 01, 2023 at 03:12:37PM -0800, Atish Patra wrote:
> KVM module needs to know how many hardware counters and the counter
> width that the platform supports. Otherwise, it will not be able to show
> optimal value of virtual counters to the guest. The virtual hardware
> counters also need to have the same width as the logical hardware
> counters for simplicity. However, there shouldn't be mapping between
> virtual hardware counters and logical hardware counters. As we don't
> support hetergeneous harts or counters with different width as of now,
> the implementation relies on the counter width of the first available
> programmable counter.
> 
> Reviewed-by: Anup Patel <anup@brainfault.org>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  drivers/perf/riscv_pmu_sbi.c   | 37 ++++++++++++++++++++++++++++++++--
>  include/linux/perf/riscv_pmu.h |  3 +++
>  2 files changed, 38 insertions(+), 2 deletions(-)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
