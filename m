Return-Path: <kvm+bounces-31990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 319119CFFC1
	for <lists+kvm@lfdr.de>; Sat, 16 Nov 2024 17:03:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC40D285B07
	for <lists+kvm@lfdr.de>; Sat, 16 Nov 2024 16:03:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9D0D18052;
	Sat, 16 Nov 2024 16:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nreeZij/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA751372
	for <kvm@vger.kernel.org>; Sat, 16 Nov 2024 16:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731772989; cv=none; b=JPsoT+6xtmhNONoQvuA+cLwtiYMNngBpZvZgtuzlpmNT5Ms+Q0vZaSFeWnmwuh/1nBrKt3eq2ZuVDT2zMHScXohJEoO8KHB8oQetEwkP364MbF+N1c9Q/NPVctY0db1KysuUfT/gmqsk8OBwWGc8Fe6CHzjWPkumKTAJL/bYZM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731772989; c=relaxed/simple;
	bh=Wd+7kLQISUZlzyPvYmSUTVOb8NV4Vyd3OpsFXw6X7a0=;
	h=From:Message-ID:To:Subject:Date:MIME-Version:Content-Type; b=ao70tl905B9vI5ZYjspmrQn9IdLtQ5q/NYtlWYNyGmcm+CI7ZejgO0kUBtK7W3UPpI78BIHMHfIt2YG1or7++FfhMpHClyjVR7x31iOJJvQC0H5uS3SpH0muKWi9APIlKj1b0JzA9s6HDarBrtzJ5oBLuZ8nTLQJ6NLoHFoXJLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nreeZij/; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2ea4c5b8fbcso85084a91.0
        for <kvm@vger.kernel.org>; Sat, 16 Nov 2024 08:03:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731772987; x=1732377787; darn=vger.kernel.org;
        h=mime-version:date:subject:to:reply-to:message-id:from:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XHEOkgJ64rwJ+cv0sVIqPUmbc8l+iTifR7HzGzNced0=;
        b=nreeZij/C/rmhsbayrinV7vEam6iDwmO/S7ciTJvU9gEyma9ytmfKwxGuPfcVTvyP3
         EiZ28mqkm/XAIxzJ9wDCFSTqoJnDOg3tc7M3NBbtHmbZmScizcLmbzwc0OXVLSr/wSxP
         9+NbF05CwtX23YctBpggt8PJ3TsjmlrEIs0Frn1PkprBsO9U9Nr9VpAbggOtHVXwP47O
         h0UdwVn5e46W+/HImZifh4Rd8DLX/CgPs+hU2T09rJi7asFMGdP4nts3ScnuosN3Kdr2
         2q5SlcfyDvqDAfGZpzTFW57ej/lwLZyz2dU19SHF8TwmtrWNxLml7Q3yHuOVXmjxHpl5
         Jktg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731772987; x=1732377787;
        h=mime-version:date:subject:to:reply-to:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XHEOkgJ64rwJ+cv0sVIqPUmbc8l+iTifR7HzGzNced0=;
        b=LsTnptsQY8V0yUEGuhTD8YJ7AB2DfYvUB50HNZhoPQW9RarY+0i3peg1mZdlr40dgs
         QjjBtUdi3X/ZmEQDLW3zZxwUyxYRANbxRvLX4DIhMaeuCP+VrKevvVwrZ2WZl4hHwbJO
         5UHq+nE0fK2SDEN3hAdfpSPBXYm5YN9hQ3ws26fzOBTWAeyzyIUeUMLUhT71WujKb5ho
         jHAJ8IY1Uo3TupbUcIfERP1W+pxT5ekqqAqumuAfzeV99T2nIwUdus0d1XfM+qMoT5Zo
         oHL0XjKxXlzJbFowCdsvXDPF64JEcSkdQ/Uafw3+alH1ZAH1IYGfv54TcMKbeN3l/DIr
         WZhQ==
X-Gm-Message-State: AOJu0YzzLMIiffw7S54QpneZ42ne9HNYSeBlGWJey6Z6iLNng3FLKa1a
	1uE0gbtnYmphuMOgQv+49K0JACKcWbLieGWdiQWV/ryYDkoksCms0wpH2w==
X-Google-Smtp-Source: AGHT+IG7CeF90hYUTft72WGQsgbjjg6NNJ7CJPzhTsxQDGqSbinSrm/lIDIVobPA0U8nVOnFX93eBg==
X-Received: by 2002:a17:90b:3145:b0:2e2:878a:fc6 with SMTP id 98e67ed59e1d1-2e9fe6b7bbemr16440486a91.18.1731772986820;
        Sat, 16 Nov 2024 08:03:06 -0800 (PST)
Received: from [103.67.163.162] ([103.67.163.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ea06f9c643sm4553150a91.41.2024.11.16.08.03.05
        for <kvm@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 Nov 2024 08:03:06 -0800 (PST)
From: "Van. HR" <spartangh300@gmail.com>
X-Google-Original-From: "Van. HR" <helpdesk@information.com>
Message-ID: <0e14c51d251f93bf898b151823ee53dd768b999b11caf0d512e4a929e11fd8df@mx.google.com>
Reply-To: dirofdptvancollin@gmail.com
To: kvm@vger.kernel.org
Subject: Nov:16:24
Date: Sat, 16 Nov 2024 11:03:03 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii

Hello,
I am a private investment consultant representing the interest of a multinational  conglomerate that wishes to place funds into a trust management portfolio.

Please indicate your interest for additional information.

Regards,

Van Collin.


