Return-Path: <kvm+bounces-70183-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YJisMhUng2kxigMAu9opvQ
	(envelope-from <kvm+bounces-70183-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 12:01:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 841D4E4D98
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 12:01:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4DDAA3016287
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 11:01:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E85F3E8C72;
	Wed,  4 Feb 2026 11:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ezr1xAi/";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="rPXzgyPL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5422B3D9049
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 11:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770202891; cv=none; b=fGVJ0vVSzkwruYjreRrNczDrbS1aLE6ykSkM4SoAMudPBMeeJMbvxLToFhNuesV9fDoAtPYS6fYQY5pFgBbDGs3OlWkhcETXF4Jo3nkYEBk8jtwPyf1RXdebtUvbqYMonV1p+Wy+awnCtvQ6o0JlLM//9P+cqNvCzYlHtYWuooo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770202891; c=relaxed/simple;
	bh=Gl3yzWLtY6a5wD1HkcBMM7Cf1CcO6DGRYdCtMkY4mJ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mY/2QRo13Jite/0hn/Ao+TQKyMw787T4WwaVsTsybBwin+3ok+bbO1Y3WT6L9V1jvp/csIaVGHXntevlY/baLpRo7OmmgN/toqtEiokkwnG9Hl714Jt0Whyf0axmlztS4caWzef71T5QeBXaE/a8UuNPPCUa74LEsOnNzFWW9w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ezr1xAi/; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=rPXzgyPL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770202890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iX9CLo1079q9GFBbcum8ANwzEzOFk8ylauhc6MGrexs=;
	b=Ezr1xAi/GZGChS5YWPiZfmt+WaylCxdw9+RMED/ZI3/YCvz3TKi3l+xDJyJEoaRezILQE1
	KCAGxQr+ebnb2qG2FCnGSgQLvPylLf+euEVfvJZTLhouxrBDi+hL8E64mL78usrJXcyKXm
	lUEr4pLlmMVislxYtqn+aZVg2UJ7zzI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-263-D4JDv3ZKN-eq9RvRVQDFLg-1; Wed, 04 Feb 2026 06:01:29 -0500
X-MC-Unique: D4JDv3ZKN-eq9RvRVQDFLg-1
X-Mimecast-MFC-AGG-ID: D4JDv3ZKN-eq9RvRVQDFLg_1770202888
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-47ee056e5cfso59691635e9.1
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 03:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770202888; x=1770807688; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=iX9CLo1079q9GFBbcum8ANwzEzOFk8ylauhc6MGrexs=;
        b=rPXzgyPLbuTqsulDCEtrDggIMObVego20jocB8e+vAppIsT6xKruZjzVQ4GZgzXrrC
         +zN3/OJhugclRIPuMJGAwyho9ecUnB8u+lH3ps7jS6CYJZfFLQ0LJMh5EApm721LHzy7
         l6psyuCCWMcGzTFvtPbOJLBDNqjXm00hCKTV2ZvnGPF7JfBazJKakz4bu3uJeDwIqcYQ
         qCKqJ5458hsgY7h+3bgiLlDrrLCLhwKd0Gxs/PLDRSBJvUARrfAjPalk2TWKXzC5yqEX
         BBzBUnK1oOIQs4pPu4IP8fb0Q9FVE5H2D255ZCSvzEbS+A9XJaje98HI66eXFb5k981N
         Q/YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770202888; x=1770807688;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iX9CLo1079q9GFBbcum8ANwzEzOFk8ylauhc6MGrexs=;
        b=lkfrNV4J5sIKy6kJn4A+ww05GRjnpw8bcueZxiJyNNAFvT5GoL+OLhApq5tO3QRSav
         IIt6WRht0sg27aHYhUebWBZx0DWl2JADeduE3O6mpF/wcuKdW+TVFVZ3uxLiUbXuR+s3
         k5Qku1CpSanr3ENs5lcPuG//+G/rSzYonyT8tckMAjBVJrsdhUQ1eB+UaTYdyfJqG3tJ
         /XERtDQW4JbE+kwP4QiXZMEEv/pFh89jj3GTmkSIlN3xbgKqEQRNskL/fUkh9rBcCPFf
         gEgwpBuDsS9NQ30QnJH3syeUF3Ey0cVRi+ZyZ0iCDkEjmewxYR/gV1MIUqsQtEK2KwIH
         XORQ==
X-Gm-Message-State: AOJu0YwhkPttUueK3j3iG1mh2A+2GIYsi1U9TKrwE/8JpmjE8iM4zGGS
	GSvdCppfwQfEP6fGqjE3mKNcbAVD6K8CBrSJ8UeWYO55M4SY5C5SA94+C8S7Wqd827UOip7mdEA
	HV3RjJYRLSTZc+96Sq+oWD/W/ZO5r8mztpS6vGFtKz3zxPZk4C7gwvA==
X-Gm-Gg: AZuq6aLENmS+F871Zz16GxrqWP2bKCO/wdcERAsLVUDqTlJ/JHY+uuIl5ARynM+EEXN
	02EHttihqOn+zreuvT10HmFGcdrT67KDLeCjffDzK5Ct6fiDZm1jOrNSchTREwBaLr2X/KOgOPZ
	/9HRHyDUpmZRaPTpZ3Ojy0/pIDG5wRA4/3ujSKG+kRSQNudfkrWMXL+sUA6b141Vpj0JU1ocY/5
	fG0MzsErpuQfCBD7ZLkhQCWovcBIDRjRVnAsao2D5lXjB5Alfj53PrwBaVcVI2Vfx6ZW4sLZbcn
	eoGw2Q2pxDuEs6WNwq9qfYJU9Ge/EJAbaZL3f+wAwC43C3SzZ3NKgDOYwSIMXk/MM78JVcvQJoQ
	8QwZmHzdf+oaiH2Mm1IAbC3eDid2/2vGqcHyPdVyOg7NDdNp3
X-Received: by 2002:a05:600c:5309:b0:480:4b59:9327 with SMTP id 5b1f17b1804b1-4830e93eb11mr32228415e9.1.1770202887801;
        Wed, 04 Feb 2026 03:01:27 -0800 (PST)
X-Received: by 2002:a05:600c:5309:b0:480:4b59:9327 with SMTP id 5b1f17b1804b1-4830e93eb11mr32227875e9.1.1770202887315;
        Wed, 04 Feb 2026 03:01:27 -0800 (PST)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4830ec42833sm28680595e9.1.2026.02.04.03.01.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Feb 2026 03:01:26 -0800 (PST)
Message-ID: <f357d187-70df-4482-b224-47006f0cefec@redhat.com>
Date: Wed, 4 Feb 2026 12:01:26 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/10] virtio-mem: use warn_report_err_once()
To: marcandre.lureau@redhat.com, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, Alex Williamson <alex@shazbot.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Ben Chaney <bchaney@akamai.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, David Hildenbrand <david@kernel.org>,
 Fabiano Rosas <farosas@suse.de>, Peter Xu <peterx@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Mark Kanda <mark.kanda@oracle.com>
