Return-Path: <kvm+bounces-34620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63F0AA02EC5
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 18:18:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA0933A4603
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 17:18:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C930A1DEFDC;
	Mon,  6 Jan 2025 17:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p41AdQMO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D32516F8E9
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 17:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736183888; cv=none; b=KZ5173pyQmloZIchw5GhSWzB8/sUONE0/WdCP8LrNXv1LaWn4WsJfpJbvfbRXJSGKzLSkupi48Y3K7pUTNaVzn5J77RoJyZqERK3x2SjjhWWfQ+GZ7mSINNngITVg2V0Nh7+ngs7/aQi7YhpnhrLFbGfL4IRwFUdkS3nbO9NazI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736183888; c=relaxed/simple;
	bh=qXFqgqxAqyUeWVPBcafW/WpP7kiQQk/e+qd5C+KpIfU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=maurJGqVgXzHmqgwyDjMVAysajK3PIvtpTy5I98XTclHnNYPrzIVes/hGc0nzSo9MHtib8J/5HFPCxo4ZG9qpk6H57DRxKBVb7bgGvObuwgW8j53aZ+TK5oyOWydnD8P0uDFeDhuJTZxmm1UM0t+lAwqn4ioiynFfo6HB2RNttA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p41AdQMO; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-aaee2c5ee6eso1669219066b.1
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 09:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736183885; x=1736788685; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qXFqgqxAqyUeWVPBcafW/WpP7kiQQk/e+qd5C+KpIfU=;
        b=p41AdQMOHuVrxZpkejKn5c10cGK8XlVRdwlKTgfoUoZrSYEBSiAOKoxiIgV5wc8/3W
         a1NEpIEQ2c04eVwyfAgnt+qRQjdh/GAbB+zz0Kxuj7UFTx2Z2wMusWx+IEfriXRL8ME1
         l6TqH4QeDWdfpQTmsk2IVgMOjB2vRQ0yG/MYdyJO9TJp8B+ic66ykOPWFJIyWp5rp5Xa
         kaMwnRASy9CVaJUw4Vz0Iufw0aC9S1CarlAeUdj1/zR3ng2Zc1bGAdu2ZXtBWNk6nGmv
         /R2s0HEq2F02ZHGuyxfwmUCsSmMMmw8s8eOxpCriqooG8Vy/31dfDb8JTNI63eOLNveM
         okNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736183885; x=1736788685;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qXFqgqxAqyUeWVPBcafW/WpP7kiQQk/e+qd5C+KpIfU=;
        b=ukmQSiRQEiS23+a/dt0mUy62rzLVXwCd4koJwStGbOMCRDEorjmVjpj2h4hsSjI/89
         HacIY0Xp31sMc4TDfz7O8azWPRiW61RnJrHGZGtxz7rB+KUXjhpfK2S9BZy0Zpq9TDgn
         rA90iRQn4ZZH08I7Va72AsKBX8Lt2FubkHt3F9uVhSkXqRdkwYQmp5BxI0y5ffkJP5EE
         JgcCrQ8hGmXvg92uAp9nfpNOV3Jks/CRDO2XjRTa4xeAcRj39ESkYWM3xHnqBu5Q9MqF
         89YmmPUxnFVCwlrmZd/ODsF4LjqVGLcbtcYzujgKq3rwI2gtQN/W8VB5jVeoWjGF0NbJ
         Yb1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXP510L1UTH1OtgsIqRUfx7tthwkIq0tKsIYW24kbFmt7Xw+tZCFm2jcfRo48+k3o3tsa4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxya2Y/7OKUSwQyMdwq/+aY6wJG64AUhixdxjn3mTRZ6Gp/sxxU
	+waAbQmn4WX2IQdt4BwU4eoftIXQKdUNzQpqIaxTNRztX6O4cec+rcVcJ03SVZpYySHSnJtx8Ll
	esJNFg88OrJb+ZBrR1PNCTT52i6wSPmTWSeG6
X-Gm-Gg: ASbGncsy3dtyjigruuAoYQFlVw+k8NvQgEmUZusxBALFjDLVwaQ0WbzAeFJ+8xjDpNG
	5aZ7HPVI1r7cd6coUIwGlrmJ9OP41oJSpHjzaXtmAGc+cjmHRsNvkpS2yexdNsDAcXW+Hn0MP
X-Google-Smtp-Source: AGHT+IH4zhvWlbTKOD8lvP8RMMKJA0yWR5I3TDvRZlab6xY+9KB36ULJffWZ6mcFIjwUzAEqY3NRwnlWiKUO7EH3Sjg=
X-Received: by 2002:a17:907:96ac:b0:aa6:59ee:1a19 with SMTP id
 a640c23a62f3a-aac348c4720mr4648129566b.60.1736183884594; Mon, 06 Jan 2025
 09:18:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1735931639.git.ashish.kalra@amd.com> <707efae1123d13115bd8517324b58c763e9377d8.1735931639.git.ashish.kalra@amd.com>
In-Reply-To: <707efae1123d13115bd8517324b58c763e9377d8.1735931639.git.ashish.kalra@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Mon, 6 Jan 2025 09:17:53 -0800
X-Gm-Features: AbW1kvYrCxcJi7iB4tiG8Ua04Oabv3b6MoW0bEbHV4EKkOFCLYtAjLUDnY9Vig8
Message-ID: <CAAH4kHb6-us9a-GZhXEs2Ah0aQp5YwSniHVvJ=QtuiJF5LTrAA@mail.gmail.com>
Subject: Re: [PATCH v3 1/7] crypto: ccp: Move dev_info/err messages for
 SEV/SNP initialization
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, thomas.lendacky@amd.com, john.allen@amd.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, michael.roth@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 3, 2025 at 11:59=E2=80=AFAM Ashish Kalra <Ashish.Kalra@amd.com>=
 wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> Remove dev_info and dev_err messages related to SEV/SNP initialization

I don't see any "remove" code in this patch.



--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)

