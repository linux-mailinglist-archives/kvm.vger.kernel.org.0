Return-Path: <kvm+bounces-31027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6167D9BF57B
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 19:41:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2527C288E90
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 18:41:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FA78208225;
	Wed,  6 Nov 2024 18:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oMn2/oGY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B1B205E3C
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 18:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730918510; cv=none; b=fz8efFvG2MX6wWkOmpjLkZ7YfVkYTLNM/JTqJj/DPqNvn7MoXUY24FwC+ZjV0D/hxvvagwRpcvsY44L9Kc7HwYbDVP558B1czSmfinOslVt7ZAYP8RnfZmHZ3oypXKOgpnCDXqBoOu69KY08V+mM5M/Jr73nTJiEQOg2jItHnwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730918510; c=relaxed/simple;
	bh=O0rXKOxISdp0VOGK36WmzL5LnmhOQY5UyxWhw+AV0sU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vo0CB9JkBlvmZ4anvV6ga4eMuSF1L2awhh5eIa11l++QZes/apvEapJUDzj946sCElYjygp/uOWECHVPR5/UHY8LGe8PYpDQHWqOfPFos7TEF1SBTKJwfm2hTinvIvkT2J+h0z1iuIVx7p7WO7S4qV7PaX6nHuL3ILQSSJFfMmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oMn2/oGY; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-539eb97f26aso22036e87.2
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2024 10:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730918507; x=1731523307; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yYk4e/Rf0Fwn8rgiKqzmXUTH3/JjwaWMVgfrc3mEkFk=;
        b=oMn2/oGYZprndId/F2PzmmJNlPulVcI/oYRj1/Y7c8Nz1Qd3Rv8YFsMqr/n44BEjMN
         6BAsEk0WKcWzmzrvDagnM+PWAkbS+kmkhBR7jdcoBCCU74dvoX63P45y5qpQP4z/TIoz
         UDUppNTdWCTLS2cHbJ6f+axBWF6lEopPsti8W+CTdI6PfR1v6yb91pKsE40QtpJTjnHl
         0PGOGKhw7ZjHQ2ewi6uCji+5zrTVzhmAzYbxl+W+TVpxTPC9JCiwHw3PsMJAtv0EaZEw
         2HFkNuIFnCRIXe/AlITNzzAD3lF52/BWAM9v1JZk1wYTEH8GDcs42Id1vt9nW+Wvgcya
         CuQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730918507; x=1731523307;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yYk4e/Rf0Fwn8rgiKqzmXUTH3/JjwaWMVgfrc3mEkFk=;
        b=l19tx6xL3yTFAr41eUyLKPGxiw5qY0Eq0TOArZ2RkkMM28Q9ISqiozrKj1bMW2o+Hd
         lN6EcPGfm/zDkWcy2TTFQw4GMWO5/d7dv2aEbE05qvpqzzfGOggsclfYuF9fnVv/mMhC
         i9MnJqlon8laZCsx22PyfsrUy9KpwdWk2YA2fIbg2HWXOVoP0xgTofxMxiJzEY2iggwB
         yPtiF+75Gw3cl2ko2cF0CPD+YF9FWCY7kg5DzWKy3iCkzh1Rf7xxyA/VF+lHJxHVBrXL
         p2Bv07cAlIx/pl38lj4chHdWd7NBdhAfDlJSyDq/rPyMCUfpIlfMX4lKTGByLyB3AEnM
         hRsA==
X-Gm-Message-State: AOJu0YwXZXbYxnMKyN95UrtBVWPnZ9X3yx6Xpu2DtUTTR8iQJUTM/Svj
	V2N9PVUf7zD3JgxpAccRN4a1AZYSsCYYztTcm2rYWL9LerL1uczym6Li9R+Pkf42dvcoO6S+1Ks
	sb8O3X70z5+96CT9tfsZKNE7RGH5B9CLxUszt
X-Google-Smtp-Source: AGHT+IHx4X3KPAFGSnjaYKE8NT/XVzFyHeBioH3zapaMHSYPe+KnYq0l63zBuSlt2HLiDpsHUtw8XFGqFcDi10iVlu8=
X-Received: by 2002:a05:6512:6ce:b0:539:f922:bd4e with SMTP id
 2adb3069b0e04-53b7ece11eamr15715877e87.23.1730918507026; Wed, 06 Nov 2024
 10:41:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241106083035.2813799-1-jingzhangos@google.com>
 <20241106083035.2813799-5-jingzhangos@google.com> <86a5ec1oim.wl-maz@kernel.org>
In-Reply-To: <86a5ec1oim.wl-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 6 Nov 2024 10:41:35 -0800
Message-ID: <CAAdAUtjYZ5N4UpaK5Kt8MRyN1zqPD5QqjZzNdp-HPUgA-AtNJg@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] KVM: selftests: aarch64: Test VGIC ITS tables save/restore
To: Marc Zyngier <maz@kernel.org>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Oliver Upton <oupton@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Kunkun Jiang <jiangkunkun@huawei.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre.przywara@arm.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Shusen Li <lishusen2@huawei.com>, Eric Auger <eauger@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,


On Wed, Nov 6, 2024 at 5:27=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> [Adding Eric to the list, since he worked a lot on the save/restore code]
>
> On Wed, 06 Nov 2024 08:30:35 +0000,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > Add a selftest to verify the correctness of the VGIC ITS mappings after
> > the save/restore operations (KVM_DEV_ARM_ITS_SAVE_TABLES /
> > KVM_DEV_ARM_ITS_RESTORE_TABLES).
>
> What are you checking? The saved data? The restored data?
>
> > Also calculate the time spending on save/restore operations.
>
> Is that really relevant? I don't think performance matters at this
> stage, if we can't even have reliable data.

Right. It doesn't matter. Will remove this line from the message.
>
> > This test uses some corner cases to capture the save/restore bugs. It
>
> Which corner cases?

Will add details.
>
> > will be used to verify the future incoming changes for the VGIC ITS
> > tables save/restore.
> >
> > To capture the "Invalid argument (-22)" error, run the test without any
> > option. To capture the wrong/lost mappings, run the test with '-s'
> > option.
> > Since the VGIC ITS save/restore bug is caused by orphaned DTE/ITE
> > entries, if we run the test with '-c' option whih clears the tables
> > before the save operation, the test will complete successfully.
>
> I'm sorry, but this description is meaningless, as you need to know
> what is the bug that has been fixed.

Will add bug description here too as in the cover letter.
>
> Also, how is someone supposed to run this thing? Without options? With
> options? With any combination of options?
>
> From what I understand, the various options are designed to help
> debugging a broken vgic implementation. So please document what the
> options do rather than an bug that is supposed to be already fixed.

Will do.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

Thanks,
Jing

