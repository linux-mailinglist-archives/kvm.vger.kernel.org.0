Return-Path: <kvm+bounces-13842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61E2A89B7B2
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 08:36:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D63A1C215D1
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 06:36:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50730182AF;
	Mon,  8 Apr 2024 06:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gooddata.com header.i=@gooddata.com header.b="PiVHLjsZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E386514294
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 06:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712558159; cv=none; b=GHD/ZAZVdOVQVz1T/zuPV871WRENzk3h4uS6pRnX3Kbfx3wvJEhu4sn7K8XteG+PS3PjniA+SzSUR1JgMvA7om/ZxF68HLyuC40qWgln+lAOKXaeNE7Nnm9bOXHi7oHKQQFf6J8nRtDRtoLRDy7dMEPFMomGIDBoRmy0oJ2nlO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712558159; c=relaxed/simple;
	bh=GB58bQle6/TE9XhpcBSQjj6cikX2bR8e+VuUWv1u+SE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aLcWx+MfAlOgzqSnrxC+oq9rImNBtwFtXf6VdJp7CSBhNSwaZaktcGO1scRdtTTmiUJVC+GKRNZ9f+HB/udznEG9KCaLaxG3SI/AbpDachxeyzd/0F5DeIwZhFNvQeea/rusU40Hla311AiHggN8GvQH95J6up2DiC59tj8xcJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gooddata.com; spf=pass smtp.mailfrom=gooddata.com; dkim=pass (1024-bit key) header.d=gooddata.com header.i=@gooddata.com header.b=PiVHLjsZ; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gooddata.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gooddata.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a51b008b3aeso225557666b.3
        for <kvm@vger.kernel.org>; Sun, 07 Apr 2024 23:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gooddata.com; s=google; t=1712558156; x=1713162956; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GB58bQle6/TE9XhpcBSQjj6cikX2bR8e+VuUWv1u+SE=;
        b=PiVHLjsZEyeApXJdxfGALGW1z5oS6aYyaXctRE2Yw88k3GCEQRr0DWo4ofr3+E7Gr/
         BLPG5DGcdsH4vKrkjleF++t9NcXJJWH+dbtA/dioTBSUrh5Qu2eLen0P0C2e6EHXgG8k
         woehRemp38+VRVkmmpP/NMXh8NpEm6KRyDU/Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712558156; x=1713162956;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GB58bQle6/TE9XhpcBSQjj6cikX2bR8e+VuUWv1u+SE=;
        b=hzQrOkWsfKo+NcLi9di4f+G3T3RHpw3Y8fH+kjdGfGmOz/NUwUtaCAYbSeuU5ncZQm
         WwEGW+xoch3Qn/wVW+pUD+1PUEmAk/mUz4OldlYe+lM8fVWhTwQovOBVtBov+BTp2Bbh
         2chnBbg/s5kEF1z879N7KcX5sr+DLggkVDB9d91KawR9eLjYM7C09ovmNgbgab6mMDUY
         UcKeU8IjQXRsD3ZNovpOQUM8sftoUC9r2TmIN9rQ4TE5xqOOSpG0lpPQmb599WDMi40A
         SekknB6NUiupz0vmIxaZK52FVqlJKmBjAfPXf9XN8gzJjwXTPNiM9phpc6i1K02K2IM+
         DxaA==
X-Forwarded-Encrypted: i=1; AJvYcCUJ0bzR4l5ScDMkVsJEQ3gTP/YNyExeHQMCn6srD/85wR9SLWmPQavURCXYoMtGW5G6kY9lfKlxV4vylRzbJ0ZyMP3F
X-Gm-Message-State: AOJu0Yxpr8bmbIo8pqpJzXIru6JNzZ6rdYVA9kGDKodqqFO2X31GRsAM
	0nHlu23z0JeKfxuG4ooEwwsPE7v7rU/+ETNK4knx7EtqrunOIfjbP94r3Ha5Ue94zEK9opVYBsV
	yHUDk4pF70NlOXyqcB0md+DXkIMo5QKyvXSac
