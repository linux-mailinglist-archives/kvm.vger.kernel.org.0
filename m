Return-Path: <kvm+bounces-13593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 773FE898DD8
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 20:18:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2100A1F2341C
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 18:18:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22DB5130A69;
	Thu,  4 Apr 2024 18:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gooddata.com header.i=@gooddata.com header.b="ZoXjvpzB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C5812FB2C
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 18:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712254692; cv=none; b=n4YLVqf/V3ZcBW6vjx79Xxa61apldjAkhRBh2VUBZ9w3pqpVLSVtheDi2Zh4VxPuTd9kByn6IdBI928Gu/uFX0XpaMz+kchUE6W5qBC8ukI4Qw0pGkVBfsY/TB+ptcFWcL6ZuJbQ874IDuoXBpXOsoyJH4bQx7z3cPpCCoCKku4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712254692; c=relaxed/simple;
	bh=SNfX+q1IgkQj9nz0GckYsepusnw34MhTeimF85l/VUU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iKoNUf+OTCGDl3rFNnJFClzvMvijJKvJddaEFUePT2+w2Zz5MvRghDwNA2in9ysaqtXAllN3Zsnt503uuSjQ/UGylF6q4VduZ1HaYlQRmygQHxveOjbOZDg0+QkmOYoFaEVE+isQm91OcbvUzS0xd6Cfb6xzZpqNbKFHct0d3qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gooddata.com; spf=pass smtp.mailfrom=gooddata.com; dkim=pass (1024-bit key) header.d=gooddata.com header.i=@gooddata.com header.b=ZoXjvpzB; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gooddata.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gooddata.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a4e62f3e63dso171407066b.0
        for <kvm@vger.kernel.org>; Thu, 04 Apr 2024 11:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gooddata.com; s=google; t=1712254688; x=1712859488; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SNfX+q1IgkQj9nz0GckYsepusnw34MhTeimF85l/VUU=;
        b=ZoXjvpzB9O8q4mfd/1iHNRmoPQzRmvOm5UrT/TbbrdDvZid338252P+r5DtUe2ivVE
         bFczjWVKzvxbSSgrP+bK9fIIwS5AWyxOgGpctra+EuVcgnkNsE0v3amei6rcvlFXeuRO
         G6Qw3Gz780oyiUl5zx82bVklcEc7YsLgHipDU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712254688; x=1712859488;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SNfX+q1IgkQj9nz0GckYsepusnw34MhTeimF85l/VUU=;
        b=f5Yj5x1Xe9CDjgni+uUYTbnUy8A/PJ+m3GsdYkPM56BdLkbuI4khTjARRGzlLAafjl
         S+uBpKGHEMgCmxUmr2webps0qT56Q0MWKkFTrynexiQBXYlvQUNa9EG8jX/GN6rvQ5ll
         lMizUnQqVOGUBNKR0XtCgvFTZ/WM0X54lxupXz4HeXBtTWMvGLMaGKFh3CfErz+J/NyA
         uQzJT7JrTi4EEGKfrUgXaPszG2117BcC7k+zqtOdvdoqGP7//CkpBKsCMOBTxIP0fzyV
         Ol9/A7LMx+Yyfc8B6hQOqqRILrkSnaUx/BqnD3EhrWFj/ZC+VAXpKd7Kzd4wiW3+pLwC
         /nFg==
X-Forwarded-Encrypted: i=1; AJvYcCWZWnpNmqwGGUbHn1IfSuQkZWGuaRJpvWgwPBC7gVNlfQSX9SyQbqGoxU48aCMKrSxJvNyhmQg89/58J9387yrDD/ng
X-Gm-Message-State: AOJu0YyGYW6RNBXaTJDPjzUclBOZpDL6LS1XG4Ptf23ISI1P7HBpRxMA
	dxQCCC2YVAGnCAF7rlLu2+fW/XZMu4tpz8pyIy1IKBF5uJ3cTPDnYUycqJbtxoSc90ZNapLBhvf
	rwY+DudDLzOBjkZPcmn8gVX+dRA7G+1zkb5eb
X-Google-Smtp-Source: AGHT+IFs1ZK7fW9vhtx+DT4doL6b7bsFLXc6+FeNlebBKgAPxl18h2/KgaTIEGprqn2OnYYpU3mldzZYNuXXB6RyHE0=
X-Received: by 2002:a17:906:d0d6:b0:a4e:62b3:6264 with SMTP id
 bq22-20020a170906d0d600b00a4e62b36264mr271865ejb.76.1712254688003; Thu, 04
 Apr 2024 11:18:08 -0700 (PDT)
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
 <CAK8fFZ6P6e+6V6NUkc-H5SdkXqgHdZ-GEMEPp4hKZSJVaGbBYQ@mail.gmail.com> <20240404063737.7b6e3843@kernel.org>
In-Reply-To: <20240404063737.7b6e3843@kernel.org>
From: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Date: Thu, 4 Apr 2024 20:17:42 +0200
Message-ID: <CAK8fFZ5LHFMPAOFCKu-vr7JQJHKo9jshrgvCCP50d596nFiXUQ@mail.gmail.com>
Subject: Re: REGRESSION: RIP: 0010:skb_release_data+0xb8/0x1e0 in vhost/tun
To: Jakub Kicinski <kuba@kernel.org>
Cc: Jason Wang <jasowang@redhat.com>, Igor Raits <igor@gooddata.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=C4=8Dt 4. 4. 2024 v 15:37 odes=C3=ADlatel Jakub Kicinski <kuba@kernel.org>=
 napsal:
>
> On Thu, 4 Apr 2024 07:42:45 +0200 Jaroslav Pulchart wrote:
> > We do not have much progress
>
> Random thought - do you have KFENCE enabled?
> It's sufficiently low overhead to run in production and maybe it could
> help catch the bug? You also hit some inexplicable bug in the Intel
> driver, IIRC, there may be something odd going on.. (it's not all
> happening on a single machine, right?)

We have KFENCE enabled.

Issue was observed at multiple servers. It is not a problem to reproduce it
everywhere where we deploy Loki service. The trigger is: I click
once/twice "run query" (LogQL) button by Grafana UI. the Loki is
starting to load data from the minio cluster at a speed of ~2GB/s and
almost immediately it crashes.

The Intel ICE driver is in my suspicion as well, it will not be for
the first time when we are hitting some bugs there. I will try one
testing server where we have different NIC vendor later.

