Return-Path: <kvm+bounces-33254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F4F19E8459
	for <lists+kvm@lfdr.de>; Sun,  8 Dec 2024 09:55:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6515A1884A5C
	for <lists+kvm@lfdr.de>; Sun,  8 Dec 2024 08:55:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB93613B59A;
	Sun,  8 Dec 2024 08:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mo4c+lcA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35897F7FC
	for <kvm@vger.kernel.org>; Sun,  8 Dec 2024 08:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733648134; cv=none; b=ZBLxGe7O5jvp7UXmVWV4YU3UrLv/hOWwcTHE+4Y+Up/UuoeiCSSw8AeF3z86IIXhQBm1WLc2RP2MQgVQWGJp7RsQB8dT4rBmmpU9GbFL93LJZHcetmY/dHe/9sRbIyOMYnnslouArs5pVF8ygD8F/YIxaeEoCUpfmkBya0E6PIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733648134; c=relaxed/simple;
	bh=M/ZsFGNVA9M77veAI/vQHt95dqOPK+Noa2E0aMMPX7A=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=cnRKS1X/jOg3JWWesuEepc5ApZg6oXMK1e/c+iVTsLU1sC262CbK1xaSYDxcmq2m/R6RPTRvJ6+FxRtozwwvRmh2YIwy7apyIMGfsTPiNNms2CK6sCvD+9jKrLxvoLHhylyfzo/4HU87ncw28L21r0uP7lfpO4Y0QqkpHQ5LTeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mo4c+lcA; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-216426b0865so1553765ad.0
        for <kvm@vger.kernel.org>; Sun, 08 Dec 2024 00:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733648132; x=1734252932; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=M/ZsFGNVA9M77veAI/vQHt95dqOPK+Noa2E0aMMPX7A=;
        b=Mo4c+lcA2mKm80s01aBLEzjt4jHd/BDjtxVDVY1nTuLxd+zO5b8eT7yxH+uQYXWJUR
         /Z4OIFBECEKEobqk66Ajp9OOiZkMEI88DLgItwnCw8EWnn2bGxBxLikQ69pzgGAqnJre
         DB8/rgBDnw/FgJJPeCSXq5Gg4j1HQ842oWmN2E9iHwz2Y2aJed6Rdjfqx63zOlhey4yx
         lIDpUHmLQKzfBxcy6f0+OicRtvZAHIbxh873KtYhpV4WLSLiWRThr1lqTr5c5AwziHyY
         kx37JTu6mObd+lQWXW9MrC+cbddh3/AfOAiB2oHO0cZR8TnOLANiq2+bn/nlfv9phnXW
         Op/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733648132; x=1734252932;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M/ZsFGNVA9M77veAI/vQHt95dqOPK+Noa2E0aMMPX7A=;
        b=ExVjWp2lAcjO7mhko7MNG/mse3+9wRMqbhFcIIyHSlfEifzbwQZSAq2tZHLULhJVJ2
         48LFwvu92lnJyh0RTEi/dCBgqt+JjopZC9RcF/7PpTemCridIFDi7gzyZSiF1at9iPUU
         eTdifgDg1JgMh9Sd8QVBsQ7hmzK4/Ua4+r8Zx+eVtNEM9m8pJYxeRAPJ2z1lrpSX7o8u
         J7SgQeGq9qzO7YH9oESShDqLXgFhS35XOzzOYta+LywKoNpJAerdCljDN3Mp1iG4Z+xW
         rGyPLXmQiPh5NDyxMjGT5WcNvf58qG/WL0d7ViLzYRgkzD4TyNtIy//gkK3Wc/IMESoQ
         O7Eg==
X-Gm-Message-State: AOJu0YyxJRY6+FRmN9FsIIZNsUhItLgJdfZLoQHoBxeV3oHabgyBbAnu
	MLm6TSUnJYQHNciROIrXmaSPwN0g18i5nfmoI8jPYDmyhOkbB6wiQ+qOmUMQ6NQ1tOx0XgffaP/
	QqzfnOG1FplbfHoVIOgfvvBPQuQyafc1N6UeRJA==
X-Gm-Gg: ASbGncu9J17z2xERUrl1eflOMRbg1Pw6ShjxcigaIGwT7rqRo08UsG3al04sGVCvgJS
	VVdlyA/J16sy1v82EWbm4Sa9ZTciBGQFkqltc
X-Google-Smtp-Source: AGHT+IF7aw+UdUjPImisyKWHQpp1h0jGGDouNR4x6EkPsAV7xjOyHNwNA1wVdbeWVyZ6aTgcgjHzOGaOalv86zKwWDM=
X-Received: by 2002:a17:903:2b08:b0:216:2426:768c with SMTP id
 d9443c01a7336-21624267776mr87466405ad.16.1733648131789; Sun, 08 Dec 2024
 00:55:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?B?5p2O56GV?= <shilishuoya@gmail.com>
Date: Sun, 8 Dec 2024 16:55:21 +0800
Message-ID: <CADTb_0MBXXP5AdkBgboa4cKPhicG9yXwQ_93X8iJs0-CEMVYiA@mail.gmail.com>
Subject: i want to learn some recent development process about kvm, not robot
To: kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

subscibe kvm@vger.kernel.org

