Return-Path: <kvm+bounces-65663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C8CB6CB393B
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 18:17:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ABDDC3068014
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 17:16:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6970D3271F3;
	Wed, 10 Dec 2025 17:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cnqzBv+H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A9523F424
	for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 17:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765386998; cv=none; b=e6gOB1p05qNySqOJLPJkKPkeZ3BDXFScKiMbwzxr4aoXEjjARIPctBpiSOJI80q1EZykXfCEpcM831me2vHee1D0D/EGsfV467ecbNvC+8Xy0m92o55TQpdaqXLvTcNP1DQpBuuYR/JtdeIX9BH9GLSW7gxgtW939pQ/JBk04aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765386998; c=relaxed/simple;
	bh=4KI+ckcMR5U8gYwZ4LT8vMa5Q+f+B8Vh83s1DVSWSTU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KoYvHjJNiezsXqkR6w4OL3/d7uk2FKgg9XQH1TCCHtKZ3ICLlB01LrjvFB/mkeCbI1Q/YgNN3lOpCOWgv1ITpE/CxMd3T1I3ioEFZHo838odvtJ8C1lY96MdvwPIUBEg4EQUKABsjVLSLItOHoYS2AT0NAu8hglpt/m31NVFRe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cnqzBv+H; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-645ed666eceso12623a12.1
        for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 09:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765386995; x=1765991795; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4KI+ckcMR5U8gYwZ4LT8vMa5Q+f+B8Vh83s1DVSWSTU=;
        b=cnqzBv+HxOJsf6pSv83icKF+7HH8SuxGZVZuNdzn7RNSaaTjvEEcERwYuQyLaN/S/r
         omIIABebeMkeEld4mHvQN4NE6da8QQdV6T3s2/LplOsmdHAG+aLSMsKzielEhdrSSTE7
         3X59q4F8BcQZSHdY2ZL8JvPq18uR18A1FK84xmFguFEAQ7nkH+Ib0fCdV/gJtmk7Nimw
         HyKGVZ1leMeZmibeIEiq/vO51VBtWy5GPF8fc6vgSw+HK+gT6VoUX7gAj+Yx5IHQkMX/
         q5aledYbwiK7bAY3BSQ87kHPJZHBwimurvv7iqRU/T4/ij6/4+Gi16Lh9koaIhwPwLLC
         ZdyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765386995; x=1765991795;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4KI+ckcMR5U8gYwZ4LT8vMa5Q+f+B8Vh83s1DVSWSTU=;
        b=hMnLFERpHKWeaRfy9yz6crOxwvYyf9tmC0+ZyscTrq+TFfZYB0q0uOg1a62Trc+vvZ
         j7SyMCXEBmD5F8pH9C8RA040B1/HtkzQ0dVycNmkQghMjPbw6CbMk5cTrA0AZICX1btd
         nU3q9kRFHlu89Anr37eskwlxJKNUJJXwGcVL1FBzcARyCFHT/vX0FSuLu0NFxFVMEWqF
         UdvYEyPmC7dYZMDsdj9CUVo2f/Yy/mPe+IlESnf4aWtFYhz/OusZu3X7M4jFlAQCmXk/
         UO3j0Nl14OAxgtpe1o9AGl2CDTgyK0Qglbnp/uPbe30o9z0QTrkkM0yBYAZwv6UjBZbO
         CiVg==
X-Forwarded-Encrypted: i=1; AJvYcCUigepfdpJ39DmqOGooPX6nmHW+BDo4yUaC8qB/BNmALv2NwCf2dlEN8B7Z91sWtuARmaU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXtHyrzBdWjNeBroaJF/STbb4JW7i+eJ2+L99hxK3svne5CcJk
	p7J2s7Dj2kg8GjRDMdUqzctBGqncg/IzH+tLQaxveam4k4OxDkgcfHmM9kZtyEkL0XXRcYh18Yr
	nX0nAkCMLF7RgUEas4Iz7+7/D/X1SPlRACuSSQ41LHCHSmrH9ywn2Znckqvb3dA==
X-Gm-Gg: AY/fxX6yn7wjU0FwYzCZLmX7yssNnTs+XJJRk6VZ5ztYNUvv5YdLNej/O7qEOgPhWJO
	0CEf8fNkmPyJsFnnw6Ur8I+B+uho+nrS9mjPFTW5zIF02ji0vVEdgfw0q2/JXPDx1R/koyNKfQy
	HsBnsr8m7v09CXAptKTpKwmtcEoYuR5vSrLd4DQTkhahHMlFYyDTIZOHc9PraMd7HT5j9FkXxZP
	WxBQPZOD5SvJvlkP0SGM8r+Hz9xv2O+xnbzcRHL38DspMAJFj/qmCpESF5RjP+pILuDsDYuYURH
	G4Ov6nZk6uZN2KyXJ7iAdFHVZ1k=
