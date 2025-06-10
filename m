Return-Path: <kvm+bounces-48793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BBA5AD2E1D
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 08:52:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1C8897A6489
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 06:51:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B518127A908;
	Tue, 10 Jun 2025 06:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IsdU0W5n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9632119CC3C;
	Tue, 10 Jun 2025 06:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749538364; cv=none; b=QrOqPO1lFqbUUhzfYNA/26CTQoTiZcWtBqRxLYRo0Eu/MmBDa4Ylp7SdNGJ5CEYK61kJs1TI0CfBlWwRnHN02DvbJt+pJUhaHl5KXEbJd5PL5UZDnKeVZuFUwKcvpqAHneB1fjKyvOQ5CztIqcQGh6NH7aq6/bIFSAiMX/3drJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749538364; c=relaxed/simple;
	bh=Z15PpRdSgnz+vXwLbGgMFsx5QYH5wMhLLxDrCSV4sEE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PWCIkvNsHP2sR6UN6oOfvZaQtIJjvBvUsASRUZd/n80ruO+LRSz8Tz8yEr8w9JKsUpKxPbbiPvvuxgaW/vg53aGIAi7pZ+GGmcbPRJ5WXjSe6nPh79J5ved3rYczxiXACcxXoOF/1hYGh05rlxer+CHTnho7RXyl5x9qRWNQOE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IsdU0W5n; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b26f5f47ba1so3414185a12.1;
        Mon, 09 Jun 2025 23:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749538363; x=1750143163; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z15PpRdSgnz+vXwLbGgMFsx5QYH5wMhLLxDrCSV4sEE=;
        b=IsdU0W5n4lnW8nQVUUhMYojQWwgOemfxpXIwl5O8+s1eswQ1UMwqneb3MEviYuDnZK
         pMpDuZcjIj7sjNo2/lXoAJ3sGWNRnFBiNvlfOW5AavFX72lno1yvXuwYMB4CsEPnOYcc
         pO77ByPc2jQqoAKYdP3PYffjzGlk5Kv18BhhqyrDgeWYzs8ugzvNNYrQWcewM5MqNKIe
         qAk0ng2vf0FC289mfC/CT7qvjufoJGduMM4Tlwtw5R7Jwrit8Y/q2OyGvDWVXRQFWMZm
         bG4EXiuNouuiJcpAG3ROKVWz9XWMeYB3HZKlz/i3MHevjIBumpLvqz6mpVLzvjGPbywL
         tLyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749538363; x=1750143163;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z15PpRdSgnz+vXwLbGgMFsx5QYH5wMhLLxDrCSV4sEE=;
        b=wwprI5HYIUaEgCYew0c8XpmjOjpYJtXQLxR9f03JWZWa8/Vn5zGwz8STBnD7gV00Gi
         TAdAy2ePv/dOtkFpTQSdaaPGPmMXmDhe7eYe126982rxhsKYCSdirpgEryvySkL5CT/c
         b7EIPBqmy5ZoH5TAm5j8xEzd6nbSvGrW8IOSN5bf9e6BsY2qGCns/0U86mKw0kSjHzyY
         /abSnAj8zZ+Fd299ObcfOYaeU/trqidbjGWzMBdtUULn2xTVwLzrkNmyMD5zpNOPAKTE
         KNFHKX/UIHlpjGUPAadNAFSsDNq0jLDAyijqGfsvPs/FjupITRvXJzVETa9LyKe3mbM3
         X72Q==
X-Forwarded-Encrypted: i=1; AJvYcCXTmL6sP4p8R8AiYaPX6XqUuWUYo7LaD8L+0C0GJ2ElsdO5KBCDWy/6adCoFSal6eUvVHY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhGLotJ5u4Ak6KIiPv+t8FJ+0JlcP1JbiQyWSiuRBew9NKhHIE
	TfEewS66Wqc5sN4i3393f/loRKnNtTELYKAyJktXfhJwFZfHk6HYP+2/wMqLOMccuUHuzanT+hI
	sRzjTLGc0Gr7Sb8+vVuTf7Rc1QOstlHg=
X-Gm-Gg: ASbGncvAHCFcuYWVjcjhSrfOtAW5Y7ajBCFY5UxeCvTPgCQ45ew+aNjYUjk2WwhxsAp
	CAMnE1WqHJNDfeSUefosAGMEQv7gWdRk16F/O5mqE0U8ndP8QfGWIaw0M1cJYzl4eAS97k/mAYe
	zsWRSBQ6a2hougQdy4WTEZmmuWuPFU5zGn5cjVEPqLpGjAKmaLPeHm5H2ZE0NWLQ==
X-Google-Smtp-Source: AGHT+IEUNOn2nWJk84twTCYrxdBxDsH3Is6LWpRs2m3XayiIYhvCIEcbm420lSbR5Z0lmwZhZHdL1RUgwFFC385C940=
X-Received: by 2002:a17:90a:c10e:b0:311:abba:53c9 with SMTP id
 98e67ed59e1d1-31346af9a80mr23754878a91.7.1749538362856; Mon, 09 Jun 2025
 23:52:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com> <20250514071803.209166-16-Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250514071803.209166-16-Neeraj.Upadhyay@amd.com>
From: Tianyu Lan <ltykernel@gmail.com>
Date: Tue, 10 Jun 2025 14:52:05 +0800
X-Gm-Features: AX0GCFvAyWbItEDYUVD9ACtHYG65hiRhZwCAk_QEh0qppn6kbmRpJvo42ecNl4A
Message-ID: <CAMvTesDRy34gnJCQwDg1Qg+95snPzjB=JQ5+OJ=dJD40bPSSjw@mail.gmail.com>
Subject: Re: [RFC PATCH v6 15/32] x86/apic: Add new driver for Secure AVIC
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com, pbonzini@redhat.com, 
	kvm@vger.kernel.org, kirill.shutemov@linux.intel.com, huibo.wang@amd.com, 
	naveen.rao@amd.com, francescolavra.fl@gmail.com, tiala@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2025 at 3:25=E2=80=AFPM Neeraj Upadhyay <Neeraj.Upadhyay@am=
d.com> wrote:
>
> The Secure AVIC feature provides SEV-SNP guests hardware acceleration
> for performance sensitive APIC accesses while securely managing the
> guest-owned APIC state through the use of a private APIC backing page.
> This helps prevent hypervisor from generating unexpected interrupts for
> a vCPU or otherwise violate architectural assumptions around APIC
> behavior.
>
> Add a new x2APIC driver that will serve as the base of the Secure AVIC
> support. It is initially the same as the x2APIC phys driver (without
> IPI callbacks), but will be modified as features of Secure AVIC are
> implemented.
>
> As the new driver does not implement Secure AVIC features yet, if the
> hypervisor sets the Secure AVIC bit in SEV_STATUS, maintain the existing
> behavior to enforce the guest termination.
>
> Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
Reviewed-by: Tianyu Lan <tiala@microsoft.com>
--
Thanks
Tianyu Lan

