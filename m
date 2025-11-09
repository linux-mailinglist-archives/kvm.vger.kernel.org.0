Return-Path: <kvm+bounces-62413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id D8B70C439AD
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 08:07:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 76D184E221A
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 07:07:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFE40245014;
	Sun,  9 Nov 2025 07:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XGUl+MxX";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bn+evX0Y"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EB71482E8
	for <kvm@vger.kernel.org>; Sun,  9 Nov 2025 07:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762672051; cv=none; b=dEcW+xgPqKhcHgtOUo0+9vqgBKeVC1FifZe45VFQgIgY8t7MvsgM9u4y52uR/ukyj9Snjz0c4KEBGADv9PR1MVKjkP6PLvZH6CtQ/OqePQpjP3uJ8ldeQUEI0+JdLrbVy1diY28UoLCHfhO3lAGbzIWyFIYzFzjrOPFvmRZwZGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762672051; c=relaxed/simple;
	bh=Jmp9ZrL7yj20ouM54WfJB0CbhEdJY3rhnhwFbU4U5QE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mzEeKLMTSRwuALZn2w9aWMAnHGpzcvkfDYSjs6+tpmWpbYMgVP7WWnzcwtb5MzVA0G9XWLQuVo1BuvkxIdCg424sTs0Lr6gDOGBYxL5FP8fSnkVldhb/1HiiyVCVF4X6PF85Du7wPWehLKsvOUcmUw2en+xi0BAWTgohKzrxHjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XGUl+MxX; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bn+evX0Y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762672048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QHvKsjMe/AixpxnbJYjrVGK6zy8xknqlwpjxpwPDfNM=;
	b=XGUl+MxXhAYGJHK8CJuSIJ899TOuTBoSIKbNXRG/Nsi+x4l1B9qABVrQqHUX/ICKI7QLld
	3AS5L8GHWifcALfRIAhGK8Vd6/6reF9IvOhJCC/VvCUAbgBH5NP+bxbxQ1lPTxzs5Xsff+
	DTlJFS8w6HSvfMRV2QPOKoKMFw44MRg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-v31PoZvwPFu7Juty-srhnw-1; Sun, 09 Nov 2025 02:07:26 -0500
X-MC-Unique: v31PoZvwPFu7Juty-srhnw-1
X-Mimecast-MFC-AGG-ID: v31PoZvwPFu7Juty-srhnw_1762672045
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-40cfb98eddbso904825f8f.0
        for <kvm@vger.kernel.org>; Sat, 08 Nov 2025 23:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762672044; x=1763276844; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QHvKsjMe/AixpxnbJYjrVGK6zy8xknqlwpjxpwPDfNM=;
        b=Bn+evX0YE5MQ6FDaAGNk1GZl4qvdooh6suyCd90nSt8qHYBpdypJHRuaPvJieHwBAf
         fYaJQZRXBdeoy2THDI5q21cYiZEkjLDP7vbh3ksnjAlEpR4gVx2PWkO+LBAOByUPWzWv
         wk0JpCZUz77dGwfYdG++kiopUqHzvO3HN4CYRLM4NmcJW6qtQ5LyUMG2oUy9y5aN8wKW
         g4SRBlgu/MVxyBHbdq3/KPRxDNasKp3sJy1KtmNZu9lpX4AzOohtmYaUMQkjB152NOUC
         FkMaUlaNz5ovN/Ry4HaOLFwglh3lyK3g/7ns1qySTfnoQEC0YbRPd8U8QaRZM3bmJ0WL
         cWqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762672044; x=1763276844;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QHvKsjMe/AixpxnbJYjrVGK6zy8xknqlwpjxpwPDfNM=;
        b=lSKx1ok4ICHtHxoIOwd4ARBWSp9qBnbdW8Q86rtLhvEuSVHOdkPcoEAoCtfCCFnf3l
         QvWpgUKs2k17kn/PKSkHtYZm5HQtRQEVqinuMBKjt36Cl5iJomGxxt9gaUUt08YxkM+8
         Y3bKJTaIhG8o05e5v1WxpOUPj7Eq9U9aTYV9DA4OEb6QVtCeuY8oUhdVZrC59aIw6CoQ
         b0h7SIQkmZ4nO4mFaj9JLkQD2SBh4JIx+35YNMTac37veSksnrX4nCGDwO6rHWPB4BeB
         dpJK43GKrXCMqlLTdZGzgm3lGdVULPKb2JVsrP11EjD5suvGRwt98c+ucb7hlwlNP0y/
         1SXQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYs8LTg02Vao3Uy04WJXWDmMpvEeCILwznpM3MIglSfl3tTbUUPZygqYlhhxy5ee/5mLw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNxD7MHCHYHnzWbefnzdfLtV/YM7P8D/rww/ckMpROODTVwvSa
	WyDDoiHzJ3JrKBTJPWCgZOVIcijua0LZrpTExcz0MJMsJ7BVFqi0PTHdmX8YecCCw4xnlsDJufz
	7WulMZV9A8celtkN4zXpr8yxxcjf5kxAjlZZBILDe5dJE9RdGx5WhHNK/YvSBD93SIO6/XNjtV3
	kg8r3Q19AZ1GkEziA5bkgXKEfTHaDVliwWKTVr
