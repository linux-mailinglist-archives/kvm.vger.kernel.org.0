Return-Path: <kvm+bounces-59923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC8E2BD5638
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 19:10:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 22AEA427330
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 16:49:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 026DE296BC4;
	Mon, 13 Oct 2025 16:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dDYbt3AY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1A628E571
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 16:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760374192; cv=none; b=WL4Rnfg03Zim4hJxvMMsYIZBK7GiHdaLax3OebMiA9O0JjbJHbbBUxNXhFnQN9RI781fIuG3VjZd+bCiNO1lucRYKAbqF9/pzqNJhhWh5u/5OFdJeZgCcUhybOB32BohPJ8yebkR1ry6KBW+L0VkBeGpq1dTbWb5CgQp/wKNDI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760374192; c=relaxed/simple;
	bh=kx5RY7oeloUuI7eYO+d6SROp0dR5EAAxdn5zrmZ7DwI=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:Date:References; b=JYxH6rJ1FwFGet6fVzc2AVP8pCclQIVnY4PXFHglHka1nu/fTv5qweAPBzsCR45ulOujxuj0HMbuN0wNpG7r/AKtXjqxEa4RXxerQYbRnm3TlMGeD3GAf87j1carTbpor5MyI28ICM3t8DfD/7tsRGvZD5EmQ0hr+tZwWJxPOaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dDYbt3AY; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3307de086d8so3629682a91.2
        for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 09:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760374190; x=1760978990; darn=vger.kernel.org;
        h=references:date:in-reply-to:subject:cc:to:from:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kx5RY7oeloUuI7eYO+d6SROp0dR5EAAxdn5zrmZ7DwI=;
        b=dDYbt3AYrsBt7gAEajsrCYu1CKtkOmgXVQqeA/WK6W2AQW/kjmZChSp1xHEOdBIBOP
         tjfpqPRdj0i9nErlbhZQoLKlJ7xCE4oL590RfQGK0FFa8JMdw1+5Yfr9k2lrMj4+z1Pl
         eVf5CA2UWp8qlUJv2TxjPFuUYhTsLftDjdMboCvrYUeDhguZdI4RdlnlvE6RQXBDtANg
         yDPd7JWeS6u13cT/3XKOesDWWzIl+59YHXmbOek6kUoDRjDd3lxBVvgSbZ9dN+Cahr/d
         0SBWZJDd6Hb/pUoOaswPq6DkEtnUtwbQF8PliZn4HUt1XEIm3Z1fzPqcIaZ6bFR7QhJd
         R79Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760374190; x=1760978990;
        h=references:date:in-reply-to:subject:cc:to:from:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kx5RY7oeloUuI7eYO+d6SROp0dR5EAAxdn5zrmZ7DwI=;
        b=qmSLCpGhAeylu3j7NF6a3Wz4PEvtdhO8JSKHIPT8GEEWyhHzJp5XyZzNF0lD6vwkb8
         Crwrugp3OOAm8XvRPe15+cKNJALEXHN0LLhG2hiUpInLvSF2DTtAi7/2AEPNVKwMu3Vs
         MPcjPuFQOG79Yr+kdnTX3z0DsPO+dAPCRs6SVOaNzfDfBOUZJ03OYa7O0YK5W71s3c2j
         KZ/NT4IKR8rIN+2YqxYbvE0ugaBHNRt8P2QbAEopM5u1VjRVZhdF4WFUCM6RopFDX7qD
         8OjSitcs39PmxqSqg1cnZu2Qb8+HGrx/XlSrwDg6fjHQqn1sTlJx8rtENmQKkh2GJ+/5
         6UUw==
X-Forwarded-Encrypted: i=1; AJvYcCUPmyU7nKcxFWPCYpfiGYobHm/tTAMXKa+4YNBgnN5ZxmFSvhz+eLOtLRuRPR6HWKvuYD0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlXqLAnykeTSI5k1nHx9WtHGYeceZzir9uFQwOc9xQPh9xz0o6
	dIzJ5xXHpxzm8dI0UoZfGbKdfhmljzYjtjmxnMZSXDkQlkWXXla4ddzG
