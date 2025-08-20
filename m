Return-Path: <kvm+bounces-55106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50AE1B2D737
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 10:55:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 440DE16BE87
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 08:55:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42BCB2DA767;
	Wed, 20 Aug 2025 08:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="WT4bqIBs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39BF2D9EDB
	for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 08:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755680127; cv=none; b=aPkntZoLDdfOO7ZwdK6gepFhuq73JOOhTz6195LYmy8WhlEFPGq45Kbgw3pJxb6bIdyPkRqeW5kgb8xMghrP7AiJj9xzza3L4RgmXrjc9tR3kGV6+DMUey9xnSPsfCTy1TSgQYR+gfy3ryVFdpifruOxyZjLrJMAjwk4WcHcP30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755680127; c=relaxed/simple;
	bh=iR+hp7xjDohlk4uLKSCKHyRXgQV+E/1v3D9EcSrOhN0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JQOIwCD/efIjlqFVmNeRgQjQ3NwepzBqMoJumaY+GrWI7DZUt5x7m6ioKP2z/x3pDYWJKpzfrPtBG24in1E1bWdgNpEZyXbQa9YGa99po8P6Rjc0r70157g5p46IhGwHEwyKqILHz31Ja5sBNeYZ+ZIbrOUEihTbJ+dY4gQrTj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=WT4bqIBs; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4b134aa13f5so39928711cf.1
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 01:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1755680124; x=1756284924; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=prBdbd5IwT0l6EaL1JkN4d71dM3Y9IcSn9RyaijIepg=;
        b=WT4bqIBsnr+/XLgoFcOejJYaJFknO2gM+YnGl5gSykq5+lbwzy9FPM1NWzbBlReqA+
         gU8p6b6lnmeDdZshBm7iRHkHWAm2Pc2dUI5iTdYtBUn9SLH3w20UKzfiqtIdB4gdITXw
         hxbReZtroFYjaWkMLDBVt3wlaDngcirqUq4IQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755680124; x=1756284924;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=prBdbd5IwT0l6EaL1JkN4d71dM3Y9IcSn9RyaijIepg=;
        b=PQBY19uo+OF0TBP1LEENOuG+mxCK2Vlt26dRbey9sqWuVjB2OyNLD1TDr7gLOmN+Zw
         LXh1urNhqoRBOtz7e9oF0sOU8AdyckTJPU1qxpgQovI5iIvZZtEmm3hnZeWMxGfI7eX7
         WX/eoxyo56d1ORZuXwwxRN00OgLyz6m4Fo52GCMzyDyEZQ6hVl/AGkWtzKG1w6XpYckh
         I+aFt/PwQ8Zj2f1sr66w8mWjSwdk4ps08Zt9N/BN+ilwlYVxkZjES03msFSDDB9vDeAO
         HI2MKRdXkmH1x7XhUgqKZVPG2w4PASE3KGYQ/C2KuXetp4Rp21/YVikDPpQ4c3DcVdj9
         agHw==
X-Forwarded-Encrypted: i=1; AJvYcCWhFx/koEeWmSfFqX2/OmqDXEqITkXYsIfte1qZ+p/yVfeyMFoVUVlWymWdTxcxGy5f5XI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWGQ5L5T6N4Gu6ZmlrtimmiimM2j9eCUDWEUGWs5pD9SogJyYj
	im56GCqzGad7GwWPGnXI/FaVUUcDbzA46dlYztcwK0GgqyDkPZcNmU74kVMXw+aE1+0vqs6W+1q
	tyfCx6EeTlrbOV27JIfvd7I+R7Ywv/g8dwVJm8eCRMw==
X-Gm-Gg: ASbGnctrN5C3KVKtU0shJ8fSOws3JwsyKwZw3C/yOpMwezJU0/kc8HPt5QQAvdxAwuK
	jdiXUnN3at8MMd67gX7UC/tsDhF6tEipfl1XkWlaLILGzBZOlLO7FeQm6wTqjKyZSbbc2cBGWnF
	OhY1MZIf6tFArGIE7pO9TwQumJl7nk8JoBJzDU9vmINnWr8aZDQerCYNSEzcHQcDwGa39K0D/Wr
	giwU4gV+w==
X-Google-Smtp-Source: AGHT+IE9amIH8vBvDkdrmFCBMvx46Trt8+B/hM/ooS8/9+69L7vKMWavOQFjcJ0LSDyTfdtowVCQkWdhAiN053eMzys=
X-Received: by 2002:a05:622a:11d3:b0:4af:1535:6b53 with SMTP id
 d75a77b69052e-4b291bbdfdfmr24247191cf.54.1755680124542; Wed, 20 Aug 2025
 01:55:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <D5420EF2-6BA6-4789-A06A-D1105A3C33D4@nvidia.com>
In-Reply-To: <D5420EF2-6BA6-4789-A06A-D1105A3C33D4@nvidia.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 20 Aug 2025 10:55:12 +0200
X-Gm-Features: Ac12FXyUk9U2BD5ab17RBeP0LlcO6BAKZygfWvTdoZSnBgGcz8gaw_tlQOpNzxU
Message-ID: <CAJfpegvmhpyab2-kaud3VG47Tbjh0qG_o7G-3o6pV78M8O++tQ@mail.gmail.com>
Subject: Re: Questions about FUSE_NOTIFY_INVAL_ENTRY
To: Jim Harris <jiharris@nvidia.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "stefanha@redhat.com" <stefanha@redhat.com>, 
	Max Gurtovoy <mgurtovoy@nvidia.com>, Idan Zach <izach@nvidia.com>, 
	Roman Spiegelman <rspiegelman@nvidia.com>, Ben Walker <benwalker@nvidia.com>, 
	Oren Duer <oren@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 20 Aug 2025 at 01:35, Jim Harris <jiharris@nvidia.com> wrote:

> Can we safely depend on the FUSE_NOTIFY_INVAL_ENTRY notifications to trig=
ger FORGET commands for the associated inodes? If not, can we consider addi=
ng a new FUSE_NOTIFY_DROP_ENTRY notification that would ask the kernel to r=
elease the inode and send a FORGET command when memory pressure or clean-up=
 is needed by the device?

As far as I understand what you want is drop the entry from the cache
*if it is unused*.  Plain FUSE_NOTIFY_INVAL_ENTRY will unhash the
dentry regardless of its refcount, of course FORGET will be sent only
after the reference is released.

FUSE_NOTIFY_INVAL_ENTRY with FUSE_EXPIRE_ONLY will do something like
your desired FUSE_NOTIFY_DROP_ENTRY operation, at least on virtiofs
(fc->delete_stale is on).  I notice there's a fuse_dir_changed() call
regardless of FUSE_EXPIRE_ONLY, which is not appropriate for the drop
case, this can probably be moved inside the !FUSE_EXPIRE_ONLY branch.

The other question is whether something more efficient should be
added. E.g. FUSE_NOTIFY_SHRINK_LOOKUP_CACHE with a num_drop argument
that tells fuse to try to drop this many unused entries?

Thanks,
Miklos

