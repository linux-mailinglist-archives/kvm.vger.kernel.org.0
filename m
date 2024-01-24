Return-Path: <kvm+bounces-6851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0FF883AFEB
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 18:30:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F398F1C272F3
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 17:30:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FFC98613E;
	Wed, 24 Jan 2024 17:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OZJtCBiL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B23181AC9
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 17:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706117318; cv=none; b=AV5AB0yNAtC4+PA57Kwdj5dDangEy94m9S4S0NBFQLAoXwg5IryCGMYhRXRQj2GxxAtFxgpgKzlfOGOeu6A3YGalCKA6k83E7FZ/dfk9iia4skGSxP2p48fX0169q8vajiyMAiKOv/69tX9FdBAyZBCwvLbmURazObva2A9m1wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706117318; c=relaxed/simple;
	bh=YZUoq4gXQ8SwxSgpga+ErXb9tt/oiDZ/4vATgGxnJV8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LW80wxWCjvpEy9YptKLIBBgAnYyaGcjNEKcaOrRVAUu8kv426YDe/9HYGY2KAofgVyn7SmIw6Pztsp0/ZZTUWBzPqWbhoT/e0BpxVV/NhQOUTyyh9TnhNg1N57vZzqxRxn1XZLDh9N+2jviEl7Tgw/zg+afYd6FosQFbtjWmya0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OZJtCBiL; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6002a655cc1so42593587b3.1
        for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 09:28:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706117316; x=1706722116; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ynH78JY911w9hOfeq2os2brIlYFhSAYv5WM0x8QaxUs=;
        b=OZJtCBiLn6kfjpXOc+LveC8d+p4RPa7mAhpyDNV3TbCQOxgB/Q7DUlbPUlz3mCNbwJ
         s/8ZFu9xlu/7pL3IyEm/OOCx+8qucSELi2Ccb2orTP8Nvvd17rxWNJ+RXpnAMvCoLeJ4
         UKJr53kjZgNsf04YFtMvO/n6eTZiSmbQwMwQ6auF1ydLMCyVCmVgf4TBsx3OGolFkaBO
         YMzuhOg81EjdOMad5doW+dIoTIbWduns605hPnZl943pAOME1Q8vzu9hT26+0ELuRwqk
         FHgHTKSODCyhRkFASi4KJh0O8XmCDPVYIQ3iS1ujDyzSNSWhoEsuMT/YWV9yPvxvTAGc
         r0tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706117316; x=1706722116;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ynH78JY911w9hOfeq2os2brIlYFhSAYv5WM0x8QaxUs=;
        b=FFvRHS5QDrVASqmOENtDIMtC4c1z/5fb9lYgbSUTc5ysoqUYUZ8aUtj+EaQgxleDC2
         YrTMljOrNHpqpKwoYwZOeST462sq/y54rIyjPSeQ1gME9DxHv+B/Z7kAYffaKbBH1K2m
         h/PjS2UmqhveLj0/S4aPJKpjiAYnJFBt2flelh0KJAdqb208FGgwCwA5W9uFtsI/uoib
         yNG17yxYCh2mhlIeRUhmbKAfKK/viJacBvVGGkcoqm28r4jSA5BAMd9FwGjutDM8FxBI
         i9psdXUsjGscUrQ7yYWT4vp+RviTMTXebNs8xQgulosV8Ye4rvLNwtdrdvPgAwpTLOh/
         uRJA==
X-Gm-Message-State: AOJu0Yx3t936BVVGpGZt5Cg+ifGj+kNFYiHIC4zMmsyTJq9EdWDYbJhD
	jGn+KQGtREnRugrCUAXxMTliO8SZwsblfv1hTfv0nb+KDEipKLPIDYS712PxDIP9AidRuBgF4bc
	Ylg==
X-Google-Smtp-Source: AGHT+IG6AhaBMl0R3V0mmvcHm5xaarazZI2n6QvBq0gL/rH7W0bSjyhUFqLUOEoiJzneuXN8Ao3qxMEyVW0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:98c2:0:b0:5e7:12cc:a60f with SMTP id
 p185-20020a8198c2000000b005e712cca60fmr380883ywg.6.1706117316349; Wed, 24 Jan
 2024 09:28:36 -0800 (PST)
Date: Wed, 24 Jan 2024 09:28:34 -0800
In-Reply-To: <20240124164855.2564824-2-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240124164855.2564824-1-vkuznets@redhat.com> <20240124164855.2564824-2-vkuznets@redhat.com>
Message-ID: <ZbFIwjfgWiv9XrDO@google.com>
Subject: Re: [PATCH 2/2] KVM: selftests: Fail tests when open() fails with !ENOENT
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jan 24, 2024, Vitaly Kuznetsov wrote:
> open_path_or_exit() is used for '/dev/kvm', '/dev/sev', and
> '/sys/module/%s/parameters/%s' and skipping test when the entry is missing
> is completely reasonable. Other errors, however, may indicate a real issue
> which is easy to miss. E.g. when 'hyperv_features' test was entering an
> infinite loop the output was:
> 
> ./hyperv_features
> Testing access to Hyper-V specific MSRs
> 1..0 # SKIP - /dev/kvm not available (errno: 24)
> 
> and this can easily get overlooked.
> 
> Keep ENOENT case 'special' for skipping tests and fail when open() results
> in any other errno.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index e066d584c656..f3dfd0d38b7f 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -27,7 +27,8 @@ int open_path_or_exit(const char *path, int flags)
>  	int fd;
>  
>  	fd = open(path, flags);
> -	__TEST_REQUIRE(fd >= 0, "%s not available (errno: %d)", path, errno);
> +	__TEST_REQUIRE(fd >= 0 || errno != ENOENT, "%s not present", path);

Rather than make up our own error messages, can we use strerror()?

> +	TEST_ASSERT(fd >= 0, "%s not available (errno: %d)", path, errno);

And then here just say "Failed to open '%s'" and let test_assert() fill in the
strerror() information.

