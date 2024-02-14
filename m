Return-Path: <kvm+bounces-8645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02F03854163
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 03:09:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 975BA283209
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 02:09:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83850AD5A;
	Wed, 14 Feb 2024 02:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rJrmn/Lp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79621944D
	for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 02:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707876564; cv=none; b=YVHwjg/3U2Dpp0nW4x6hdHoTJMzTa7Gs7ll6+axNuG5mey7Yxm7y4tGCIiGbuOpFR+h2V74R09mrD9zeXor3dKS0if19E2PfsX9ftwPy+tcFNj9jfX7rgLgjWFzuiQk0KeIsntUYYq6DoRTXdp4Qwd9CFl0N8K3qNPT4Z+ocscw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707876564; c=relaxed/simple;
	bh=qPdFwZ8mnINsKo+kaHmLBcNmgicBBXUmqQA5j4kA6R0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=l76ZjBNnXOmDZKiHt99hYLOx8KkcwyXRA64HTUcOeO62zFszBgvkCFhkvX82STLcP9saGNVbc9X8cdd9NzG10A+vqK/ydW7uGpYvc366TE3e/CC8xewTlvXu8cC73NtmQoP8eAc6/hj34mvtq0p8rmgBzn7bqmXT1iE7SKxIcFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rJrmn/Lp; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e0a9b28359so3355853b3a.0
        for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 18:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707876563; x=1708481363; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S7v4C1q0Io2313q/W5uOI8OVc5LXFtxFMDUw5WZo5KU=;
        b=rJrmn/LpQAF5vflaahfFXkLgoTWFdBhrdvXpmCzf1uDoMZTxI8VfSjnhWpHpdvPkJM
         aP27SWgnKuPc8zIvZ+CNxeJI6y8rDe4+ah9H1r9CM827gDL8UgVZX49NFab6mWfkEeg3
         0daGbtlEWIF8UztM1rpMZUoqGLDcSSGLgmXMaO5vpMTVYw+L5Cs9qIsCUMn6x7TIRov/
         WqgdvK/1u0Ip6iBR1CdtB3uRZM7TFKURCrp5K9PFztXnrNkJKnwYyUz2Qbm+rhdfBgba
         T9hffDdM/qgRp9bzTDQTdVR4ldkIpcTe7JSelWMvs/Ml4pILxJZE0FFXHGdG9oGpbJNQ
         33UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707876563; x=1708481363;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S7v4C1q0Io2313q/W5uOI8OVc5LXFtxFMDUw5WZo5KU=;
        b=vMPpZIPDiZpHh78gUwqpqHcV7H3+vSyrxWgwDc9f9Og7MCqbjpGKiEKSp9ydqwnnQn
         ZpGPPH5GdHPkPLJZI7/B07itewndwKbFuvhLz36qJhyuij2mC4y/xEmTDIfIk+9ou9Mr
         f6xBIrvkSQzQ562+InnDBRmoOwwrV+7cs3Jx/lcmGTef7UHl0pmvYZFRcFfOLh9Uxer4
         WHhwk+wmokIPS1JKRFg3gYDoutrb7dLR9JMWuHx6vXgHcTsLQ6jXzOaQR7jqSQ4ZZtqy
         7JKc16gKmD+adSZ/sshyhskkHK0LrISyrX22vjgtY3QL8DLPWP4ekY1MdIoLLOLAqyhx
         8mzg==
X-Gm-Message-State: AOJu0YzlNlDmmwriYm+KEDWA1Hs+rOPCbqpricDh3ijbdU1UUl/njkBE
	aTxo9G/U8Ce8vEEx4/u5qn2yqergIIoG6KH+OHAa6PcE0gzAGabYwMSYKNN7jthlhAa1IuYWb9L
	Kww==
X-Google-Smtp-Source: AGHT+IFOtqME2k6mUPFgh63d9O2YFa0HCB1jMzt686qjh7+JgcLUO7AjEIbRv74K7ghAKX7VJVLw/J/O01k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:6582:b0:6e1:e45:3490 with SMTP id
 hd2-20020a056a00658200b006e10e453490mr780pfb.4.1707876562673; Tue, 13 Feb
 2024 18:09:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 13 Feb 2024 18:09:20 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
Message-ID: <20240214020920.1152268-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2024.02.14 - CANCELED
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

PUCK is canceled for tomorrow.  No topic, and I need to catch up on a few things.

My apologies for the late notice.

