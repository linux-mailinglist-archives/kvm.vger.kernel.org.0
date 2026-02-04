Return-Path: <kvm+bounces-70184-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EGjkLyQng2kxigMAu9opvQ
	(envelope-from <kvm+bounces-70184-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 12:01:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 35101E4DAE
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 12:01:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 66585300ECB9
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 11:01:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02B7C3E8C71;
	Wed,  4 Feb 2026 11:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bmE2xBW4";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="JVEQikAc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1463A3D9049
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 11:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770202909; cv=none; b=KFUdwx2KC7+/RTfeTnZos8HHDDyuxeME7yz2Ks55y/uJKTDU1IVltmXVwbr7gwbwChSZ4TwSdSZummcE6gfzzNDXrEGKgB/6UOcSTiy5EJmPRLFlOcxBpt3LsNB5o6xqVjVusjT/OuWRRihNTcticeW5Rh2o5l6LPFnjTrP/aFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770202909; c=relaxed/simple;
	bh=Y1Uhj6JfcZxJlkorun2eWU9tfGcUMtrPdLiELMWBn5s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WwcsGVEdriMTxIBmnosm0tiShwVcjIqtMuXzylLfxU45I9CvOtHqYWs7quZMQwhYPZcGnKOnQ/Iy0dtaSJI5jF/YH3l9LQXVTYAKd82I9fq5rZDrtUmawVCg2NdHA3wGRMXmZHL1atpwpRHLqnWN6Ak/vJ1waQWe1r+xRm732So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bmE2xBW4; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=JVEQikAc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770202908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ytqoyVsoCtzdTkkmGSJsy6xixwptxcvSJRO6L1WAx8A=;
	b=bmE2xBW4v8JTpAObB+wralXPOE3Lr61PwV84n2yiRPLA34LIDlijVcziTS3wry4kDl1nYl
	zg+JHRoEB2FpDnvPqBz2irQvpK5I0ILOe1/HNsrBsCoufwKZI0hjfdvvG+RjuxgLXUp0a2
	4XfJUsKcteLNAxrHvfC7fyz2ZjMN/KU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-685-Benvhdj9P-2ta9aJP6kYOg-1; Wed, 04 Feb 2026 06:01:47 -0500
X-MC-Unique: Benvhdj9P-2ta9aJP6kYOg-1
X-Mimecast-MFC-AGG-ID: Benvhdj9P-2ta9aJP6kYOg_1770202906
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4325cc15176so4651047f8f.1
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 03:01:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770202906; x=1770807706; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ytqoyVsoCtzdTkkmGSJsy6xixwptxcvSJRO6L1WAx8A=;
        b=JVEQikAcSUjkWj9b2P+Sy/TJXKyJmNXIO7y15yeS3vpNyKhOwLKBkc1nLQ4Hsk13HS
         McsQ/dB9Ipt0JFq+iNCrhN/uhhPZYgmFVm8X/71ZfXy2LcN8CvL+VfSCaA6CEyDPeQy8
         RsP7e9vqEUhBsFwb9AlQ7YQnwyrbAvQ22AOOozCnYTuYb5usMAbuU9hNAIe4PqX0gK2L
         kUHX7AY8xIAYaYouAzkK3wuQnaRXNY6E7k/+N/v+4K/DeX72PIOg2jX+JblIt+v4a/U6
         d/CKXVZ1M690O3vehEdI2zWclt8vf8J3qbB+r6Mug3i1HbVnQEZuhejEqMqQheZx3RRI
         +CEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770202906; x=1770807706;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ytqoyVsoCtzdTkkmGSJsy6xixwptxcvSJRO6L1WAx8A=;
        b=A1cyV3YHIdDpYKkLBybb+eGHlN/GmE7R8j0PivjY5m4LWkPwEUEK/8SMBTEMqnLsa/
         xZ3ov8vAUPNCcBPlTsEnED/yTIHnV4vUiim415RGtCT8KCXxTj4ujtdBOYFrTkai36MD
         0KXnvNyi/WkrInmU8Fk+BnlcSK3t+f/ynlBGBtkLE/qRHiA9DgS+Gs8wyqn4YF8pwAgO
         +/SM80IavII9D9lWxBFKFdLhJ3Q0gI1zetqzHuxwi3CZDS7+Qx3QG3WabKdvJ/Fg2mc1
         ux8b+ahJhoceNXovCCa8lDXlu4fEBzZEkvezFXJxP967V3bPkfvUaeMqJDaIxUuJ1TwJ
         t90g==
X-Gm-Message-State: AOJu0YzZ+wlNjqbfR6TzwZMMpo4ANLgrqsfrtmzvnjwaxYgtgTj/M4GJ
	pEXJ9DPmkDFb4oUqwGb1mOGtWLeqq08uqWFj6A9Sg65+vnHlTplcbSwv4MMyuueS70sud5o/ru2
	QItW0TXJIePngXurqkBGGysqTPMfG/aF1PseTKqSMDm4IjEQeFmu5kA==
X-Gm-Gg: AZuq6aIq/EQjFin6l70vODaiYSi6RG1vmsjEZJ24jo9NcaNSLqSe+EY8LPT2XkPF6iB
	Kk4YB4Oa1ZF9UJxY4gMI4PMiBvklRb5JGgKwbaATb0v1WSeI4gZ18pv/ewMhRQ+T/Wuts/RzTj1
	Iituq6c3svKHH0vdo0YYMSKAJc0IcyHL52STQSwZn32xMVH1V7OuHQN+YbORHkxuM5nDqDUyhMm
	tJ5+i4/wLgiTMxXzynXPBt7JvIo3tMuhYQ+wxiW+KNiL3DbirJevpAAOnEkFvWHC49HcXUWNrP3
	9G0kEAqHwXxV8i+31tmGzIH7kOy4eCERpWeB41ljiJ/D5uGt53jKcpD4LwlX4FS/v+fBIP7ll0E
	7elPBJXJYhxEqOxwRHlEYBMLk3CBxpzQcSgf7O2XL0CJZsC79
X-Received: by 2002:a05:600c:5491:b0:480:46c6:bf4b with SMTP id 5b1f17b1804b1-4830e92a73bmr31086745e9.5.1770202905741;
        Wed, 04 Feb 2026 03:01:45 -0800 (PST)
X-Received: by 2002:a05:600c:5491:b0:480:46c6:bf4b with SMTP id 5b1f17b1804b1-4830e92a73bmr31082085e9.5.1770202900541;
        Wed, 04 Feb 2026 03:01:40 -0800 (PST)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43617e250b2sm5936053f8f.8.2026.02.04.03.01.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Feb 2026 03:01:39 -0800 (PST)
Message-ID: <bd8d630b-f3e9-49a7-b94a-24707a66d755@redhat.com>
Date: Wed, 4 Feb 2026 12:01:38 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/10] system/memory: minor doc fix
To: marcandre.lureau@redhat.com, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, Alex Williamson <alex@shazbot.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Ben Chaney <bchaney@akamai.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, David Hildenbrand <david@kernel.org>,
 Fabiano Rosas <farosas@suse.de>, Peter Xu <peterx@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Mark Kanda <mark.kanda@oracle.com>
References: <20260204100708.724800-1-marcandre.lureau@redhat.com>
 <20260204100708.724800-5-marcandre.lureau@redhat.com>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <20260204100708.724800-5-marcandre.lureau@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_FROM(0.00)[bounces-70184-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[clg@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 35101E4DAE
X-Rspamd-Action: no action

On 2/4/26 11:07, marcandre.lureau@redhat.com wrote:
> From: Marc-André Lureau <marcandre.lureau@redhat.com>
> 
> Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
> ---
>   include/system/memory.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/system/memory.h b/include/system/memory.h
> index be36fd93dc0..a64b2826489 100644
> --- a/include/system/memory.h
> +++ b/include/system/memory.h
> @@ -574,7 +574,7 @@ struct RamDiscardListener {
>        * new population (e.g., unmap).
>        *
>        * @rdl: the #RamDiscardListener getting notified
> -     * @section: the #MemoryRegionSection to get populated. The section
> +     * @section: the #MemoryRegionSection to get discarded. The section
>        *           is aligned within the memory region to the minimum granularity
>        *           unless it would exceed the registered section.
>        */


Reviewed-by: Cédric Le Goater <clg@redhat.com

Thanks,

C.


