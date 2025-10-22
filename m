Return-Path: <kvm+bounces-60794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A9982BF9C49
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 04:51:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3EEA34E8737
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 02:51:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37E4B221FCF;
	Wed, 22 Oct 2025 02:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dyHywGH7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B3E8248C
	for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 02:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761101459; cv=none; b=TCkFOusSSGETKe2fQetQNDHtAGlF64HgRlmri+oJq+HgmhY5dLKkOYKHDo9Hp3eCXe+GD1/o6AhbWvNMG1kV6EEPegt1TuDudxMXITowu4skk0BB09YSX60Rbndg8a6SQB5XBpxD8Ab9GpfU2lkwDMMqYI/csTK6tHpXkuE8ZHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761101459; c=relaxed/simple;
	bh=74Q/QyxC69gHYqKvcyXF1RTLpkWKNAxTLiRfo0xsGck=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c5pTG/top1j3D1CrthV4iptuiN6cau41yi3xWSItfJr3YFz+kam2aYOPgzKf1JlEj/MMcJaEsRgl1/5JHwUTatPQ4MDx76vQh7PphvlIvdy8icoTr35d8f7jgxwUwU3R3AJGXIcGtYiNW2h8bYDoEKBOQvw5E9Ik/aEkhLo06gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dyHywGH7; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-290d48e9f1fso76425ad.1
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 19:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761101457; x=1761706257; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=74Q/QyxC69gHYqKvcyXF1RTLpkWKNAxTLiRfo0xsGck=;
        b=dyHywGH78S5yBX7YyqKiXj5ikSYRGPZ+VUDVPU5Fa2P9iGR4sh/wx9xP2sJP8DV9j+
         7/7LFvWcUItwKSLr7HNydWPZ09SVE6VXs2EIcap5pAhm7b/D+ql6x/PHkfklwyttMANL
         Eoujm0q12KvsCdobGOnayhIc1irUUZ+c5QMNMgvPPIsUhjjXLAk1uWVVHr2gXwCO7Ga7
         FzzhADifTQbUCjmgacV1Yv2WDqfdR2/lP3yX+z+bkxOrR+IpK9xETQWKxDowR8QPpUAJ
         DUktG+MBZGvfA9mrcgyH5dHmrILCNZHIlcOnlMnrSm1ZGZAUY+9tapCIwXfOVQF33Q9T
         /xaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761101457; x=1761706257;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=74Q/QyxC69gHYqKvcyXF1RTLpkWKNAxTLiRfo0xsGck=;
        b=PhBkr+nkUe1E56PhSPCkNmuOOV5lfZiSVqw+ZOXbB0matEtiYQwVQcOgA5ZcjemP96
         bKM8CmJw1Ly48BOh/y3+Y+zJYOIY7GDmSAiKRZ6OvqJ68nAj3XDfb+XcjBhGuQEbjQeo
         //55AgGT4ZQxt13F06UE40UVBfW4BVr+ygy4LMi4w+kB4rRY0sUL2Q8iQGXc2Y3ZlC4m
         Xpnu8u2QDLfVZV8vBSp5RisBBtHPJarsqYczMlwWAWg75HiGCs/FSCnVtlTJH2E6NAiw
         6GHdJCIgm4JdyCgbm0/+qLwtVuoM3Exp5P01603dmCvMNWuNGEfJbO2zgyzL0c2xBoQT
         +Z+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWFB7IBGhEjXBPCQA9u/Gi0ScVMIwqbe4lOi6VqPIOTRUcLAfbWxguL15YfP/Kb9vgvKGE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfM3KbKPxg0G5BrAy36YjpWBCqRvvbWo4ox7qh7I1Pf806wHF+
	LzrZfajktrvbgZ3FuWkRYTcrrTeWQ0cXy1oxo9KYIr4/jgl78+tVmkGiSBgcVkPAKHEwFNcA7Ql
	bsJjrI27Dp4igrTHYRrcSwz0MrbSCEvjg/i9C7Ryr
X-Gm-Gg: ASbGncue5iK/u7Jn2QZ1YkvhyY6DPLFYSklbffflmzHolQt+ubmNOsNV57JMYGsRUec
	XoLQzf1/EUOl6E50LgAsozBexQ20K5GlNEjH1dDEdbHDHQAQKKFO6dLsC/kCPBRLyIw+8DSah6m
	AmGgOeOnLN84U5wPfVD9wT/FIAWnAqxQsGH5nAdEqctuqy8ORWCFGg3cif/CFXPtssD+G8IH0hk
	fwk2bQtNA9tKXVB/e1TxYZC0Cqvu0RCZI5ulptyMXa6lcxABjB8zCUAXQKdet+LDKW/fx/czJNS
	zIltkX8zWoOstPptIA==
