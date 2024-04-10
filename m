Return-Path: <kvm+bounces-14133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CC6F589FA8A
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 16:52:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A2621F2FE3E
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 14:52:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35A69172770;
	Wed, 10 Apr 2024 14:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0QoNVmXy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36B115F32D
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 14:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712760296; cv=none; b=O5ErFoVc+Vd4LPd2YKBYoXDnEk7An0XSU6Lh+bxhWXnctktA4qGC38d0+1hHVgHteLmoIB7qAvR1+41oroiDFGBpVYcx4ZSFsBNwDQ4jIeK4+T9SjOoO5YUHgmCC0V1W3m9DIOemrKkDvKXBurIzIHd+aJqA74NOv29HeicDaG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712760296; c=relaxed/simple;
	bh=vdSS8oSfCOnVaZjt/jgZZmNqUFixNGmzq6ar9ljb28g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=exNx0aNkKGV7JdfRvyrbODRqESXTa7H2E36+sQas/k/nPbzhx4bTLB3dL9aTjZffga5mZDxO1tTgInUC9DiHaWiI/iPnz2dRJEbjbG63hs1FSucefIO30wjn9zk0/Mq/UJ1dnA3ZlXDTryhMlrse410evs4RDyxpSfHPMk+0URU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0QoNVmXy; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a51d05c50b2so450845366b.0
        for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 07:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712760293; x=1713365093; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SorY6BMN4ofXw7AkV1BJGHD1ZDym8XWxLWPHdQQ4SL4=;
        b=0QoNVmXyB4dnB6lTwQIkSPzfyYDr+vAVVcjzKJYuPxl7aiHjhsWz9V1jO6VMb4ckeA
         uG0Z/B5SHxTvG9fHMXnB8jpuiDB+qfEzIJ4Q0nh3nPAN8/opKPO9oaakX0Yb7iLrDucv
         CIeF6zjNkw3LB52EAI2hrFQ4FzIMGukrwsqiJxkBYB8anvxL1qNrdjaAGS3MSxZkzht3
         YlZ/zp6beEf1K40W3G5SU8q+1XWDHx1o1gbUKrWIUfHmMYPZ1qpNlVsLIIqnlFytlKfG
         O0PQzjVLDxEenSsPtDG3BJkbPs+EyBgTkpJ908B6c7pbRlQPYoCIQiD4DQy8p7lSus97
         Pyug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712760293; x=1713365093;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SorY6BMN4ofXw7AkV1BJGHD1ZDym8XWxLWPHdQQ4SL4=;
        b=ssMMYDUw35TaHiFsT1NvEkd14uzuRCnMGzDeqowYwBimQaVMiOOwGOUD1miIXQzCSC
         xjmFTZkiO5WIgGpEAIn91Dl8Rze0Du5ZIEzv1mKGolT83zzlWSy6a7y5z2u/aUnRk5dN
         7G0wjAjmctFuECTYujQE4z/cAEXd/zwxHOSdgJX3Jnh0IlJ4nbYbgbvX2Dei3pKhWaM1
         f9YOa7mA5WnYIqwRlv/PaIx0mKXHnz5pTiirRslLkSRT4Le7EqBNGS1hZV+msV09Y9k/
         fJXq0ci2FNeAiy0TuzjDRMr6i2s4Vw0A3/VNwVVsOaqGwj0QpmZ44cfJEshwPNVKNgay
         eRfA==
X-Forwarded-Encrypted: i=1; AJvYcCWhuaFVi/3Hce8IjpC/UBYJgzs5+NCpdU/dRWE3ceLjIvVKEaWJr4sUmWmgih5nDkM4YMY41z8IGef4f3U0y8phajVI
X-Gm-Message-State: AOJu0Yy3pKFQSWa+E7TdlFCZCCqaN4JPtUJS8DD2TJhzkfDXEGz5/15w
	3STxpLiitl/QoKnik+KHXVXkQEdFdVeWj3gjNCETR5C1eMPaRHKNzPSJUfQ4XJHukAfXRIKo0+Q
	qfQ==
X-Google-Smtp-Source: AGHT+IGxJ9gIqQrf+HvEjnspNjc7cdxKHlWD5YVIJkYKWhir2ZuLe/UJfbhkg/iRaUNh0SAoCgtxig==
X-Received: by 2002:a17:906:ca91:b0:a4e:62b2:a09e with SMTP id js17-20020a170906ca9100b00a4e62b2a09emr1635742ejb.35.1712760293137;
        Wed, 10 Apr 2024 07:44:53 -0700 (PDT)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id gz15-20020a170906f2cf00b00a51e9b299b9sm2402050ejb.55.2024.04.10.07.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 07:44:52 -0700 (PDT)
Date: Wed, 10 Apr 2024 15:44:48 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 05/10] KVM: arm64: nVHE: Add EL2 sync exception handler
Message-ID: <seowwg3mfexvtif3vtaxkxttrsfdputkwcb7bfmjuqk25xdoz4@ez2dapcfsfe4>
References: <cover.1710446682.git.ptosi@google.com>
 <cebafe40b170589d52e2ef66f3bfac7396fa1f56.1710446682.git.ptosi@google.com>
 <86bk7d13uz.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86bk7d13uz.wl-maz@kernel.org>

Hi Marc,

On Sun, Mar 17, 2024 at 11:42:44AM +0000, Marc Zyngier wrote:
> On Thu, 14 Mar 2024 20:24:31 +0000,
> Pierre-Clément Tosi <ptosi@google.com> wrote:
> > 
> > Remove superfluous SP overflow check from the non-synchronous
> > handlers.
> 
> Why are they superfluous? Because we are panic'ing? Detecting a stack
> overflow is pretty valuable in any circumstances.

I've reverted to keeping these in v2.

However, the rationale was based on the assumption that the stack overflows into
an invalid mapping so that accessing it post-overflow triggers a page fault. If
that is correct, can't handlers of non-synchronous exceptions just blindly
access SP and rely on the synchronous exception handler to catch any overflow
(and somehow handle it or panic, this isn't really relevant)?

In particular, note that passing those checks doesn't guarantee that the SP
won't actually overflow while the handler is running (as most push to the
stack). In that case, they'll end up in the synchronous handler anyway, right?

So, given that the checks seem (to me) to happen at completely arbitrary points
in time (due to the nature of exceptions), it is therefore not clear how they
make the code more robust than not having them?

But I'm probably missing something?

-- 
Pierre

