Return-Path: <kvm+bounces-39805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 98807A4AB49
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 14:41:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E10E116F0E4
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 13:41:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 234201DF960;
	Sat,  1 Mar 2025 13:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="khbiapUa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4483117580;
	Sat,  1 Mar 2025 13:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740836482; cv=none; b=lqt1P1j/0+KWBR1UQD0NACXY6W6ehWtSLpXQUFUANqtp1Jf8Ka7HsRefak5/UVqi0uqC2q8/+pEjhTxxDlAsPs3iRjoUEw4aL1svde7y7N0jYib3r9PiyUJTNLYylMJ1uBrj2yelfbDFKn1XJeGAwM40BpQQSZjlVUXV+wtyS7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740836482; c=relaxed/simple;
	bh=VE5FWgE1MxTVzfx85xcUwX8vH6LogPEezP+kkD8nwhs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mcrw+kNVwFZuZBI8fKDr96DHT/qqYtf5aNZO4wTV4CFfvqvqJ7mum+2GDpwWjfoQUcIsCzrA2zA5KggZCZsmRXoJgPyLED+71gdkK2LDjtxiOI8PQpRryFTGOjEc7KLN2SbVut7kkBAdKwkhPoAjiZoU8OWTZpvDrMIqOoF2ihY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=khbiapUa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB38CC4CEDD;
	Sat,  1 Mar 2025 13:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740836481;
	bh=VE5FWgE1MxTVzfx85xcUwX8vH6LogPEezP+kkD8nwhs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=khbiapUadqzsFsR7JGus45Aesly4haRuJqlttVuSn/qCm+T0yIDTHIVBAL1tQutx2
	 znCufFUaRLtqQJoqPJhLR6QUvXkegpL5JJX+toQmz9vPfPeb+g6DHDTUFq6OjiAc9X
	 0BJAE1egYVj2L9YnJ9t/U7nS/B3AB2APZFG/fILNgeVS7uWOYiLTQx51zlUFY3vrcp
	 DgFMP2YkXBzCHThN8D8nDQa4TFmDBZFbiWqC2bpM/m7DaQTTM1CD9JEPcuvtGt4hHm
	 ZNEYW0tqcW8rmhF7D7+2Jueo9ffvuybwST959fV9Sv7WNmTCkQqGEr+aupMZ6Sbvwq
	 spggc9hCMhy2A==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-abf4cebb04dso125276966b.0;
        Sat, 01 Mar 2025 05:41:21 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWpDut0dxOIbqPRdHgkrCsJ2EVXPQGsDgih9vP8pyvo4FdNYpGuAuinoBI3ULuGQo54GW0=@vger.kernel.org, AJvYcCXjUBd/crLGccL526hWRDrMAPaixjJNu3+6lI0S8b0gyBTOGvgOh0QUn966GUlaHJoNWJOFNX7YaJ99y6nE@vger.kernel.org
X-Gm-Message-State: AOJu0YyUwhXk5izK1Jiul6Rz/Sz7T1lkUyEgWnXAn5Wz2DuKlGXhMQhr
	1hMRHwsAJfBDWYoY53uztw24p0hIDlNdD9g7RBloKkEHA8s/DgdssvHWQw7y3sj1x0FuqXzpJoM
	5A4xP4vzONmj/8JJue1Y/h+fcEyc=
X-Google-Smtp-Source: AGHT+IG7po7pJDDc35oABPnCV8e2oNeFHbKI421YeH112LWbXzXmwf/99EyoY9TFlshCYr/BgRoR1TuBiXE1OA7g0LA=
X-Received: by 2002:a17:907:8b92:b0:abb:d047:960a with SMTP id
 a640c23a62f3a-abf06286bbbmr1364205066b.22.1740836480291; Sat, 01 Mar 2025
 05:41:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250224095618.1436016-1-maobibo@loongson.cn>
In-Reply-To: <20250224095618.1436016-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 1 Mar 2025 21:41:08 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4fE+SZHpLyPHWv8U0Pr9RmQnoh5sSD9ib6wVbHZYUADA@mail.gmail.com>
X-Gm-Features: AQ5f1Jp9w0nu8wr_nU0qvvl9NReayLSzl0qJaPzXj_Cj24qKIp_wJWEC2z5ZrAk
Message-ID: <CAAhV-H4fE+SZHpLyPHWv8U0Pr9RmQnoh5sSD9ib6wVbHZYUADA@mail.gmail.com>
Subject: Re: [PATCH 0/3] Add perf event support for guest VM
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Series applied, thanks.

Huacai

On Mon, Feb 24, 2025 at 5:56=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> From perf pmu interrupt is normal IRQ rather than NMI, so code cannot be
> profiled if interrupt is disabled. However it is possible to profile
> guest kernel in this situation from host side, profile result is more
> accurate from host than that from guest.
>
> Perf event support for guest VM is added here, and the below is the
> example:
> perf kvm --host --guest --guestkallsyms=3Dguest-kallsyms
>      --guestmodules=3Dguest-modules  top
>
> Overhead  Shared Object               Symbol
>   20.02%  [guest.kernel]              [g] __arch_cpu_idle
>   16.74%  [guest.kernel]              [g] queued_spin_lock_slowpath
>   10.05%  [kernel]                    [k] __arch_cpu_idle
>    2.00%  [guest.kernel]              [g] clear_page
>    1.62%  [guest.kernel]              [g] copy_page
>    1.50%  [guest.kernel]              [g] next_uptodate_folio
>    1.41%  [guest.kernel]              [g] queued_write_lock_slowpath
>    1.41%  [guest.kernel]              [g] unmap_page_range
>    1.36%  [guest.kernel]              [g] mod_objcg_state
>    1.30%  [guest.kernel]              [g] osq_lock
>    1.28%  [guest.kernel]              [g] __slab_free
>    0.98%  [guest.kernel]              [g] copy_page_range
>
> Bibo Mao (3):
>   LoongArch: KVM: Add stub for kvm_arch_vcpu_preempted_in_kernel
>   LoongArch: KVM: Implement arch specified functions for guest perf
>   LoongArch: KVM: Register perf callback for guest
>
>  arch/loongarch/include/asm/kvm_host.h |  2 ++
>  arch/loongarch/kvm/Kconfig            |  1 +
>  arch/loongarch/kvm/main.c             |  2 ++
>  arch/loongarch/kvm/vcpu.c             | 31 +++++++++++++++++++++++++++
>  4 files changed, 36 insertions(+)
>
>
> base-commit: 2408a807bfc3f738850ef5ad5e3fd59d66168996
> --
> 2.39.3
>
>

