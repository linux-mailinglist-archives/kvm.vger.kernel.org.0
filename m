Return-Path: <kvm+bounces-64141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 42165C7A1A7
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 15:18:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 44D432CB23
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 14:18:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D651332EA3;
	Fri, 21 Nov 2025 14:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JVBgbQXy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CA02FF151
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 14:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763734700; cv=none; b=BkgoV2paQm3oIX67rLOetwDYc30xrR6hqsCRDfPjizaTWERJPSW3s0+YvVGpzJqteFpPb2BuugcxL+cj+L7uKbfrGz9U/X1OYgQYRMtwefFE3USYP+uHq3CptjUilLDwGI4b4MYo2HgD+prfLaYsx+rx1696dlXnUbfQb5vqtB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763734700; c=relaxed/simple;
	bh=YxWWlAsZqYAxuYhnWljtUxq/fF/WET+4jUiU+3A7jKg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fNqLH4K1/A+YSD/oA9xXus55NNouAf4xYP8DKQN53QjZMtG7Dec4p3RS4PwfUtm0moK6OCFGb6VZdzfM64wgc9GB/LqG57apGIVkDvC6asx4zVhNmmEQx7WaPjs1gmrNKDEDLolqzcYSlASumX47UAIUZEtHejN/ihO5En6K5kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JVBgbQXy; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-42b3c965cc4so1118577f8f.0
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 06:18:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763734697; x=1764339497; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=503K01X0EjRdBqgywH22/w+iIk3UaBmqSzYIZrwCI8c=;
        b=JVBgbQXy2kjwN26nhVZ8+G7q8RghvbEAfl5caYBIKvR+aOaT2q9KX5mzF2xR8pLGkc
         niLaYSwJAJ4KGnlsxlL5qXQM0BO3lVeUorXz8dnWoh6bGx1/+Fb2njtklxIekA2ZO1bG
         0fZNInamWDQw3WKoq6s7Dh2v1XqLlohvUrJAxUqI1NMzofzd5yyW9fBcddLhuCY4ECVd
         OpprLgh2PV4mAEKBUzkUdoGkINBRGdhYb5WEU/kang8NEnNxbIY0tVD29WtE3WzyEgh1
         VJGQCs5q9oDvL39/my48OVtxW1wlcuFP8x9UdY0zBgDKQCbE1mSK4CJT2szq9EtITrfD
         57ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763734697; x=1764339497;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=503K01X0EjRdBqgywH22/w+iIk3UaBmqSzYIZrwCI8c=;
        b=tJ2tPYDmqPUus5L2LlZ1KIttKB36LjZsucMaMzbT8PXhj4GIPShvGvP+1tmFJLG+sQ
         8cXz2kl52dWwJ+/0NuzLIAk4lKZ20pCdlDvT99zG3hhMruKHV4TO0qe1gzDtvOQX5I/m
         eny9VL4uyPrBU+R+zFQjRueKMkJvphQF6kEj8MRmklS3ZqsmIkwHVTyrv/lddDj3WMET
         zlkD1XOFHut/HCXut/6WVb18MHlZ+OJvPeOY++Zbvm4AVoIFRLhBA2VKjEPOiv0nPtx9
         rA2rg6MnWNHzPvm0xrxd1cTQ3l+rTQko01zi8O5lzStemV9mx3fFvOivMFXX78ci98tX
         GQKg==
X-Forwarded-Encrypted: i=1; AJvYcCW6owb1AgSubujOleMFp8vgLjlM+zyy5xeat3of39fJ5PQXMgD2x4i7KeovVgCuBQ9vBuk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLpJczeD/v1WKKON8r8IogshTUO1tyJQX2tifS2oY4LFiKIdiq
	Ko7QCnKaCDsdGYzdBAvCtjivMykyR2COkijh7OWhBqEJPKDPCsuwqrfPDFQWhzb3Kwc=
