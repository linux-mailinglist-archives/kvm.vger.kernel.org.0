Return-Path: <kvm+bounces-65177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 81419C9D1C3
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 22:42:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 2B112348870
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 21:42:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B49312F90CD;
	Tue,  2 Dec 2025 21:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="Op5VRHid"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D4E2EC086
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 21:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764711716; cv=none; b=FwOwb8yuvcTocD+70n1sRJ9g8XJEar7yHToVclSV0WzU7m7CgriYuJQXJC70AFvtaNiAjnZH/knXWCth/BgJuby/0m406Z5rIHPv9k7H08TkkflZrZhpacTwGf25UeAoFdEnPO5h7fmO8xHlUWeblcukNYqXz/xyCuuvlQ4HMNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764711716; c=relaxed/simple;
	bh=bK1bgqioLqPqNCUbFDzXCG7JyoMoUTbDQKJcABIxh2w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XlpL576HEMDNGvT/7dz1lfY+NWbrk5tf4KkRy5QzuTmfzjGYVpOlY8TKqJgophBKrJaJttFwMPyHhBL5HqJ4FtaewtEPNrS6KiBiPzpA0gsF9Y3Gfb1gZqA4WI8vlwxAeDuaD+yhcp4FJFaNNd18jtYXGJqwPyyZJScJDDDGNrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=Op5VRHid; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-640c1fda178so11261652a12.1
        for <kvm@vger.kernel.org>; Tue, 02 Dec 2025 13:41:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764711713; x=1765316513; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BBy8J1XDJHjmvX+Es4TFPSfzkazm1BSKmXhHEtk+CP0=;
        b=Op5VRHid8eH8ab8VEX0QPXgsFu0URtp8bXZp/H8ljdQMHABjoPeqMIU6h/A5GYp09O
         KZ5CJiq1zG2ZcYTiSuZL8G0HA7ePok6V34mVi4UsUQK1mZxHsBufcTh95QTs0z2ihO9K
         tul2bvvQ5hdy8L1+JKgxMlJ+AOV2OxXlnOLcOjQ+85y1ot0k98PVhHPZiiqQMk6K08n6
         WNGL8ukYm6/qJrI6EynDO9OHFaoqeIRrK7YKnrvMut71cFGvIs9qYblyM7l6+yODBLjJ
         f+kzAAZBOXpVBv2JJwnoBkpwjQTpeE7PG0BVbxTnw1VjhZV5e9z3joJfWgH9xun4FFo2
         zWYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764711713; x=1765316513;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BBy8J1XDJHjmvX+Es4TFPSfzkazm1BSKmXhHEtk+CP0=;
        b=kYBG4nBfdmvaDqDRNtObtYMw+0X+w7mkbdz1PUZ8s1PQLkZ9GidKMgVpTUsFGZdojg
         kqL15FV7i+JART7U0PRPb/ty2xxw6P6y2JEYGdxzzKfilm0DNHJwuN36Wfkb671cqoMi
         TawCyzFN1PaB91Fmiqx5hXZNu/O8W5Pjjh94VgMu9MYkdorxkqEZYejkcrkEajNmRrf+
         c55YZGoR/P4Tb8D4H7Jdih2380I92mR6OJ+f540UZl1t++FraaXWDshCIugWZcOti7JK
         7BKjOfgyJbHDXKIt02ck6jsdbl6zz6xYILvUdLGegvDCjgLLW3K5HL0BglylgtGwWuJX
         2PNw==
X-Forwarded-Encrypted: i=1; AJvYcCUhQem8JITVmp46VLjCnNR2sfYe873FUC4FPPZgCmBHshD9h+TzW/UbA0tLw0y3mt/gP/c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1Y8CQps1xYLXUvmGNjDJaOChpORtL3Ktu4b7NeGYdyYe+3eu+
	otfR9LTNYmhe6eudblyxCdVyH3fBNisEzd7HQ8PbRI6vpkuljk+1fnJZD9z3qAfW0Iaaxo3vEj6
	F5vsmdejGf3MxCXdb0Fhs6Q05KhCGY6l9yrpyMFp7Qw==
X-Gm-Gg: ASbGncs80OJaM32znCFAsxq1q8w3V4c0bDpTPj8eFX6V/Ax31Dcv17L3lu6E9n6Bxeq
	wfRxcgwUeSrZDFjYaNFv6bdJqKuJ9MeiGfI4uTL6DS3hIgMK5VEB2yeI8oiPSlsATI9jCQCddb3
	svZWozpmYMOykyYiVnceJbjiW7YFUhrhQeTiyZe5hX2kSu7wZ2HzMKMiD0EQNz9jrMF4hPEMaTn
	7fyo3vcUDZsEBWT+3sfqjp8KfBQYVey+z31Xr4Uf9pFZ5IhqAAC/6q3MpvGcuURZe846V1KEcvE
	AnQ=
X-Google-Smtp-Source: AGHT+IHWLpn7rUj8mxZXJ9rMfRKD6U7DeusV73jTTRLFZkQI3y5z61JVyECIWb2QWdSzz1X1Lv1zjhKD+XOAMt/wgfo=
X-Received: by 2002:a05:6402:455b:b0:643:129f:9d8e with SMTP id
 4fb4d7f45d1cf-64794f33cc3mr841742a12.8.1764711712986; Tue, 02 Dec 2025
 13:41:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251126193608.2678510-1-dmatlack@google.com> <CA+CK2bC3EgL5r7myENVgJ9Hq2P9Gz0axnNqy3e6E_YKVRM=-ng@mail.gmail.com>
 <86bjkhm0tp.fsf@kernel.org> <CALzav=es=RKMsRUdpX03m+2Eq4SVxPZSZuy1fLXV+dv=rhDhaw@mail.gmail.com>
In-Reply-To: <CALzav=es=RKMsRUdpX03m+2Eq4SVxPZSZuy1fLXV+dv=rhDhaw@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 2 Dec 2025 16:41:15 -0500
X-Gm-Features: AWmQ_bnrPyeCqV6AbWIFTsaIoktB-kTeS5xKZG_PhpHyIHste-GfTWjRKtK6tnk
Message-ID: <CA+CK2bBWB_+SOf6EgFm0nfovQd0-KPHQCRkqbWWTq4Yx2wAL7A@mail.gmail.com>
Subject: Re: [PATCH 00/21] vfio/pci: Base support to preserve a VFIO device
 file across Live Update
To: David Matlack <dmatlack@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, Alex Williamson <alex@shazbot.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alex Mastro <amastro@fb.com>, 
	Alistair Popple <apopple@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, 
	Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Philipp Stanner <pstanner@redhat.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <shuah@kernel.org>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, 
	Yi Liu <yi.l.liu@intel.com>, Yunxiang Li <Yunxiang.Li@amd.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"

> > >> FLB Retrieving
> > >>
> > >>   The first patch of this series includes a fix to prevent an FLB from
> > >>   being retrieved again it is finished. I am wondering if this is the
> > >>   right approach or if subsystems are expected to stop calling
> > >>   liveupdate_flb_get_incoming() after an FLB is finished.
> >
> > IMO once the FLB is finished, LUO should make sure it cannot be
> > retrieved, mainly so subsystem code is simpler and less bug-prone.
>
> +1, and I think Pasha is going to do that in the next version of FLB.

Yes, I will add this change in the next version of FLB; however, I
will send the next version of FLB only once list_private.h [1] is
added to linux-next, so I can replace luo_list_for_each_private() with
list_private_for_each_entry().

Pasha

[1] https://lore.kernel.org/all/20251126185725.4164769-1-pasha.tatashin@soleen.com