X-Google-Smtp-Source: AGHT+IGCo694TW1RhmkhZWtiVXhezgljvwqz0W7dqz+T2/n45QTyNPkuuODJ2LDoyhvFUATWBu7KuJF6s8TQvF0s4Vs=
X-Received: by 2002:a05:6402:7d1:b0:643:bfa:62ca with SMTP id
 4fb4d7f45d1cf-6496c403d7cmr50712a12.8.1765386994816; Wed, 10 Dec 2025
 09:16:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250807093950.4395-1-yan.y.zhao@intel.com> <20250807094333.4579-1-yan.y.zhao@intel.com>
 <CAAhR5DGNXi2GeBBZUoZOac6a7_bAquUOzBJuccbeJZ1r97f0Ag@mail.gmail.com>
 <5b9c454946a5fb6782c1245001439620f04932b3.camel@intel.com>
 <CAAhR5DHuhL_oXteqvcFPU_eh6YG38=Gwivh6emJ9vOj5XO_EgQ@mail.gmail.com> <aTjD5FPl1+ktsRkJ@yzhao56-desk.sh.intel.com>
In-Reply-To: <aTjD5FPl1+ktsRkJ@yzhao56-desk.sh.intel.com>
From: Sagi Shahar <sagis@google.com>
Date: Wed, 10 Dec 2025 11:16:23 -0600
X-Gm-Features: AQt7F2rABdgQYlTVVV4LbwYLlWX9Qv6eY8rcsiR6dYwzEzORPrYP5cvF_Zq810g
Message-ID: <CAAhR5DGPF3AV22kQ4ZVNWh3Og=oiJiaDRgBL5feB6C-AHb=apA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 10/23] KVM: TDX: Enable huge page splitting under
 write kvm->mmu_lock
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, 
	"Du, Fan" <fan.du@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>, 
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"tabba@google.com" <tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com" <seanjc@google.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com" <ackerleytng@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"Peng, Chao P" <chao.p.peng@intel.com>, "zhiquan1.li@intel.com" <zhiquan1.li@intel.com>, 
	"Annapurve, Vishal" <vannapurve@google.com>, "Miao, Jun" <jun.miao@intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "pgonda@google.com" <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 9, 2025 at 6:53=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com> wrot=
e:
>
> On Tue, Dec 09, 2025 at 06:28:56PM -0600, Sagi Shahar wrote:
> > On Tue, Dec 9, 2025 at 5:54=E2=80=AFPM Edgecombe, Rick P
> > <rick.p.edgecombe@intel.com> wrote:
> > >
> > > On Tue, 2025-12-09 at 17:49 -0600, Sagi Shahar wrote:
> > > > I was trying to test this code locally (without the DPAMT patches a=
nd
> > > > with DPAMT disabled) and saw that sometimes tdh_mem_page_demote
> > > > returns TDX_INTERRUPTED_RESTARTABLE. Looking at the TDX module code
> > > > (version 1.5.16 from [1]) I see that demote and promote are the onl=
y
> > > > seamcalls that return TDX_INTERRUPTED_RESTARTABLE so it wasn't hand=
led
> > > > by KVM until now.
> > >
> > > Did you see "Open 3" in the coverletter?
> >
> > I tested the code using TDX module 1.5.24 which is the latest one we
> > got. Is there a newer TDX module that supports this new functionality?
> AFAIK, TDX module 1.5.28 is the earliest version that enumerates
> TDX_FEATURES0.ENHANCED_DEMOTE_INTERRUPTIBILITY (bit 51) and disables
> TDX_INTERRUPTED_RESTARTABLE when there're no L2 TDs. (Please check the
> discussions at [1]).
>
> Looks 1.5.28.04 was just released (internally?), with release note saying
> "Ensure TDH.MEM.PAGE.DEMOTE forward progress for non partitioned TDs".
>

Thanks. I don't have access to the 1.5.28.04 module and we need the
code to work with the 1.5.24 module as well based on our timeline so I
guess we can just add the retries locally for now.

Do you see any issue with retrying the operation in case of
TDX_INTERRUPTED_RESTARTABLE? From what I saw this is not just a
theoretical race but happens every time I try to boot a VM, even for a
small VM with 4 VCPUs and 8GB of memory.

> Not sure if you can check it.
>
> [1] https://lore.kernel.org/all/aRRAFhw11Dwcw7RG@yzhao56-desk.sh.intel.co=
m/
>

