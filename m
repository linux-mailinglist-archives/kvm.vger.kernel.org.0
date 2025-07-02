Return-Path: <kvm+bounces-51348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DFDC8AF6502
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 00:16:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 214A9522871
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 22:16:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF43124BBEE;
	Wed,  2 Jul 2025 22:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1Ot2qhKR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A943F246BA5
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 22:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751494595; cv=none; b=pV7Ix+Y3e5/7FZAjna0rYN6wWNjG/Rxnd4OZm608bnCQSlDSQFRv9kTRQHyEDPCtXtxhK7H/+D1tLRgilCkc8NvaloRRsCKtSS/fgbkhIxrlcaI22V4xlIcoZrdb+raqb8vk1ZcNEzlXoNQqxsq+FojwSzi0F2RSwJAMlTIcQBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751494595; c=relaxed/simple;
	bh=q8sdUTpaDOCalr3uQLbIEsxC754WeLAOeZDnA3VLNLg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r66Znc4abo3NApFOXE0N19sFu75NBZsjOGvPEZKVeU97OPge/I87672b0OUn7qJjw+bsfgMX1eN0pxc5JCKh4231e/B2OYUMqpQWWEPW/KS91MKxmxKvxXSimDJghkfRDnQ+BXFseJqMHfDIryRDi26Jnmnf6u6a0YGRz+Ky5Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1Ot2qhKR; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-235e389599fso68105ad.0
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 15:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751494593; x=1752099393; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ODBIXl7mimtpT0x2dxMarYzL00zVTd/hQa3cXVMtA1I=;
        b=1Ot2qhKR3hBIXut99VI4saSgzjX6R+NqE9m4p84AEvPAWy0D++Ms9MQOj3OPX54P+2
         P0LrbXTLoonBRq3Nem7S1Dvf+G1NfDFCl6X2FpcLU4ARz+twfepGOb4lz8qQHi24U2Z+
         XSMgyf+w9hiYRR8XTqjWk9sd3Qj6vFC7GeAyE6+pZ1b+Flpy9g4yBAE7gxmJ+ntoHIsR
         JOQ9VBYFAme0imKbrW7CpcTXRieHrdL9acHuxyCkRdXjKME6xHOCxWeVqwn/y/qX9npf
         KqarsnPH3K9jew933PHj+2MhyXjJs/8zt7tfqm4eTcZeQZ933CCUJ7ABhg+8hA0WNxrK
         oYZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751494593; x=1752099393;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ODBIXl7mimtpT0x2dxMarYzL00zVTd/hQa3cXVMtA1I=;
        b=cQABtAI3YUvG7uGQiUmA6vE4DitWyKk/CWj3ZA8beqMW671s2GiSaeWjnCvOwEi+kX
         BcTTfVQeWeHN4hLqYCbydKacAuNIPJADTH4zndf42AWz0LPx8QCnEa/McykpBfAozSTI
         85aiKPj7JYzz83XtAS0eI+88klDDG0DyMFuhkVoXT679i/GMu2t2xOrOtpZznsT9/TGv
         TJwSqhB48H9ooq5apufyC3apdO1g//3Y6fC3tWswGiWXXKYO9BIUXt8B21xlUwCpNiyi
         fB3ok5nO7wQLk/csQCZUlfQjsqkfvwGAE+2cPOIu6vE4B3Tpd4m47tmaXrctY9QKFj88
         PBQw==
X-Forwarded-Encrypted: i=1; AJvYcCWDAA49oJV7x7d00tTUKF/uQM1tyzAcp1R9wQ0zEwFWVIMRtJ+LuEuSp/6D7+FXekwa8PQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRbLo8ndKmBiHmOWCq36duip4y+9e6yYzBgjPmJkLfcHVCk4dm
	xbaD7N4NYk6eCrbnQZuOlCBylHgVi4o8eyEWFbFQDc4emDRqS4gdTf5SwMs+3iFaZYkwCW7ED++
	FC0f5OL4p4dnYGlg2fDND2fIFs4eDZUUQi/KiUOaE
