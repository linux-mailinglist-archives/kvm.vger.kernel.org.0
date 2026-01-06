Return-Path: <kvm+bounces-67160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2738ACFA3F0
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 19:42:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 08AEC3397485
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 17:55:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7390A35CBDD;
	Tue,  6 Jan 2026 17:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rz04sJii"
X-Original-To: kvm@vger.kernel.org
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3190B35CBB4
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 17:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721655; cv=pass; b=TBzvcik26ncAJCp6M6lPRth+HGdpG1KVUbP9EL7OsYLMIK+gw8NYrL25YO2AFD7xjEgKUKQOPwGMwgfRXy/gm48tEnN78OHruexQImkZyZpkN2EZYujxaOnX+TuQUx/SwJDkQCtJRnEDoc9lMovKFuE2+0u81uGunB2pHzUHymI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721655; c=relaxed/simple;
	bh=EXL9Wfx+B9qmociVk5Yy6Cl4j5OGERB0rkfaSROY9/8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s6z7+gxf5ZJXOwR3+poFXrW4q5jnjm4PXCTmmgGGfRu1DJhxw+HMOTxslbSak6CzL/NP1emo5KlO/AwYJ4was5ApwMOaZTHJhbVUsW8hqktdu7NHuTSkRsHRKe+yp820+siV3YtTqTOsf3fwvB7nCvJ+awDAFmE/6LxtJUPbQF0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rz04sJii; arc=pass smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-11f42e9977fso105c88.1
        for <kvm@vger.kernel.org>; Tue, 06 Jan 2026 09:47:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767721652; cv=none;
        d=google.com; s=arc-20240605;
        b=MUZKMGoMmJLvGe98mRwHDQof9fPPL5ErpWdG22IKJHMWC+FAhg/HUd07CP3oNz6d2f
         ZAd4RShwRcEhL3sWxnUhEjy3MCKNOxC//4mjYxBwQgdyWwHexIaZnHMxqPGJ2lICfe1U
         728YlAdEXkH7nbIi/sWqsMcPaIKyR3wOAMXzk4oMZkPE0419QMwNzdEhFdnrKkYxS36z
         iRCW5VeY5CU+he19Omjhopdx5nO5tF4/NxBJ/HcoDH1zxS39nUs0S8pRXMt9VU14Zira
         J/JCtrfLI8IAeLy67Wy9x3ibkxwdaxX6r4bRLcUAkI2XJB0+LWKqstur4F+O3C+KzSOq
         3ulg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KceEcR8Mk7VNRuQE40tEkR+SrpRIwDvfMIKd8O5ZDDI=;
        fh=n8tleSNJyWz22WCwMdsi5dG5zPUXY7o2rzZI+rxTayw=;
        b=XCOJ7hLGrEn7UEAPm6U+5voJsQEokIzjC5KFY00vFy1CYq1aCuitbdR0mkKBhcqYIK
         LezEHRUFZxRToXyT5pMn1cCbA+N0Ug5Z/ZdS10GOUW/c5E8Bb5noXOL/rERAufJMum3C
         /bJBKckrlUWFMbZZ1SK7KobNTt8hKKEfovfXZPyMJefa9JkOzRU0fO+vOKu9AvrLCAp9
         AQJNbDf5V20cwqMFDqHJb0nfDepu1qFNRCmAUf9qlZ4UUzRBOSgtE0bSZgFJoLtdVzMM
         A6dJd7Q7f/51KGvuOlvNjxuIErVj1d7+oXKtYNJoFiZd1c038zk1nQ2U4XLd3TEv+BQk
         EKlg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767721652; x=1768326452; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KceEcR8Mk7VNRuQE40tEkR+SrpRIwDvfMIKd8O5ZDDI=;
        b=Rz04sJii0kJ6G3XVF4QUGvNx7+IR6LM8llMD1HxJd1lC7dAg3D4imN4nvHhGfA2kwO
         WqHFCNTO8rtOqhJNkgkUo2eT4SFCTJ91XC7NYPJwtd6Tnv5YZz/sqESQZAW2vkaodr0P
         EDqZOjzsTrdAnLE0AXJWcGhrgu2Rspi3AMU0BQ28Kf9TpwY18yB2V++fcC1305dFy6RP
         /Vptw2cuHVzXKCfazzGth7Ky83ZHcqkJGeMI/pFZZ7eSLysYKTZ4XNHDBh05+y8RAwvz
         kZZX8ZLKL4RaqNPQzHHFvlUa72TXxdSVZ1p/v30ungSfHhWdAM22YwB04Rc9mcqZVi/x
         LzIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767721652; x=1768326452;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KceEcR8Mk7VNRuQE40tEkR+SrpRIwDvfMIKd8O5ZDDI=;
        b=CHyW1OahmMZrhTreW/O5JaA8ANTt4t2aESmM8gToHL3E4YdIaP0g3A0/YO2Rk6145J
         dpjUzl4hhD4jW9xHpWWTlRGZAMHh/20jlgnNsqTS+7KE6prSjyr8L5T99xeP1H+BdhYN
         zOnyPrdHijdI+zRVnrEJiIqh9RzhIEuMK+su9G5czUtU112Br+uovZCqEXYr4P6bY4D6
         cMn1CLIc66v94lAQi8abPDPKBUpRiEbz5A3izGJ4+6mdn2/A5KP1MzynyF1BCYnSmckz
         vbxcP2dcbuRVLBGd9xQ+RRxIbCpG3sRHZWs0+wPl6uW+Or77Pp5dFJXqS3XKgNMgT/zi
         cLKw==
