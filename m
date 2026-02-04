Return-Path: <kvm+bounces-70186-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GHhhHWcng2kxigMAu9opvQ
	(envelope-from <kvm+bounces-70186-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 12:03:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E302DE4DF1
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 12:03:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A01D6300E143
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 11:02:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD3723E8C72;
	Wed,  4 Feb 2026 11:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GBtWPm7l";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="f9oRaPIR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99F03C1995
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 11:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770202975; cv=none; b=tz1aq4AW4HzKjwd8LkFGUkpXYSClrL9GtjTIgJ9Xzf2Gk6PhkHuv09DVgbtxm2zHBaaaAPKBl0eNouDVCjxZPnjyKdYIrHS1NyyFnfvyoLZzN94zStinVr6RodyMzSP4ERvlwtI/WhodijKGpuVGotLXM/2SgO5d3apD1XCdv+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770202975; c=relaxed/simple;
	bh=EC9uA8xH2SZ3Yv5pwgfirpjuVlG8eEzV9thDTZKTyu8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LvNfksEPpS/6LKzxd7/rpTEZ0eNJ0wEqGw4j/p//7XO8bUMrDJJkumISayCTccnbcD98+7v1iTjtCJRz8tiDyrUtln7P3ABM3GCSXZHIQHJxPzjbSaDj/FvH51TrTxACNP3JY+ktXBwy3+OELfcF2tBczGy0pBaHQfU+7XYy4UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GBtWPm7l; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=f9oRaPIR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770202973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qvcKAZkncLIc+v7K5p5BcoqgrEGB2Yh9ODnVajfUSl0=;
	b=GBtWPm7ljwxiUOGoTsImRvJD9ICH9izWvF16To0tu3iGG1fw5AVieY78ju9f+np6I3tHX7
	1oQqLjfjx7Rlj8BFgO6nwpytKY8sTXdwz5alSneKrsTILhFy64oS5n5qJZaiQwyzYMxZF8
	1sG8GsKflspzpgKIJd/4Xv/AWSUuIqw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-0gSQhiZeM7GyZ9XFlQqzvg-1; Wed, 04 Feb 2026 06:02:52 -0500
X-MC-Unique: 0gSQhiZeM7GyZ9XFlQqzvg-1
X-Mimecast-MFC-AGG-ID: 0gSQhiZeM7GyZ9XFlQqzvg_1770202971
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4806865a01bso4988985e9.0
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 03:02:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770202971; x=1770807771; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=qvcKAZkncLIc+v7K5p5BcoqgrEGB2Yh9ODnVajfUSl0=;
        b=f9oRaPIR/wqQhgbp36fTTjQ6eFxRfJ+ASA97RAlqCbCos3Y53eDS7lgWuF6loiYolp
         ZaAlXplsXeJ+sQHgo17K9yPxyy4e8vcaOU+W0aUxG/QJZgwGr0hPeBdLq4QXdxa4hO8f
         CejtudB5ryh+QvXHC0gpT4mGVr5Lnuy0P7qrUdAb7oHZP2MTgWdWc3A5rusuycw7vN9i
         B2F62bH8GKt6KmMqB9qEBU1RnNdoE46elgTcO2IS+cfJbZ7Iwr/r0/F2Oy6GUrkHLKOl
         gt+tMglEMkMu1dPmTBs6XpxEBKZI6V7pPEiHxKcFmzMsG91+aC+uixGMu7jb6xyG7P63
         91Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770202971; x=1770807771;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qvcKAZkncLIc+v7K5p5BcoqgrEGB2Yh9ODnVajfUSl0=;
        b=ibJZ3inkPqHsuOGJ4Sx5P2sFFeH2/5vkd4tAj5M7r4v6MaXOx6eS1UwnGIS8kc0ZRz
         5hbAHeq6v11r0u59FiSL/f7RrCyZbYKLfWkevftz7yLop1hBOvE3WLHmI9L2qbx+un7s
         1b5KCtFT+/qqlb+jF/El9mEonnvX4IHZ8doRy/qrCanSO0sFLfTTmKAAeS1kMU6Ok0O4
         i1Zl/XTX+8c4Ekn1mdCRMT5pkR7RYkHrji8JxSp6jHb3i/LLo3g4cijZaiEl+v8NLcEq
         +LhgKLSecpuy7uMGPS1Xa/ES3tmqKA1H9j1VYTOIjSE6TAW/acOUss0ofWIh3GtRl8uy
         Xy/A==
X-Gm-Message-State: AOJu0YwnmpOqloVE/sxCJAwC2LlSga3jUIIwULOuAoQSMuK0d1H/JGmu
	05sSbEdD7vYd610/N4fyf5/Fk1+tOah8R5MhiWfih8aT6nLT5uavfx354RoEZgoEtqJQcKJcLB6
	IIkZtrxdIGMXGm1kTXBs0AUC0VAdRvOVJFe4udzLUp1d2b+PFzfgWcg==
X-Gm-Gg: AZuq6aL/QF3AlfP5CRIU9IJfTUFsgBmjtb23eGx9nWn/Z2SH+vmlidhXf5uBfhVOSrJ
	lbvjaE674HOo/rQ3yO7iKSgd6afk4oeQ4E2c5ycLNw5AcWhmDKuWpHEJrNCo6hzT3upm5KvkWBB
	rvDFsHUIkyi9psydfPwP83k/sD3uxfUU7pGPi7Tc5JznTFx10hfFeIf0dWKfCAFC6Ror8/xsxIP
	wk+HJuZeshnto2FX0ILAmfnRqjmk9dH5ZDqVA+m5VWzcucDYiCfRXYaN7Uuj1kCit7Xpk0imR5w
	5siGC0Ihg3HS4nyelqRg6KPcIPYKa44ymbrmA3hY/ielPI5aIVJw9A9QOV4qtnrbaLuLaQbudCQ
	32DCAAml8dAhwArLehhxxfjwSxa3K7Wpxy5wfpHHLDkezMKFQ
X-Received: by 2002:a05:600c:3496:b0:480:49ce:42cc with SMTP id 5b1f17b1804b1-4830e93124emr36587365e9.9.1770202971388;
        Wed, 04 Feb 2026 03:02:51 -0800 (PST)
X-Received: by 2002:a05:600c:3496:b0:480:49ce:42cc with SMTP id 5b1f17b1804b1-4830e93124emr36586895e9.9.1770202970909;
        Wed, 04 Feb 2026 03:02:50 -0800 (PST)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483109278adsm35298505e9.13.2026.02.04.03.02.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Feb 2026 03:02:50 -0800 (PST)
Message-ID: <56522478-b1a5-4f2a-a5f4-a45f6f2e153e@redhat.com>
Date: Wed, 4 Feb 2026 12:02:49 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/10] system/memory: constify section arguments
To: marcandre.lureau@redhat.com, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, Alex Williamson <alex@shazbot.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Ben Chaney <bchaney@akamai.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, David Hildenbrand <david@kernel.org>,
 Fabiano Rosas <farosas@suse.de>, Peter Xu <peterx@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Mark Kanda <mark.kanda@oracle.com>
