Return-Path: <kvm+bounces-20516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CF1E917602
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 04:08:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37C41284DF8
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 02:08:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 746001F5FF;
	Wed, 26 Jun 2024 02:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XEpNxKHZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66589BE6C
	for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 02:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719367702; cv=none; b=idShluV2IbvD38Y9yD0E6E+33XwPIqsFqXt+rVniPZ3BpH9yFD7I5vrYGUThXWTHtNkAr+TrYW4zYctUd3teJy6hrKAkoZO36U6MRWoRCOkoMv/Hy27VQdd3BCOV5++70PWhx+VzapBQgXQwkI3+dGCzyjFlK24v4fuZkZ//QGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719367702; c=relaxed/simple;
	bh=n/fPFzaj5kKSWYjO/3QwxalPySZCfCdjgXhSIwJ31B8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ihcCcLtDPH2kGA5/M5kta2fmu1dT+s2NMhSr3A3pHKeNPyKG9sEt0e9h0TiatD9jhztZbmoCLI23J0qt93xkTkRlX4HiGglrJPWHYWtkRWXLSoE6ABQsAAWcsCiESVc9IxcvFDMVhPsRkQS6Yki9eaGXOxjHhRgilF0LCLlrxsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XEpNxKHZ; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-6c7e13b6a62so8089265a12.0
        for <kvm@vger.kernel.org>; Tue, 25 Jun 2024 19:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719367701; x=1719972501; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EAQsYppA3Wyp6dfOfIsDIc976yQGokb2kdxJBPM7hKc=;
        b=XEpNxKHZVaq7JsjciuB6XN78miGFskIZRu/2W570yKOP1qoSRaltK2Bvi7xGssow3r
         s5yEYGJzUANz6HGL/ErMGuUaNLrLLhU7SHumSj69CK/d1GjGN8DGR2pcS6i7R4A5l1kt
         aZLAnNwPiK0XWsMZj5kji1UBl2p6OmJ/D54mY/rmnCclws9Lm4KUC/5GKeMf08cmvcdK
         mnEVhNpGr+l8oUcG1KCQif5vcXlInKvE1iqzle96svwnAClaUILl1QUOSfHpgcE4Az1F
         aeg1w4Fhqgf7Uk6AEeZL0dTTT1dtopVC8WDm1/XKt8UWQvY0B3CmjUXesoRQc4o8T/fY
         QCsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719367701; x=1719972501;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EAQsYppA3Wyp6dfOfIsDIc976yQGokb2kdxJBPM7hKc=;
        b=mA5SnqbHWIsGXFFkP9TBKPL7dCjRpD71t7VHot1DLQdF3JLD4FA0XGVPqGgj0Fq9GS
         9bCBnLJGBWgHp5vBCIE+jxTfRR/Cnu+q7rx6GjasuH6iaszE5uctFN+f+JClqnhlTi0t
         w37hcR8DNNYLAitJmZszALWlX9/l25wAnGOIeEdu0rs/j+8ZghI9V40OSclAalmARK5v
         6zMym5kib5qkX8CfBc1o9q3PrUVn4QRkLrecDidK9zeAKR0l1tqK2AUCuxU4c6wCmPjr
         Wdt2Io6YrCZa2IGscJEVaqbjDWAdH4ALfmZP+4BHftTr/VcumUNEsvoe2+WdtCagXJJR
         HVLA==
X-Gm-Message-State: AOJu0YxBO6qR+lHjeIc6l4jjl9At7hrScRaUBZdVlR+bAuq8CtessjW3
	iXrFJ0pJ+02hCjBgKii+Lxst/WudBYBaGbqV8pNHmDMaM64+6rlHj2BFvwsaxzA9nFdQ9wuwQ9b
	gIQ==
X-Google-Smtp-Source: AGHT+IEYLu5aiHogpqRtID4ElfT6aHF+xNB/7Ttv9nlZrt9fi6FggQYa66FXVmO9bEFuRoXGB83Q04brZug=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:3813:0:b0:710:bf4f:52a2 with SMTP id
 41be03b00d2f7-71b5f351a09mr24996a12.7.1719367700358; Tue, 25 Jun 2024
 19:08:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 25 Jun 2024 19:08:18 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.741.gdbec12cfda-goog
Message-ID: <20240626020818.3158096-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2024.06.26 - No topic
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

No topic for tomorrow, but I'll be online.

Third warning (give or take), no PUCK next week.

Future Schedule:
July  3rd - CANCELED
July 10th - No topic
July 17th - No topic

