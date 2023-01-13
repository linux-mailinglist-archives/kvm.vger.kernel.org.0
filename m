Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 548A3668F40
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 08:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240690AbjAMHbT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 02:31:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240683AbjAMHaq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 02:30:46 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B46B26173
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 23:25:34 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id u9so50321271ejo.0
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 23:25:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Lhi8jYvVrdulmGHgT4JCBN4U+J8RgOrkfiv27l+MC9E=;
        b=Mju254kQFDcnKmBgFm5I71D0xdTlvOv0r31tdnHhhM+zFUREh+EuS544iYShoeSGHZ
         naTLqjHTCOwLn2zB0rMfercAA8oAORGrw94CWaJ6iqDn8FO9uR58oW3JbfqncFW7vMmk
         MrVaxTDSvqYquqNijOrkV6W44rSeWs356dr6Aed+L+xXDP2U4WnLzjUlCl5mfUTTDl+0
         dyrUgN/CwrHOPSeBI96eNEY+UNRyB1HtF6wujgM/BT7zvDdHThRJKdKNUsWbwJZ5OzIp
         DsSKH/K9NOdkP9fO1yZJyYe20HcXmWtfhLTX57XnEhNyGGYVVy5VS64bfHeOhFz12u98
         I8cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lhi8jYvVrdulmGHgT4JCBN4U+J8RgOrkfiv27l+MC9E=;
        b=W5LZoYCBDE4UV29juyXqi9kcqTbmyRXPPv04Hs+R8vjC5oVVrm6JanorQO67rW2GO3
         Y9Vf1spkpV0We2Vj+mzFdTcd2Aizgz9ap7gbwXfSnAZcsURZNcjusN27SNapKE4VxC0R
         ptRG85yxcRmhsOh3DhZ5VLFOSnWaYgXvn0C4En1r/gfqTdq+gkAXtO99UIKcDV8WGe1G
         Df5cI9gItS5COl3C2KRH23Ar3Q38L/jM3vg/WvdAOBd+AZjLXX5277eT8f1wXNW6/1YY
         ReLRfvx8qkfwj9HJC3Fetxq3XsMTjseloVCN96jIhSXQWILkICDD+TVUXXvakyc86UCl
         zRYw==
X-Gm-Message-State: AFqh2kpBVyGkuK1a4Z04srC/LjabtJvh9c/Qr9luxP3CooRXMvQ9r2sS
        8qQUqJVkUegMWIJR5lL4GxPOtw==
X-Google-Smtp-Source: AMrXdXveedehEvO/75X4SdeCprtpnLol1R+4zKE3VpgAB7bVmaqC650NTja+r40AXk8ju/+o6bkgAQ==
X-Received: by 2002:a17:907:d684:b0:7c1:11fd:9b98 with SMTP id wf4-20020a170907d68400b007c111fd9b98mr70594615ejc.27.1673594733313;
        Thu, 12 Jan 2023 23:25:33 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id kx1-20020a170907774100b0084d368b1628sm7098072ejc.40.2023.01.12.23.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 23:25:32 -0800 (PST)
Date:   Fri, 13 Jan 2023 08:25:31 +0100
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
Subject: Re: [PATCH v2 03/11] RISC-V: KVM: Return correct code for hsm stop
 function
Message-ID: <20230113072531.xgg5e3rwdjvx7afy@orel>
References: <20221215170046.2010255-1-atishp@rivosinc.com>
 <20221215170046.2010255-4-atishp@rivosinc.com>
 <20230112102839.rsabb2bah5lkkx4e@orel>
 <CAHBxVyFokVx0C+a8LvYrftE=JwuDAHgPRmhMQFtV9LHGqMuJgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHBxVyFokVx0C+a8LvYrftE=JwuDAHgPRmhMQFtV9LHGqMuJgA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 12, 2023 at 10:25:06AM -0800, Atish Kumar Patra wrote:
> On Thu, Jan 12, 2023 at 2:28 AM Andrew Jones <ajones@ventanamicro.com> wrote:
> >
> > On Thu, Dec 15, 2022 at 09:00:38AM -0800, Atish Patra wrote:
> > > According to the SBI specification, the stop function can only
> > > return error code SBI_ERR_FAILED. However, currently it returns
> > > -EINVAL which will be mapped SBI_ERR_INVALID_PARAM.
> >
> > I presume the mapping referred to here is kvm_linux_err_map_sbi().
> > If so, then -EPERM isn't correct either. That maps to SBI_ERR_DENIED.
> > The only thing that will ensure we get SBI_ERR_FAILURE (-1) is
> > anything not handled by the kvm_linux_err_map_sbi switch, as we
> > need to use the default.
> >
> 
> It returns SBI_ERR_FAILURE in the next patch when kvm_linux_err_map_sbi
> is removed. Maybe I should drop this patch. The next patch does the
> correct thing anyways.

Yeah, I saw that, but then we silently fix a bug in the next patch.
I like that this is a separate patch, but it should do what it says
it's doing :-)

Thanks,
drew
