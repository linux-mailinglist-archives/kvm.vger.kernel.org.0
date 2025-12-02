Return-Path: <kvm+bounces-65106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id D0DFFC9B7EB
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 13:30:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5371B345C4A
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 12:30:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DDFF311971;
	Tue,  2 Dec 2025 12:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JAgZ3/mY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C79B31281E
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 12:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764678622; cv=none; b=isV3xsjBvsN69tN4n4EBnNQ5tA//GCnjINanhlC/TDiJ8Zs01l5KJyeCwePjv6vzqhwGsPKFEVRpHBckGpMhuNcPn3louYYffSv8r48xr8ZdQ1LZgFr4TIfPjjh/4+hPIw9HRKvcUzndktRc73puOcUxzE4Sf59Uluuf3zUR3pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764678622; c=relaxed/simple;
	bh=DYrCxNPlFuVDSPMG9cJBMCTF+3+Wuie5AgeLdOEZ5KM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=meX1Gh98JOvPlKLE1OXW3Y1/UGIzDxyxjiLReZvnCn7r1uY3RTByzWPUyOyhvdyTngTVeahSgGSD3NNGLuhWeZEWlUMVW4aOtSUujhlZsqefXknA3SOCHjJhJkFBxSL7jObbty8ilYQ+FyXeXUntgXC4t8torCiORKBgoX6n1Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JAgZ3/mY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764678619;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+k1NuFG7spi4ZG7Y3o/8GYtNYDGncuAlR/SSsckE/eo=;
	b=JAgZ3/mYTrqNP96gs2HNuyIGihJ9xj9+QvzVry+LSpz8WRgzV04wq/3j8fnyOAhdkJXXHb
	40xFTI6dBNETfuTtWh0WPvsXka54KKXTiT/sbwFQ0xdd8WGPci6iz4Zro+tgVAOI7sjSPo
	Bu67hyDLcGsC/v+nQXPJ6sk0QvCS59g=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-511-DXMwUTX3PyacqVnbdMP2SQ-1; Tue, 02 Dec 2025 07:30:18 -0500
X-MC-Unique: DXMwUTX3PyacqVnbdMP2SQ-1
X-Mimecast-MFC-AGG-ID: DXMwUTX3PyacqVnbdMP2SQ_1764678618
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8b2e4b78e35so978972785a.0
        for <kvm@vger.kernel.org>; Tue, 02 Dec 2025 04:30:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764678618; x=1765283418;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+k1NuFG7spi4ZG7Y3o/8GYtNYDGncuAlR/SSsckE/eo=;
        b=C9TDj7BURqkhg8IgjXp3MzMw/JYjSyhBeu6XG5k32ccHB8pekOP0uFi20fK1MSoX/b
         /vPrEPK80atiXHATPb+NdXAIYe9I+9FmNNM6kaVNGjiB8l9htIRIMqsl27ln4jAmFiz0
         F+N5XQ5xPXzSI5yWdxx9oJ69ZBw+Cev7OupBFG/MQ46e4e+L5F7D+Opnq5WBgjbn+UZj
         ZS11vPjYgInO2XJnAIhyJ+Dl8SmUgQro7r1bmeajuE6hBgPNY9T/28l0hZVu6lU5pYjl
         IYLCkU6SjTsRw2qBI+0Zv45sQD86ZuUgjn1QTwLJmR/7Wtg2BE/G3wWXtSGrEDM9scKF
         MLVQ==
X-Gm-Message-State: AOJu0Ywz4kRsjSmQIS7sP0MDbTYg2g5p56YsBGHQTCcgYzBfcM6VXYkf
	VU50DIg4yEE/zj7gmsJS9hFIBCDz2VU4Py9kLSPvJ82qzp6AoIuatOK/UiBXn15+BKkQvHW0sdL
	KPf9jSNvkWwk5Q0OSweWZJ8yA6M9ehkidqwREyHgZr8l47IjiR9XOCw==
