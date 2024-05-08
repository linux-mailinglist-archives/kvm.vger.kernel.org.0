Return-Path: <kvm+bounces-17012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A36A08BFF44
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 15:47:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 431D21F29688
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 13:47:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7AF485930;
	Wed,  8 May 2024 13:46:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD51E85C74;
	Wed,  8 May 2024 13:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715175988; cv=none; b=V4QLJkdmKBUFLLvB+0NYJfLYMl08qwFt7YoS/1QAq/dtviY4lMI2/rTn+Ru/XavFfgqBX/IaMEQ+Ax6Nzc9hW+hOIo2e1RxUFASeqlCZOb8JqNHWtiNrTRYyEslXSt2zmgaOB04W8svnWwiX6ClcVAesOdWzoU8/ETX1NDlxyqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715175988; c=relaxed/simple;
	bh=QdgvVBLaGVh8Hgex4e8pqIu0O0yKM4UstbHMpQAL9fU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=oisu6EaVF1pY7AjD3idU++EOb+lRW4ptoksWLfy9A9a8/zytpX0F43otaBCaepox9OMAPzX0wFOwGACfAUTa3ZENpc2UVQ8WHPvdSnrNmRmmAGfSP9JBiLrMuAf9qBMgyhtzYawhyCM0zbM38IpmXPsrE+oJ42z83RWiauck5zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4VZGdY2PzCz4x30;
	Wed,  8 May 2024 23:46:25 +1000 (AEST)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, Jordan Niethe <jniethe5@gmail.com>, Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>, mikey@neuling.org, paulus@ozlabs.org, sbhat@linux.ibm.com, gautam@linux.ibm.com, kconsul@linux.vnet.ibm.com, amachhiw@linux.vnet.ibm.com, David.Laight@ACULAB.COM
In-Reply-To: <20240415035731.103097-1-vaibhav@linux.ibm.com>
References: <20240415035731.103097-1-vaibhav@linux.ibm.com>
Subject: Re: [PATCH v2] KVM: PPC: Book3S HV nestedv2: Cancel pending DEC exception
Message-Id: <171517595456.167543.8572230162605343190.b4-ty@ellerman.id.au>
Date: Wed, 08 May 2024 23:45:54 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

On Mon, 15 Apr 2024 09:27:29 +0530, Vaibhav Jain wrote:
> This reverts commit 180c6b072bf3 ("KVM: PPC: Book3S HV nestedv2: Do not
> cancel pending decrementer exception") [1] which prevented canceling a
> pending HDEC exception for nestedv2 KVM guests. It was done to avoid
> overhead of a H_GUEST_GET_STATE hcall to read the 'DEC expiry TB' register
> which was higher compared to handling extra decrementer exceptions.
> 
> However recent benchmarks indicate that overhead of not handling 'DECR'
> expiry for Nested KVM Guest(L2) is higher and results in much larger exits
> to Pseries Host(L1) as indicated by the Unixbench-arithoh bench[2]
> 
> [...]

Applied to powerpc/topic/ppc-kvm.

[1/1] KVM: PPC: Book3S HV nestedv2: Cancel pending DEC exception
      https://git.kernel.org/powerpc/c/7be6ce7043b4cf293c8826a48fd9f56931cef2cf

cheers

