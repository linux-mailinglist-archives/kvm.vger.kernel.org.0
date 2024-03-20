Return-Path: <kvm+bounces-12277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F2884880EF8
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 10:46:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A09F1F22393
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:46:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 356703BB29;
	Wed, 20 Mar 2024 09:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JMhPB4cB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E01171C2
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 09:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710927997; cv=none; b=G7ncHwCMYhh7T/BS0rWxX8MvpSxW1ZkdG0/vB9GhJ/rJSZsjw2zSnHX12ZJ364BB/12wYxpdSqpxoXZkK2y8JNN3P8Wcqd7Qb3NncOQnXREBKj+pYML1G11Zf26LeTfFpiYwKlJ7I/cahKEfWSFXwiyVc3h2RYWOu6FRArenjro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710927997; c=relaxed/simple;
	bh=JYS75+mEXjUw09pqAXR3mKOlMrZwWFjYkegIv795lfY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KtS3beErNSiFt6miPCTVqlZs8bGwsrrS9vSe3sap52ENXfjuEnrHFJRs3WwPZptqs7SXj+eLCHIy98u2CuM8LCl/DtqAFrjre96wVk6ZeBjY0fBPNc+KSPXRR+WModraKIEdxqoByarFrpxFzhb1mBNp1VdXfrBHUV7338fmbao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JMhPB4cB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710927994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+WZs6qFUYItA5gvCkkHLzU1au93L0AnahHvuXruBMKk=;
	b=JMhPB4cBVqoI8lBYg/66fzV6bP1A9QbNE9R4NuhSs1cPUQPxoxmNKMkxSrchSIN7LR/Bco
	dzA67BSQDZOomVdc7V9X1ZXOLCXMq2RIYy+dgX5Itc+6r2fQF0y7hCl44T0zgH8UIuXbI8
	xyrUbNVOaC6R2cQjTFkwYz+HKk9NlUo=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-Tsb0pRuqMGKcpgSp6T1oXw-1; Wed, 20 Mar 2024 05:46:32 -0400
X-MC-Unique: Tsb0pRuqMGKcpgSp6T1oXw-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a46bae02169so71400366b.1
        for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 02:46:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710927991; x=1711532791;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+WZs6qFUYItA5gvCkkHLzU1au93L0AnahHvuXruBMKk=;
        b=Eic9lrtjxDVjmJxXU8EY15fiqg5tlC7QwEEeNRmio8v7seY2NE0pZJHwd1n9PmS1+f
         8HsYxYfK+mXdeU24XOjQwWgx+fKjsGOsUXsJ5LA5jFLjHD5m7GVMxsjQihpEhyKn4Kx0
         8Yu3l7VZ4fl0mofO5eWgEenLW4/rFLbtCtN7t/xGqZKTWOwnIezsrbkY7uIJSblF/crn
         uVfA7lbY298edDPLa7pqEoDuxarRvq7lXCP0NIxsBysSZH8if3TSDK3YZQwQdYdl2Tlo
         G2nrBHY1MXSw8vr+hxcccbUkfon1nJzMghMnzS/c4Bi9BAO/ZjsmHujinAT8pCBqjkip
         EtsA==
X-Gm-Message-State: AOJu0YyU1A/gsBjIq2z9n4UuQMRynvnaRGM9GPd2eFvxYUYzLxK1zSKW
	gcXg/e3/TByG0ch1+8Bv35j1RmegKsv5LDqWXANGbSpLbym22w3f8CF5Yc80Pt2KWU2O+fRR6NA
	8e2gabap5cCmZ5KVyjF6Z3CC/60ZM94Dvk3blWqWnMzjWCE3CYw==
X-Received: by 2002:a17:906:af8a:b0:a45:bde1:a334 with SMTP id mj10-20020a170906af8a00b00a45bde1a334mr1652428ejb.27.1710927990924;
        Wed, 20 Mar 2024 02:46:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHYWyHr39ieL8VW6sq78MqBLPco9oQ7sYS8RNzT+os3VOZljrCtsjVKViXIi+OETXikeC19vw==
X-Received: by 2002:a17:906:af8a:b0:a45:bde1:a334 with SMTP id mj10-20020a170906af8a00b00a45bde1a334mr1652414ejb.27.1710927990617;
        Wed, 20 Mar 2024 02:46:30 -0700 (PDT)
Received: from [192.168.10.118] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id j1-20020a1709062a0100b00a46af0fbf5dsm4271330eje.103.2024.03.20.02.46.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Mar 2024 02:46:30 -0700 (PDT)
Message-ID: <7727f1f2-2a30-45d2-85a9-db22ec5a9be5@redhat.com>
Date: Wed, 20 Mar 2024 10:46:29 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 25/49] i386/sev: Skip RAMBlock notifiers for SNP
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>,
 Isaku Yamahata <isaku.yamahata@linux.intel.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-26-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240320083945.991426-26-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/24 09:39, Michael Roth wrote:
> SEV uses these notifiers to register/pin pages prior to guest use, since
> they could potentially be used for private memory where page migration
> is not supported. But SNP only uses guest_memfd-provided pages for
> private memory, which has its own kernel-internal mechanisms for
> registering/pinning memory.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>   target/i386/sev.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 61af312a11..774262d834 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -982,7 +982,15 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>           goto err;
>       }
>   
> -    ram_block_notifier_add(&sev_ram_notifier);
> +    if (!sev_snp_enabled()) {
> +        /*
> +         * SEV uses these notifiers to register/pin pages prior to guest use,
> +         * but SNP relies on guest_memfd for private pages, which has it's
> +         * own internal mechanisms for registering/pinning private memory.
> +         */
> +        ram_block_notifier_add(&sev_ram_notifier);
> +    }
> +
>       qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
>       qemu_add_vm_change_state_handler(sev_vm_state_change, sev_common);
>   

These three lines can be done in any order, so I suggest removing 
ram_block_notifier_add + qemu_add_machine_init_done_notifier from the 
sev-common implementation of kvm_init (let's call it 
sev_common_kvm_init); and add an override in sev-guest that calls them 
if sev_common_kvm_init() succeeds.

(treat this as a review for 25/26/29).

Paolo