X-Gm-Gg: ASbGncv2E0k5bwmHyid6J10cjNYKSuUdomq4BOAqAvCemqFRcWRTKvdnh1eEp4tGGvJ
	4WyY6StUXeMpNqNcT46TGBKci3v3T9hTuomrELPXdvMZhLRjPb92YUHjkSSFlutkQfd5pwQKC5H
	GuFLN8w2f05QvpGBZ1HEVpJTjPWrwETbz9+Mgw+UpVORRryRqM3W67rOkhXRE5IoRMEEQy5ReJG
	sBnlTRZvgYGWdNyA02EHA+lTwIeKju8R1bev2cuvC1vGVYgjuoZQOkdQRmI
X-Received: by 2002:a5d:5f51:0:b0:42b:2dc9:437d with SMTP id ffacd0b85a97d-42b2dc945bemr3340224f8f.8.1762672044537;
        Sat, 08 Nov 2025 23:07:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHlgHVVqddTf0z9GBTwc7IKuQZJE4lbbt4jIACSUKr9tRwMh48mz2VQwkxk817nUPP85PYqX+H4iU6UOxhzr7A=
X-Received: by 2002:a5d:5f51:0:b0:42b:2dc9:437d with SMTP id
 ffacd0b85a97d-42b2dc945bemr3340209f8f.8.1762672044139; Sat, 08 Nov 2025
 23:07:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy1jcXypH3yCUBaci2EbOy2cbr2qNtdYriKa-vcyFFeCzg@mail.gmail.com>
In-Reply-To: <CAAhSdy1jcXypH3yCUBaci2EbOy2cbr2qNtdYriKa-vcyFFeCzg@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sun, 9 Nov 2025 08:07:12 +0100
X-Gm-Features: AWmQ_bnx7mWPxNcnsLGyK7FcbtNdFOMyOYxt5lXfFl9U8cdhZMTbepfHl2tYedU
Message-ID: <CABgObfYYc1MTR6MFjVWfXKu6tOe0iVY-dh9OnGU_6RvF1fCMeg@mail.gmail.com>
Subject: Re: [GIT PULL v2] KVM/riscv fixes for 6.18 take #2
To: Anup Patel <anup@brainfault.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	Atish Patra <atish.patra@linux.dev>, Andrew Jones <ajones@ventanamicro.com>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 25, 2025 at 12:14=E2=80=AFPM Anup Patel <anup@brainfault.org> w=
rote:
>
> Hi Paolo,
>
> We have three fixes for the 6.18 kernel. Two of these
> are related to checking pending interrupts whereas
> the third one removes automatic I/O mapping from
> kvm_arch_prepare_memory_region().
>
> Please pull.

Pulled, thanks.

Paolo

>
> Regards,
> Anup
>
> The following changes since commit 3a8660878839faadb4f1a6dd72c3179c1df567=
87:
>
>   Linux 6.18-rc1 (2025-10-12 13:42:36 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-6.18-2
>
> for you to fetch changes up to 8c5fa3764facaad6d38336e90f406c2c11d69733:
>
>   RISC-V: KVM: Remove automatic I/O mapping for VM_PFNMAP (2025-10-24
> 21:24:36 +0530)
>
> ----------------------------------------------------------------
> KVM/riscv fixes for 6.18, take #2
>
> - Fix check for local interrupts on riscv32
> - Read HGEIP CSR on the correct cpu when checking for IMSIC interrupts
> - Remove automatic I/O mapping from kvm_arch_prepare_memory_region()
>
> ----------------------------------------------------------------
> Fangyu Yu (2):
>       RISC-V: KVM: Read HGEIP CSR on the correct cpu
>       RISC-V: KVM: Remove automatic I/O mapping for VM_PFNMAP
>
> Samuel Holland (1):
>       RISC-V: KVM: Fix check for local interrupts on riscv32
>
>  arch/riscv/kvm/aia_imsic.c | 16 ++++++++++++++--
>  arch/riscv/kvm/mmu.c       | 25 ++-----------------------
>  arch/riscv/kvm/vcpu.c      |  2 +-
>  3 files changed, 17 insertions(+), 26 deletions(-)
>


