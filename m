Return-Path: <kvm+bounces-37901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A224A31276
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 18:09:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B8D63A5540
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 17:09:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C5CE262152;
	Tue, 11 Feb 2025 17:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JriOSng6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBFD3260A2A
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 17:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739293768; cv=none; b=MEUlFHKlEHQH+NLRs9aFDUusGlZI0NoLRb1LBQBWCFnM/4hX/vyb9DD/Rb8RJOhgdjUhNKuldzW3OjOiGI9FdfuZONQyorPxuLG8OCTiADPSy5u08KTFRcPyF2zQs/K+J65VmWBATwZ+dgi8d1cKBTeyT9DdQyBEdo7SZLAoRNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739293768; c=relaxed/simple;
	bh=g0tGKJas1ZSOxaK+K5kdB8bq5Y/ouUM99Eg+pkCt1Q0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gdWKjhvkrNnCajJo+P7WwTcD51iRlQujqQkkHTkmUp4VW2h77G5rBEjaALTKLcFp1DGhF5ThrM2ZDB94X+5cayJHNF2VxuXjPK6CpIbxBUpP+9RWPlEj/SvZR/ydMLjFUvPsCbV0tr4trRqDnMZNkUS58X92tiWTRgKIv1rDO18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JriOSng6; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ab78e6edb99so622690466b.2
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 09:09:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739293765; x=1739898565; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g0tGKJas1ZSOxaK+K5kdB8bq5Y/ouUM99Eg+pkCt1Q0=;
        b=JriOSng6CGas9qax0TS0fZSi46N/vqsCUesyoy+aCrdRvDjsjQZchg/Y94bURep2kD
         T9R+ymXn4Ct5cw/HFQ4iHzblccJRcN408eKELMxHQrSFEprGFN5T6Qe/07KFBRKNDCRM
         j/TA+H9EPeswYWfyKB54peGqXkpj4R7AKz30XI70AdZLjjE4BaaQevGMB4zbgK/9mGbk
         Hg+WQUF6D8+jnbhLJmr/Eq6hHIPn4IJRQpIucFBgwfYPk8Ql1lJrm8fJEU9U7NFQadhl
         x5em5HiJtnIfdVEmBF79x14OLoizN54SynzPn/z7LHb4h6mCh/vjdvQ3gtgx4c2jGrEu
         9sLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739293765; x=1739898565;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g0tGKJas1ZSOxaK+K5kdB8bq5Y/ouUM99Eg+pkCt1Q0=;
        b=g370VesmvMcWf/MU6QS+tqOdqJZwZjyQG1tmdxsIIIMqancw2PsaHqN8WJEX7s01GQ
         Uy3oorlYii8jxl4rt2cbyAMZSmQ8KBKCCI5qy+8ZuUNlU3qmq++y2eR5Us1bliNFbB2H
         5BOSpOzj8ktODiuCIsYh5XHlrFtgOGRKgitnSHJw5F7PeZ5GdM+1RrU1SP9DWM3sjEYI
         EQTJxwJJz8CBusdXOmUTb10DnoKxlT4Waa8bemJ/o2i8zPnSmwYIztvBE0SbGff4Up4y
         mbwuUMoGdBLOeFaPme9Wd+wxli8ReRAFIgkSqmvVe0tHmIaZr/nsc6q/gHMXZ1/UAqCM
         lAdw==
X-Forwarded-Encrypted: i=1; AJvYcCXd/DTET7r0wq8IqgAltEmYas2h336zqmHpRljzphcmQ31OZ5EjYK67NOdIRayPwTowcF0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyg9nLKTp/n6+Gkbki/vTve7uwNOr1j8t6RWcPxO8OtgBn96+zM
	NuJzs0iOhjKRF1e1domfoI3sWHrw/vRRn4ztS8VgG0GtQUCMpmr9M9GR4CHpuA==
X-Gm-Gg: ASbGncv/ymPrtj03hmKdTPydaqDZXjd6NXA/w97FEPBVITu3gedaksSLs+TpUs5jtlQ
	yR4ONK4EKDT3bnGRtBOfy0XghoOzZV9QJBGZW65M1RtcAon9GiWyMmD85s6gOCqb76R2lf9ZWPX
	PF3dSif8QBaXhku8ZadXxkE+5Rd5I4KANiKUxhJulPh1FC0/VAABMaJg4bKk8TX6j1m7Cu267pX
	HdrUsV7FopNzaxwsRxCllwREabiiNix2uyaKIeklT6sBlNkH0rfsQQKdDQJ0fTaU1a6B5Qy5nWc
	X1YiZdJFWeOHJra3xr1UQnzqVPogu0v9KR1lGybiniTcztdEI9b3
X-Google-Smtp-Source: AGHT+IFIi2IgfMiUl6fq4jxhAFkNUGBPDebPQN+2zrMnqf5fMbjpGvWnWGuDKbhOOsAcxDgiWgwGAw==
X-Received: by 2002:a17:907:1c95:b0:ab7:c94f:af87 with SMTP id a640c23a62f3a-ab7c94fb336mr860049466b.16.1739293764863;
        Tue, 11 Feb 2025 09:09:24 -0800 (PST)
Received: from google.com (229.112.91.34.bc.googleusercontent.com. [34.91.112.229])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab7878b18a9sm958724166b.167.2025.02.11.09.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 09:09:24 -0800 (PST)
Date: Tue, 11 Feb 2025 17:09:20 +0000
From: Quentin Perret <qperret@google.com>
To: Patrick Roy <roypat@amazon.co.uk>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
	xiaoyao.li@intel.com, yilun.xu@intel.com,
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
	dmatlack@google.com, yu.c.zhang@linux.intel.com,
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
	vannapurve@google.com, ackerleytng@google.com,
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com,
	wei.w.wang@intel.com, liam.merwick@oracle.com,
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
	suzuki.poulose@arm.com, steven.price@arm.com,
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
	quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
	quic_pheragu@quicinc.com, catalin.marinas@arm.com,
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
	maz@kernel.org, will@kernel.org, keirf@google.com, shuah@kernel.org,
	hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
	jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
	jthoughton@google.com
Subject: Re: [PATCH v3 09/11] KVM: arm64: Introduce
 KVM_VM_TYPE_ARM_SW_PROTECTED machine type
Message-ID: <Z6uEQFDbMGboHYx7@google.com>
References: <20250211121128.703390-1-tabba@google.com>
 <20250211121128.703390-10-tabba@google.com>
 <Z6t227f31unTnQQt@google.com>
 <CA+EHjTweTLDzhcCoEZYP4iyuti+8TU3HbtLHh+u5ark6WDjbsA@mail.gmail.com>
 <Z6t6_M8un1Cf3nmk@google.com>
 <d9645330-3a0d-4950-a50b-ce82b428e08c@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9645330-3a0d-4950-a50b-ce82b428e08c@amazon.co.uk>

Hi Patrick,

On Tuesday 11 Feb 2025 at 16:32:31 (+0000), Patrick Roy wrote:
> I was hoping that SW_PROTECTED_VM will be the VM type that something
> like Firecracker could use, e.g. an interface to guest_memfd specifically
> _without_ pKVM, as Fuad was saying.

I had, probably incorrectly, assumed that we'd eventually want to allow
gmem for all VMs, including traditional KVM VMs that don't have anything
special. Perhaps the gmem support could be exposed via a KVM_CAP in this
case?

Anyway, no objection to the proposed approach in this patch assuming we
will eventually have HW_PROTECTED_VM for pKVM VMs, and that _that_ can be
bit 31 :).

Thanks,
Quentin

