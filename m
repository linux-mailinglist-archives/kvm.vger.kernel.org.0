Return-Path: <kvm+bounces-52839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A308B09A01
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 04:58:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D3EA317B708
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 02:58:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57B8F1D8DFB;
	Fri, 18 Jul 2025 02:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OGDF0mw6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C5CA923;
	Fri, 18 Jul 2025 02:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752807488; cv=none; b=kqCT3hhSpH95XwP/SFzUWKEQpNMKkEtYDPixEy/wPbXCwQ31wUohHu9nlgBOpzxqhHb2/iFJe7SfkqE8fyBf6UugXGokAwenaTdSZJ4vDF3LDLLmi69NXmSA6aqQa8ap9pFWx+uST3VtBgGCN3jIAmzryZHOlq6FNRtuvBghyxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752807488; c=relaxed/simple;
	bh=zW8WpDljd70i6LD/w2JqHRPW4ewaJOJjDtvN2vZv6LM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pRCFqer/I4jx/7HIKtZslRp9Hjb8YkkEb0ZqwLysCYBWuy4cPZao1hlF1fe6VBB5RNA530RLcqpOAZDAqDLGqkzotqL8zb14fFmUEGPlI0NLYkve8nKdD3E3KsQhVh/bwAc4tXr4K42pLG73Nthb5zWzsDlLjHGE2iD91ibQtms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OGDF0mw6; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b34a71d9208so1142175a12.3;
        Thu, 17 Jul 2025 19:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752807486; x=1753412286; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B06f3Dtzq7hwRxDjldtJeFqMrkepf4H76VXm0gTo/5o=;
        b=OGDF0mw6fN7aZmIsfhNCR3eOhkx/E6P0oNLjRSUT2N47dP5fns7rQ4DZEIZJEIjL5a
         ZJJZ9ahZH1lx5p5p8Er4V5/YfXYt0SRNxG6T2Ze8QW2DEW9nM6Jg8NmUGT3t5zwXGstG
         ryG8eKfYQpj89pWIFVJtTbPV3Ts7XnIimUabE8KybLca7OiRoLqUpIssRGDDb348Fk+R
         zVnBJlDGoPooLiZ4QsbuujCSVY7qfU95Fk6xLafiAxAYi8RRmkZNXFD1L/agJhMUhSUS
         /ZAUupL7GSAJ77WsHFaE5ZClNZDplyVF719jOILzlsMqJY4MSrz9g2GKG9oGxbHPdNgu
         Ps5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752807486; x=1753412286;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B06f3Dtzq7hwRxDjldtJeFqMrkepf4H76VXm0gTo/5o=;
        b=OSA9g+mK/aZGTiXqcfyzNF+CG4NScHHJXZORSu8Ey+8vHwjuvmzax2XyxA1GzaiPyv
         oKSl7UJ5n4cLzifUkhLmQG3Kz5ee0f6GaCPtbMt70YyRv0eeK/Xvc+bZ0Mjb7vixwxGo
         G0fmIC2GAYFPZXsAUxZ7z5Ls/p/r9Xz7yBIQztfbNQCCRvV/0Y/k13JjhacVWmctxu/1
         2rkNvtKfzGEAuos5Uk0ulNNEono2wJGOBv3rm16fYjbJrOL2gk/zh0ehJ7F/ZlQ912jZ
         2dJASnED/lF2v1PACLZ4xK3DYsgqIEZ85MGhW/caFzKUNfxoK9w9q0WWjY5ppfuw5qKp
         FMfg==
X-Forwarded-Encrypted: i=1; AJvYcCUuvk+KpWEju7pXzaREYK5gyIkGBGEhCELfwZSRIs0vfR3Bita8NyLOjJMVPmtyV9B5qJo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzG5HS66/1H8RodEhDW3ZeBT7gYFbzOJ9aw2SUWvIpXGu+hxVF+
	8XDIgNazDqVE6cPvuKd2f6M8lTwDPmBmscldtd4TDha0hV0eigXpCwwWDUEwQKHmaZxvsszhO1H
	I81RdmjGkV6N5PugW0O9lxnB3VqD9lFg=
X-Gm-Gg: ASbGnct++SjtQrm/PWzbXGEJoZ7HlaoPje49o1wEhkJLZDUoTZZkrOebZAbnGHUEgRq
	Ijiyk7UW7Y+6cjWhKzWDk+uBLU2XJNsM2Qsy/tNgSE8iZwPrcenPg/4JW19RPaVJNq8y0a3G2xG
	5wDs6cKBFhegO3KUJe/VDo/DHcx7doE1Yj3mT2JRkG2C+coLywsBsgyDh09T10mc7bTRKqGLSfX
	3AJyjh8KPzJdJ4=
X-Google-Smtp-Source: AGHT+IHJctuqSROAZ650UpkpwcTiZYiKPNisXk5FDavpFQBEzFA5DmMJwiPzvLSVnjsMRL62PR6InACqufXS044x6w0=
X-Received: by 2002:a17:90b:4985:b0:311:ba32:164f with SMTP id
 98e67ed59e1d1-31c9f47c2f6mr13403273a91.8.1752807486400; Thu, 17 Jul 2025
 19:58:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com> <20250709033242.267892-28-Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250709033242.267892-28-Neeraj.Upadhyay@amd.com>
From: Tianyu Lan <ltykernel@gmail.com>
Date: Fri, 18 Jul 2025 10:57:30 +0800
X-Gm-Features: Ac12FXzmMFbbHVIUaufe3AfDHemMMS8b8hp7m4xVu9SVkkGnzi8hG1q8jkGy4cE
Message-ID: <CAMvTesCqqVovTAyRWZNq1Ermbf1UCK29_-wYA0e99RdSOHxS4Q@mail.gmail.com>
Subject: Re: [RFC PATCH v8 27/35] x86/apic: Add support to send NMI IPI for
 Secure AVIC
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

On Wed, Jul 9, 2025 at 11:45=E2=80=AFAM Neeraj Upadhyay <Neeraj.Upadhyay@am=
d.com> wrote:
>
> Secure AVIC has introduced a new field in the APIC backing page
> "NmiReq" that has to be set by the guest to request a NMI IPI
> through APIC_ICR write.
>
> Add support to set NmiReq appropriately to send NMI IPI.
>
> Sending NMI IPI also requires Virtual NMI feature to be enabled
> in VINTRL_CTRL field in the VMSA. However, this would be added by
> a later commit after adding support for injecting NMI from the
> hypervisor.
>
> Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
> Changes since v7:
>  - No change.
Reviewed-by: Tianyu Lan <tiala@microsoft.com>
--
Thanks
Tianyu Lan

