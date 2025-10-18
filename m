Return-Path: <kvm+bounces-60442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 631E1BED310
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 17:55:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0055619C3321
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 15:55:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6B1123F417;
	Sat, 18 Oct 2025 15:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mvcnaHVM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A305C1F8AC5
	for <kvm@vger.kernel.org>; Sat, 18 Oct 2025 15:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760802899; cv=none; b=r+odxRZJFuvWoFIMecllKdng1utQfSAVE3ceMOvXzqlnezmsbwfdYA1/2i+RCh4Ao1fcXMNDcFQOuRydhhq/ymInrjBeEblmRnJuc8dQhfOdVmrDwU36VSAc8hsTWh1VurXk6Ek8kDfjd+v5yHefaC2NhHKP67GT7MRY2DQ3Zb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760802899; c=relaxed/simple;
	bh=sVKAaHctC1yRYCu4mr97pDNqGs87idnl+/BtC8bpGmA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ocWjGQBcd1r9xMUauVbFXRaf3OP0EWIUnJ8gr55VKha7xaQwZdeR6aRMgIAxy1KU3TRRO3P8VdheC4Fa/6Ha0jXCE1CQhsSKRXAe7430q1mQuMnA4NbFcdpPiJc5AVncHuQTCjeDEP349mhWz1oyHt8uj4wLSYRoxqknvTt3Qdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mvcnaHVM; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-290d48e9f1fso108995ad.1
        for <kvm@vger.kernel.org>; Sat, 18 Oct 2025 08:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760802897; x=1761407697; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v+y/GbuIzwVBXSPgt0IYrlsBZ+dL6ebQsqmjpjt9+kg=;
        b=mvcnaHVMHKfc9d9+H3ifAZ8zdtX3p+uwxJr7rvMteAJ2lIwyYm7Yy+yQy36Lh4a6U/
         AL8Gm69JVS0CaxT+HCO3Z+0SPSc6rt9AsCm742PXEePCQ5jU56zqntyVbbU8QCwD7Npa
         yvOShlf96e3u64iynTndI1x6IU94ZSCVWZDYgCTn9cIHVrh/+N3b7HkqR9q4pz23JrUE
         HgIPBzb2Qut7llt3r/sNKnlqgdZKZKeeGJUdz12DxrAhcpZJbcyUYfW87nAiJVlvzozg
         kJ8d2yTgLmbAh2HygWbDCtMcIXLcNQr8UGfzxAmdLWgrBZQYpgLIo50uqLnLqbqLwXt4
         Eohw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760802897; x=1761407697;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v+y/GbuIzwVBXSPgt0IYrlsBZ+dL6ebQsqmjpjt9+kg=;
        b=wYM4bUXOnQQFpOu8FA3y0XjMGSZpTbLngUp+jcuI2XbolLmayyxRYJeYunBrOsoW61
         X25rwZpqFPZbbOv+rMuw5kPCvqOxUFWTfqxpXTIxDY/s/xSuhHMWNxh1Ub1QWBG/to68
         MYKb5al4/dBZdiQjcYF5jUjf1pgEY3VgjNg7zZgDAHE/UB4RS5cKu9NV+JLAolWxDI92
         dmftExjmM8gyf7WtGCafGbxPQcghlgohl/nw6fD/N1Y+NN5e0HOY8bvXPgUZqd2VGLax
         m1g63WNGx1MwIK5m5GRSL7/Vovyn0+HfpAaqBv2uun2z+sPJp1rcTy2fNprvoGkLt8Zt
         NjEQ==
X-Forwarded-Encrypted: i=1; AJvYcCV//2lBzbUea8bI8s52kOEOwL9Y602TsfiX0+1hlZXMPUedNesjjH4OJB4UdWsVOfQCoLo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyD6qGwWI0Bw5JrAfJk5wjsHG5rZQWAf+gpeRM/FXUudon09czr
	rQRDIuQ7AXV6PhYKl9xgHw+vQv01LdFWvWcPxAopR6/L7ntg1ymK0y/OozjZA04WBEmZaHqMPhc
	qgDCEiwnpCM2SJ/wWLjUHKpRJIBKZUEg4X5r6AveeNwYkMM2TSvmFwJyWDsU=
X-Gm-Gg: ASbGncs+nOGxrXmL/mPiH9OaQ9Cqm1dHIcgl7GnVDjySv/ju+BZwJ4utAv8vFfY6OGT
	kY8j3igGdq3APhDw30VYBmK/Nu9RHqg/rbSqk0ZlLiCKorZy9bMBQR6J1Ifk9ff+N9jdgpM1vaK
	z7k30BgN2XwWK/or0YW/EPd8ndBIDrQte9TC1OHsf8SauOkYgcLtq/1mfdT8i8evhq7KuSbOA1g
	lREHW9eGpYxqs3azQjHYEgq5fCBwVT73M4T2roHpIWVuZ8HkR9AViJ5uX1xNCPVSdBr2jLBvCGY
	Wp4FC02igz5NyN2Sjw==
