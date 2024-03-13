Return-Path: <kvm+bounces-11714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D0F087A286
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 05:55:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB91C1C21A13
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 04:55:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3D9912E6F;
	Wed, 13 Mar 2024 04:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="awKcicmA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8BE111A9
	for <kvm@vger.kernel.org>; Wed, 13 Mar 2024 04:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710305735; cv=none; b=idmCcFwpinvMBLqbbZ/FTw8Wz6bu2WIjJ8tAIf3sA4dAFamelKeNS1ElZCIlhf2eiIxPRA/VA0TgsQr5Jkz3EvOc1R6UEdGUsOWmDIyYsV3ncgTc2w49Ng4aApzoBkg5rI7zkIpyxGKRUjIhnzkRMAjhXvsxOqkma5wLXpwNE5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710305735; c=relaxed/simple;
	bh=RTWz8EpSDEWKJM3TEtQ8z2nh961615KfzXWZv+DoDH8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gnKDZ6shTT2V3vTbx2cyr8PLEWSL6PnWQ58BMS9+DU0wzIwGB8WFn+65j5DLk5dE3NwveARORFFBViSiysXne8QQ+6moswpAptecnlP1DTJbc5CM2Ov9QgnMYT+B63/O5a9AFnMxYEOVJ5kyhxyF4Bi4AkZARJTv0LSnyiR608A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=awKcicmA; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5135e8262e4so6693532e87.0
        for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 21:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1710305731; x=1710910531; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RTWz8EpSDEWKJM3TEtQ8z2nh961615KfzXWZv+DoDH8=;
        b=awKcicmA2sv2rFN9PCIV1Fem03o9I0g9Wrvm3KyafY/yhQIPX9+EXvRl8EL+kMRONX
         pSLK3jilIQKwitliWT2l7MNIZ9tpcL0YzygrCKPn/mi3noAaEzb2WnG8dANN6m7EX6y5
         0LYHKU7tGN3k5h9qJ1uABYfxGJZJVnvQY6Kc0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710305731; x=1710910531;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RTWz8EpSDEWKJM3TEtQ8z2nh961615KfzXWZv+DoDH8=;
        b=DnqL7rCz/XjfRhCjEA+0SV8tJuzDFci1QN0t97g1cuWWs0wEf3c9kGeRjbrZFaE8Yb
         MStx15U2BVwPX0UOjENXd7P0QdR8fisaUgIX8fNNif82rAjRmkU7N4FWF3xknfeTZXBg
         smyrjgV4h+RfrEYeZfwOTKuy1Xp6X7R9/0gsAXaTqRCIm7sAiWB8BU2yWFBrsd7FyACO
         y5bNfR6ylQbj0e9yNf3gc7dPQW+dZ/yMRndwws0NSiBkRyta5geAUlB7oYc2bpx1cEpF
         uWR3Xilt+MNmrtISI7MPO69ostA40vqNd1KR9L3Zv+xOk+QuoQ2Rdj/AmHoY7GjnD9m8
         Z2Sg==
X-Forwarded-Encrypted: i=1; AJvYcCUdvZtH8cICpZ5+tn9RkrnqWO+YK/Y368qVYS7Y0Pi6pPn/NzDAoA1hesa+tGHOiAN8p74aQaLAVspTcGMtVNu6GY3l
X-Gm-Message-State: AOJu0YwWiX7kuolNb33tWLlGSoVDMKXqxIABBtOljGWZiV+mRDFg3LBn
	w6hbblNNH16GmmyEzipKfWyyJHVhnlOq+//IblCUyQkpHC61/czvP0hIgPGilRIAiTn+DUWlTwm
	5FluPwWNBKNXF6Ipn/F43PckWyvvN8RKUyyL+x/laLoDm4aGwCQ==
X-Google-Smtp-Source: AGHT+IFnrqxk91ihDavcZ15Yamg0oeFHaSxOKuxqRQfg8amMGoR83ZIRGkueW8eCFqCm+gR78/kxhDbJgQE9zn7EngE=
X-Received: by 2002:a05:6512:556:b0:513:c1e6:3c55 with SMTP id
 h22-20020a056512055600b00513c1e63c55mr1925135lfl.69.1710305731589; Tue, 12
 Mar 2024 21:55:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240229025759.1187910-1-stevensd@google.com> <ZeCIX5Aw5s1L0YEh@infradead.org>
In-Reply-To: <ZeCIX5Aw5s1L0YEh@infradead.org>
From: David Stevens <stevensd@chromium.org>
Date: Wed, 13 Mar 2024 13:55:20 +0900
Message-ID: <CAD=HUj7fT2CVXLfi5mty0rSzpG_jK9fhcKYGQnTf_H8Hg-541Q@mail.gmail.com>
Subject: Re: [PATCH v11 0/8] KVM: allow mapping non-refcounted pages
To: Christoph Hellwig <hch@infradead.org>
Cc: Christian Koenig <christian.koenig@amd.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 29, 2024 at 10:36=E2=80=AFPM Christoph Hellwig <hch@infradead.o=
rg> wrote:
>
> On Thu, Feb 29, 2024 at 11:57:51AM +0900, David Stevens wrote:
> > Our use case is virtio-gpu blob resources [1], which directly map host
> > graphics buffers into the guest as "vram" for the virtio-gpu device.
> > This feature currently does not work on systems using the amdgpu driver=
,
> > as that driver allocates non-compound higher order pages via
> > ttm_pool_alloc_page().
>
> .. and just as last time around that is still the problem that needs
> to be fixed instead of creating a monster like this to map
> non-refcounted pages.
>

Patches to amdgpu to have been NAKed [1] with the justification that
using non-refcounted pages is working as intended and KVM is in the
wrong for wanting to take references to pages mapped with VM_PFNMAP
[2].

The existence of the VM_PFNMAP implies that the existence of
non-refcounted pages is working as designed. We can argue about
whether or not VM_PFNMAP should exist, but until VM_PFNMAP is removed,
KVM should be able to handle it. Also note that this is not adding a
new source of non-refcounted pages, so it doesn't make removing
non-refcounted pages more difficult, if the kernel does decide to go
in that direction.

-David

[1] https://lore.kernel.org/lkml/8230a356-be38-f228-4a8e-95124e8e8db6@amd.c=
om/
[2] https://lore.kernel.org/lkml/594f1013-b925-3c75-be61-2d649f5ca54e@amd.c=
om/

