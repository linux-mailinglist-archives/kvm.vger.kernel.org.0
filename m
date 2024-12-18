Return-Path: <kvm+bounces-34076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CB449F6DD3
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 20:11:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6EC77168A2E
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 19:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 626AB1FC0F1;
	Wed, 18 Dec 2024 19:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i6cbz8jy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114641FA828
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 19:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734549051; cv=none; b=ieGVimPqtACBE6wfcFGmGy7BuSCdK9g5JUYi2oW6k3DQEoG1UG1a5inP5/Yr5aqVAl0acOFjnPjXl5iZvPBWpoqM6U1Lj+yDAAft7PVGHj1J2iz1p9hsapO3rF9g7m7ofDEXJjz1BU3pVKNDg8PPSaLf6OOBlcST2fMi9TsyxtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734549051; c=relaxed/simple;
	bh=jMj1OzrDjIrxeMoYOsAPw/b7S6pBg2XX6eTDS2vTCUk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VXHUlA/IpSPxGv73BZqZmI+jTVw5umdI/Ej8lF82dfu7t60vTmM+hIParYKWa/8kCK+dxm8O2L8YuTNP2QGir//K247+E8mlWUYiMuF8Z8w1NvY08J4tNECP0N4+LoTd+30KgpdeX+LY8jNRtcGws9iiO74vanirDNPtcF9zFag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i6cbz8jy; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-725d8bdc634so27071b3a.3
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 11:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734549049; x=1735153849; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YClUdPoywXVSqRLvOMBrpQD/YaQSG0s79CHQrCDEw+U=;
        b=i6cbz8jyMqb2VdeZyEovdZzi5pM+Rs5D/WSs9i3tQmh6UMfUTPdTgNtV4e4UARhmWk
         9cEtf4hNwByGUaUzv2CCXvcn3gORXmn8bVVJ+1NmskffzmbrFnFLHZRyKCyms+2XckbV
         APnwB1Rda19/wgFQ/G6NuDQY8+gav4ruFaTyrFa1UyPip1WfyaC53ZRxP2lS8GZBLYiK
         aCkgAq2t4tIpG2FwbIQferNWkQudyd/NFp+rBwNb/QSLu2trX5OlM1k9KlY+oIKj/HUz
         uOAdBAqDCfZsP9gRFWW0OEi+GmWsBZH56XOTOnT1tkHkfLmRhzej/C9GxsTIMKF5fG9/
         C99g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734549049; x=1735153849;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YClUdPoywXVSqRLvOMBrpQD/YaQSG0s79CHQrCDEw+U=;
        b=Tg2N5fK/SrvIhEcAf3Z38hlYQWb2wPboiKdpaG65WSZ1oGY91eYGK48ZgYTd696Yly
         qTg1/5OOa4WBVeB6Cd/IES+w6BwElkcou0u3dJkbvYJ0lvGEE3xlBC4YfEOOw8Xs9bFX
         GHtpbC3AM1KSp6Zm7N9VkjG50eilG/b/TwAyq+prPgrcBY0ytK++OpzQjRV/2+Jzk54P
         16+bPrM6E/bNh9iTxLhZCUdaD1D9++w3TaLUhZCNyllhm9TwLCB7bWt1V1rba4/ioOWe
         KMqYms5cBXvvie4/gT+U8fA6rWFuldRgAXdQ5tbcJ6g3xKvlEO5YbTSh6xrmRiT7ioIG
         QEmg==
X-Forwarded-Encrypted: i=1; AJvYcCVQe4JwTXWLLTm9BvDdsq+5lZB15URj/LlFDUR21NIItsbx5/mXO+BRC+APF7yQyPHmsHE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKap89XndgatmNS8eZWb8ocr3wRVbwNzadBzpU9R0av8AvmEk/
	sNm9leHbayoBTAH3nCAWB2DHfMqUGvBuiUUq35yGAjb8c6cUq13NfkjpEgwlbD0JbifBBXntlUd
	1Pg==
