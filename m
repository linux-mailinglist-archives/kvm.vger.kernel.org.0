Return-Path: <kvm+bounces-37160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CAC4A265CE
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 22:38:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F399C1886704
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 21:38:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D3A42116F3;
	Mon,  3 Feb 2025 21:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qmDEtDXn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A86211294
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 21:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738618647; cv=none; b=PSYPhMLUqXhawiR/EmC0hR6dRxjSJBsKUE8NEswhQKkKBLyOYAoc2GPWmB61+33T0cQ9U+26E/WoG73mqIOfPGWfx8EDLvw6WIRYXg1v4t22e4atQAQTYUtbBYqqq/U9PSgjcim38m+0tRezLJ2SLi0ZBZZT2PyRQM/2gQXA0kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738618647; c=relaxed/simple;
	bh=QLnx4/Rgy7zQOoI/TasPwiI6+hjEJs/e68fuOcK9rGs=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=GfU9c5uTcbxuR7SfyLMFK0PY0JuBj8EfcjHzI2FsZLI0wTx3GyeQMvhg2qhGZDi+n5NsO0dO6vbeYspNRpz0cQ6yghhKpZwtdpQ5yq31rGnc4QjC09+doO5PL2a/QgbypG2YDnZHUXoaXUxDvT0DfnfLEv1Bw0LIZBkNd9bvHCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qmDEtDXn; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3cffe6b867fso67730435ab.2
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2025 13:37:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738618645; x=1739223445; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XEqP/YEsjQP6HXPcAZ+OLL0SnqZRyU2wi8fLU4Seg48=;
        b=qmDEtDXnc+drZ2rBsx5VwzDTo8GAidumBDsj/exrwP3oPPPzqsVXCuGF68aWe3gD+9
         fzEtf1YGvJojJQm6s9piBShclKbrI+4Jgs6yCx65MwpwhX5+dVpgfCWWVppr6fdpRsCo
         RvX2A9Q2z5mplQVC1RKXwMyBzd2Hya9FENjOS/qMpJqcodTv41OfSqA6J0RrzH1dsgAH
         IC572ulqisdDqw6RsKjq9T03zRi8lA37nIQLIcF85+S5qpQfUzeR1MlNsuCW910R3iEY
         BNZhhqwPV09n/lrMSAkB/BgVgOwAELzePUlvyo5s/UoXcjwQht8jFSgy2GItQ8b1fBG3
         qwHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738618645; x=1739223445;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XEqP/YEsjQP6HXPcAZ+OLL0SnqZRyU2wi8fLU4Seg48=;
        b=TeY1gFbC6C5lr2Yy6u7m0KeQhpoE5a6FntlKxRvWjSZLbT+UIsgNK1URKaOsEnwyJt
         iqVu4F6cH4oR/LdN7wGLcODXFCLOOKIFnFa1953DjObm31kNHw7zbq7HGmyV4jyyquGs
         UD7XD2ARiX+0G74NsiJn9NoiyYpDLOeQtcBvN4V2lxLASwHOfjBZQFCt0EWLCwSy+NnY
         z9D9jJG2uNpx+5GX4HbRbhwox+MivCZjbNCMV5eL+EnLoKHD3brM3PyQHul53WGbRtXe
         U4mCj/MBlT6zOKl5AcxvwF6dqlC/r1Tz+bbVwsrRff07SBR8K9sJKSwR1dZeMcmEH2Ap
         YvLg==
X-Forwarded-Encrypted: i=1; AJvYcCXn6u2qJjvBh6SIoP7KFtLYlFPFqXp0F5ULfdW2gu36XOFZowaT0qKx9vhntFWvt4YLooU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxsoIHNtS1B9Eox+skjs6d+8rqxYAjZtal9nj5IgCrRblisTye
	YSCLnmgnvVMwOSnwzUpIr9C5j1UiWqjjVbRk+UeUsQ4xLPW7fTWIRhGk4aqQCp0J7s44c3/1iLm
	2Y778crP9DOdGJ/hq97zz4w==
X-Google-Smtp-Source: AGHT+IFzEQXFVr/GsJOoiYsXrEqAdOToUP7ubJ3+EUez4554ouloGovsV2x1HVo9oXN98kh3qBpaq5S0IrbbEWoKkA==
X-Received: from ilbby19.prod.google.com ([2002:a05:6e02:2613:b0:3cf:c127:d037])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a92:cd83:0:b0:3cf:b571:c08c with SMTP id e9e14a558f8ab-3cffe3d1bc2mr218960215ab.3.1738618645230;
 Mon, 03 Feb 2025 13:37:25 -0800 (PST)
Date: Mon, 03 Feb 2025 21:37:24 +0000
In-Reply-To: <gsntzfj91fbs.fsf@coltonlewis-kvm.c.googlers.com> (message from
 Colton Lewis on Wed, 29 Jan 2025 21:27:03 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsntwme61zhn.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [RFC PATCH 1/4] perf: arm_pmuv3: Introduce module param to
 partition the PMU
From: Colton Lewis <coltonlewis@google.com>
To: Colton Lewis <coltonlewis@google.com>
Cc: maz@kernel.org, kvm@vger.kernel.org, linux@armlinux.org.uk, 
	catalin.marinas@arm.com, will@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, pbonzini@redhat.com, shuah@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Colton Lewis <coltonlewis@google.com> writes:

> Marc Zyngier <maz@kernel.org> writes:

>> On Tue, 28 Jan 2025 22:08:27 +0000,
>> Colton Lewis <coltonlewis@google.com> wrote:

>>> >> +	bitmap_set(cpu_pmu->cntr_mask, 0, pmcr_n);
>>> >> +
>>> >> +	if (reserved_guest_counters > 0 && reserved_guest_counters <
>>> pmcr_n) {
>>> >> +		cpu_pmu->hpmn = reserved_guest_counters;
>>> >> +		cpu_pmu->partitioned = true;

>>> > Isn't this going to completely explode on a kernel running at EL1?

>>> Trying to access an EL2 register at EL1 can do that. I'll add the
>>> appropriate hypercalls.

Ooohh. Making this work at EL1 is much more complicated than adding the
hypercall to write MDCR because once HPMN takes effect, the upper range
of counters that the host will use is only writable at EL2. That means
using any register related to any counter in the upper range would also
require a hypercall. The only way around that would be to avoid using
this feature in the host entirely and only enable it when we load a
guest.

I know we don't like feature discrepencies between VHE and nVHE mode,
but Oliver thinks it might be justified here to have PMU partitioning be
VHE-only.

