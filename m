Return-Path: <kvm+bounces-24736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A707095A039
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 16:43:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 19B6CB213A9
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 14:43:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D77621B250C;
	Wed, 21 Aug 2024 14:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="cyeDB6m+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5003719993B
	for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 14:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724251413; cv=none; b=CaajGYpXKYnBm1//q71zrW7zY+ChVgu2wvi3FXP6pypslPowpsb9w205n7hK3QfA+F+t12L0XU/uqeyhezb6jNhM8rhKeLdxdWYFZZGxYFjyzYahqRXBdPJLI9SqAIY7sYmlma+02SjPor6x7ndMRuemDXnBk4lCsukjHDgubHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724251413; c=relaxed/simple;
	bh=A8p0t91hvXka+g/psRaquRixFWGMAD2W6eWokcSl1dA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ko0nbcBSwoF/5fZP+twfmf6rzQIUUxJVLsfqJ5/DT7C5WjuntvVicew8llMDbD9D3Dn7zxldpxRODSgXBk73T4RrlZhEulQ29SAj95CT5Ft9c7osZcHHYMD25JB+ru5MU7QosckdZaZ/yvg0w+DTg8HgjQ5njhqUNMYzRxnAztU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=cyeDB6m+; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-39d34be8b6dso17655475ab.0
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 07:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1724251411; x=1724856211; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YnANlyns677MLgmX5D+5HDeCYuvU+7Zvhaak3tUYSFM=;
        b=cyeDB6m+tupMQK/jzHwvb7XU2a+bNU2raAb0Rmkz9Ipxui1lb8GRer32p3I9JTjsXn
         XlYAXD7xQzBO72hMSsICEYiBThvXWTf3QywF6AONbzreGrPD1I6OhfdrYy8qvz7R9luk
         niBzFIVDNvdg4/6d4fEz/ByhhNnDUce6nF0+r/ywHgNKkSq1ZFBBdFnQzmuGdKuhr6+6
         4ofiKBEEUZHcvQxJaEBOGBOBFhUTq1XDyzji+lXpSkueCDI7j4hoJFffHyDErMGeywc7
         08otJ/PADPAW56Tovd36LWbpup0HhECzOFUjq7tJbhQ52f58s/B+DjqQa5X1NKsbG1tk
         UYJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724251411; x=1724856211;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YnANlyns677MLgmX5D+5HDeCYuvU+7Zvhaak3tUYSFM=;
        b=adiBs4hln5VjTyM02gB0MRK/tepXrNHlp8bchAUdeRsbFsI5H+CrMY1jSE4HfKho2i
         bx7xqdhC66nDtMaIGUnqnrXHKFZDLJ0zjxpEcnlhINNYy/Hifs6yMM/JOStyZlJxlRfj
         BYWvmDJuRRg7rCKUPDClQj7NAkWevlrnverWBfAbesD7ULAd4XSqM8d0V5SJZ1Ua4PKz
         XrvF4Xj8avgY92wvNd4hpboK7O63E0+kWP/Nw9P7GcFkkHU8WSxNW8OKjlVJW8UJdYDR
         BZodlMtabgSljNPGJ/rS8tf0U0FPBaWtTgaKxVS56iHoiG+d/tMwwdAqZA5G01i7ziwC
         UuWg==
X-Forwarded-Encrypted: i=1; AJvYcCWPKjPEAEp/rrQcPlhRvWcseL+t1tcz0j2/J+Lsp75QUxHu3398IrXHj8UgeAzJJF54RfQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyE19zFVZBrVqVCrKe1jVB2je1EjMv1UetM944RaugdtGf7rr0g
	OAkdbeoqXYOHfbwZEJlkJmIYCEHWQojpjo3aSrsLtrNIbCgjqqTEJHN0gDsOxY6ejNf6sr5y5Ni
	vjfSFlj9NTlH6h42ErGmvRekZE3XAU4r1PEMfVQ==
X-Google-Smtp-Source: AGHT+IHJtDUtxCawhOpqM1OVmpuYr/77dmq70s53HK4PjVrBx/OVg/mV1LIwscPOhsReGVgKzxXiUVwufmTAZkEqd5E=
X-Received: by 2002:a05:6e02:1a6a:b0:375:9dd4:d693 with SMTP id
 e9e14a558f8ab-39d6c344cc6mr29305795ab.3.1724251411230; Wed, 21 Aug 2024
 07:43:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240726084931.28924-1-yongxuan.wang@sifive.com>
In-Reply-To: <20240726084931.28924-1-yongxuan.wang@sifive.com>
From: Anup Patel <anup@brainfault.org>
Date: Wed, 21 Aug 2024 20:13:20 +0530
Message-ID: <CAAhSdy05BXUZu6BNUoDWoEVd_YiM0Dpqg=t5WYUX7+cacnO2Hg@mail.gmail.com>
Subject: Re: [PATCH v8 0/5] Add Svade and Svadu Extensions Support
To: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt <palmer@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, greentime.hu@sifive.com, 
	vincent.chen@sifive.com, Yong-Xuan Wang <yongxuan.wang@sifive.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Palmer,