X-Google-Smtp-Source: AGHT+IH1B/bbkp0G6ABRo9fqVZ6adP+tKt8f/j21FuyOVEbiorHToFEL5buQ5JKv3Q2UPzxlMkYtWT3lSj0=
X-Received: from pgda26.prod.google.com ([2002:a63:7f1a:0:b0:7fd:561e:62dd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:e68f:b0:1e1:aa24:2e56
 with SMTP id adf61e73a8af0-1e5c76afd3emr528641637.30.1734549049187; Wed, 18
 Dec 2024 11:10:49 -0800 (PST)
Date: Wed, 18 Dec 2024 11:10:47 -0800
In-Reply-To: <57d43fae-ab5e-4686-9fed-82cd3c0e0a3c@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1734392473.git.ashish.kalra@amd.com> <CAAH4kHa2msL_gvk12h_qv9h2M43hVKQQaaYeEXV14=R3VtqsPg@mail.gmail.com>
 <cc27bfe2-de7c-4038-86e3-58da65f84e50@amd.com> <Z2HvJESqpc7Gd-dG@google.com> <57d43fae-ab5e-4686-9fed-82cd3c0e0a3c@amd.com>
Message-ID: <Z2MeN9z69ul3oGiN@google.com>
Subject: Re: [PATCH v2 0/9] Move initializing SEV/SNP functionality to KVM
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <ashish.kalra@amd.com>
Cc: Dionna Amalie Glaze <dionnaglaze@google.com>, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, thomas.lendacky@amd.com, john.allen@amd.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, michael.roth@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 17, 2024, Ashish Kalra wrote:
> On 12/17/2024 3:37 PM, Sean Christopherson wrote:
> > On Tue, Dec 17, 2024, Ashish Kalra wrote:
> >> On 12/17/2024 10:00 AM, Dionna Amalie Glaze wrote:
> >>> On Mon, Dec 16, 2024 at 3:57=E2=80=AFPM Ashish Kalra <Ashish.Kalra@am=
d.com> wrote:
> >>>>
> >>>> From: Ashish Kalra <ashish.kalra@amd.com>
> >>>
> >>>> The on-demand SEV initialization support requires a fix in QEMU to
> >>>> remove check for SEV initialization to be done prior to launching
> >>>> SEV/SEV-ES VMs.
> >>>> NOTE: With the above fix for QEMU, older QEMU versions will be broke=
n
> >>>> with respect to launching SEV/SEV-ES VMs with the newer kernel/KVM a=
s
> >>>> older QEMU versions require SEV initialization to be done before
> >>>> launching SEV/SEV-ES VMs.
> >>>>
> >>>
> >>> I don't think this is okay. I think you need to introduce a KVM
> >>> capability to switch over to the new way of initializing SEV VMs and
> >>> deprecate the old way so it doesn't need to be supported for any new
> >>> additions to the interface.
> >>>
> >>
> >> But that means KVM will need to support both mechanisms of doing SEV
> >> initialization - during KVM module load time and the deferred/lazy
> >> (on-demand) SEV INIT during VM launch.
> >=20
> > What's the QEMU change?  Dionna is right, we can't break userspace, but=
 maybe
> > there's an alternative to supporting both models.
>=20
> Here is the QEMU fix : (makes a SEV PLATFORM STATUS firmware call via PSP
> driver ioctl to check if SEV is in INIT state)
> =20
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 1a4eb1ada6..4fa8665395 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -1503,15 +1503,6 @@ static int sev_common_kvm_init(ConfidentialGuestSu=
pport *cgs, Error **errp)
>          }
>      }
>=20
> -    if (sev_es_enabled() && !sev_snp_enabled()) {
> -        if (!(status.flags & SEV_STATUS_FLAGS_CONFIG_ES)) {
> -            error_setg(errp, "%s: guest policy requires SEV-ES, but "
> -                         "host SEV-ES support unavailable",
> -                         __func__);
> -            return -1;
> -        }
> -    }

Aside from breaking userspace, removing a sanity check is not a "fix".

Can't we simply have the kernel do __sev_platform_init_locked() on-demand f=
or
SEV_PLATFORM_STATUS?  The goal with lazy initialization is defer initializa=
tion
until it's necessary so that userspace can do firmware updates.  And it's q=
uite
clearly necessary in this case, so...

