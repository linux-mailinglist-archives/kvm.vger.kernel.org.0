Return-Path: <kvm+bounces-72555-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OAvAAU8gp2mYeQAAu9opvQ
	(envelope-from <kvm+bounces-72555-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 18:54:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 714E11F4D2C
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 18:54:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CA246305432A
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 17:54:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C03233A6EF8;
	Tue,  3 Mar 2026 17:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FuwaqiSX";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="jEfUGQvn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC0731A053
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 17:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772560455; cv=none; b=MuoCBWhCb494+lxarvh2R27xdwlB+pIvA7o7mG/AfSSVXdvbe0q+nCub+0gkrKZy5v4kAJpvGJAGD2BNTXYTN5znhk33NhlIrTmGuz7HhV2n5ZpLAwQ2UzNpudUjhhZ2lXrqbmbJNXzIVvmLVZwVow+sPQKDyeldtuZ4e+r8RK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772560455; c=relaxed/simple;
	bh=5vHpd8S1bBwojWOhM24H4CTXaJcsC21G0yOTJH8sttE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ANX3HlLANPnFTNrX927QA0VsH21Ouqq5Cxy7qFQBx4AflbbL+csSBbRnLaGcjV13q57TvMF/6F9q1iuoEicR23lSzh/epktw2obWTIqteKwh7wLG8k4iBmI3Vsa6ONj7dXDMf7TsW4uWlQn9hQz6Rm1roj5Km7HVKn4lp6bjbuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FuwaqiSX; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=jEfUGQvn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772560452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=doX5i5HJd9ZPEpXpfoeEyvmiiOWgmO4mFqxIxFFY0e8=;
	b=FuwaqiSXTuOlsaA7eY7aCSfGCwIuyidbhFw6wiLVQU4TlhK5K1qVoFjZuZiet0eia+GWAw
	8SH3DHOpExmi2d7Ash+E9RBiinWwrFFqgVG3YpaDlgKodUzwNbdY0zImAwYkZv4S+VTPrM
	PwCnrJDugJFIBEHyeFzmF/lnnwmYnb8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-142-bhwyMzmFMm-qZF9W-VywNA-1; Tue, 03 Mar 2026 12:54:11 -0500
X-MC-Unique: bhwyMzmFMm-qZF9W-VywNA-1
X-Mimecast-MFC-AGG-ID: bhwyMzmFMm-qZF9W-VywNA_1772560450
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-483101623e9so52864275e9.3
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 09:54:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772560450; x=1773165250; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=doX5i5HJd9ZPEpXpfoeEyvmiiOWgmO4mFqxIxFFY0e8=;
        b=jEfUGQvnbyyonKAEsFZpklscxQKbR3E/wvSHm0QQkyfZKQkJmyrs5i2pt+uFfF779r
         qn1EiOIcATq50CBcNJEiGcYBXZbT/qSKSf/bOWDvslyFQaWn9gYSvh5pbjzHGtGD/OIK
         pjkXJNonFRz5LXa+N78UZM3h3qRLKHMXVThFqFbdPSfFecqGDgHG6BFHlPiKevYZorRq
         QhpyFpofoxroSXtnGEggjV8MCsoXM49ks+HLmEWrGacKVWVZHBOhPzfmoMxEZPUd7L3l
         8FRjqrT8b9XvwohUKrcTaxOaRvnaS5dDDLY9eoE+fn60EDK/lY/rKlVcvKeET5NKZD8R
         hnLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772560450; x=1773165250;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=doX5i5HJd9ZPEpXpfoeEyvmiiOWgmO4mFqxIxFFY0e8=;
        b=lxPgLQps8tAbwMMeZzp/7tNrZ42cCObtQ7/XNJ2Kz5eyTquz85FBqtvbjF6P4M+VU1
         9CUaiVyHTI8W/0SbxKKvdftoLzJOVz9JNVfhEQgR+gII9cUyzFKh5jAwGi0aZXLUYlXL
         jl17PeGvBhToPzp65ayN/eOwZflJjqIKyysZgzTc2innf/eWLoMC4y/vjeMtCnHqdsWn
         CsFU14hQi7hiIm+IHD2A+wCnolVBzu4oBKGQ0TPro74EifUteBVVUKAWhCDH1HxdDdFd
         s54BU6m8/jpgC7IG+6S4y/GnKH/QnGOAK6wFyyO+FiODygaXbvDPwSe2XV6WvbWiCcnk
         +ckw==
X-Forwarded-Encrypted: i=1; AJvYcCXgVeLsC9fUeXQ3J3Sa5v7WUw2TGFZpzBs7v7XlEaXkdKsME2wPq8IBplK8rIA6XaYygKY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxA0o+2jEkEefWMkQTUTbbABb1aqF8DVLtwJ5ZJbwqgmNtwQAsM
	evtouKhWcRpNBYNmd6wtFC+IOIjDYWScZDziDaLBuyM/CtINGXnfD+mdGX0+avrL5Dn+cYrBRvj
	fwjW5g25QLWhqUj6nWRKBFHBah+qOSpN8XyEz44xCouJthoswP96oxQ==
X-Gm-Gg: ATEYQzxmhRvZtXBr1iqI8a88OFBHQMKEQn7AQ2+cHaXXC4TIecLjSU6CKm2sZptURAh
	UGqLodJb4MTaWgLymZvgTalcX1gd7TITrXxsD4E/hYKgiK8mgAy8aPHvlCOKTsod7vQUb9h40X+
	BRVv6PpRrgxCW+pyKO3VIGrm7k8JPdFOQlyiSwxBo4hrWMwHpwMY59uIDsZ891fb1E/YEAprM6q
	9nTNBnQ7AhxrBGckIgYhnv6Sz8SHQ5IB8w0wnmWJLwQ598csoWnPAP/RqFIuRJV1SYWL14r5E+R
	UGIwuhKLY8GXiqyCMzSHBxltGq5/uNTNvXHB43P64UbO0+vHMhuUJDLYbtEfGBDnwn/n5epO9oL
	/s4yptC7vEY+ryQeh4FAUNQm5CoXjdU9X0em0KoXEci3K90RjtJw2QqB28rnxbKuTpm+06q3MHt
	OL93PHu40+zXuqzANOvhH8Dii7duU=
X-Received: by 2002:a05:600c:3509:b0:480:f27c:6335 with SMTP id 5b1f17b1804b1-483c9c1a2b9mr251213205e9.25.1772560450226;
        Tue, 03 Mar 2026 09:54:10 -0800 (PST)
X-Received: by 2002:a05:600c:3509:b0:480:f27c:6335 with SMTP id 5b1f17b1804b1-483c9c1a2b9mr251212895e9.25.1772560449788;
        Tue, 03 Mar 2026 09:54:09 -0800 (PST)
Received: from [192.168.10.81] ([151.95.144.138])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-483bd68826asm797166665e9.0.2026.03.03.09.54.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2026 09:54:09 -0800 (PST)
Message-ID: <4a4bd216-3cdf-4098-8a59-a4cbceb31677@redhat.com>
Date: Tue, 3 Mar 2026 18:54:04 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/8] KVM: x86/mmu: bootstrap support for Intel MBEC
To: Jon Kohler <jon@nutanix.com>, seanjc@google.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>,
 "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Cc: ken@codelabs.ch, Alexander.Grest@microsoft.com, chao.gao@intel.com,
 madvenka@linux.microsoft.com, mic@digikod.net, nsaenz@amazon.es,
 tao1.su@linux.intel.com, xiaoyao.li@intel.com, zhao1.liu@intel.com
References: <20251223054806.1611168-1-jon@nutanix.com>
 <20251223054806.1611168-6-jon@nutanix.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
In-Reply-To: <20251223054806.1611168-6-jon@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 714E11F4D2C
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
	RCPT_COUNT_TWELVE(0.00)[21];
	TAGGED_FROM(0.00)[bounces-72555-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 12/23/25 06:47, Jon Kohler wrote:
> Extend kvm_mmu_page_role access bitfield from 3 to 4, where the 4th bit
> will be used to track user executable pages with Intel mode-based
> execute control (MBEC).
> 
> Extend SPTE generation and introduce shadow_ux value to account for
> user and kernel executable distinctions under MBEC.

While MBEC has a different definition of the bits, GMET is essentially 
SMEP (except that AMD couldn't retrofit it into hCR4.SMEP due to how NPT 
handles the U bit).  I wonder if it's possible to handle MBEC as SMEP as 
well, with some additional handling of the SPTEs (with shadox_x_mask and 
shadow_ux_mask taking the functionality of shadow_nx_mask and 
shadow_u_mask) but no large changes to the MMU.

This should be a much simpler patch set if it can be made to work.  I'll 
take a look.

Paolo


