Return-Path: <kvm+bounces-51769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CEDA9AFCD86
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 16:27:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 602641C20CE8
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 14:25:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3CAA2E093E;
	Tue,  8 Jul 2025 14:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c0YIVrUS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2803721CFF7
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 14:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751984652; cv=none; b=ZMdwkaUoSGz3f6pvJZKTmthJcDYeBpHJ1saY/q+bVFG73BCFLU2S37W1bORcK6tG046ptP4nc/AvfRn0LJyZRuuJ5Y/MAC2s9iB0HAf8WAzklc9qKlC9rF+Hh3SueBxFrimEW7vbOnQVIXI027W1cz6Tk4dKFVXF4dfdSBELpv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751984652; c=relaxed/simple;
	bh=/kZqCbhqYh5YCXTxk+fK0iWg1EAtPt/kehn1Ec6GM3g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HMM1TGWJxmXDGngjEAIznRYJIbn0NSt61+5Btcw2KYgHH9iaL1aJS9nyAsnf/cOmicupK2x/9KHPDUB7hcSY+YBnYuLCQ1Igtk/SA0/nXJS5Z+iKEmYLzzegCYAlsPAeaggQbgZbSHAc5tAyoGr37U7TS+3lMX9m3E4LEH8fiY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c0YIVrUS; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-235e7550f7bso38565305ad.3
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 07:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751984649; x=1752589449; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=F91em5bdhzH0evEHfCzXh2OqMZgsdjbMrBY86+xRXLE=;
        b=c0YIVrUS3xRal5UIPJXKtD2qNRePESEk4haQG42HX3/EIR0G9d1uU/itu9kWWiTd6C
         4Hp+8wMZ+dpXDlO155fnGuZYFBEH1L4Qw1wTIgL9hlkfF5DBfj/M/YGtMVQB6UWw4sTy
         F4EYbgAvP+o/5Nsrw2iIeLBuMAwrVmKoKNlUoYP9/mOdtPCQUbRlieG4t8AMDJvjgeyb
         daR+D2gRtQQlFMPETJIoT047IlhmBA0glZKKMbXRFTajY8+8AuHx3DInoUDS0aUm7jvn
         tryC3WmRCknFDesidSi9JOIbv5YGPU91lXrHQbYQJh2t/1iHFqwDmiJ2lLCWAdwYJM35
         Rs4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751984649; x=1752589449;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F91em5bdhzH0evEHfCzXh2OqMZgsdjbMrBY86+xRXLE=;
        b=QrHFRgh7pC5qFkj+coX+hK0F2UbPbCTgra4DbfIc0cmWZIsI8FWAWTAiUwcwdWh5IU
         03QqswmaVl0sT/Tv7xChfVK/itd+CEj46sIARJLvuW0t2GgcO2EHk1E/B9Tg+jiwi09G
         MCAlfwda7tO/ETZAN0uJX812KfRrK4aaamrUwxnxmSl/QEooiWngUIwISeafXTzWuMn5
         qC9YMX7uBrfP25DdEIwOp3mgUlocF3K2elMzlgcK/47hmV4o/+jZgi2xRMTqUF2onVrt
         50AwEQqmQjmBc25pAIxVNryqi8Gn8Ue+b011gLwShTvb7//vCfcjxSKCFSooyA68uASs
         c/rQ==
X-Forwarded-Encrypted: i=1; AJvYcCV7SdwKs3s6WRCLVrfqg8DkuMWx4o20CuFOsbmYu89HVO70SO2f6flB1bHJaRvzNEsh+R4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNIBPMsP5QuzhO5dkYWwrh+Xbre7oJxWPGqdRqNmQ7WE8gC/Xv
	HtKZ6iLoBWAxijgmu/+T+/G6ufEJaNwXuuQLg/MdyiDzAnxt6zERqL0xwEu2Xko+DuQ1yqDQS9j
	IhPQFEw==
X-Google-Smtp-Source: AGHT+IFbF1V38gdww09JJdOKoOpDJjez8aU/gHvPRnPoc/lwUMPRCGZHI+DXUdaAyT+Hz7B4vCxsYKhdwN4=
X-Received: from pjbsd4.prod.google.com ([2002:a17:90b:5144:b0:311:eb65:e269])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f54d:b0:234:f6ba:e68a
 with SMTP id d9443c01a7336-23dd0b2174dmr54565265ad.45.1751984649451; Tue, 08
 Jul 2025 07:24:09 -0700 (PDT)
Date: Tue, 8 Jul 2025 07:24:07 -0700
In-Reply-To: <d38b37c7-70fe-4c94-9ef2-e5d765ca5c79@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250708101922.50560-1-kirill.shutemov@linux.intel.com>
 <20250708101922.50560-2-kirill.shutemov@linux.intel.com> <d38b37c7-70fe-4c94-9ef2-e5d765ca5c79@intel.com>
Message-ID: <aG0qB2OEUmBTKzpY@google.com>
Subject: Re: [PATCH 1/3] MAINTAINERS: Update the file list in the TDX entry.
From: Sean Christopherson <seanjc@google.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 08, 2025, Dave Hansen wrote:
> On 7/8/25 03:19, Kirill A. Shutemov wrote:
> > @@ -26952,12 +26952,18 @@ L:	linux-coco@lists.linux.dev
> >  S:	Supported
> >  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/tdx
> >  F:	Documentation/ABI/testing/sysfs-devices-virtual-misc-tdx_guest
> > +F:	Documentation/arch/x86/tdx.rst
> > +F:	Documentation/virt/coco/tdx-guest.rst
> > +F:	Documentation/virt/kvm/x86/intel-tdx.rst
> >  F:	arch/x86/boot/compressed/tdx*
> > +F:	arch/x86/boot/compressed/tdcall.S
> >  F:	arch/x86/coco/tdx/
> > -F:	arch/x86/include/asm/shared/tdx.h
> > -F:	arch/x86/include/asm/tdx.h
> > +F:	arch/x86/include/asm/shared/tdx*
> > +F:	arch/x86/include/asm/tdx*
> > +F:	arch/x86/kvm/vmx/tdx*
> >  F:	arch/x86/virt/vmx/tdx/
> > -F:	drivers/virt/coco/tdx-guest
> > +F:	drivers/virt/coco/tdx-guest/
> > +F:	tools/testing/selftests/tdx/
> 
> That file list is getting a bit long, but it _is_ the truth.

What about adding

K:	tdx

instead of listing each file individually?  That might also help clarify what's
up for cases where there is overlap, e.g. with KVM, to convey that this is a
"secondary" entry of sorts.

> It's also adding some arch/x86/kvm/vmx/ files, but I assume Sean and
> Paolo will welcome having some more people cc'd on those patches. The
> hyper-v folks have a similar entry.

No objection from me.

> I'll plan to apply this as-is unless someone screams.

