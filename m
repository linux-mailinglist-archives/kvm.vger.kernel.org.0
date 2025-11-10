Return-Path: <kvm+bounces-62548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B6D04C4883E
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 19:19:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B0343B3B69
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:19:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6A8432AAA6;
	Mon, 10 Nov 2025 18:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZZKa3gmn";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="KNQRksje"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1384F313265
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 18:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762798763; cv=none; b=AS5SW3ilkQDXE5iazgqaEAGq4ogaC3zhBFfVGI1LOZIw7dKb2XtK7eSavysLwE+DtI0ifiZCWN8MitSjktTK7WRKJjXNLg3w0BYZMR91M+BhTHPaF7yhL9VXKT/04JHKHg9oIRvvvKBKUU5dNj7xzOnBOCYK8tj8dbbt3i0bCrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762798763; c=relaxed/simple;
	bh=1QZl5r7sIr5sRRuRRJHMFTSX73wHJTLDlyXpkcHSecY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oCH9Ltm7sB07cC4JROEN998s2tNSOV0NE6bxjecHEjEQ3BrhW3HdUiogyLEywDG4pSSKFA8/g2Z849l52ly4B/ZRJiRskCKdifYw8lpkdg8wgwAp1Cg+gw0xUbkQZby8mwKwfVu61IX1VntdfFQX/D9h+FEP+CcBW6fHoA+wSuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZZKa3gmn; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=KNQRksje; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762798760;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LhvLst+P0pIwwi9pGBO2xXY1tmD2l0kTSuuyImpVM8c=;
	b=ZZKa3gmn5HmzhDrp9NL2BQWe3/Yk+hHDAZKvpLGQ5KkvQifFyGrHKIstghbTO/2VTPKt8G
	ygn5tHLklouTP3Oe8+PqT7/arEBrNXhUUenTrdANhYgI+HhuPjXAseVrhTz++rUUvfNDns
	Gc9KX9nS8+IKvtJRU+J0smHe3j3aoGQ=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149-PgkynIJsPIqy1ttQhJ-7tQ-1; Mon, 10 Nov 2025 13:19:18 -0500
X-MC-Unique: PgkynIJsPIqy1ttQhJ-7tQ-1
X-Mimecast-MFC-AGG-ID: PgkynIJsPIqy1ttQhJ-7tQ_1762798758
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8b2619f07aeso635125185a.0
        for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 10:19:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762798758; x=1763403558; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LhvLst+P0pIwwi9pGBO2xXY1tmD2l0kTSuuyImpVM8c=;
        b=KNQRksjevAIiH6YwujA+jWfvLIShPEja2YEmM+hHr+G/va/eTyl1SRVghRamTfvMlq
         KWB0xJ82Fm6k3Tb09rbml1I7VCi4zUmfPz7/Tc1ZXuxiTsnEsyHloMuzfHE3NjiwzOdh
         p6i6F5Vp85moIShLDaaaRJEyV6h/5yTLxbNTKrdyoBwKli55U9rHBRvSLIQ4x1mCHNZ8
         Tq5fIe7Xrd6Ql6n0xtzCXIzJ52B3MEwE/ZLP0WbwA83QRRltJYvnh+qxPbT+zakOA5B2
         vE+AEhwWUY6fc2Sf7QHkPISAsN5eA8g+BWP3PCquSAemFAW+PZmzcTuAF/DlBnBCrWNh
         QUGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762798758; x=1763403558;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LhvLst+P0pIwwi9pGBO2xXY1tmD2l0kTSuuyImpVM8c=;
        b=XcT3rwPQn3yuDPUV1jUHXHmYSGw+PBAHCR6OIL5XD/LBHSnmymIpfoyVXPlqqX56g/
         HcOjqF+DAqt2KxU4qE+mn3QojMtX+NbWyr6+M88T2xmtPg6boy56CEGN6F+TYoB2qg+s
         d6NGvI+imoVq2a8PcheFdwEekgql233rSMmhdHQXWpBFLe3CYt3U5o+QRG5FXo7c71W4
         4zO8KXrBBDAs/sJM/GP9M4WUpUnmZUlOZxpnd6CxRIRJX/lucT1y6lIYrbIMwMPMnzbY
         aGF6+92E86M7J+ZyYramO1n6uO5e07v4R6rDNOi4l2vfWWFdNT32ZLk5RN/4VHDOkcZ4
         XtQw==
X-Forwarded-Encrypted: i=1; AJvYcCWyYgER2VMTLTzn9+B8WEdPrK9tNI8PzshkbPadF/h5hgQkbmgZhQ99XF0RNS/n/mv9TCU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1fKFb8fieWufNH99o1j5vzn/SkiDnIuZgMASzaxjjuqsVeOou
	8ByE80BZj41IvpPkifwDV5HbS8VpQYc11V1rf162voZf3+gu0sIFMp5/PBWEKPwaBjkmHFhHKM/
	m2KzwUbhS6kebzqG7+pLN3iFfboklAKY/EpWFK8z7L1v7k9hwehoSsQ==
