Return-Path: <kvm+bounces-52745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 65B46B0903E
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 17:11:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A7873ACD1A
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 15:10:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C35B82F8C29;
	Thu, 17 Jul 2025 15:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NE5xQbD6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E9B2BEC22
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 15:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752765054; cv=none; b=fmeNUxH6j4EEUMkK0LCN6wXb/2dz/atq1+fsf0oVDLIHyHOwUFMCFCn4u6bLxRglNw+3X3B/GfqcJzk6VevjORQIviTXBw4Q61hTPgM0B51G9pD8g2/ocYnasi6tFQxbE+Jg2HT4wSwJW3d/dfoR2qs4os29MC1gxQx7rAt3L+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752765054; c=relaxed/simple;
	bh=TWpCqk7Om7R/mh2HByUTA2UFLmq3RPpf0tdxVzsXdLo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hduUdeB9Qd4KjDrOAlxrMgaXdSUSRj5KXDFNjZEOk2Wir7iv2fJ5Lo05iPu3+5HzPwjbHYn7QMfx7b6eH57S0T6iyau73/0nP3mYR95xS8euSlhw2tOqz+/C1ck3ekUBMcVXH+S0WR0sinaSrnX/fwkwoFZgNZDU9qdSmi3BJBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NE5xQbD6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752765051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HnTl8YyVmCQ+6lx7TAls0CZruBl5qS1i458aSA1jJeM=;
	b=NE5xQbD6T2sEoEJkCVNygdT3hJll+1xw0HcaUqf0bVVxVOz6P5QRub/KefpfzWaR2ZedoW
	hil9vlbMpTKQVRq6QyIv+NOphZjyZu64V4joz6dyXT8wRnlZv4zlNEny1+vGnsi7YD1dUm
	iY7QhiWUZvgrZD/CJsewaFX5GXKUYEs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-138-vuOCCBY4NQudHSQ4HP-KFA-1; Thu, 17 Jul 2025 11:10:50 -0400
X-MC-Unique: vuOCCBY4NQudHSQ4HP-KFA-1
X-Mimecast-MFC-AGG-ID: vuOCCBY4NQudHSQ4HP-KFA_1752765049
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a4eb6fcd88so659103f8f.1
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 08:10:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752765048; x=1753369848;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HnTl8YyVmCQ+6lx7TAls0CZruBl5qS1i458aSA1jJeM=;
        b=X74cN2Uu7UNJlqrhmSnuHMTE9LZQDnqlYOsFsSGtTghsOTbciAqyWCIJTuiNVzSvGq
         sONJzyZjTEQzbMJyzLJoIleKZhTnxUIWSQ3slihUCq3oHDsQYRHxp1CSW1zsMBaN8bmB
         VTvfHv7KpLprb8cT/u6eUwpy4z0mAdsp2btJ4GoGl73c42uWPWl6nhtTh2xG9/hXoHQU
         ftUTGqlgifr7pJuHYvZ3moVZJAJ8Di8McRanBFZwrWfQi7tCTGg2e5ARlxk1rqUoG3xW
         7M8l8wjIRyvj+cBjsj5bOeuJ1/LFtc6VFk7DbrI75r3UPedcnR4j3cDd1khNGmnsptOb
         1uDw==
X-Forwarded-Encrypted: i=1; AJvYcCXj2TGyTJoNOFqp/fSehoqII0m8Xx8vZxe5PGAi0+IggZ1teB+yNJyeoud34wYv+4ePGKU=@vger.kernel.org
X-Gm-Message-State: AOJu0YypExge23cgxB4AGZ5nYExKk+Tn8uFT4gmT1sMIHqCvwnWzc/5V
	JvxYJxp/ky0k3RpcQqOZZLRJ9Px121EpAwpKy/Mqshf3BXeZRCyCV4AtWEJEfL9X8UclkOCp1n2
	+hHQir+NeWPCkfpayORbBskvSofU4uTpPKgFMVyCCdxbdpAT7ugQgIeWSMhCuId7rW/gG1AdNze
	4W+gKm+7Ut/Z4enshP2P8YeDnuiwKJ9WzfhLjC
