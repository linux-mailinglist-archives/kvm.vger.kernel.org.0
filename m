Return-Path: <kvm+bounces-70185-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WCinCjong2kxigMAu9opvQ
	(envelope-from <kvm+bounces-70185-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 12:02:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 94454E4DCA
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 12:02:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 37C98300F14A
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 11:02:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9EBB3E8C71;
	Wed,  4 Feb 2026 11:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KQfO9Zqo";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gVICeHxj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8293C1995
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 11:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770202929; cv=none; b=iP9Hivt3CWvInXhLn7W346fj+UKlre8OdbLIggn6dYm7EeTj0Ud+CuQvkAZvCQrikQMYO9eIT663l1F8O7V49lmoblne7PX+pGQKlIhJMjkkWqoDbHSEzRI5fvX9aRgKKNcDXPD1GeiEa/FhrgLBsH6021U7PlQRvF1PF7P9xs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770202929; c=relaxed/simple;
	bh=KguprQi8qz7j7whqrDhY/6p33Iz5Pz0gjXr4TQzorrA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XrqCwvANOhf0tflXCteQn/TpWR1C5UNcGGbyeMHNR0ciqw45CX2EC5+ngMjAPyikIa3TpDoYk6itCUWoTduG8bId7LGqCakWbjY1ZJOmawdsUOfmiZM4XAG/hZqomLqttv6AE/oEy4nyGoaytLOQvHcpD7YB8ZkJDVfk3RwO1lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KQfO9Zqo; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gVICeHxj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770202928;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=stYoBmDqpFy0bzLkTHuEeUMZMLbMG6I0YuF8zRTmjmU=;
	b=KQfO9Zqost01IlWZzK/WXP/rPCtQKHpHTM+cZ2xHTVQsaW6WORWo3jKr91UXuSodc7GGyl
	A74lA1f3M9Sl3As7i3g2gkE84E5ifpmvwgZeMf4UVIbLhcj8EJcE7ngPmIDDaNhnM/S9hX
	pKt2Ea13ji+0AeB9uqYHjSuoAoWRXa8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-575-eDTHfcNKMg6XBHoPm7415w-1; Wed, 04 Feb 2026 06:02:07 -0500
X-MC-Unique: eDTHfcNKMg6XBHoPm7415w-1
X-Mimecast-MFC-AGG-ID: eDTHfcNKMg6XBHoPm7415w_1770202926
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-482eec44485so34577805e9.3
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 03:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770202926; x=1770807726; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=stYoBmDqpFy0bzLkTHuEeUMZMLbMG6I0YuF8zRTmjmU=;
        b=gVICeHxjGjkzoCzUw6hqxnyaIsaLv+lHo8piZ0dgqTCpzns74orjXWBPnys2UNCfW8
         IP/V9M4XQGtP75fE3yUcP0+0NbPaie0HPRcridiHZvpNyC6wyNLvBYpjHmMlDmdzGnkU
         0/Qo/NEInES94yVsKOOnu3Afp9upRN5eHKqa7/YAF1c2SW0tMQVM9XNokGle3ICSkNWg
         RVlpuYS+j8Mm0w0C51oB2N0TQNXAOj7ywyEH3Lm2O4bnJXLVgoAqVanv2rnBWmw74m9A
         elMEoFOTXKB/RWTNAvmuAxt6K3X8AC2021z5ht5AnSDZkNI51c1vPjxGWZ8Zr5O+rnLC
         fpqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770202926; x=1770807726;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=stYoBmDqpFy0bzLkTHuEeUMZMLbMG6I0YuF8zRTmjmU=;
        b=VYIE6q5hY/ZgC9Glb9h6pc3Xda5wGPABfcguTBdkKge797EWdqqVHzlpSvLijjuCQn
         CvqNjnHoboF39G1K7dzYgaCRdJHWQGabmNFGejxhxBXwSa65spvwBkMZioIymiGUe4te
         z9IVJDG7suUyVv068/b9GqMyC/VxY792RCP8jq7+AxHUzhHKM+yY10INGTZ8hTMP+7kE
         Xvm5MElrwYZA/9EwlVOEJ19W0zOQ5zfQtIHbUHAuM65iGKR5GKVDm7Y6sD2J0hhpb+hL
         /oBmSBdCENUM9y3+T2sIJ6ZGNUo0frkQulD81QcB0UIru5FvJhawdlv/u8yL7yHALO6S
         b6Cg==
X-Gm-Message-State: AOJu0YzaB1y3bimVvQANnA/gKR4SqflG4kDi3m524kVkTwSs6NOm9Qnj
	d7Gq7hTnv1QnUt9Ru7cqudYghOr6NvRr7VAKgDs5rYaTtz94QhnPSIVM3OcWTP4ZmQ5gihxIL8O
	gg+/JSDKkEcE76KY4wMojMROBGso8llsOPS+/Tgjl/P5LOhJuu+Qhow==
X-Gm-Gg: AZuq6aJqkCKrdu9qiuz/h/VIe5+9V7iUsLhF+dLAlzx1dDDXgRGHNpgt8baYoKi0UUj
	xQ8VHG+yNUvDOWGp2RLEPwBT0PO5qSEIfjaSQwg9pJWkhNesT+FsgGG4mrMCQkbq3bt8xHrH+NJ
	MEpDoYO5kxTM4Bug+nmuEakYt98kqBHCetqq45rIYrp9Lbh9gM/bKjggckWn+OdAbr013fMtkUg
	sRrMo8LEMNGIlHthIjIrPwRBCP9rpAEWcHrLK3Bc5l4XMlIwh12acCbiLOctsarDrfQwxb7I020
	Y32lfPgin4AXh7XYk16x/SR8bm9xnlXuDIa/AYGfbzc/WDt5/vJPVaBTcI+yqmra8IYuWdwnd9D
	4POy78f5VBkce5onkCx5NMwaNlRzELoxaCOB2wW5ldXufvtWh
X-Received: by 2002:a05:600c:1c28:b0:477:7925:f7fb with SMTP id 5b1f17b1804b1-4830e93203cmr38810205e9.10.1770202925865;
        Wed, 04 Feb 2026 03:02:05 -0800 (PST)
X-Received: by 2002:a05:600c:1c28:b0:477:7925:f7fb with SMTP id 5b1f17b1804b1-4830e93203cmr38808305e9.10.1770202924171;
        Wed, 04 Feb 2026 03:02:04 -0800 (PST)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4831093650esm53589965e9.15.2026.02.04.03.02.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Feb 2026 03:02:03 -0800 (PST)
Message-ID: <1a656700-8185-4b0f-b90b-795da131e110@redhat.com>
Date: Wed, 4 Feb 2026 12:02:02 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/10] kvm: replace RamDicardManager by the
 RamBlockAttribute