References: <20260204100708.724800-1-marcandre.lureau@redhat.com>
 <20260204100708.724800-4-marcandre.lureau@redhat.com>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <20260204100708.724800-4-marcandre.lureau@redhat.com>
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
	TAGGED_FROM(0.00)[bounces-70183-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 841D4E4D98
X-Rspamd-Action: no action

On 2/4/26 11:06, marcandre.lureau@redhat.com wrote:
> From: Marc-André Lureau <marcandre.lureau@redhat.com>
> 
> Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
> ---
>   hw/virtio/virtio-mem.c | 13 +------------
>   1 file changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
> index 251d1d50aaa..a4b71974a1c 100644
> --- a/hw/virtio/virtio-mem.c
> +++ b/hw/virtio/virtio-mem.c
> @@ -594,18 +594,7 @@ static int virtio_mem_set_block_state(VirtIOMEM *vmem, uint64_t start_gpa,
>           Error *local_err = NULL;
>   
>           if (!qemu_prealloc_mem(fd, area, size, 1, NULL, false, &local_err)) {
> -            static bool warned;
> -
> -            /*
> -             * Warn only once, we don't want to fill the log with these
> -             * warnings.
> -             */
> -            if (!warned) {
> -                warn_report_err(local_err);
> -                warned = true;
> -            } else {
> -                error_free(local_err);
> -            }
> +            warn_report_err_once(local_err);
>               ret = -EBUSY;
>           }
>       }


Reviewed-by: Cédric Le Goater <clg@redhat.com

Thanks,

C.