X-Gm-Gg: ASbGnctx/0IVq0BiCJg7hEoUDDy6qPyN+9F2s2SGSz0Ob/xekJRYpV8sFR0NoiCNnDa
	jmslb2AK9v37wu8k8U3h42s2wMKUJZT/2Fuc/GsVELPt42GGDxXuuRgC8wrJWYk6RK6DSSCmw79
	o3XwuUc6j2lHziyfShiPr+wMDpiV2tVbzW7naqvj3vkXXJ7gCsmU+t83pvZFQETTgvw1FDUVK/W
	xeA6R5CI2VpNZBOmApKTJvoBgSzAol9O5Dx/Wa03QANrYscWNWsNZhRu+/wKcxXhDRiHIlc7dYb
	B7wlkOiIX1ixZZyPLkO+qXBXmPEpf8tQdsXMi7WbKD4lg0qdSxg5xi5ZlgBW1vKoLtMmySOAhzZ
	LIOKMa21AH+hXsBroEcJfAeLt93E+1aa1VtkxpEQ5bixVqw==
X-Received: by 2002:a05:620a:1790:b0:8a3:87ef:9245 with SMTP id af79cd13be357-8b257f76956mr1198804385a.85.1762798757999;
        Mon, 10 Nov 2025 10:19:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF+PJnuQIOmozkDYCSrliPkbbXo0Xy49cuqoebK2tXkzI9uYUruFfyTQDfTiP6bVgjiW7/jHQ==
X-Received: by 2002:a05:620a:1790:b0:8a3:87ef:9245 with SMTP id af79cd13be357-8b257f76956mr1198799985a.85.1762798757576;
        Mon, 10 Nov 2025 10:19:17 -0800 (PST)
Received: from ?IPv6:2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38? ([2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2355e776esm1037884585a.21.2025.11.10.10.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 10:19:17 -0800 (PST)
Message-ID: <36f35af3070673c6b0b899ab34724f05ece36fba.camel@redhat.com>
Subject: Re: [PATCH v2 0/3] Fix a lost async pagefault notification when the
 guest is using SMM
From: mlevitsk@redhat.com
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>, Paolo Bonzini
 <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
 linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>, "H. Peter
 Anvin" <hpa@zytor.com>, Dave Hansen <dave.hansen@linux.intel.com>
Date: Mon, 10 Nov 2025 13:19:11 -0500
In-Reply-To: <176278796977.917257.9553898354103958134.b4-ty@google.com>
References: <20251015033258.50974-1-mlevitsk@redhat.com>
	 <176278796977.917257.9553898354103958134.b4-ty@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-2.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2025-11-10 at 07:37 -0800, Sean Christopherson wrote:
> On Tue, 14 Oct 2025 23:32:55 -0400, Maxim Levitsky wrote:
> > Recently we debugged a customer case in which the guest VM was showing
> > tasks permanently stuck in the kvm_async_pf_task_wait_schedule.
> >=20
> > This was traced to the incorrect flushing of the async pagefault queue,
> > which was done during the real mode entry by the kvm_post_set_cr0.
> >=20
> > This code, the kvm_clear_async_pf_completion_queue does wait for all #A=
PF
> > tasks to complete but then it proceeds to wipe the 'done' queue without
> > notifying the guest.
> >=20
> > [...]
>=20
> Applied 2 and 3 to kvm-x86 misc.=C2=A0 The async #PF delivery path is als=
o used by
> the host-only version of async #PF (where KVM puts the vCPU into HLT inst=
ead of
> letting the kernel schedule() in I/O), and so it's entirely expected that=
 KVM
> will dequeue completed async #PFs when the PV version is disabled.

True, sorry for confusion.
Thanks,
	Best regards,
		Maxim Levitsky

>=20
> https://lore.kernel.org/all/aQ5BiLBWGKcMe-mM@google.com
>=20
> [1/3] KVM: x86: Warn if KVM tries to deliver an #APF completion when APF =
is not enabled
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [DROP]
> [2/3] KVM: x86: Fix a semi theoretical bug in kvm_arch_async_page_present=
_queued
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 https://github.com/kvm-x86/linux/commit/68=
c35f89d016
> [3/3] KVM: x86: Fix the interaction between SMM and the asynchronous page=
fault
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 https://github.com/kvm-x86/linux/commit/ab=
4e41eb9fab
>=20
> --
> https://github.com/kvm-x86/linux/tree/next
>=20


