Return-Path: <kvm+bounces-60896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 96DECC02A1C
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 19:03:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C4C7E345BC8
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 17:03:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D1A2345757;
	Thu, 23 Oct 2025 16:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RImSYiwN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE750344047
	for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 16:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761238509; cv=none; b=cXNxI9XM7VIygkFBk+sK617O4rkH9jJRX8wDf/ugmTXJytLCEA1EsIxatONMnrxwe6uU/WUstiECWbl8tBmpVtvKWeyCdoFyOTKhHgeX5MivI3XLsyt5Bc3n1kdraW6lBWdS9wh6NXq4B5GWyRy3rlfv6WcJayxqfqIuDH8h3Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761238509; c=relaxed/simple;
	bh=YrDC/3mfpaef0fGHbDOJscgvzXVsxuu7Gw87FelYM1w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZDBY57fI8nrqCnCY4dFmSBunotpaAtU6p/2MVujbt8j9v5idZOVC3UMJlX0aXRYG3XI4cikz9VkfM3BoNCd97B2rBKpfTk6+S2boaehOqfN74o7TCzKVtxLvVNLefppaOId6cvoBFTNcDaKDzR3XIKniwcXP4Oh8Ove4l4mAGB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RImSYiwN; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-290da96b37fso1235ad.1
        for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 09:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761238507; x=1761843307; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CyiR0u8ocZvunIC/RiElNF1L/aM7gxJVr3g92t8HgY4=;
        b=RImSYiwNjdL23VQBmaOWO87uzg1OhoeLtFZwu0lCtGbmDVcNgjRLWpAqHIhkE5rOnt
         Q7Povhw4pqzLib9aa3j7hvfFsi/o0MrQTosDAAgD51zJ/j2Gjz6j4ZTLYEW6dnt5YcZ7
         KLNRX/GRLviUm8+IdI838RYHGIHn9rE6HUxuCmGlM+XtoFv6KVfzZ9bymmmlRuYnIHkt
         WGGIOpupGkmJuK29uxZU6aBSMMJHdW2qEj+ksReAPjsi1lK1jAnHr3yapc0LIBtYauSj
         urp27OinzXCW4ELq9avfE2efVepezBl8ucBO0kCvq+n+Lr0lT4GGAclcnryZ1M8+y4nm
         hW2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761238507; x=1761843307;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CyiR0u8ocZvunIC/RiElNF1L/aM7gxJVr3g92t8HgY4=;
        b=HvpBXmKq5kE3KG+1PNFk8+Blr0QidWxJk4tm/WcEFTcPC9fe7nl+6t+C0ISY/vSQ2Z
         igWfu9Ow4lhqED42h2oZvT2sifEnZV+GNCVYLY9DOA4jYYQtH5AfEJ14WOUbsvgbCa3q
         0u/rS0SLJlnUwkq0cO5gtS5WoOv3w1uptk4GXuu0duzpAWvfng4JAmiQ4cC4LQ1OM127
         YlJtHPrThSHY9pEiyMZhfIeln2xU03IwGuEw191N2YIq73DLqEh1lNFCRozWPS7y8ptX
         /QGalLT+dz0Mmpg2lQoDjTHhuNSZmZE6wx7vadlnFoMy6IORSOVhpA61VbzleJymRSaA
         808A==
X-Forwarded-Encrypted: i=1; AJvYcCVZ5qTwfrqV6NTbZfZaWNM5SjV8ntjebYyXZ2chO5sO9cSdHaWI9SwhmZlGX8Ch6ddWOdg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWVkqSKeiYduYxRz+Syk9SFE0ZaseO0RwuhNjcUlzkvWtexlqd
	iAXBz/ZLRtu0MpgsYfMsZ/uBFaTFYB++NtoHaIK2alhEKIVvVPhvXqwwjowZ2MU5GviUDbd1P0n
	cTYUAaMW2n7WQtZlg4nq7Rpzo5oy8ufEMHQw7VVar
X-Gm-Gg: ASbGncu2iPmqcsL4EyzQ51d3icMh10Yzoghj3BA9OJI3sWsAGxG1xMBLmlGDdD8aczL
	hGJQZ2EmIn3P3BJTVAnzSQMOxFJRMJ85CYlkKfP5pvZIyt4y0FZD7yHyUeWz4IaFmRar/4acKAu
	Mqw97tgsUG3qRmRMkdyH3LcQmDXX6zOjSMhxAh7Izs7njiz+yxlzvD7CFDEmw0s/7s5JC2JEO53
	PSjJf+4DTe1qm8ohBVeYr09K1bytPbyIm9EqK02AYGUEnn/i/PcYmgXfbTRZzTEqmLG3q9cCfZX
	vWYGu+1YvDrDtoYHuQ==
