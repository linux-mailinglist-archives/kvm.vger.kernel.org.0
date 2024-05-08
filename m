Return-Path: <kvm+bounces-17029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C1AFB8C018B
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 17:58:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 77C481F23726
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 15:58:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85E1612881C;
	Wed,  8 May 2024 15:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KYinLjPK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BB68625B
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 15:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715183887; cv=none; b=ZDn47jedoO1Jy40SuIw2RvLEtt5IWQfq3KiJb6JLaDNsWLAsPSdyTe86ID5TY0ZBXfW44mBMIsxhy0HgDDdbKlYOHrIbp2EKM8bBpn2igKcX4g/t4lo52c6bgOAl6nUc0cJSTcX4+cdkxRVrvg/vijrW1GtHXmAVlt24LKYbnqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715183887; c=relaxed/simple;
	bh=6izLnspEoWi407XJFRyj0TMHQcyQNDsYCuNvg2YZsww=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j/0fZrj+TjuQ6Lu6RKl87HX8IBWlmmtRdDM74WqY6oXulMOs6VqRbLFLNh3D8os7+FOYY81JJo8GTcycqqGMWn3xdLih9PJje/A9hF6ZJenD4AyyZa+jvWGInJ0lLx4MaSrukakRXObVvtn6R72V3vlCNQ1WSfQH7oRr5n8/KeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KYinLjPK; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1ec401f87d3so49522215ad.1
        for <kvm@vger.kernel.org>; Wed, 08 May 2024 08:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715183886; x=1715788686; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7zrXfdhQVZa7DTzCijd3YUUNo+sqV2sNEtTK3+8ITdI=;
        b=KYinLjPKz33Jnl/g38R8VtxyHX+w2AuldeA4HVAd9D1IHqp8CBHpPa2SHs0x1x5rz4
         KJPeIstO7LoZxJ7c3oHQCr/TzYIwfgPNDZVxyCfAhXiV0+6T019r3MKrDigUykbRtSn+
         Re3ZcfQl7jDqmgZq0WRfr32GivGbmjYaTEDQuUQYnjKsi58ZVQgJQAGFucd6U9jXofa7
         5JR+w9mojXc1lHIwKE2nCPbNmQtDLylyMu7cmG9lmUr9MuoPsKiqzF+6hJRso78Kr1g/
         mA8bzn7M2R0Tvest6H4gbP37BmqWlwwnfjvmS2ziYWq8Uje7t7IGe559SkFpOyu1FfHf
         XWxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715183886; x=1715788686;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7zrXfdhQVZa7DTzCijd3YUUNo+sqV2sNEtTK3+8ITdI=;
        b=eARyNKCDZKThIaiSHB48jMuLw5F4syLbd/VP4l4PtXgCO16IVe2JuZ7rl76/3mNm6U
         lNelTQlmNVYBiz7R31L2OPhfArd9jnKuygJo8zUrCjuP9DelcmarxQg4mq3O8tOx6GV9
         9ofzSAK226swVlXFjsjjMzpDrj2gjrxiySR4Xjbt/ldreYF5jdkiRXqiUIEkrxsRryHu
         VVe1gqgilp59iSgZDm90O+OgJdBCftNYlOj7N6bbzY1CFFfjk8u5OMiKB8V1uHLECuPy
         9M1ivZmllizsHwK6UoqqIN6o1gI1dZ/HNZfpLtiwFDeTt4+UHM2cP3KVt/zudgpz4Ctd
         HgLg==
X-Forwarded-Encrypted: i=1; AJvYcCUsasI1pY4dg8mmsQVE9nHRpbEvcu0ekBvzdzF7Tgr6DaZsdHjWf0M8C7e+c5puqZl6OLUJJErT7u1+T+NqT0+UcAbt
X-Gm-Message-State: AOJu0YyruH5HEGiUtwPQy9lFCkG1jRojWnqs0poW20ADOMqA78ObAXfs
	/FwXwDsrpNApgPwUd0k920LcYRlBfvwgji6gVjX39WWdqIbSqQJMKGcU7WXgSnZ+65KwfeiUdJy
	9dg==
X-Google-Smtp-Source: AGHT+IFFApl/y5uiJncgorOHEu1jR3i+2v1awa9cG5JJCxjUi30iOSytJZZfPz3m0xt0S8aBg5vAHD4GeA4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:fa4d:b0:1eb:829:b6da with SMTP id
 d9443c01a7336-1eeb0197748mr505235ad.4.1715183885782; Wed, 08 May 2024
 08:58:05 -0700 (PDT)
Date: Wed, 8 May 2024 08:58:04 -0700
In-Reply-To: <20240508184743778PSWkv_r8dMoye7WmZ7enP@zte.com.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240508184743778PSWkv_r8dMoye7WmZ7enP@zte.com.cn>
Message-ID: <ZjuhDH_i9QWL4vyz@google.com>
Subject: Re: [PATCH] KVM: introduce vm's max_halt_poll_ns to debugfs
From: Sean Christopherson <seanjc@google.com>
To: cheng.lin130@zte.com.cn
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jiang.yong5@zte.com.cn, wang.liang82@zte.com.cn, jiang.xuexin@zte.com.cn
Content-Type: text/plain; charset="us-ascii"

On Wed, May 08, 2024, cheng.lin130@zte.com.cn wrote:
> From: Cheng Lin <cheng.lin130@zte.com.cn>
> 
> Introduce vm's max_halt_poll_ns and override_halt_poll_ns to
> debugfs. Provide a way to check and modify them.

Why?