X-Google-Smtp-Source: AGHT+IFPG2UyyHX1c0s6kSVXa5NAM5usKNUInL3UiLQme7hcHp+vGKoHFT8nnOpIS0Gk1uoUdPWMm5XNiMZbLUTqhak=
X-Received: by 2002:a17:903:1b6e:b0:26a:f9c7:f335 with SMTP id
 d9443c01a7336-29088b9f8e1mr16508655ad.9.1760802896066; Sat, 18 Oct 2025
 08:54:56 -0700 (PDT)
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
In-Reply-To: <CAGtprH-WE2_ADCCqm2uCvuDVbx61PRpcqy-+krq13rss2T_OSg@mail.gmail.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Sat, 18 Oct 2025 08:54:42 -0700
X-Gm-Features: AS18NWAv7-VQlOHhgcjY-mnsuUnfCgtHPuKbyOsZGhKoWFpiLhH-j25kFc5xkag
Message-ID: <CAGtprH_sedWE_MYmfp3z3RKY_Viq1GGV4qiA0H5g2g=W9LwiXA@mail.gmail.com>
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

On Thu, Oct 2, 2025 at 9:09=E2=80=AFAM Vishal Annapurve <vannapurve@google.=
com> wrote:
>
> On Thu, Oct 2, 2025 at 8:06=E2=80=AFAM Dave Hansen <dave.hansen@intel.com=
> wrote:
> >
> > On 10/2/25 00:46, Juergen Gross wrote:
> > > So lets compare the 2 cases with kdump enabled and disabled in your
> > > scenario (crash of the host OS):
> > >
> > > kdump enabled: No dump can be produced due to the #MC and system is
> > > rebooted.
> > >
> > > kdump disabled: No dump is produced and system is rebooted after cras=
h.
> > > > What is the main concern with kdump enabled? I don't see any
> > > disadvantage with enabling it, just the advantage that in many cases
> > > a dump will be written.
> > The disadvantage is that a kernel bug from long ago results in a machin=
e
> > check. Machine checks are generally indicative of bad hardware. So the
> > disadvantage is that someone mistakes the long ago kernel bug for bad
> > hardware.
> >
> > There are two ways of looking at this:
> >
> > 1. A theoretically fragile kdump is better than no kdump at all. All of
> >    the stars would have to align for kdump to _fail_ and we don't think
> >    that's going to happen often enough to matter.
> > 2. kdump happens after kernel bugs. The machine checks happen because o=
f
> >    kernel bugs. It's not a big stretch to think that, at scale, kdump i=
s
> >    going to run in to these #MCs on a regular basis.
>
> Looking at Elena's response, I would say it's still *a* big stretch
> for kdump to run into these #MCs on a regular basis as following
> sequence is needed for problematic scenario:
> 1) Host OS bug should corrupt TDX private memory with a *partial
> write*, that is part of kernel memory.
>     -> i.e. PAMT tables, SEPT tables, TD VCPU/VM metadata etc.
>     -> IIUC corruption of guest memory is not a concern as that
> belongs to userspace.
> 2) TDX Module/TD shouldn't consume that poisoned memory.
>     -> i.e. no walk of the metadata memory.
> 3) Host kernel needs to generate a bug that causes an orthogonal panic.
>
> *partial writes* IIUC need special instructions.

Circling bank on this topic, I would like to iterate a few points:
1) Google has been running workloads with the series [1] for ~2 years
now, we haven't seen any issues with kdump functionality across kernel
bugs, real hardware issues, private memory corruption etc.
2) IMO rather than disabling kdump because of host kernel bugs
potentially corrupting private memory, it would be much more useful to
employ mechanisms like direct map removal to ensure host bugs leading
to private memory corruption are caught much early on. Disabling kdump
doesn't help the problem here and just makes it worse for a vast
majority of other scenarios. On the other hand, enabling kdump doesn't
make the problem worse than it is.
   - Host IOMMU mappings should also be ideally restricted to the
regions that don't overlap with private memory regions.
3) With DPAMT support [2], the possibility of  the host corrupting
private memory will reduce for the hosts not running confidential VMs
at all.

[1] https://lore.kernel.org/lkml/cover.1727179214.git.kai.huang@intel.com/
[2] https://lore.kernel.org/kvm/20250918232224.2202592-1-rick.p.edgecombe@i=
ntel.com/

