Return-Path: <kvm+bounces-11543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6634878156
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 15:10:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 064551C22022
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 14:10:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 998E13FB95;
	Mon, 11 Mar 2024 14:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MfVyBrRP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243082BB19
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 14:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710166231; cv=none; b=PL4qtq2PHJjSrG5zUP93htdikUK9h2TAMo/9mQPJ6bqc6+8nNpl9bP9jsoEsJbvR0JOCLuG2uxU+eq3qCS9e7gpydwc/83+8E8ccmq2sJEPgdaaYOw8SL1ustHUQT1WaU/t9vr1DRh0a4LLgUWfF1AJuaQiiI1Gyae3IgGDkiUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710166231; c=relaxed/simple;
	bh=Z4SSQaT52eZKD7Umt25pdDNozU2k30+g0F1G3C9wXyw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e7/8MMd3Ikx+1KbHjUpOk27mga51j9BDlAWF/wqCr7PilYD1lvH+9itVuW6KdoBBFuJ2hpbMJjfJ/o7dhjYftz3kb2BYUYeB8T7Bo9NuIw+ZCPy6kvaAGj40JvV4UM25IVhRludP6p6SXIYDjF4sDAnYg+Bx9R5Gisps2Aq9CeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MfVyBrRP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710166228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hYh5tQchtq2eZoOZpBdnN7mPdgsWGKOiIWfUojl7Cjw=;
	b=MfVyBrRPPLLVS1nv711y/x1kdBCfu2ZdyemcnDXBN8GvIdXVF4GgFk0EWTQNqP4/dTYMIG
	NdT69nfoaBJf9WNvYe4NgbZrj5S+ClsXIN6Md7hbhEbfwM0QHpuVd8IJKvkG5m/GuzYjVW
	/O1pFG6fPx7lJfE7Cycz0isGErBWd9A=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-472-HwK9gRKpMkOWrkren2w_wA-1; Mon, 11 Mar 2024 10:10:22 -0400
X-MC-Unique: HwK9gRKpMkOWrkren2w_wA-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-567002485e2so1834273a12.1
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 07:10:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710166221; x=1710771021;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hYh5tQchtq2eZoOZpBdnN7mPdgsWGKOiIWfUojl7Cjw=;
        b=iSbwNU+8+n7GdsOkmFbjGS/dNzLYNHdgl99EeL96+ZQdbGEHB/1eJL4DrYH9qiXsSw
         yXJx0t22QK6/3ztE7IcHSZXFaxUefkNkBWFXajLp2D1K+Sblk8edIg4X4+nhEEWso2cL
         gHStrLUAPSA+FItqb4gYwvpcuExleVniQVcVnHvWQyqT4G6QMyhq7I+9jkOypJ3VNPyj
         /f6+aflYpXw6D+gwUUGL3Qtg0z/NV9WzpDTYVDIR479RZCS7Oq6NEboE6R5hKP7vw0zE
         XKm7SBJE9er74I1THnRhvihmcKXin/w5rpOF/jdk3oYmLHJIfhfqJkOnMsok3PZs1KvN
         tx7A==
X-Forwarded-Encrypted: i=1; AJvYcCUfMSF+8H9KCEqdLnsQmvTM5ZHyYWn8LGMPK5QgxidKwFuRMa8cNOhZi9n1d77iIEeG8AkLKUsqYN461nbP1KFF8m1B
X-Gm-Message-State: AOJu0Yxq3lkm9I3QCfLJkig+emTOfV0bQ6aP+bJKDJf2lQMGMfBgIlqy
	5FI4UR5t8KeRYnqkImE/pj5Dhpxwlyp4CGHxXH3iEeEUsBMMUp9FUjpYrC25pNEU7j/RT317oS1
	KPBo5i+9gnYsXAsEJXewPr3X4DsyyMHcuCl71SX9SRrZ80E/4iA==
X-Received: by 2002:a17:906:e2c5:b0:a45:f9da:b683 with SMTP id gr5-20020a170906e2c500b00a45f9dab683mr4046329ejb.66.1710166221178;
        Mon, 11 Mar 2024 07:10:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEY7olz2nnq89L389z4fKjNkFp+/5FWfOwUlOJt4408T6wNJTGHcVc/O4EzaY14GwTb/wlJkg==
X-Received: by 2002:a17:906:e2c5:b0:a45:f9da:b683 with SMTP id gr5-20020a170906e2c500b00a45f9dab683mr4046305ejb.66.1710166220755;
        Mon, 11 Mar 2024 07:10:20 -0700 (PDT)
Received: from [192.168.10.81] ([151.49.77.21])
        by smtp.googlemail.com with ESMTPSA id c23-20020a1709060fd700b00a44180ab871sm2900654ejk.50.2024.03.11.07.10.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Mar 2024 07:10:19 -0700 (PDT)
Message-ID: <6091398f-a2b3-4dc9-9f33-d7459a0a9594@redhat.com>
Date: Mon, 11 Mar 2024 15:10:17 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] KVM/riscv changes for 6.9
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, Anup Patel <anup@brainfault.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt
 <palmer@rivosinc.com>, Andrew Jones <ajones@ventanamicro.com>,
 Atish Patra <atishp@atishpatra.org>, Atish Patra <atishp@rivosinc.com>,
 KVM General <kvm@vger.kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)"
 <kvm-riscv@lists.infradead.org>,
 linux-riscv <linux-riscv@lists.infradead.org>
References: <CAAhSdy1rYFoYjCRWTPouiT=tiN26Z_v3Y36K2MyDrcCkRs1Luw@mail.gmail.com>
 <Zen8qGzVpaOB_vKa@google.com>
 <CAAhSdy2Mu08RsBM+7FMjkcV49p9gOj3UKEoZnPAVk92e_3q=sw@mail.gmail.com>
 <ZesxeoyFZUeo-Z9F@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <ZesxeoyFZUeo-Z9F@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/8/24 16:40, Sean Christopherson wrote:
> You're missing the point.  I don't care when patches land in the RISC-V tree, nor
> do I care that you made a last minute tweak to fix a bug.  I care when commits
> show up in linux-next, and*none*  of these commits were in linux-next until
> yesterday.
> 
>    $ git tag -l --contains 2c5af1c8460376751d57c50af88a053a3b869926
>    next-20240307
>    next-20240308
> 
> The*entire*  purpose of linux-next is to integrate*all*  work destined for the
> next kernel into a single tree, so that conflicts, bugs, etc. can be found and
> fixed*before*  the next merge window.

Indeed, and this is more important as more work is routed towards 
different trees.  At this point we have 5 more or less active 
architectures, and especially in selftests land it's important to 
coordinate with each other.

Anup, ideally, when you say that a patch is "queued" it should only be a 
short time before you're ready to send it to me - and that means putting 
it in a place where linux-next picks it up.  For x86 I generally compile 
test and run kvm-unit-tests on one of Intel or AMD, and leave the 
remaining tests for later (because they take a day or two), but in 
general it's a matter of days before linux-next get the patches.

Paolo


