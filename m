Return-Path: <kvm+bounces-5739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DE2C8259B9
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 19:09:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34AAB1F23883
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 18:09:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1036234571;
	Fri,  5 Jan 2024 18:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TpPm8D0T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A042C347B0
	for <kvm@vger.kernel.org>; Fri,  5 Jan 2024 18:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-55679552710so396a12.1
        for <kvm@vger.kernel.org>; Fri, 05 Jan 2024 10:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704478184; x=1705082984; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3BigxxSzpNvAGoQIBfaV1OAOS4EMsVFO9Hy0woPRhdQ=;
        b=TpPm8D0THuXi1FIq5R2hjCd3gktkbRxgejfrMp++MLooGXYzZA01kS0+Wc7dtCjoz0
         xhiyzFtIoOrMYwNdmnerp7LsEmkFjLIY6yC2di5xCp5JaAhpEWZc4MzBUyPn/x5t6lpo
         rvr++SARtWwMaYh+wnamWHdTci5CWluRl/weiyNtre3mocFsERTZcCsXma9LgMKhHhwh
         U6YLzRNarlBw/inS6Lx6V66uaZpGNqMzzT0YZZ5J/w50MPNcw3Thbt5hQ8OmktAx5caT
         TbfGYbTjdWt552vsItQPz3PyOtfu6eoCIMAm3QGh7EMUGDrolUJ6sg3UGgrK6p3a4AzS
         /7lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704478184; x=1705082984;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3BigxxSzpNvAGoQIBfaV1OAOS4EMsVFO9Hy0woPRhdQ=;
        b=OHc1wyyJ5BRNxLfJnPW49o25L/ppza8MFneYAbAwP6LRBY7lyEHZ9Uu4rt7QFDlBPE
         aumAAJFsd6BuZnbRQnTLuH0mFNEI0gDp6UP0o77TYwYJCX1wZG+ku60p+ongKpuaBU/l
         2pdEvT8MbIOYiysUZ2v4m7d6NFAzTUbGVyFiJ+7Ss23kM8jgAG6oFv3vvfp914diAe5h
         eHmV0V86mxippBoukOdhDgDJoWwX2dDUMt+toMgCNzbh5XW7C5wdWuxaYUKlneY/uEzp
         sBn8qRBQ0kl2P2wzi2H49ZwtZlLvENLybP0gTBoPIHTUaQNamFlwSbjj0JfAEelLP9R2
         2jZg==
X-Gm-Message-State: AOJu0YxeXB4taJrdTLdjWNQ0mJxlPkqMXGr5U+hW/97zS+UtWl0eutuM
	KYX/TXYIC8KN88ZA3g/SLMc/SRdbiQrfCyFUcxrk2JsbSTo4
X-Google-Smtp-Source: AGHT+IH+hgjyFFH8aTaoPlj+NLHD2Ehc4vuo3UPmyggTjmI+gf3BrKdlbPGELyqb3KLnry5DEWM/qtyUb8YMzRWptJw=
X-Received: by 2002:a50:9f4a:0:b0:555:6529:3bfe with SMTP id
 b68-20020a509f4a000000b0055565293bfemr6452edf.1.1704478183815; Fri, 05 Jan
 2024 10:09:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231221140239.4349-1-weijiang.yang@intel.com>
 <93f118670137933980e9ed263d01afdb532010ed.camel@intel.com>
 <5f57ce03-9568-4739-b02d-e9fac6ed381a@intel.com> <6179ddcb25c683bd178e74e7e2455cee63ba74de.camel@intel.com>
 <ZZdLG5W5u19PsnTo@google.com> <a2344e2143ef2b9eca0d153c86091e58e596709d.camel@intel.com>
 <ZZdSSzCqvd-3sdBL@google.com> <8f070910-2b2e-425d-995e-dfa03a7695de@intel.com>
 <ZZgsipXoXTKyvCZT@google.com> <9abd8400d25835dd2a6fd41b0104e3c666ee8a13.camel@intel.com>
In-Reply-To: <9abd8400d25835dd2a6fd41b0104e3c666ee8a13.camel@intel.com>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 5 Jan 2024 10:09:28 -0800
Message-ID: <CALMp9eRMoWOS5oAywQCdEsCuTkDqmsVG=Do11FkthD5amr96WA@mail.gmail.com>
Subject: Re: [PATCH v8 00/26] Enable CET Virtualization
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Yang, Weijiang" <weijiang.yang@intel.com>, "seanjc@google.com" <seanjc@google.com>, 
	"Gao, Chao" <chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>, 
	"peterz@infradead.org" <peterz@infradead.org>, "john.allen@amd.com" <john.allen@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 5, 2024 at 9:53=E2=80=AFAM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
>
> On Fri, 2024-01-05 at 08:21 -0800, Sean Christopherson wrote:
> > No, do not inject #UD or do anything else that deviates from
> > architecturally
> > defined behavior.
>
> Here is a, at least partial, list of CET touch points I just created by
> searching the SDM:
> 1. The emulator SW fetch with TRACKER=3D1
> 2. CALL, RET, JMP, IRET, INT, SYSCALL, SYSENTER, SYSEXIT, SYSRET
> 3. Task switching

Sigh. KVM is forced to emulate task switch, because the hardware is
incapable of virtualizing it. How hard would it be to make KVM's
task-switch emulation CET-aware?

> 4. The new CET instructions (which I guess should be handled by
> default): CLRSSBSY, INCSSPD, RSTORSSP, SAVEPREVSSP, SETSSBSYY, WRSS,
> WRUSS
>
> Not all of those are security checks, but would have some functional
> implications. It's still not clear to me if this could happen naturally
> (the TDP shadowing stuff), or only via strange attacker behavior. If we
> only care about the attacker case, then we could have a smaller list.
>
> It also sounds like the instructions in 2 could maybe be filtered by
> mode instead of caring about CET being enabled. But maybe it's not good
> to mix the CET problem with the bigger emulator issues. Don't know.