X-Gm-Gg: ASbGnctWe2MDFZQ9Wlo9FLy8fNIlq2azp/5jfGfDvsJoSjATnCe/slrMqJ7S3aSfzav
	Hwt+r+Fm8pDgzTStTLdgcXGh5TXPkZT6gNrk8UKuhfaj98Strib+l/80l8j8U9c5DSZ+IdmW/S6
	5pKsltu3vnXKW+G8Z3xQONRvr3LLzqypqACIBf3f/kh0oU7oagCJySkHnDVQgBm6MSSY3kaXlef
	/P+XVgV57GArtjzyIJOFkLtnbq7sXfIcuK+Byy7nTVE7CMcKDbupn+3AYPatfY7pbQ4JaNE3pP3
	zwkRfb6Z243h8j0F0eSbxA19vWpAeYFLebpolJj2cttBYku5ik0n/3aNATR1Jdx/2FDllwNl6op
	xhyJ111Up3DNSliMd/7wOeLvoTLf9tCJv/RQm4cHAcxbdGvztWpy5MkiAHQ==
X-Received: by 2002:a05:620a:4628:b0:8b1:8858:6ead with SMTP id af79cd13be357-8b4ebd544d8mr4283179885a.11.1764678617541;
        Tue, 02 Dec 2025 04:30:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE0zRe11uom/kkSvdyQA9xz43jkfmxGltEDBekuIpQHF9i5i5ETxny6Z2lB/fuqMa/GpRMgVw==
X-Received: by 2002:a05:620a:4628:b0:8b1:8858:6ead with SMTP id af79cd13be357-8b4ebd544d8mr4283168985a.11.1764678616932;
        Tue, 02 Dec 2025 04:30:16 -0800 (PST)
Received: from ?IPV6:2a01:e0a:fa3:e4b0:95dc:ab11:92db:6f9e? ([2a01:e0a:fa3:e4b0:95dc:ab11:92db:6f9e])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b527e5bf00sm1082655885a.0.2025.12.02.04.30.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Dec 2025 04:30:16 -0800 (PST)
Message-ID: <ea2337d1-cef4-41f7-9d1a-068218e4ac78@redhat.com>
Date: Tue, 2 Dec 2025 13:30:14 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 07/10] arm64: selftest: update test for
 running at EL2
Content-Language: en-US
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, andrew.jones@linux.dev,
 kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <20250925141958.468311-8-joey.gouly@arm.com>
 <5160dadb-1ff3-487e-bd0b-9f643c3d9ec3@redhat.com>
 <20251202122115.GA3921791@e124191.cambridge.arm.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20251202122115.GA3921791@e124191.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/2/25 1:21 PM, Joey Gouly wrote:
