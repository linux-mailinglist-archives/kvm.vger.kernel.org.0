Return-Path: <kvm+bounces-52423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F0BEFB05078
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 06:50:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 768D57A4ED7
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 04:48:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72D092D29AC;
	Tue, 15 Jul 2025 04:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aevdprUs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48187EEC8;
	Tue, 15 Jul 2025 04:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752554990; cv=none; b=T+FeUgYp7WdxPcJJXPaeyms/PytR6eH/n4zOWmxr4pOP0V+jt8LqB0rBBD+8dIshKUwCjv3LPWtLrmAheLDLF3vciCQ9AU9HbxzyXJ/u3bfZ0xiwx89bwuhvgnEBHJOrkGBAR/an0VQZIsBw28PRobGuDPD8A38aCuHiDW0Ib+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752554990; c=relaxed/simple;
	bh=jCpCZzj9+jIqbDLl0rZNceKFiCwNF5dAp2pbxupYOHU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jJyJS+8mhrwgiYMmgSj8yDnuj0wK9aB5G0oBblA7K0Dev+CkamONw99UOy6aujEi+7Ppp8AtKbP+QyfiHr8r0sRUWKzyIfSolLifng4Y7kD2+z9JqWYjAo/miwHOklEQ4y29U0lK1jDn8ZfgUoztm51REhx4TSuWOZUp4orSQw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aevdprUs; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-313cde344d4so5379278a91.0;
        Mon, 14 Jul 2025 21:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752554988; x=1753159788; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8YHwYy7F+vTrJTZ/Y3Ym4lTo+fho4ey02h10o6MTdS0=;
        b=aevdprUsPKUG2U7ydLpsmJu+IgHS78ximHRlHBGkqPXz/0zj2MN5WwAjbwfSsAEBcC
         MQuK8sQiNdgxe1Z/PAcbUO4MwNIzJBWs0io4Jcp3ICgXuXCdJGHHppC++Md1giVskCov
         m9y1r7WIYwMBvhWUPofdai8Tx4xF01jHrdo6JxURGEu6kZPNvsorEdYvJwcLVLysOO1H
         YBlV/JJMhtOC2c6nxi1ggf44+SkXroiVOJOMkcI09+73AhAR8v2QUXHaiUzFq8Ne859U
         6LIrj0a/ISlphY0uhR0NaWeSuH+LP5P0dp892hZPNiTJlbipNfZnbmP0BLxgGUwJljYu
         BDtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752554988; x=1753159788;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8YHwYy7F+vTrJTZ/Y3Ym4lTo+fho4ey02h10o6MTdS0=;
        b=f9i1pVMGoRVBBQIwvXkuabho1j43FG5l0G/n69HrFp6YAKGSsDUwaEhmSnAJNZ5ip7
         JzP53tLwBp7HrtQGPPiV6ONUzK0tbm4Ag1R9yFV3GpwlmUFVxcNzZwMrtyCfgsLtJWGS
         w1uS0B9XD0zFPGZphj1ohMM/36L2uAUduZ/FVSD5GbUyMnxhzlcFAB7ILxzcGtJ5PVd/
         tw5GkElCCTbxghVAI8VgwI/r/VngxiUqCEWUSuArc0zmFe/pSka8frRr+G9WT4qULtTr
         5zRHa0cfrLgerXh7R7KaFeJqHPECKa2v5UVNWJEgqdIvxDMQpPP71gkeWUdarmJ0nygG
         vsxw==
X-Forwarded-Encrypted: i=1; AJvYcCV98sl+ypsHyIMyHJsmu6ClsPas1tAEgGERjYVUCuwVFGv2F6hjqwaTTEBZVAeXAmUan8c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yystxv5TgTmtsgV0x2JW06yzV+sURH8TdtY8TJgm13I5DaAX9nu
	mfumJ/DmayJFaGBq9BBYx/iRaBkH/EqaP06faXp8Na6NgUXuBrmPXEnTrYG7qi+QQNbifzBBuJ2
	uJn8OndM8Z+MPzoJGu7MveiTZJ+bZhdo=
X-Gm-Gg: ASbGncvHC/jxLNiW1w+aj4Jz/XoB5KdTWKK/FVJUiBL7+jcgkwt5sgX00i5sB9zUbWf
	Ojao6RKlg8hPwz8JdSlSQETOqdd9j/aaacBIcufYGYzWCLLVbiYHxnFh1h7Jd+XmEfypk7apUJu
	2L6KcdbacWNVQjMmZe3hWKcNRLtcIdhhEDMsJgWW5G2VpBS8dF1xmZ6uqzPuGHsJDupVktw+c+i
	GJ1GEVYT8kILVM=
X-Google-Smtp-Source: AGHT+IFv6qUpm4FAbD0oyWkx7SS3q8QYKfFqmrpcSWlil7RPcS1OOxDkzcdvcbnJOeWsCP4nayUex8a2XghIhScitvw=
X-Received: by 2002:a17:90b:558f:b0:312:639:a064 with SMTP id
 98e67ed59e1d1-31c4f5af641mr25885834a91.28.1752554988399; Mon, 14 Jul 2025
 21:49:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com> <20250709033242.267892-20-Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250709033242.267892-20-Neeraj.Upadhyay@amd.com>
From: Tianyu Lan <ltykernel@gmail.com>
Date: Tue, 15 Jul 2025 12:49:12 +0800
X-Gm-Features: Ac12FXzoXpwXjmo15hPC3yFWbIJ0OVO_lPU5_xp67Cj16Rh1xCD3AXZHPFo_q9Q
Message-ID: <CAMvTesB-vrPMDfGhPUb-0ntkCGdUKUtsWe=0PQ65zvbqTwko=g@mail.gmail.com>
Subject: Re: [RFC PATCH v8 19/35] x86/apic: Initialize Secure AVIC APIC
 backing page
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com, pbonzini@redhat.com, 
	kvm@vger.kernel.org, kirill.shutemov@linux.intel.com, huibo.wang@amd.com, 
	naveen.rao@amd.com, kai.huang@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 9, 2025 at 11:40=E2=80=AFAM Neeraj Upadhyay <Neeraj.Upadhyay@am=
d.com> wrote:
>
> With Secure AVIC, the APIC backing page is owned and managed by guest.
> Allocate and initialize APIC backing page for all guest CPUs.
>
> The NPT entry for a vCPU's APIC backing page must always be present
> when the vCPU is running, in order for Secure AVIC to function. A
> VMEXIT_BUSY is returned on VMRUN and the vCPU cannot be resumed if
> the NPT entry for the APIC backing page is not present. To handle this,
> notify GPA of the vCPU's APIC backing page to the hypervisor by using the
> SVM_VMGEXIT_SECURE_AVIC GHCB protocol event. Before executing VMRUN,
> the hypervisor makes use of this information to make sure the APIC backin=
g
> page is mapped in NPT.
>
> Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
> Changes since v7:
>  - No change.

Reviewed-by: Tianyu Lan <tiala@microsoft.com>

--=20
Thanks
Tianyu Lan

