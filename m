Return-Path: <kvm+bounces-40153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCC65A4FD4E
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 12:12:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0696D1691D7
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 11:12:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5259E23371A;
	Wed,  5 Mar 2025 11:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VgVccV3C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B1E20469F
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 11:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741173116; cv=none; b=QDFsyja4XLwIp1sfnclyV//jXA4pOM61E0uA15JCPL8OfROAEvtp0bFfbDmONKrSgL/QU/PFcXWCAUIv9zfHoUn9CedgZ/s/IoFYZi4yuFGUTNTlMXm8BkIkjZDh9uVlNb7W3JttyOeAgwplDS+j4NR3YAdALReV+yLjfcymeN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741173116; c=relaxed/simple;
	bh=Bf/g3042Wak8eOrAzj9XZVU1E8jDH2VAYy9m7CZ/0Dk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=BOPuomlmRfwmCyI79BPEo+JeE4qYjUQ8z1QAPybbgTc4SK3tsjl5X5BqxDFL/KNbURqEfOTe56Sb9cbZXUiaZL5111rjD+9cSATeEKUMPy2rAEKrP4sY7KQrcMHim1jpfq42DoBBIcxo2+eRXxaXE6EDYsW42FumyxLHb7tc8Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VgVccV3C; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5e5491eb379so5534488a12.3
        for <kvm@vger.kernel.org>; Wed, 05 Mar 2025 03:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741173113; x=1741777913; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Bf/g3042Wak8eOrAzj9XZVU1E8jDH2VAYy9m7CZ/0Dk=;
        b=VgVccV3CLZNld8TM+VmgOx9gkvP0flPOoK6cv/yBslJKJMrzesCUblJHFCtigihdi7
         WkQ6EVV8ziXLyUT9Fsybcxse2sGGGCT5b4nHY3MYEm+FU4VQPc57ouLQyFKowTCLuxvN
         8CV3JSMen9we/Mmk9SuksKe0JH9tzIeK+Vp/dcj/PN5InXezqnJj7I8Ncuon3QIoeL/Z
         GKIV8gVFf/lSfPEgRmqy6VAFnHAiikuP1C+pcV5orl2t7+e37El+EfpYpkVSW76fFEM+
         Rdi8l4sK24fZUwybGYwR2dgG/zuE+mocq5mSDzGkcDUs2g7hzthsX76RE1cJz8mxwIOk
         5c0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741173113; x=1741777913;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Bf/g3042Wak8eOrAzj9XZVU1E8jDH2VAYy9m7CZ/0Dk=;
        b=fj4/8KGBlJP7tel1sSupbViuIxmZtuJKZh4nrzbZx/81k+fNu3447ETJcAmwfdMB3O
         2u+rWlobs1gUuuFgj4s7V8ZjFimtstzYZus6dlsN4Snelt0nlFmTaM5cVuiNJqWlHm38
         hC8kwjX5dxXuRJgCTAk7Lax+vgF3vTxUoBn+GnQgnSyX8+/TzwzkHv/TYyPu8QB6KmMU
         gdIcuoPhbBeMfLiHhYB6GvvnFBsoizo1esF05K5Cqbw7XHQLCtOMXrDkyu7swivJC9Mq
         JhrnvuLd+ne8x0A5VoPNhrMY3XGMnsmyynxblm9Jq2WlONP/s2q3+ZoD/LWdM8IDFY1H
         JQnA==
X-Forwarded-Encrypted: i=1; AJvYcCVSgRDRvPTOJCOCHOxIH9LXr4kzsTOgEIQiw+zMmOi017Txy7Zd91ZfpmdIfhppKoOJBsI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQPUGaN8fLN+fB0h2tRJkJXvSayZ9bctI4rNDUP99ZkfPs+z/S
	FnGQTVoyDwDPdcD+fCfKvT/7NybZ4r9DWQO/bs6XFNPFnJIXgR+BHO0HS8pyRy81imIxAjQrGZU
	TRaGfh8VlrfJoLogbCkoGDiQH5c4=
X-Gm-Gg: ASbGncvrbPemHvw4dCPoxZArWlbw7cjixRo65YxipZqbuFJLm/88w74mTuX9W7Iwy1r
	gDcouH7X6i4XfM9/gsV6mGfEfFg9VrD89y1qTPdTmpzoxp1nR7Jr56CaazhV/oUUqvXSC73oJGC
	ejTHS58Y+3njFb65p4bCjzuGaMfA==
X-Google-Smtp-Source: AGHT+IHG9lmcg6LEBxptug/KrlMBmK9DLefcBHlNyF+EJ3vF+/XciI/lRPEs7d/f9XAedbfMMCdVbvDPup+OljO8RpY=
X-Received: by 2002:a05:6402:909:b0:5e4:d499:5ed with SMTP id
 4fb4d7f45d1cf-5e59f495e91mr2347178a12.31.1741173112770; Wed, 05 Mar 2025
 03:11:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Wed, 5 Mar 2025 19:11:40 +0800
X-Gm-Features: AQ5f1JoYbLuL8OKdiNKWzagF8jwCcr4qGl8blZBQiWXTdOHfRV34hjqkUdJD0RM
Message-ID: <CAJSP0QVzNieSgkecZEjsfjwpQsXL3-7yrwech7-QH433V_u+Gg@mail.gmail.com>
Subject: QEMU is participating in Google Summer of Code 2025
To: qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>, 
	Rust-VMM Mailing List <rust-vmm@lists.opendev.org>
Content-Type: text/plain; charset="UTF-8"

Dear QEMU, KVM, and rust-vmm communities,
QEMU has been accepted into the Google Summer of Code 2025 open source
internship program! GSoC is a paid, remote work, summer internship
where first-time contributors work with mentors to begin their open
source involvement. It's a great way to dive into becoming an open
source developer!

Applicants can now check out the project ideas list and get in touch
with mentors to discuss the idea:
https://wiki.qemu.org/Google_Summer_of_Code_2025

This year we have QEMU and rust-vmm project ideas in C, Python, and Rust.

If you are interested in participating in GSoC 2025, please see the
GSoC website for details about eligibility and how the internship
program works:
https://summerofcode.withgoogle.com/

Stefan

