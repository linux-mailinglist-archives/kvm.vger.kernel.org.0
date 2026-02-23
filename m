Return-Path: <kvm+bounces-71460-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QAXrH/cWnGkq/gMAu9opvQ
	(envelope-from <kvm+bounces-71460-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 09:59:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D0AA61735D3
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 09:59:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D24E5302262D
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 08:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AB0B34DB61;
	Mon, 23 Feb 2026 08:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AWDbWvHz";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="SMmwNACt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B13B34DB44
	for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 08:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771837087; cv=none; b=JZLhmRbvDT8/ZYFBeZqj/B8Vci9jmjDY67YNs9PhWxcjtH/XDdVTmoO4rqu4bB+Ag8pk+xMC1ZCn+FRiwc27rArUhQe60ABjvvbq/2c7LZDwrMaFoq2CnrNSHtkzTO9QopxGApo5tCZu6qABNwH6mvAvJs/ETPlslngmyQQZRG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771837087; c=relaxed/simple;
	bh=TJbxqHVs+e50jZZ4SLCFVeSNZh3JxXe/D2GgxbkHo4Q=;
	h=From:To:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=jhqwgChU57A8fY0dZ7xnJ1QXbGE0KHkPgINimEBzCkYx5/Ubq7jjmy0faQ0LMTkl5LHh6mSyVOHAskRM98LWCKcO7NWYvvF4qCXedFN1Yd6mSMMdjJA0JIlIEEYBeL7NcdDWKaGmCTIpsDpTNqhwQuHS1Tk9SMSXZDkSWEf0Q9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AWDbWvHz; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=SMmwNACt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771837085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3cWctW69aIH0GXOOoxbqXQgAV5r2o6fzbkGEycK6FGA=;
	b=AWDbWvHzK4wC7tdMyOraD6+wGU8EGpha/lRldfTSOMlxjL0BEngwLD+sMyvFBGjPOE5fYf
	YFC/LDl4q1hkrRaKCTm6K5aauYQFknuni9omP038JCSEkvLpOmm8Ne42EJtBm9X7o8NUgU
	aImfygN8TyUMdRjQQoM5aWx1cLQY0uM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-177-lOqVV6-MMve9-bXHxACMlQ-1; Mon, 23 Feb 2026 03:58:03 -0500
X-MC-Unique: lOqVV6-MMve9-bXHxACMlQ-1
X-Mimecast-MFC-AGG-ID: lOqVV6-MMve9-bXHxACMlQ_1771837082
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-435ab9ed85dso2527605f8f.1
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 00:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771837082; x=1772441882; darn=vger.kernel.org;
        h=mime-version:message-id:date:references:in-reply-to:subject:to:from
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3cWctW69aIH0GXOOoxbqXQgAV5r2o6fzbkGEycK6FGA=;
        b=SMmwNACtmRwOS81Q4nfzu0Xh7eTTUPBF5H1j0vXw9ea1X7auA64SylT2ySEo3TCtes
         CPI71hd33HCQHgX2/D+Krb/i7ph7Ue0qRFd+XQCmWF3jkvQWHLm+CfPHwNOZQpN7wG1S
         RGEuDqfxGAmxHZKzONIYSLzTiIL0tg/OG8JSsQ3RiI6fG1aGqd0pg3zYB8X6PCuUqeo1
         amgzh3RE5XCEOvlW6zo8btjRa9eMyEZ93ORJnf4pUXi+S8k3B6iuHAmbUi5r5WvQ9bHf
         zCZY82UimowHArhsrKMGlVHB+WNQBf2Cx/ikQNO0srqIc+giBpk4BRZOIT6n+InDxbu7
         9qCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771837082; x=1772441882;
        h=mime-version:message-id:date:references:in-reply-to:subject:to:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3cWctW69aIH0GXOOoxbqXQgAV5r2o6fzbkGEycK6FGA=;
        b=p5T6WUpaxRo19Vkb720rx4oW2sWtrhSfYZk7dZXhXGQB0OzBTlvsPzvnDIQ7FDiCt+
         dX5eznD2huTB5noMHvrv5zd0go5VYW0kjxgmedFwlX3PtZt5TUVnZf+l430sIQUVR84C
         MQ08Kma/Amx5umJGKoJCs91Y/8xuip6MHHC2pP8ZrGVOr5r3y9u1/V1ienOY5yymJwq4
         ENCj972aeHtljPXKiei9QOd3IqDUR4EiHwomKsiWhuvqghhFdLcGYqn8ZVE7xrORjeKn
         ezwUVnrm4Ire+vgYt07VMnCi89wurS/nE14MBIJLs8tG7MCnBdyZ2Ed4vDaU6JRgHLY5
         BKQg==
X-Forwarded-Encrypted: i=1; AJvYcCXyoWGyXmYS5YiMmnh8HhrDrOeByY+dKKEgCHB6GIyu9b4TQJ1+7cwjY+p618cXI0fFPI4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLFSQIO/wx8qrjbY8I1mQf1X2rv4Tg1FTdefsOhD/Zz4p8JOsx
	bjuAn879qzBAkG4fNMP49GYYOfogDR+MFLpoFT7zWB6+gYCxcZa0kdxGSS66CSId9JFguv8jE8W
	HqGNHKqwdDzC5E83M5N+BU46S+YG1LGqbZkOwpSJ0LhlkiqXSjLjpxw==
X-Gm-Gg: ATEYQzykuFdI+puVX89A9Hmz+1iubXWtf5etWvLQPviPd3yaLAdVjUDvwmsiWsV9OBh
	jFxhT1xbFCCwVshuFZzsZqmjK0fDl+ZkwTj85NteXWzBq5ZTp319DCDQfqYLaI0xhM2/IOr3dWm
	RrTVzWFAoZ+Zpkf83wPVpkNtnG2wqrZtRMSZ4nG7enYIjhxu9KPI1Ey2+ZA+zyXc8FPR2koVsh1
	M+HW3EsHjiC1sWAPyJg+w0MlXycP0lWeJGs81wHPNCkw6hLmKANMj27Jk1NlJ11Xg4zvCMOabtZ
	k3E7uoROdeq9ReE98CNxUGEpmDYA8l4MBlbdZQwXRj0nwlVrSqJ2hGsTPHDOh6/pfGB8wzYAj6K
	r4q8wYMP+CxuPPTSIsQ==
X-Received: by 2002:adf:e346:0:b0:437:6efe:94c5 with SMTP id ffacd0b85a97d-4396f1564b2mr10433958f8f.2.1771837082311;
        Mon, 23 Feb 2026 00:58:02 -0800 (PST)
X-Received: by 2002:adf:e346:0:b0:437:6efe:94c5 with SMTP id ffacd0b85a97d-4396f1564b2mr10433921f8f.2.1771837081744;
        Mon, 23 Feb 2026 00:58:01 -0800 (PST)
Received: from fedora (g3.ign.cz. [91.219.240.17])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970d4c982sm18127947f8f.31.2026.02.23.00.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 00:58:01 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Manuel Andreas <manuel.andreas@tum.de>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/hyper-v: Validate entire GVA range for
 non-canonical addresses during PV TLB flush
In-Reply-To: <00a7a31b-573b-4d92-91f8-7d7e2f88ea48@tum.de>
References: <00a7a31b-573b-4d92-91f8-7d7e2f88ea48@tum.de>
Date: Mon, 23 Feb 2026 09:58:00 +0100
Message-ID: <87ms0zu99j.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71460-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[vkuznets@redhat.com,kvm@vger.kernel.org];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_COUNT_FIVE(0.00)[6];
	MISSING_XM_UA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,tum.de:email]
