Return-Path: <kvm+bounces-36096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C19EAA17A23
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 10:28:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 81018188B88E
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 09:28:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F0B41C07EF;
	Tue, 21 Jan 2025 09:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RRWmyCCm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05A21BEF6E;
	Tue, 21 Jan 2025 09:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737451680; cv=none; b=mr3otWRuZayi5U2NnnqPDILto13LvMeIDYRWDRcPABmrQ4YvxA9hPUD6jpk0QGPXD2FTuJfKZD0aQtL+gmkNZz/U1QXWvZROWPYk10eRmcDfJ/NoOW6323rvtRmW7RYolCtuP3+MqbDMGQ33qOE9jN0DPonXuYHyLPJdTV2gmVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737451680; c=relaxed/simple;
	bh=IF4TaY7d4duRohpHNCzfQE6bKthFQI9a4bf/i4NmVg4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qjPBFW4uPgNMWKVRaD1ah6fF+Lu6wA5ugF2D0nOhxFo3PfozXZgQ5dbfE1Zep+LRK34/MOX/YkwDeCYMOwCu0Wgb2COB3FGbc4Te1u7YaPy/zGOUpT/8zGdCbeh9ykSz+u5SrnxrhmKMadnDZyfjfFQLPiqx1BGoGKvp266kNLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RRWmyCCm; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-38789e5b6a7so3035689f8f.1;
        Tue, 21 Jan 2025 01:27:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737451677; x=1738056477; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IF4TaY7d4duRohpHNCzfQE6bKthFQI9a4bf/i4NmVg4=;
        b=RRWmyCCmbox61iqCz2MqdLIhDXxO1rvKNlId91YNqkKdj5o7+PULSok2xHvarSf0nK
         DgiSGlqaFHDe8GxuphCDn+7Ywzms7rNw9C7XTcoZHk7ydPf5NqHw5AQ45hzwCoo1fna1
         IL2K/kF+1tu7pZSKm9DrhEeTtAqKtoRMiqrQiaim/9DaJk0GZ4hmerLUI0412tpxxFtM
         1tUv8g99ZUHQMYgfHko79OC46+RDYt+1cahdiX37JKllSGluyLT+S1iBkyh9DSE2K7Mz
         IYK+OfkdgF2U4x5JIsv3SUvQ0qmEN+O4TBkKAvC6ajX9n96kBbj7A0Q/zJc32U/Av8bZ
         6BPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737451677; x=1738056477;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IF4TaY7d4duRohpHNCzfQE6bKthFQI9a4bf/i4NmVg4=;
        b=cn85X+45wmgOoKWnS/iStRM7eK88BHtAnsFqILQ2Amzn3iaQvFERag9sUDyWimqWQH
         xRd2eL9r96J2X9rmwpudjZi4vGATccotcGBhiQH27FXkVr7K7cQLHFydPJCuwukMpvxq
         LQHjZjPluFFQZILYLFpsNFu0YOlsehixgy2+dW6BUNtZgKB6+b90tznuJAL3knS1gVQ+
         XEpOequgRWjRZIe1HRXZyUyKkn8XWAy5rQ0B/NpdnQlKCQcSHHNybh9fIHAOBKs+iJ+n
         OXNfCo0iGdYrImu8iC1fCBhkedNMHwkLAQystFtZmZQh728QmSGbEpN/3P43ntteaR/8
         VZSg==
X-Forwarded-Encrypted: i=1; AJvYcCVKkqxlcuY1IldHd8eZAYrC2/nmv2Lell5ECbNuvLrgJ4uUE741S+VmKh7nli2gSr1FnYs=@vger.kernel.org, AJvYcCW4SIH93TBmLFJ/1SKD0ZnzSjXRw/39aouBfPBWtgz9S5Z45yV0ECWm2ragwnbJj0d6DAlNZW1DtzihF7P0@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6ZBLFyCgFcN8P2Tcm1u9cjPHGkHWSCQ+dHfwMitNI75uw48j0
	QGIfYKHxRYdTH/GhOc9ZgZ6i4Uk3gvNBwB+DSzsAYtkGAHko1ASQBBql/W3HVQoB+/6OV5xjWQm
	p89QA/kkUMPN9dBh/F6aBqrhd+XA=
X-Gm-Gg: ASbGncsQ6+Zgl0IP7Bl8erNb7F9alFZCAA96aZf+ta4+lrPTjbPd5H8GHHICT2v4sTv
	1PMN2WSr77fjCcD0agNpLzJTaSnBHsWj8Bl+wssVkEn4KMl/NBuuK
X-Google-Smtp-Source: AGHT+IGsHiq2BXKFB5OMXmd0lgl9uWHfEUBKI+MYwp+JL4oD+JVooOEe842v0Fn2NK+Yo6kt6laXtC4RaZ/9ayRXYk0=
X-Received: by 2002:adf:ea0d:0:b0:38b:da31:3e3e with SMTP id
 ffacd0b85a97d-38bf566c690mr13509240f8f.28.1737451676752; Tue, 21 Jan 2025
 01:27:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250117071423.469880-1-east.moutain.yang@gmail.com> <20250120135933.GJ674319@ziepe.ca>
In-Reply-To: <20250120135933.GJ674319@ziepe.ca>
From: Wencheng Yang <east.moutain.yang@gmail.com>
Date: Tue, 21 Jan 2025 17:27:45 +0800
X-Gm-Features: AbW1kvYWGED4KZNuExXgO4AJnk3tgAnEtHwpSg2ObjCB4wpxxs4VW1Y66VsUkc4
Message-ID: <CALrP2iXyfU91-bg3u0mAL8zQrriuQMbdtJ1Hta9XeBRQ_vDEHQ@mail.gmail.com>
Subject: Re: [PATCH v2] drviers/iommu/amd: support P2P access through IOMMU
 when SME is enabled
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joerg Roedel <joro@8bytes.org>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Alex Williamson <alex.williamson@redhat.com>, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 20, 2025 at 9:59=E2=80=AFPM Jason Gunthorpe <jgg@ziepe.ca> wrot=
e:
>
> On Fri, Jan 17, 2025 at 03:14:18PM +0800, Wencheng Yang wrote:
> > When SME is enabled, memory encryption bit is set in IOMMU page table
> > pte entry, it works fine if the pfn of the pte entry is memory.
> > However, if the pfn is MMIO address, for example, map other device's mm=
io
> > space to its io page table, in such situation, setting memory encryptio=
n
> > bit in pte would cause P2P failure.
>
> This doesn't seem entirely right to me, the encrypted bit should flow
> in from the entity doing the map and be based on more detailed
> knowledge about what is happening.
>
> Not be guessed at inside the iommu.
>
> We have non-encrpyted CPU memory, and (someday) encrypted MMIO.

hi Jason

IOMMU shouldn't and can't guess the type of the mapping, e.g. memory
or device MMIO,
VFIO passes the info in a flag to IOMMU to setup IO page table entry.
There is another Qemu patch which will set the flag.
Qemu path: https://lists.nongnu.org/archive/html/qemu-devel/2025-01/msg0283=
7.html

Thanks,
Wencheng

>
> Jason

