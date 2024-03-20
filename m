Return-Path: <kvm+bounces-12275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 78D9E880EBF
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 10:37:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E61171F21780
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:37:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B13783CF65;
	Wed, 20 Mar 2024 09:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JrSnTa8p"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513783C08D
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 09:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710927441; cv=none; b=VbQtGjSOzhbALWgMjcPxkwNZ8uF//p/sBN3neoOIWXri11zLE4kdmgyCZGOu/NLuscVwQeRxRShMb/SPnSnK8F2D4yarcq6wIzM8sfLvchqRmAwYTO6MYQ2CzT9cW6oflar8La6WL57oI58i4PI1UCViAuw+Kdu4tUMVSlbEdsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710927441; c=relaxed/simple;
	bh=83l8UvUD51v0A6Mudo+AbFZP6M78fc+r2G0rSlnMdpQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o+Wqc5wdH/1ddJ6p57OWzAb7AUQjtgCXCZ3X072ysnMB735iwFUKFLexCD2JYgTKnkj+56k2qQINZl9gXtikNzMfDNRplZq/Y+4T6Y7S30xhMuJ/zK7w2XNnti0M+BqmsZiiV0G2UVaYSoE05wfzyRMlVu4Vqobqy5SUbH5sUfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JrSnTa8p; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710927439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cXZV6rEbMyzNQrvbML6Ca+872q9ui7Bn+y/au3eyJA4=;
	b=JrSnTa8pp+pvwS8mQvWAaK7ERYy3fXXaEH6nHL6UBriqiwq8L5kMEroG4EtFllzCPKwLHm
	47iFeIai5h2dyAxmDlGg9PT2iEWzQlVsabHMMyrBwAOgafQJQvu+Y6M9Up+VMLNSXQMfpT
	CB1yA1esooSjjnEdrrF/4RVs2jg0WiM=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-455-7GFsrG6aMjehSke9t1ICVQ-1; Wed, 20 Mar 2024 05:37:17 -0400
X-MC-Unique: 7GFsrG6aMjehSke9t1ICVQ-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-513e45ab9a8so2587537e87.2
        for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 02:37:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710927436; x=1711532236;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cXZV6rEbMyzNQrvbML6Ca+872q9ui7Bn+y/au3eyJA4=;
        b=B8fQVuw55d20megaQUAuJqlWLP87rq0oxqZk721TJgp9JNqKVCo9itiT2K0Tmcalp4
         JyWIB1iMWAnlu0JndKWJ33vnzYkPqdREpcImB15k0A1fdYXNuWM7jM58xlsRYWOPNOcs
         6A1OzEAuS6ZDqthJq4tmgD6jfGvliJdIyP66QKMerEmphdyA8E9am9DXIkBZnXi9yg2O
         y/n1FPcW78N9CkX+XBBWseteJJdB2hdHLuUZdPqEdrCNF9eKbvvIcZ4dYd0t6Dc7lb1R
         Tdvcl41xZPNZ6+0Zk3GvHRg9mM3J0H+3rpFwNrqWdKVCqoEep2zNTvbkCj3qWADUg2TV
         wMeg==
X-Gm-Message-State: AOJu0YzYixB59QICGrhQRnhTzVRML+kTqyq+1GtT+KZR+tMEO0aTQl5T
	Z4jGd3qZ+o+Ve7GQFEMdjscoSNaEj2WpSkrEYRd5tY+PloMrykBNg1TxxWGAsK5BIXm20lLHbfx
	Rxw0dmGqaSipHo4613jhPhtPo4Sb4TrD5DduDP4+x+iq5KJKcEw==
X-Received: by 2002:a19:3850:0:b0:513:1946:a771 with SMTP id d16-20020a193850000000b005131946a771mr12650326lfj.44.1710927436013;
        Wed, 20 Mar 2024 02:37:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE+KdpzZ1/8Z7wI4wJem/qrSLfe7KVPRuTvaPPfUZOLirdxW4UVV39YLSqnNJuQw6I2PrAbvw==
X-Received: by 2002:a19:3850:0:b0:513:1946:a771 with SMTP id d16-20020a193850000000b005131946a771mr12650306lfj.44.1710927435481;
        Wed, 20 Mar 2024 02:37:15 -0700 (PDT)
Received: from ?IPV6:2003:cb:c709:c400:9a2:3872:9372:fbc? (p200300cbc709c40009a2387293720fbc.dip0.t-ipconnect.de. [2003:cb:c709:c400:9a2:3872:9372:fbc])
        by smtp.gmail.com with ESMTPSA id b2-20020a05600c4e0200b004140837a0d4sm1647261wmq.3.2024.03.20.02.37.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Mar 2024 02:37:15 -0700 (PDT)
Message-ID: <750e7d5c-cc8b-4794-a7ef-b104c28729fa@redhat.com>
Date: Wed, 20 Mar 2024 10:37:14 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/49] physmem: Introduce
 ram_block_discard_guest_memfd_range()
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>,
 Isaku Yamahata <isaku.yamahata@linux.intel.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-12-michael.roth@amd.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240320083945.991426-12-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20.03.24 09:39, Michael Roth wrote:
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> When memory page is converted from private to shared, the original
> private memory is back'ed by guest_memfd. Introduce
> ram_block_discard_guest_memfd_range() for discarding memory in
> guest_memfd.
> 
> Originally-from: Isaku Yamahata <isaku.yamahata@intel.com>
> Codeveloped-by: Xiaoyao Li <xiaoyao.li@intel.com>

"Co-developed-by"

> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>

Your SOB should go here.

> ---
> Changes in v5:
> - Collect Reviewed-by from David;
> 
> Changes in in v4:
> - Drop ram_block_convert_range() and open code its implementation in the
>    next Patch.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>

I only received 3 patches from this series, and now I am confused: 
changelog talks about v5 and this is "PATCH v3"

Please make sure to send at least the cover letter along (I might not 
need the other 46 patches :D ).

-- 
Cheers,

David / dhildenb


