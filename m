Return-Path: <kvm+bounces-30966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AA789BF159
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:15:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B6831F21D09
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 15:15:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF7ED20263A;
	Wed,  6 Nov 2024 15:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fkJ9eDg7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899911D7E30
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 15:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730906148; cv=none; b=DeTe4EYZt/QXPRFfyEbPBnJnrs4QbYwzguqEVHAk237Y1n6ileegExRCEtvBWz5l/NyF93P5Wgmc1YmpvyX8gmcEHMu/K59s5sDT0zAXnClIWMLcPDo++yTrnPA8YkbUDBv2Y3ilSWdFZSYMtdrSXsMnOFz0+UPU2Kcg4KNfo1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730906148; c=relaxed/simple;
	bh=ah6lRDJ1vIAqy6JYLuznrNniubx0AIAPGEcdoLbmwbk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uFqp9/C67U2qDH09oTL+3A57Bh+fJdeOA9WF/c4noit5rAdsfLa4+Vu++1PK8m30ZwokULzlUc70kBf6WwRYg+pJZKDSf8wHk9jXYa7S+/fRFWnYFOKNUmSj4WUWku69nGgf0FP3oIFCekdZYR9o+WwpH7jrC4SBoQq0Cq6kXUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fkJ9eDg7; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e32e8436adso94023717b3.0
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2024 07:15:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730906145; x=1731510945; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UQ2mx+EpljTToGeyel8oB03Vw6L977V2IZ3L/Hui8OM=;
        b=fkJ9eDg7ln6P3eFEkRVgNEFW9EqDRPPRY78Ous36LuuWrYz90ljfWAkGneRo79LVAm
         /MXHDOFDG1USCtwA1GzmWncEGciH1qWqktpF9/M3O+V3DebHgmetqhccI7lOpFzJNAiA
         Sd/k3gSduveuHBkz91z8cULgdJkw3cY/0V48QnaPWiy7n/xIpuPVpT/W7/SVe2t5HW0M
         90ZMoA52/BUnLeTtqS0fQJVsmnSUnsTVKoT12Q4vKGrkDXc8QTEHY56WOv33opMBQ1I/
         Smakj0n0Nr/tWplJuBd0pjN+tsHyn8vsbuPpzg5GYnRIT7lTVqvNfSCz6fuJEtgcT424
         kdSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730906145; x=1731510945;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UQ2mx+EpljTToGeyel8oB03Vw6L977V2IZ3L/Hui8OM=;
        b=YeHsoFeQm/8vqZg9Vjy9nHlfgW1RSTVKM5Auw8i5II5zHezCISq0VzLcuEMImoYchk
         mLx4OUp2ByrRhquuEN0csYSFN5ku1rjbks7BUsxEWPeTk1Lhp9Qm5fx5iH+nxmPdUOZ7
         bFF6VsWCN3CtcPipuc9Cyi0ylRnIkvs+weC7lXmJ1jkS4XNku1BSUhgPZmRXJXqZsIwb
         hm+AkH4DLHd4WLOa6yrgQ0ye6kxDdXiz52oegLS3RHN/Dnu0hUvAKFWpfvefUMGwq0W4
         jrnVE/N6ErRXcgOQxX54XPg8KV8Kj8GTd1fcTOZR56NxCEQ3kHODw6RzjzpqvikWmgVW
         puvg==
X-Forwarded-Encrypted: i=1; AJvYcCW2F0papv3RBKAqLN8TyunPqe0ysQSVBJFzcHW4+q/awxGH35b138PFPC64lneZnSOfKPA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyE0Qv5lr7RdPQU/i4TUjBsi1cqHfOGpdn7gD/eWxzdrtKh9Qq/
	vi7JSPE2PYlFObBO98UsP567uTPA/hVwQXs48OFF0W+ZT42BZ7zpf+uZKps/mtoLxOUPOS2vY66
	IDw==
X-Google-Smtp-Source: AGHT+IHSVYy6O6LuOrDLKfyMmnWs9nkPoThhKY5KU2GVwo0c+o1WEZ/A33w3yFUxE8RmnKti3wVld/5lngA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:7448:b0:6e3:f12:1ad3 with SMTP id
 00721157ae682-6ea64be01cdmr2004097b3.6.1730906145701; Wed, 06 Nov 2024
 07:15:45 -0800 (PST)
Date: Wed, 6 Nov 2024 07:15:44 -0800
In-Reply-To: <fb72d616-dba8-410f-a377-3774aa7a5295@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105160234.1300702-1-superm1@kernel.org> <ZyuFMtYSneOFrsvs@google.com>
 <fb72d616-dba8-410f-a377-3774aa7a5295@kernel.org>
Message-ID: <ZyuIINwBdiztWhi3@google.com>
Subject: Re: [PATCH] x86/CPU/AMD: Clear virtualized VMLOAD/VMSAVE on Zen4 client
From: Sean Christopherson <seanjc@google.com>
To: Mario Limonciello <superm1@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, Nikolay Borisov <nik.borisov@suse.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Brijesh Singh <brijesh.singh@amd.com>, 
	"open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>, 
	Mario Limonciello <mario.limonciello@amd.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 06, 2024, Mario Limonciello wrote:
> On 11/6/2024 09:03, Sean Christopherson wrote:
> > +KVM, given that this quite obviously affects KVM...
> > 
> > On Tue, Nov 05, 2024, Mario Limonciello wrote:
> > > From: Mario Limonciello <mario.limonciello@amd.com>
> > > 
> > > A number of Zen4 client SoCs advertise the ability to use virtualized
> > > VMLOAD/VMSAVE, but using these instructions is reported to be a cause
> > > of a random host reboot.
> > > 
> > > These instructions aren't intended to be advertised on Zen4 client
> > > so clear the capability.
> > > 
> > > Cc: stable@vger.kernel.org
> > > Link: https://bugzilla.kernel.org/show_bug.cgi?id=219009
> > > Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> > > ---
> > >   arch/x86/kernel/cpu/amd.c | 11 +++++++++++
> > >   1 file changed, 11 insertions(+)
> > > 
> > > diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> > > index 015971adadfc7..ecd42c2b3242e 100644
> > > --- a/arch/x86/kernel/cpu/amd.c
> > > +++ b/arch/x86/kernel/cpu/amd.c
> > > @@ -924,6 +924,17 @@ static void init_amd_zen4(struct cpuinfo_x86 *c)
> > >   {
> > >   	if (!cpu_has(c, X86_FEATURE_HYPERVISOR))
> > >   		msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_SHARED_BTB_FIX_BIT);
> > > +
> > > +	/*
> > > +	 * These Zen4 SoCs advertise support for virtualized VMLOAD/VMSAVE
> > > +	 * in some BIOS versions but they can lead to random host reboots.
> > 
> > Uh, CPU bug?  Erratum?
> 
> BIOS bug.  Those shouldn't have been advertised.

Why not?  "but they can lead to random host reboots" is a description of the
symptom, not an explanation for why KVM is unable to use a feature that is
apparently support by the CPU.

And if the CPU doesn't actually support virtualized VMLOAD/VMSAVE, then this is
a much bigger problem, because it means KVM is effectively giving the guest read
and write access to all of host memory.

