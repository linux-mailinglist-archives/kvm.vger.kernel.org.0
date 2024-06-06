Return-Path: <kvm+bounces-19004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DF5F8FE36F
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 11:52:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03D30281412
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 09:52:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF33717E8F9;
	Thu,  6 Jun 2024 09:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="gtk1a9bp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F7F178CDF
	for <kvm@vger.kernel.org>; Thu,  6 Jun 2024 09:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717667533; cv=none; b=WXjNG1oibGQ4tmEZFDdD3t40Xs2bet1rqk0ymKwgAQ0YW1HiBFPjX9HCB5ndITCjl15LCItcPDzSHei4t1d0FCRsRurjPu5Uyd1F3pYE25erUa3d7GrMbAesD85fU0mLyOFNtFKnWjwKu4DMJlA+ML/nvfUtfIELXx6Frfrlix4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717667533; c=relaxed/simple;
	bh=hzMInXZBrq08VfXm9EodIoLXJ2qNXwWHpR/vSZpB+as=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XcoJHho3tbUPdyNSeOnPGDhGMcpBtr3xR2n8e2c1geblnEkly+0qdcMeIkxNWHz5FuZJO8e+Ih+kqaUGUT2euJARCwKh1h5H4TaQJcpuGP1bbQIpdfnz4DJAwDHXHB7/Dd0RhpB9sGqOPPpR8k9r5OuOaDiP4sZtvreX6Dso088=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=gtk1a9bp; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2e95a75a90eso7630801fa.2
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2024 02:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1717667531; x=1718272331; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hzMInXZBrq08VfXm9EodIoLXJ2qNXwWHpR/vSZpB+as=;
        b=gtk1a9bpnVtDocVdEOLvEOtSatyS73dq6dJfgs1U+WASwtsiqzSuVhHfb0c2T6rklL
         HEBfmgXDL587gyb6sDVbecdU7maBaPvdxalvbmUw4sBKfUY8EXlOtU+hzixVOJiw1Z1t
         iVw58P5FR2jo1hocr6P6kJCmL9NRP5QSG28dofAGZiMyFrUjBqtV6fQbxEP+PprfUYmn
         b00b1+BLLIOROzaImz6CTvHi4mN3qzotw+BiFqecf0LMDG3TQ0t7plzlq9usP4L5CWsg
         FEhh6cFj8JH7pmSvVSFy5LjBuer4lKhswukaCZDnFfBR5XwmuSjeXKTQO36uWCzQ10b0
         JiMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717667531; x=1718272331;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hzMInXZBrq08VfXm9EodIoLXJ2qNXwWHpR/vSZpB+as=;
        b=TKf4vHKELnxLGf48BbmRqXNLhOcisHOsH19iXdB3tzU1BZU52GwZxZOzxADPyYIpjg
         KyJDFTPPwOIqBHFUrnDJwuwtfXvqDl84VegkvPslHnkyCJesZAl9E5q+zMNmVfGVPpsW
         a3+3a38HBmgI5qylllG2uCpohj1n65zpqvPE++4RDjaPovBmqW7Hc44gMJvRxnUrMDPi
         DdpImHIeHr/QiscblmHfsn5igzdFvC/ju+Xp2ETlbE4/WTVtlTbOqcb3JOuD80MDmZhc
         3gEunf05usqdB8HUd3CTEFqXq6M12IEfxnR20RFqVGVnyHEAY7WhFulcxFn7dDPlVNos
         53AA==
X-Forwarded-Encrypted: i=1; AJvYcCXU7Z1XM41WPj3sTJgRAg/8wOhE9qOsKgGB8YvSwMulySPaDD9OZzNskiUABwzRwswxWQi4UkZRnLlysfbIx+pE7cVe
X-Gm-Message-State: AOJu0YxMGTYXLUj4vhrz8S21ZCb8IKnFYpVv4+kfh1z/po5e/Gvh5mXn
	5xW8rMTkbKlv58dLfLA+wreS1QsvYPJ92rLdswdf7lFVvY2yg/yVcKe+TLIEw5oTkig8byAoaIM
	ux8PTHS4a+9+5f5e7xRPHAfsIp6Qvt7KF3yEpBQ==
X-Google-Smtp-Source: AGHT+IGRjxg5JxSkcZ0TIa9nvKzj+6js95PShzriLgFiyIk8WZvSEOxoci54ygHxxx3XlK6Ngc3iCOMpgDTyPLdieC0=
X-Received: by 2002:a2e:9617:0:b0:2d8:3e60:b9c9 with SMTP id
 38308e7fff4ca-2eac7a82898mr28203101fa.33.1717667530690; Thu, 06 Jun 2024
 02:52:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240422080833.8745-1-liangshenlin@eswincomputing.com>
 <20240422080833.8745-3-liangshenlin@eswincomputing.com> <mvmr0das93i.fsf@suse.de>
In-Reply-To: <mvmr0das93i.fsf@suse.de>
From: Anup Patel <apatel@ventanamicro.com>
Date: Thu, 6 Jun 2024 15:21:59 +0530
Message-ID: <CAK9=C2Ug2gcS5Rbqc9EQ6mVwrJkoeLscOm6wtgqGKHdqEdSpSA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] perf kvm/riscv: Port perf kvm stat to RISC-V
To: Andreas Schwab <schwab@suse.de>
Cc: Shenlin Liang <liangshenlin@eswincomputing.com>, anup@brainfault.org, 
	atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com, jolsa@kernel.org, 
	irogers@google.com, adrian.hunter@intel.com, linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 6, 2024 at 3:10=E2=80=AFPM Andreas Schwab <schwab@suse.de> wrot=
e:
>
> On Apr 22 2024, Shenlin Liang wrote:
>
> > \ No newline at end of file
>
> Please fix that.

Fixed in KVM RISC-V queue.

Thanks,
Anup

