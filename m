Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED87476FCF9
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 11:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbjHDJOn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 05:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbjHDJOO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 05:14:14 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED4F4EC1
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 02:11:34 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-522294c0d5bso2337160a12.2
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 02:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20221208.gappssmtp.com; s=20221208; t=1691140292; x=1691745092;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZCLrMIcrmxPkYa4R7qfeQvE0tPVOXSV4boHfMs5CXCw=;
        b=e7TjRfOyN4hnGmNqQDqDk2MoCCyGYJlKRtgX8kcspaBT9rO0VX/9xDn1We+detSqQ0
         65OL305lzPVJxdiHn4qeII8Hsc6nRLfWzwoz8DJevMvoJpym3NrVxxtEfD1yOJZdhvfG
         wByQjNIP7InMrnTq2G9APZbXSNJqWkpZQjbs5r7naeqtwvZ5N4nGICruwbZpjTLkta4a
         +c/w33gcfCcH4NJ2SWspuHn3wBuIKgLUul/0ihqQ2V/IJHbZ/bm2pakiXJlKPzSBwsV+
         T7qgV2Zh+vIkbJdK7UcA1Y0+padUgmtl4e7yvby1v8TQgNnOU9M4X+sLb7/xbSHAT6j/
         /yXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691140292; x=1691745092;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZCLrMIcrmxPkYa4R7qfeQvE0tPVOXSV4boHfMs5CXCw=;
        b=iezmNKZKaKb2t9OodAvf/oRhrfDFh8TFU41MG2MUA9Zx/5k1QyxODJc3F0dBjWxtOj
         o+gpJ2t6ntTPpqS0yCL1GfU3h6eVO/VRj1TZ7azRe20yKiyObyH6SEuupUq+RyWXuUmn
         ElbL4Y78sTx/p5XHMwRANCnmWS66G6TSxgr+Gt1UBA6CPmuv3DyQmshwj1D+atK7A7PF
         3QObm4Hp7KTjdu3N7uDdS33Q56nnd7REb/pyRYDMVA9iolbyygnf6TNgCMNVSlPxhSmU
         GlH/rlxuS4B3TsR4xLuODh+xrSVGlKodPgIBADqkum/bUNEt/tuvDDZl86BA+HuIdeJ9
         4+Bw==
X-Gm-Message-State: AOJu0Yzkse+LeAXSkm21QtUACmVD8/nSrCyD0Hny5fCrYevE9KCTUKJG
        nMeXJghsw4V/DRIDtZlrw1ofSWDSfZGja2SHHxP5pPvkU+1LKguL
X-Google-Smtp-Source: AGHT+IG0L5EQE0VXMUNJlUQFay1dJwjekRL8tawBeRTK1zsdM3y6pPSjp/CooI8XEt894peGJueURTR8hnSRzdvc2Lc=
X-Received: by 2002:aa7:cb57:0:b0:522:bc01:47ab with SMTP id
 w23-20020aa7cb57000000b00522bc0147abmr1100082edt.29.1691140292458; Fri, 04
 Aug 2023 02:11:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230803163302.445167-1-dbarboza@ventanamicro.com>
In-Reply-To: <20230803163302.445167-1-dbarboza@ventanamicro.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 4 Aug 2023 14:41:21 +0530
Message-ID: <CAAhSdy0PoG=AwvcavJxuS1Y6nbFE8pcX5vXDuzFr6+vjhpAMkQ@mail.gmail.com>
Subject: Re: [PATCH v4 00/10] RISC-V: KVM: change get_reg/set_reg error code
To:     Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Cc:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, atishp@atishpatra.org, ajones@ventanamicro.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 3, 2023 at 10:03=E2=80=AFPM Daniel Henrique Barboza
<dbarboza@ventanamicro.com> wrote:
>
> Hi,
>
> This version includes a diff that Andrew mentioned in v2 [1] that I
> missed. They were squashed into patch 1.
>
> No other changes made. Patches rebased on top of riscv_kvm_queue.
>
> Changes from v3:
> - patch 1:
>   - added missing EINVAL - ENOENT conversions
> - v3 link: https://lore.kernel.org/kvm/20230803140022.399333-1-dbarboza@v=
entanamicro.com/
>
> [1] https://lore.kernel.org/kvm/20230801222629.210929-1-dbarboza@ventanam=
icro.com/
>
>
> Andrew Jones (1):
>   RISC-V: KVM: Improve vector save/restore errors
>
> Daniel Henrique Barboza (9):
>   RISC-V: KVM: return ENOENT in *_one_reg() when reg is unknown
>   RISC-V: KVM: use ENOENT in *_one_reg() when extension is unavailable
>   RISC-V: KVM: do not EOPNOTSUPP in set_one_reg() zicbo(m|z)
>   RISC-V: KVM: do not EOPNOTSUPP in set KVM_REG_RISCV_TIMER_REG
>   RISC-V: KVM: use EBUSY when !vcpu->arch.ran_atleast_once
>   RISC-V: KVM: avoid EBUSY when writing same ISA val
>   RISC-V: KVM: avoid EBUSY when writing the same machine ID val
>   RISC-V: KVM: avoid EBUSY when writing the same isa_ext val
>   docs: kvm: riscv: document EBUSY in KVM_SET_ONE_REG

I have queued all patches except PATCH9 for Linux-6.6.

Drew, please send v5 of PATCH.

Thanks,
Anup

>
>  Documentation/virt/kvm/api.rst |  2 +
>  arch/riscv/kvm/aia.c           |  4 +-
>  arch/riscv/kvm/vcpu_fp.c       | 12 +++---
>  arch/riscv/kvm/vcpu_onereg.c   | 74 ++++++++++++++++++++++------------
>  arch/riscv/kvm/vcpu_sbi.c      | 16 ++++----
>  arch/riscv/kvm/vcpu_timer.c    | 11 ++---
>  arch/riscv/kvm/vcpu_vector.c   | 60 ++++++++++++++-------------
>  7 files changed, 107 insertions(+), 72 deletions(-)
>
> --
> 2.41.0
>