X-Forwarded-Encrypted: i=1; AJvYcCUQRWsZMCj8mI80vaqSMRKk5HynH8xs1tV4ZKT/XixEbEv8/aKOG2I+sdMYHpC+XLS2Jbk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIxREauICHO7CJWzhuXUpqDMHz5wbk+YO5/UuoOVfw33sSDf6f
	S2k0yvR2hBIfShwwU5XaneDHXDOHGqFZ+vwXms0iVOYM1OmsBsd6Mj19PLB3ih+ytmmERTd3uIJ
	Ayk03m9+t+I3O2MsnwOf9WWT+PyNuzaZdGGi2gCsJ
X-Gm-Gg: AY/fxX72HtSlJlRg/awsVWkLh0hFwhGyzar/L11gObOg8Al5ryVrMPY0+B9mRAB00fZ
	lndzsQGC1Kxoiulymnn3E5Vg7sn0rlYyCAu975eItsDcCvDonuo9v0mZgaqUJVFiDVy8TktE+dz
	s3cvzVrZFx/e0EJoJndxtEtZRw6wf0q52I+kmM9lKehJGQ8YZFodHMH1juoCv/P2QBvJbpQVfKm
	34jx44feGMEhqrldF1VWRrglDHh15jJseAF2jyL5Osqy/o8nW5ZqV0bjMwho2g8rs3q1ura9se/
	iBqwY85aIYAkrAyu14FeY9XQqtoN
X-Google-Smtp-Source: AGHT+IF1hccZhhStfmTqm65aZChcZ14xPQI+yEW3tbI7YKmiBlwx3rFprJQyQrX5Hep5w9Exbs544yNuLuF6s3W06co=
X-Received: by 2002:a05:7022:6190:b0:11f:25fe:952f with SMTP id
 a92af1059eb24-121f1ae4199mr175430c88.8.1767721651510; Tue, 06 Jan 2026
 09:47:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
In-Reply-To: <20260106101646.24809-1-yan.y.zhao@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 6 Jan 2026 09:47:19 -0800
X-Gm-Features: AQt7F2r_zD7My1QCBjngb16zmg_Phxutejj6Kpq3XGjvBfejBJdiqRRBjc3YmlA
Message-ID: <CAGtprH-eEUzHDUB0CK2V162HHqvE8kT3bAacb6d3xDYJPwBiYA@mail.gmail.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com, 
	dave.hansen@intel.com, kas@kernel.org, tabba@google.com, 
	ackerleytng@google.com, michael.roth@amd.com, david@kernel.org, 
	sagis@google.com, vbabka@suse.cz, thomas.lendacky@amd.com, 
	nik.borisov@suse.com, pgonda@google.com, fan.du@intel.com, jun.miao@intel.com, 
	francescolavra.fl@gmail.com, jgross@suse.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, kai.huang@intel.com, 
	binbin.wu@linux.intel.com, chao.p.peng@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 6, 2026 at 2:19=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com> wrot=
