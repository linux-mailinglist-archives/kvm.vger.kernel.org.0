Return-Path: <kvm+bounces-60241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C121CBE5DBE
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 02:10:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A364E1A671E8
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 00:10:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AEC9136E37;
	Fri, 17 Oct 2025 00:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GalH2AOb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5661F95C
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 00:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760659808; cv=none; b=hdnw9lXQQfyw1p7n80SZ3zsSWrFufArlMV3YyyrbE6sv8XTbpx/fWRtYnwxs845C9X/APSQ/HZO8luPZ4C0abUtAOMNctCJ7S/A4sn7R/BNyE1lYy2fRQJBga2zTX8lvQxNMxZOakEa5Y6zfu/r8qRb4t7XhaD5Awt1ZM7I4kBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760659808; c=relaxed/simple;
	bh=E1AC9iyyw2ScMA/Vd6Wp/4knwNlCQVVOev8xoskItFw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zxm6Ntm3H26fgK9TM/NyKZhuALfNx9D1oujrZI2KGEMKuPkEf8nAPP6yN0zTshfPigShoTKmC8zvIoSL+NguOv2/Uztj3PjanE0ELBAz/fCw4HyAdq+Hc9LmlYbbqd7q0jcx4KIofBVGi21nWV8E25wQ/Wa+iwpDrEYroK3cp0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GalH2AOb; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-26816246a0aso1763295ad.2
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760659806; x=1761264606; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E1AC9iyyw2ScMA/Vd6Wp/4knwNlCQVVOev8xoskItFw=;
        b=GalH2AOb9ugD/EnLU/YjEXztTOrnDPpnpfcBJcj0d/MNGzyaVeWapYmBzJ5dVgVdUO
         GrBkGeCFw55ow5Lnm/9H1x5k0uwtclYMP3oKGykA0AZ45a+pylS5YIf1v1y1hl2/4zTo
         UfLjnpNxUCyyefC3cLb6UtyJ0cII5gosaBzkGh9BkOxfuJLDemvsD1yrvfiIGEVLUxZx
         /BdAfDzvpK+s0adOXt/WqIGe4PtXqjFiPB5znTGtB8LdYVEFiIKGpp2Ik0tIyno3Bhu/
         B/xTMdudwoJ22Z5o1lDMt4ucEnTCZqCwaSzOjTMrTiMoKSgU0f8eBmRnpC+Ho0opLJNo
         bWKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760659806; x=1761264606;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E1AC9iyyw2ScMA/Vd6Wp/4knwNlCQVVOev8xoskItFw=;
        b=d5w/+FB6HnNx0in0rCmlQvuURguTfjfLNVr4spxcDybSzmYPHPz3dZwn4vf+TpWMWZ
         sfXecXsOeQk3abLWJZF94cjbSowwhRmv5kWkxosHl1aBPwjc0mQlqDTGMHKaEQLFuAtR
         m0orh3jYWP3P4Glf86mms4uaeqnJ6NmhAVScr1tjuQXDmtSXAZtbm4aXr/Nu4YRdrIhk
         2cqcRv4Q97pJsmtywBTpBqF9KftZCkyFrdl04iRAEnPHiZh3j+ZRBBoxttMMrP5qTZFs
         070m7r59jQjAPPFc44ZGzUUCGvuCqAP8PBPJ7VF0ulzVBT6BS5pWZF6Z5iI/Ec09Xgnp
         j8Xg==
X-Forwarded-Encrypted: i=1; AJvYcCWN9m44RMYKLITBtVbKliDQGcoFlsDB0BbslE7Uy9tdbFO2FRLua9uC9Mz4riukPbPUPHQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+ZHIi77z4wnBtrwwBZnnxHNP0LpfOF2eIwHVRoGJEhwfRtSsn
	MDr3S7IiVYNczvaNn5enjtqO5b7qzAHFiXoCDNi8AjFKhsDtx4KOgpUxwqKy6YCzkUaYXLG6Bec
	h0S3Z02rU8YlwDk0QrPs3a9Kymam92H8=
X-Gm-Gg: ASbGnct62wjRC6y+3P6CQ8X/N986gbJkbB5zaqtw/TO3kTQ7qjWBouw0njrU/aFUhJE
	ehg1GEIOaU5JUBu/BKqd7o3IfBGueZQAmd41tBKhOICeleDVvKbsZOfb/KH0YDQCniLj/2nMhJL
	xJ0cWd8NNS15R2N9WKxV3pxOsp9vtOCmAZ4BGUgS2K7Bop+YVPbkMxM3FkJ0XsSgLPRLOf7ngJE
	YFWv+VQaFTAF4eumjeZqH1gUjEkGXqAy1QZy7ALLx0og1eqeujuyhyosFpuiZizJccnH/eXQ7oM
	lMW/UN76//s3joQXN+h/ZEYqFyL4tGMwW+nBcPwRhjZGR0X6S+8RO1N3uJv2RfkS9q0u5PbS5W3
	eE07zzJmGpgPC1A==
X-Google-Smtp-Source: AGHT+IHyIQx0yThg9KT154kOAtD8f8239Y2M/cEMXBlvtxveyWdxtgQX335VASRAYK/45RIQjcQyHtpm998s6Nd9ll8=
X-Received: by 2002:a17:903:248:b0:275:c066:33dd with SMTP id
 d9443c01a7336-290cba529f3mr11403495ad.10.1760659806208; Thu, 16 Oct 2025
 17:10:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251016172853.52451-1-seanjc@google.com> <CANiq72ntKAeXRT_fEGJteUfuQuNUSjobmJCbQOuJWAcNFb1+9w@mail.gmail.com>
 <aPFVcMdfFlxhgGZh@google.com> <CANiq72m6vWc9K+TLYoToGOWXXFB5tbAdf-crdx6U1UrBifEEBA@mail.gmail.com>
 <diqzqzv2762z.fsf@google.com>
In-Reply-To: <diqzqzv2762z.fsf@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 17 Oct 2025 02:09:52 +0200
X-Gm-Features: AS18NWCDoiITBSs67Uq2rZ6IBFom-AeoZUx_UgHO9S2h4SATYKwpJteeHcfF5xU
Message-ID: <CANiq72m0rNCaKandZgRa4dMhNOEN7ZanT5ht4kT8FLxYoWLVLQ@mail.gmail.com>
Subject: Re: [PATCH v13 00/12] KVM: guest_memfd: Add NUMA mempolicy support
To: Ackerley Tng <ackerleytng@google.com>
Cc: Sean Christopherson <seanjc@google.com>, Miguel Ojeda <ojeda@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Shivank Garg <shivankg@amd.com>, David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2025 at 1:57=E2=80=AFAM Ackerley Tng <ackerleytng@google.co=
m> wrote:
>
> Using the command on virt/ would pick it up. Would it be better to add
> "virt/" to the "automation" + update .clang-format while we're at it?

Yeah, that is what I was suggesting if you rely on it (and if the
maintainers of the relevant folders are OK with it).

Cheers,
Miguel

