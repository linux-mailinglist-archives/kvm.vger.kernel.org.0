Return-Path: <kvm+bounces-70181-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uCcSGP4mg2kxigMAu9opvQ
	(envelope-from <kvm+bounces-70181-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 12:01:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C8817E4D8A
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 12:01:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 70226300AC30
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 11:01:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68C623E8C71;
	Wed,  4 Feb 2026 11:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="efGJ+0df";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="erOwzmI8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BA23D7D83
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 11:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770202869; cv=none; b=URHvQFYOJq/GE7QCZdwGC+HY1awYU5WWlU0CM+6/qLjm/80rdqGXa3mDv54YBYhd0lxjgmzry+yHOUjrIr+HO1obXHV4OyKjajH1aDk7As1AXyEGOw7bE17GNN6soT0S7jcBPIwrIMFdjDy8YoM6URdh9WS+mgz5dRVuLaUci9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770202869; c=relaxed/simple;
	bh=m46LMUWk5jnhsZu6bi0/L8ImivAOHtptqN4mC8Em3kQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kc9ktQtJPi26sr2KIX5somPmmq1A2Fz7+52AgpwjmTNb1LwScyGao1HOCRQTcbABEtTO1/yFsF1en6bPZcC8WeRWBszOFxm/X4MN5rRkazwW2N/hrnasyZ3i0Z/IKooO4+NzDQpOxnrHGdRe2uIMy+C6rs1kGXl3L065VeVzpWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=efGJ+0df; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=erOwzmI8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770202868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=u+O6sAxi0+uikxe9nJN/COhn6Ec+5y5VrLnRQxND988=;
	b=efGJ+0df6PPVk03Qzs+F7HSOW4KrWstirQYOaXsyil30jefhYT+lbzn37l5e2uBfYdFpP6
	Isz9ywovAdybroqPvwpd89zOtHOebmkn8M2UDyoXcIilB7v1XmIW/SMr+fXuPsxMYYrw/M
	b0W+cJODoCJHSIlG3bUR7pAgXcVoCgs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-474-4ELRfoYFN3Cp4ShX7kyUHQ-1; Wed, 04 Feb 2026 06:01:07 -0500
X-MC-Unique: 4ELRfoYFN3Cp4ShX7kyUHQ-1
X-Mimecast-MFC-AGG-ID: 4ELRfoYFN3Cp4ShX7kyUHQ_1770202866
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-430fcb6b2ebso5232765f8f.2
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 03:01:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770202865; x=1770807665; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=u+O6sAxi0+uikxe9nJN/COhn6Ec+5y5VrLnRQxND988=;
        b=erOwzmI8Fh42tvZlTf6Ub+cQ51dG4w4/nNPABvyv05tY7khtt4rD4K9WoGM9h3LlSV
         7krK1TgxkcJaHrYI9CH6nTzGi8eOjQpPIZWfaAEjN4ElZiAShgaam199RoX1kCy1e5Xc
         9VT8yltNaLfVCRSW5Uso5uwv4lCECS8s3q1uc9Q8Dz+h5dSHeEf34aOwNK9sX53EHlXA
         DFuuVJbo1nNk+BH5aXyawfhL/vPD0gbYqhioNQ604e8n+Fu7uEDNnU8ytZmO4ketIB4z
         MwjEkAQaqSi8aYNDgsLv1qyGb1n6E+qNAPsS2dUUl4WcBlwAJ7VjOsYvEizHilySQQGJ
         c8ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770202865; x=1770807665;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u+O6sAxi0+uikxe9nJN/COhn6Ec+5y5VrLnRQxND988=;
        b=D7MMzaT5IqXjFx+/P5F1w/SlV9BEWiWi15VEYxch/zn/H90ZIgJSD2GcMmGxuXTyJJ
         JGm+z4hzn/F6LdTnpxgQiRZ2oXF/i6hNH3/n8Q6fz2h3My4tzsC6ZnxdAOUoQVdQFlGk
         3mVct8mDUfyMsZERr04P4LVgK9Ky8nvXESa5UHvp7cSvau4Yz3c470PtoNYCcOhYtwou
         b6GqCsuzSknVnS/PjrPocMRidtU8CTNce/0237Hbbe8XBwPiop/LzaSIhXtpq2a9ml9X
         avM1CdV6aqUuMWuJJak+7Ml/WOof0Kc8RxBBrBN9Jmh0YhwTI6MtGUewkghKaqlIMJ3y
         0kVQ==
X-Gm-Message-State: AOJu0YyTV+oduCkLg0flqhfRHU/KMee6QfjyfiUxz3uMdg4M+l+e8rcz
	4RuVBSXK0jrY+l2ZwAUiBv0RXQX7qsSoUm4LeCwff1lfcglnrZbH33BYazIRcWkJjPloppN7CvZ
	w66cgP4fS0BHt3nTMUOaAtDl7WjhS54xaNbR4vLJ06wyXX8bwhK7jF6X06VCJAg==
X-Gm-Gg: AZuq6aJZ2TH1KlJ5UhZ156aFWM9jo6YXssnpQ9y/NtlzyXEdDNmsvB3/cbkiqW28FAW
	jyCOpvsTDmncFskhTIuF8u0e5vroeoE+alvVjQDD6/uGy9ngeQH8VOXKz6OwWhy0U5U8jAjVdSW
	eHv0jPchjf54mMswZdkCX3ZonAkpfLEdPgqLIQcpta4POMyLdQkDSP5dBVGc7dPJRPU0e7EobFZ
	8pRWCqw52fd1C0R9xhCMGP8KLWYiFd1V6uYWn3MHL8bg4QiFU1XhlkE68W4pKdvyv+RDJK0Za3K
	HVPkZ994igSQvd3iDOC0S9qZ1cfn6Bi8UzMFuF1mipvfrUYFXDh07h0UmwlUWKyKL0GjUiRIhFz
	Wwf8qo2/Vof/boKVehO1M2EnD+7EO7F9z8y97Z4S/XTreW++s
X-Received: by 2002:a05:6000:18a3:b0:435:b068:d3d2 with SMTP id ffacd0b85a97d-436180611a9mr3521297f8f.57.1770202863984;
        Wed, 04 Feb 2026 03:01:03 -0800 (PST)
X-Received: by 2002:a05:6000:18a3:b0:435:b068:d3d2 with SMTP id ffacd0b85a97d-436180611a9mr3521231f8f.57.1770202863356;
        Wed, 04 Feb 2026 03:01:03 -0800 (PST)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4361805f8c1sm4763764f8f.37.2026.02.04.03.01.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Feb 2026 03:01:02 -0800 (PST)
Message-ID: <da5b11cb-c55a-499c-9351-729370f77948@redhat.com>
Date: Wed, 4 Feb 2026 12:01:01 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/10] system/rba: use DIV_ROUND_UP
To: marcandre.lureau@redhat.com, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, Alex Williamson <alex@shazbot.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Ben Chaney <bchaney@akamai.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, David Hildenbrand <david@kernel.org>,
 Fabiano Rosas <farosas@suse.de>, Peter Xu <peterx@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Mark Kanda <mark.kanda@oracle.com>