X-Google-Smtp-Source: AGHT+IHgOG1QFRsazaJJTQAM1OpfXlCUvvdH9XD6u9F4YJ8KIuAm8siPgnu/FFrnysbhWv7Ny+9JXK+VCjeK9WS7Rgs=
X-Received: by 2002:a17:906:565a:b0:a51:9737:f23d with SMTP id
 v26-20020a170906565a00b00a519737f23dmr4595803ejr.70.1712558156369; Sun, 07
 Apr 2024 23:35:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+9S74hbTMxckB=HgRiqL6b8ChZMQfJ6-K9y_GQ0ZDiWkev_vA@mail.gmail.com>
 <20240319131207.GB1096131@fedora> <CA+9S74jMBbgrxaH2Nit50uDQsHES+e+VHnOXkxnq2TrUFtAQRA@mail.gmail.com>
 <CACGkMEvX2R+wKcH5V45Yd6CkgGhADVbpvfmWsHducN2zCS=OKw@mail.gmail.com>
 <CA+9S74g5fR=hBxWk1U2TyvW1uPmU3XgJnjw4Owov8LNwLiiOZw@mail.gmail.com>
 <CACGkMEt4MbyDgdqDGUqQ+0gV-1kmp6CWASDgwMpZnRU8dfPd2Q@mail.gmail.com>
 <CA+9S74hUt_aZCrgN3Yx9Y2OZtwHNan7gmbBa1TzBafW6=YLULQ@mail.gmail.com>
 <CA+9S74ia-vUag2QMo6zFL7r+wZyOZVmcpe317RdMbK-rpomn+Q@mail.gmail.com>
 <CA+9S74hs_1Ft9iyXOPU_vF_EFKuoG8LjDpSna0QSPMFnMywd_g@mail.gmail.com>
 <CACGkMEvHiAN7X_QBgihWX6zzEUOxhrV2Nqg1arw1sfYy2A5K0g@mail.gmail.com>
 <CAK8fFZ6P6e+6V6NUkc-H5SdkXqgHdZ-GEMEPp4hKZSJVaGbBYQ@mail.gmail.com>
 <20240404063737.7b6e3843@kernel.org> <CAK8fFZ5LHFMPAOFCKu-vr7JQJHKo9jshrgvCCP50d596nFiXUQ@mail.gmail.com>
In-Reply-To: <CAK8fFZ5LHFMPAOFCKu-vr7JQJHKo9jshrgvCCP50d596nFiXUQ@mail.gmail.com>
From: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Date: Mon, 8 Apr 2024 08:35:30 +0200
Message-ID: <CAK8fFZ74tj=u5HKfpFue1ejy_9V3xWdf-ekC0gLt8BmJs7Y5ZQ@mail.gmail.com>
Subject: Re: REGRESSION: RIP: 0010:skb_release_data+0xb8/0x1e0 in vhost/tun
To: Jakub Kicinski <kuba@kernel.org>
Cc: Jason Wang <jasowang@redhat.com>, Igor Raits <igor@gooddata.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=C4=8Dt 4. 4. 2024 v 20:17 odes=C3=ADlatel Jaroslav Pulchart
<jaroslav.pulchart@gooddata.com> napsal:
>
> =C4=8Dt 4. 4. 2024 v 15:37 odes=C3=ADlatel Jakub Kicinski <kuba@kernel.or=
g> napsal:
> >
> > On Thu, 4 Apr 2024 07:42:45 +0200 Jaroslav Pulchart wrote:
> > > We do not have much progress
> >
> > Random thought - do you have KFENCE enabled?
> > It's sufficiently low overhead to run in production and maybe it could
> > help catch the bug? You also hit some inexplicable bug in the Intel
> > driver, IIRC, there may be something odd going on.. (it's not all
> > happening on a single machine, right?)
>
> We have KFENCE enabled.
>
> Issue was observed at multiple servers. It is not a problem to reproduce =
it
> everywhere where we deploy Loki service. The trigger is: I click
> once/twice "run query" (LogQL) button by Grafana UI. the Loki is
> starting to load data from the minio cluster at a speed of ~2GB/s and
> almost immediately it crashes.
>
> The Intel ICE driver is in my suspicion as well, it will not be for
> the first time when we are hitting some bugs there. I will try one
> testing server where we have different NIC vendor later.

I run the setup on a server with a different network card than E810, I
used BCM57414 NetXtreme-E + driver bnxt_en. The issue is not
reproducible there. So it looks to be connected with Intel's ice
driver for E810 network card and introduced in 6.3.

