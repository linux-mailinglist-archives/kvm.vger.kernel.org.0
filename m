Return-Path: <kvm+bounces-55234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BC811B2ECA8
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 06:15:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C42CB1CC31E9
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 04:15:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB74F287275;
	Thu, 21 Aug 2025 04:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CLdElNwO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6941C26C39B
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 04:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755749722; cv=none; b=k3ptyHyup/H02RLyfXnXGptUIF2a7vzNmj7OGzn/6/ushN2p+2a5f1/dkt6O4raWMvDfvKgPj/G+HfH4d1cn2fG190K4jkWWqqy/bjQ69vHLwYwsaIyzA7dsMmwvepOLllqVAZtqPM3AQntSzgGlhS/rsL74hKrjn2+DIIN4ICU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755749722; c=relaxed/simple;
	bh=JdY1qJGiDV0gX5VeBSkpZuvK/MFWiTVeYr9Rr+KfHQo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g1faKrd3zlKCDwGtII7YxRsDhG1D6WJ0S6OyLSpRQn3+ZcRovhnIqVrfxNPhy/8QIckIV15vMqUZYQzZHxvJsCBw9IBcBv9oMdibLUpTIBagjkqtGMLjkkPM1t4Gb4/Y6oQM5w1YEq6tChhFn8fOx4FIMsI9jU9a9fwAB6y1wMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CLdElNwO; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4b29b714f8cso110971cf.1
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 21:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755749720; x=1756354520; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MNaNAKyGPmX/d78vEdQ+QgbBQO1veoXBan2CooQjkMg=;
        b=CLdElNwOtEQr6lq/X7O3rzVpCYQu5nz9UCTQltSzEdArE7IRpgqfjUYkEVTEXZVZu8
         U/uWTpfo4GUnWn+wq/OoRgqdhT8+EH6CJZDD0+bOMoOnscu06UTJekh8+NN83hFWzPwE
         yLEq5VbbHHAQFvciGKOCzPCpXR24pnNuKAsQ7T/3KQxYQhIOvUkEuy7ORoS8AIDBQ1vI
         H/mcmyWqXOCSGW4HGbJUcIz3yB5LjssTUXpW4EXysm4qRCEbNBTk2il7NxNo29wU2Ky3
         R1GT3KnRhweIoUUGKlgg8gFNnxC1EoRO9kM8lMmvxRhNvnZAW9m/FUnTISzuzLUEo2OR
         xtxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755749720; x=1756354520;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MNaNAKyGPmX/d78vEdQ+QgbBQO1veoXBan2CooQjkMg=;
        b=eTHYwRYCPWHB7xDj0rAkWgqj6zFCq3OCoMUU84VnqalpwBWmycJvDTavgvVSS8/p/8
         zfMeAKnJfpCJA3LHV0rtavD09EAeYYO+5GimZ32D8XlEOT/xvRVPBAWQXy7aqKaNqo1f
         Oq3fbCLeGsG5Sg4FuCO2gl4OHGVWgy6hGkVfFIQZAz20ydYLVMH2LNsi8T3rLOiW3V/S
         cP40o6THt1cZv7OIQ72+oZX7OuVTPnfon5d6qZzL/gOV0MvefsUaZO+e5qINZ1Jrjh4V
         lm0Qxth4Xh4t2jhHtt0IXVACciTaO5Z6idUSPp4lLUxeUdlLh7U5YJ1JGPSrh3vt14wf
         ZZsQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQbjZLvD81lTVkNDaZiVi2MyUc62D3JanoZ0/gtPMVDsyJls2utY585nQe3iFdu5Rucds=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMDbzyTHpnATsiszsZq1HSKEzYxDhaebGIyyNC50PrDkOln7L9
	km8dzEezmDGvj066yqIwEsB2a//ga11XUD627nfOuvYxesC43SW1DmZ2EwMB1NF+AbfUO+IYA14
	4qsGYVGmxcUm3sfyb5vvLFKdo+SwbJ4C3Z2BIDVLp
X-Gm-Gg: ASbGncvSAOrQGAI7RiPzLfzvA2t+oL76HCQCgYm5FYnH5nHkWBNXz1t9ONVRzu+GYd2
	0gCqsPJL/NSa/5zdR3wIf3/Vj1gTbF7zAJOTifJOdtpZvR4cdbecBUvzl12NdJpz2Tb/bjEPxFP
	2Z778hONuYdqIAnL/TP5Iy/k70Gm11cEvzMBZuFq04ezmQ5UmZTAhrvFhTLHlzMUAtWTZDN3vcT
	/CJLP6T0uToSDZrl2B2CD8/o3m4TtfQBzvd5JZVfewYLUQ8KxDlTe/gIA==
X-Google-Smtp-Source: AGHT+IHrvMTbTaOJLKUlQ8aFWOIq+tSI0SGfzvUHFpq0M56V8X0953CH98M1Fodt4Q9+4XLn0iKbo+FSiuKH6JDo1rY=
X-Received: by 2002:a05:622a:1aa0:b0:4a5:a83d:f50d with SMTP id
 d75a77b69052e-4b29fa06aadmr1948401cf.11.1755749719366; Wed, 20 Aug 2025
 21:15:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250807201628.1185915-1-sagis@google.com> <20250807201628.1185915-7-sagis@google.com>
 <1348bb0bed9da95489b83312998352060ac3defb.camel@intel.com>