References: <20260204100708.724800-1-marcandre.lureau@redhat.com>
 <20260204100708.724800-2-marcandre.lureau@redhat.com>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <20260204100708.724800-2-marcandre.lureau@redhat.com>
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
	TAGGED_FROM(0.00)[bounces-70181-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: C8817E4D8A
X-Rspamd-Action: no action

On 2/4/26 11:06, marcandre.lureau@redhat.com wrote:
> From: Marc-André Lureau <marcandre.lureau@redhat.com>
> 
> Mostly for readability.
> 
> Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
> ---
>   system/ram-block-attributes.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/system/ram-block-attributes.c b/system/ram-block-attributes.c
> index fb7c5c27467..9f72a6b3545 100644
> --- a/system/ram-block-attributes.c
> +++ b/system/ram-block-attributes.c
> @@ -401,8 +401,7 @@ RamBlockAttributes *ram_block_attributes_create(RAMBlock *ram_block)
>           object_unref(OBJECT(attr));
>           return NULL;
>       }
> -    attr->bitmap_size =
> -        ROUND_UP(int128_get64(mr->size), block_size) / block_size;
> +    attr->bitmap_size = DIV_ROUND_UP(int128_get64(mr->size), block_size);
>       attr->bitmap = bitmap_new(attr->bitmap_size);
>   
>       return attr;

Reviewed-by: Cédric Le Goater <clg@redhat.com

Thanks,

C.


