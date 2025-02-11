Return-Path: <kvm+bounces-37812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B2FD2A30336
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 07:05:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E6231889877
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 06:06:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 076B51E633C;
	Tue, 11 Feb 2025 06:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="fqFSAtw1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830CF26BD98
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 06:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739253951; cv=none; b=HWSefUkw1vBQRnuKiW2h+joo5EpwLh687T8ur1fsoOIRkENriDzlovmXWo0/R3yATU8EO1lu6krun163/EN6xc4syhSFMdc8YKLGmUiZ0ec8usYywVWWAwpVCU1zfd1SvWL2fnIVFG1OthJUZNr3HE+TnmRcPbaskT8AutzJMwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739253951; c=relaxed/simple;
	bh=etI1X9YYise9QDMvacxx/FUON9SjznTzXVvKpdWkWyg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NpF9DgovvONxB6O+8ItidkpcjzB4Nk7lTdewfI6YxYAMeM1TWryrHA4vibkslmcVyuJ1TmxrOfoac47qZvBqeJf40XL5wgaRvVW784qtqQdolU7uybEsgoQT2qErlPq/M8QGDnVJ6hQMGP9OMZLu+u9xgPDBxgYR8VTb18SMQg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=fqFSAtw1; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-21f61b01630so52357975ad.1
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 22:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1739253949; x=1739858749; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0MBqIRdwxcxCwshRcxNA0crppewQ5oTYfihHZZAluN0=;
        b=fqFSAtw1ais+++FtIWx5Ockf9NzVWgV41LWrtowuNjFu0OfZA6DQRtoYipKUvfK6x+
         m5ikmfseZwYpKJ5Y1GQ0C5HOiOKX5R8SED5ksq6lJVvBF4rDC68UTA9iyV2PqOPz0Xwt
         ayxfHmksQcR1srsrlKVW4GHsJYAeisrQOEf2AJeSdygvWXfrQQ35zcXZ/5UqJLrx/vqr
         6Xezfs1SMLP8jo2BhlbtzY75T3cDHBgI24C9sfkBHsoMNaoTZYEFgF3qzUYcPhE/4byo
         H8qodEZcnanpfz882r3xYPvX1nCHBlvacLxTUjox7QbPgXDI91ox2A6zaTb0xzWL5yNk
         HUhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739253949; x=1739858749;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0MBqIRdwxcxCwshRcxNA0crppewQ5oTYfihHZZAluN0=;
        b=KKEEK9Zp9EawdUl1d2vD+BSC5C/YoOQHBXOoUmZWFrmca9LfPDzLuY5Ai7Qbmat6Ah
         e97AVEchl0aQL3P4vj3S968ln1U6D42YOS9heTn8vuZ5rHbWJ/sZI5l6aulxbg4ERmJz
         mzJGOLxIj9omRuPZnR65W2FhcUbGbPYkp3IFft2lOYl1OAJraxPFxvaCjwO/eKgHoLif
         7jN+CqOep41cLTK0aH0nTnb+m/TnxHJUA3Xf64el9IdreuffsNUKuY38dZaceddDu98t
         0FSAfOe+DZrbzGOWcs0Fqit7y7vNH/vziHHfzlhctj4U/N2xoCqKX8R/dXpyMuh2+ITn
         Mkfg==
X-Forwarded-Encrypted: i=1; AJvYcCWxvuBXcykyliqnZbAz/KpepVa7WPhaXhUXrt1mBOf+dWJP7cb9pMZlKId7UWmtiapES4I=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFsmOg1/WaR4i5QQI+1bE3665xCJFDxthU0G2dizqZVbLy1mWA
	QzlSxMIRESUEZkL5GKD1LL6WWqHgJlFUF+ljkcWxaF3da1kQlbJXEr3yYR4WQ8o=
X-Gm-Gg: ASbGnctMNBTq9wPW9fqatOVJI/43fLIyqzQYYkG6v00IMfI1Vfjm0hS4dN365UTXYRa
	VRDtbBrA4BvTRb+3E3xT0HnaVd2yqIzOk9eYqk2cRqNBdUxvOk9EMy9t7ZHFNIa/g6QSvfvv13s
	8hZObo0bKvDulu4q1+epLIqs9OB/K3b+Hqqitj6D45dS3U3FprRzP40yrFnuQ7PwjvOIDAo3QWX
	r5yfHq5sI9dSb33Jym4DjhVeHKbL6XcE1t8G86Mk5Bk4N6Wf88Cts9bQgYz/VpehuCNHeIEhqwe
	JQYuPeIoKnGSjzyhYj/5HLujgA==
X-Google-Smtp-Source: AGHT+IH/1R26NlLJZyOyqaoXeZYqCyF01+N1vBhKDh4u7o7gbIXbZU50VOk7nAyf7jdBnJTufNHygg==
X-Received: by 2002:a05:6a20:244f:b0:1e1:a920:225d with SMTP id adf61e73a8af0-1ee4b77355fmr3102269637.19.1739253948792;
        Mon, 10 Feb 2025 22:05:48 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7308aa3a1cfsm3437000b3a.137.2025.02.10.22.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 22:05:48 -0800 (PST)
Date: Mon, 10 Feb 2025 22:05:46 -0800
From: Deepak Gupta <debug@rivosinc.com>
To: =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <cleger@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org,
	Samuel Holland <samuel.holland@sifive.com>
Subject: Re: [PATCH v2 15/15] RISC-V: KVM: add support for
 SBI_FWFT_MISALIGNED_DELEG
Message-ID: <Z6roumtGyFOfoOiw@debug.ba.rivosinc.com>
References: <20250210213549.1867704-1-cleger@rivosinc.com>
 <20250210213549.1867704-16-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250210213549.1867704-16-cleger@rivosinc.com>

On Mon, Feb 10, 2025 at 10:35:48PM +0100, Clément Léger wrote:
>SBI_FWFT_MISALIGNED_DELEG needs hedeleg to be modified to delegate
>misaligned load/store exceptions. Save and restore it during CPU
>load/put.
>
>Signed-off-by: Clément Léger <cleger@rivosinc.com>

Reviewed-by: Deepak Gupta <debug@rivosinc.com>

>---
> arch/riscv/kvm/vcpu.c          |  3 +++
> arch/riscv/kvm/vcpu_sbi_fwft.c | 39 ++++++++++++++++++++++++++++++++++
> 2 files changed, 42 insertions(+)
>
>diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c

