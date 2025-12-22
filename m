Return-Path: <kvm+bounces-66479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 35CA5CD662B
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 15:37:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AFD5D3047666
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 14:36:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54D4D2F999A;
	Mon, 22 Dec 2025 14:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g8j/0jMP";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="cSMucefK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB14729E0E9
	for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 14:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766414202; cv=none; b=dx8KmoV04nbX6SWwh2GDqhsYUfvWFv0rSK0sgRGQ6ZYt2zBZM/mr4GFjwH2KcygHjF88uOuc2v303/+6++42+Z6AE3MEXaPm3BHFyJfBN7MO38KbZX3ZlSIN/32Wbci26+eSRjZV/+0TLGQ8+c+1M9H2fZcz+cyHn0Te5PcL8fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766414202; c=relaxed/simple;
	bh=pNvoUte3Tm+MiMUjWVSizHJrx8+tRYdxMeRNIK1y2Es=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gevfzJ4Lh4UqmZmViIj7mqLEzx/AC+G77OUPIT709qTHc03cqQADxhio37YgaXYdVjsh9Kv+bbOdnAtPWfEQ9BipX1G8yIGhbjkdqwOWgVQtuA/7pv0bHa3Zsb031kdXilji25Tc3tXCX9w7PH9d84WIxUAQj/45I8Fdd1vz7Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g8j/0jMP; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=cSMucefK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766414199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xaxsvJPQ7mMfQtIiXUHfGkh4Lap3ndw1ZbgLV+q/Lv8=;
	b=g8j/0jMPomaiT3fuXzP80meY5EQujW8I5QDnsSIbcHqgk6MppyLmro+MIiPjmpi66ec34E
	eyxJJL5VucuQUZeNe1WvcAVbIv1BsdT45IdqB834+FXdGNw/t0R2mHXeTgvf14v2Ll7PSI
	+S96I1XDEoQCCFOiY01hgJzuO7SCM+o=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-bcP5HvZmO9-F-OwJR95dMQ-1; Mon, 22 Dec 2025 09:36:38 -0500
X-MC-Unique: bcP5HvZmO9-F-OwJR95dMQ-1
X-Mimecast-MFC-AGG-ID: bcP5HvZmO9-F-OwJR95dMQ_1766414197
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-477bf8c1413so22060015e9.1
        for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 06:36:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766414197; x=1767018997; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=xaxsvJPQ7mMfQtIiXUHfGkh4Lap3ndw1ZbgLV+q/Lv8=;
        b=cSMucefKKVbnEkWt9d0sisuV3rtSnWb7bUURSrJWT/zFNQex48k2ZBlGOa4Ei3gwsj
         fVmjr9J9xcKSWI8ief9Db0aJiQ0gHHd6S4ZfagtrBJsFpi4DZ9JqCQquvde2orHz7w2Y
         6z6SvW3Pw0gBd21ItIa+p2IG8oHk6aFxm0SBsao/tUV8UR0hJzXBmxrJ5y7n1fR775/5
         pd999xeFeWTDkNcV6mslbifIGA9QwKXqgZzN6aOqOQmAipFYP6ZkBhnZLJUzvsarw918
         QXkXy/NQl7vHEqx3e8gsLazK4l0ZS19wQf8uXWQ2s9Q94zil5iMsap/GxFcQWYDW+OEe
         mwfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766414197; x=1767018997;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xaxsvJPQ7mMfQtIiXUHfGkh4Lap3ndw1ZbgLV+q/Lv8=;
        b=UetTy8ek4qmkR9ZfsqAnQRABVOEm6TVfcJAK7/SqlPtNSnLtHz/iUPsh9pz5rzN66S
         9EUoDdNT8tBXIOwOeWSqwNe5aFbE2N1hnivc4SYglHYs1EW/vUrVoKUNdhqbgcATgfwq
         joQ7pGo6+B2RV3Cv3dlUkLQtmEdb7nB1amfvII3IAK0RaJinPcwpbEI3FlVKBFvWhHsV
         sJSEH6Do8SfsRFS4d373CXFBo/NATHdnAsxHUuCtr8en5jlso93y67C7v/VzFf7H5pJ8
         2PQCJr/6fvPFaFxgggpGBcxLcHvOjlfosbuiH5HNyxfNYMDvst3r9wqx+v53Sir2R71S
         hSzg==
