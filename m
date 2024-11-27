Return-Path: <kvm+bounces-32570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE7729DABE5
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 17:38:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 66F8316285A
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 16:38:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04D63200BAD;
	Wed, 27 Nov 2024 16:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KLqoA6A8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6984C200132
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 16:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732725500; cv=none; b=Ab1RpzuV/lkBi57OUJjqOMap8SXMIFGHVDNnM+4jJePW5wONjhtEtCNBpnckx+tq6hhWEKNqcj1q0LBKmmMSgd+MeTISBFRvrIIPaOD3jZjsZiCFnj4YtG+eLZUZllyOhIWEAaWVW9CdFkFBtYVZFqstmQQ0rXCZ7mD6+GC6sqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732725500; c=relaxed/simple;
	bh=S2GzSPCwTpA5llzuw8j7tLntJvPoggKyl9/JhGqLNKg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U1SWXdHzjF4CXcMyr2XUnTITTAbmNxFGgZYpQnOQacifLJFelfIhVtYEg9nNmGLIEfeaefyDsPtt/6PNWleDRhgTdE/sfQjvFO7vFjzghOdmqXiD4DHudYgm7hKXsLXp4jaov7txALmy2auTUEVQ/PEDwkQ5tU1eHgYoMj9YY+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KLqoA6A8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732725497;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=afE31lUK+/6tVm+DJ+Y3g8/UJ0QVmsOY1tXmRc3zdA8=;
	b=KLqoA6A8uMJODJ6m39jMRntyECzdM3C2iOExcqKommV2RYwyNPq0s5L5NEjB4jGzUIdqre
	c9DQralRFh+XC+dqnlDDZXRFQtMFPOernDy2+FtTaAK4nnLqLvUZI4+jkq7dzFPxPVkAb7
	H39kUh1EQbRK/rP2z2Jb4Yvn2sbArZM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-VWbqufleOr-68kBe3uanOg-1; Wed, 27 Nov 2024 11:38:16 -0500
X-MC-Unique: VWbqufleOr-68kBe3uanOg-1
X-Mimecast-MFC-AGG-ID: VWbqufleOr-68kBe3uanOg
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-382299520fdso4521552f8f.3
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 08:38:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732725495; x=1733330295;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=afE31lUK+/6tVm+DJ+Y3g8/UJ0QVmsOY1tXmRc3zdA8=;
        b=CiaoW1tCzaNqLBLbKqC7YYPoyTq29lv0mmT6fjFmQ/FhDFJfapam8shaJa9QSc/5+U
         jdldB6AEU/vLs2sJAmL8xut3pGzDM6Q0j1/Sa3kw0QIVhmuPIWhTl1eNyh1U8314tLt9
         JWQDefTtL2BWdj0UKhi3Xg8pWTjXtG/tZUjmVEjXtbF96g7ufc61mVawg50h8rGXL/sT
         4tW10wKJj+qsO3NUMFx27P1hyWriLrernxi0e1+9aqKZ4Y7Bm/pk6W8N+cq2q4doumvh
         VcyKiE/UM4svwUBZgrxAUn8qEpi91S2hac7YnHmND6BRebfz9SZKCyk+l7KTv19vV9KH
         nOjA==
X-Forwarded-Encrypted: i=1; AJvYcCU9AvWndComTLFN1VL4pZLXLV0JF6/IHWRKx3coqB2OJPwPOu9f5bIpe23HVSjxA75M6eY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yytq4KvKA/vHvxvafRtG1o2Zo0sDT6p+Wn8WIh+DIGaHCa/ZADd
	Nf89rhrq1nMjRJCb7wwM+Z/CEtxBIxKX3IPp79ufaoaYn+ySlZsEEfFdf7AcTq3OUUAPNy097Uj
	ueB6tgkWbqqf571wkFJu6MRDuJKGQKvvYaET4OR2Sw0nUgpHWen5DOyqedv+ZKigYBL1Y28v7dA
	VPity3Op8RjHzzI6ujuq5t9T1C
X-Gm-Gg: ASbGnct/vSV+B88DDgqzf2vFWTsAMyvfpVZU/A98keJtHQp72LTiKKNKXQNAE6IMgJw
	70eQBXVI+aoevHZ8AKAPeyTWp52Ng/Tqf
