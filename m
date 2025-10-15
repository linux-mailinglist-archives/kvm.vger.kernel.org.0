Return-Path: <kvm+bounces-60073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 555E7BDEC48
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 15:31:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3945D3B02E6
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 13:31:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB1112236E9;
	Wed, 15 Oct 2025 13:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PGgoeU2l"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4548E1DB122
	for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 13:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760535087; cv=none; b=oa2/BpKIwBaWaZA6c8Kv56VWZQC/DoX960wzYiorJeTah/QOliJJFqTh4rX442LIJspBcpoOnMR6oeqNMVIfDws3qfNOQZ+lJjj/6w+aOc5FSLFbBIdr//K55MVfcIooJkKQ3OBclMNd1+69uzVMSoClXLn8BLDAx5tNnai9KvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760535087; c=relaxed/simple;
	bh=4MwBaGYDxeY3KaqvM06UxE6Oi41Lj8+hgnXgEvXTvuo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ol+YiV3aw6n139ByTWsCmA3q8Eigd7RuscEhY/MMMz9jRVcCv7/CdMZop8uFkrl2dOm91WrnZBSLv05ltjw8ZAjufn3En7fUa1y8y/jjX3GRD8/drtKlth9m5xNndYVKUhQPtv/YIalaWziNmRyixTRlKN5B6/JMuGcT9FDsmWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PGgoeU2l; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760535085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Qx/WLIkX3FuLLIRvr6wXXZfUggNICjgo22DnjBHxXpg=;
	b=PGgoeU2lpEVxDw5gRE4Xc44iOFpbFlKPGm2+rSqFecR/bUlNqprlLF7WKJBnlB3f1IVxG9
	3ZdjYvmYwQv1aCL2UB6mSCyuLSCif11akplQf7/eaIlAByiGkCaKCVkcPZicHUrOR535g7
	cVM0OEMtwV3iTk95PvY0C/t1Zp1ulfQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-YC_tfJdgMo6XH_Kev4Lw1g-1; Wed, 15 Oct 2025 09:31:23 -0400
X-MC-Unique: YC_tfJdgMo6XH_Kev4Lw1g-1
X-Mimecast-MFC-AGG-ID: YC_tfJdgMo6XH_Kev4Lw1g_1760535080
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-470fd49f185so6305995e9.2
        for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 06:31:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760535080; x=1761139880;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qx/WLIkX3FuLLIRvr6wXXZfUggNICjgo22DnjBHxXpg=;
        b=fWxiNOdeVcFTLTY9mnc+XsOPqW+sAoXCCmFoEiyw6IyZE0Kd3HvENHc3gil5m8Lajt
         0jr+Dp70QrDX3kQ3nB6feEdGZws/Og2hYyxxyWLghAR/5oil3kRQIVYNP8Ax5q82exm5
         GJnucqg52o7Xi3BYYZtdez/83XNHVKHLqWN3UmlAMpVcNtItLSMMXtGHBbLo3kXxI7Gd
         dD6H1AhblH2tDf2EFLSscxfygcrUEkS04m9hJfQ1V1WtqAuaqpkiNeuExmqvxZgLrR95
         QohrXd4eJDbh3R1BreAAblpvknAvVig65FzmKCgh3YrBszKO8ZkpHBMnJD8vnYZa41i/
         m35w==
X-Forwarded-Encrypted: i=1; AJvYcCWNsuFac/J/jo7VPKNt/xcpY6xHGtuxdwW24B+dtolPW3y6XKGkjMoFZiCk9nJMHKI6bRU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpXWBPmXFbO8oEmcdaTOZh6+o/bkPu9HMSvofY2VX3uDyLHhoe
	0TxszjOfuu8oATdCngdpIYa3AlKVpcXsV2iiBymwI8fdLL4KUgO6dyvZumON9+drbjhBd/U4pER
	xj18/PeadpxyZWRS4OuwmbPdMxjWWI+W/+VeKjzcu9s/48+h7VS8VAYMC9dDHTg==