X-Gm-Message-State: AOJu0YwEHufIaCSW5dzhGucG87AjEXEVkyr0CsS5uunZg7U3EyMtJW6e
	RS6y1PrUN7ze+bDpl+mQnOtgdM6V4hKtDLP+2f+BOGNqRPCR7MrI2Ybx4kSj+RoZPtJ9JXiDWi2
	fdLLp29abDDYWtiAx5aS50Np0ByctIVUxzftXzImbGhd16nUr8wPLOw==
X-Gm-Gg: AY/fxX46jUs1HJ/XxInHKDKIHJKhhtbR0/AOtwIFjaCMzKrX4lqh6e9jrD5p+Ag59QU
	TJFM8ayF7IESr8wwezTwg++4opznRFjRrnlke1y6OFcPzKMeUlPqhtu67Yo62Y5KR7E96exCa3i
	CV+3nWcSO6mTyKKx9PFH+doVbtFDueJoDoP0XNAutHvh7ty3fEjB7toOVNdbzng1Lpsdt6/+pTf
	iwvmJLMXuYy0fWrtcK1dIuh+ODf/0Sy00lfjtIpRnW51s523MeovsHAoPFbucwUa+84WVlkX5S0
	l96OyuRyXqLF1o45S9qC/3lm8ujpx8MKxHqUU4uneZwNrXjbjIsILabwMVRq5+pxelQaDzhIaYl
	ijv963YrgL+57MVoE/qgeDxgNRhOt7liXNS22RmIXraN3oGH8SUgPlHP4iQlIk8QLWZ4jrq8pMB
	hS6I0ivoLuHqnQNvY=
X-Received: by 2002:a05:600c:34d4:b0:477:afc5:fb02 with SMTP id 5b1f17b1804b1-47d19576cf0mr117994975e9.21.1766414197011;
        Mon, 22 Dec 2025 06:36:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH5DMmFkcIii4+pwZRMftckVSbIfM6scMVW+I+ggwTUnDSRoftbgzfJH/D1H0qT7N2nAJHagA==
X-Received: by 2002:a05:600c:34d4:b0:477:afc5:fb02 with SMTP id 5b1f17b1804b1-47d19576cf0mr117994735e9.21.1766414196635;
        Mon, 22 Dec 2025 06:36:36 -0800 (PST)
Received: from [192.168.10.48] ([151.95.145.106])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-47be2724fe8sm294151625e9.1.2025.12.22.06.36.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 06:36:36 -0800 (PST)
Message-ID: <671a0738-fd16-4bad-bb18-d6367c6c4229@redhat.com>
Date: Mon, 22 Dec 2025 15:36:33 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/16] KVM: emulate: Handle EGPR index and
 REX2-incompatible opcodes
To: "Chang S. Bae" <chang.seok.bae@intel.com>, seanjc@google.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, chao.gao@intel.com
References: <20251221040742.29749-1-chang.seok.bae@intel.com>
 <20251221040742.29749-11-chang.seok.bae@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20251221040742.29749-11-chang.seok.bae@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/21/25 05:07, Chang S. Bae wrote:
> @@ -175,6 +175,7 @@
>   #define TwoMemOp    ((u64)1 << 55)  /* Instruction has two memory operand */
>   #define IsBranch    ((u64)1 << 56)  /* Instruction is considered a branch. */
>   #define ShadowStack ((u64)1 << 57)  /* Instruction affects Shadow Stacks. */
> +#define NoRex       ((u64)1 << 58)  /* Instruction has no use of REX prefix */

While you have explained in the commit message that these are 
instructions that ignore REX, the flag is only used for REX2 and you're 
defining it based on the REX2 parts of the manual.

So I would call this NoRex2 ("Instruction not present in REX2 maps").

Paolo


