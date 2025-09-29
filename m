Return-Path: <kvm+bounces-58967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B56ABA8936
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 11:18:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A48817B3F21
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 09:16:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1BAF286D46;
	Mon, 29 Sep 2025 09:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hho3VQpM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C4D286438
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 09:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759137494; cv=none; b=meKBsrYOpsIU/3C8XLpkW38Z/VTRViKtS1X+wqKj/Z0Ub3m2UWd+Xg5iEBPvCAowh764wgNxIJSrjpuvrdnrKmqusCsK97C0Bc6wkZKGvQA7qnRxudR0iX8jgc4RYjFwWrX4HHrFo1B7+cXwkOYsPU/gGLznxTUzQd+fWV5+HtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759137494; c=relaxed/simple;
	bh=Ks2BBBzQqjGWEUp3vTQtsltYJN13fV/jNGcOycVGv2I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I1kca3aB7OCm3uj4hzRW3sWtcNJJDaA+GeNQHLtgZTWyFHP4OlZUKFFtlcHUPkHc+kR2J+EX4pHdup9qdbnfP2tSLsKjnArpHKPOtn+X0xydES6TFAdoinzG5PnS/38U2szNE0s/BEGGRvk8DlSVYTQ5Nk+tcIyHsvDYGsGvWcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hho3VQpM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759137492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vk82StvtzuvoQmzBkr51Z9nRoIXejYH8Zn9Ho/zzzFs=;
	b=hho3VQpMJwNT6FD0sBhWXNnhnO8mpwtcsnxWT5p89MNJW/xA2MJzKFV0G/XcFprUcxbTNy
	tOg5Uqg8DHKxgg8Bpqa34QsLF2LHTzb8nEHCKZRftwE3W6Qtm40jcDlgKvJmvcMNcjnjR/
	NCVnJxvdRtxnA4tddrOj+y8ouTDfFJk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-330-8X7SFCTNMYilfp855qLWtg-1; Mon, 29 Sep 2025 05:18:05 -0400
X-MC-Unique: 8X7SFCTNMYilfp855qLWtg-1
X-Mimecast-MFC-AGG-ID: 8X7SFCTNMYilfp855qLWtg_1759137485
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ee12ab7f33so2329429f8f.2
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 02:18:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759137484; x=1759742284;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vk82StvtzuvoQmzBkr51Z9nRoIXejYH8Zn9Ho/zzzFs=;
        b=EEU2IKQBJOAPfM/wciwzt1//iwkHdMX8fwVQ0oJgzjYbVl6htIg8+nsY/3Oma1Lzo2
         dZ6pTDPtHfvRgI/prO/wwYlr6eEhSzm6BUF8vHTMdxu7zGRqJfXM/8JcVVARTuK2mhJf
         JnkFtb1X4jMOAvfDe7X+K4L7d02Vda7+7SKc+6W9OSTb2iyHfxnX4DSPyr4JJvL1J1LP
         yBzpSRRMbz5J9+M1lTvsCiu8PaqTkbuARJw5Ch40GlJHV+Kbw2VHWj8yIn+yWwPNqNVm
         PsjwKW8A4d333nDzafv9hziXX2813+Ate0fl/zOLGvjCrNTFaD4ndFWcrsOhPeXKKQdI
         irtQ==
X-Gm-Message-State: AOJu0YyZPylHHG0K/4BI6lMtCt1ma9ENVdgXFq5NrBfF/S1QoDgPZh6W
	4924FbxNjokxsDKB4aKReWIxz8N7LRumx89piCl9ZnHIWZIXLfIIl4j+xSS3ZrBSmPzmkEOFsDx
	kbnxfZWZQLIdO9fM1YuY3fw5tnvDJ71hjvZvtZsm6ojT+WHDaaIKBig==
X-Gm-Gg: ASbGncsgaHFWvRGFbjJSBmTBZYcbcxuWBszrdNdOBOi+jzM1N3m1PMkwa6VKeVvTS14
	jLOVy1oIPNyOKTCi4t/X9RfHyuT19GmRu/xZCFd0O5U4dFguMCMG417dIobkxGhfBLFlLxhPvax
	eqhi8XAri3Oall4PVWkRm8LIy4E2HY22NCsoTtkG7+fBXU2iQOALMdz8vp/ooxxVz+g4vaYCi2m
	s2Q7ycOBFKwDM72PkvBAeoIg/wCz6ynMXlqBZX1w3rTjy9WqySlpLPQ/G1wqM0ifXzDVwtd2DrS
	3QR0sXM+MeLgcGzYBCtLM5IT8NCO7iscNUWJnE7zOXDOn6XEmLEtH4ndCAECgHUH7td/FyZLYHP
	4svJRtAVdGc9FElBhblWw/7d0DYqzjU8L8JX2des+3IppxDkoQxn4cQG2GrtZTMphYQ==
X-Received: by 2002:a5d:5d03:0:b0:3f5:453:77ea with SMTP id ffacd0b85a97d-40e4dabf28emr14251794f8f.58.1759137484484;
        Mon, 29 Sep 2025 02:18:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEXlkIee2EP6cCZceUObBZoMhwWwE2P79HU2Td+9p0UV2c9KpI5Byo6/WYxtplqGTOY5+qGuQ==
X-Received: by 2002:a5d:5d03:0:b0:3f5:453:77ea with SMTP id ffacd0b85a97d-40e4dabf28emr14251773f8f.58.1759137484049;
        Mon, 29 Sep 2025 02:18:04 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f05:e100:526f:9b8:bd2a:2997? (p200300d82f05e100526f09b8bd2a2997.dip0.t-ipconnect.de. [2003:d8:2f05:e100:526f:9b8:bd2a:2997])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb871d051sm17855205f8f.14.2025.09.29.02.18.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 02:18:03 -0700 (PDT)
Message-ID: <59730bad-4731-4c25-838d-9dafee1c6c44@redhat.com>
Date: Mon, 29 Sep 2025 11:18:02 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] KVM: selftests: Create a new guest_memfd for each
 testcase
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Fuad Tabba <tabba@google.com>, Ackerley Tng <ackerleytng@google.com>
References: <20250926163114.2626257-1-seanjc@google.com>
 <20250926163114.2626257-4-seanjc@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250926163114.2626257-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26.09.25 18:31, Sean Christopherson wrote:
> Refactor the guest_memfd selftest to improve test isolation by creating a
> a new guest_memfd for each testcase.  Currently, the test reuses a single
> guest_memfd instance for all testcases, and thus creates dependencies
> between tests, e.g. not truncating folios from the guest_memfd instance
> at the end of a test could lead to unexpected results (see the PUNCH_HOLE
> purging that needs to done by in-flight the NUMA testcases[1]).
> 
> Invoke each test via a macro wrapper to create and close a guest_memfd
> to cut down on the boilerplate copy+paste needed to create a test.
> 
> Link: https://lore.kernel.org/all/20250827175247.83322-10-shivankg@amd.com
> Reported-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


