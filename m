Return-Path: <kvm+bounces-7189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12B9883E116
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 19:12:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFBF4284A19
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 18:12:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D83B0208D9;
	Fri, 26 Jan 2024 18:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HfkL3rMT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A695B208BA
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 18:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292717; cv=none; b=pLuZOWP8bjyzGgpQOwKyXpANQTwMI3pw9Br74MCz5CC6K7u8aMCYRLBdOF2D2QsTOFmTFwomNlr2pSthYBtw6AENSH1kiVpEyzdurB9PvULSw+jFO8VnnkvuprmfMNtnlR7OZ1fY2KAzpkVJhpXiEi1EgcEt/wG/RzBQAx9NpU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292717; c=relaxed/simple;
	bh=LAhg6tS6NsgOJEDjzQ1H66nZrrX2VZPrvnT+rMBSFm4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kDoCbI4zWuzBYy9/AsFh88YE/yEwLzNMboXdCMa/ERysjVy3vDuod6TNrT3CwveIHsR52fYYzlbQyp5EtssKkp+K1zxSEeBknMQIKz302prEz6aYGNAY+W4KgZxyrx5V/iZ3nCTOkUcHDOCg4JzwCYB555VG6tdKVEMgYg9TvdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HfkL3rMT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706292714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PG6onSOxW5WTwWOpHXFWverwBGhD/J43wL8mjF4h6m0=;
	b=HfkL3rMTkaJDYQyIO4CRgJeQrNs5spl//8L0pVeJNlx260DOM987OQMQieQ3D8RlY53387
	b1trKEtGz1bOMz/Uq3AK7SgpTXFFUpxsUWqd6J/xEQy5pPjREt3ynf9Or9mVS6RZv4BDhH
	K8/X3JwMe73hKA8qZI2ptTn5kaAfBr0=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-246-JaGeCNytPRyG593_lfGZxg-1; Fri, 26 Jan 2024 13:11:52 -0500
X-MC-Unique: JaGeCNytPRyG593_lfGZxg-1
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-3bdd8c4ab39so1076658b6e.1
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 10:11:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706292712; x=1706897512;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PG6onSOxW5WTwWOpHXFWverwBGhD/J43wL8mjF4h6m0=;
        b=LkwsWjyN2XI+abfnv2TDHCfhim8UbYuhbgcnjCFdvnzNV4ttIppMuYr/FgbXVVltza
         U2y6IrftuvyD0+cjifTLCUCSeu0v8FWlJubErybwsk+brKEZsYX8hmiJVT6vCTqCASCG
         Ej+jJC0J1Q42hdaDSjE8oEGT1syRYSh3K7kSZ/G9jSgPHfkWtJgs4AiGuakF3kf9UZWI
         hk3Ri1oPhfhH/C95vbP+Gd0/lciM0UkKonpDhF63hCYgWK4fsqKpHdz4QtIYIYe0Fn6/
         DFEbq6Cv/sIFtWg2wMQ4FJA+mVaUoI3rGESJDa8wcpYS3o8Wwdeh8nBV7Fsm3hnFEAAu
         wfNg==
X-Gm-Message-State: AOJu0YxAfKh4mKsYOPGp+yjTBm75KSxYeFBoAzNqRIKz9LKymp63uDjX
	JkwGZVtectlqwAQMta4aJjQDnk7yUKyetkYNqwn1w8S1NrRRMjJu2SfcIdKAuJ5u8eh2T2ViNG8
	PR6Z2DK9xkYenbPP/l0XufsMxJXK0lLziUKtzcBqKHF1AWTeZkUYGsYl51yWBvzfRlA4C3igWdB
	p2gUhl0z28GSHgbafnhjWpSkAt
X-Received: by 2002:a05:6808:19a7:b0:3bd:e0ba:9851 with SMTP id bj39-20020a05680819a700b003bde0ba9851mr157003oib.30.1706292712279;
        Fri, 26 Jan 2024 10:11:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEiFLff6j36/Ab1tXXQQCeW0IAo9c/e1vP7Jgv/bnq5PaDz3DPz7Pm9UGCYE8CoFZAlZ/5HDTeo2SYY7usvdCA=
X-Received: by 2002:a05:6808:19a7:b0:3bd:e0ba:9851 with SMTP id
 bj39-20020a05680819a700b003bde0ba9851mr156988oib.30.1706292712070; Fri, 26
 Jan 2024 10:11:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZbFMXtGmtIMavZKW@google.com> <20240124190158.230-1-moehanabichan@outlook.com>
 <ZbGkZlFmi1war6vq@google.com>
In-Reply-To: <ZbGkZlFmi1war6vq@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 26 Jan 2024 19:11:40 +0100
Message-ID: <CABgObfZe3JWv=zsVoRwgERNzVYLUet8LpRhj_sbh4Mg=zbwsNA@mail.gmail.com>
Subject: Re: Re: Re: [PATCH] KVM: x86: Check irqchip mode before create PIT
To: Sean Christopherson <seanjc@google.com>
Cc: Brilliant Hanabi <moehanabichan@gmail.com>, bp@alien8.de, dave.hansen@linux.intel.com, 
	hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	mingo@redhat.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 25, 2024 at 12:59=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
> On Thu, Jan 25, 2024, Brilliant Hanabi wrote:
> > Thanks for your review. In my opinion, it is better to avoid potential =
bugs
> > which is difficult to detect, as long as you can return errors to let
> > developers know about them in advance, although the kernel is not to bl=
ame
> > for this bug.
>
> Oh, I completely agree that explict errors are far better.  My only conce=
rn is
> that there's a teeny tiny chance that rejecting an ioctl() that used to w=
ork
> could break userspace.
>
> Go ahead and send v2.  I'll get Paolo's thoughts on whether or not this i=
s likely
> to break userspace and we can go from there.

I share the same worry but I agree it's quite unlikely.  Let's just do
it, and if someone complains we'll revert it.

Paolo


