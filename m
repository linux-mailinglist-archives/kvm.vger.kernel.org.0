Return-Path: <kvm+bounces-11547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6230187818F
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 15:25:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8512D1C223D3
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 14:25:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C767040BE4;
	Mon, 11 Mar 2024 14:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dPrLP6NG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FE040843
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 14:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710167048; cv=none; b=qmVCMFGjj+Kg1MF8tCrZKdOspv902jI2AwwHns844+ZrYOk8+q1G03lkvpSYOegOGFZ2jqsi/8MRac1gc2S8P+51gjB0YgtmhWLI+gBsCjhygcZWClbm2v3CY08t5jdFMG9cP2ASUX8WG+Gl5UyM9rHCfu4uS6cf4bwOF9G/3oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710167048; c=relaxed/simple;
	bh=WtQgGWTYQaJiOa4MFHOZ7vxpiFJed8s3JLi/LtYBqok=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SZnVQeRBLQO/VxbduxhwBipw2XFzg980+pIyLhFVm+Tt0x7NNiLn1t78J6rJIhk8WZ/ZA+RRrbThg8xB57JegQp0vzJ5T1uvRPpvwMHKikPE2WkiNxYbc7f1XvP+pYlBfqiJlz4TptbbiM1kdsV2BTA4uOOlZDW6yYFc4y5V2Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dPrLP6NG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710167045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=F82riURCH1Rw4V0//PIHQvW551QBq40hiU2IYotc7wY=;
	b=dPrLP6NGFOQ/DPlW53qHjGAC1s5ngPS98VbDwVb5dDZE2lfd8vc8kbY0M4+nNZEcqbuInw
	4LwxSnDk10olTdFxWk2p/3YwvHTcfiygWTrLn+9TSjd71v5ril+qWQzPvHNN5GMqdD2JWE
	4TLnscI9FPVQ0sGSPgZW67td2mUybTk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-398-Sk1PI1LnN-G3g-ftsXXp5Q-1; Mon, 11 Mar 2024 10:24:03 -0400
X-MC-Unique: Sk1PI1LnN-G3g-ftsXXp5Q-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-56864b8f5f9so417119a12.3
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 07:24:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710167041; x=1710771841;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F82riURCH1Rw4V0//PIHQvW551QBq40hiU2IYotc7wY=;
        b=ZLRGSDjPUgiiZStnHMUAs2O4gdOyjHegjNWc/b2yqQWxg8kFVgUxnbtScC4GQ2TO2H
         +v+BVdIZsSHtRpIonpPUNYLPX0PhyhmU9ZI6hFM5EwBXxv/uzD+IJMkUUT8cztlRctHw
         znYMINEpCH/WF6XpNuDlfxMiBOlzUzMfxohX0UxHFzd2MMJzpmSs3/RSeQUbJS5gBDsF
         9DI/gbRtfINtCUWBDdbwo2UOTaHDGB7jst3Bqq5oKOoI2XUME7e596Rrg2T99FyPrlHa
         7WfwP573H0yNhplQwv4D9tdXdTSJ2GXx6UNebAL4rnbBCnmqN/0xQ2FYQRCi+Tud+s7O
         X0Kw==
X-Gm-Message-State: AOJu0YzX1/wsqTpMLTNSByQGEWJdPwpuJ6B++F98hYh4ZxaIDyuZKAzt
	iykUAJu6R1GJeWMc3rWm/NVJht5O1XLNuNPzfJsDrVzoN/hncs+VqQ4FDnGEVQfE+7liC6cjTpv
	OWYjlVcf8eiDUUGxcnV5fZPdhBYbIqRkhpDb3aau1YNhYSbGYLQOvmEjY4g==
X-Received: by 2002:a50:aad2:0:b0:567:f643:fc5c with SMTP id r18-20020a50aad2000000b00567f643fc5cmr4877251edc.20.1710167041233;
        Mon, 11 Mar 2024 07:24:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGX2VUjZWCtwumP/VuHCCROXiMHAwvgO6QmF1POjR0R2ICy87/7cFQaYC++uQaOwCricWEoIQ==
X-Received: by 2002:a50:aad2:0:b0:567:f643:fc5c with SMTP id r18-20020a50aad2000000b00567f643fc5cmr4877240edc.20.1710167040950;
        Mon, 11 Mar 2024 07:24:00 -0700 (PDT)
Received: from [192.168.10.81] ([151.49.77.21])
        by smtp.googlemail.com with ESMTPSA id et8-20020a056402378800b00566a4dec01fsm2972343edb.11.2024.03.11.07.23.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Mar 2024 07:23:59 -0700 (PDT)
Message-ID: <994db404-f3e9-41d7-90e3-5ac22565cbac@redhat.com>
Date: Mon, 11 Mar 2024 15:23:58 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] KVM: Async #PF changes for 6.9
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240308223702.1350851-1-seanjc@google.com>
 <20240308223702.1350851-2-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240308223702.1350851-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/8/24 23:36, Sean Christopherson wrote:
> Fix a long-standing bug in the async #PF code where KVM code could be left
> running in a workqueue even after all *external* references to KVM-the-module
> have been put, and a few minor cleanups on top.
> 
> The following changes since commit 41bccc98fb7931d63d03f326a746ac4d429c1dd3:
> 
>    Linux 6.8-rc2 (2024-01-28 17:01:12 -0800)
> 
> are available in the Git repository at:
> 
>    https://github.com/kvm-x86/linux.git tags/kvm-x86-asyncpf-6.9
> 
> for you to fetch changes up to c2744ed2230a92636f04cde48f2f7d8d3486e194:
> 
>    KVM: Nullify async #PF worker's "apf" pointer as soon as it might be freed (2024-02-06 11:04:58 -0800)
> 
> ----------------------------------------------------------------
> KVM async page fault changes for 6.9:
> 
>   - Always flush the async page fault workqueue when a work item is being
>     removed, especially during vCPU destruction, to ensure that there are no
>     workers running in KVM code when all references to KVM-the-module are gone,
>     i.e. to prevent a use-after-free if kvm.ko is unloaded.
> 
>   - Grab a reference to the VM's mm_struct in the async #PF worker itself instead
>     of gifting the worker a reference, e.g. so that there's no need to remember
>     to *conditionally* clean up after the worker.
> 
> ----------------------------------------------------------------

Pulled, thanks.

Paolo

> Sean Christopherson (4):
>        KVM: Always flush async #PF workqueue when vCPU is being destroyed
>        KVM: Put mm immediately after async #PF worker completes remote gup()
>        KVM: Get reference to VM's address space in the async #PF worker
>        KVM: Nullify async #PF worker's "apf" pointer as soon as it might be freed
> 
>   include/linux/kvm_host.h |  1 -
>   virt/kvm/async_pf.c      | 73 ++++++++++++++++++++++++++++++++----------------
>   2 files changed, 49 insertions(+), 25 deletions(-)
> 


