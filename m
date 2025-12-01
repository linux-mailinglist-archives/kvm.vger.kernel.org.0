Return-Path: <kvm+bounces-65026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 88EF8C98C16
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 19:46:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F369D4E1A6D
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 18:46:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA5EC2222AC;
	Mon,  1 Dec 2025 18:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cXEY+Heo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD4836D513
	for <kvm@vger.kernel.org>; Mon,  1 Dec 2025 18:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764614785; cv=none; b=DgrAnGe5k/m6LG0mHz7XjZYF5TlxI/pgKOoavi+TtqOigWOodNDHVWDoUsAyqi+mSAuXKrScqX/OBpYOdayMQvqlVwbdFAUMV1UNJ+JBsXlXV4QImz20mE7oeAvN8Ai/rw6+e/DVFwaKBOd5pwZ/DCpxnNbBK8DKdFRIbZIckmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764614785; c=relaxed/simple;
	bh=fcMRFNZHzXJ556qsx3mtb6wrOB8beL+alN74EbcVktk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Ef/AeMhu5nx3ZDAYSXLcu8vItFpGeNArlAfdSLQI1JWFVzNOsaPyAJZ4+TuxlY6luK8dHHLqngrILcEreNtfKqW8tRPbfwhl1ZCm8OYymaqRHX8Ga6bB3VvClQoIqpIyAqL9xu9cEUxdsmb0PuSJR+a+sdjG+t19CCGbffNBmlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cXEY+Heo; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7b8973c4608so1935618b3a.3
        for <kvm@vger.kernel.org>; Mon, 01 Dec 2025 10:46:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764614784; x=1765219584; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fcMRFNZHzXJ556qsx3mtb6wrOB8beL+alN74EbcVktk=;
        b=cXEY+Heo2Gb8XDbdcmqJiZqr8yAgw/lbIsrJYGMLec8HN9a6B4yw073HYuVBuSIIpS
         lu1T7YJMt60zxT0ltM0YQ1itXyRJyJKyhGBKRPMbtaGp8BIOJW1+w1Sfb2r2JeSo+AXo
         H2i1e3UYOp94EwLpLS5iC7eihlhL+MTA8Viz1eaHbmpu2aD2UkdWMcGo0xQ9Q8nBG8nf
         2YoHROdzIK6V42Fq6F67rj8ZOK/ap93ybWspLKCnfZhc4uPCTmxD+fNnjXZl98SZ6Q/J
         GkfOTbRp1mlLE5wl3rAIMu8d4pljGjjUK1oNNUU41dH2INchRQwc/3gWPOKm6IdqJKSV
         Rl+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764614784; x=1765219584;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fcMRFNZHzXJ556qsx3mtb6wrOB8beL+alN74EbcVktk=;
        b=X4d6hxNxGWSmh3D8GeIJMphbNdQ1ydcRApDrOItD6w1hH6uTSPQ+m6duVArFtft9tb
         FAq2gcIBsIdrlPkIE1ATfRN+NMED58o5MnM0vT/RCAtrPlzxGf8d0oVjIi/Cyo6cxqnw
         +fAk2kewgMSY6c3TUDMuYUOEeeJp9kmhqOMDrVcPExRKiJlY2qtt+RdDceYY4vkyP+PG
         toLmgnGhwOBMFHtsdzmhXgfA8AUz4AZFvg/9+qX4AQti67FUouUSP7uhsFd0oKtZ+k8N
         TwBD+MO+aaeEAJ8ckfJ79PTqoqPC1ifDs6T0DcB+llZskHN2Q5fcF/eZcv/u/FPwENX+
         k50w==
X-Gm-Message-State: AOJu0YzEIevyVRr+rAobqnNZEEgWOJEVgBEw5trgrks0xdNJTb9iRBYn
	QnTiqTSN8x/0JX2WHy3U60b1NevtNJ5gdjrmDAsyLYCQBufDz2shlsh8ze5zhwgm8O56p/DYNZd
	O8nL4iA==
X-Google-Smtp-Source: AGHT+IFFiR9WNmlZylDHzUUbmz6c6E1SP7g61KVJZmRNZjhQZ/EUpC57MdoFftgSxR7SmOAcq6yIP+gEROk=
X-Received: from pgkz37.prod.google.com ([2002:a63:a65:0:b0:bc4:fd78:4e82])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6d9f:b0:350:9b6b:8ea8
 with SMTP id adf61e73a8af0-3637e0cd294mr28415138637.51.1764614783892; Mon, 01
 Dec 2025 10:46:23 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon,  1 Dec 2025 10:45:51 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.107.ga0afd4fd5b-goog
Message-ID: <20251201184551.1035469-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2025.12.03 - CANCELED
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

No PUCK this week (December 3rd) as I will be unavailable.

Early warning, no PUCK on December 24th or December 31st either.

