Return-Path: <kvm+bounces-72596-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iCUsDWM7p2mofwAAu9opvQ
	(envelope-from <kvm+bounces-72596-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:49:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DC03C1F65DD
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:49:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9B007308DFE2
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 19:48:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC41538424F;
	Tue,  3 Mar 2026 19:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KJe6WDBg";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="i87qjKTX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC1437C92C
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 19:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772567317; cv=none; b=FZDeNcNwrIr0YC9x7S2y1wwQR667Zp1YFA4adcfXs7zl5ZQgbVO9f+TD4hiNDdfebcyWfbVS2tsIKpQSeoHCFVajTU6nsyQkEN8kC9xgL68yni7qOU1nyiiCBtXbd6wlaKDtTjFTvhQhwK/hFd2LT/c1LVEB8NzxzOjRSTIv/Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772567317; c=relaxed/simple;
	bh=mM+BxzFlU8uDwNenAVj3eUQeGIQZGgUkOKnMtIAhNyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d8ZZaJPeNcVG70xsbg4lVxm/3v0UgvLgJlpUrAuZcUlkRCqyMh6TZvrEfJ5ouKasmFfJD/2UI/hCZjd15tjEqZhMS4xIsTokIAgyyCPwfV3LgzgOK/eTkjt1abfuw1GwuA83FSorY7loB+fMk5AkOO54R6bNKk0+iImv5VGT7Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KJe6WDBg; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=i87qjKTX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772567313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mah6Rptv9qO9EnrZrVhLS3/tVZQsJm7csPd9ev3L8Ic=;
	b=KJe6WDBgtZeihWAADq3O+ZxHT7gw1DNT5VUq2iMZ3Xs/e0anNZHp0ClIbIxYvCyVGnbFkh
	AQ+ajCkZVxMyyXLtHl4sogrUU7cyaEr0GJqyTFl/1uoB/0zrNCyP2BDmJ8H7fETQ7Fs26q
	7H9C7K0wJhq3UFI3YiEeFXqMQU60csw=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-A4iLfUmuNTm_Hi5AjBajLg-1; Tue, 03 Mar 2026 14:48:32 -0500
X-MC-Unique: A4iLfUmuNTm_Hi5AjBajLg-1
X-Mimecast-MFC-AGG-ID: A4iLfUmuNTm_Hi5AjBajLg_1772567312
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8ca3ef536ddso835031585a.0
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 11:48:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772567312; x=1773172112; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Mah6Rptv9qO9EnrZrVhLS3/tVZQsJm7csPd9ev3L8Ic=;
        b=i87qjKTXZA+MQKTBUvuCIwRoggtsemVcEpud4K8QOnA9Y2PXuiv8YA2mKrTH42OiQX
         XvSb9/Bj/JK1zHgOS9Cj44kXZQdEjABubJbORLuNlKsopqwwPXX80M82/ALWyr7yvswc
         usBXdGSxAfqdGgGeK8QKvG5PjpGtneSqjqa7cupyKWYozgjE6mF5zCTDp9zlxNupkhpV
         o9k3XRo4CX56dFWli+IeUMAQM2b3b24kNcQJEw2JKdowOEeO8p0j7Y0HpP85MFhM3b9F
         akcX7XTVJs/LJfxUhbunqdhwQRZXAl6ATNWRJYk05532zbRNe7H7fnGLjJXuunQ2uUy7
         KOfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772567312; x=1773172112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mah6Rptv9qO9EnrZrVhLS3/tVZQsJm7csPd9ev3L8Ic=;
        b=ggwM6StRxav3MsGoMhNOOe6e5BedmsAvBj0GjllfD2K/tFgQWqQy0o5ItUliPkoxxq
         kFgSrtvV9DfVP9hGWPk68t9uKyAoq/jrgwj++3qTX9baAEm//Ywvdyri/q5aRVSiQZgd
         2nwM5SxJwLUDCqb+FAZ7iXvsr4RNGGW2XSygBIMg4IwF8eODwLYgdjkhtKnoY6HR8ggC
         YH7R44upL6kz02ei95vA8+H/m99xblVBpi8ADfHBV8H5fKd3HZavprXPY2/NWdYvvl8Z
         f/XO/Lo1GfGm3ECM19EjKkg+LRGkPz0FgYtahO1Dwc8/NgXiHkmEDELhqIjfE003nxQq
         CxyQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYllJ9qoYUJD/lhI87mpuKQQKrI6bFNnZ26X/2jfldLBdsIijdjRV6YI7oA/NHnqMLFe8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyR65qt8kNclqtsPa2hXSj3lJsmp4PUYuVagnpo2FFpKp2RnOiN
	wrke97Ia7jXch07zm2j18xLwZDUrvkWEdUwMgfmdOMkQOwJ3xdQooK5xk76FOW5aZt81u2dx9mW
	jwYWgW0RYalUqbQt1ESLfrU2RIxDvnBGgJIJ6q4BjSUrBsfYUxoYNWg==
X-Gm-Gg: ATEYQzxusF6/erb84F+8Q0y6zZSe94Is6mBjVgcoG0KNjZtGC+OoDWwv44AkkLOfCAJ
	2JJ8RhMSE6ND2HbCWaGPpDEhO3yw6q37tctECJ75DiXO3eid81jK5xF1/JPoBc3srXucDNCcV31
	EM81Id65U39eFqJpLjGLjnQYjVo7G1ibTvW/vHO1QU7z/oMBRuAT06Vs5XNsECwk1VJwjjz9ifP
	ylXp8Ro3BCmDuG1zsHLmIHAqBFMoE9j+5bw06jN5E/jOFzKryI7ecFPiVKQJQeye8k+ixdkcYel
	3t2IZqGlCErD3jiRNF+iEj/59z15u7V3F/vwDOj3w6zVImOHp3suub1njV49fE35S+cChRv8WBC
	7+S/PEPHQTwonNg==
X-Received: by 2002:a05:620a:1a22:b0:8c7:c25:9e69 with SMTP id af79cd13be357-8cbc8e2e9efmr2045286285a.66.1772567311964;
        Tue, 03 Mar 2026 11:48:31 -0800 (PST)
X-Received: by 2002:a05:620a:1a22:b0:8c7:c25:9e69 with SMTP id af79cd13be357-8cbc8e2e9efmr2045282785a.66.1772567311362;
        Tue, 03 Mar 2026 11:48:31 -0800 (PST)
Received: from x1.local ([174.91.117.149])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a0485ca0asm38444196d6.11.2026.03.03.11.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 11:48:31 -0800 (PST)
Date: Tue, 3 Mar 2026 14:48:19 -0500
From: Peter Xu <peterx@redhat.com>
To: marcandre.lureau@redhat.com
Cc: qemu-devel@nongnu.org, Ben Chaney <bchaney@akamai.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	=?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Fabiano Rosas <farosas@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org, Mark Kanda <mark.kanda@oracle.com>
Subject: Re: [PATCH v3 08/15] system/memory: constify section arguments
Message-ID: <aac7A4XbqFNmYzCT@x1.local>
References: <20260226140001.3622334-1-marcandre.lureau@redhat.com>
 <20260226140001.3622334-9-marcandre.lureau@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260226140001.3622334-9-marcandre.lureau@redhat.com>
X-Rspamd-Queue-Id: DC03C1F65DD
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72596-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterx@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,x1.local:mid]
X-Rspamd-Action: no action

On Thu, Feb 26, 2026 at 02:59:53PM +0100, marcandre.lureau@redhat.com wrote:
> From: Marc-André Lureau <marcandre.lureau@redhat.com>
> 
> The sections shouldn't be modified.
> 
> Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
> Reviewed-by: Cédric Le Goater <clg@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu


