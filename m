Return-Path: <kvm+bounces-51701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D99FAFBC41
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 22:04:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6DF4F7A5794
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 20:02:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14DCF219A9E;
	Mon,  7 Jul 2025 20:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zwCj8yCc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22C92E370C
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 20:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751918598; cv=none; b=AESchYS7rlIDU+XjxB5b/vQEzYJPl15yX5zPDrbbHWNXjPBN/uQjEF5F0lghy1pt50LITofQn7Q+3pSxSp8luYq2Nj76VS7yUzHG0LLP3taDmZenmIy5YYMWGo5O9RSWPxZquMtwkS9lBfv8wsZ77O/X3MxmsdeZ//w5esggmqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751918598; c=relaxed/simple;
	bh=2cIHTAmhbNRlGmzgDKwCtAvt8CD9ydDa5HE1bihKYY4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iGGNNu+6QzVA5p3PcHJFzNMVfit6GWPy9S52k4I/j0WIuMctNItgKwy/Izd+7DhnD8TwjFJnp2Fgnn7SWWzx6ntR9zjOXsviCWyK/lrH/wNGG6k7+yZFikyrl5Kfb8uDl2Q41JgDCkFsyFWvZ8SQ6RxdAt49mlPL0fDVmlDL3ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zwCj8yCc; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-315b60c19d4so2876459a91.0
        for <kvm@vger.kernel.org>; Mon, 07 Jul 2025 13:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751918596; x=1752523396; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f9m8kL9zJyr1SiWshCzmMkh3jOhLBWM1enV3zix4EH8=;
        b=zwCj8yCchhSsj1C2K+siZjfyYhbGSg4ZtEQL/p+kX9TTIje+VIXQLbLXYkymhfZFxF
         2akWFQBrdFwRs5ZHcKypGJ36Qji4GT1latNHPCjyX6SUmWHqf1RAj5qn83ji1kZ/aqn5
         6WG5Rud0rO9ADKVjM2XDPOsOadcsww5lQquFUeuAv6Af6OxTUHF+RWgzDNU5oY+ZTopI
         U9NVd1+pqr8n6JKhcVR6pizCAUcOn2OvPzSQrdzzc4z+A5p3jkSrymS5hjA4HSze+XJa
         HiOv8+bb7cr2b+Ie4XDsB93TNIpci0ane9rIX/AXeZIGFCp0u8bmTkpvmbO0m/9hQMXS
         FXAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751918596; x=1752523396;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=f9m8kL9zJyr1SiWshCzmMkh3jOhLBWM1enV3zix4EH8=;
        b=K95B/WgohTh+s7C31mbiTlGuUTgA7oy+nEaxvcoRS6EDlDZUoLqHV0SBjjxR1q+wFf
         9OwMDRKWSVKecLJt67gMWfEvMpZAqDySiJqObAWhV06WPvnFSIFweqliwQMKbuq7iUd2
         mw9UeRe3s/gagVsVUq1Ola6z/YtGH6xTIYWKE4WQcZfr2+f7U9Lx6JKYfEY4DAwSSjga
         7/zt84N0HFv4FYwWqJW5BLfNpa2sdDxzaWrctjxco3zCs/+fuW80wQbCPv5oaPyFMF+s
         NDTAGwpuSnGOOQnpTCtDPNjKQJDCxHyWECwIZPug3Ea9fePdqDPe2MzGPI/0/pWMIewM
         on6g==
X-Forwarded-Encrypted: i=1; AJvYcCWJ7JWlPkX2jJU8yqoi9DN4kfdPO7d8egBGU3cVN5a0FDeZE68nRHIpcYEe+h3YcSJqv3w=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZdoN05nPOZr3s4Vz0slkKWWGGl/PNr9xfKg/5o3Q5ydxtAqaa
	5ejhoJsfK5T9IRmfvdq6TNtGbaBrKzO2q7FAUeuuB+m6nBcheeXmp/8rWy0GX1Nj95SvFiejSFt
	VeV1N7g==
X-Google-Smtp-Source: AGHT+IEOE22l1/AQskq/2IzmrxwVQiz1bT6C2edqUZUbehAs5hUamrBIaw+wv6+t/a48QuFUK94WyklPDEg=
X-Received: from pjk16.prod.google.com ([2002:a17:90b:5590:b0:313:d95c:49db])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d88c:b0:311:c939:c851
 with SMTP id 98e67ed59e1d1-31aac43865fmr20009835a91.4.1751918596108; Mon, 07
 Jul 2025 13:03:16 -0700 (PDT)
Date: Mon, 7 Jul 2025 13:03:14 -0700
In-Reply-To: <aGwgq2cz_xcYCf4o@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250630133025.4189544-1-alexandre.chartre@oracle.com>
 <aGO3vOfHUfjgvBQ9@intel.com> <c6a79077-024f-4d2f-897c-118ac8bb9b58@intel.com>
 <1ecfac9a-29c0-4612-b4d2-fd6f0e70de9d@oracle.com> <e19644ed-3e32-42f7-8d46-70f744ffe33b@intel.com>
 <aGQ-EGmkVkHOZcnn@char.us.oracle.com> <aGwgq2cz_xcYCf4o@redhat.com>
Message-ID: <aGwoAo02SWIBx7QR@google.com>
Subject: Re: [PATCH] i386/cpu: ARCH_CAPABILITIES should not be advertised on AMD
From: Sean Christopherson <seanjc@google.com>
To: "Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?=" <berrange@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Alexandre Chartre <alexandre.chartre@oracle.com>, Zhao Liu <zhao1.liu@intel.com>, 
	qemu-devel@nongnu.org, pbonzini@redhat.com, qemu-stable@nongnu.org, 
	boris.ostrovsky@oracle.com, maciej.szmigiero@oracle.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 07, 2025, Daniel P. Berrang=C3=A9 wrote:
> On Tue, Jul 01, 2025 at 03:59:12PM -0400, Konrad Rzeszutek Wilk wrote:
> > ..snip..
> > > OK, back to the original question "what should the code do?"
> > >=20
> > > My answer is, it can behave with any of below option:
> > >=20
> > > - Be vendor agnostic and stick to x86 architecture. If CPUID enumerat=
es a
> > > feature, then the feature is available architecturally.
> >=20
> > Exactly. That is what we believe Windows does.
> >=20
> >=20
> > By this logic KVM is at fault for exposing this irregardless of the
> > platform (when using -cpu host). And Sean (the KVM maintainer) agrees i=
t is
> > a bug. But he does not want it in the kernel due to guest ABI and hence
> > the ask is to put this in QEMU.
>=20
> If QEMU unconditionally disables this on AMD, and a future AMD CPU
> does implement it, then QEMU is now broken because it won't be fully
> exposing valid features impl by the host CPU and supported by KVM.
>=20
> IOW, if we're going to have QEMU workaround the KVM mistake, then
> the code change needs to be more refined.
>=20
> QEMU needs to first check whether the host CPU implements
> ARCH_CAPABILITIES and conditionally disable it in the guest CPU
> based on that host CPU check. Of course that would re-expose the
> Windows guest bug, but that ceases to be KVM/QEMU's problem at
> that point, as we'd be following a genuine physical CPU impl.

+1

In a perfect world, we'd quirk this in KVM.  But to avoid a potentially bre=
aking
ABI change, KVM's quirky behavior would need to remain the default behavior=
, i.e.
wouldn't actually help because QEMU would still need to be updated to opt o=
ut of
the quirk.

That, and KVM's quirk system is per-VM, whereas KVM_GET_SUPPORTED_CPUID is =
a
/dev/kvm ioctl.