In-Reply-To: <1348bb0bed9da95489b83312998352060ac3defb.camel@intel.com>
From: Sagi Shahar <sagis@google.com>
Date: Wed, 20 Aug 2025 23:15:08 -0500
X-Gm-Features: Ac12FXzudqPDBGFHEJVLJoRihcQqYBZ4EHBHQUfTtFItOC_ZZmIjCuL7sKLyGB8
Message-ID: <CAAhR5DFUKnoi3+1=AufhDtPpGC-isfFJhTa9t9Zv5YmjigDv=w@mail.gmail.com>
Subject: Re: [PATCH v8 06/30] KVM: selftests: Add helper functions to create
 TDX VMs
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Aktas, Erdem" <erdemaktas@google.com>, "shuah@kernel.org" <shuah@kernel.org>, 
	"Afranji, Ryan" <afranji@google.com>, "Chatre, Reinette" <reinette.chatre@intel.com>, 
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, 
	"pratikrajesh.sampat@amd.com" <pratikrajesh.sampat@amd.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"Wang, Roger" <runanwang@google.com>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, 
	"ajones@ventanamicro.com" <ajones@ventanamicro.com>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2025 at 7:49=E2=80=AFPM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
>
> On Thu, 2025-08-07 at 13:16 -0700, Sagi Shahar wrote:
> > +#define XFEATURE_MASK_CET (XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_=
KERNEL)
> > +
> > +static void tdx_apply_cpuid_restrictions(struct kvm_cpuid2 *cpuid_data=
)
> > +{
> > +     for (int i =3D 0; i < cpuid_data->nent; i++) {
> > +             struct kvm_cpuid_entry2 *e =3D &cpuid_data->entries[i];
> > +
> > +             if (e->function =3D=3D 0xd && e->index =3D=3D 0) {
> > +                     /*
> > +                      * TDX module requires both XTILE_{CFG, DATA} to =
be set.
> > +                      * Both bits are required for AMX to be functiona=
l.
> > +                      */
> > +                     if ((e->eax & XFEATURE_MASK_XTILE) !=3D
> > +                         XFEATURE_MASK_XTILE) {
> > +                             e->eax &=3D ~XFEATURE_MASK_XTILE;
> > +                     }
> > +             }
> > +             if (e->function =3D=3D 0xd && e->index =3D=3D 1) {
> > +                     /*
> > +                      * TDX doesn't support LBR yet.
> > +                      * Disable bits from the XCR0 register.
> > +                      */
> > +                     e->ecx &=3D ~XFEATURE_MASK_LBR;
> > +                     /*
> > +                      * TDX modules requires both CET_{U, S} to be set=
 even
> > +                      * if only one is supported.
> > +                      */
> > +                     if (e->ecx & XFEATURE_MASK_CET)
> > +                             e->ecx |=3D XFEATURE_MASK_CET;
> > +             }
> > +     }
> > +}
>
> Since this is only going to be used control the directly configurable bit=
s, do
> we really need to do this? SET_CPUID2 will just get what comes out of
> KVM_TDX_GET_CPUID, so it should pick up the correct values.
>

This code is used before vcpus are created so KVM_TDX_GET_CPUID can't
be used here.

But either way, I removed this function in the next version.

>
> <snip>
>
> > +
> > +static void tdx_td_init(struct kvm_vm *vm, uint64_t attributes)
> > +{
> > +     struct kvm_tdx_init_vm *init_vm;
> > +     const struct kvm_cpuid2 *tmp;
> > +     struct kvm_cpuid2 *cpuid;
> > +
> > +     tmp =3D kvm_get_supported_cpuid();
> > +
> > +     cpuid =3D allocate_kvm_cpuid2(KVM_MAX_CPUID_ENTRIES);
> > +     memcpy(cpuid, tmp, kvm_cpuid2_size(tmp->nent));
> > +     tdx_mask_cpuid_features(cpuid);
> > +
> > +     init_vm =3D calloc(1, sizeof(*init_vm) +
> > +                      sizeof(init_vm->cpuid.entries[0]) * cpuid->nent)=
;
> > +     TEST_ASSERT(init_vm, "vm allocation failed");
> > +
> > +     memcpy(&init_vm->cpuid, cpuid, kvm_cpuid2_size(cpuid->nent));
> > +     free(cpuid);
> > +
> > +     init_vm->attributes =3D attributes;
> > +
> > +     tdx_apply_cpuid_restrictions(&init_vm->cpuid);
> > +     tdx_filter_cpuid(vm, &init_vm->cpuid);
> > +
> > +     tdx_ioctl(vm->fd, KVM_TDX_INIT_VM, 0, init_vm);
> > +     free(init_vm);
> > +}
>
> We should comment the CPUID twiddling that happens here. It masks, filter=
s, and
> applies restrictions. Sounds like all the same thing.
>
>
>

