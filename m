Return-Path: <kvm+bounces-34029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31C169F5D96
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 04:44:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3098116251A
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 03:44:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C09E14F9E7;
	Wed, 18 Dec 2024 03:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JuViTJyE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301CA14B075
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 03:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734493437; cv=none; b=ggxUiGZXLVtCnknrBOMDNWme3ccg1KOzb86L0zmR6RYQEarxE4dTL+2LCJvjPcJ6mKNEc1ASGSHwiVSx2RZvU9/iz/95gHtNJnCZRBYU2w+rsNE2ZXhWQG3XgU+9TdVd7mQN1jCsGnK/GfKWtiit1+ohd60g6/QtRYnhi/8uBus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734493437; c=relaxed/simple;
	bh=T9P0nKFIxiPyS8k4DExDFRUY23tQRBPVrKGYouHSjtg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gU0POLDZtwUUG54r7G6IABqBsn7okj9UjFtd2k4ptGvPuC1el9LJgrc1CrBHskri2GHsj0zGMrAR+tZxKokzCqk75mHcwkS70QEKb3Bb+JEsLyjRi+PkLfIDCjVPBTUCByxBtTNsaGS1Q2S+Ur+JquUhBS+OeTFLLZ8jMupZaSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JuViTJyE; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef79d9c692so8166398a91.0
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 19:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734493435; x=1735098235; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vMvxGFaauCT6EXkSSVcakmGQcSaxmrUYWuzpakI6n64=;
        b=JuViTJyEXDRPQmhzC6lKYjIAQtYMNGSxDFvZ+5JPzBOXlHOSG0FJrWO3kBuk8XX9Z+
         aW6ayge6DkIwnTBJFrbPfgTJDXW6xUfhli9YoULF4OODZbZlHENwUCh6uzvh/FuqGm2k
         ulDiKeFRmN9UUI+XKFQPGynMeXTEsb5kmnP0eMQpnrtzeMQ/Th14xvyxlQLD8auv5+YJ
         TxG8BvhhRrlPHGkXU78SsNMD8OqYrMojb306HstcrZRTjP1g7iRqNiI7y1sTzW1tMpv2
         GQjwjFrzptar6PRmTRi4z5rhM0hFzwljnkvjEG73nVhXdIhCzH+yJTZ+MW1T7L0DHHPK
         zkHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734493435; x=1735098235;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vMvxGFaauCT6EXkSSVcakmGQcSaxmrUYWuzpakI6n64=;
        b=e1ucQqBBe7281QMjhAeXOssBnNLV9phWaY9gRTwXOmaWhBhvD2S3zS5r5TLLSY7Dwc
         lrzjpTlZQyASr5m1HL/HyOq51vPCnefjX1wI3NWjui8ClpQf04MkACh5S22QesEwOgbG
         O5IaqSb7BGsuQoe05GZGWgNNby7s8VRcZ/JhaZ+xjQ4apXzLSH6w25tMl5RQfK3b7Qag
         RV7mkDjsKoSDx0iHRKfyqhAxCzcSxNj66xq9Xbevk2Ov5QXnvnYtkPd1ix4AHuxAMTHG
         TKhKYfFpPtCSSSWlgwjxpH2oVjCM+G0+rtftJqyYWCfVAU+93CgE8Uf79ja2xcYoCFGf
         ODNw==
X-Forwarded-Encrypted: i=1; AJvYcCWIHPIR626wjPYDbz+NVrnJ/xZqSzyypWy1HFBgWKG5s7CIaNXOJUdFDCV9gk17Re9SSlU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyf7s8tTAg7iuO1/0vy6pIWkvKUWXxW/7bN0uDfke4Ah/DOjALn
	yGO695prL9RtvOV66AcF0nytd9uDYqVwWbJ7+6vBGtWkLotOZfESOls1ryeeLgKrKKq0TeMOfwa
	HPQ==
