Return-Path: <kvm+bounces-6833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B6FAB83AA34
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 13:46:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6DFD028F4B0
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 12:46:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D22CE7A712;
	Wed, 24 Jan 2024 12:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lUmH60PG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CDA76918;
	Wed, 24 Jan 2024 12:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706100310; cv=none; b=l2UWQfpqRQDIHB8L1fVdn4ofW6nV3Fiw7/3IqQpPvVmKtqpqlonKGbAsOpdUVjIDdrX6R2sNoskUdA2c7/7VtREmfzsWKtnHWZ9rkOv2yimerTTb8QW39trLCAZa73o2zzlLYiFy4UfWqGkUXw7hBHGquqXCMgUq/qO5LNi+TkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706100310; c=relaxed/simple;
	bh=TZXm+kuPZ4nvGmxpZjlQE8EIcmBZdeT0tswbj5rQmKk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hPxG1NmbQuEW3gSXHp8IphEFNAUj9i1HjWBXBhVGb+r25oq9kM7Zoof/cKV/n7O4pK0miKQuHNpFe8VBLm1LDlv+qwav5XP7skxAA2Q+lpf4f3OxSsx3o0n9H8+bamBeUhTF0bbVhASNZHTBrdH5KSMTiixbCLVkgbmxsazJLeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lUmH60PG; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-5edfcba97e3so55809187b3.2;
        Wed, 24 Jan 2024 04:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706100307; x=1706705107; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TZXm+kuPZ4nvGmxpZjlQE8EIcmBZdeT0tswbj5rQmKk=;
        b=lUmH60PG+lTytt1bs+Dgq/gLt1mGApiq63Iv2zYphUTeUIztS2n3ECaOSodn0g11Oj
         0g/e12sTCuSNhiz7VGIN+BAdxLq0US4BAONucqIyLNIxRKCpEnH+cTv93KTBPvT7UofC
         k9Okm2ntbRXSjGru42SJwJdL6nyCXMNZfM5u+0fubfMTHqx/GhV1K3V/vsF0KcECq3oT
         rkETCEy9SF0Un9ILy7XSEoIKMCa+WxXIpsfz+/qY1aFA+9D0ho8YcSPf7DGA5wroM0wx
         hSujFhoEBDYVG+5FJ7chgRCxW1apYXExI2ppNMFo6cynYo6XKhnlyY1JVnn1F9iQ1gqw
         XLxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706100307; x=1706705107;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TZXm+kuPZ4nvGmxpZjlQE8EIcmBZdeT0tswbj5rQmKk=;
        b=i1dR2ypffQhuxHHjK4Fbxi/bQC0Urj9uirdKpjk0zBUooqGGmho5qtTX+ezYayOJET
         qDDLSF4JjWaS+troiFwYf0vym4HONYnE2WAFotXzONGfgs5BY2i0KZK+CfYVXEE9hDaH
         WjPZwU4i1qmoIsnqkXE3wD8op57sKpsr0nK10dNiuD8lxlkBVTZRaZ1ULbibAtRa+44n
         p61v01J8ihBaxl4fIvhdByDEyHYX6/N3o/A5pRSLMobtIFCZkWnyCRzy/HwwcHDKRuR6
         68VuK3VSFBz8N/HfWI0naADZij3XPE604AevnccbMYuLmHRHuXMBuZftftPxwatE4Rir
         Jh9w==
X-Gm-Message-State: AOJu0YzmNg+lUHY4hxzL22tyRzUo+8HF2jqGQcVWztxsyNj0JoQ9PMtg
	drJ7PzrEdNiSwfuga/W9T754Bx1Mh2uZi99U/Htps2H9mkqwAmswDI8IA4OuXIMSOBu3GcDEXlO
	QwUe2W61CBMV0pZtcjoHmDr5K+TpTVQ+2TOwh/sMLha4=
X-Google-Smtp-Source: AGHT+IGhg2BSC76jnAi74QGv0SbZtJZCUiJjbfeZOPD5ypEKfiEUJ0ZOdlvGhrFpnODlmLZfQJtgvgOBQT8gRfiznek=
X-Received: by 2002:a81:7c85:0:b0:5ff:67f5:f3 with SMTP id x127-20020a817c85000000b005ff67f500f3mr708565ywc.38.1706100307452;
 Wed, 24 Jan 2024 04:45:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240121111730.262429-1-foxywang@tencent.com> <f898e36f-ba02-4c52-a3be-06caac13323e@linux.ibm.com>
In-Reply-To: <f898e36f-ba02-4c52-a3be-06caac13323e@linux.ibm.com>
From: Yi Wang <up2wing@gmail.com>
Date: Wed, 24 Jan 2024 20:44:56 +0800
Message-ID: <CAN35MuQvQ7mbNCR=udA2xCu9wZ+qjSEM6eZ+6giJ8BBATsA-Ew@mail.gmail.com>
Subject: Re: [v2 0/4] KVM: irqchip: synchronize srcu only if needed
To: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	wanpengli@tencent.com, foxywang@tencent.com, oliver.upton@linux.dev, 
	maz@kernel.org, anup@brainfault.org, atishp@atishpatra.org, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 24, 2024 at 8:14=E2=80=AFPM Christian Borntraeger
<borntraeger@linux.ibm.com> wrote:
>
> Am 21.01.24 um 12:17 schrieb Yi Wang:
> > From: Yi Wang <foxywang@tencent.com>
> >
> > We found that it may cost more than 20 milliseconds very accidentally
> > to enable cap of KVM_CAP_SPLIT_IRQCHIP on a host which has many vms
> > already.
> >
> > The reason is that when vmm(qemu/CloudHypervisor) invokes
> > KVM_CAP_SPLIT_IRQCHIP kvm will call synchronize_srcu_expedited() and
> > might_sleep and kworker of srcu may cost some delay during this period.
> > One way makes sence is setup empty irq routing when creating vm and
> > so that x86/s390 don't need to setup empty/dummy irq routing.
> >
> > Note: I have no s390 machine so the s390 patch has not been tested.
>
> I just did a quick sniff and it still seems to work. No performance check=
 etc.

Thanks very much, Christian!

---
Best wishes
Yi Wang