To: marcandre.lureau@redhat.com, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, Alex Williamson <alex@shazbot.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Ben Chaney <bchaney@akamai.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, David Hildenbrand <david@kernel.org>,
 Fabiano Rosas <farosas@suse.de>, Peter Xu <peterx@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Mark Kanda <mark.kanda@oracle.com>
References: <20260204100708.724800-1-marcandre.lureau@redhat.com>
 <20260204100708.724800-6-marcandre.lureau@redhat.com>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <20260204100708.724800-6-marcandre.lureau@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_FROM(0.00)[bounces-70185-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[clg@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 94454E4DCA
X-Rspamd-Action: no action

On 2/4/26 11:07, marcandre.lureau@redhat.com wrote:
> From: Marc-André Lureau <marcandre.lureau@redhat.com>
> 
> No need to cast through the RamDiscardManager interface, use the
> RamBlock already retrieved. Makes it more direct and readable, and allow
> further refactoring to make RamDiscardManager an aggregator object in
> the following patches.
> 
> Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
> ---
>   accel/kvm/kvm-all.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 8301a512e7f..b6a593d0863 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -3124,7 +3124,7 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
>       addr = memory_region_get_ram_ptr(mr) + section.offset_within_region;
>       rb = qemu_ram_block_from_host(addr, false, &offset);
>   
> -    ret = ram_block_attributes_state_change(RAM_BLOCK_ATTRIBUTES(mr->rdm),
> +    ret = ram_block_attributes_state_change(rb->attributes,
>                                               offset, size, to_private);
>       if (ret) {
>           error_report("Failed to notify the listener the state change of "


Reviewed-by: Cédric Le Goater <clg@redhat.com

Thanks,

C.


