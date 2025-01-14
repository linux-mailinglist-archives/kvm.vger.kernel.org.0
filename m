Return-Path: <kvm+bounces-35345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8762DA0FE9A
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 03:18:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A395F18892B3
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 02:18:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3EAD230263;
	Tue, 14 Jan 2025 02:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="enOZ+Cwk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7902DAD27
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 02:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736821113; cv=none; b=Wp+WA+RVjokMYrujRU6I5ksDyPlxlVfDYC78f/kn/tH/RzUtquXovEeCWRUeN7PrbWYXF5NQgWEJtaH82o9LY/QCuzpCZdPuEIvDoXfQiNlKa+hsIGbffWWwanqR4DEFiCw9y0pABsQvOEIggekeQdbaO8kcZpL5gYY3n7LrsEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736821113; c=relaxed/simple;
	bh=FR1w8DHiNlRfEH0Y9g4o9X9y5C85sJ8mTWqsZ0CrX5s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I6zUTFB6Xd3MDLHaIuQkaquGBHJ+/WYL1r5ONiTCLZZzuxkAdJHogLZyVuxOcKmDf3PePL0uwt98xbggYq6Ertfk/nLdYl9DyAxzMpu8l7bGt3SJ5WANkqwVkj47/6b5R4R+RhxOJKapUlD+fmV9eN32ZVnKW9COgG9yAfocFrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=enOZ+Cwk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736821110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nMiO78zk7MaHUEVJBvuQE73KBuKkV5ITS7yQXGCIoKg=;
	b=enOZ+CwkLxZxk5AbLXLu1BqC1GGFaEUhZTLYagIyW/RLyGAJ5t+bBFNil6AXMJTKyF/bTA
	dXbxkSO94dx7rTzeCkF6bTy8eEXu3/FPVNf5UydLvuuBhZKnlGtBUdeL9H1bS/dFZaIAcx
	6Y2BOr904z6ozEIx+fayvHaPo6VjAmE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-17-QNY9fUWvMhyVEyc-XuWPvA-1; Mon, 13 Jan 2025 21:18:28 -0500
X-MC-Unique: QNY9fUWvMhyVEyc-XuWPvA-1
X-Mimecast-MFC-AGG-ID: QNY9fUWvMhyVEyc-XuWPvA
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5d3f4cbbbbcso4851906a12.1
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 18:18:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736821107; x=1737425907;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nMiO78zk7MaHUEVJBvuQE73KBuKkV5ITS7yQXGCIoKg=;
        b=qD5VICbkjmGevOEGYXUBcmR7jYbFitL0IQlTmeERgPP6LfxDrLwFFrcmPSI0Bb/eEb
         T/zgz86rmJqQO37e5id7bGyQQkt7OmklYqh/hSw4NZbR6oM0EZCdcZK7vsbwCxgi4Lq6
         J3dRfpPzRJGzKeuhofJcEnRkojgSwqn4TbH+aDFt1m5LpQCLFc6b/Nu1RDXUALUvAjkh
         2ECzYIkB9c+YWwhVat+hQ6ekCLeSuBlBSAIxRZGND2/khf/1bGnxd0eiyuRaqsy+gElm
         Eaj/XDXTJ+sffeerkO7k6NSJVLRmNrWEy6t1/l6P5jMtGuwtROPWWp2isnCnzRzVwTeT
         i4hQ==
X-Forwarded-Encrypted: i=1; AJvYcCXS2G9JRfpLejSuKTNso1pPTxRcIhaHwrWnsGpYPUSThP/LxAW3woaO6oudDNpVmRVG6B4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJ5Hx7T8ZRTi4RppMkruswSwgh0jVqLSp8sStTACwGnR+m9yIo
	fVby/wbc5t/ftjxfMu03w+TlRZLMgXFwznuMgJnMfeqA4B4jFcz5WA/fHWLCmRdvBZbFZnAKWWz
	awheokhRfCzX5mTIpSY+uAI9QSJDLNHFKeAl4h6rd3HioCKXvd7GV4nmBuSI3dmpwaxymHm7h3L
	q/VI00WIVtwkMSFN0lyYjeTzxg