> On Tue, Dec 02, 2025 at 10:16:42AM +0100, Eric Auger wrote:
>>
>> On 9/25/25 4:19 PM, Joey Gouly wrote:
>>> From: Alexandru Elisei <alexandru.elisei@arm.com>
>>>
>>> Remove some hard-coded assumptions that this test is running at EL1.
>>>
>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
>>> ---
>>>  arm/selftest.c | 18 +++++++++++++-----
>>>  1 file changed, 13 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/arm/selftest.c b/arm/selftest.c
>>> index 1553ed8e..01691389 100644
>>> --- a/arm/selftest.c
>>> +++ b/arm/selftest.c
>>> @@ -232,6 +232,7 @@ static void user_psci_system_off(struct pt_regs *regs)
>>>  	__user_psci_system_off();
>>>  }
>>>  #elif defined(__aarch64__)
>>> +static unsigned long expected_level;
>>>  
>>>  /*
>>>   * Capture the current register state and execute an instruction
>>> @@ -276,8 +277,7 @@ static bool check_regs(struct pt_regs *regs)
>>>  {
>>>  	unsigned i;
>>>  
>>> -	/* exception handlers should always run in EL1 */
>>> -	if (current_level() != CurrentEL_EL1)
>>> +	if (current_level() != expected_level)
>>>  		return false;
>>>  
>>>  	for (i = 0; i < ARRAY_SIZE(regs->regs); ++i) {
>>> @@ -301,7 +301,11 @@ static enum vector check_vector_prep(void)
>>>  		return EL0_SYNC_64;
>>>  
>>>  	asm volatile("mrs %0, daif" : "=r" (daif) ::);
>>> -	expected_regs.pstate = daif | PSR_MODE_EL1h;
>>> +	expected_regs.pstate = daif;
>>> +	if (current_level() == CurrentEL_EL1)
>>> +		expected_regs.pstate |= PSR_MODE_EL1h;
>>> +	else
>>> +		expected_regs.pstate |= PSR_MODE_EL2h;
>>>  	return EL1H_SYNC;
>>>  }
>>>  
>>> @@ -317,8 +321,8 @@ static bool check_und(void)
>>>  
>>>  	install_exception_handler(v, ESR_EL1_EC_UNKNOWN, unknown_handler);
>>>  
>>> -	/* try to read an el2 sysreg from el0/1 */
>>> -	test_exception("", "mrs x0, sctlr_el2", "", "x0");
>>> +	/* try to read an el3 sysreg from el0/1/2 */
>>> +	test_exception("", "mrs x0, sctlr_el3", "", "x0");
>>>  
>>>  	install_exception_handler(v, ESR_EL1_EC_UNKNOWN, NULL);
>>>  
>>> @@ -429,6 +433,10 @@ int main(int argc, char **argv)
>>>  	if (argc < 2)
>>>  		report_abort("no test specified");
>>>  
>>> +#if defined(__aarch64__)
>>> +	expected_level = current_level();
>> nit I would directly use current_level() in the calling function,
>> check_regs() to avoid that #ifdef
> I can't move it into check_regs() because that's what's checking the exception
> level of the handler is what the expected_level is.
>
> Something like this (untested) would work:
>
> diff --git a/arm/selftest.c b/arm/selftest.c
> index 01691389..f173bc99 100644
> --- a/arm/selftest.c
> +++ b/arm/selftest.c
> @@ -215,6 +215,7 @@ static void pabt_handler(struct pt_regs *regs)
>  
>  static bool check_pabt(void)
>  {
> +       expected_level = current_level();
>         install_exception_handler(EXCPTN_PABT, pabt_handler);
>  
>         test_exception("ldr     r9, =check_pabt_invalid_paddr\n"
> @@ -318,6 +319,7 @@ static void unknown_handler(struct pt_regs *regs, unsigned int esr __unused)
>  static bool check_und(void)
>  {
>         enum vector v = check_vector_prep();
> +       expected_level = current_level();
>  
>         install_exception_handler(v, ESR_EL1_EC_UNKNOWN, unknown_handler);
>  
> @@ -340,6 +342,7 @@ static void svc_handler(struct pt_regs *regs, unsigned int esr)
>  static bool check_svc(void)
>  {
>         enum vector v = check_vector_prep();
> +       expected_level = current_level();
>  
>         install_exception_handler(v, ESR_EL1_EC_SVC64, svc_handler);
>  
> @@ -433,10 +436,6 @@ int main(int argc, char **argv)
>         if (argc < 2)
>                 report_abort("no test specified");
>  
> -#if defined(__aarch64__)
> -       expected_level = current_level();
> -#endif
> -
>         report_prefix_push(argv[1]);
>  
>         if (strcmp(argv[1], "setup") == 0) {
>
> Is that preferable than an #ifdef?

OK. yes I think so

Eric
>
> Thanks,
> Joey
>> Eric
>>> +#endif
>>> +
>>>  	report_prefix_push(argv[1]);
>>>  
>>>  	if (strcmp(argv[1], "setup") == 0) {