X-Gm-Gg: ASbGncsPuPbqr6ZKkEmQCcxTi1ugS1kYf5p7fWhZUs1LeZiFpNEUlGN/Bx0Cwu1dT3X
	/NqGDEozBN4AlQj3frPVW5cigpaQeSB590r4TxHyM1/9hJwJdFMv/PfISirLApA31M41n8eVPdW
	5Lcr8lz2Xqer/fZvvYSg/rJlgaJ1ea4qsa8DxSb7f5ekKXv/Jri9Jl6OI/9YoyZjfz0QtQLprxS
	qYb5zvVIfM2XyhTB1fNOC0SxrMwQf/07iE5GGY1TfVHUk7ChyIes6A/ot9EcmX9SchO1+atv+wM
	3O+0dl363E5R7mLtiz/evbGGsvd1tnXpPMS6mvQu0d8Z1SaEaJrk+VKjht1PS9qCwSSKWLqN/Ux
	uewQqVYGaI3CN3KqO7RxfsmebkEgH4DDoMyYMiH9XCAo=
X-Received: by 2002:a05:600c:1f06:b0:46e:384f:bd86 with SMTP id 5b1f17b1804b1-46fa9a9443fmr180403395e9.5.1760535079973;
        Wed, 15 Oct 2025 06:31:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH+lnTVA9bwGzjwuoD5HESi6s46NjZLx8ClZtJP3TmDc/as04XcYPb2mz8vb4LsH6wKJD4ZoA==
X-Received: by 2002:a05:600c:1f06:b0:46e:384f:bd86 with SMTP id 5b1f17b1804b1-46fa9a9443fmr180402875e9.5.1760535079118;
        Wed, 15 Oct 2025 06:31:19 -0700 (PDT)
Received: from [192.168.10.48] ([151.61.22.175])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-47101c21805sm32779375e9.10.2025.10.15.06.31.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Oct 2025 06:31:18 -0700 (PDT)
Message-ID: <81af1654-5cb1-405a-bd42-670058dd22b6@redhat.com>
Date: Wed, 15 Oct 2025 15:31:13 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.18, take #1
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Jan Kotas <jank@cadence.com>,
 Joey Gouly <joey.gouly@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
 Naresh Kamboju <naresh.kamboju@linaro.org>,
 Oliver Upton <oliver.upton@linux.dev>,
 Osama Abdelkader <osama.abdelkader@gmail.com>,
 Sascha Bischoff <sascha.bischoff@arm.com>,
 Sean Christopherson <seanjc@google.com>, Sebastian Ott <sebott@redhat.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Zenghui Yu <zenghui.yu@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
References: <20251014122857.1250976-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20251014122857.1250976-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/14/25 14:28, Marc Zyngier wrote:
> Paolo,
> 
> As 6.18-rc1 is out, here's a collection of fixes that have accumulated
> over the past 3 weeks, addressing a pretty wide ranging set of issues.
> Nothing really jumps out, for once, and it's the usual mix of UAPI
> tidy-up, architecture fixups, and other random cleanups. Maybe a few
> more selftest updates than we usually do, but I'm sure this isn't
> going to last!
> 
> I'm already looking at some more fixes, so will probably be back next
> week with more presents...
> 
> You will notice that, just like I did with the main pull request, I'm
> adding message-ids to the tag instead of putting them into the
> individual patches. It looks rubbish, but I don't have a good
> alternative, and I'm not prepared to remove provenance information
> from the stuff I ferry upstream.
> 
> I'd welcome any guidance that would make things suck less for people
> reporting bugs and backporting stuff, despite the "Link: is bad"
> nonsense. Preferably something that we can adopt across architectures
> supporting KVM.
Because you're already unusually meticulous in tracking tags, I'm going 
to say whatever floats your boat.  If you want to add it to each patch, 
I'm certainly not going to be the one to complain, and/or to make your 
life harder, because of something like "Link".

Personally I think that there's a different between adding something 
mindlessly as a cargo cult, and adding it *unconditionally*.  Link is 
the latter, it's unconditional because it may be needed *later*.  In 
some cases it may not be strictly necessary (for example the tip bot 
used it to send replies, and that is served by notes just fine), but 
overall I don't get the hate either.

In fact, I'm very adamant about *needing* Link trailers for each patch 
in the RISC-V pull requests, which are the ones I look at most closely 
since the code is still in relative infancy.

Pulled, by the way. :)

Paolo