X-Rspamd-Queue-Id: D0AA61735D3
X-Rspamd-Action: no action

Manuel Andreas <manuel.andreas@tum.de> writes:

> In KVM guests with Hyper-V hypercalls enabled, the hypercalls
> HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST and HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX
> allow a guest to request invalidation of portions of a virtual TLB.
> For this, the hypercall parameter includes a list of GVAs that are supposed
> to be invalidated.
>
> Currently, only the base GVA is checked to be canonical. In reality,
> this check needs to be performed for the entire range of GVAs.
> This still enables guests running on Intel hardware to trigger a
> WARN_ONCE in the host (see prior commit below).
>
> This patch simply moves the check for non-canonical addresses to be
> performed for every single GVA of the supplied range. This should also
> be more in line with the Hyper-V specification, since, although
> unlikely, a range starting with an invalid GVA may still contain
> GVAs that are valid.
>
> Fixes: fa787ac07b3c ("KVM: x86/hyper-v: Skip non-canonical addresses during PV TLB flush")
> Signed-off-by: Manuel Andreas <manuel.andreas@tum.de>
> ---
>  arch/x86/kvm/hyperv.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index de92292eb1f5..f4f6accf1a33 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1981,16 +1981,17 @@ int kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
>  		if (entries[i] == KVM_HV_TLB_FLUSHALL_ENTRY)
>  			goto out_flush_all;
>  
> -		if (is_noncanonical_invlpg_address(entries[i], vcpu))
> -			continue;
> -
>  		/*
>  		 * Lower 12 bits of 'address' encode the number of additional
>  		 * pages to flush.
>  		 */
>  		gva = entries[i] & PAGE_MASK;
> -		for (j = 0; j < (entries[i] & ~PAGE_MASK) + 1; j++)
> +		for (j = 0; j < (entries[i] & ~PAGE_MASK) + 1; j++) {
> +			if (is_noncanonical_invlpg_address(gva + j * PAGE_SIZE, vcpu))
> +				continue;
> +
>  			kvm_x86_call(flush_tlb_gva)(vcpu, gva + j * PAGE_SIZE);
> +		}
>  
>  		++vcpu->stat.tlb_flush;
>  	}

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly


