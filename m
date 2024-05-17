Return-Path: <kvm+bounces-17596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E641A8C85C5
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 13:40:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2354A1C23202
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 11:40:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C0FA3E485;
	Fri, 17 May 2024 11:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h13MafUE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320603D541
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 11:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715946045; cv=none; b=WZfNHcNDCVmF66JnXMekRKQamtFctZgHUR9+/kh3BTedRRwXM/PrBnoj6IqVuDuPVqK2QAmBa2znJOO6vdJwwGeLHYWtzwYPHzTdxXUs1H+PkUdVLoqx8YPQYIffeJZN/J/UWElO6s5ziGuLJ6YGMs5WJ9lbmOO9q8r4Twc/cSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715946045; c=relaxed/simple;
	bh=VTCKd70/SBwuq9RrLUHrCAfekeuemVbrEvH3qT49EA0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Djn8fIvVmMlj7cU3fs6XrVkRpVtrZYXNAUYvlXNPE7yZNmjCPBEKeTEEz0Jv/bW5L4quE39/OrJdsxm9NzjFopgnOl4V2h1u7wam5x/HerQ7XF024owkSUO/UD6nB+4yCLrsZ1gvI4/oiuWS0X+khD7nr6pxIuIHAIUZq9gDfTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h13MafUE; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a59a387fbc9so479528266b.1
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 04:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715946042; x=1716550842; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WE8kqzzVET6JEQADYhspOECjsHmntsmoyxjZQShQKU8=;
        b=h13MafUE4CMkes07gKR1zYLU4bbExQq4dc1f8yv8ayHfkJte6BEC9vc3JwGOf3dkDQ
         foUupXQl+jd6dEmTb/0TuwJP6+SwjEbFL89VJ9xrmO6glkdSWgm7yfdWMN/RKGyJI9v7
         boKjDSVj2sQx8YcxO8MZ/JUAsguR0s0MINH0ZmYkGksQH6C3F3GvWRH3ejrwRfb1My7E
         HYG1yQPQe0SoFNHm2gp2rxO1lyoMYYcUyDlOy0P2uTcYQ3VdsmyFqIY2pvJ9rHDL5Gmy
         78oPdqAernG2WIBYfebJTpib0t+nUZNN15lIHSoipjSQF9XaJ4RGtrjwWcVEGLI4GWPZ
         6Bww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715946042; x=1716550842;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WE8kqzzVET6JEQADYhspOECjsHmntsmoyxjZQShQKU8=;
        b=ngnEpZdTklGRYVHwMyAP76peM1+xTGp44Xkl0DM+CcErTgUi9M4ckgQpJs0uZGLJxC
         S5djPpAyqJHTtI4VmbCCav413EMDwbMAIIUMKz4TKTsr1fca69PjRirHHfya6IoJeLKx
         F2LW04hBWQ3o2U/CSw01oW6YLToSVfR4GuvS0bbUo2QC1PL9GEaNn2sEMn/GuTN0oPpa
         hv2mIYFNCgCB9wngWCf/15zFqzohm6twL8Bi/t/wz/tWJVcBzQFlgmeeX9jsUkHYStBG
         yr8ZRkFBRzrT/+cyCC1/lbXjvNLg75BqYDJhTthAf3dX+CxccrlU8Cwg7AAhkMd/yl6J
         whbQ==
X-Forwarded-Encrypted: i=1; AJvYcCWRcvOceLCPva208sjNiGq6puQUzshc0zaeGEL7XMrZyQAqwNSoTv8Ywn6kQvO2gIAG6H3Ip/xQvG3JbLoKMAgAy1bC
X-Gm-Message-State: AOJu0YzTzHC1PnThPNpbxOfHRlzd630qj/PBmexUe4h3TBM3bc5pMA50
	pjBGGfys+C29eIMKS2xyvPVwtg5jaLVd+GbEwils078xjTtWYcaA3ovv/38k4tiddxPJED8+khX
	UpB9pzSNd1aM1HMen1+0DwNB6uh4=
X-Google-Smtp-Source: AGHT+IGgK1gg9ewAP/rU3qwyrJ4UVfzYpGjGdax9bjRrZPIaqCt237LivRvlO8/auGANv+v0v58KEoOCzaIQawLmTZ8=
X-Received: by 2002:a17:906:eb0f:b0:a59:a83b:d437 with SMTP id
 a640c23a62f3a-a5a2d58a6a8mr1355442066b.32.1715946042225; Fri, 17 May 2024
 04:40:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <82c8c53b-56e8-45af-902a-a6b908e5a8b3@redhat.com> <20240515143728.121855-1-julian.stecklina@cyberus-technology.de>
In-Reply-To: <20240515143728.121855-1-julian.stecklina@cyberus-technology.de>
From: Liang Chen <liangchen.linux@gmail.com>
Date: Fri, 17 May 2024 19:40:30 +0800
Message-ID: <CAKhg4tKg_jS4ZtzJ-x8OZc==TYuagaxaxHHUCHdwKs8CX2x86w@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Prevent L0 VMM from modifying L2 VM registers
 via ioctl
To: Julian Stecklina <julian.stecklina@cyberus-technology.de>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, seanjc@google.com, 
	syzbot+988d9efcdf137bc05f66@syzkaller.appspotmail.com, 
	thomas.prescher@cyberus-technology.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 15, 2024 at 10:38=E2=80=AFPM Julian Stecklina
<julian.stecklina@cyberus-technology.de> wrote:
>
> On Wed, 15 May 2024 13:08:39 +0200 Paolo wrote:
> > On 5/15/24 10:06, Liang Chen wrote:
> >> In a nested VM environment, a vCPU can run either an L1 or L2 VM. If t=
he
> >> L0 VMM tries to configure L1 VM registers via the KVM_SET_REGS ioctl w=
hile
> >> the vCPU is running an L2 VM, it may inadvertently modify the L2 VM's
> >> registers, corrupting the L2 VM. To avoid this error, registers should=
 be
> >> treated as read-only when the vCPU is actively running an L2 VM.
> >
> > No, this is intentional.  The L0 hypervisor has full control on the CPU
> > registers, no matter if the VM is in guest mode or not.
>
> We have a very similar issue and we already discussed it in these two
> threads [1, 2]. Our proposed solution is to introduce a flag in
> kvm_run to make userspace aware of exits with L2 state.
>
Thank you for the information. That should be sufficient for userspace
to determine if the vCPU is in guest mode.

Thanks,
Liang

> Julian
>
>
> [1] https://lore.kernel.org/kvm/20240416123558.212040-1-julian.stecklina@=
cyberus-technology.de/T/#m2eebd2ab30a86622aea3732112150851ac0768fe
> [2] https://lore.kernel.org/kvm/20240508132502.184428-1-julian.stecklina@=
cyberus-technology.de/T/#u
>

