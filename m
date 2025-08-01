Return-Path: <kvm+bounces-53856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A753B18895
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 23:15:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8BDE2179A56
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 21:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BC2A28E574;
	Fri,  1 Aug 2025 21:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ed3tS5hV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811531E32D7
	for <kvm@vger.kernel.org>; Fri,  1 Aug 2025 21:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754082928; cv=none; b=WYLoJnvXpMzW+r0nmFUabEYN82eJHERgIqjKXt2gQZIVY/SSJ/T2orXB35K9swDgxArx0/DIBkMFeiI9COqMYpS0a5M8be+pDv3+0kwiRgAOfcap+jHqrCuX84tVVuXAiW3Lv7LHt8EnL6SeUklAC6zwo/G2cRLISuWCzlwfpho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754082928; c=relaxed/simple;
	bh=8Kri1HoPuh6lwB0F7qiPiOrJzYKY+av4+R1JiwsLGGY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GzLPm5hmJqLVFLZcv8cIKmettt7kQKu5o2V3ojD+dDCKwkVvWY+tdgtf/B7wliUwUUVUs1JRJBb6dHbYB1V29JGIc+vbKlA7sbpjjC2ic0UxpeWN9i2AezaXi84kBMsEotED/Su37oWBOcBMSrq/ESqqI4PO0UCHPTgJUZsELoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ed3tS5hV; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-61592ff5ebbso4387013a12.3
        for <kvm@vger.kernel.org>; Fri, 01 Aug 2025 14:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1754082924; x=1754687724; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BOAZkZ18mJY5AP4pAaTQp2Y2a24YFEEDzHLPHw5UlIc=;
        b=ed3tS5hVmqg27kcwp9asyn8v6l8kjsZbFtV+T/31MD/k+8EI8GJab5hp0BiLkK67Jw
         /JGfBr2tm9hlPX8uLLEANRha18elStyH2x8Y0ayiNjPefui5stg4D8CobI3v5UMqvqb6
         9wzLq52cMIgUVO7W1+9G/LhRjXzuVqDZAiWoE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754082924; x=1754687724;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BOAZkZ18mJY5AP4pAaTQp2Y2a24YFEEDzHLPHw5UlIc=;
        b=oNdrXimnWo7i2iNaZj8k4D6Rk5k5QAZ0QAFzxZB00n8M7wMXo6BdlZcjVITg3t2MlP
         z+z7TJHCgsX/1wyrWUBeEVa3V85c3Pfl87mZ1mKI713KiJjXMbJFdtlFsxyrHVt+RmhR
         +ZIDLkofS3Lril8t+xFaohWBC5KK7tuCoLOqfYtW2UzK5jEjonjxTm17DazVY7wJOghi
         14zrz5AHauTQK0jH2J5ebeuKO8qJO/K1UUJyKyOjSqvQACenqcb8/W+nvswUj1xEg+/X
         yklOgKRCdH8yf2j3s01Lh0zB3ecfgiPxYaAgS7EcH2z5Kyx1invapcII9WOArPd5+kEf
         sj8A==
X-Forwarded-Encrypted: i=1; AJvYcCV0Xlcg8MHJ+i+q6Cagt5Ugia2tg9xyTuZnUHClK1DLh1CH3eM+ORepmPsCyvvHnJALn0g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yytn2rQj/trAX9V+HI++9NLwRKxe+ZgiJ1fezDGYmKRmoaLIGYA
	ii2FcFNahLJG9h0JKSST7LDIUsvbaSuDlhLxRYXgXIOF/SXdgHzEK3LkCSvbmFaQ2b3lYUTrt2u
	CRXYT33o=
