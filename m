Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBE769DE36
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 11:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233874AbjBUKvw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 05:51:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233222AbjBUKvu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 05:51:50 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2F421A25
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 02:51:16 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id c5so4612455wrr.5
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 02:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jrtc27.com; s=gmail.jrtc27.user;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9w7XobGmqoHAIzgD6LtsFXauMIPw7dVC/9cFUkEqxAg=;
        b=AXBF51TxVmSaVNE/WJ8amku2KSqvbxFUmsYKA0gXCvXJqgyKiBQs9uEXObAlXXO/7f
         /l+eZ4zLmdc1I4b9hsiZ/twLu7qAVcd8EfZA4oho/t2X1ZdAzrR7SiGiYVu2aFezzqJm
         +df4yR61596wmZ5fi9d9AocUK64Oe7O14BjlKLmzHvbUcGvMVAzvQ6/XVHgpna5C2jOL
         umPOhgxAOtOgrzSyfHnsPud0NAy8QPEfUyToiLcecoc667tm7GRghydN6Y98YF7nzUNv
         3lmdApV/CvnwmL6AZZl/38AEFazpjx8ROWgcWSGfrA+FeK/lQUEq5lYzMmSfW0kByN7z
         Ic3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9w7XobGmqoHAIzgD6LtsFXauMIPw7dVC/9cFUkEqxAg=;
        b=eOlTf0rdLrSzDZdNMXD45C62+wCRD+enfsvu9TT34C/bOM/I8EE9b6NKVpWeveovGE
         A3HgVzgRG9DeRQh0Ox2l7gsdoU2/uPaDLUx3XgivRlEqEW/SiM3rB9DBwokUt34IxdKX
         YeUbQLpfzB8YgVlDSDQbIhsmdPUGu90SdCYtZqVMsXeXZgxx1i4Z8l4VRpD6a8jnNg7U
         885jTiywJM+qio1w8zpX87LNzUAxk5QIux/HDwBlbnzP89xkjJLYgZsVMbD3HcoxPwk3
         04/XK4+FOWDBhZoKkiS9BfnkphczS4bgBb6R+suZ6YqTOYUVOPYi5sJLOpz2QFFjW3xL
         f9aQ==
X-Gm-Message-State: AO0yUKWXwdSoD9zm6RBP6Y3L3/biK+wtVVGE1rNqV+9yKd6L1FTfEI87
        5TTsPTHrQDsX6ik5XB4kz+p8Fg==
X-Google-Smtp-Source: AK7set8U0nwW6pymToKnj0QWWxsDXX4OES4HSyFf1ItR+ya7bj1YlMfmMfNBNYEKfrx1VuPwLLXTgg==
X-Received: by 2002:a5d:65c6:0:b0:2c5:7c7a:78f7 with SMTP id e6-20020a5d65c6000000b002c57c7a78f7mr2849679wrw.45.1676976674381;
        Tue, 21 Feb 2023 02:51:14 -0800 (PST)
Received: from smtpclient.apple (global-5-143.n-2.net.cam.ac.uk. [131.111.5.143])
        by smtp.gmail.com with ESMTPSA id d1-20020a5d4f81000000b002c5526234d2sm3656584wru.8.2023.02.21.02.51.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Feb 2023 02:51:13 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH v2 2/7] RISC-V: Detect AIA CSRs from ISA string
From:   Jessica Clarke <jrtc27@jrtc27.com>
In-Reply-To: <Y/Sfpb2c/LS0LCiA@wendy>
Date:   Tue, 21 Feb 2023 10:51:13 +0000
Cc:     =?utf-8?Q?Christoph_M=C3=BCllner?= <christoph.muellner@vrull.eu>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Anup Patel <apatel@ventanamicro.com>, pbonzini@redhat.com,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <F80EBB4C-29C4-472D-B213-EFD220EF9B1F@jrtc27.com>
References: <20230128072737.2995881-3-apatel@ventanamicro.com>
 <mhng-0f9bdf58-5289-4db4-8fd7-38898824c44f@palmer-ri-x1c9>
 <CAEg0e7hrQFu+cdZy+3QO1ML9FNTPBehZwOOBnr1F-5ABYDnkGg@mail.gmail.com>
 <CAEg0e7hRjMSgYZbPTQztbQ3bGZf-r8wAfCK5ZnDXOcx27HcTCA@mail.gmail.com>
 <Y/Sfpb2c/LS0LCiA@wendy>
To:     Conor Dooley <conor.dooley@microchip.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21 Feb 2023, at 10:40, Conor Dooley <conor.dooley@microchip.com> =
wrote:
>=20
> Hey Christoph,
>=20
> On Tue, Feb 21, 2023 at 08:12:58AM +0100, Christoph M=C3=BCllner =
wrote:
>> Hi all,
>>=20
>> The RISC-V Architectural Review Committee has discussed the concerns
>> regarding the non-ratified chapters in the AIA specification.
>=20
> Thanks for the update!
>=20
>> Here is the relevant quote from the meeting minutes:
>> """
>> Although the Advanced Interrupt Architecture (AIA) has already passed
>> Architecture Review (with a minor edit still pending), the committee
>> has some suggestions about its final steps to ratification, to avoid
>> the AIA document having a mixture of ratified and non-ratified =
content:
>=20
>> - The AIA document's remaining draft chapter on the Duo-PLIC, which =
is
>>  not currently on a path to ratification, can be removed to a =
separate
>>  document.
>=20
> That sounds promising...
>=20
>> - Ratification of the full AIA (without Duo-PLIC) can be postponed to
>>  coincide with ratification of the IOMMU specification, given that
>>  the latter is now expected in a reasonable time, and the AIA's last
>>  chapter concerning IOMMUs is already scheduled to go through public
>>  review and be ratified only together with the IOMMU specification.
>> """
>=20
> ...and so does this. AIA stuff's acceptability only depending on the
> IOMMU spec's freeze (and thus Chapter 9's) seems like a vast =
improvement
> on the status quo to me!
>=20
>> The full meeting minutes can be found here:
>>  https://lists.riscv.org/g/tech-chairs/message/1381
>=20
> This link is non functional unfortunately :/

tech-chairs is private, for (co-)chairs only... not sure why it went
there rather than tech-privileged.

Jess

> Cheers,
> Conor.
>=20
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

