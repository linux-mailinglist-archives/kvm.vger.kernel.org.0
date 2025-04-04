Return-Path: <kvm+bounces-42769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AB26A7C677
	for <lists+kvm@lfdr.de>; Sat,  5 Apr 2025 00:57:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4D23A7A9385
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 22:56:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F19A21D5B6;
	Fri,  4 Apr 2025 22:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="D0dgBbzm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E8D19DFB4
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 22:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743807425; cv=none; b=ILMeaulT17C75tr2gPApkgkf3qrKf6jJywScCWDn3RJt2bYjs+DTHs7+Q6PoA6mCc0iNQVa0+19xF29AcfqKVqeQlsz+K+qWICMyoMNC+vBsLF6awMyDvj9lUtA9MeDS6YiPRnJjujoOJ+wuJeSvCcQ7W8hYPNVt3lOEIT2RxU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743807425; c=relaxed/simple;
	bh=IQJ0fvofASEvsIGj8BQe6qpDwitFwPQCocyVi0hhduk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xy+bnSIpocuTYIpdg7mbU8hfLFReAWG2qBCjXUz6YuzeQL0WDyqLLWQW7algyd0Z5CeKT4aAxOlqAMh4mtgXfPv4C90piaqpzQvNnizJmXzp4dDzoii1XVDt4cFtxwqFNqU4o6ytGAO2XN2o85gbKLv7tAh/kfuVdGpYbzUopvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=D0dgBbzm; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ac25d2b2354so454523766b.1
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 15:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1743807422; x=1744412222; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XUvAMJN7a+mUWz56T/QYJnMdlarIxyMfDMpTXRfo540=;
        b=D0dgBbzmdJPgpGtuZMu24+UB/d6t42dAjF6lXmY9D1UTfILyEdXhpyDU+ctzwpeO7x
         I6d9vrxaxp4CmsRKlHf92d+E/kU6V+lBRuAtFtfhYDQ8/5Itvcy9abU5/1gVTmpp8xHl
         CaG5nDf5BAxn+2tcut+eoO2lgDENzaCc/ZTM7qeBfzyZK0d48TA3246qFI8maqoyXbP4
         DaRb9xDQKrLpTeJIPLrg6NgGaSrf/6cdrHfjxhh26bxLmfGWnUJNPgMikYVgN8ux5wwQ
         RCuYP/Y2PopVIZCsu48Wy7JPpI/zWzjGutphtNQF1Zot8CMBf36patKXRAJZRYz8BtoL
         lrcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743807422; x=1744412222;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XUvAMJN7a+mUWz56T/QYJnMdlarIxyMfDMpTXRfo540=;
        b=DPW2UoN8JAg2FwwZv9LvalMxHmsRHf7vWyV0+48joJ8UDksM6FSaQ4358hZMU8SafK
         MMEPM82MNiHF7B+/O2iMBIFEYqMQpO8qbKqx156lFc6SeoanUYRTdNM6YRSRfDZ2bP/g
         /R1KAN1fgOPFuoO2OfRHUJBcfUqG8ni7FA0mZzF/lviPiyCNxsgJbSxnArGJW/k235T7
         c6Os1pmIZPEa6eN51JeWrJK7dwyQJGLBIeubz/Z4DfvagWP+gNk3Q8vJSDNnuZHSQJ+R
         1oh3YrIieY4l1zEU+zrNvY8FMYZzEuV755dzX3j5g3TgtMxjt4CRJvkFeBL426OIb52T
         7jkA==
X-Forwarded-Encrypted: i=1; AJvYcCU4vjkAaY/L0FGcEiMRoAi3kv/6HvWFPDt8+uzRLaUib13Ml2Xmv/mWyhizktPabhPCYuE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9wXYYpy1y3sS0xW+xk2P6WSi2AOXYNgHH/wXXgn26oPpJcHsi
	7hZmfciuo2PNLEHS0TbbKs8gByF42AQrCeFpgQtl2dPYUn6DXkOvCxBjvAKDpYA=
