Return-Path: <kvm+bounces-52223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 61803B0279F
	for <lists+kvm@lfdr.de>; Sat, 12 Jul 2025 01:26:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 508051CA7EE2
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 23:26:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76FEA2236F3;
	Fri, 11 Jul 2025 23:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fWi8hOEu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F0F223323
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 23:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752276360; cv=none; b=H8IWb0SZlcDUAyH/NOXKRAqoCymmXr7TbBLubvd5PiFGc/8GanCwihtje4klIw4WBooJbDv1SSOeJ3+QSPZXsyZdpphoOR/FQsUTJgpgkAJLs8bvXCDUTcVG7RSjUQeb0hjDsjQ3Ed9kv5eRuiR1q/+/Rvc1XR5T2vX6cc7B/ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752276360; c=relaxed/simple;
	bh=FTjm64xHe0mUQGe0gmdkpS1UKnLUFTMDb4s/LwJnZHA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ldljLcwj7hFPNLq4L90f13YselLvWE8pop9oe0gPMhAU32MG6lIobXWDUJKu/016FhQwLVeT9rJ3AFeP01Z8b3fQTZ9yyFjESAN+0AkK1uX1grpwgDlcD/BBHVtrp+yqdZKOKzI0K1KhTa5z+Kc26XuR4yGQwqqiaYt2muaq4Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fWi8hOEu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752276358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KNnitWUyVMmZ677TXjq4fGNMFjZQx7zQ4oPAZSNDf8g=;
	b=fWi8hOEupLzPeFS0KK6lfp3AwDkDJWZyOiym1lzqQUzfiQzKNeLg+4ljhlCRNeR5lVRjTR
	+PDVXs/zza0WWNVTEepEWQHXSX0l9xVf0Zlx2zbz56heGsJp4jeYPOEI1JX3yaIt3YQMYy
	WRncveNqNz4Q6u+N3PGzw7O7kBijsco=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-CgXpMOmzNSOJcTNrUYvz8Q-1; Fri, 11 Jul 2025 19:25:56 -0400
X-MC-Unique: CgXpMOmzNSOJcTNrUYvz8Q-1
X-Mimecast-MFC-AGG-ID: CgXpMOmzNSOJcTNrUYvz8Q_1752276355
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-ae0d76b4f84so211781866b.3
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 16:25:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752276355; x=1752881155;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KNnitWUyVMmZ677TXjq4fGNMFjZQx7zQ4oPAZSNDf8g=;
        b=nUGCtP6m1y83/MbsP6BitzpXfFLiKbW32Vj7Yxebs6N5VGjW/iItLf+LX5LlLHX5HS
         cl+1OyASFAOHSPGjNSLkF0Op5C2c2gXSrt1FFU1M13YiPlRopzrz53GrSAPzCDiJjlck
         JHhZG7HjhK50aekNSQOI32F6w2b5+HDnV96nqCF5RZHjsmG07MTcwzi47Wx4XikPtXEa
         epO3gPWzkydRlTOPd05l3XmUHhSI5awtW26vnECJ0t6m/5WjbqTqZo8sTdET8a2yg5hv
         twUovBlzWy0504XVIp0qSszdhjR3FG1U93g2LFRasLBDzY6x5Iz/aPsFVHb3DpaH86I4
         Tk3A==
X-Forwarded-Encrypted: i=1; AJvYcCWP/sgh0AJ2wMoBwyL4etcy+e9PHbnSAKlJGB44ALLZVcPPT5Wg26/D9mJ+nbneCQQabhA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzI+G0WKbTgpTJalqFWslsDfxn26WWh3LeoEizk3kZrQEExcS9C
	9NOhgmVxIInUG6xhsSOrsizwYjKPZBExO1DQ+r0BtAsn6qzX3QQkes+4WlDJZ73bEteQ5EeXbES
	DkD3auf7yzWGL9i/wEQZ6RMB0RqDA0WFXfTx3QzEmiBO5Euv8JPxsx/Zwd0/PrNo6xHDQ3OgRKe
	2wl7rO83yx2drC5JG3TyDLk7PCwpnY
X-Gm-Gg: ASbGncuondv3SLwOcoApyOqVOkvzQU+qc0IdYuzMR7Dg4gBwBZyQmM0L44lvHCI2SBT
	B/j85HDSwsNbcZg4GR5LhAb1JCcVU9BzQic4Ya0Pj36RDEu6IeY6BGVHdjzM/9e6mMziqnatA8D
	B6w+1918eLhCXoyrNGU3+yng==
X-Received: by 2002:a17:907:1b05:b0:ad9:f54f:70a2 with SMTP id a640c23a62f3a-ae6fbdc90f4mr531762866b.22.1752276355368;
        Fri, 11 Jul 2025 16:25:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFt+iJFpZ7hKPJdxIrpDsRa3jGHWrIka/5oKF32jekBQp3esoTQv/Phk6pp434QyDFneeZCLDCHJ81+4M08gnA=
X-Received: by 2002:a17:907:1b05:b0:ad9:f54f:70a2 with SMTP id
 a640c23a62f3a-ae6fbdc90f4mr531761466b.22.1752276355051; Fri, 11 Jul 2025
 16:25:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250711053509.194751-1-thuth@redhat.com> <2025071125-talon-clammy-4971@gregkh>
 <9f7242e8-1082-4a5d-bb6e-a80106d1b1f9@redhat.com> <2025071152-name-spoon-88e8@gregkh>
 <aHC-Ke2oLri_m7p6@infradead.org> <2025071119-important-convene-ab85@gregkh>
 <CAC1cPGx0Chmz3s+rd5AJAPNCuoyZX-AGC=hfp9JPAG_-H_J6vw@mail.gmail.com> <aHGafTZTcdlpw1gN@gate>
In-Reply-To: <aHGafTZTcdlpw1gN@gate>
From: Richard Fontana <rfontana@redhat.com>
Date: Fri, 11 Jul 2025 19:25:44 -0400
X-Gm-Features: Ac12FXznuBL3348HIkyZK48dfJrdmjVLqm_3FxI1CyeUB1LpyaZRNLgOhXRZp_o
Message-ID: <CAC1cPGzLK8w2e=vz3rgPwWBkqs_2estcbPJgXD-RRx4GjdcB+A@mail.gmail.com>
Subject: Re: [PATCH v2] powerpc: Replace the obsolete address of the FSF
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@infradead.org>, 
	Thomas Huth <thuth@redhat.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Thomas Gleixner <tglx@linutronix.de>, 
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-spdx@vger.kernel.org, 
	J Lovejoy <opensource@jilayne.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2025 at 7:14=E2=80=AFPM Segher Boessenkool
<segher@kernel.crashing.org> wrote:
>
> On Fri, Jul 11, 2025 at 05:02:18PM -0400, Richard Fontana wrote:

> > while this one:
> >
> >  *    As a special exception, if you link this library with files
> >  *    compiled with GCC to produce an executable, this does not cause
> >  *    the resulting executable to be covered by the GNU General Public =
License.
> >  *    This exception does not however invalidate any other reasons why
> >  *    the executable file might be covered by the GNU General Public Li=
cense.
> >
> > does not seem to be in the SPDX exception list. It is very similar to
> > `GNU-compiler-exception` except it specifically mentions GCC instead
> > of saying "a GNU compiler".
>
> https://spdx.org/licenses/GNU-compiler-exception.html
>
> is exactly this.

No, because `GNU-compiler-exception` as defined here
https://github.com/spdx/license-list-XML/blob/main/src/exceptions/GNU-compi=
ler-exception.xml
assumes use of the term "GCC" rather than "a GNU compiler".

Richard