On Fri, Jul 26, 2024 at 2:19=E2=80=AFPM Yong-Xuan Wang <yongxuan.wang@sifiv=
e.com> wrote:
>
> Svade and Svadu extensions represent two schemes for managing the PTE A/D
> bit. When the PTE A/D bits need to be set, Svade extension intdicates tha=
t
> a related page fault will be raised. In contrast, the Svadu extension
> supports hardware updating of PTE A/D bits. This series enables Svade and
> Svadu extensions for both host and guest OS.
>
> Regrading the mailing thread[1], we have 4 possible combinations of
> these extensions in the device tree, the default hardware behavior for
> these possibilities are:
> 1) Neither Svade nor Svadu present in DT =3D> It is technically
>    unknown whether the platform uses Svade or Svadu. Supervisor
>    software should be prepared to handle either hardware updating
>    of the PTE A/D bits or page faults when they need updated.
> 2) Only Svade present in DT =3D> Supervisor must assume Svade to be
>    always enabled.
> 3) Only Svadu present in DT =3D> Supervisor must assume Svadu to be
>    always enabled.
> 4) Both Svade and Svadu present in DT =3D> Supervisor must assume
>    Svadu turned-off at boot time. To use Svadu, supervisor must
>    explicitly enable it using the SBI FWFT extension.
>
> The Svade extension is mandatory and the Svadu extension is optional in
> RVA23 profile. Platforms want to take the advantage of Svadu can choose
> 3. Those are aware of the profile can choose 4, and Linux won't get the
> benefit of svadu until the SBI FWFT extension is available.
>
> [1] https://lore.kernel.org/linux-kernel/20240527-e9845c06619bca5cd285098=
c@orel/T/#m29644eb88e241ec282df4ccd5199514e913b06ee
>
> ---
> v8:
> - fix typo in PATCH1 (Samuel)
> - use the new extension validating API in PATCH1 (Cl=C3=A9ment)
> - update the dtbinding in PATCH2 (Samuel, Conor)
> - add PATCH4 to fix compile error in get-reg-list test.
>
> v7:
> - fix alignment in PATCH1
> - update the dtbinding in PATCH2 (Conor, Jessica)
>
> v6:
> - reflect the platform's behavior by riscv_isa_extension_available() and
>   update the the arch_has_hw_pte_young() in PATCH1 (Conor, Andrew)
> - update the dtbinding in PATCH2 (Alexandre, Andrew, Anup, Conor)
> - update the henvcfg condition in PATCH3 (Andrew)
> - check if Svade is allowed to disabled based on arch_has_hw_pte_young()
>   in PATCH3
>
> v5:
> - remove all Acked-by and Reviewed-by (Conor, Andrew)
> - add Svade support
> - update the arch_has_hw_pte_young() in PATCH1
> - update the dtbinding in PATCH2 (Alexandre, Andrew)
> - check the availibility of Svadu for Guest/VM based on
>   arch_has_hw_pte_young() in PATCH3
>
> v4:
> - fix 32bit kernel build error in PATCH1 (Conor)
> - update the status of Svadu extension to ratified in PATCH2
> - add the PATCH4 to suporrt SBI_FWFT_PTE_AD_HW_UPDATING for guest OS
> - update the PATCH1 and PATCH3 to integrate with FWFT extension
> - rebase PATCH5 on the lastest get-reg-list test (Andrew)
>
> v3:
> - fix the control bit name to ADUE in PATCH1 and PATCH3
> - update get-reg-list in PATCH4
>
> v2:
> - add Co-developed-by: in PATCH1
> - use riscv_has_extension_unlikely() to runtime patch the branch in PATCH=
1
> - update dt-binding
>
> Yong-Xuan Wang (5):
>   RISC-V: Add Svade and Svadu Extensions Support
>   dt-bindings: riscv: Add Svade and Svadu Entries
>   RISC-V: KVM: Add Svade and Svadu Extensions Support for Guest/VM
>   KVM: riscv: selftests: Fix compile error
>   KVM: riscv: selftests: Add Svade and Svadu Extension to get-reg-list
>     test
>
>  .../devicetree/bindings/riscv/extensions.yaml | 28 +++++++++++++++++++
>  arch/riscv/Kconfig                            |  1 +
>  arch/riscv/include/asm/csr.h                  |  1 +
>  arch/riscv/include/asm/hwcap.h                |  2 ++
>  arch/riscv/include/asm/pgtable.h              | 13 ++++++++-
>  arch/riscv/include/uapi/asm/kvm.h             |  2 ++
>  arch/riscv/kernel/cpufeature.c                | 12 ++++++++
>  arch/riscv/kvm/vcpu.c                         |  4 +++
>  arch/riscv/kvm/vcpu_onereg.c                  | 15 ++++++++++
>  .../selftests/kvm/riscv/get-reg-list.c        | 16 ++++++++---
>  10 files changed, 89 insertions(+), 5 deletions(-)
>
> --
> 2.17.1
>
>

Let me know if this series can be taken through the KVM RISC-V tree.
I can provide you with a shared tag as well.

Regards,
Anup

