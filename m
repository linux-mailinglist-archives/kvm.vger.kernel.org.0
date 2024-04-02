Return-Path: <kvm+bounces-13384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C2CE8959BB
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 18:28:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 142CAB265EC
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 16:27:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3889D14B072;
	Tue,  2 Apr 2024 16:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HNxu9d6J"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4761133421
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 16:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712075241; cv=none; b=IsQte7l4xytgkE5j9uZG1+cHaA8LZB5uCWoOgzhz7K/3QlTzwrE73g8vxdFVAWUnAtqt7EnNTHJH1y9EVGpbyUGuNSI10iJCc2lDnr5RqZbnnlE9fHnOhYBH0xnYSyAmN1l/84wdCgwZ938xX5ysbim7NsfYxh5K0dN5pZlDO6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712075241; c=relaxed/simple;
	bh=33qDBOjGVRWk65rVOXWwJ7uaRWVQ8xgKebzRSVn1LFU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Rhpqpb6duazSq/G1ueXrFxUvYMoc9KOM5Q3W76bkS/B1hMywRNAHWmLtKDIUrvwaLdqyZcZw1XR8vA94aVayVRAy2anUtlyfG0mmy4ol82TX7VtTeHIhVDkNwnUsrsckyTgX7ZqMsYvd9V5VPnWihwQVsPd8Wc79ZYze7wcp8dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HNxu9d6J; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712075238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DUvuzJkhgeIbEx3kwWWb2/fdwHNDJzTQC6qK3IdEcUs=;
	b=HNxu9d6JBKHSGx7BTC7sL1FxER3EJaRF8WXVxXunBMLm59yL/lpefE2StwKSAdCgBxfoci
	dHrycRf79hfnFWcvn9b8HeCd03Y6/LGfopmytSJD3sEpgJajXRxwzaots0h+q647SZO2Yi
	jiBPMMnBHJqVXd5/EYUeZthwoXJ3+HM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-83B55oNzNN2tuqBvfgycrg-1; Tue, 02 Apr 2024 12:27:17 -0400
X-MC-Unique: 83B55oNzNN2tuqBvfgycrg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3437032fe82so31898f8f.0
        for <kvm@vger.kernel.org>; Tue, 02 Apr 2024 09:27:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712075236; x=1712680036;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DUvuzJkhgeIbEx3kwWWb2/fdwHNDJzTQC6qK3IdEcUs=;
        b=f1pG/xqyYLyXi1mMXvPX+Y6aoY4pIxRbsKjN+7UwtvFrkAk6x1aSdo2S9DlRhRBPnr
         Iu4HMrzzGYy9syjKIaqIU6FbueUD04YEqc7VsD3klg/CZELI733bNkJ2N8f8JBra60QH
         HYSYTuyHuPYiWyDxF/Pb+pzULkXjXgFdWIE7keUswfgZwA6tiqn3Ak5rsJWw7/hvlzG6
         CUReTQWveG0py6LXseGgdQ+m1ZTQx4REV/CzyrUyEGQBHzojwtvOBSX4F8n3dR2vRhz7
         Nur1Kf4PUjBUy/95ska85+qd849EXC1HGhYzKrRQgVmWWiJO3XM/6hGrtQUHJ5Sb+b6m
         Ns6g==
X-Forwarded-Encrypted: i=1; AJvYcCX4u5Ojqb+GFp8fO68PlIT/Ds5ZhSBgQFzJuBnDcwdKGpJH0SqUX3mejiLoilg7GxWIhtWRLoU7lnjlQU4GfXLTXRuE
X-Gm-Message-State: AOJu0YzFLjR5mw4sQPYMNLDVdhPmSxr/wZk1mrehjVBYVjughbNWMY8K
	vQcb2UjoCLfa55XnkIlda1zGQswlJMHqP8gD7A/YgpUXiyDkK6Kz3shFBx9/mwUcX5nRs6V0mUy
	2VYfVJOGOtB777rlHbEctGhg9vRcf9iq/9EpQzEEb3OC9WT/y8UZKRQ8nxRv1/kM4s5A88r3Bv3
	vxn+QtvhC221kjloEkMZt9cGKU
X-Received: by 2002:a5d:4b52:0:b0:33d:7e9:9543 with SMTP id w18-20020a5d4b52000000b0033d07e99543mr11576992wrs.32.1712075235978;
        Tue, 02 Apr 2024 09:27:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEPdJjojZpCbVTwj+daJynuypEfeW/dgyJw07L+cbjNX73qYfysRGlGJgKpJlSzHkF09cMYYitKdc4IyYAmC9k=
X-Received: by 2002:a5d:4b52:0:b0:33d:7e9:9543 with SMTP id
 w18-20020a5d4b52000000b0033d07e99543mr11576963wrs.32.1712075235633; Tue, 02
 Apr 2024 09:27:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy2e237A_vA022kh3cmy-YJ_t=0iXyRkbQS3NSR=_Z+6HA@mail.gmail.com>
In-Reply-To: <CAAhSdy2e237A_vA022kh3cmy-YJ_t=0iXyRkbQS3NSR=_Z+6HA@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 2 Apr 2024 18:27:04 +0200
Message-ID: <CABgObfYWXOo-cLGWrb1OKTgJX5zKdvRkJNw7i9AKGz1dsWp4cA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv fixes for 6.9, take #1
To: Anup Patel <anup@brainfault.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt <palmer@rivosinc.com>, 
	Atish Patra <atishp@atishpatra.org>, Atish Patra <atishp@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 2, 2024 at 5:48=E2=80=AFPM Anup Patel <anup@brainfault.org> wro=
te:
>
> Hi Paolo,
>
> We have four fixes for 6.9. Out of these, two fixes are
> related to in-kernel APLIC emulation and remaining
> are cosmetic fixes.
>
> Please pull.
>
> Regards,
> Anup
>
> The following changes since commit 4cece764965020c22cff7665b18a0120063590=
95:
>
>   Linux 6.9-rc1 (2024-03-24 14:10:05 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-6.9-1
>
> for you to fetch changes up to 8e936e98718f005c986be0bfa1ee6b355acf96be:
>
>   RISC-V: KVM: Fix APLIC in_clrip[x] read emulation (2024-03-26 09:40:55 =
+0530)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> KVM/riscv fixes for 6.9, take #1
>
> - Fix spelling mistake in arch_timer selftest
> - Remove redundant semicolon in num_isa_ext_regs()
> - Fix APLIC setipnum_le/be write emulation
> - Fix APLIC in_clrip[x] read emulation
>
> ----------------------------------------------------------------
> Anup Patel (2):
>       RISC-V: KVM: Fix APLIC setipnum_le/be write emulation
>       RISC-V: KVM: Fix APLIC in_clrip[x] read emulation
>
> Colin Ian King (2):
>       KVM: selftests: Fix spelling mistake "trigged" -> "triggered"
>       RISC-V: KVM: Remove second semicolon
>
>  arch/riscv/kvm/aia_aplic.c                       | 37 ++++++++++++++++++=
++----
>  arch/riscv/kvm/vcpu_onereg.c                     |  2 +-
>  tools/testing/selftests/kvm/aarch64/arch_timer.c |  2 +-
>  tools/testing/selftests/kvm/riscv/arch_timer.c   |  2 +-
>  4 files changed, 34 insertions(+), 9 deletions(-)
>


