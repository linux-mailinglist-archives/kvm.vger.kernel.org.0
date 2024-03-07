Return-Path: <kvm+bounces-11285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E42D874AC5
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 10:23:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 827381C21275
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 09:23:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BFD976C8D;
	Thu,  7 Mar 2024 09:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="diLe7/CE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1301C42047
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 09:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709803427; cv=none; b=Kjc3fiR9nAt+JEWc7aKovkN+gKcACgZOtLNA5Oj0udx2k9Y+LRT4TSJqHG+dhRvTfGbyEWIWVlLv+sg1oS3XKdg+piVkEZYuMoq8NtmdYI1v0P2G8AorYyEqrNnf7AqgabB3SIkkMMOCpr3JTtejVID2DpnptOas1ylLiBRSfiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709803427; c=relaxed/simple;
	bh=OiSQi7ghMSLp2Jt0muP0jfyWL7YCaJzKtHujliby0+Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cj4CQjXr0bUpwBqTt0ZRtsmsFg3gKg6ABEhHIwR+qyI+yAs+haFYR8ZeQOej4RI5mACQBebcpzVju5HJEoVMT9zqStYT5/8Yxa/PHdCEpVezJ0wA6St2b+VeW511WrijROQ9DvUP86DeN6+27ILdZvknoB2BVQ6l2XESDyqZOgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=diLe7/CE; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1dca160163dso5945715ad.3
        for <kvm@vger.kernel.org>; Thu, 07 Mar 2024 01:23:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709803425; x=1710408225; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vj4pe1G8UrVbImDIL//+uea/5ulRNv7gYohfuZeyfdo=;
        b=diLe7/CEFmBNxgvGpmaRXa1IVxHSL0D3LdyEDRuRmEpX+SwIZOYmPTp6uresIAWqTN
         OS8Vn1LMOS5q4khoX8WZG+dl+32KqHa3hmt7AZ4hXvC9+EbQzcVTf/NfhfUx+rIGlOXA
         cHmA3XgHJW8vmqPaFpQdqn+3QFkTavyCKNrLjkv1gXRskVUlm32s4Pe6XVY8zBZcQr9m
         t+gGV/sN0q9tqvZ4tWNFwyRJ+jwkbnfYhSghDmNqWFaEf5KPhY0VU+YtsZs+sH2Hkiw8
         9D2uL40JZSV+LI7Dxp0RFGAgotPUFS7QiCo8zzO5dh31PQZWdtwbFVQLtYIO9mEIhO8E
         3uJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709803425; x=1710408225;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vj4pe1G8UrVbImDIL//+uea/5ulRNv7gYohfuZeyfdo=;
        b=Aof1iL/H5usgDqdInrjGJyBoJ+LXpJAhYFFixWMWwUIw3LkP5Dv19vmNn0pFYdVmgi
         WnEyTUw2lbJgAtKQsCC1btRT6dAS3ba9lRvNQyvRhWvaPIMCDam91KUd99aq2PosDmAs
         SLqrdhRQwCjGQs7yexHmueA+diowtoIVBbgCXXWqrmcsvEiO4C64pmCmFQJ1aFDNBREY
         2Gwo6d8YKWw+RiTS96zaPgRxlA5Nh04UhJXLeQoZOPA6m29p4ddSfLg943erCPecS3uq
         dEYiL96ahyQPFqnuwVBvms2dGKj7NdRerGE+0dEbePM/KTZW6mBmW0KWWBU4PuZ4HTyE
         ZbUQ==
X-Gm-Message-State: AOJu0YxXqDQOzZofZOSik1ZSOwCb3nt64vVGtI94qpMd70rMbr/gt1EB
	GUVLYSq8EWze7bYfTRaGDy3IZPf7DvGQYnAyCNU9hSLbUXP0T3AV
