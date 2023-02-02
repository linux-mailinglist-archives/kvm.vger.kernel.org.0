Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B82AC68870C
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 19:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbjBBStD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 13:49:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232579AbjBBStA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 13:49:00 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36EB2D48
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 10:48:59 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id j29-20020a05600c1c1d00b003dc52fed235so2183180wms.1
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 10:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hyIuku1DLw3Kq70v/GpC6w5pbvVSADLCrJO9Kfo6jnE=;
        b=B+hTTsIpPXufuh3YNnn326L0bofkR55sUD2C8YR4wnrOd/T1pmzVKMOGZ2CELwjlPN
         +XxqxDdGE7UKGrlA1VOtX5E9ROQUhY5tg0i9lb6iqcfoRnbFieEPHMoHuP+MFQ2M/fz2
         /KJ7/CM6DXm8xHX2Vxeq3pZ9fbyPAkWPmw/FfqCgM45DFRIv6gkJZ18TmzF6UKyfuL9Q
         8RzM18wxGX7Z6cvhzE5QsQ1qZpRqQPpO2NhxWleXS73tkmWPhhhpkRY0A98ULGmcg8fF
         /Y3EeZdihnRtEzs/XWNudPzXhTK6eQ9beFixFwDTWVhmhhtjb/Q5VCO93LxiNG8GqVt2
         ZBeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hyIuku1DLw3Kq70v/GpC6w5pbvVSADLCrJO9Kfo6jnE=;
        b=l4wquk1ftYFWAoas2+2x86AOmYhYcW5+QMIVmR1p0NhA7jx7jtpRmdVqIbx+XCVBVV
         d+qiqJVJPjpS9Xg/xU5I+QGT6OKVMfc1Z/XA564ngG+bZB5IQ5iWC4Xq+5McpTaADaBk
         32zFq0C73O1bGNapGwc1qujg6jc1NKK+asqf9LbSNc1wuxcwPTMnjNR1dWzH3TVfMqS5
         Ed76GLHc9KkMWAs+kabwIbdiJ9kibBd6l9h1ogO6gx+mbH39Fr+Vyoc2j8OGEWEmNqJ6
         IM3WAsC5YpJqDO9tQRqCZXBfT9ZuqZLQiKJtaovQ2F55R3scbDhAVktHhuX37ajWurjk
         /IJA==
X-Gm-Message-State: AO0yUKW+ucqJXBiAKDYsDF+66TBBsj7F/+mXVVG7soo1r6jFXW0I9v4f
        DNblWpU/TNg2BZjv0gfqDW++1A==
X-Google-Smtp-Source: AK7set9DkB6Y38JyS2pl/dSssNbOlSVrKpDPsMqQqNpIhqkiEvGOx+L4qp0KckHTYsEBBlDSUGZFBw==
X-Received: by 2002:a05:600c:601b:b0:3dc:443e:4212 with SMTP id az27-20020a05600c601b00b003dc443e4212mr7330912wmb.1.1675363738367;
        Thu, 02 Feb 2023 10:48:58 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id l21-20020a05600c1d1500b003dc59d6f2f8sm655370wms.17.2023.02.02.10.48.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 10:48:58 -0800 (PST)
Date:   Thu, 2 Feb 2023 19:48:57 +0100
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
Subject: Re: [PATCH v4 14/14] RISC-V: KVM: Increment firmware pmu events
Message-ID: <20230202184857.knf3cle6j2cd7a4n@orel>
References: <20230201231250.3806412-1-atishp@rivosinc.com>
 <20230201231250.3806412-15-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201231250.3806412-15-atishp@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 01, 2023 at 03:12:50PM -0800, Atish Patra wrote:
> KVM supports firmware events now. Invoke the firmware event increment
> function from appropriate places.
> 
> Reviewed-by: Anup Patel <anup@brainfault.org>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/kvm/tlb.c              | 4 ++++
>  arch/riscv/kvm/vcpu_sbi_replace.c | 7 +++++++
>  2 files changed, 11 insertions(+)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
