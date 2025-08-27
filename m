Return-Path: <kvm+bounces-55878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E72FB38351
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 15:06:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 088E11BA24B9
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 13:06:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1DDD35207F;
	Wed, 27 Aug 2025 13:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="iMI+q5oa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595B631E112
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 13:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756299950; cv=none; b=uah9vLInk6Gmm0/ip5nRr6nv6/rTKceTKwK/Tj/gtrZxj74D9/DejKAOy/l1vgdz5bwBTiCMBJGjaM0sMBqeabP/1Gbp9eQCm/W3mZZJ6q4wZ2k/nUKHXEJIPxDT9uIPAwch6yqqqg1fdbuHIxh0cofYJqAQN4ec0IGDFvJOBbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756299950; c=relaxed/simple;
	bh=Lg5YJJaXpBc/s0JfoRj0Jz/sHkqXKEkjrx56oNdh6UA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KzC+A9LsJdXQf8GMPXiF6+JKE/+Kock+rKF75XtS8zNq4Ro+6i6+E8/hNP3aHfCmwFEp9mIqtc98DoZiF/lkkty3ZMUHrUbelMeFJ3mP06cs6aENz3BrZtSfXQlLekGyOEPCORveuJ4vlTFFOEpYdnCXOYPL44Kw9Z4IK0bgni0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=iMI+q5oa; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4b109c59dc9so88396711cf.3
        for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 06:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1756299946; x=1756904746; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IS9A1xArxW2DbHOyp5U7gUvufvKTYOF7Z8twNaozFaA=;
        b=iMI+q5oa4hKi016w+wiT6+ebiebiA6MW71fGyRmaONWPqmnhli1IgPAeJZNMJiq3Ra
         I5YNXHcaoaYIgNHMZieVcY13r+t9DUZrfH1fnbO+WHOG4ziU1UMidX73oiaDqaPMktDH
         Qfll2mqaGFkkgYlDOmZmqouUb9j2W/qnQn9ds=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756299946; x=1756904746;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IS9A1xArxW2DbHOyp5U7gUvufvKTYOF7Z8twNaozFaA=;
        b=RdTpka2sKbal2RfOfDxPOKgX9kf35RAsxYpfsMeRVUM2O33JabgW0ADRf9WdsGi2iJ
         GyNmVW7kRIxRbpMcXHHXkkwZiN/t+hAGmT+DPKZ87OYBn/pyM2lebBHUjsRqltQogSrf
         rhVIw3mGFwfluuukD3M9HRY+BQTa4z2ktdpQIRVWJOV1I66vcMgDl78/z5xn2yrmODWf
         LVuRs00Yk9mhjrJ1FUfgysEYQyLHlqCdFKEOwnB9KMjY2Qba6xzlx+rtUVozJrNKUC4e
         iUVxV62vZdIQXEAt57+c4SmNjUj/Nh1NYKAxkidT8rLScV5vCHDlnFsQ2keGQVUiQaj3
         ZJoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVl08/9m/1qzxbSmaHtfohrXu4akcUWJzV573zrknTkEPAcoZLcNlx0ufaSJ0uARNcCc+E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyC8I6LPMY0Vh3DugyyJzAPqn2X8qwz8JiBWRkt5oDJ4raqrkoj
	MRPRfgIJS7IHdG0VypeMwg7kTa3+yqLpvdi5KE/5vHaT9/rsqj231WD/PG9E7OLsC3dvGchWPFa
	TObM8NDzwNA9qfd3N8/Rt3AxhcIGE92ihLZan529NMw==
X-Gm-Gg: ASbGncvkz6XU6VT/UzLoLhbvwdZC4T6fmHzdkHFLQm0VZniLm/eCu5b+NXaWan8n9xE
	+L+nKPsKIibea2CzN30sg+cw/5U1u58Hnm53WLatmRcj6mcB1AQG6yJQBMd7h+9Xn95+Q9XxNeY
	wT4799/2peKXn0h/t5oQFf3LGpoECJef41OH/s4lMR+td1HR4F7M8zE9cB+NMVTUb4v8USnrpJz
	PUmZXlLtEWSnvzBgTRS
X-Google-Smtp-Source: AGHT+IGLeocHq+w8KKF32Jz+bx2Tk/02BB9NqaabL//OB62XP1A63lXRphuALAt/uyjA7/9UrZ1B5iZzrud5rKizpFo=
X-Received: by 2002:ac8:7d50:0:b0:4b1:1fc6:863a with SMTP id
 d75a77b69052e-4b2aab0cfa2mr202698391cf.63.1756299946002; Wed, 27 Aug 2025
 06:05:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <D5420EF2-6BA6-4789-A06A-D1105A3C33D4@nvidia.com>
 <CAJfpegvmhpyab2-kaud3VG47Tbjh0qG_o7G-3o6pV78M8O++tQ@mail.gmail.com> <1E1F125C-8D8C-4F82-B6A9-973CDF64EC3D@nvidia.com>
In-Reply-To: <1E1F125C-8D8C-4F82-B6A9-973CDF64EC3D@nvidia.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 27 Aug 2025 15:05:34 +0200
X-Gm-Features: Ac12FXzh4c9-bhOGpJCxyjBS2F9uSLYJUbMNbime6Sd-tJCzwd6Aonr7-j-nBrI
Message-ID: <CAJfpegtmakX4Ery3o5CwKf8GbCeqxsR9GAAgdmnnor0eDYHgXA@mail.gmail.com>
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

On Wed, 20 Aug 2025 at 22:42, Jim Harris <jiharris@nvidia.com> wrote:
>
>
>
> > On Aug 20, 2025, at 1:55=E2=80=AFAM, Miklos Szeredi <miklos@szeredi.hu>=
 wrote:

> > FUSE_NOTIFY_INVAL_ENTRY with FUSE_EXPIRE_ONLY will do something like
> > your desired FUSE_NOTIFY_DROP_ENTRY operation, at least on virtiofs
> > (fc->delete_stale is on).  I notice there's a fuse_dir_changed() call
> > regardless of FUSE_EXPIRE_ONLY, which is not appropriate for the drop
> > case, this can probably be moved inside the !FUSE_EXPIRE_ONLY branch.
>
> Thanks for the clarification.
>
> For that extra fuse_dir_changed() call - is this a required fix for corre=
ctness or just an optimization to avoid unnecessarily invalidating the pare=
nt directory=E2=80=99s attributes?

You see it correctly, it would be an optimization.



> > The other question is whether something more efficient should be
> > added. E.g. FUSE_NOTIFY_SHRINK_LOOKUP_CACHE with a num_drop argument
> > that tells fuse to try to drop this many unused entries?
>
> Absolutely something like this would be more efficient. Using FUSE_NOTIFY=
_INVAL_ENTRY requires saving filenames which isn=E2=80=99t ideal.

Okay, I suspect an interface that supplies an array of nodeid's would
be best, as it would give control to the filesystem which inodes it
wants to give up, but would allow batching the operation and would not
require supplying the name.

Will work on this.

Thanks,
Miklos

