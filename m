Return-Path: <kvm+bounces-9048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21F2F859F02
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 10:02:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 538791C213A4
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 09:02:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77A4D22330;
	Mon, 19 Feb 2024 09:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jvy026Wf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229A979D1
	for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 09:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708333319; cv=none; b=is7sORxMv/jWd7tEXz2YpLlBfpmzoUSmtAoq+78oPlFZWYk8gFfPbIrB8jllAJUmAOmy85pzHNOZqjd3cdBoWR8f7p45T5oiTNVEzkN9MLh8p0ChaBdzIcVrMt74yQTs7lZlOgFR6briky61nYRX1MEkzRPd00fHgwGRpqOdpyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708333319; c=relaxed/simple;
	bh=jKQbQw8YDHMEt6XnAMuS4qvnUkuNiJ5srPQzSlSDZaA=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=J+CsDapV0R9Yi0QS0QnUXevpKAxtqocdaH1+aOiNTJFVjc1y0drV2gZ3B0RNsqZVAlBqQVT5+yDNHPqMIpjV4r+PrMrrVpTLS1RHkFXPP3mbyg4N/AH6/icfsHpSDW/i8VO6Gc5wTNiyog/hlZsqsqDK+Ns3181Gc+I9tUIerIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jvy026Wf; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-41268a88cdaso2231035e9.2
        for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 01:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708333316; x=1708938116; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hOaE+nTJLJdlAuRGNjDID11+1ccT9hWpWLLFbiUyQhU=;
        b=Jvy026WfEG79eUn09w21CP1U/dpfhFAwpng4kv0LJhw86QMBNJCBLuYSoAdzy5uHVF
         0nmQw0hvmW4h8N70QnVnJMG3Y374Z2u2OZMutUl50AZ5xG+LRkDqgBZYf+YqkSoj3d0x
         qmgYN/cpBMCbqRDCtRqkiDRwDG4KV5HCU+9kDb5fIuthIIQ+AOX64XsvVZqlcE+h60Fu
         UPPqTdN45BZMw6rPh0dkLLcRAnkfzjNoxyuptFNxuoGEu4hixzdwsdazatYQ5ZkNMrjH
         pAC01CZSi+pKuk/+HM1MlKfDJ6qEm0IucTRSbh56zNe7fHazg9pL6DRjB5F15Vh75VKY
         TNhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708333316; x=1708938116;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hOaE+nTJLJdlAuRGNjDID11+1ccT9hWpWLLFbiUyQhU=;
        b=Clk2t2e2OdTFShfAerO2wYZ2woaFTOoJj5Fs779Lqd93DIe1jhVn9Lr2dbLNKm9YjS
         TKx1AfNoaNGWOL+cXPacUJTokZC8N2Jv8sKx5EmW7i2joM98ElEuaZ1euJugJLy+iAft
         yDanjoKPt491h9X850Iz0rsF7BDRm+XS781w5dvPMgKs7OdesWr50TV+c0M1GzP6FzS4
         csxZ4Dv9afF7qb2TO5qtEL2Le0e7LFUOznkxqnZ3KY6Ltm+sN9akQrS8RCV1D/9HyRu3
         H3irDXWfY0eGqQkImWY5rMHGN3mddOdUgaIx5Jp3vTdoFf40VgN8E4wanVyfS+B4X8a5
         ltbg==
X-Forwarded-Encrypted: i=1; AJvYcCWzjuIHRmUqvKZ1c5kZHbJoGRMvoY9nRf4YMMt5nH0xruOk+G1e+wKaZ0PVBoRfuhhhaU6O3/Oj7BjMxxZ9KNsujrVJ
X-Gm-Message-State: AOJu0YyXJHrZcjbznlbgkMVA+s0AFBROUZYkIeY+a0yWuq9gRxgNNYDT
	kpXAiK1OQE9J1T3nm6l7PzsIVXz+eWNaJJEq70yFtLUHyvUCGCzv
X-Google-Smtp-Source: AGHT+IFj6u6ZQtgYJF0iQS6p+VI64llp2NqJt2TRYGTbUBIXxmvPSRoMzZm3NZuPNZKrnp9wUuQZ/Q==
X-Received: by 2002:a05:600c:4f53:b0:412:5ef7:29c0 with SMTP id m19-20020a05600c4f5300b004125ef729c0mr3572525wmq.13.1708333316372;
        Mon, 19 Feb 2024 01:01:56 -0800 (PST)
Received: from [192.168.6.211] (54-240-197-236.amazon.com. [54.240.197.236])
        by smtp.gmail.com with ESMTPSA id h5-20020a05600c350500b004124219a8c9sm10431210wmq.32.2024.02.19.01.01.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Feb 2024 01:01:56 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <8fa2e8d9-46c5-422f-ab3d-e0fe601b9d4c@xen.org>
Date: Mon, 19 Feb 2024 09:01:55 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 5/6] KVM: x86/xen: fix recursive deadlock in timer
 injection
Content-Language: en-US
To: David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Michal Luczaj <mhal@rbox.co>,
 David Woodhouse <dwmw@amazon.co.uk>
References: <20240217114017.11551-1-dwmw2@infradead.org>
 <20240217114017.11551-6-dwmw2@infradead.org>
Organization: Xen Project
In-Reply-To: <20240217114017.11551-6-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17/02/2024 11:27, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> The fast-path timer delivery introduced a recursive locking deadlock
> when userspace configures a timer which has already expired and is
> delivered immediately. The call to kvm_xen_inject_timer_irqs() can
> call to kvm_xen_set_evtchn() which may take kvm->arch.xen.xen_lock,
> which is already held in kvm_xen_vcpu_get_attr().
> 
>   ============================================
>   WARNING: possible recursive locking detected
>   6.8.0-smp--5e10b4d51d77-drs #232 Tainted: G           O
>   --------------------------------------------
>   xen_shinfo_test/250013 is trying to acquire lock:
>   ffff938c9930cc30 (&kvm->arch.xen.xen_lock){+.+.}-{3:3}, at: kvm_xen_set_evtchn+0x74/0x170 [kvm]
> 
>   but task is already holding lock:
>   ffff938c9930cc30 (&kvm->arch.xen.xen_lock){+.+.}-{3:3}, at: kvm_xen_vcpu_get_attr+0x38/0x250 [kvm]
> 
> Now that the gfn_to_pfn_cache has its own self-sufficient locking, its
> callers no longer need to ensure serialization, so just stop taking
> kvm->arch.xen.xen_lock from kvm_xen_set_evtchn().
> 
> Fixes: 77c9b9dea4fb ("KVM: x86/xen: Use fast path for Xen timer delivery")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   arch/x86/kvm/xen.c | 4 ----
>   1 file changed, 4 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>


