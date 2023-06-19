Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D669B7351B3
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 12:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbjFSKNS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 06:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbjFSKNR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 06:13:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017F8CA;
        Mon, 19 Jun 2023 03:13:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8946660B46;
        Mon, 19 Jun 2023 10:13:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF453C433D9;
        Mon, 19 Jun 2023 10:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687169595;
        bh=Ka23/u4MzqnLdyscdmovU7196lfxfiLmNtNvURhGOuQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rlhpPkiwN/3ae/M3XHqVuSOiROzCUnNeVPcAWzOG7/ALQvJvGKS8zLskdmJGrXEJm
         HhvtaAimfkZzaD5t/nd6RH2TWCR8S9dWPMs6Ne4xFjZRfaOT7iPwb3gr+Z09Jr7gx/
         R0O8DwKiq/c9zt0CnaEmQ2GBQikq+y6BoW1xXOwBpf7Jh0qj9wSxz6xOuOccVU+/0v
         po9ZkgpDF1mSRJvU4bnpeOm3zZYVfY8rkPE9ofspKjwBpt5g1CwGyXvjfhNmK7UM+E
         qMAGX9EzT7V/jqviFcHpqS7VbC/t/DyZ8suSRcItYI/NBxJkKeT37+O6wNlY5eBWYW
         XnZ61CuUSe7XQ==
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2b46d4e1b0aso22373921fa.2;
        Mon, 19 Jun 2023 03:13:14 -0700 (PDT)
X-Gm-Message-State: AC+VfDyf5n+yP6oWKbgWA81Cqq/4n9zwjK2oHbQ212Z6WpRLIo3mAgZp
        9IkMjGWilIC1K9Ktr22KbOB3qtnzQWv6cOGSEyU=
X-Google-Smtp-Source: ACHHUZ6+m0JNu1Zl8Q4e1b48iHqq2nss/OByLpaHRRLoZU7Uioft0V1XZWJA9+xFg0z8ZBQbmpZyFX+1z19e0MSz14E=
X-Received: by 2002:a2e:80c9:0:b0:2b1:c039:e977 with SMTP id
 r9-20020a2e80c9000000b002b1c039e977mr5144365ljg.16.1687169592851; Mon, 19 Jun
 2023 03:13:12 -0700 (PDT)
MIME-Version: 1.0
References: <20230619083255.3841777-1-zhaotianrui@loongson.cn> <20230619083255.3841777-22-zhaotianrui@loongson.cn>
In-Reply-To: <20230619083255.3841777-22-zhaotianrui@loongson.cn>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Mon, 19 Jun 2023 18:13:00 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6VcQUYu8Q7Cd2vbd=XQZmdTxUHV0bnuwr4vteLBpKEoQ@mail.gmail.com>
Message-ID: <CAAhV-H6VcQUYu8Q7Cd2vbd=XQZmdTxUHV0bnuwr4vteLBpKEoQ@mail.gmail.com>
Subject: Re: [PATCH v14 21/30] LoongArch: KVM: Implement handle iocsr exception
To:     Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, tangyouling@loongson.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Tianrui,

