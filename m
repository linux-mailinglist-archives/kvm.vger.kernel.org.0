Return-Path: <kvm+bounces-72945-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KHxwGNXcqWm4GgEAu9opvQ
	(envelope-from <kvm+bounces-72945-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 20:43:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CB6C4217AEA
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 20:43:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EC4A8302E0C1
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 19:42:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25EFB3E0C66;
	Thu,  5 Mar 2026 19:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J7y/Lq1I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12EE37AA95
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 19:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772739768; cv=pass; b=TcFr+XgTL46zdr6owdqVkQFnf9GlbDE0zFC4ontMzloZqdlsOdai+7oknaLWQqiFXPxDFJDUrcsuwU+dSi0FJVyiRk+fIuKgfVDwO71jWY3z0Ypjj9q+F/a71XVewwohGwq5J7kLhwhyWyq0U+IuyvGiJOyWgB2j32n5/vdSKp4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772739768; c=relaxed/simple;
	bh=BFL2J/Icfk5z6sblaLG86L1o2xcdsDyOfso7V9JzEr4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UKx82dffhCFZ4Ja06fNkdvP8souYa7VG9RTvKfFJovKWYVNLU7F3sMLObTC5xOMh5ZqBRGMVLMfRZFG4dRwASaest//tQrA4p51Nxayy3CMx035EhbCw7P8f29dBOqFlOa+P5O85s+8b/2SsTXNriggA4t/5ioyC168Gek5EOlw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J7y/Lq1I; arc=pass smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5a12fbbd9d2so1231090e87.3
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 11:42:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772739765; cv=none;
        d=google.com; s=arc-20240605;
        b=ekWjk9NeUPg0zO4Nb/GQlvpJq1Kqe6fmSjdLP9dacqdbKgoeRdiyu0mvDjzIfJ3dx8
         pucCHktj3vnJErKZ6JvsUTJGopws5+K9DKceOvlrci0Tm9DGIBp6t5Hna+UH+Mw1WIUd
         GhQgBgGGbfu4B2/cYR6DmLMMjU6hueeLAY5MmxiOZt4KUwGDEHyepCjlrgIgjGMSfpgj
         sZyJU2JAob2D7Cg6V+T2eHB8N9uZtDqh/eahaPQryDt8Xmw7maeW4MUXkXRSBt2b+z3N
         JKj5SIWHdMmvECsS9S9VlYZgt95XmXsSsUpf1CsOWXNPhre0cBhJGOx3szuDebz+UmtL
         wN5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BFL2J/Icfk5z6sblaLG86L1o2xcdsDyOfso7V9JzEr4=;
        fh=qz7YQOjGzdSq4VXaoKF6PpjQFKYLH/JwfmstHwb1GRg=;
        b=Ogs7Z/E7WW1GiQdazk3hJ4tgONXgRSYBeUNjXfLEmIMzL78OWbK70QyReJuNOLPJUV
         h5gLPRoNzUAuH6kCHimoHZUQLh2GNYKWYk0tolIwvX0XL3k3SP3Kp+xAH8YeYn7xkDBF
         QuM5oLznkWqkawze9XVq8JPYEuZ/b1HEu8ixkTFS6UxNAJ6LmUOhtBuHizDH5Z8FiHd6
         7rPvvm2ipgKMM3JNQ+ya4FLOG7yyrq0C0n6n5+73JONtBcsqmx5u+HiaCBbdsa/jbKPl
         uz6D3We59ksvN52tBpvEh9nShKuIwVlgaJvbfH5ik2PAesOfE42eTws7vVomIl9YqBHK
         0UTQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772739765; x=1773344565; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BFL2J/Icfk5z6sblaLG86L1o2xcdsDyOfso7V9JzEr4=;
        b=J7y/Lq1IxLU+Dz/yjyvb/dPGPWnJbQob8Q2QuxVwDq6DrAe8KOLBbCw/RJH28ZsIVm
         eLzXtNQcCvkAEH7bpRZF/pHYbvI0NuBd2MgR2c/Tmts2IWoPoUSUjur+tO8lJhe/JPu+
         wNIM01PysIEn8QP4iLyrMtWwOGswInpVK2slbAeLvCixJcS5Jcfm/YXy9W33WHWUlNiP
         +p8C9bhO6HnUerwsZkWaI2Fa4KQlt131xsUL2xLViCepC/XpkT2ZzP5F5tcH1trI7ll+
         91MgpSRqDkP3dwwPHNc+cwgxgozBIsjP9eh+BAsVQOwjVYYakt93rQClSztQIsXMrt+/
         C4Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772739765; x=1773344565;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BFL2J/Icfk5z6sblaLG86L1o2xcdsDyOfso7V9JzEr4=;
        b=dj6jcrPUAkF91s1UVBTRAkIhBMEfcWzZ+pxyEl5KOoSnfITmlo2zo8c4gJNO7a8eG1
         veLXjapz4DXsJa9k7ZIcmvFnwKP69zHFXTNF50C23wGVHRmHxKiqCZj4kNYMjoj8kW1q
         Nd43LnIasXa+uQTbOxLKe6B00FRbb/14zStw+lDTHQ7JM4fHQ/bD+xFLGofkIAt6x1Ab
         9hcIe2OfXrRMtvG/1szZoH67UYZXR7KUIFN0BepP5uS5GTUPg3ICodoH6TVqskMYECnb
         El8xB5VjV/FH2NonnCbjDloc34Kf9F5KMEF+oayCGD80seCGg8939vhqgXc99i23L/Cp
         7r1A==
X-Forwarded-Encrypted: i=1; AJvYcCXLLoHkTmap39gCZSa4sm8/atgJuHDFJwz2EbsYBi4YEjepUrH6IfIWhkHfajJcPzVKn78=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvQKGOzJXrnf1+xME+erSTt3p+5vg8B5M5fUEhAaj10o/f5Nvx
	eU4VPpvwzYFTNGL5BcJlSKshce+sqZT2f9BijtUxT5W3dsQKzTjy7bqKj0u2bJfhaBK/yY11T1l
	HL+yMy7wd6+BY6PK2EdJkYxwsLT5/JScPYf3NHTey
X-Gm-Gg: ATEYQzxD4LcyjUlX8d0H+AeICNwMExJ7eLqGlF64rX8OWo3WQDAlQCxPeVA1jjkaRdt
	7neZhyUcmjS9JXSmpHCr2ZP27fRqtwQYjkyO+aVc6BaHwqKzEqY09djmS46N2vm4cNS5AVDxpe5
	NHxHlGfDD0NUF4DP6xOhM7oFmh/IW5xipztN6neQ6euu4A0N+kijUOoIcVbULVeQ8bwkklzlKlB
	LZjARJKBh1+/TlIC19q7PrCEDRLtbDyI/UFtKnWXWy39R1q6iRlDP0WGQ+xU1bTwa3u7a+Mxycl
	Ju/MXvQU
X-Received: by 2002:a05:651c:1587:b0:38a:6f5:4b54 with SMTP id
 38308e7fff4ca-38a3c815300mr2046311fa.4.1772739764639; Thu, 05 Mar 2026
 11:42:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129212510.967611-3-dmatlack@google.com> <20260225224651.GA3711085@bhelgaas>
 <aZ-TrC8P0tLYhxXO@google.com> <20260227093233.45891424@shazbot.org>
 <CALzav=dxthSXYo13rOjY710uNbu=6UjzD-OJKm-Xt=wR7oc0mg@mail.gmail.com>
 <20260227112501.465e2a86@shazbot.org> <20260301192924.GR5933@nvidia.com>
In-Reply-To: <20260301192924.GR5933@nvidia.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 5 Mar 2026 11:42:16 -0800
X-Gm-Features: AaiRm52QizUmbxb_ZZJRNIFYAvXcIrsVMR2oGVyxQJsUboHWoi4G3a03BNBWEM8
Message-ID: <CALzav=deyfyzGXzSGmEbjvLr8Nn9Rpeh9w9JVk0vmb9FcURYPw@mail.gmail.com>
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <helgaas@kernel.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, 
	Alistair Popple <apopple@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, 
	kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CB6C4217AEA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72945-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[shazbot.org,kernel.org,nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,linux.microsoft.com,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	RCPT_COUNT_TWELVE(0.00)[44];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,nvidia.com:email]
X-Rspamd-Action: no action

On Sun, Mar 1, 2026 at 11:29=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Fri, Feb 27, 2026 at 11:25:01AM -0700, Alex Williamson wrote:
>
> > There's obviously a knee jerk reaction that moving PF drivers into
> > userspace is a means to circumvent the GPL that was evident at LPC,
> > even if the real reason is "in-kernel is hard".
>
> Given we already have GPL licensed kernel drivers for the PFs it
> doesn't seem like a reasonable worry to me to fret about some cut down
> version of a kernel driver running in userspace.
>
> Further, let's be honest here, the people most interested in all of
> this are doing it to support their proprietary VMMs. I'm pushing that
> we must have at least a reference implementation in qemu before the
> kernel parts should be merged..

Yes, this is why we built VFIO selftests with the driver framework
[1]. We wanted to ensure Live Update support could be well tested
upstream independent of VMM adoption and without requiring complex
orchestration.

Google is also working on upstreaming Live Update support into Cloud
Hypervisor and the kernel pieces land.

[1] https://lore.kernel.org/kvm/20250523233018.1702151-1-dmatlack@google.co=
m/

