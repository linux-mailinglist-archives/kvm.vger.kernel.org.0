Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A313682CA7
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 13:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbjAaMf4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 07:35:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbjAaMfz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 07:35:55 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 013E14DCE3
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 04:35:45 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id u72so17845161ybi.7
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 04:35:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vQn+TZx2ZHg1ApK09QZ06jQPj+oxkoi+MpHZ23vJ/Mo=;
        b=SUoYVHk6JknUbDyV3+y2XxOlGAx0wbz6zPz0hDrvwIcmWO3KF47MMR6Ik4X2wQLU6L
         oNwWcRAmcpmGwiJxGHjr9xmbNr2S/F9xP383wGXCdjUABZfZb36VxM7R4uajIplJQQwA
         j4OzpwN//6CECGck374xZYMFakfthacfCzVRfBvOfJeacFmvMNuQGh0itFVZOG7/StIm
         FGTR/tZvHYkyKrCc1Nw+cTSz4f7FwZAKH5EewKWK0r/UAhlIrqke0iMdFQpGbSHlkX0D
         uLN2fQPpGzIYierqyS21Zp73OGb/8HQhVtc57B+khefwgEBJaQ2uwv5p5i2N2oRP0tYq
         kclA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vQn+TZx2ZHg1ApK09QZ06jQPj+oxkoi+MpHZ23vJ/Mo=;
        b=KCZpakBGF1Avn5PRKgUEXX27H0QpVbZDe/A+3aQ0Jm45PUSKYOcvh2PxRMsbTR2BHU
         LI+2aEOPq5u/vpWrQUTl7LSsi6c2dHH9Zr41VKrnqN5UhjcoLIHUwpD1QUyExofYPHJD
         IbtTkU/PjCr6FzSCm/XR6EDZETNTUt3xEObsr0qnDI/2eaZZz/qO3LhLzpeSI7DIM+kJ
         ArHHQgM8mgn8VtbFalVLvHqo0AtDqgnqJwvszjXC4dWOtM+YVuD6GUJEeFo7M8abNbxy
         1KKGo6gG8uEWK4QILwzGpH+lx9jgpTnWQUUs7pNhUF/fc+UmdWz4ZypACLmNQsI9ll9Y
         t9Dw==
X-Gm-Message-State: AO0yUKW6dilm7R9BQnb3a7Ub1x+NJv3wjPVVCU3yD+k4LRRyfH+/84LJ
        G9xGWs/ORkiP78rzLHksKXyu+vz9kvTch+Y9eAuolQ==
X-Google-Smtp-Source: AK7set+WXs6daZruHvyrocSF896E3CxVGcrQOI3JhFDNxYzHQLkkFrrrqU4xfxSofcZ59ugZQKkUJnVf0ucFbmsbLIs=
X-Received: by 2002:a25:cfd7:0:b0:80b:8a60:fc4 with SMTP id
 f206-20020a25cfd7000000b0080b8a600fc4mr1549332ybg.541.1675168545233; Tue, 31
 Jan 2023 04:35:45 -0800 (PST)
MIME-Version: 1.0
References: <20230125142056.18356-1-andy.chiu@sifive.com> <20230125142056.18356-15-andy.chiu@sifive.com>
 <Y9MKeqtT+PEe7KTY@spud>
In-Reply-To: <Y9MKeqtT+PEe7KTY@spud>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Tue, 31 Jan 2023 20:34:00 +0800
Message-ID: <CABgGipW1E3922+TM6tgWEeAsDbogrNxB1rBxFdshqjdP3oO=Mw@mail.gmail.com>
Subject: Re: [PATCH -next v13 14/19] riscv: signal: Report signal frame size
 to userspace via auxv
To:     Conor Dooley <conor@kernel.org>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>, Zong Li <zong.li@sifive.com>,
        Nick Knight <nick.knight@sifive.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Andrew Bresticker <abrestic@rivosinc.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 27, 2023 at 7:19 AM Conor Dooley <conor@kernel.org> wrote:
>
> On Wed, Jan 25, 2023 at 02:20:51PM +0000, Andy Chiu wrote:
> > diff --git a/arch/riscv/include/asm/processor.h b/arch/riscv/include/asm/processor.h
> > index 44d2eb381ca6..4f36c553605e 100644
> > --- a/arch/riscv/include/asm/processor.h
> > +++ b/arch/riscv/include/asm/processor.h
> > @@ -7,6 +7,7 @@
> >  #define _ASM_RISCV_PROCESSOR_H
> >
> >  #include <linux/const.h>
> > +#include <linux/cache.h>
>
> What have I missed that is the reason for adding this header?
>
__ro_after_init is defined in linux/cache.h, so we need that header.
> >  #include <vdso/processor.h>
> >
> > @@ -203,8 +205,10 @@ static size_t cal_rt_frame_size(void)
> >
> >       frame_size = sizeof(*frame);
> >
> > -     if (has_vector() && vstate_query(task_pt_regs(current)))
> > -             total_context_size += rvv_sc_size;
>
> Usual naming comment here about rvv.
Ok, changing it to riscv_v_
>
> Thanks,
> Conor.
>