X-Received: by 2002:a5d:5f53:0:b0:381:cffc:d40b with SMTP id ffacd0b85a97d-385c6eddb83mr3051310f8f.39.1732725494807;
        Wed, 27 Nov 2024 08:38:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE8a3nxjTefB5MHFfWxupT+6qo4a3qig88kkXoZUYfsMcqJnap4vBza1hw0BxDwUCN1o7X13TJ6FB5P8J+GDIQ=
X-Received: by 2002:a5d:5f53:0:b0:381:cffc:d40b with SMTP id
 ffacd0b85a97d-385c6eddb83mr3051286f8f.39.1732725494457; Wed, 27 Nov 2024
 08:38:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy2mLBzE63wpQrOaHtOV0rwqkaxTUMBA9oMZsk68o0EHMg@mail.gmail.com>
In-Reply-To: <CAAhSdy2mLBzE63wpQrOaHtOV0rwqkaxTUMBA9oMZsk68o0EHMg@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 27 Nov 2024 17:38:01 +0100
Message-ID: <CABgObfacuB-8KN1+Czt5DaXQbaiw9=jP5zYGatw6CGooLnz9Sg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.13, part #2
To: Anup Patel <anup@brainfault.org>
Cc: Palmer Dabbelt <palmer@rivosinc.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>, 
	Atish Patra <atishp@atishpatra.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 21, 2024 at 1:55=E2=80=AFPM Anup Patel <anup@brainfault.org> wr=
ote:
>
> Hi Paolo,
>
> As mentioned in the last PR, here are the remaining KVM RISC-V
> changes for 6.13 which mainly consists of Svade/Svadu extension
> support for Host and Guest/VM.
>
> Please note that Palmer has not yet sent the RISC-V PR for 6.13
> so these patches will conflict with the RISC-V tree.

The RISC-V PR has not been merged yet (has it been sent?) and I am not
sure what's happening here. If these are merged first, presumably
Linus will bump the arch/riscv/include/asm/hwcap.h constants --
leaving SVADE/SVADU at 87 and 88 and adjusting the others. Should I do
that or is it delayed to 6.14 at this point?

Paolo

> Please pull.
>
> Regards,
> Anup
>
> The following changes since commit 332fa4a802b16ccb727199da685294f85f9880=
cb:
>
>   riscv: kvm: Fix out-of-bounds array access (2024-11-05 13:27:32 +0530)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.13-2
>
> for you to fetch changes up to c74bfe4ffe8c1ca94e3d60ec7af06cf679e23583:
>
>   KVM: riscv: selftests: Add Svade and Svadu Extension to get-reg-list
> test (2024-11-21 17:40:16 +0530)
>
> ----------------------------------------------------------------
> KVM/riscv changes for 6.13 part #2
>
> - Svade and Svadu extension support for Host and Guest/VM
>
> ----------------------------------------------------------------
> Yong-Xuan Wang (4):
>       RISC-V: Add Svade and Svadu Extensions Support
>       dt-bindings: riscv: Add Svade and Svadu Entries
>       RISC-V: KVM: Add Svade and Svadu Extensions Support for Guest/VM
>       KVM: riscv: selftests: Add Svade and Svadu Extension to get-reg-lis=
t test
>
>  .../devicetree/bindings/riscv/extensions.yaml      | 28 ++++++++++++++++=
++++++
>  arch/riscv/Kconfig                                 |  1 +
>  arch/riscv/include/asm/csr.h                       |  1 +
>  arch/riscv/include/asm/hwcap.h                     |  2 ++
>  arch/riscv/include/asm/pgtable.h                   | 13 +++++++++-
>  arch/riscv/include/uapi/asm/kvm.h                  |  2 ++
>  arch/riscv/kernel/cpufeature.c                     | 12 ++++++++++
>  arch/riscv/kvm/vcpu.c                              |  4 ++++
>  arch/riscv/kvm/vcpu_onereg.c                       | 15 ++++++++++++
>  tools/testing/selftests/kvm/riscv/get-reg-list.c   |  8 +++++++
>  10 files changed, 85 insertions(+), 1 deletion(-)
>


