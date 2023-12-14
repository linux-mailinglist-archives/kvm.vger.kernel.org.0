Return-Path: <kvm+bounces-4429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1411A8126EB
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 06:30:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6990C28249B
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 05:30:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4875C6FB1;
	Thu, 14 Dec 2023 05:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="QebyDFxk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93BCC9
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 21:30:49 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id 98e67ed59e1d1-28abda9ca94so2894533a91.2
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 21:30:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1702531849; x=1703136649; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9U2O5u7uen8CfuBxQN6p1uI/+w8QJjGVYrTalXyihP4=;
        b=QebyDFxkSyNHmDtL3qfmT6drk5yc8vXzQu3OkYuEcyNbHqA4FM4zQ0i0tpQAyPEtL8
         xgF32clzkEommeF97Zd/7VNqtzND5TaH4Ws5BjRVLhfqRKVN2pW1DvclJ8BDHHVFWnym
         99b34nV6nAzktikR3yihF+gV17XCDjtF7eLK039P6Dgktfgwi/upQM1tE3tPGFqvmuvq
         RD+6a8DdgiRLlmCvtS4ZtMEzFN5goyWh2L08oW0CHPhdyM4GDmu7ADOB2WHWvC01nI2S
         kLAzU2WEwwDAhnlc+Wmpj6aw614z+ZBMBLGfFIR/sbynfeUpTATkNFmzbegs9/7hw2Sw
         6oMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702531849; x=1703136649;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9U2O5u7uen8CfuBxQN6p1uI/+w8QJjGVYrTalXyihP4=;
        b=eOWSnD2uQu+pfk5g8un04/bIrD2QCEPD6aTBpxuU9sKgSp2rqEC0VO4MQVi+mxsf2E
         G8qX3PISLUtyUsovmcPT64Ebi606low6yJvs2csVnzWbfhouLIOAvNAxZQtYB681887n
         3ItmCs8xnM3v4c2sedUbOYaRvB/6ixbSpeToa80Ywxi+M+t1OhlKo3gRSGLt4gh3WIBK
         M1OTxauEQuWVdDrHrSL7+c1N7hMN5hSSAUzJQcspYc1xtKPyZ+Sdb8rtuxeFk0YEALr8
         wZ4A9rJKjmk1IQpYkvQsQX2GSvucVdXbOPCy1wvLHmSGXBefv0nCHDnNFLmzMOE0eWrw
         BG4w==
X-Gm-Message-State: AOJu0YyKx6XhKs9ipP5BjcEFLan/B3xQ7TySTUarDZ2w02IM75t7HTnU
	WzAjzmW3b6TlxaB0Zu6m/AMwzfoPS3k86QTFOMyubw==
X-Google-Smtp-Source: AGHT+IEBbgOkCwAWD6LY5cWHC+N0DvQp7kP7zN+RUWEXIv/8jCMpHr53HMsDo2v41+snZLJIzHlTeVqoeyKh/HvEf70=
X-Received: by 2002:a05:6a20:4295:b0:190:38ef:3a57 with SMTP id
 o21-20020a056a20429500b0019038ef3a57mr12754720pzj.28.1702531849046; Wed, 13
 Dec 2023 21:30:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231205174509.2238870-1-dbarboza@ventanamicro.com>
In-Reply-To: <20231205174509.2238870-1-dbarboza@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 14 Dec 2023 11:00:37 +0530
Message-ID: <CAAhSdy3BybeRrAyaOvpncQE81GNLyY2i+6d1_YD-2w1vSt_6pA@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] RISC-V, KVM: add 'vlenb' and vector CSRs to get-reg-list
To: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Cc: kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, atishp@atishpatra.org, palmer@dabbelt.com, 
	ajones@ventanamicro.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 5, 2023 at 11:15=E2=80=AFPM Daniel Henrique Barboza
<dbarboza@ventanamicro.com> wrote:
>
> Hi,
>
> In this version we're exporting all vector regs, not just vector CSRs,
> in get-reg-list. All changes were done in patch 3.
>
> No other changes made.
>
> Changes from v2:
> - patch 3:
>   - check num_vector_regs() !=3D 0 before copying vector regs
>   - export all 32 vector regs in num_vector_regs() and copy_vector_reg_in=
dices()
>   - initialize 'size' out of the loop in copy_vector_reg_indices()
> - v2 link: https://lore.kernel.org/kvm/20231205135041.2208004-1-dbarboza@=
ventanamicro.com/
>
> Daniel Henrique Barboza (3):
>   RISC-V: KVM: set 'vlenb' in kvm_riscv_vcpu_alloc_vector_context()
>   RISC-V: KVM: add 'vlenb' Vector CSR
>   RISC-V: KVM: add vector CSRs in KVM_GET_REG_LIST

Reviewed-by: Anup Patel <anup@brainfault.org>

I have improved subject and description of patch3 at time of merging
this series.

Queued this series for Linux-6.8

Thanks,
Anup

>
>  arch/riscv/kvm/vcpu_onereg.c | 55 ++++++++++++++++++++++++++++++++++++
>  arch/riscv/kvm/vcpu_vector.c | 16 +++++++++++
>  2 files changed, 71 insertions(+)
>
> --
> 2.41.0
>

