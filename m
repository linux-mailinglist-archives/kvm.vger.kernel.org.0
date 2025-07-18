Return-Path: <kvm+bounces-52833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DA952B099B4
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 04:17:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B4951C80BE8
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 02:17:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8BFF189906;
	Fri, 18 Jul 2025 02:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EQPpAGUR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE98C70825;
	Fri, 18 Jul 2025 02:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752805010; cv=none; b=FXw/+HiI4dCr8on8QB84LyPY+eJpTe9S/ETwlFtJg3FhSrA7WgI8QVmheSFGhyaVSSAMdPWC8pxNEJF3dDxwsw0gavfLxMsbVwyB0j4/e413WRZ3hfxnsKrb/2XFclVPSzVbxSRAr1Bl3Yc85U4V2UYznbDR3iEKf8+gscgWV/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752805010; c=relaxed/simple;
	bh=VvruBhjiCiVxIuJDIeyL6aRkzsdLfa294STAL3HABG4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uw+aCfLngamteRKys338kTJIyrffMNJLCwWLkA1xAL79moXdsaKiYdIHXjM+DvYYwTlAWJMPvmX5MCh7jVac6s3AHiqAGWkiEcmIVtDxBzTEmaVa5U75aq0sW1CaQuagT4uJoKHhzZIIiNa42tmvvokig7aN86afGjp91Ncb0iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EQPpAGUR; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b34a78bb6e7so1244231a12.3;
        Thu, 17 Jul 2025 19:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752805008; x=1753409808; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/4cVCy+igKClD91Q0C623JaQKFoi0xlJc0TbgPtXkQo=;
        b=EQPpAGUR/I49ElHexdYbwg9ZZMc4p/aUIZ4wUlsQ27hUJ9JByGSqLdgHx511ZHqU79
         XWL6gNqFDpg8DqkEJzwqDKGZHI87XZUWWmiN/KPf873Hq3zlqUnZ+jyvuAmsQEEHw5NY
         LfkJ/hHPf+MvMW/y9tG0MJq4/7NOQuNGFkeO2dndaKtNtQCFbZd6evLTu+ahGe3zfR04
         5JbiloDQi3UXuuhlhMjgL+iELnB3HKwoVl2ZkWXZPzOn/qqgoMMydvwMXM9U+Fje2N4v
         cOYQdGH5Y7uB4KXg9vshUV1hFAVEwGS/bqCpLZKlWZEXTfraBRn41CiZC6TgBowRHLdD
         KUdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752805008; x=1753409808;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/4cVCy+igKClD91Q0C623JaQKFoi0xlJc0TbgPtXkQo=;
        b=NJXfI2/U4//Z7P72GylAo9rwrw8HPZi4UkBJS5+XeH+ucritWIKZB4sOzAvcSr9Mhi
         HRLt9TPjAyuWRf9zD9ggYgKWw4ZB1OJTe7kcDdzmSHq5D1JdWDA/rAEjdRSkSKS5Fc7X
         D2tex6fzBU38lhGfXnu8hPU74Jj5QwypqwSCjpB8f5CljTV0DWSu5zUJ5hzF8c+BESSq
         AlA7bvZp92dK9cxZ9E39jOldvPkiBAkbh3e/pManI/OtvcRambBCXkA4rvuhxuWwnyyS
         Apqgz4kbIueIKjK+jvafPq0R9JVxbGeuB1uzKAB7he9Y07KC7tIN6uM+TwcCsG7Z5edU
         I6dg==
X-Forwarded-Encrypted: i=1; AJvYcCUx0WaFw1OUnrJ90KQ5GPVxjwN06U0uvZCY8HOwd8tyCi5egFT72SsK5rwDOyiVlMch75w=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHV2y1KDHf2+t5nURU4tBWzRFn1ufIcQZvufEP/w8NyHcWHR88
	D0cJJ6TNiac5Y5F+iD9tS08FCZOFU1+z7LBiDAmryD7NiM2t0DduyQJ3jixhUg1sMf7Oh4PizVw
	pa80FzgzPGa7Cbmd8lh3iIA8XmKvH+ws=
X-Gm-Gg: ASbGncsAebkSVRCmProP0IyvgJ6JDYcscTtddbqkZwVt04ESHapyPHyTrGPaAtv9Fxn
	sKYkyqJ2RF1RCxnf3q7CmU7OQ8GSuMknrf6gPXQvpAXYRwU9rvlIJV6UQYrktfkJ023SI04wwPw
	emF4WmyR+YS2m2Af4/HdxjXgFyprFHUdl3eNkU8ebvLgos3NdCD9/YMcFaHooQ1zBzcJPvxu9K2
	ahF
X-Google-Smtp-Source: AGHT+IG5dkHvknOHsiH3gl80hXX/qpto8UyKKqUO8ywyYrqszAloVTmGym/4MmsOqWco1mBL372otu81SQhoXzTKZ0w=
X-Received: by 2002:a17:90b:1f91:b0:312:da0d:3d85 with SMTP id
 98e67ed59e1d1-31c9f3c3657mr13189215a91.6.1752805007852; Thu, 17 Jul 2025
 19:16:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com> <20250709033242.267892-27-Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250709033242.267892-27-Neeraj.Upadhyay@amd.com>
From: Tianyu Lan <ltykernel@gmail.com>
Date: Fri, 18 Jul 2025 10:16:11 +0800
X-Gm-Features: Ac12FXx4-j5t-Wlt-ORWLfXdLOTRGHYgCvA_lqM26BLPXc-phK_PVpOhloCbU-Y
Message-ID: <CAMvTesAXc_nLKUw9eUBQv=7QCyukFDBOragN3PinpbhyxzuZ5w@mail.gmail.com>
Subject: Re: [RFC PATCH v8 26/35] x86/sev: Initialize VGIF for secondary VCPUs
 for Secure AVIC
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

On Wed, Jul 9, 2025 at 11:42=E2=80=AFAM Neeraj Upadhyay <Neeraj.Upadhyay@am=
d.com> wrote:
>
> From: Kishon Vijay Abraham I <kvijayab@amd.com>
>
> Secure AVIC requires VGIF to be configured in VMSA. Configure
> for secondary CPUs (the configuration for boot CPU is done by
> the hypervisor).
>
> Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
> Changes since v7:
>  - No change.


Reviewed-by: Tianyu Lan <tiala@microsoft.com>
--
Thanks
Tianyu Lan