X-Google-Smtp-Source: AGHT+IFKbuM72mJEDTm+SxvDAF7Q/UY5oa8t6CSwb/j80tiy08frgGSldBorFS7vvcpu0oujlmcNXpyG8/Flcsl68pE=
X-Received: by 2002:a17:902:d512:b0:26e:ac44:3b44 with SMTP id
 d9443c01a7336-294872d7c8emr884775ad.10.1761238506433; Thu, 23 Oct 2025
 09:55:06 -0700 (PDT)
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
 <CAGtprH_sedWE_MYmfp3z3RKY_Viq1GGV4qiA0H5g2g=W9LwiXA@mail.gmail.com>
 <08d64b6e-64f2-46e3-b9ef-87b731556ee4@intel.com> <CAGtprH860CZk3V_cpYmMz4mWps7mNbttD6=GV-ttkao1FLQ5tg@mail.gmail.com>
 <56d5fe5268af7d743f4962cfcc48145e6c0d3db5.camel@intel.com>
In-Reply-To: <56d5fe5268af7d743f4962cfcc48145e6c0d3db5.camel@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Thu, 23 Oct 2025 09:54:53 -0700
X-Gm-Features: AS18NWBwejBgFHJB2xNBPonhiSr_vJQRjOTN-d8yNLfO9ZNitoThOG8nf0Onj28
Message-ID: <CAGtprH-WuXg8aNe=xyQxzmwJQS0kOVLDRPQnC9vxCaQF2+VqJQ@mail.gmail.com>
Subject: Re: [PATCH 4/7] x86/kexec: Disable kexec/kdump on platforms with TDX
 partial write erratum
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "Hansen, Dave" <dave.hansen@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Gao, Chao" <chao.gao@intel.com>, 
	"ashish.kalra@amd.com" <ashish.kalra@amd.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"Reshetova, Elena" <elena.reshetova@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kas@kernel.org" <kas@kernel.org>, 
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "seanjc@google.com" <seanjc@google.com>, 
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "hpa@zytor.com" <hpa@zytor.com>, 
	"peterz@infradead.org" <peterz@infradead.org>, "sagis@google.com" <sagis@google.com>, 
	"Chen, Farrah" <farrah.chen@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"bp@alien8.de" <bp@alien8.de>, "Chatre, Reinette" <reinette.chatre@intel.com>, 
	"jgross@suse.com" <jgross@suse.com>, "x86@kernel.org" <x86@kernel.org>, 
	"Williams, Dan J" <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 22, 2025 at 2:05=E2=80=AFPM Huang, Kai <kai.huang@intel.com> wr=
ote:
>
>
> > * Modifying the logic in this patch [2] to enable kdump and keep kexec
> > support disabled in this series
>
> Resetting TDX private is a complete solution which allows to enable both
> kdump and kexec.  If we choose to reset TDX private memory, then we can
> just revert [2].
>
> >
> > as a viable direction upstream for now until a better solution comes al=
ong?
>
> The alternative could be to simply modify [2] to allow kdump (but leave
> TDX private memory untouched to the new kernel) but not normal kexec.  Th=
e
> risk of doing so has already been covered in this thread AFAICT:
>
>  1) If the kdump kernel does partial write to vmcore, the kdump kernel ma=
y
>     see unexpected #MCE.

Ideally a kdump kernel should not write to vmcore.

>  2) As Elena pointed out, if the old kernel has bug and somehow already
>     does partial write to TDX private memory (which leads to poison), the
>     consumption of such poison may be deferred to the kdump kernel.

Is this case very different from hardware memory failures leading to
poisoned memory ranges? i.e. kdump solution has an existing scenario
of possible poison consumption during generation of kdump.

Is it okay to advertise kdump functionality to be the best effort and
live with this caveat until a cleaner solution comes along?

>
> >
> > If not, can kdump be made optional as Juergen suggested?
>
> IIUC Juergen suggested:
>
>   Then we could add a kernel boot parameter to let the user opt-in
>   for kexec being possible in spite of the potential #MC.
>
> I don't have opinion on this, other than that I think the boot parameter
> only makes sense if we do the "alternative" mentioned above, i.e., not
> resetting TDX private memory.
>
> >
> > [1] https://lore.kernel.org/lkml/6960ef6d7ee9398d164bf3997e6009df3e88cb=
67.1727179214.git.kai.huang@intel.com/
> > [2] https://lore.kernel.org/all/20250901160930.1785244-5-pbonzini@redha=
t.com/