X-Google-Smtp-Source: AGHT+IEgztvLWb52BnIZoHvncjnNyp90SJMgAHmmjKQFhaCOV0qDcxqDayfebRz4dcLnBBg0mCziG+9A4kQ=
X-Received: from pjuw4.prod.google.com ([2002:a17:90a:d604:b0:2da:5868:311c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:544e:b0:2ee:dcf6:1c8f
 with SMTP id 98e67ed59e1d1-2f2e91f29ffmr2409883a91.16.1734493435506; Tue, 17
 Dec 2024 19:43:55 -0800 (PST)
Date: Tue, 17 Dec 2024 19:43:54 -0800
In-Reply-To: <CADH9ctB0YSYqC_Vj2nP20vMO_gN--KsqOBOu8sfHDrkZJV6pmw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CADH9ctD1uf_yBA3NXNQu7TJa_TPhLRN=0YZ3j2gGhgmaFRdCFg@mail.gmail.com>
 <c3026876-8061-4ab2-9321-97cc05bad510@redhat.com> <CADH9ctBivnvP1tNcatLKzd8EDz8Oo6X65660j8ccxYzk3aFzCA@mail.gmail.com>
 <CABgObfZEyCQMiq6CKBOE7pAVzUDkWjqT2cgfbwjW-RseH8VkLw@mail.gmail.com>
 <CADH9ctA_C1dAOus1K+wOH_SOKTb=-X1sVawt5R=dkH1iGt8QUg@mail.gmail.com>
 <CABgObfZrTyft-3vqMz5w0ZiAhp-v6c32brgftynZGJO8OafrdA@mail.gmail.com>
 <CADH9ctBYp-LMbW4hm3+QwNoXvAc5ryVeB0L1jLY0uDWSe3vbag@mail.gmail.com>
 <b1ddb439-9e28-4a58-ba86-0395bfc081e0@redhat.com> <CADH9ctCFYtNfhn3SSp2jp0fzxu6s_X1A+wBNnzvHZVb8qXPk=g@mail.gmail.com>
 <CADH9ctB0YSYqC_Vj2nP20vMO_gN--KsqOBOu8sfHDrkZJV6pmw@mail.gmail.com>
Message-ID: <Z2IXvsM0olS5GvbR@google.com>
Subject: Re: [PATCH 2/3] KVM: x86: Add support for VMware guest specific hypercalls
From: Sean Christopherson <seanjc@google.com>
To: Doug Covelli <doug.covelli@broadcom.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Zack Rusin <zack.rusin@broadcom.com>, 
	kvm <kvm@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "the arch/x86 maintainers" <x86@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Arnaldo Carvalho de Melo <acme@redhat.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Joel Stanley <joel@jms.id.au>, Linux Doc Mailing List <linux-doc@vger.kernel.org>, linux-kernel@vger.kernel.org, 
	linux-kselftest <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 12, 2024, Doug Covelli wrote:
> On Thu, Nov 14, 2024 at 10:45=E2=80=AFAM Doug Covelli <doug.covelli@broad=
com.com> wrote:
> > > For LINT1, it should be less performance critical; if it's possible
> > > to just go through all vCPUs, and do KVM_GET_LAPIC to check who you
> > > should send a KVM_NMI to, then I'd do that.  I'd also accept a patch
> > > that adds a VM-wide KVM_NMI ioctl that does the same in the hyperviso=
r
> > > if it's useful for you.
> >
> > Thanks for the patch - I'll get it a try but it might not be right away=
.
> >
> > > And since I've been proven wrong already, what do you need INIT/SIPI =
for?
> >
> > I don't think this one is as critical.  I believe the reason it was
> > added was so that we can synchronize startup of the APs with execution
> > of the BSP for guests that do not do a good job of that (Windows).
> >
> > Doug
>=20
> We were able to get the in-kernel APIC working with our code using the sp=
lit
> IRQ chip option with our virtual EFI FW even w/o the traps for SVR and LV=
T0
> writes.  Performance of Windows VMs is greatly improved as expected.
> Unfortunately our ancient legacy BIOS will not work with > 1 VCPU due to =
lack
> of support for IPIs with an archaic delivery mode of remote read which it=
 uses
> to discover APs by attempting to read their APIC ID register.  MSFT WHP s=
upports
> this functionality via an option, WHvPartitionPropertyCodeApicRemoteReadS=
upport.
>=20
> Changing our legacy BIOS is not an option so in order to support Windows =
VMs
> with the legacy BIOS with decent performance we would either need to add =
support
> for remote reads of the APIC ID register to KVM or support CR8 accesses w=
/o
> exiting w/o the in-kernel APIC in order.  Do you have a preference?

I didn't quite follow the CR8 access thing.  If the choice is between emula=
ting
Remote Read IPIs and using a userspace local APIC, then I vote with both ha=
nds
for emulating Remote Reads, especially if we can do a half-assed version th=
at
provides only what your crazy BIOS needs :-)

The biggest wrinkle I can think of is that KVM uses the Remote Read IPI enc=
oding
for a paravirt vCPU kick feature, but I doubt that's used by Windows guests=
 and
so can be sacrificed on the Altar of Ancient BIOS.

