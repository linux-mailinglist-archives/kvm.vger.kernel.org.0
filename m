Return-Path: <kvm+bounces-9168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D5DF85B831
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 10:51:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0D550B248B4
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 09:51:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AB936351F;
	Tue, 20 Feb 2024 09:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Ejkd3q1q"
X-Original-To: kvm@vger.kernel.org
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436B9634E3;
	Tue, 20 Feb 2024 09:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708422565; cv=none; b=DSb7J9AT7+IIp8yWgkh5c/4cIqYx752JCCjMacdBZrNIWBYzSBS9BDXoo6gLvsx6L57S7Swb3n+Ptf+jyCBOycjykWD03cnYihgEd5p37Kfndrd/2qcP17U0ncruK/X4XiBS7zF3K5KFpdKbsiMhuTcuaOklG5BcSh0k0eYwy7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708422565; c=relaxed/simple;
	bh=sNUETDST/v8hQGqSf1wePFn/eaKqyg242+p8bl9EfMU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sZBmu6v9jPq6+upu5HZ/3LYIC93ymSqdsuFg5S/O3oey38abM3VMPNqcnNxhNTLgo0gsyOr6W8lUjjLXeOXPmipqKLpl08I/vVXxhLgLXnRxM3CF6w55TLfEEtvUBfqqm8K20iROXFexuO0GyBeMiu/6rnKh14vqaKvE9DSFkF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Ejkd3q1q; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1708422560; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=KVGuMbs0Ek78rNZXhgXCoIlF0qOOV7+uQghBDmhesIA=;
	b=Ejkd3q1qWMLFUU+gv9DjfIC2T7WYX3bdfUroJmraAP7rQ1ykqAcaeb55KrtpAzkw3BEojgV7gJGArOCi46RwSqq+GZTJQWiFStKbFYHWOAdvl/QZsLApvci+u1n10wPONJlimOzyTOevtp2cpws4eJk0F6QmgqGAuE1OMYWtNzc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R561e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=yaoma@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0W0wRtoq_1708422556;
Received: from 30.178.67.228(mailfrom:yaoma@linux.alibaba.com fp:SMTPD_---0W0wRtoq_1708422556)
          by smtp.aliyun-inc.com;
          Tue, 20 Feb 2024 17:49:18 +0800
Message-ID: <335d1e82-8e70-475d-a4d5-12dbbd7ca660@linux.alibaba.com>
Date: Tue, 20 Feb 2024 17:49:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv8 2/2] watchdog/softlockup: report the most frequent
 interrupts
Content-Language: en-US
To: Thomas Gleixner <tglx@linutronix.de>, dianders@chromium.org,
 pmladek@suse.com, akpm@linux-foundation.org, kernelfans@gmail.com,
 liusong@linux.alibaba.com, deller@gmx.de, npiggin@gmail.com,
 jan.kiszka@siemens.com, kbingham@kernel.org
Cc: linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org
References: <20240219161920.15752-1-yaoma@linux.alibaba.com>
 <20240219161920.15752-3-yaoma@linux.alibaba.com> <87le7fiiku.ffs@tglx>
From: Bitao Hu <yaoma@linux.alibaba.com>
In-Reply-To: <87le7fiiku.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 2024/2/20 17:35, Thomas Gleixner wrote:
> On Tue, Feb 20 2024 at 00:19, Bitao Hu wrote:
>>   arch/mips/dec/setup.c                |   2 +-
>>   arch/parisc/kernel/smp.c             |   2 +-
>>   arch/powerpc/kvm/book3s_hv_rm_xics.c |   2 +-
>>   include/linux/irqdesc.h              |   9 ++-
>>   include/linux/kernel_stat.h          |   4 +
>>   kernel/irq/internals.h               |   2 +-
>>   kernel/irq/irqdesc.c                 |  34 ++++++--
>>   kernel/irq/proc.c                    |   9 +--
> 
> This really wants to be split into two patches. Interrupt infrastructure
> first and then the actual usage site in the watchdog code.
> 
Okay, I will split it into two patches.

