Return-Path: <kvm+bounces-3901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 73746809B7E
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 06:07:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F0B1281F1D
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 05:07:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A4805396;
	Fri,  8 Dec 2023 05:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bivf7zGL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA131735
	for <kvm@vger.kernel.org>; Thu,  7 Dec 2023 21:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702012051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7DjOW++h2qpYv/KAC35xyOMKgc1I7IXf0474RhNm4+E=;
	b=Bivf7zGLH6HHkHSxL/SFmWnzO27NVKMaAAdNF/pIYkcZDows70grjSBIwfpobLjH1aN4kR
	lu8vpX9o7HajVZaHsZWSIYUR4Dix1ghR7C951ILEgOxhid+maEk5Ei81u5yph+J/Db0Gr0
	AUCrxYruIdjlEmgKCay+tL7h3nW/+O0=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-336-dEcHNXLiPUKS_0F2bk5U0Q-1; Fri, 08 Dec 2023 00:07:29 -0500
X-MC-Unique: dEcHNXLiPUKS_0F2bk5U0Q-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-28658658190so1440803a91.1
        for <kvm@vger.kernel.org>; Thu, 07 Dec 2023 21:07:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702012048; x=1702616848;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7DjOW++h2qpYv/KAC35xyOMKgc1I7IXf0474RhNm4+E=;
        b=mecDjdeWNLLwl3VYwrwE4fTHxN/bzbAKH92MrF9Elfu7mkcbL7rcD6p9DdRUQ3ITp9
         t5JPFMwbm3tH3/GwUkYnCq+4pvMyN7FbjUPFrd4s4/udZI0GiP6d8ucnzNn8XV1voz6W
         zz6AD+9UfDmz5QV893weJE3DAt2OV96cq9E2rirmpY+PCHQgatMMXbxX0AEt7GqcV4yz
         TQQZrYR56lsl/a+3YKvlbPPpuElxp6JhVmuMHwZOWOFCTQCVpyYOnMyp1YO9HtCm2PlE
         JLA/XGJ99Qz4pPC6bK0NHTsRsuXdNuxMJu3XoLHBVqXreiXNd6v/OgXLO6gudpI/MqLA
         nlpw==
X-Gm-Message-State: AOJu0YxzrIKw+1+gt0XSXs7AWVKDyBvSHnzyD3T1gd/odpXuTYXDIJuV
	c4GfA/P03ezBxCsu91TGGkIRaRvzDf2WsEdeVZdA94cLRNwYHedmysZ67oHYlrytBvYuJXJzQZ3
	uXOY63StgJy/1
X-Received: by 2002:a17:903:228b:b0:1d0:b16a:b26a with SMTP id b11-20020a170903228b00b001d0b16ab26amr3435386plh.4.1702012048129;
        Thu, 07 Dec 2023 21:07:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG6LlOSfQMdwKQHpCvinXE+YTOV9LAn4L/4e5piuadXfTGPzQr096NtqUuMnxxErVNRlrsErQ==
X-Received: by 2002:a17:903:228b:b0:1d0:b16a:b26a with SMTP id b11-20020a170903228b00b001d0b16ab26amr3435375plh.4.1702012047799;
        Thu, 07 Dec 2023 21:07:27 -0800 (PST)
Received: from [192.168.68.51] ([43.252.115.3])
        by smtp.gmail.com with ESMTPSA id g24-20020a170902869800b001cf9ddd3552sm701722plo.85.2023.12.07.21.07.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Dec 2023 21:07:27 -0800 (PST)
Message-ID: <c8e1594e-1379-4fb3-904f-fba2cd194cdc@redhat.com>
Date: Fri, 8 Dec 2023 15:07:22 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] KVM: selftests: Fix Assertion on non-x86_64 platforms
Content-Language: en-US
To: Shaoqin Huang <shahuang@redhat.com>, kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 Sean Christopherson <seanjc@google.com>, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev
References: <20231208033505.2930064-1-shahuang@redhat.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20231208033505.2930064-1-shahuang@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/8/23 13:35, Shaoqin Huang wrote:
> When running the set_memory_region_test on arm64 platform, it causes the
> below assert:
> 
> ==== Test Assertion Failure ====
>    set_memory_region_test.c:355: r && errno == EINVAL
>    pid=40695 tid=40695 errno=0 - Success
>       1	0x0000000000401baf: test_invalid_memory_region_flags at set_memory_region_test.c:355
>       2	 (inlined by) main at set_memory_region_test.c:541
>       3	0x0000ffff951c879b: ?? ??:0
>       4	0x0000ffff951c886b: ?? ??:0
>       5	0x0000000000401caf: _start at ??:?
>    KVM_SET_USER_MEMORY_REGION should have failed on v2 only flag 0x2
> 
> This is because the arm64 platform also support the KVM_MEM_READONLY flag, but
> the current implementation add it into the supportd_flags only on x86_64
> platform, so this causes assert on other platform which also support the
> KVM_MEM_READONLY flag.
> 
> Fix it by using the __KVM_HAVE_READONLY_MEM macro to detect if the
> current platform support the KVM_MEM_READONLY, thus fix this problem on
> all other platform which support KVM_MEM_READONLY.
> 
> Fixes: 5d74316466f4 ("KVM: selftests: Add a memory region subtest to validate invalid flags")
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> ---
> This patch is based on the latest kvm-next[1] branch.
> 
> [1] https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=next
> ---
>   tools/testing/selftests/kvm/set_memory_region_test.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