X-Gm-Gg: ASbGncvts53SUtO8wgRJvd1lKaxEMl8BC+8iWwiUZszvSDX9lZaGyWMNvBaQ/fST6iT
	d2CDAGUYQv/95AnXCmkNAEYENEjeWQwt2NQn/7sjovL3GORfpXPOmZ0RIKJXrS3RYsZ85PLYLyh
	JdZCeKT+GnnTCB+T4F0SAVATRKUd04a8WtuxjxP8FKUQQEJ2dRmIz75oWwmZQm6TqlPum/eB+bp
	oZI+zwtzU44c+am8KIp3DytYJAx8q6bfC+jN9WgyYpngHrzRZqnm/qXzXGmN2sSPKvJBVSv0oEi
	88iy4gDYtXewzh0YH5z7hxeLHBjmzhwLh1iAgRoZ9L2HwrzdQpb9ENIg9ZWtSOSaHXcBbzbQiAu
	jfeVcQRNoEelqb7hYL7aNpFVVyQuRIeS0IPnekxL1u8X75l3EdVZ90kLijVblTw/upIosHzfT
X-Google-Smtp-Source: AGHT+IEsLgae0KkIawVhGRJBRqFBAVHp4XKm8hsXefBqs6bS6Dl1pu1dOW5dTi9b9iCcQEm9/hLUQQ==
X-Received: by 2002:a05:6402:4305:b0:615:7fd8:d959 with SMTP id 4fb4d7f45d1cf-615e6edf033mr652070a12.10.1754082924431;
        Fri, 01 Aug 2025 14:15:24 -0700 (PDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615a8fe7995sm3207590a12.36.2025.08.01.14.15.23
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Aug 2025 14:15:23 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ae360b6249fso469798166b.1
        for <kvm@vger.kernel.org>; Fri, 01 Aug 2025 14:15:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWl2dJmz9H6xCp1o/7fxTo2kHH0Brauc8eGf3nyjwg9BZuhSpUGQtMLT2fLi54CxTMeU/U=@vger.kernel.org
X-Received: by 2002:a17:907:3f99:b0:ae3:6657:9e73 with SMTP id
 a640c23a62f3a-af9400844fbmr144333466b.20.1754082923387; Fri, 01 Aug 2025
 14:15:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250801091318-mutt-send-email-mst@kernel.org>
 <CAHk-=whgYijnRXoAxbYLsceWFWC8B8in17WOws5-ojsAkdrqTg@mail.gmail.com> <aI0rDljG8XYyiSvv@gallifrey>
In-Reply-To: <aI0rDljG8XYyiSvv@gallifrey>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 1 Aug 2025 14:15:07 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi1sKCKxzrrCKii9zjQiTAcChWpOCrBCASwRRi3KKXH3g@mail.gmail.com>
X-Gm-Features: Ac12FXxTQNyMa37gD218OICz8yv-5X8AXqC2OjqDUUC5iyMABu84wbERpHpCWcY
Message-ID: <CAHk-=wi1sKCKxzrrCKii9zjQiTAcChWpOCrBCASwRRi3KKXH3g@mail.gmail.com>
Subject: Re: [GIT PULL v2] virtio, vhost: features, fixes
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, alok.a.tiwari@oracle.com, 
	anders.roxell@linaro.org, dtatulea@nvidia.com, eperezma@redhat.com, 
	eric.auger@redhat.com, jasowang@redhat.com, jonah.palmer@oracle.com, 
	kraxel@redhat.com, leiyang@redhat.com, lulu@redhat.com, 
	michael.christie@oracle.com, parav@nvidia.com, si-wei.liu@oracle.com, 
	stable@vger.kernel.org, viresh.kumar@linaro.org, wangyuli@uniontech.com, 
	will@kernel.org, wquan@redhat.com, xiaopei01@kylinos.cn
Content-Type: text/plain; charset="UTF-8"

On Fri, 1 Aug 2025 at 14:01, Dr. David Alan Gilbert <linux@treblig.org> wrote:
>
> My notes say that I saw my two vhost: vringh  deadcode patches in -next
> on 2025-07-17.

Oh. My bad.

My linux-next head was not up-to-date: I had fetched the new state,
but the branch was still pointing to the previous one.

My apologies - they are indeed there, and I was simply looking at stale state.

So while it's recently rebased, the commits have been in linux-next
and I was just wrong.

                Linus

