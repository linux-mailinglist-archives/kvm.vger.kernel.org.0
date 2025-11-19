Return-Path: <kvm+bounces-63739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 62257C7068F
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 18:19:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5B5B23C0F86
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 17:03:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F08B430148A;
	Wed, 19 Nov 2025 17:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hI/werp+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7A42FDC55
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 17:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763571822; cv=none; b=nFJCrBt8P+haIcs2uNPf+hy68WOOOZ9Ztp2vrdx9VZGYPnGz1a4DD/U4c3mYQPeCOqVBv8q7hxQrZg5ZILWIx1ldR5b8IEcsaDL1euwghPiWmLj7WcqIJ7p08FdV1iH82cnx7K/IojEePOGc1whK41C2byX7yjefiltKXfGReJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763571822; c=relaxed/simple;
	bh=Joz8s/dxni9sL2elLvsu4hbVWZHfP5iY9H5gppebmlQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=grKd33ZfBi6lA3SGz/orrS3EmwHHDr/aEjHaI+ltpa5UxbxeqsaqkQgU5ltS18ZDIcVfugJqpRGWFlLVk+aeI9VI+muVgnJwB9LUoudday2GMmnCOKtr4ytKr1H4QHj4QAQQPejMB1lL0iA8l6Kd5iRcoB/AC49Z2gaU1ZajHto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hI/werp+; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5957d7e0bf3so1136460e87.0
        for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 09:03:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763571819; x=1764176619; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Joz8s/dxni9sL2elLvsu4hbVWZHfP5iY9H5gppebmlQ=;
        b=hI/werp+0Bw10BKjLRjo6Du7NgDTtNFN/s9Y1bFstY3+NcDgQjQd6l6Im2IFE54JpX
         qPldxqlRubHscTCNtLqdq3ibIlEd7pFTs2k8ufsw/yYe8+gPVebrb2Km5qsARlb6W8ve
         0b1Llg1rInMrFfMWe7h34uB5lTVhAhszFUM3KnUDlW4W1sLeKgbzAJTUgbTHQqVGb0oJ
         8PDdjEfuxty4QzwEd3Dz1rCi9VVT1HMufkZXDSYsA2MGzRPTYIvIdJcuQL4QBciGfCUX
         e7EM/OkIoOmMMaw7rY+c8Ah8ybH7jzFzfncmeiJbrKr0pEnG+GMyxf1LOsGWBizRiGb1
         C+fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763571819; x=1764176619;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Joz8s/dxni9sL2elLvsu4hbVWZHfP5iY9H5gppebmlQ=;
        b=jNNm4u0YJZAIp2XEfzm+IJO024pGAFArkTteX0R1GwLaPvLV/uc/KkpeciKxJhsCPE
         9V0XSET2Hc0eYtOxv9A5F6yRDXzZOVz0tb3cEKkZUkbstpFK85Deco3ioMbPYkravpPV
         uDcUrl/CkdX5t8aHhoicROMUZD6qe1a5eX4ABKPZ7TPYwgdfrL42ATjqZWJPAFCIEbIv
         sczDY6SDHBr2SjussX2OofkfMHchkFB60+2h2Pw5mZPY3G3HvobQqcJjJ4ewLFw2Up1y
         EKtF6BYdxeIUvrMOuuwAFf2zTPAlVd7xPM6HLIv4tjzTuUSru3z42ZGD9jqmohO8wBYS
         pUXw==
X-Forwarded-Encrypted: i=1; AJvYcCXYxJuTxnavqasxslIQ0Hv1sRB5Ec+RiTvrdODvSnu9ZNeDyfAMhv9ZDKYNzSXeAd3Mfq8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSNAFAg0GIqOStkVM1kOxmzQR2KMYa78FYOPFceRuiuHRTexm3
	Cce4SoYA839y9NFMVOt8jAZpmBS+QXlM0Tv0vLKadun+aEmMLy85bMGc7wSOb5EL97r0hCbg6l7
	BEWmPKF0umVfVZb8L8fYYMANDiBeelJJM683uPgAg
X-Gm-Gg: ASbGnct3z1x/MAfXOW1DurKwFP+LS7rabcEjSe6GCjYIEllEkf/8rxAkDsvcZrqNqsR
	AKNeYKWNaGm4LXLt37JCFMzMrr2VpHwtBmUCSYjF+xL2mZVORkAT1Jb8DdxVUZltO0dZvPOU4ZO
	/yKcoDLeeetcgfjrh1U4tV0rXrqiKyOsZlPNE/BYQA7IRMHnkEsDIqhkzco6Cw6+I8ZW2rIdPR3
	BYxgAaOph62LMKotzxwAA9o8rxemGzPzqOOYDHlp5IbMdFlV7xe6o7afO2aGlE7Z5hMiyg=
X-Google-Smtp-Source: AGHT+IHLnfFMB79mkG+6/o9cMHX6tnmLJ/qLfKaDy79MvHc48DxMublMslXondrAnHRz/vxgrdeuGlBqo3D+UMEcLug=
X-Received: by 2002:a05:6512:239e:b0:595:9989:16fd with SMTP id
 2adb3069b0e04-5963c6ebb4cmr1183399e87.11.1763571818694; Wed, 19 Nov 2025
 09:03:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251112192232.442761-1-dmatlack@google.com> <aRuB45aR1LVGO1If@devgpu015.cco6.facebook.com>
In-Reply-To: <aRuB45aR1LVGO1If@devgpu015.cco6.facebook.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 19 Nov 2025 09:03:11 -0800
X-Gm-Features: AWmQ_bl4OFVMea1wDth-sxqYlydIYD_u1bMxVsbbLDnyANu2bUVfhbsszPNqIjQ
Message-ID: <CALzav=eHne7TihNmskg9ctv1N+F0snKVmifwOdtmrU8LQwcDsg@mail.gmail.com>
Subject: Re: [PATCH v2 00/18] vfio: selftests: Support for multi-device tests
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, Alex Williamson <alex@shazbot.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Raghavendra Rao Ananta <rananta@google.com>, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2025 at 12:13=E2=80=AFPM Alex Mastro <amastro@fb.com> wrote=
:
>
> On Wed, Nov 12, 2025 at 07:22:14PM +0000, David Matlack wrote:
> > This series adds support for tests that use multiple devices, and adds
> > one new test, vfio_pci_device_init_perf_test, which measures parallel
> > device initialization time to demonstrate the improvement from commit
> > e908f58b6beb ("vfio/pci: Separate SR-IOV VF dev_set").
>
> Aside from the Makefile assignment issue in "Split run.sh into separate
> scripts", LGTM.
>
> Reviewed-by: Alex Mastro <amastro@fb.com>

Thanks for the review. I'll send a v3 this week to address your comments.

