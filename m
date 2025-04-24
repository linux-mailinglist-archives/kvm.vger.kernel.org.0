Return-Path: <kvm+bounces-44218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 222F2A9B587
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 19:39:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5500B4A628F
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 17:39:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FF9828E5E1;
	Thu, 24 Apr 2025 17:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EmtN6D7r"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11C2288C90
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 17:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745516308; cv=none; b=UdUqHVZ2/vey/D3/jssHVwWHvZZ6FQwOcQ+3C/Ip0UdNxHAzwaNyiwmRuke9dp2+KfYlRVXANSfGgcLdeXTbt06dWSSVJlP0dyUImN3LMESAB2rZICJqHTi+vHBl/0oCrM7hvWU9ox4otnP/O6nF0n8zcjheyerXWz32ig5JlbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745516308; c=relaxed/simple;
	bh=+3qGCQZl/U0MkFm/X6EpDwwucSxPvMb3L7QjZX6gyww=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p0eI47cRahi/EFdIxWr+FrVgGnHekxnKuoz3BT5ccg29LOyP1PFIFznPc7HieP0y6451TIPJ/gYsIM8F82ZxkTH7LxxNrXt6kHJEBcmdwrR/q01RRC2mpW+UZO6V5gNweipeSv6gQSdso02yzicl7Qia25+DiemhnUUtR9uaFrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EmtN6D7r; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745516305;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=M6iPlq0+lPq47ekL78NC2y1kZ/SereiKHjDQ5zOpW38=;
	b=EmtN6D7r6qRve19fzndwv1QRoLJCC+mNVJcvlr++59DqT/MJDBvPU/S9qntx9ses+cJg+6
	v+oGLCe5vOZqRlOhVZ6tPZZ09QbtdkqLbt7dJSqPciv/FVw0GH/zAlxUei6dWVxNMorRCi
	YzkxAvsQVEFmGCdpyx9Z+Ilc6JTeLf0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-443-jkK183CbMwGpTVDGjyOgvg-1; Thu, 24 Apr 2025 13:38:24 -0400
X-MC-Unique: jkK183CbMwGpTVDGjyOgvg-1
X-Mimecast-MFC-AGG-ID: jkK183CbMwGpTVDGjyOgvg_1745516303
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43ceb011ea5so8264665e9.2
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 10:38:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745516303; x=1746121103;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M6iPlq0+lPq47ekL78NC2y1kZ/SereiKHjDQ5zOpW38=;
        b=NdXBG1RqcDkaYNceZr+pbbVkr/V2WfnnymeDq1Z5g1Nr0qvooQhdQF0v9O11wNLRNE
         FZnye2LPDUs6lOAuHKQgDolBQA7UFI3Dp0jP1Jfb5Nc2lw05mIZB3nVW5TcYE8WY50Rz
         yBU7ih2R7R6TZ000FApnn//JOh3HptN86nyG8L2kmY5Mgt3TD5nJJtbD5J0uYGw7ySj7
         xJCoZFhuvQ2J4HYvGw1rKfhSJTTcwXckCNJjYP5E276XhK3k9nXmu/Wy4QYEyh9e8BiE
         im8pG0FeZhO5O/vUOh+nYf5W59H1JfCI796HnY5WIC+2mKjvFAJihRZtw4vd9njzkrB7
         IQhg==
X-Gm-Message-State: AOJu0YyCGb3qJx4/r3XojVm51dQbbRWr5YqOt9YFHXw872IoVep4oAF5
	IhGlbjUl7PtQUfzrv3pL+omD7ksVZIqdg9q49VZ1Z4evVdmv+2eBhdx1f9pfF/6gCXW3YykfLWN
	VURkT6PvD2Uz3nijfqPe2vDsxIOoi/Hcv6D0wd30ntTUWUITkJw==
X-Gm-Gg: ASbGncutv3Pf7g79tBZ1RmN93gWfjG0269KzB7aM1D+UaaexmogCoK361eIqXJxFgsx
	zAXE/pOJFyYB/rT6wCLmUnMxuk4PEySlKuZWLgfAOhgb4MtIG5NqKMAky63mO7frvUQje7zmh8g
	2MlO/J3joBtJM5cWdFATtVRZ3J0yyrbBCfEmMpkpUDVrePfFURINBc1+0mYRakl6HuYANyNSUqY
	olHlKy99xJj/erhAA9EyyfbtBXb2euw/rxwJWQvp1mXp5rYza62gKBpRMrfkvBLx/cuLpU8fFc/
	8uXUD3HHS/40
X-Received: by 2002:a5d:47cd:0:b0:391:2fe3:24ec with SMTP id ffacd0b85a97d-3a072a85d1emr194606f8f.14.1745516303022;
        Thu, 24 Apr 2025 10:38:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG5D2IdhVkkhzZ2u4E9jNLM9y6rqvZsJQWcjcm75UgkS2t3YqrF/hXRwT+JfZpueEpjqert+g==
X-Received: by 2002:a5d:47cd:0:b0:391:2fe3:24ec with SMTP id ffacd0b85a97d-3a072a85d1emr194592f8f.14.1745516302620;
        Thu, 24 Apr 2025 10:38:22 -0700 (PDT)
Received: from [192.168.1.84] ([93.56.161.39])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3a06d4a804fsm2858556f8f.10.2025.04.24.10.38.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Apr 2025 10:38:22 -0700 (PDT)
Message-ID: <df3b44a7-70b8-4952-a7d7-231e69c8d3eb@redhat.com>
Date: Thu, 24 Apr 2025 19:38:21 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: linux-next: build failure after merge of the kvm-fixes tree
To: Sean Christopherson <seanjc@google.com>,
 Stephen Rothwell <sfr@canb.auug.org.au>
Cc: KVM <kvm@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Next Mailing List <linux-next@vger.kernel.org>
References: <20250422124310.2e9aee0d@canb.auug.org.au>
 <20250422173341.0901ebaf@canb.auug.org.au> <aAeg8A7DMvTAjqVO@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <aAeg8A7DMvTAjqVO@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/22/25 16:00, Sean Christopherson wrote:
> On Tue, Apr 22, 2025, Stephen Rothwell wrote:
>> Hi all,
>>
>> On Tue, 22 Apr 2025 12:43:10 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>>
>>> After merging the kvm-fixes tree, today's linux-next build (x86_64
>>> allmodconfig) failed like this:
>>>
>>> ERROR: modpost: "kvm_arch_has_irq_bypass" [arch/x86/kvm/kvm-amd.ko] undefined!
>>>
>>> Caused by commit
>>>
>>>    73e0c567c24a ("KVM: SVM: Don't update IRTEs if APICv/AVIC is disabled")
>>>
>>> I have used the kvm-fixes tree from next-20250417 for today.
>>
>> I also had to use the kvm tree from next-20250417.
> 
> It's a known issue[*], just waiting on Paolo to resurface.  :-/

*bubbles noise*

Done, pushed to kvm/master and will resend the PR to Linus as soon as 
Stephen updates linux-next.

Paolo

> [*] https://lore.kernel.org/all/20250418171609.231588-1-pbonzini@redhat.com
> 