X-Google-Smtp-Source: AGHT+IFkG3kqBGNd46dgK6k1mDuBdTTvwZJXkiU044mOI8ZxoI9hkB/OVHaxUzIqj6um5XEsujlEKYLzOZVTQWu3PkY=
X-Received: by 2002:a17:902:c409:b0:25b:d970:fe45 with SMTP id
 d9443c01a7336-2930238eaf8mr2130905ad.1.1761101457070; Tue, 21 Oct 2025
 19:50:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250901160930.1785244-1-pbonzini@redhat.com> <20250901160930.1785244-5-pbonzini@redhat.com>
 <CAGtprH__G96uUmiDkK0iYM2miXb31vYje9aN+J=stJQqLUUXEg@mail.gmail.com>
 <74a390a1-42a7-4e6b-a76a-f88f49323c93@intel.com> <CAGtprH-mb0Cw+OzBj-gSWenA9kSJyu-xgXhsTjjzyY6Qi4E=aw@mail.gmail.com>
 <a2042a7b-2e12-4893-ac8d-50c0f77f26e9@intel.com> <CAGtprH_nTBdX-VtMQJM4-y8KcB_F4CnafqpDX7ktASwhO0sxAg@mail.gmail.com>
 <DM8PR11MB575071F87791817215355DD8E7E7A@DM8PR11MB5750.namprd11.prod.outlook.com>
 <27d19ea5-d078-405b-a963-91d19b4229c8@suse.com> <5b007887-d475-4970-b01d-008631621192@intel.com>
 <CAGtprH-WE2_ADCCqm2uCvuDVbx61PRpcqy-+krq13rss2T_OSg@mail.gmail.com>
 <CAGtprH_sedWE_MYmfp3z3RKY_Viq1GGV4qiA0H5g2g=W9LwiXA@mail.gmail.com> <08d64b6e-64f2-46e3-b9ef-87b731556ee4@intel.com>
In-Reply-To: <08d64b6e-64f2-46e3-b9ef-87b731556ee4@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 21 Oct 2025 19:50:44 -0700
X-Gm-Features: AS18NWB82gI5mzQohtK6dqujASE7pQMR3DBpwJ7JLgGvKBNTIxbWBEnf-GbjPkc
Message-ID: <CAGtprH860CZk3V_cpYmMz4mWps7mNbttD6=GV-ttkao1FLQ5tg@mail.gmail.com>
Subject: Re: [PATCH 4/7] x86/kexec: Disable kexec/kdump on platforms with TDX
 partial write erratum
To: Dave Hansen <dave.hansen@intel.com>
Cc: Juergen Gross <jgross@suse.com>, "Reshetova, Elena" <elena.reshetova@intel.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"bp@alien8.de" <bp@alien8.de>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"peterz@infradead.org" <peterz@infradead.org>, "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "x86@kernel.org" <x86@kernel.org>, 
	"kas@kernel.org" <kas@kernel.org>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "Huang, Kai" <kai.huang@intel.com>, 
	"seanjc@google.com" <seanjc@google.com>, "Chatre, Reinette" <reinette.chatre@intel.com>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, 
	"ashish.kalra@amd.com" <ashish.kalra@amd.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>, 
	"Gao, Chao" <chao.gao@intel.com>, "sagis@google.com" <sagis@google.com>, 
	"Chen, Farrah" <farrah.chen@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 21, 2025 at 10:08=E2=80=AFAM Dave Hansen <dave.hansen@intel.com=
> wrote:
>
> On 10/18/25 08:54, Vishal Annapurve wrote:
> > Circling bank on this topic, I would like to iterate a few points:
> > 1) Google has been running workloads with the series [1] for ~2 years
> > now, we haven't seen any issues with kdump functionality across kernel
> > bugs, real hardware issues, private memory corruption etc.
>
> Great points and great info!
>
> As a next step, I'd expect someone (at Google) to take this into
> consideration and put together a series to have the kernel comprehend
> those points.

Then is it safe to say that Intel doesn't consider:
* Adding the support to just reset PAMT memory [1] to this series and
* Modifying the logic in this patch [2] to enable kdump and keep kexec
support disabled in this series

as a viable direction upstream for now until a better solution comes along?

If not, can kdump be made optional as Juergen suggested?

[1] https://lore.kernel.org/lkml/6960ef6d7ee9398d164bf3997e6009df3e88cb67.1=
727179214.git.kai.huang@intel.com/
[2] https://lore.kernel.org/all/20250901160930.1785244-5-pbonzini@redhat.co=
m/

