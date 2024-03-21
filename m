Return-Path: <kvm+bounces-12372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 576F58857DD
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 12:13:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11FF328202B
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 11:13:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 770925FBA5;
	Thu, 21 Mar 2024 11:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="coiYMLs+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F316F5EE97;
	Thu, 21 Mar 2024 11:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711019589; cv=none; b=dqr0NNw1i6CYQOq7Bjh3FAHK5XAlT/CaCWQPPTPpKePRuyN9Dnfgnqj73DPJ+tYdYrQWKzdLslstkAtXYIbixgqdHlUSsSWcmZ+eULbvv7QbZTOEAC6OTeC/vp1TQIm66DZpS/vX7Pcr3WthArSc9y+kyOg5wbWK58c5hrFFZq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711019589; c=relaxed/simple;
	bh=B+AlRq5wD4cwKio/BwnlSW6HPEA5QfwG/R6CJTZ8mjk=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=hChlHTKDWKgO09zaxSdzJplzRMgLW7OD+evfAwsYVWXGM5VY086EfMgu8g72HDXxAYwsLvz7yRzheZKs/y2x7eyKIP7KyM84bco0WEN7cX8KjBUrWg/8AUCp9Ty4R8yKRHlgm+mXqWEmPxyGTyGqQRcI7N6Y2VARsyuBLwBeU4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=coiYMLs+; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-33e285a33bdso421968f8f.2;
        Thu, 21 Mar 2024 04:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711019586; x=1711624386; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/cbRd6FJvpAd6q8sCN6S7DaJi3dR5jcQCtvHDUVwB4s=;
        b=coiYMLs+est4Nm+KDbvN8FMJlPuToEsv3hiKd1vftPIosjFMg4zrWuuP/ncw+/YEka
         fsm5oJU3vGePgK3GjWHU+1O2reO2oZCKcsGCL8rkjqEgcU7vKvqkgjZr+xAteb7EpRMv
         URbWNUUb5HIPvsZwsPSyioAKdKoedEjkDQwxZvptvo8L/nrzFUHoydhMzw9txwCtalAc
         4ZSRiZNNQ6KvA81qQqsox48HCgWGFfFtm5ZgVYapz3tcmCXg7Mr9Efpu6QfS+L3AqHo2
         Z7Ps835KtcTxBN333LiO+G1NnmU/wuuWsQQ0zo6VTmPKF9Yqjvtx0q3zN2/OLBkd7vo0
         f0tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711019586; x=1711624386;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/cbRd6FJvpAd6q8sCN6S7DaJi3dR5jcQCtvHDUVwB4s=;
        b=lfCDTKdrfM8d5dPgW7nBiw1rpHmBeZoX2rI2LCheowKlsekj+TLd1tckKG7M9O6UAX
         WzR14Dg7bmuP1vbOKvwUidmb9dapO0zkRXNLpEICRdFcAMIGvdZ1WzhDn/SoEWLsJ/g8
         lIyVtZLUPVWreqhLa9XXRZIXVhjt8A3aIevrGM+VCWansB9LtqMhTsh3TdaBFjR+Rw9L
         rf2rfF1adkiz5XtM+tiWV2Eps/AqZlgQ/UobCxYSGa13GT7jEmYqJT1Ebe9/5JjzbRG8
         9XASvaRXtTf6eJvnD1vyVeEnfdLIJumOJBfQUXN1MYX/svHYU4NqwGQ85wf/kGQN/QQ7
         C1Ow==
X-Forwarded-Encrypted: i=1; AJvYcCWxdW4y7T13FG9+BGkzMq5O77b20DwxXlQ2I7vrDeupg54zR/0U3QM1+dg0/Dbvr7fAxsncd6/+u0gkXIIXWe4ut9rBtTRb0Jgdqj5q
X-Gm-Message-State: AOJu0YyJxqlpj4t29Tfkc1afK65wOJUku1DrouXnsPvxmO6Xu3qOBsSt
	Ugtyp439SA4hj1esc3oK9fvi5ieCTBb53vzg2EhnKqKLbWIf8Pgc
X-Google-Smtp-Source: AGHT+IF1qcjGqILJGRttiMz+xlyqBsK2ZvkeTOZ/NL2ddPVFWT5/4nVJZeIZwrHSd8camWTZIH4qdw==
X-Received: by 2002:a05:6000:402c:b0:341:a079:4aa6 with SMTP id cp44-20020a056000402c00b00341a0794aa6mr3000966wrb.20.1711019586317;
        Thu, 21 Mar 2024 04:13:06 -0700 (PDT)
Received: from [192.168.16.136] (54-240-197-226.amazon.com. [54.240.197.226])
        by smtp.gmail.com with ESMTPSA id q2-20020a05600000c200b0033dedd63382sm16862061wrx.101.2024.03.21.04.13.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Mar 2024 04:13:05 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <0a1d48f9-7628-4c70-ba83-efb6263f6bfa@xen.org>
Date: Thu, 21 Mar 2024 11:13:05 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 3/3] KVM: Explicitly disallow activatating a
 gfn_to_pfn_cache with INVALID_GPA
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+106a4f72b0474e1d1b33@syzkaller.appspotmail.com,
 David Woodhouse <dwmw2@infradead.org>
References: <20240320001542.3203871-1-seanjc@google.com>
 <20240320001542.3203871-4-seanjc@google.com>
Organization: Xen Project
In-Reply-To: <20240320001542.3203871-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20/03/2024 00:15, Sean Christopherson wrote:
> Explicit disallow activating a gfn_to_pfn_cache with an error gpa, i.e.
> INVALID_GPA, to ensure that KVM doesn't mistake a GPA-based cache for an
> HVA-based cache (KVM uses INVALID_GPA as a magic value to differentiate
> between GPA-based and HVA-based caches).
> 
> WARN if KVM attempts to activate a cache with INVALID_GPA, purely so that
> new caches need to at least consider what to do with a "bad" GPA, as all
> existing usage of kvm_gpc_activate() guarantees gpa != INVALID_GPA.  I.e.
> removing the WARN in the future is completely reasonable if doing so would
> yield cleaner/better code overall.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   virt/kvm/pfncache.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 

Reviewed-by: Paul Durrant <paul@xen.org>


