Return-Path: <kvm+bounces-15844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FDB78B0F75
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 18:13:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 817381C21B03
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 16:13:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6830161326;
	Wed, 24 Apr 2024 16:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hPjtlIT6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAAF615E1EA
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 16:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713975210; cv=none; b=cabpaz3Jqa+sBahUqHR/8/Z7a4SeKaIpv4t38ZwPGa0zpuXy9EkqldsWl9YsAjvV3EG7HlyJmV5XSkfHFRiWNSnA8riSa9sfT92vwm5vC4EBvL/h1ahlU8oRrJ4ukCAWcA2SlvhVi4XBvsUy20ONx7ghPT07vvzH6ZC7kGIaEh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713975210; c=relaxed/simple;
	bh=LWAdr7sNhwS/CNPenio+nMszXGBrLvqRUUDAm9TzMRQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jxkp8oRbqQ5uTPdAezHPG4iw5mojCOe9ngKUnqtRg7ZJ+aLqEZdCZWrgyMa3/EFZu1zBJWlyA9yL4bGLguLF1l5Yf4aGs3HjyxwemDrObzlJtLn5xx66E41VRF7g/Ml6Gg6oB3eSDTgmoRCRMDwlZ0h3FopN1T0MCqzd06GW4cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hPjtlIT6; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6ed4298be66so59446b3a.0
        for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 09:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713975208; x=1714580008; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PaA4wyLmEeZNOg80inX0PuP1bfRa+x1yCphxcXdPVro=;
        b=hPjtlIT6PgLW+bzEXKypv38tBnheBFqHe95iWB3Fr0JsxB1302SuLFz+Fd780z6y8+
         N7V1YLrkvBtRcYnkgjWM3rIW69ClIgB0+EHBbEXp8Z+6PqSwD/9OlA6Z7MjY9+jq6jgk
         GzjDtHSSgOiUroBWFgTkDjHihzvirZDiPXDaTo5yOHHuDhMZ/ug3Gn+wHImqP39z9MLl
         vcA3CdjtKAzPIMowa0kZLwGHRDDdVOe9nsgX5JsB4oFS3QGj82echJEZ5sLVVpF+wTr8
         AF3ZtNfP72Hsfb66ox4Dqifs0WCOI9JUF1PlDoyZ1bJvDuR70sVuZMRh+uq/YqQvPglF
         gyxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713975208; x=1714580008;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PaA4wyLmEeZNOg80inX0PuP1bfRa+x1yCphxcXdPVro=;
        b=QONKmM8Fh8Ju09y09xGFOa6+nn1DANm1eyesdcyppJ3Lwlo8wOi5lYAjn81ws7Ick0
         lNv9U7MY2TVjsiuKA7zy1i6Ot4cePV7UiqD1G7CV2tg/84/ke7quaKsqI0UI+E5/KAUN
         +boVdmanzXXW/LDow8wfQeJw/bLENxqhXvl+cuBvnN1l9qxc0T5ROebeXE4wT1x92sH2
         3qe33Xmxy9lADOHkuWKvlO3WG9X76184RfO95UANi8ibSd4xoXiDPD59SRYaydBHw+9o
         s/GmvBJHgml4RImue79Z3WqJ5LQabVRj/SFM6azSEGTAynG+LjL4rD6KyWrMSl9zkI08
         Ddpw==
X-Forwarded-Encrypted: i=1; AJvYcCVQkyZYYBU5GHqzHW3I34tQix7+3UoRPt2GES99ngb1Ijp0VQEgqwYq7WRUeG22DBA89DU2KcjLVBNjHneInTH3gEop
X-Gm-Message-State: AOJu0YyeVR8oP2axPeeqqRPUBbvJxYOxUiUJ9iXL0TbS58pywPK6jnvr
	Z3TEvNLnZLZ6QtbN65lq6vJEmxbZegUt7QHHSkDUClTsKTFPhENbnyCYHDgpHV12qGP6zxfLBTp
	Sag==
X-Google-Smtp-Source: AGHT+IGcH9Ew/i2TenHG22Ht2ZajYli2cHigwOlMHHn2UBTTXvMnBBQr0XVBCFOVW2KZ/Dmr6S2qlvHy+Tc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2450:b0:6ed:d14e:a1b9 with SMTP id
 d16-20020a056a00245000b006edd14ea1b9mr273950pfj.0.1713975208058; Wed, 24 Apr
 2024 09:13:28 -0700 (PDT)
Date: Wed, 24 Apr 2024 09:13:26 -0700
In-Reply-To: <6fae9b07de98d7f56b903031be4490490042ff90.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1711035400.git.reinette.chatre@intel.com> <6fae9b07de98d7f56b903031be4490490042ff90.camel@intel.com>
Message-ID: <Ziku9m_1hQhJgm_m@google.com>
Subject: Re: [PATCH V4 0/4] KVM: x86: Make bus clock frequency for vAPIC timer configurable
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "jmattson@google.com" <jmattson@google.com>, Chao Gao <chao.gao@intel.com>, 
	"vkuznets@redhat.com" <vkuznets@redhat.com>, Vishal Annapurve <vannapurve@google.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 16, 2024, Rick P Edgecombe wrote:
> On Thu, 2024-03-21 at 09:37 -0700, Reinette Chatre wrote:
> > 
> > Summary
> > -------
> > Add KVM_CAP_X86_APIC_BUS_FREQUENCY capability to configure the APIC
> > bus clock frequency for APIC timer emulation.
> > Allow KVM_ENABLE_CAPABILITY(KVM_CAP_X86_APIC_BUS_FREQUENCY) to set the
> > frequency in nanoseconds. When using this capability, the user space
> > VMM should configure CPUID leaf 0x15 to advertise the frequency.
> 
> Looks good to me and...
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> 
> The only thing missing is actually integrating it into TDX qemu patches and
> testing the resulting TD. I think we are making a fair assumption that the
> problem should be resolved based on the analysis, but we have not actually
> tested that part. Is that right?

Please tell me that Rick is wrong, and that this actually has been tested with
a TDX guest.  I don't care _who_ tested it, or with what VMM it has been tested,
but _someone_ needs to verify that this actually fixes the TDX issue.

