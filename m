Return-Path: <kvm+bounces-53853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C621B18831
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 22:36:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B8C7116F924
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 20:36:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 826A220B7EC;
	Fri,  1 Aug 2025 20:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TkdlXd+q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964A015539A
	for <kvm@vger.kernel.org>; Fri,  1 Aug 2025 20:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754080607; cv=none; b=l5RqrM5+k14oLBWziN74Eb/rcAt81bJBySIU/ReJD0dPq4cHXrpDp2XPQh/qsBeFnp/VdjkBL83edh6iAs6tyDO1SjAMO9JS6v9ioHlV+uhfYopsz3Go/E0NhwCSmyg0MzkenVBF+lOceA/6yDhPpFEcRc0tJ66chkT8vvw5G2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754080607; c=relaxed/simple;
	bh=ft1GtVlHTumH5n9zAoqypec1LBFsX5MTL+yaj3JjcSc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U5rTrHm3J7QfuimLR8kFdfwEE9nWUdcwdlqRGrOcS4Mpz9vgwJ4JILy2FyEy82ZYMdolIl5tejIHCrNw7u/AkWcYyCKvL66E9P1Qh2+gyuseiNfdQTw1q/x3H2oE4hsc5q+QbgeQOottfuUSVYSHYHhOYa8Shp3VZskDW63N9Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TkdlXd+q; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-61592ff5ebbso4343094a12.3
        for <kvm@vger.kernel.org>; Fri, 01 Aug 2025 13:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1754080603; x=1754685403; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QXkdEcm3dcCFEHiiyHz9se6bX6iRUxFV0EivrOFS6/U=;
        b=TkdlXd+qNWy1ZqEENZcuxY10mbd9g87g0MFrtrVNH5XCP+JBm9itWNeC6coJY6cvkq
         l3ChH2+vFmr3DuEiHgOMXbrahIH0D4u33UZC+IVmFQy0eJ7bEAaU994OCV1PGkG5IIfu
         jI6qbu1XG4h39nZ/mChGwldCuRZUtEOwBVb1s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754080603; x=1754685403;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QXkdEcm3dcCFEHiiyHz9se6bX6iRUxFV0EivrOFS6/U=;
        b=u6047/e696+FA0jHn+FzBXbO/YPy+4N8ZGZFO6WVC5McV4tiZgQIZqd9uVpoYRtxMq
         DODds9OawYjP+RnBSZ9b90nI7y/q++vGlSiiY4vxYCjJxMGiA6CtBKMhumddcD2ydnLX
         Qthr84ejefR49w5LNQWLnFmYlSoYy3eDHxcq8IfInOcnw1ULAaY7wadytRDZtvNN6f3W
         963SiXNywrRWxMlKLlp8zsGkVMlJ5r1U9a1V/aGODuc4ZcHduQFyL13rY55Ax/0u+/5W
         iAaEoKziTLtZA5RX+PTLiSs7q4mMzNt6//rAB6Aj7/ZdAPj2pzef9nhEPTlM0SHMrPkS
         3YCQ==
X-Gm-Message-State: AOJu0Yy37zoPWn5QmPIk73Zg6K8pDyqh3fGx2QG1qjggrYjn2Xe9NBbC
	YO/TMHCZWzySlTILNfMJvZOYORak8sO4bQgeH78wKou7DplK6y3l6czGBsRTZp/dr7cnRHsYDQv
	3L9GFdKk=
X-Gm-Gg: ASbGncuYTee1XcocgjDSRO5jM0Uv/7TOmVAGGKUoBusXi/uoJrUpR++yJQ56+Yuq/uk
	tjhWGuaaCBvqJWYfyJQcqr32PI1c80Qv1+BaFGZDsEelPv3LpS0DlMf7mDct1S4WazUexR1m6Ku
	7Jl7zn6RcqxffzVKleyR58K4lIzQuXA7SsfytYmqacvcaPjd2SN5RYUBV7vFNOcgayzAMXiOMQd
	Uq/wWKYDndogCLwiuUJKfKNGIDwaHJrsdr+Xvl7xaJng8isAu0F0K8XKHWYBboCEI/mXoIEO7r8
	c9JGkyCPthq6b6kJkiEjpIG5q+Pxa3wDtMDFXlwo24HhTJ9emV4LuOh0W5fBb8J91fB/uww7LSp
	MC0xSWu964S4Q4OfTXr8wzCv+qrUYOspGZf+iTN57liZ4V4DSrXgMnsiVitqTZClHPdmKYSvM
X-Google-Smtp-Source: AGHT+IFck6LFGilIHZubNhURHVrswTQrAGo2WUbQpj3lZXvHuIqoDLDq6gzwlA2epxBctZ3khoGjcQ==
X-Received: by 2002:a05:6402:2790:b0:615:cc03:e6a2 with SMTP id 4fb4d7f45d1cf-615e6ebec77mr580802a12.1.1754080602768;
        Fri, 01 Aug 2025 13:36:42 -0700 (PDT)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com. [209.85.218.44])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615cc38ae55sm1699313a12.10.2025.08.01.13.36.42
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Aug 2025 13:36:42 -0700 (PDT)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-adfb562266cso414876966b.0
        for <kvm@vger.kernel.org>; Fri, 01 Aug 2025 13:36:42 -0700 (PDT)
X-Received: by 2002:aa7:cb0d:0:b0:615:8012:a365 with SMTP id
 4fb4d7f45d1cf-615e715f7a6mr469886a12.25.1754080158122; Fri, 01 Aug 2025
 13:29:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250801091318-mutt-send-email-mst@kernel.org>
In-Reply-To: <20250801091318-mutt-send-email-mst@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 1 Aug 2025 13:29:01 -0700
X-Gmail-Original-Message-ID: <CAHk-=whgYijnRXoAxbYLsceWFWC8B8in17WOws5-ojsAkdrqTg@mail.gmail.com>
X-Gm-Features: Ac12FXxywlhxHC92NneGnmmt5Hm9rlPrKO5mJOfIsb2I5ZMf5olIOr9KL1pDLfc
Message-ID: <CAHk-=whgYijnRXoAxbYLsceWFWC8B8in17WOws5-ojsAkdrqTg@mail.gmail.com>
Subject: Re: [GIT PULL v2] virtio, vhost: features, fixes
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	alok.a.tiwari@oracle.com, anders.roxell@linaro.org, dtatulea@nvidia.com, 
	eperezma@redhat.com, eric.auger@redhat.com, jasowang@redhat.com, 
	jonah.palmer@oracle.com, kraxel@redhat.com, leiyang@redhat.com, 
	linux@treblig.org, lulu@redhat.com, michael.christie@oracle.com, 
	parav@nvidia.com, si-wei.liu@oracle.com, stable@vger.kernel.org, 
	viresh.kumar@linaro.org, wangyuli@uniontech.com, will@kernel.org, 
	wquan@redhat.com, xiaopei01@kylinos.cn
Content-Type: text/plain; charset="UTF-8"

On Fri, 1 Aug 2025 at 06:13, Michael S. Tsirkin <mst@redhat.com> wrote:
>
>         drop commits that I put in there by mistake. Sorry!

Not only does this mean they were all recently rebased, absolutely
*NONE* of this has been in linux-next as fat as I can tell. Not in a
rebased form _or_ in the pre-rebased form.

So no. This is not acceptable, you can try again next time when you do
it properly.

            Linus