X-Gm-Gg: ASbGncsbwjIoqlRXPmgY1LqmrKu03gvhVHwkVvzWWCFOLfvq0DotRa46YbzY8GV3oWr
	GbA5FYSgU7M4retOcrGjJzbPqvOIXD7fvU33PSVdvXUmLQBez5E9ta/QueS1ZDfHlepR1zU1dHR
	zD8z75mZkAx35TAbkF4JT67M+inxdaTnKpqS3cDMDgR2RjNLRDrtq2tiEuRHEKQwAU6jltw0pRc
	GoEymp5d/VF3f7B1Zw930Xfe95Pa1A0AA+/YEszUeUJhuLK8JviyNxDMKQ2QMaipIS4b9N4nHPQ
	L7MIQni4oQk3GXdBnMu33UCDCEgUkK/C00NhrEYTABOCj5IiU33p87w5FDPKONHWCUglP8Od1HH
	Zp6zSKpOpWz6DuEPp8EBB6N8AIt0uWlgn
X-Google-Smtp-Source: AGHT+IHevJcBjt8mHUt/pyY93x641rdKkka0MNqxiQeyFCWUh9FBFG0xSjkzcIivii+OZab9HkGH1Q==
X-Received: by 2002:a17:90b:3909:b0:336:bfcf:c50b with SMTP id 98e67ed59e1d1-33b513865a2mr29845894a91.20.1760374189866;
        Mon, 13 Oct 2025 09:49:49 -0700 (PDT)
Received: from dw-tp ([171.76.87.41])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b7411fcf0sm6811568a91.4.2025.10.13.09.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 09:49:49 -0700 (PDT)
Message-ID: <68ed2dad.170a0220.37a345.0a48@mx.google.com>
X-Google-Original-Message-ID: <87wm4ylpge.fsf@ritesh.list@gmail.com>
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Nam Cao <namcao@linutronix.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, Christophe Leroy <christophe.leroy@csgroup.eu>, Frederic Barrat <fbarrat@linux.ibm.com>, Andrew Donnellan <ajd@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Nam Cao <namcao@linutronix.de>, Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc, ocxl: Fix extraction of struct xive_irq_data
In-Reply-To: <20251008081359.1382699-1-namcao@linutronix.de>
Date: Mon, 13 Oct 2025 22:16:25 +0530
References: <20251008081359.1382699-1-namcao@linutronix.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Nam Cao <namcao@linutronix.de> writes:

> Commit cc0cc23babc9 ("powerpc/xive: Untangle xive from child interrupt
> controller drivers") changed xive_irq_data to be stashed to chip_data
> instead of handler_data. However, multiple places are still attempting to
> read xive_irq_data from handler_data and get a NULL pointer deference bug.
>
> Update them to read xive_irq_data from chip_data.
>
> Non-XIVE files which touch xive_irq_data seem quite strange to me,
> especially the ocxl driver. I think there ought to be an alternative
> platform-independent solution, instead of touching XIVE's data directly.
> Therefore, I think this whole thing should be cleaned up. But perhaps I
> just misunderstand something. In any case, this cleanup would not be
> trivial; for now, just get things working again.
>
> Fixes: cc0cc23babc9 ("powerpc/xive: Untangle xive from child interrupt controller drivers")
> Reported-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Closes: https://lore.kernel.org/linuxppc-dev/68e48df8.170a0220.4b4b0.217d@mx.google.com/
> Signed-off-by: Nam Cao <namcao@linutronix.de>


Thanks Nam for the fix. I validated this with KVM on my POWER9 hardware and
this patch fixes the previosly reported problem at my end.

Feel free to add:
Tested-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com> # KVM

-ritesh