X-Gm-Gg: ASbGncu1WmMImUL9f/pFAzE5hBl2MnP7LR3h8KZTzb1aeX2ILf0iMte1CWMzEochHGW
	0LziwbwHcLDw6E8sUhnhVWujshX1ko2Y9uKsG/V0=
X-Received: by 2002:a05:6402:274a:b0:5d8:253:b7df with SMTP id 4fb4d7f45d1cf-5d972e48659mr21444178a12.27.1736821107568;
        Mon, 13 Jan 2025 18:18:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGwN87+SW/CJ0q5w+fFyKwkjmaOPTvcpYsKJ3Urzea1zeBUktcHwkxUS7fJj9IS1+DiptMQz+3daJxYmSuTs6w=
X-Received: by 2002:a05:6402:274a:b0:5d8:253:b7df with SMTP id
 4fb4d7f45d1cf-5d972e48659mr21444164a12.27.1736821107249; Mon, 13 Jan 2025
 18:18:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250111033454.26596-1-wh1sper@zju.edu.cn> <bae5ca72-c6ff-4412-a317-4649f2d09cdf@oracle.com>
 <481cd60a-d633-4251-bb53-d3026e005930@oracle.com>
In-Reply-To: <481cd60a-d633-4251-bb53-d3026e005930@oracle.com>
From: Lei Yang <leiyang@redhat.com>
Date: Tue, 14 Jan 2025 10:17:50 +0800
X-Gm-Features: AbW1kvYpBkzrOO9_Y543NCMNGVFyPvt5bcHTDPNALBdClEeextvc706FXuGRAh4
Message-ID: <CAPpAL=xC7+f_8V4D==JvZxs5X-CePa_VftOH=KDc8H1vPSNp9w@mail.gmail.com>
Subject: Re: [PATCH] vhost/scsi: Fix improper cleanup in vhost_scsi_set_endpoint()
To: Haoran Zhang <wh1sper@zju.edu.cn>
Cc: mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, 
	stefanha@redhat.com, eperezma@redhat.com, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Mike Christie <michael.christie@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I tested this patch with virtio-net regression tests, everything works fine=
.

Tested-by: Lei Yang <leiyang@redhat.com>


On Mon, Jan 13, 2025 at 5:20=E2=80=AFAM Mike Christie
<michael.christie@oracle.com> wrote:
>
> On 1/12/25 11:35 AM, michael.christie@oracle.com wrote:
> > So I think to fix the issue, we would want to:
> >
> > 1. move the
> >
> > memcpy(vs_tpg, vs->vs_tpg, len);
> >
> > to the end of the function after we do the vhost_scsi_flush. This will
> > be more complicated than the current memcpy though. We will want to
> > merge the local vs_tpg and the vs->vs_tpg like:
> >
> > for (i =3D 0; i < VHOST_SCSI_MAX_TARGET; i++) {
> >       if (vs_tpg[i])
> >               vs->vs_tpg[i] =3D vs_tpg[i])
> > }
>
> I think I wrote that in reverse. We would want:
>
> vhost_scsi_flush(vs);
>
> if (vs->vs_tpg) {
>         for (i =3D 0; i < VHOST_SCSI_MAX_TARGET; i++) {
>                 if (vs->vs_tpg[i])
>                         vs_tpg[i] =3D vs->vs_tpg[i])
>         }
> }
>
> kfree(vs->vs_tpg);
> vs->vs_tpg =3D vs_tpg;
>
> or we could just allocate the vs_tpg with the vhost_scsi like:
>
> struct vhost_scsi {
>         ....
>
>         struct vhost_scsi_tpg *vs_tpg[VHOST_SCSI_MAX_TARGET];
>
> then when we loop in vhost_scsi_set/clear_endpoint set/clear the
> every vs_tpg entry.
>