X-Gm-Gg: ASbGncuZ1LppK2fEwwBIQWSXjqhsxGSTZU81aW5INhLFtHnZac8jMxIqBFKD6a/9K7g
	u7/W3r2UsLiPuTO5UfCEGUqffhYKjgJ3y0YswEaE108N63/Jy+m6LshPUIlRVbVsES5qVzFU3lA
	SuCvWQZ9v8hwcJ3DRs1QTNXhe9wyKYPLPmJAS79YsY5iicBjmKkN1khXqvhL4sjodXM0rNHmF21
	U39K8b24+9PJBLsV31ipYeBKzVsBbStLbcoXWdcy2w22KdbRqOxqpZN6xNW6agDfla115g8FU3b
	rdH07ZCVfIIpmV831Vky+jQnFYWRO1FYKFr7r+hOUr18YTFiag==
X-Google-Smtp-Source: AGHT+IFstlVHevq12xIqmlOF3Xj0EZVEkLfWM4v9tS8EgPSXMh4vyUPP9FqMK6weyL9zVCXKmT9Wtw==
X-Received: by 2002:a17:907:7e98:b0:ac2:622f:39c1 with SMTP id a640c23a62f3a-ac7d6d06cd9mr318153066b.22.1743807421863;
        Fri, 04 Apr 2025 15:57:01 -0700 (PDT)
Received: from [192.168.0.20] ([212.21.159.224])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7bfe5c45asm321658066b.1.2025.04.04.15.57.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Apr 2025 15:57:01 -0700 (PDT)
Message-ID: <86903805-569a-41d5-93d8-df8169e61cef@suse.com>
Date: Sat, 5 Apr 2025 01:56:59 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] x86/bugs: Fix RSB clearing in
 indirect_branch_prediction_barrier()
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, amit@kernel.org,
 kvm@vger.kernel.org, amit.shah@amd.com, thomas.lendacky@amd.com,
 bp@alien8.de, tglx@linutronix.de, peterz@infradead.org,
 pawan.kumar.gupta@linux.intel.com, corbet@lwn.net, mingo@redhat.com,
 dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
 pbonzini@redhat.com, daniel.sneddon@linux.intel.com, kai.huang@intel.com,
 sandipan.das@amd.com, boris.ostrovsky@oracle.com, Babu.Moger@amd.com,
 david.kaplan@amd.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com
References: <cover.1743617897.git.jpoimboe@kernel.org>
 <27fe2029a2ef8bc0909e53e7e4c3f5b437242627.1743617897.git.jpoimboe@kernel.org>
 <d5ad36d8-40da-4c13-a6a7-ed8494496577@suse.com>
 <ioxjh7izpnmbutljkbhdqorlpwtm5iwosorltmhkp3t7nyoqlo@tiecv24hnbar>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <ioxjh7izpnmbutljkbhdqorlpwtm5iwosorltmhkp3t7nyoqlo@tiecv24hnbar>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 4.04.25 г. 18:17 ч., Josh Poimboeuf wrote:
> On Fri, Apr 04, 2025 at 05:45:37PM +0300, Nikolay Borisov wrote:
>>
>>
>> On 2.04.25 г. 21:19 ч., Josh Poimboeuf wrote:
>>> IBPB is expected to clear the RSB.  However, if X86_BUG_IBPB_NO_RET is
>>> set, that doesn't happen.  Make indirect_branch_prediction_barrier()
>>> take that into account by calling __write_ibpb() which already does the
>>> right thing.
>>
>> I find this changelog somewhat dubious. So zen < 4 basically have
>> IBPB_NO_RET, your patch 2 in this series makes using SBPB for cores which
>> have SRSO_NO or if the mitigation is disabled. So if you have a core which
>> is zen <4 and doesn't use SBPB then what happens?
> 
> I'm afraid I don't understand the question.  In that case write_ibpb()
> uses IBPB and manually clears the RSB.
> 

Actually isn't this patch a noop. The old code simply wrote the value of 
x86_pred_cmd to the IA32-PRED_CMD register iff FEATURE_IBPB was set. So 
x86_pred_cmd might contain either PRED_CMD_IBPB or PRED_CMD_SBPB, 
meaning the correct value was written.

With your change you now call __write_ibpb() which does effectively the 
same thing.

