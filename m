Return-Path: <kvm+bounces-7872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 70D28847CE3
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 00:06:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2DB272890EC
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 23:06:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21B0112C7F4;
	Fri,  2 Feb 2024 23:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vxVZ0xFN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44B183A10
	for <kvm@vger.kernel.org>; Fri,  2 Feb 2024 23:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706915176; cv=none; b=cYmag4EA8+nqrpu5ltg+jxRh5jsd4cR153LUgvsUFQNUlbAPmdrAFg8BMv//VrkntlTMZcCtyWe+HAi8QeEEATuKIVvuG7P6sMCY+z0NjBe0FUDwI9M+bITGOyCh/V1dMwSsKRII3CCRbB/c7OY1uDe0QMSh1kqBXCq6p939Qlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706915176; c=relaxed/simple;
	bh=teG0ygYBoD/d0W0ZK2Rh8QBbw8OV80jrDVa2aMA21c0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=kr/RCWbcQxT1OnWSbSNN2fQEptn7Jujyy+mQJPu45/ZK1SjjkZ0EWVk5UeHVBXhjfAGZLHrHGkV5C4z9WL9DPEv/wigbHXdrMAGB/oilm+YcVHC5eQHrWB08GyuKx97gOItIfT8OL8U0clgaE+bdz9bomQog8nV5WHMKMPs72Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vxVZ0xFN; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5d63c7c4248so3245238a12.0
        for <kvm@vger.kernel.org>; Fri, 02 Feb 2024 15:06:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706915174; x=1707519974; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YYkaoKtTT1rGsO6DF0CgTNsVuiFWtfE+/HLvWE6qfGk=;
        b=vxVZ0xFNomUCCy8nAKinckoN6fEAmprripBQ6VQQFzwE/ZyViMph3d88yuCCH7WYow
         CpmEEBwS9bAuAWIYTkJYBhE+Oae6NoXqmBZNt2zI1YMYl9E9zyBna0AonoSew+PxEUQI
         iQc9uI3dTIff9VgHn9bTR6hQDWxyLBbtmtyjaoqcsoeIpjdEm/tBSHsaIY6r66vAbQPY
         K1+Y+ZrH+Ssvy6EcKMBPy+s4132iYovfln1fn8HCTmwdyJGc2+XByePu8QuNxDThh1Yr
         l6s1ahqcYzjyrIl9bzgGzFI0Kxz1PhlMeQtVzND2NQ1S56FynJ0lWEQgVPRGRIjLon5l
         0j6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706915174; x=1707519974;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YYkaoKtTT1rGsO6DF0CgTNsVuiFWtfE+/HLvWE6qfGk=;
        b=azoxfTVQlbHor5UaBmtip8AV4ifv+eCpevzmsd3Mmg4nUIJAZuGEXbHDjtw27sCWOz
         DdQbFewN6oQ8OaluKSW8JQVbWXVEjPQ86H4VrOprMsFgri5YaANfSodNflOYmbHFDvP+
         ocMJ+56FvJ1xoKf8s8P8MGBUda1ctUWU3o2+TtirIaSH5RdralgVI2VDuYQP3hg49nCc
         7VtaUJp3x6hSKD3aKejyuXkKn96APVXfPz8aQBylSm787i3XDCSLNZJu7QZbTigtlEq3
         vWb+DGPdPwXJVJk2eNQwdpSf+KNOchwRoKFDUD1deQcScjaORCTVA9tWyy2fM8ZW6b7n
         Vsvw==
X-Gm-Message-State: AOJu0YxK7d0fhoF5Zy+lryuEZE2woh7puL24gnqYcDP+8Gc87TkST+BA
	aDV5LYVoT4zQKK/oUvZu3QSLhBC2d5OpuIl0CgSPWwwt8LD0IL6IQBgoXmoBlqCivAnp7n+uuty
	+tQ==
X-Google-Smtp-Source: AGHT+IHu6d3u5Dk+iZFSsSIyynomg+uuqFy3/EGk+Ka77ZLxLdT0yeVful26jlHRMYefy8WHrX5UIU5dH4U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:35c9:b0:296:4d0:5840 with SMTP id
 nb9-20020a17090b35c900b0029604d05840mr81pjb.4.1706915174191; Fri, 02 Feb 2024
 15:06:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Feb 2024 15:06:11 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
Message-ID: <20240202230611.351544-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Notes - 2024.01.31 - Finalizing internal guest_memfd
 APIs for SNP/TDX
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

No key takeways this time, the discussion wandered all over the place and was
more of a whiteboarding session than a design review.  I recommend watching the
recording if you have a vested interested in guest_memfd and/or protected VMs,
otherwise you can probably skip it.

https://drive.google.com/corp/drive/folders/116YTH1h9yBZmjqeJc03cV4_AhSe-VBkc?resourcekey=0-sOGeFEUi60-znJJmZBsTHQ