On Mon, Jun 19, 2023 at 4:33=E2=80=AFPM Tianrui Zhao <zhaotianrui@loongson.=
cn> wrote:
>
> Implement kvm handle vcpu iocsr exception, setting the iocsr info into
> vcpu_run and return to user space to handle it.
>
> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>  arch/loongarch/include/asm/inst.h | 16 ++++++
>  arch/loongarch/kvm/exit.c         | 92 +++++++++++++++++++++++++++++++
>  2 files changed, 108 insertions(+)
>
> diff --git a/arch/loongarch/include/asm/inst.h b/arch/loongarch/include/a=
sm/inst.h
> index b09887ffcd15..db5857796432 100644
> --- a/arch/loongarch/include/asm/inst.h
> +++ b/arch/loongarch/include/asm/inst.h
> @@ -56,6 +56,14 @@ enum reg2_op {
>         revbd_op        =3D 0x0f,
>         revh2w_op       =3D 0x10,
>         revhd_op        =3D 0x11,
> +       iocsrrdb_op     =3D 0x19200,
> +       iocsrrdh_op     =3D 0x19201,
> +       iocsrrdw_op     =3D 0x19202,
> +       iocsrrdd_op     =3D 0x19203,
> +       iocsrwrb_op     =3D 0x19204,
> +       iocsrwrh_op     =3D 0x19205,
> +       iocsrwrw_op     =3D 0x19206,
> +       iocsrwrd_op     =3D 0x19207,
>  };
>
>  enum reg2i5_op {
> @@ -298,6 +306,13 @@ struct reg3sa2_format {
>         unsigned int opcode : 15;
>  };
>
> +struct reg2csr_format {
> +       unsigned int rd : 5;
> +       unsigned int rj : 5;
> +       unsigned int csr : 14;
> +       unsigned int opcode : 8;
> +};
Put it before reg3_format.

> +
>  union loongarch_instruction {
>         unsigned int word;
>         struct reg0i15_format   reg0i15_format;
> @@ -313,6 +328,7 @@ union loongarch_instruction {
>         struct reg2bstrd_format reg2bstrd_format;
>         struct reg3_format      reg3_format;
>         struct reg3sa2_format   reg3sa2_format;
> +       struct reg2csr_format   reg2csr_format;
The same, thanks.

Huacai
>  };
>
>  #define LOONGARCH_INSN_SIZE    sizeof(union loongarch_instruction)
> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> index 18635333fc9a..32edd915ebcb 100644
> --- a/arch/loongarch/kvm/exit.c
> +++ b/arch/loongarch/kvm/exit.c
> @@ -96,3 +96,95 @@ static int _kvm_handle_csr(struct kvm_vcpu *vcpu, larc=
h_inst inst)
>
>         return EMULATE_DONE;
>  }
> +
> +int _kvm_emu_iocsr(larch_inst inst, struct kvm_run *run, struct kvm_vcpu=
 *vcpu)
> +{
> +       u32 rd, rj, opcode;
> +       u32 addr;
> +       unsigned long val;
> +       int ret;
> +
> +       /*
> +        * Each IOCSR with different opcode
> +        */
> +       rd =3D inst.reg2_format.rd;
> +       rj =3D inst.reg2_format.rj;
> +       opcode =3D inst.reg2_format.opcode;
> +       addr =3D vcpu->arch.gprs[rj];
> +       ret =3D EMULATE_DO_IOCSR;
> +       run->iocsr_io.phys_addr =3D addr;
> +       run->iocsr_io.is_write =3D 0;
> +
> +       /* LoongArch is Little endian */
> +       switch (opcode) {
> +       case iocsrrdb_op:
> +               run->iocsr_io.len =3D 1;
> +               break;
> +       case iocsrrdh_op:
> +               run->iocsr_io.len =3D 2;
> +               break;
> +       case iocsrrdw_op:
> +               run->iocsr_io.len =3D 4;
> +               break;
> +       case iocsrrdd_op:
> +               run->iocsr_io.len =3D 8;
> +               break;
> +       case iocsrwrb_op:
> +               run->iocsr_io.len =3D 1;
> +               run->iocsr_io.is_write =3D 1;
> +               break;
> +       case iocsrwrh_op:
> +               run->iocsr_io.len =3D 2;
> +               run->iocsr_io.is_write =3D 1;
> +               break;
> +       case iocsrwrw_op:
> +               run->iocsr_io.len =3D 4;
> +               run->iocsr_io.is_write =3D 1;
> +               break;
> +       case iocsrwrd_op:
> +               run->iocsr_io.len =3D 8;
> +               run->iocsr_io.is_write =3D 1;
> +               break;
> +       default:
> +               ret =3D EMULATE_FAIL;
> +               break;
> +       }
> +
> +       if (ret =3D=3D EMULATE_DO_IOCSR) {
> +               if (run->iocsr_io.is_write) {
> +                       val =3D vcpu->arch.gprs[rd];
> +                       memcpy(run->iocsr_io.data, &val, run->iocsr_io.le=
n);
> +               }
> +               vcpu->arch.io_gpr =3D rd;
> +       }
> +
> +       return ret;
> +}
> +
> +int _kvm_complete_iocsr_read(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +{
> +       unsigned long *gpr =3D &vcpu->arch.gprs[vcpu->arch.io_gpr];
> +       enum emulation_result er =3D EMULATE_DONE;
> +
> +       switch (run->iocsr_io.len) {
> +       case 8:
> +               *gpr =3D *(s64 *)run->iocsr_io.data;
> +               break;
> +       case 4:
> +               *gpr =3D *(int *)run->iocsr_io.data;
> +               break;
> +       case 2:
> +               *gpr =3D *(short *)run->iocsr_io.data;
> +               break;
> +       case 1:
> +               *gpr =3D *(char *) run->iocsr_io.data;
> +               break;
> +       default:
> +               kvm_err("Bad IOCSR length: %d,addr is 0x%lx",
> +                               run->iocsr_io.len, vcpu->arch.badv);
> +               er =3D EMULATE_FAIL;
> +               break;
> +       }
> +
> +       return er;
> +}
> --
> 2.39.1
>
>
