Return-Path: <kvm+bounces-4284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8762181083F
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 03:30:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 969651C20E58
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 02:30:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20CDF1873;
	Wed, 13 Dec 2023 02:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H2Hh05FK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82809C
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 18:29:51 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-db512266d27so6706241276.3
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 18:29:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702434591; x=1703039391; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3A+By/dcpP8NgMf5bfJ77th91WWv84vlb2YGj1lcL0s=;
        b=H2Hh05FKZIOeQhNpl6lb+jbEZTI/e027oZDeRo+18Mj/y/l6Rep28Mw9ed865hpKj2
         kHaBva84etf7HcP3yE0tYBhsYdTaCqAOZ164Gjdm/GDIv97UGRHdFtOPatiGmDwPougg
         oeWthKRd50jWE144NouFscWRSagOgnTwNAUiXjyrFfh/IqyWfLNrfnCxdDia1UcVO/AI
         l5dWaI9UvV/wJ2YJc+aPD08xtiHrPNwjgkzOcfnW8p3cD8HA5RxDYIKP1pCc8ouNfgtj
         QcWoYTbrT/KCJkoX0+Bs9Xs5vPiIJ6jc2NalaTSlj9uf0DimrWWOCqcXnJcEjPKXuDcf
         4oNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702434591; x=1703039391;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3A+By/dcpP8NgMf5bfJ77th91WWv84vlb2YGj1lcL0s=;
        b=q2OiYC5u5rh4UPm7S8JH1NMMR3jpTOXjV1uIX4WjbCm34tg2nqZC/kRq1RbrgtIwf7
         hgY3ZemDrAF9me3tdOS/ifNP9LDHJ2/brvBjk1ThNfbECHJWKt55JSjCJaPThPYZdWWv
         9BTt6EwL/wZZuj5zqoFl98JzcM2k9/EQp/gKNiAo+Y6NhaJnBjYHnbe8v1KWcTbjdOIV
         ii+0LwTvZ3Xf45YRuUQFKafeKIBObW7WKd7U5ycSaZcV6OI8uYDkRUHRBhoX4oha4UrZ
         HZClwB6UP8VWOm/csRD7H8T+vFdITbhlk4PpaDRzqYdDkGBCV+ymSw7WZy9hDs1UtUj6
         gKRA==
X-Gm-Message-State: AOJu0YwLA6GO9jqLznz1XvAmH8oCt7JdLIwkxJ52wrUzbe2I2TNlFx+Q
	8zuXFYG3fPgtJv06sCiPpoFUhxHenj0=
X-Google-Smtp-Source: AGHT+IEp0l4xg6brahhIyo7pX86MoJ28L/CSl2SoF4hAHLUajM1JyV1FRmfpaIfhcSkctCDrCXAgiN+ef1M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:52f:b0:db5:48c5:302e with SMTP id
 y15-20020a056902052f00b00db548c5302emr56548ybs.4.1702434590930; Tue, 12 Dec
 2023 18:29:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 12 Dec 2023 18:29:48 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231213022948.547485-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2023.12.13 - No topic
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

No topic for tomorrow, but I'll be online.

Note, two topics are on the horizon, "Unifying the protected VM APIs" (Isaku) and
"Post-copy support for guest_memfd" (David Matlack), but those are both going to
be pushed out until January due to people's availability (or lack thereof).

