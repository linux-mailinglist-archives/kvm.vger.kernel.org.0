Return-Path: <kvm+bounces-16554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 650FE8BB81F
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 01:19:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92A6A1C22968
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 23:19:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A00084A52;
	Fri,  3 May 2024 23:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gCzQXjYh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380AA83A10
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 23:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714778333; cv=none; b=GDYwxVLMvcYu3/gajBLg/BBRHgtt+Rqa83FFE6MJqvVoDjlULbtCP8NLYE0QZDx5rQgE8ems/uGzBBLnm9gSPJC+RGlIRn05k6MvgftoIs4BxFBb/YHDnLyAtSCzUyPfkpLRnAsBzhGiC1HV8VoOIqYZWTIcniXjeL/RIYoP6DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714778333; c=relaxed/simple;
	bh=ufSpheMePZcwCyvVVfJi8audpe+IoeXSDRymCe2o71w=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=hka4ai71V+HS1CtAJ6MnVu+ht0IlRvsK6eLCnVfQb5Hf+9B+Ws7fJKkSZvUBCYFHTnFpeFPeBqQpN0VOEKHDGDGfUM4PRMAXEsAQfzm5fkMf4Aau0bU0+93B1nDDpDpKgNW9yzhMI8cZ7aiXt4Svm72u1PDZfdiCLP7sr0UCwt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gCzQXjYh; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6ceade361so577665276.0
        for <kvm@vger.kernel.org>; Fri, 03 May 2024 16:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714778331; x=1715383131; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KLpU7UWH9Mg44dKo7/yEoeonUj6CV72qu8L1edzNRC8=;
        b=gCzQXjYhiiO6t/emZ3cMAcBFcMuZz+4DHNbMRhyNQJxVZpoLooMRQcW2PNJQSucvfz
         OVQtbtGvgVAahvCtFhCwA3XlEfcEhSFd+RofFlSyB9ZbuXKxfANav6BG8FEmwt9O6pgY
         Axpowzjr6NzCBJs1UZW4j6pz90zdf47DXSxfQLVXXVcJhGBG8+eXTyixEbf8jQlt4GSP
         cTks2MyECDIl0WSlKyfjngYsBn3/CxW4ZR5xiS1x6KSrmiqRFFHOxf7uYD1BzfNcbZWG
         L2Pfx/xUfyPEGf08019f7GSruVnkskaOrD3Rfg8CxeANIEBhm7y/M+ByQUN7mYuZqxzS
         Licw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714778331; x=1715383131;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KLpU7UWH9Mg44dKo7/yEoeonUj6CV72qu8L1edzNRC8=;
        b=kkMpgw6sB2yFhm4XpAGIesBUpm1xbY5op+FpJM3vHHJZO2gCdjpFiBY0c+864Ba5MM
         g78KvLOrPklsGwyC7q19aXTI8xSyGgucWkxsJthysMiBnSMkcEJSPxU9lLSkz5HPVK58
         GIj8fnbEr+rmkQ1/YFrEsTwBHBPBHHcapUi/S+3j4xI4cElheX2C9Yc/TGLtrzvehSxV
         zZWs5jp6IpmCgtU4FDqyynp4Zx4hqT4fx2CgQbOT7M+2nHMDAJgWQxkOs0Jx29NlHJ4c
         z1cfZ+B0ZHSaCvDlYKipdTHSGWmLtWqdbDC4BQxPI871DlEox4DI9z2xp1jkufnjlEj4
         OGpA==
X-Gm-Message-State: AOJu0Yxhh7EoolDawaO2IoR6VkY1RjXU+z0iHaI3+cAP58NkJSRSfjNf
	nI8BQXChQgBKc9y+5ill6KyjAtppyqNUx77lXtSve/7Wc+hTclo2L8jHNZ24Tjwscs6tFmY6vRw
	hDQ==
X-Google-Smtp-Source: AGHT+IGVXIgjtqaXBlAcr0Q3kKDpMwmKQaRwYd59K2rwojMHyB/XlX3RfBIY7rX6mBVc0yonTD1CaB6aavQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ac56:0:b0:de4:c2d4:e14f with SMTP id
 r22-20020a25ac56000000b00de4c2d4e14fmr1148392ybd.11.1714778331372; Fri, 03
 May 2024 16:18:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 May 2024 16:18:45 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240503231845.1287764-1-seanjc@google.com>
Subject: [ANNOUNCE / CFP] KVM Microconference at LPC 2024
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Game on for the KVM Microconference at LPC 2024!

Proposals/abstracts can be submitted (link below) under the "KVM Microconference"
track.  Like last year, there will be a mix of short (~20 minutes) and long (~40)
slots.  Feel free to note your preferred slot duration in the submission, though
we reserve the right to ignore your hint.  :-)

Tenatively plan for the CFP window to close around the end of July.  We (Paolo
and/or I) will follow-up with more info in the coming weeks.

Thanks!

Logistics: https://lpc.events/event/18
KVM MC:    https://lpc.events/event/18/contributions/1659
Abstracts: https://lpc.events/event/18/abstracts