X-Gm-Gg: ASbGncsrW5bpiN3tFRjRMJOmelBpFOB2NY8VRWBgxMweGZkq+KKivwOn5o5fDkWiFAd
	YG9L0Mj5kjVrPZPCxmEV/yNkzEs+oLDfsgrKy88x2/CwIqvcn4hvXFZHnOGJ9FDl7Mwtq0aWyjI
	me0cW389ZQLbkLHxYTmMJD8xdtJu9ON54O3UGwrfcNoqWZxR/kKVWCyBPnYujdqh9+V1KvDRyiM
	l3ovsH56Yuq+qtl6Jjz3LGIpaqxf/TkuZInk/pEw/S4atDpJVw3id2ult0KdZZ2Lq4aDMGHAavj
	iPwG0LyBbqHl2zVdAZiBl99ewnT5kLkTO19pm5kMUKb4Z6Vu7Rh30gycMr482f4WGEBg2VMYPDl
	0mc3O8QEf+KJDmapob389B7zePhE1MsB4fcJ6SCziGzOIG4zhq/xPZsyZEdiQYkHepb5GHsmiAh
	xljG44M2hVpf0mkf8PyoDwuDLui3biuAEy5Eay
X-Google-Smtp-Source: AGHT+IGNB82e/U2NCkMNUaSlyJGpUrw+Ly8FAinwRhyZzIKg4Ey937ANGlL06E27249r5LNmnn/Q7Q==
X-Received: by 2002:a05:6000:4305:b0:429:ef72:c33a with SMTP id ffacd0b85a97d-42cba63b5e9mr7259439f8f.3.1763734696702;
        Fri, 21 Nov 2025 06:18:16 -0800 (PST)
Received: from [192.168.0.20] (nborisov.ddns.nbis.net. [85.187.216.236])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8846e446463sm39013966d6.11.2025.11.21.06.18.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Nov 2025 06:18:15 -0800 (PST)
Message-ID: <67b9ad70-71ed-44ee-bc45-e02eb75043d2@suse.com>
Date: Fri, 21 Nov 2025 16:18:09 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/11] x86/vmscape: Deploy BHB clearing mitigation
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
 David Kaplan <david.kaplan@amd.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Asit Mallick <asit.k.mallick@intel.com>, Tao Zhang <tao1.zhang@intel.com>
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
 <20251119-vmscape-bhb-v4-9-1adad4e69ddc@linux.intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
Autocrypt: addr=nik.borisov@suse.com; keydata=
 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
In-Reply-To: <20251119-vmscape-bhb-v4-9-1adad4e69ddc@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/20/25 08:19, Pawan Gupta wrote:
> IBPB mitigation for VMSCAPE is an overkill on CPUs that are only affected
> by the BHI variant of VMSCAPE. On such CPUs, eIBRS already provides
> indirect branch isolation between guest and host userspace. However, branch
> history from guest may also influence the indirect branches in host
> userspace.
> 
> To mitigate the BHI aspect, use clear_bhb_loop().
> 
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

<snip>

> @@ -3278,6 +3290,9 @@ static void __init vmscape_apply_mitigation(void)
>   {
>   	if (vmscape_mitigation == VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER)
>   		static_call_update(vmscape_predictor_flush, write_ibpb);
> +	else if (vmscape_mitigation == VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER &&
> +		 IS_ENABLED(CONFIG_X86_64))

why the x86_64 dependency ?


> +		static_call_update(vmscape_predictor_flush, clear_bhb_loop);
>   }
>   
>   #undef pr_fmt
> @@ -3369,6 +3384,7 @@ void cpu_bugs_smt_update(void)
>   		break;
>   	case VMSCAPE_MITIGATION_IBPB_ON_VMEXIT:
>   	case VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER:
> +	case VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER:
>   		/*
>   		 * Hypervisors can be attacked across-threads, warn for SMT when
>   		 * STIBP is not already enabled system-wide.
> 


