Return-Path: <kvm+bounces-8047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7270E84A8DD
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 23:14:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A36BF1C2720E
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 22:14:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 304765D8EB;
	Mon,  5 Feb 2024 21:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ArPNtNkm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096914B5C1
	for <kvm@vger.kernel.org>; Mon,  5 Feb 2024 21:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707170189; cv=none; b=ppUIG3Gd5atqgEjHHMs0dcw9FQr4LOprYOMVtXcqB04NXKCc0cIm1bQyuDdYB260Hhg2IL4A+8/GjoCgLUztrwCcRYtCrFF4InT5BsS3td587OO/RSKj/VDvn4MAwuX5MX8cOcqXeB3zR1mr9pSPfmGuwOfdVJ1wE3m0f92LVXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707170189; c=relaxed/simple;
	bh=LQnuxU1HCojSqMw5PprB5FS4EXyL1CKa2bYivcpQ2Lg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=a6N42MVGrHb3N3nKpqevr6ZXjf43TJJilWmkps3xqct0jP2n7JQKcGhlr4bKs+pO9Rp2Wuitrf6EOECamxqnphN7WM/zCdYQNOtG6BXzybD0/PVk1jeHictXjVj5sWfm2pG+2FVuL8Z2j82F0hyV07ObJQ1nt0KiT5mMaUcADg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ArPNtNkm; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3bbd6ea06f5so2038005b6e.1
        for <kvm@vger.kernel.org>; Mon, 05 Feb 2024 13:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707170187; x=1707774987; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LQnuxU1HCojSqMw5PprB5FS4EXyL1CKa2bYivcpQ2Lg=;
        b=ArPNtNkmLl+/VNZEWwUmvWoJQPsT7ex8N3Hc29ZjTBfYFbpFUzPVn5eM3bypbh7hiL
         cjAmELZLgmbWYEn2XHjdZGzTg3DYo+kO8+pJ/MMpVXDswb6qubDbeYEDHFpwhFtjPwrN
         dkF8jOntdyhw8w+j0yDyUNx4qhdj2DCa7XQM0SABVk29HWP/QiDRzLoZMJSrKaV8/wCA
         6FPbKq2N/n4zKSdkDHW99EJMTNlyXmLThVBctSwTMxl0Us2T/0P5glcheJYEHYZ0pjBz
         nLnFCkFvgzbsNgZeALp7yqg15d9cF+LfbCYd9kNPejM+60s6k+l2VuhvO8B3XMfoQ508
         Hdqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707170187; x=1707774987;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LQnuxU1HCojSqMw5PprB5FS4EXyL1CKa2bYivcpQ2Lg=;
        b=pPEW65HOroaZsUCiSPdnOYGNjTXrUb2+wCsGQo9E1fTLZl5khMRZaSMyXjTxNU+7+f
         y+wIek8+xgYJnKk+nT4Hv5Ny6d2gwJQ6+MOLw6uZrAuvvHSjWOZnORMeSXNco5zKIDKM
         kQN9vHO3mdEi+pYAZl0LvbZFgJtJoS6MCD60Thsw6BKXYJfLkQui6vuPh98dtOTnrL1C
         d2PI/rUFERNDgMseOfDR4Atx7oui8hMFzZ7roltwb+0py7UIZ9ACfaSWMqcVTsUjJkyb
         7pEMVpGfZ5JQxm5EKXxqvDZQ6OWUp+ZLoN6xV0/7xQf1yaNGVieMqR6SmBFchzk/A3Y/
         tBJw==
X-Gm-Message-State: AOJu0Yzb2R28WXyXr9WcoDUok8nwD5ETsyjXJsq8zClqPRCi6c0tvV+6
	b7zqg5efaMhR51HIp9WVIxp492Oa3xossrtTglGpqIrfHhVpfFYoM0M49C24Yoa7Kz0MCKtJhHF
	2SmP+djblic7zXHM6Fyy6Vm/jRXM8U/2kFhvcoytEbOSY3UQgKQZQ
X-Google-Smtp-Source: AGHT+IHJCzG1k6t5OdcSqCWDVM4SOxp7IeB0S7XvTeXg+mqlm+3/G/Uf+RVBY398zcSVCl+WtTQmgetcUCIIme3Sr3Y=
X-Received: by 2002:a05:6808:44:b0:3bf:cb83:76a7 with SMTP id
 v4-20020a056808004400b003bfcb8376a7mr450140oic.5.1707170186948; Mon, 05 Feb
 2024 13:56:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-6-amoorthy@google.com>
In-Reply-To: <20231109210325.3806151-6-amoorthy@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Mon, 5 Feb 2024 13:55:50 -0800
Message-ID: <CAF7b7mrOuBS=nOAy5QbVpR_TzsOG4Kop+_TiD7EZVYATvtWFDg@mail.gmail.com>
Subject: Re: [PATCH v6 05/14] KVM: Try using fast GUP to resolve read faults
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Dropped as per https://lore.kernel.org/kvm/CADrL8HXSzm_C9UwUb8-H_c6-TRgpkKLE+qeXfyN-X_rHGj2vuw@mail.gmail.com/

