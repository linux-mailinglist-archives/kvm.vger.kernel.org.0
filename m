Return-Path: <kvm+bounces-12371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 082388857D5
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 12:11:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E0E0282450
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 11:11:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA63C58207;
	Thu, 21 Mar 2024 11:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="geqy61L+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCB054FAE;
	Thu, 21 Mar 2024 11:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711019500; cv=none; b=RFqKIYPG6My3ns1faHKtkwzkvih1ThVu1OitY3N/Us1FB1yGHLOWD6g04/MWU3+3372INds/NRR5V9UGUw5k7sVuav/iSnxO7acbYFwIWLgIxW7J1qjMEVEQS3W9ckE8w7/qL/g76szoHMV1CJLmlLA5RWRDD4I+OtfMB6TfcUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711019500; c=relaxed/simple;
	bh=kA7rppNBHHosBNFKeKCGHJ5/OraR593RUSJ/nSWvTgw=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=W8OT0cd649ylkysjqW2veP+T6apTc62ve7+AHRKzp3VuRlvCZKaU7/7lnkIy/6b44yazQVCSygf1zRJf+sRMdHAn0KVdrF73hvSB+Qnv8ghdRRxWtjlwlqhUluEgEufOwUx6H3sJmvdb/+IZ4gnp3E//q7ON9VsF27nqHPYWNPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=geqy61L+; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-33e162b1b71so573222f8f.1;
        Thu, 21 Mar 2024 04:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711019496; x=1711624296; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DwKO+pneZj6JBZBv7gzgwWyz25XUZMBuMw/dNsRAuoo=;
        b=geqy61L+2q73Uv+StSN3JY3YNC9z6DeYeSn8PEtlIoHdz5TJlYJF+8j6M02D0+GkLJ
         JpLvNwn3ftODB8dd2+fOYgFEpZE1wMjGOJJtuQ3n/nRvi1Nl79Q4u8r93jqOxiOxb6XW
         ESCY8l4dkOEZV6blu16wlIv1o3Zm2HxxaPsdgX6b66bf8kd4tmnguIeVB3uoXlL8BdQY
         s0HblUuvSz4w44f9iIFbTggYLrMZabsthgHL1BOr/zwOs+aFvQJpQK0NrGIEVhBqPbaY
         y/ILVVnatwFdqzXCow0RwiN9M0k1J2frm1TMWuuCVMa65+VwSv8ZP7SfnDon2Z4YRcpR
         KU7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711019496; x=1711624296;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DwKO+pneZj6JBZBv7gzgwWyz25XUZMBuMw/dNsRAuoo=;
        b=Lq/XgkmgFR9zFBVWEY11LPAdsFqfvyI26S/Z0ZCxharRAC398937LoxhI8/tgJswS0
         DYwWMh2R9BFH/vP1Kv3CBtB8ThlXOKSFg86HO56ogyuGphJb7TfJJ5EiZ9rVtug0C35u
         ypRU7snqxr0pyO4VI6Asm5R0B9jT7aYudwmMhucT+OHD6P/CHbODUM9++cXdpQcRaJ+B
         Dy2VngnbXYwl8Scb6OguEuSyBbsiYCmyul9UKAEAYd9xQPwVd0lhS2wH1hyRoIdO7tDL
         y5cLhaphFClZO3FAMAX+b2NM8v32+03/vCU/DR7xKG0GKma2Fah2PxHaVhPuXvxZaIvu
         GIUQ==
X-Forwarded-Encrypted: i=1; AJvYcCXYuwjU34NNXBzA7/ezSlMg+rbKel+WyoBLSYoSxIBnlJQE66SgFBGgjhyyBAdOVhoEN6JeF2MmxFQ9Qg+/j5DSBSd8egBBKTKB1yKf
X-Gm-Message-State: AOJu0Ywfv59xkK4FHNr8SVbwXOe7YsyfecEQ+x2C52p6/WsoKo8IdrB0
	g9pSQth49MSaOpnRMihM4RmOxX9sIZ9CkCEuPwtovVD1oBnJxsky
X-Google-Smtp-Source: AGHT+IHKjqnDHCIyK/uLI8tCquYfyujoxldzxJb6p5R4VC/Mx9iAb76Wz3j1PAJ7gC+5uJX1bqeAaA==
X-Received: by 2002:a5d:5102:0:b0:341:938a:cd95 with SMTP id s2-20020a5d5102000000b00341938acd95mr3420087wrt.0.1711019496569;
        Thu, 21 Mar 2024 04:11:36 -0700 (PDT)
Received: from [192.168.16.136] (54-240-197-226.amazon.com. [54.240.197.226])
        by smtp.gmail.com with ESMTPSA id q2-20020a05600000c200b0033dedd63382sm16862061wrx.101.2024.03.21.04.11.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Mar 2024 04:11:36 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <db8b8156-07b7-4ee1-9343-9f7862fdf98c@xen.org>
Date: Thu, 21 Mar 2024 11:11:35 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 2/3] KVM: Check validity of offset+length of
 gfn_to_pfn_cache prior to activation
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+106a4f72b0474e1d1b33@syzkaller.appspotmail.com,
 David Woodhouse <dwmw2@infradead.org>
References: <20240320001542.3203871-1-seanjc@google.com>
 <20240320001542.3203871-3-seanjc@google.com>
Organization: Xen Project
In-Reply-To: <20240320001542.3203871-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20/03/2024 00:15, Sean Christopherson wrote:
> When activating a gfn_to_pfn_cache, verify that the offset+length is sane
> and usable before marking the cache active.  Letting __kvm_gpc_refresh()
> detect the problem results in a cache being marked active without setting
> the GPA (or any other fields), which in turn results in KVM trying to
> refresh a cache with INVALID_GPA.
> 
> Attempting to refresh a cache with INVALID_GPA isn't functionally
> problematic, but it runs afoul of the sanity check that exactly one of
> GPA or userspace HVA is valid, i.e. that a cache is either GPA-based or
> HVA-based.
> 
> Reported-by: syzbot+106a4f72b0474e1d1b33@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/0000000000005fa5cc0613f1cebd@google.com
> Fixes: 721f5b0dda78 ("KVM: pfncache: allow a cache to be activated with a fixed (userspace) HVA")
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Paul Durrant <paul@xen.org>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   virt/kvm/pfncache.c | 16 +++++++++-------
>   1 file changed, 9 insertions(+), 7 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>


