Return-Path: <kvm+bounces-63372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D866C64015
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 13:12:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8D27135DD2F
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 12:12:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4C8C32C956;
	Mon, 17 Nov 2025 12:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ali2Rdai"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f195.google.com (mail-lj1-f195.google.com [209.85.208.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBD932C305
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 12:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763381561; cv=none; b=VrSzbOjJvv31DiGvyY6olhZhtwyuSr00LtxP2O9OdTfTsNzGMcWg0q/hQg5BaRCmXE9MCozEkCqhDuZdJ5vZaqKQyLU7BQq4WKBJAP6SZzTTjRZOg1m3thT1ZLfd23sRjarZy9fRFBW0Nt+tAo2KmUdlse5b7hAE9/8OtoF2vOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763381561; c=relaxed/simple;
	bh=E7+86nXZJJZWn/7xzDlAAPZqRxbe9WlVvWJxhTPMAAs=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=HrSUIb3Hd5LmKiRuaVwF47Jg/qtpaj5vOfxrwPeQpXvT83jiv9NBoWWUxiH8fGNTzl8RnTh7KWPvxxiuUrKXqAZFyB+uxvxgW1qdgYnnv3ek5LFJ1xcQ8l80ikt+Qoz14ha4yOxieYo+mlzxv+x1G7LrjHV9Msa28VIZFg0I8Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ali2Rdai; arc=none smtp.client-ip=209.85.208.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f195.google.com with SMTP id 38308e7fff4ca-37bac34346dso22249501fa.2
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 04:12:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763381558; x=1763986358; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=E7+86nXZJJZWn/7xzDlAAPZqRxbe9WlVvWJxhTPMAAs=;
        b=ali2RdaiB+PmiBB8rNHxnkHrpBAZaioaXqQwcy5vf4CY5ojDte+J85lR51+AgQ6z6C
         nNpZJBFrttvnGT0Y71tht8/yeDvHPF6Tc9N7i6QJp7/i+sf6L9kXaJROmRaVScaL4lSV
         6nY2Bh88inNhhE1O5WrTG8lErxxNAhqmoy6lyAAqk2LNy/yX8n56U7R+eGdPcqtXwyK0
         EHv5/7YYpj0dh3D0xjNQU0gvMPDkL6sgECKyiUWPPBvY2bLCjDp/tWXPxAlQDlTlrZTd
         dV9Y4qjVEhb85UB3kc5ARDASA8OpHgarPjeQ4YrTAxq5kqaBkCPnb1mQ8VQuKTis9I8M
         8BXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763381558; x=1763986358;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E7+86nXZJJZWn/7xzDlAAPZqRxbe9WlVvWJxhTPMAAs=;
        b=S08+F63ObYD2XqhTm2uhPHoaYQ6xfhC9V1uOaYLIo+d6S/GFU6ZOqU9aVO9ujEJw6u
         bM/lX9v3KMOq905Ead52n6DE5OJzgJIL1Ehuvpg+pN0VcbzT1nhGsKR+Qjgu8aj7RxlU
         0rd0ETXBZX31fww2HjY5nlLYyWsHcFYu8HzzuCQ6j99ZDZJ72BAbglEp2O/EMetfDQNw
         b8U5lrve0qPQ3eYL44XfzvDI9uH4tdHJd2q2Im1HtVIIc7i/p6Ngh2QGZWkIC9MvTFj3
         Net7Lqpa1Z3lBND0ttokgfLbap5Fw7GIGMM2HAjBUxzz/31QhFlD7AEfIK4JDcxiwUU6
         Wkww==
X-Gm-Message-State: AOJu0Yyn8uqhmyRuYtzQ/BODzbcC68FaN8mX0ZrzEs7xco7LeCcim+8l
	/b/1O/WCn/H60n+Mv7C5thVxMfyh15oFgXzpMaEkDrsuUbLRf/3mV7eUpNNoBzqi0m/zD4z7VY1
	OPI/xsLzAwpgkc1wDOqFa7dJyA5fYJpBi0S01LeA=
X-Gm-Gg: ASbGncsFvzeT59+pVLNwAWHIKzqbm9hZnjLM2twiOWfd/znwEobRfdDNtw2+YnB6WoF
	Z/Typfqe3JsGzUhT9UxN7d0LkBatP/EBC6wJAr04FQsbHwMUcQUNLRLjbxWZVnlPL56hqYGyRZJ
	A57YOMQzdcS3wb8Wn7B9CjJTC9wi+S/VezOCyPcpDnWF1cROpboQsLmJiKa2vuVuNrtOEtZV8lc
	p/gEBi24Qj7TT3kZ/psZOKe9DYXnTNYiHGa8QovZg07XU6L6LtCqkHXbBk5E8R9Xpa8E8ut+LyG
	vdBa7FSYQJE=
X-Google-Smtp-Source: AGHT+IEfo5CgAeJLZzKdBiFBn38iawJgBJFcXrFz+/mOlHQT8hFZ4fMPdsD9/XcP14+SL4ANbJtQYytDLLmYSLqryJQ=
X-Received: by 2002:a05:651c:2450:10b0:37b:9110:21c4 with SMTP id
 38308e7fff4ca-37babd5cbb8mr25763441fa.31.1763381557521; Mon, 17 Nov 2025
 04:12:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: yw yao <ywyao898@gmail.com>
Date: Mon, 17 Nov 2025 20:12:25 +0800
X-Gm-Features: AWmQ_bld6LSw6jaPZQG3-XdoPPKfK3S4_7n3klNu9KtEtMieN-nD81-5cNH8Giw
Message-ID: <CAMVsw8x5J+sxJy0E5mFEyBypt4K-jDBYK1NoFh8=P22+2xqBRQ@mail.gmail.com>
Subject: Question about shared GPA visibility between L1 and L2 in TDX TD-partitioning
To: kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello TDX/KVM maintainers,

I am working on TD partitioning (TDX nested virtualization), using
kernels from the Intel td-partitioning repo:
https://github.com/intel/td-partitioning

My setup:
- L1 TDX guest/VMM running TDX enlightened KVM
- L2 nested VMs launched by L1 VMM
- L2 invokes TDVMCALL_MAP_GPA to convert a private GPA range into shared pages
- L1 handles this in td_part_map_gpa() and sets the pages to decrypted
- L2 writes 0xAA patterns into the shared GPA using ioremap() + memset()
- L1 observes all-zero data when reading the same GPA through __va()
direct mapping

The issue:
L1 cannot observe any data written by L2 on the shared pages, even
though the GPA range is successfully converted to shared state.

My expectation:
According to TDX Module Spec, MAP_GPA should invalidate the Secure EPT
entry and convert the page to shared. Therefore L1 should be able to
see the raw/unencrypted data written by L2.

My questions:
1. In TD partitioning, is L1 able to observe data written by L2 into
the shared GPA after MAP_GPA?
2. Is there any additional steps required to make the shared page
state consistent between L1 and L2?

Thanks,
Yiwen