X-Gm-Gg: ASbGnctwNoJjSfz2Ps9ySwZx561u2WdFrvftoByzXdnW3a+DnLzqROGuJvVSES+cNOh
	uNOnM7zPy0K4yoGOXtqfYjLr+Yi7/L/AIoOlm9NpQFBef0bXF7qxUzsm4DMRisqKvYRYfLVXc31
	PmPGog5DhcTDhYDZTFIuIC
X-Received: by 2002:a05:6000:24c9:b0:3a5:1c0d:85e8 with SMTP id ffacd0b85a97d-3b60e4c219fmr5043591f8f.22.1752765048517;
        Thu, 17 Jul 2025 08:10:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG6ENUSGVWfYmEMdWSfORC9F6DnzUU+kA3Bcwc1adVmjk2OuNyCtcLU+5XLyyeGoMwkUt3MfaixMxCh5LTkmLg=
X-Received: by 2002:a05:6000:24c9:b0:3a5:1c0d:85e8 with SMTP id
 ffacd0b85a97d-3b60e4c219fmr5043562f8f.22.1752765048033; Thu, 17 Jul 2025
 08:10:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy3_OE=R1jhF5-KBiw4mGOqHUXHdkvyeAAR18Qm8dezavQ@mail.gmail.com>
In-Reply-To: <CAAhSdy3_OE=R1jhF5-KBiw4mGOqHUXHdkvyeAAR18Qm8dezavQ@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 17 Jul 2025 17:10:35 +0200
X-Gm-Features: Ac12FXwFt8xOw-1JkHEa0ebnk7oHtzkOFfGQMkyq0xmPpds5qhTf7aNpQULhrXU
Message-ID: <CABgObfaqDdY8rv=Oq-BHSXLk_iUCReh_EcUKAhGbcXu7xpL6VQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv fixes for 6.16 take #2
To: Anup Patel <anup@brainfault.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Atish Patra <atishp@rivosinc.com>, 
	Atish Patra <atish.patra@linux.dev>, Andrew Jones <ajones@ventanamicro.com>, 
	KVM General <kvm@vger.kernel.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 12, 2025 at 12:25=E2=80=AFPM Anup Patel <anup@brainfault.org> w=
rote:
>
> Hi Paolo,
>
> We have two more fixes for the 6.16 kernel. The first one
> fixes an issue reported by Canonical [1] which turned-out
> to be an issue related to timer cleanup when exiting to
> user-space. The second fix addresses a race-condition
> in updating HGEIE CSR when IMSIC VS-files are in-use.
>
> Please pull.
>
> Regards,
> Anup
>
> [1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2112578Signed-of=
f-by
>
> The following changes since commit d7b8f8e20813f0179d8ef519541a3527e7661d=
3a:
>
>   Linux 6.16-rc5 (2025-07-06 14:10:26 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-6.16-2
>
> for you to fetch changes up to 4cec89db80ba81fa4524c6449c0494b8ae08eeb0:
>
>   RISC-V: KVM: Move HGEI[E|P] CSR access to IMSIC virtualization
> (2025-07-11 18:33:27 +0530)

Pulled, thanks.

Paolo

>
> ----------------------------------------------------------------
> KVM/riscv fixes for 6.16, take #2
>
> - Disable vstimecmp before exiting to user-space
> - Move HGEI[E|P] CSR access to IMSIC virtualization
>
> ----------------------------------------------------------------
> Anup Patel (2):
>       RISC-V: KVM: Disable vstimecmp before exiting to user-space
>       RISC-V: KVM: Move HGEI[E|P] CSR access to IMSIC virtualization
>
>  arch/riscv/include/asm/kvm_aia.h  |  4 ++-
>  arch/riscv/include/asm/kvm_host.h |  3 +++
>  arch/riscv/kvm/aia.c              | 51 ++++++---------------------------=
------
>  arch/riscv/kvm/aia_imsic.c        | 45 +++++++++++++++++++++++++++++++++=
+
>  arch/riscv/kvm/vcpu.c             | 10 --------
>  arch/riscv/kvm/vcpu_timer.c       | 16 ++++++++++++
>  6 files changed, 74 insertions(+), 55 deletions(-)
>


