Return-Path: <kvm+bounces-53566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 45D49B14043
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 18:27:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 791423B1CF7
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 16:27:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 275E42741DA;
	Mon, 28 Jul 2025 16:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F8ci9P5E"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20121A254E
	for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 16:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753720065; cv=none; b=hXUs27fn5z74ekSgptEI5O4N8/HGIbS8XX+Zzh6WN4JLGrOfBiQbYygu+zqWWYfTM0f5Nj5BRwbnEOanSpkIpme2XCiMVKifpS8WcV2A62JApdM7C0/ArSzAc8MKRnEWnO/7TetR2ivAAuhpUHMmloo37iKO5Lh+nsJmMQ9BnnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753720065; c=relaxed/simple;
	bh=Ya45jQPXHk2oP2X0G+LpFes59f3rujaPubzq7KF+/kc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sEkz/AaKXIDWWjgl8fiVrtUZZFgvHwASqNuH9liBauTrqGvi2OgLxwVfNqrn38vOsQm81X5HUqSK0IspB1o70JYCmyP0vkHeLL7Is2655y2nUmeKNYXkwvn2yL1LWXa45wT76hxqQ0UNxV30ltq0oAKenHBqd+QGdrKKCjwtZmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F8ci9P5E; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753720062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xArcZSjUcc0JM++Nvf69XtSLwcuglbrEMCVCa+W7/Rs=;
	b=F8ci9P5ElDQN3WPBGWxHZHIEiY4ZIQR5nJTZkNbk6E2gA+Hc//laiTTXk+VYMUNzZm1eCq
	tQhjUB5F3Fbqac6NqzVnnGGwynSTz0fibfM8DsFlE+eiz0ORX/detgsy/HYCnmC5vB0J2B
	eAJvsYgEys44OYWZTql793JBCAWZ1oo=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-7Z9q9Rt2N8atpG-AI591Jg-1; Mon, 28 Jul 2025 12:27:41 -0400
X-MC-Unique: 7Z9q9Rt2N8atpG-AI591Jg-1
X-Mimecast-MFC-AGG-ID: 7Z9q9Rt2N8atpG-AI591Jg_1753720061
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-86cab5d8ccaso78502039f.0
        for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 09:27:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753720061; x=1754324861;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xArcZSjUcc0JM++Nvf69XtSLwcuglbrEMCVCa+W7/Rs=;
        b=jSNlrSQBBgWNooDGmT1w/j+oc+/wr7o4kFzD48bJvx3OHKU6hL9WMMHajj2U1uBnVu
         F2HJZmZhCPV6aeZKCuduuZF4xYYnVz0IVZsgPi9x3Tm+xTm89MrqhJuxRTFm5vgDYsTg
         mTw2vFyK6Kso/gjxF7YdU7y0fXOEPYHiexR1FJIRVlmSxneD1jT6VjG6V1vFtLlQ7W3S
         HwTm4AXS4gifPtGHH7Ux1WKl+HnvJCQgsSmcYERM4AxqIYZoLvUOyb5C6cVjbg4XtmlH
         zr9gstuO31JXV+Hma+dgkD7ToNj/zFxXidsaH7COMPcLAgjQ/wBIB0OcWujCimwQrLN6
         WqqQ==
X-Forwarded-Encrypted: i=1; AJvYcCVi2qJWTPY8zvWIV45PpYEMoTSpyaK02rUkIYscaGtxBFMAgAoi8smyffapty04OY4Fwkg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7a3elDNA8gxCvsS8JBc7kjADPwC/ddLVE8sc0OT0P47q5fSew
	Nz5C4pULfz/KZ/hejZHVO+7JFC9tWMvCDUduONMeZO+6nXTSo6GwA6fs6qLySkczkb3aCqdJx+D
	W7n7rW4DnVwyWP6Wh3bcwdkTz4k86cmgW5W4tk6Jr4EDuzvTAcFbPOA==
X-Gm-Gg: ASbGncsbJKtGWY7QdtJ2UC2mPKX2R7qcmL7kMgjE0vlcFapMJqQpyN8VNlEh27J3ArG
	s88RmgnoayFQjyKXs8HqPTtG8z+NkcqFXUZ3PVMS4XkDG2p9gVzYkDVAGozWBIEafTlVUdvb3WI
	mCXXK7d05XtHYQ2BmQISkNN1Hm0lU/eRBS5eSE1P4mP82Jfs5gv37zToJKJDCmU1QedcLI8Vs6B
	KrYm3tc1LY/a9HPSJ+Eu3H1tyRYelaf/dvEMWdNqDO8Ph96tFRvZBLDl9fLhHS97Hkh7jYNE+zV
	EmfIaX+fYkxsol7SCIUkRKgADYPCnxy2tt1mPbEE5XU=
