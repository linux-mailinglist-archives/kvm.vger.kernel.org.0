Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE4A668F39
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 08:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240806AbjAMH1Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 02:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240229AbjAMH05 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 02:26:57 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E01D5BA21
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 23:22:58 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id qk9so50268988ejc.3
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 23:22:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lWuYYVoSqXot/DOZI+j//EtGO8VULweHV3rtUrUQKts=;
        b=ja86f1GwueYMphnLJRJI+y8gdBDP53NwgFZ00T5Q3TkwtUQb4qfUWt1B00i9SggGUK
         INLTM0VaHEXQnm5mC9Y837MkP0AiDrUQl2LLpRdw6SE4zYa3z4p48is+LkXAvh5tCzqP
         RxKbu+Oy51lmZCKiVs9piG7eKrdmGOHcT2cCDYlSAwTPi4Qj2Z6/fx5/A6+hFvJKsoWJ
         2bAe6zqPvgqcpAZsDbjDlHXUu11YG/tYcWS8F5/qhHWhThlN3hJFt5ZvJe3d7xfnQuFP
         lL3t5i2cvnQqyfFZMJq9psHOOdXeRzlEvO0M0GBzPjVxEmfoXL7xM0BxsGigja0nNv5q
         bxbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lWuYYVoSqXot/DOZI+j//EtGO8VULweHV3rtUrUQKts=;
        b=7ljc1lJUdEBju0hLekEDEhUpihhOMzQaO+2vlSHEQuXjKhS1p67kUaioiXCXdYBdLR
         Acpb2Lpoy3kEicKAFvj//Zczi5+nHqjCMwB+gVU91VweP4BeGQcZQ5D3df/Up52UINup
         0TxVP7jl6GFutXyAtJYp1eeQvUcJHJvB1ZpFjweZtIrG9AARQPPRWCKtfRMQDL6pe/t/
         91hKGZq0ZfgzOFfC6EgTpemYkHDRVFYYF5q9mNXVGDDUtI6i8vqowoB3VW6RczANMn3l
         HqinCBPpNSFOvxp/z61KHJEF2o8z4hdnOoO60H+ayNvPtdSQOZ5Oiotxa7WklkccZ3UO
         VJ5A==
X-Gm-Message-State: AFqh2kovyiq7YAp4qNrAiZNif8nlcPwOJIppj1j5ZS/xlta+hQyd7fz6
        NG6HdW4frLstEK9a1F9VIkhECKoAxrcULJNK
X-Google-Smtp-Source: AMrXdXst/nbGaFkV7tpr0xcLPzua3V2BMbolci8e6vxk00MeX1OaHUgkB3WAdHNwxahT4gB0JunbNw==
X-Received: by 2002:a17:907:c70b:b0:7c0:e535:13fd with SMTP id ty11-20020a170907c70b00b007c0e53513fdmr71184178ejc.70.1673594577254;
        Thu, 12 Jan 2023 23:22:57 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id q1-20020a17090676c100b007c0d4d3a0c1sm8262849ejn.32.2023.01.12.23.22.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 23:22:56 -0800 (PST)
Date:   Fri, 13 Jan 2023 08:22:55 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Atish Kumar Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Eric Lin <eric.lin@sifive.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 01/11] RISC-V: Define helper functions expose hpm
 counter width and count
Message-ID: <20230113072255.34cnyautbwiy25p5@orel>
References: <20221215170046.2010255-1-atishp@rivosinc.com>
 <20221215170046.2010255-2-atishp@rivosinc.com>
 <20230112100608.d7tnvhbotjfctlgk@orel>
 <CAHBxVyESkQ9Krmn-44f-A8hYzMrZBtBfq15fdx-sHDQfkBMtKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHBxVyESkQ9Krmn-44f-A8hYzMrZBtBfq15fdx-sHDQfkBMtKQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 12, 2023 at 10:18:05AM -0800, Atish Kumar Patra wrote:
> On Thu, Jan 12, 2023 at 2:06 AM Andrew Jones <ajones@ventanamicro.com> wrote:
> >
> > On Thu, Dec 15, 2022 at 09:00:36AM -0800, Atish Patra wrote:
...
> > > +EXPORT_SYMBOL(riscv_pmu_get_hpm_info);
> >
> > EXPORT_SYMBOL_GPL ?
> >
> 
> Is that mandatory ? I have seen usage of both in arch/riscv and other
> places though.
> I am also not sure if any other non-GPL module should/need access to this.

TBH, I'm not sure what the best policy is, but I presumed we should use
_GPL when we aren't aware of anything non-GPL and then when a day comes
that something non-GPL would like this to be exported, the patch that
flips it will provide the justification in its commit message.

Thanks,
drew