References: <20260204100708.724800-1-marcandre.lureau@redhat.com>
 <20260204100708.724800-9-marcandre.lureau@redhat.com>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <20260204100708.724800-9-marcandre.lureau@redhat.com>
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
	TAGGED_FROM(0.00)[bounces-70186-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: E302DE4DF1
X-Rspamd-Action: no action

On 2/4/26 11:07, marcandre.lureau@redhat.com wrote:
> From: Marc-André Lureau <marcandre.lureau@redhat.com>
> 
> The sections shouldn't be modified.
> 
> Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
> ---
>   include/hw/vfio/vfio-container.h     |  2 +-
>   include/hw/vfio/vfio-cpr.h           |  2 +-
>   include/system/ram-discard-manager.h | 14 +++++++-------
>   hw/vfio/cpr-legacy.c                 |  4 ++--
>   hw/vfio/listener.c                   | 10 +++++-----
>   hw/virtio/virtio-mem.c               | 10 +++++-----
>   migration/ram.c                      |  6 +++---
>   system/memory_mapping.c              |  4 ++--
>   system/ram-block-attributes.c        |  8 ++++----
>   system/ram-discard-manager.c         | 10 +++++-----
>   10 files changed, 35 insertions(+), 35 deletions(-)


Reviewed-by: Cédric Le Goater <clg@redhat.com

Thanks,

C.