X-Gm-Gg: ASbGnctyH8EancV+hVgMaTSXRSWwtNf7dVVIpcQchLi3Xl8WbFCe8h/Tb4HJ9t/uFNf
	rvy8nR4k3h6xIzUl5B5HBUR5ZqMiC64B4mMaWfuZAj30i8Yw/8CMgyKVWBzlRWi5eemOOBb+Ceb
	17eCS8zQ/d5vAIMl2NsCubS1YTFwpPBArS/pkcbxU3R6NLfS7JbKlktNOLnxTamQ2+FODuQV1K
X-Google-Smtp-Source: AGHT+IHmFHZJ24Y+ziMSvX5rjcfRYWLD7Y/VdnIeVCcN5nPZCJoRQxQxqwCfcVLNNRyHly2Bysp5QGWtiogEV6V/TMk=
X-Received: by 2002:a17:902:f707:b0:234:1073:5b85 with SMTP id
 d9443c01a7336-23c7ab9b011mr340435ad.1.1751494592573; Wed, 02 Jul 2025
 15:16:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1750934177.git.kai.huang@intel.com> <412a62c52449182e392ab359dabd3328eae72990.1750934177.git.kai.huang@intel.com>
 <aGTtCml5ycfoMUJc@intel.com> <01d96257ed48bba14d9d0f786ea90f11eb9e7c7a.camel@intel.com>
In-Reply-To: <01d96257ed48bba14d9d0f786ea90f11eb9e7c7a.camel@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Wed, 2 Jul 2025 15:16:20 -0700
X-Gm-Features: Ac12FXxq7aQYA1K9AcXvIMzY2bZXJ9xuGX0uowMfvU6ATClkt_Y7lz88WQqKWWY
Message-ID: <CAGtprH-q91ajkgzN3Mki9nRt1cJu2fK7XMiZUeJaAfwZOjLduw@mail.gmail.com>
Subject: Re: [PATCH v3 3/6] x86/kexec: Disable kexec/kdump on platforms with
 TDX partial write erratum
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "Gao, Chao" <chao.gao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"ashish.kalra@amd.com" <ashish.kalra@amd.com>, "Hansen, Dave" <dave.hansen@intel.com>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, 
	"Chatre, Reinette" <reinette.chatre@intel.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>, 
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org" <peterz@infradead.org>, 
	"sagis@google.com" <sagis@google.com>, "Chen, Farrah" <farrah.chen@intel.com>, 
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, 
	"x86@kernel.org" <x86@kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 2, 2025 at 1:45=E2=80=AFAM Huang, Kai <kai.huang@intel.com> wro=
te:
>
> On Wed, 2025-07-02 at 16:25 +0800, Gao, Chao wrote:
> > On Thu, Jun 26, 2025 at 10:48:49PM +1200, Kai Huang wrote:
> > > Some early TDX-capable platforms have an erratum: A kernel partial
> > > write (a write transaction of less than cacheline lands at memory
> > > controller) to TDX private memory poisons that memory, and a subseque=
nt
> > > read triggers a machine check.
> > >
> > > On those platforms, the old kernel must reset TDX private memory befo=
re
> > > jumping to the new kernel, otherwise the new kernel may see unexpecte=
d
> > > machine check.  Currently the kernel doesn't track which page is a TD=
X
> > > private page.  For simplicity just fail kexec/kdump for those platfor=
ms.
> >
> > My understanding is that the kdump kernel uses a small amount of memory
> > reserved at boot, which the crashed kernel never accesses. And the kdum=
p
> > kernel reads the memory of the crashed kernel and doesn't overwrite it.
> > So it should be safe to allow kdump (i.e., no partial write to private
> > memory). Anything I missed?
> >
> > (I am not asking to enable kdump in *this* series; I'm just trying to
> > understand the rationale behind disabling kdump)
>
> As you said it *should* be safe.  The kdump kernel should only read TDX
> private memory but not write.  But I cannot say I am 100% sure (there are
> many things involved when generating the kdump file such as memory
> compression) so in internal discussion we thought we should just disable =
it.

So what's the side-effect of enabling kdump, in the worst case kdump
kernel crashes and in the most likely scenario kdump will generate a
lot of important data to analyze from the host failure.

Allowing kdump seems to be a net positive outcome to me. Am I missing
something? If not, my vote would be to enable/allow kdump for such
platforms in this series itself.

