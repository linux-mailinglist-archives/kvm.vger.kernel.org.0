Return-Path: <kvm+bounces-17600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4C668C8758
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 15:37:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5AF41C214FA
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 13:37:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 825465491A;
	Fri, 17 May 2024 13:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cpnt7SW+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442C41E507
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 13:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715953058; cv=none; b=BeTU+eEi214zRaQRSzWLf5CTv3jRTy8XZEDKdvySXXbJrT9HEVZ78deGkZphqCANsMl5tlRd3rWpattX44b5bod1kBl5rd1iAHk6eBWIUU2u1lZOx6cpJIAXMWaUn84OyITQ5SkLMGI50Q50eC6VepPe1kDc/W1Z+oy0NPtP9Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715953058; c=relaxed/simple;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=E2TF8NZq4EE9bk/ECD3+f0A5RarTORpLZ22crrHLhX5nThQoJT5CnJxAZB2cFSvOl9ZmewCzpiqodkfw+wz223wCHH0eUyrGIS08ltEoPF5l5ii+S9QXeUpf2gV0JCIWAx2PwmVpYs2zQcB2qt410XulqlMED6Vb2S1DaRBJxoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cpnt7SW+; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-52388d9ca98so1304270e87.0
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 06:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715953055; x=1716557855; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=Cpnt7SW++sN+NGrjGrkcie5OjyhTPcq4BBAivCMpx1PaftOW9QhAX3ohzR2g7nk1E6
         AvvE1AE/aSj5NNASG4qJ8N6NU/7KDZBj23PBZDX9qjV8TglXOSDJY4sRLpj7U0OTh8tv
         EtzjTVwtmppTTNX3zv/bDacC6IgwxSmyLcfM/V56ccC7p2gaJf2aZPFXII371WlHZizR
         O52oepgxBDhLFLCfItn92mSLp2hCNvcKncvPjQLeomjaSgfH/qcQo8MiusCSs0CzVYRN
         Di+VWzAcP6d6Wn2xjP9Uq3NZ+aXc/l3ycyfAILWQrEBtmYL8L+AMlgavnz0418Oxin5E
         xKkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715953055; x=1716557855;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=cJzIr3sc6qd3WxS0j0qzk7UodVBEpnUyTLzf6/RPhFZGC09ig6GfZs1syj+uw9j+/n
         E48PXhaQSgVseDUagptbY/ywz8XQP10dGM2stS44hBtRSzS15CrHxOhQz+URe7jD0Q30
         UOcfE8249i6WLWEtltQP+FvURXdRqpfDiAIiGFPUOwuYoyn2oXwlThO0/fW5Nf7c5Nr2
         e9VEQvPQkZHuUcctmdyRFoVjJiBYshz13qEWlnj31W1dLqCkoJZfxqTgK7Qigbh1xtHU
         5pwhTcNvuaOYLYL35G44tAHORS/gjNdhG87eYs8YaPiHFRgOHBYvPNkqvPYlVSkotKM9
         WBTw==
X-Gm-Message-State: AOJu0Yw8peshoTcFJsweO8K+2mGIyFr+N/27w+COWZ7leK02+/c0NyVU
	psZYYL5XY0BE5HYr1bf6+CE98GK7tgwwQ7VkQ8M8R/+9mNZl+OekO5sxpMqKorluEUKr+WXr9NO
	sBMmCFLzkEwXjFy3/7gaQxJ8sVkPlpQ==
X-Google-Smtp-Source: AGHT+IGohEqzfubGnq0qYeK4klau43WTjF+71HRQVC7wJ1czwCtAFwdCK4cS8W0DcuTQFzztWv/t4nYaCwwb6T2GWKU=
X-Received: by 2002:a2e:81c3:0:b0:2e2:a99a:4c4 with SMTP id
 38308e7fff4ca-2e52039d930mr173126331fa.47.1715953054958; Fri, 17 May 2024
 06:37:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Satay Epic <satayepic@gmail.com>
Date: Fri, 17 May 2024 08:37:23 -0500
Message-ID: <CADohWC_PW5oUmQLeMDU7zj0KFL0dDB-h+wsxDH1tY1XUhxAyjg@mail.gmail.com>
Subject: unsubscribe
To: kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"