X-Google-Smtp-Source: AGHT+IGWS+CY9AwlGT/NrE0chlxYtRRrsUi1hOgUmjYRH6gvSCAsQQ8/llIslnvEOEfQCVhraMSPMg==
X-Received: by 2002:a17:902:f7d5:b0:1dc:d73e:a202 with SMTP id h21-20020a170902f7d500b001dcd73ea202mr6719356plw.59.1709803425272;
        Thu, 07 Mar 2024 01:23:45 -0800 (PST)
Received: from [192.168.255.10] ([43.132.141.20])
        by smtp.gmail.com with ESMTPSA id m10-20020a1709026bca00b001db5ee597e8sm14054054plt.261.2024.03.07.01.23.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Mar 2024 01:23:45 -0800 (PST)
Message-ID: <e24e8c46-519a-4022-876e-6c47d51f9a82@gmail.com>
Date: Thu, 7 Mar 2024 17:23:41 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 4/4] x86/pmu: Add a PEBS test to verify the
 host LBRs aren't leaked to the guest
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Zhang Xiong
 <xiong.y.zhang@intel.com>, Lv Zhiyuan <zhiyuan.lv@intel.com>,
 Dapeng Mi <dapeng1.mi@intel.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20240306230153.786365-1-seanjc@google.com>
 <20240306230153.786365-5-seanjc@google.com>
From: Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20240306230153.786365-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/3/2024 7:01 am, Sean Christopherson wrote:
> When using adaptive PEBS with LBR entries, verify that the LBR entries are
> all '0'.  If KVM fails to context switch LBRs, e.g. when the guest isn't
> using LBRs, as is the case in the pmu_pebs test, then adaptive PEBS can be
> used to read the *host* LBRs as the CPU doesn't enforce the VMX MSR bitmaps
> when generating PEBS records, i.e. ignores KVM's interception of reads to
> LBR MSRs.
> 
> This testcase is best exercised by simultaneously utilizing LBRs in the
> host, e.g. by running "perf record -b -e instructions", so that there is
> non-zero data in the LBR MSRs.
> 
> Cc: Like Xu <like.xu.linux@gmail.com>
> Cc: Mingwei Zhang <mizhang@google.com>
> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Cc: Zhang Xiong <xiong.y.zhang@intel.com>
> Cc: Lv Zhiyuan <zhiyuan.lv@intel.com>
> Cc: Dapeng Mi <dapeng1.mi@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

As I recall, the conclusion of the internal discussions was "low priority."

This issue has been lying on my to-do list for a long time, and finally
we have a test case to hit it right in the heart.

Reviewed-by: Like Xu <likexu@tencent.com>

> ---
>   x86/pmu_pebs.c | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 
> diff --git a/x86/pmu_pebs.c b/x86/pmu_pebs.c
> index 0e8d60c3..df8e736f 100644
> --- a/x86/pmu_pebs.c
> +++ b/x86/pmu_pebs.c
> @@ -299,6 +299,19 @@ static void check_pebs_records(u64 bitmask, u64 pebs_data_cfg, bool use_adaptive
>   		expected = pebs_idx_match && pebs_size_match && data_cfg_match;
>   		report(expected,
>   		       "PEBS record (written seq %d) is verified (including size, counters and cfg).", count);
> +		if (use_adaptive && (pebs_data_cfg & PEBS_DATACFG_LBRS)) {
> +			unsigned int lbrs_offset = get_pebs_record_size(pebs_data_cfg & ~PEBS_DATACFG_LBRS, true);
> +			struct lbr_entry *pebs_lbrs = cur_record + lbrs_offset;
> +			int i;
> +
> +			for (i = 0; i < MAX_NUM_LBR_ENTRY; i++) {
> +				if (!pebs_lbrs[i].from && !pebs_lbrs[i].to)
> +					continue;
> +
> +				report_fail("PEBS LBR record %u isn't empty, got from = '%lx', to = '%lx', info = '%lx'",
> +					    i, pebs_lbrs[i].from, pebs_lbrs[i].to, pebs_lbrs[i].info);
> +			}
> +		}
>   		cur_record = cur_record + pebs_record_size;
>   		count++;
>   	} while (expected && (void *)cur_record < (void *)ds->pebs_index);