e:
>
> - EPT mapping size and folio size
>
>   This series is built upon the rule in KVM that the mapping size in the
>   KVM-managed secondary MMU is no larger than the backend folio size.
>
>   Therefore, there are sanity checks in the SEAMCALL wrappers in patches
>   1-5 to follow this rule, either in tdh_mem_page_aug() for mapping
>   (patch 1) or in tdh_phymem_page_wbinvd_hkid() (patch 3),
>   tdx_quirk_reset_folio() (patch 4), tdh_phymem_page_reclaim() (patch 5)
>   for unmapping.
>
>   However, as Vishal pointed out in [7], the new hugetlb-based guest_memf=
d
>   [1] splits backend folios ahead of notifying KVM for unmapping. So, thi=
s
>   series also relies on the fixup patch [8] to notify KVM of unmapping
>   before splitting the backend folio during the memory conversion ioctl.

I think the major issue here is that if splitting fails there is no
way to undo the unmapping [1]. How should KVM/VMM/guest handle the
case where a guest requested conversion to shared, the conversion
failed and the memory is no longer mapped as private?

[1] https://lore.kernel.org/kvm/aN8P87AXlxlEDdpP@google.com/

> Four issues are identified in the WIP hugetlb-based guest_memfd [1]:
>
> (1) Compilation error due to missing symbol export of
>     hugetlb_restructuring_free_folio().
>
> (2) guest_memfd splits backend folios when the folio is still mapped as
>     huge in KVM (which breaks KVM's basic assumption that EPT mapping siz=
e
>     should not exceed the backend folio size).
>
> (3) guest_memfd is incapable of merging folios to huge for
>     shared-to-private conversions.
>
> (4) Unnecessary disabling huge private mappings when HVA is not 2M-aligne=
d,
>     given that shared pages can only be mapped at 4KB.
>
> So, this series also depends on the four fixup patches included in [4]:
>
> [FIXUP] KVM: guest_memfd: Allow gmem slot lpage even with non-aligned uad=
dr
> [FIXUP] KVM: guest_memfd: Allow merging folios after to-private conversio=
n
> [FIXUP] KVM: guest_memfd: Zap mappings before splitting backend folios
> [FIXUP] mm: hugetlb_restructuring: Export hugetlb_restructuring_free_foli=
o()
>
> (lkp sent me some more gmem compilation errors. I ignored them as I didn'=
t
>  encounter them with my config and env).
>
> ...
>
> [0] RFC v2: https://lore.kernel.org/all/20250807093950.4395-1-yan.y.zhao@=
intel.com
> [1] hugetlb-based gmem: https://github.com/googleprodkernel/linux-cc/tree=
/wip-gmem-conversions-hugetlb-restructuring-12-08-25
> [2] gmem-population rework v2: https://lore.kernel.org/all/20251215153411=
.3613928-1-michael.roth@amd.com
> [3] DPAMT v4: https://lore.kernel.org/kvm/20251121005125.417831-1-rick.p.=
edgecombe@intel.com
> [4] kernel full stack: https://github.com/intel-staging/tdx/tree/huge_pag=
e_v3
> [5] https://lore.kernel.org/all/aF0Kg8FcHVMvsqSo@yzhao56-desk.sh.intel.co=
m
> [6] https://lore.kernel.org/all/aGSoDnODoG2%2FpbYn@yzhao56-desk.sh.intel.=
com
> [7] https://lore.kernel.org/all/CAGtprH9vdpAGDNtzje=3D7faHBQc9qTSF2fUEGcb=
CkfJehFuP-rw@mail.gmail.com
> [8] https://github.com/intel-staging/tdx/commit/a8aedac2df44e29247773db34=
44bc65f7100daa1
> [9] https://github.com/intel-staging/tdx/commit/8747667feb0b37daabcaee713=
2c398f9e62a6edd
> [10] https://github.com/intel-staging/tdx/commit/ab29a85ec2072393ab268e23=
1c97f07833853d0d
> [11] https://github.com/intel-staging/tdx/commit/4feb6bf371f3a747b71fc9f4=
ded25261e66b8895
>