X-Received: by 2002:a05:6e02:1809:b0:3e2:c6a3:aa75 with SMTP id e9e14a558f8ab-3e3c5378324mr58629325ab.6.1753720060574;
        Mon, 28 Jul 2025 09:27:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHpe+ugGAmXF2USuwRkLE9+KI7pOiQNBqc2vtbrZJCicQ1Wplt9KVvxUosu4y3uaaNZ0wXR2Q==
X-Received: by 2002:a05:6e02:1809:b0:3e2:c6a3:aa75 with SMTP id e9e14a558f8ab-3e3c5378324mr58628985ab.6.1753720060073;
        Mon, 28 Jul 2025 09:27:40 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-508c9223199sm1944955173.51.2025.07.28.09.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 09:27:39 -0700 (PDT)
Date: Mon, 28 Jul 2025 10:27:37 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: David Matlack <dmatlack@google.com>
Cc: Aaron Lewis <aaronlewis@google.com>, Adhemerval Zanella
 <adhemerval.zanella@linaro.org>, Adithya Jayachandran
 <ajayachandra@nvidia.com>, Andrew Jones <ajones@ventanamicro.com>, Ard
 Biesheuvel <ardb@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>,
 Bibo Mao <maobibo@loongson.cn>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 dmaengine@vger.kernel.org, Huacai Chen <chenhuacai@kernel.org>, James
 Houghton <jthoughton@google.com>, Jason Gunthorpe <jgg@nvidia.com>, Joel
 Granados <joel.granados@kernel.org>, Josh Hilke <jrhilke@google.com>, Kevin
 Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, "Mike Rapoport (Microsoft)"
 <rppt@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, "Pratik R. Sampat" <prsampat@amd.com>, Saeed
 Mahameed <saeedm@nvidia.com>, Sean Christopherson <seanjc@google.com>,
 Shuah Khan <shuah@kernel.org>, Vinicius Costa Gomes
 <vinicius.gomes@intel.com>, Vipin Sharma <vipinsh@google.com>, Wei Yang
 <richard.weiyang@gmail.com>, "Yury Norov [NVIDIA]" <yury.norov@gmail.com>
Subject: Re: [PATCH 00/33] vfio: Introduce selftests for VFIO
Message-ID: <20250728102737.5b51e9da.alex.williamson@redhat.com>
In-Reply-To: <CALzav=dVYqS8oQNbygVjgA69EQMBBP4CyzydyUoAjnN2mb_yUQ@mail.gmail.com>
References: <20250620232031.2705638-1-dmatlack@google.com>
	<CALzav=dVYqS8oQNbygVjgA69EQMBBP4CyzydyUoAjnN2mb_yUQ@mail.gmail.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 25 Jul 2025 09:47:48 -0700
David Matlack <dmatlack@google.com> wrote:

> On Fri, Jun 20, 2025 at 4:21=E2=80=AFPM David Matlack <dmatlack@google.co=
m> wrote:
> >
> > This series introduces VFIO selftests, located in
> > tools/testing/selftests/vfio/. =20
>=20
> Hi Alex,
>=20
> I wanted to discuss how you would like to proceed with this series.
>=20
> The series is quite large, so one thing I was wondering is if you
> think it should be split up into separate series to make it easier to
> review and merge. Something like this:
>=20
>  - Patches 01-08 + 30 (VFIO selftests library, some basic tests, and run =
script)
>  - Patches 09-22 (driver framework)
>  - Patches 23-28 (iommufd support)
>  - Patches 31-33 (integration with KVM selftests)
>=20
> I also was curious about your thoughts on maintenance of VFIO
> selftests, since I don't think we discussed that in the RFC. I am
> happy to help maintain VFIO selftests in whatever way makes the most
> sense. For now I added tools/testing/selftests/vfio under the
> top-level VFIO section in MAINTAINERS (so you would be the maintainer)
> and then also added a separate section for VFIO selftests with myself
> as a Reviewer (see PATCH 01). Reviewer felt like a better choice than
> Maintainer for myself since I am new to VFIO upstream (I've primarily
> worked on KVM in the past).

Hi David,

There's a lot of potential here and I'd like to see it proceed.  I've
got various unit tests that we could incorporate over time and
obviously picking up Aaron's latency would be useful as well.

Something that we should continue to try to improve is the automation.
These tests are often targeting a specific feature, so matching a
device to a unit test becomes a barrier to automated runs.  I wonder if
we might be able to reach a point where the test runner can select
appropriate devices from a pool of devices specified via environment
variables.

An incremental approach like you're suggesting is usually the best
course.  Implement the framework and something basic, then build on it.
30+ patches is a bit much to chew on initially.

Your recommendation for MAINTAINERS sounds good to me.  I'm not too
familiar with the selftests, so I'll clearly be looking for your input
once we've established the initial code.  Thanks,

Alex


