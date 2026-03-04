Return-Path: <kvm+bounces-72687-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QIEkGsBNqGmvsgAAu9opvQ
	(envelope-from <kvm+bounces-72687-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 16:20:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 097832027FC
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 16:20:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 38138309DE13
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 15:06:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDE642D5922;
	Wed,  4 Mar 2026 15:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cZHUYkoD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A368033986F
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 15:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772636558; cv=none; b=R0hDYptN1wJlpUIqZmusa+KWw47zO59iDqXg5FTvRnGfjXmuV4c0zUedtEnmVwiJnUh5W/GOOSSS061M7ACkG3EwTx9bhAhDW5j0yPEYh7aTmf+QIEIhul5Mc/uPz80Cpnt1vtz4Q6/pJ0dMg8JmFvyrhpNgIsYvVv10x9PVr6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772636558; c=relaxed/simple;
	bh=6zZ1Agw5MlpKm8ZY1+2Yokb8eeyLEP5wcbptGyVeKdw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QU5vp4iJrc48sNo6DWk20Fyy+nlMUsu8kxZ3p4tKKgjBWhm6U5qG1PQsjAkY72epZ6R4hhBY+d+79aDd+/6Da4k4F4+vW4l62bgz2NgamdTYVakcbd+8qWDP52Hacrfi46IbXMsgiuu1ebRUSecFZt+wWWzuuGiDm/SxEMTN/bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cZHUYkoD; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-48378136adcso41600275e9.1
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 07:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772636555; x=1773241355; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=PQaLSfKevN5NxnWRn/Bkxayowjy+4UP8KRfpRnFjRz8=;
        b=cZHUYkoDdj97fbD9famjt67lzbHcCltVqkPej0TXo5bARCRH5HJP4gYo3WzmzoqlNe
         aM1Yc4vKoKd+yhys8BZkuLLw37neN+44wQ6+4oonX3pcnQA+LB9E03eeljgDGgNDlJFA
         gf4DV3uO5zWh8CkgulIL430DGqgZo+DOUm1MuqXpZyPh+HWkYdeZLjbmflmfcaaDbLow
         jPl9r5Okr3INU5mr/W4Bi8B8ih3kXZbdUGFqeDgGCNaMCNHfiw9I+k7s0Chl/yVopbgh
         2aLXBQ+Vz8etSyRo2j4+ocsAuH+/gtbVCnNNYbOfsccDtmASCD7A5eBpVAaMqtBmdA+l
         7vUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772636555; x=1773241355;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PQaLSfKevN5NxnWRn/Bkxayowjy+4UP8KRfpRnFjRz8=;
        b=gAdsMICIFY3dlnQ2FTAL01M7wBTBudPuxTutOSzqCqTUBo3F9/bHHl3+58iE5zRRxs
         8SKyfDZJrKCmr2z3sD0CAEAY3TpF76w74yAByvmZN9aNGQSJv8Qtcss5g8Dzc+SVg9Jp
         Fs0L7YZwddWBJmo14gZxoh1wJ94OAkNTYwTMZm+7CbMSlW5kwukP6eseKVSdrFKy6skn
         5ex3wyuUXnqBfKF2AEOl8ZngiYQKQMp0LyndENuM5A79tXklONfFBIth4ccc/mY/+XLQ
         TrI7x4tVYl8bYwyeuD0XD271/5pOqig17an0sqTkoLw1j7CxPyPD9cKscq8x07ib3etd
         oRRg==
X-Forwarded-Encrypted: i=1; AJvYcCWlwusBWfkKdr7dMergHE7QQCYeiS6EupU549auR21UoPVvi0j644oKpdrS0uT2tv/Lm4U=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdiUpFxaCH7Ga7L9/k9cH9NXqOv5JgTKCb36KA3NHdFkrviosY
	417BeUb3OMYVyP2IL+IEfJKvoJikxYjUBTcq6GFNYxkA6wTIuNMA9v0VdkBCI5q2aoM=
X-Gm-Gg: ATEYQzyXX43wifwJiREg2BRxbxkt0vwYr2BY4wGfHR8ySdKn6QvPxGQ2w1raFHXwb3p
	6eXfxJWfckpYwXSsuW8oDY3aZdNo+UtNKt600RbHqJ0ZS5b06meF/i3/oIo4UkL6JocDHVlIg7N
	dXFBiVt3w68E1bAyUGpj2HF/ApEphFrXji+Hx50rV6ifvRQGntL4b83F7JRabdYuOPsZxryPm5Q
	PNhcHhVlBO56D4ThP7J9SLb1iTmMxF3SmAueKkoYXXUO3rLxRKcg2niPwGABbAf6X0HXBH4BuPH
	BFE3iiPJtzKgYbH/vValJcmU4GogDlbIIXPegg/NACZamppDpG0kWQX0wYPy6liaeW3OadFxAO3
	dJNfhO40VlT/OCVlRhA7/iG1OYW/51X/XqKSIItTIhLqaAE6+CC+uJn/EjcatELsuy2bGcZGctO
	gF5HpUOYVl9HWFhDJnJObMQpDVY7OckIyip73RGw98JCInsvh8MkgFUTtEhM4=
X-Received: by 2002:a05:600c:6389:b0:480:6941:d38b with SMTP id 5b1f17b1804b1-4851989f63amr33047315e9.30.1772636554833;
        Wed, 04 Mar 2026 07:02:34 -0800 (PST)
Received: from [192.168.0.20] (nborisov.ddns.nbis.net. [185.218.67.140])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439b0549600sm29325387f8f.35.2026.03.04.07.02.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2026 07:02:34 -0800 (PST)
Message-ID: <f0941a37-1055-4473-a8d2-fbe3e912c7b8@suse.com>
Date: Wed, 4 Mar 2026 17:02:32 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/4] x86/tdx: Clean up the definitions of TDX TD
 ATTRIBUTES
To: Xiaoyao Li <xiaoyao.li@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Kiryl Shutsemau <kas@kernel.org>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
 linux-coco@lists.linux.dev, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Kai Huang
 <kai.huang@intel.com>, binbin.wu@linux.intel.com,
 Tony Lindgren <tony.lindgren@linux.intel.com>
References: <20260303030335.766779-1-xiaoyao.li@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
Autocrypt: addr=nik.borisov@suse.com; keydata=
 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
In-Reply-To: <20260303030335.766779-1-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 097832027FC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[17];
	TAGGED_FROM(0.00)[bounces-72687-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nik.borisov@suse.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action



On 3.03.26 г. 5:03 ч., Xiaoyao Li wrote:
> The main purpose of this series was to remove redundant macros between
> core TDX and KVM, along with a typo fix. They were implemented as patch 1
> and patch 2.
> 
> During the review of v1 and v2, there was encouragement to refine the
> names of the macros related to TD attributes to clarify their scope.
> Thus patch 3 and patch 4 are added.
> 
> Note, Binbin suggested to rename tdx_attributes[] to tdx_td_attributes[]
> during v3 review. However, this v4 doesn't do it but leaves it for future
> cleanup to avoid making it more complicated because it also looks like
> it needs to rename "Attributes" to "TD Attributes" in tdx_dump_attributes(),
> which has user visibility change.
> 


Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>

