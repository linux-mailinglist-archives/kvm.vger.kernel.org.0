Return-Path: <kvm+bounces-52257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D28DCB033FF
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 02:56:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2765516629C
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 00:56:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F9DD1891A9;
	Mon, 14 Jul 2025 00:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bLiXd8+L"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6A211CBA
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 00:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752454605; cv=none; b=psW27lc0Vc0JysllYnDGCFen+iuKJBwH9jkrmMxDi0YlvH6wFbHw8n1FNCWL1Wj/5gdZyzAnp5tQQ/GeGpRuOovkzFr5KqHfgextKMHk6L+LLDV4n+8aPdwu8+VPm9Sh2i1eiigl+OJDJ41OpkUtDvCZqhRmZ6wq0frga/AXvcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752454605; c=relaxed/simple;
	bh=Aj2wrqzNkDFUp0Qlcm9ZHkXFqT0KNjoQwLntUrA8h4w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=seE/SFm0x/ClXmWQF+yacnpaqOPFLy0NyEAZ35sfGsgZloVYMufD1dWnATh0OcfeqypnUoA+l4CDZJNboMEogvW+aOoCrqiRKc3ObOnChXUhtaD1HkXNeT4zniqHAQz+ldODGSp+BlgvFnmBXJyOq59KFrLjsmqg84d/ZGgVuno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bLiXd8+L; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752454602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qUmVGWmiQ9qj6UDI8yyGeFapyi86on9NnjOakrMOqpk=;
	b=bLiXd8+LtLU0OzbdzO/ANH6EO6G5V8QjtSjGPcap0esMuzMg0g5aNpliz5T3ZRs4gRbk3S
	WRgDZx4///LPkIRUyiKbSBV95tKjNStKsV9KeUJPBUoUn6xyEa7xHjlVbRFp8bG6PUGdF4
	eMLrrEVf3VZpy9svJSrWy0/Rgiar+7s=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687--a37NWxFNKm5RD2nB5tryg-1; Sun, 13 Jul 2025 20:56:41 -0400
X-MC-Unique: -a37NWxFNKm5RD2nB5tryg-1
X-Mimecast-MFC-AGG-ID: -a37NWxFNKm5RD2nB5tryg_1752454600
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-b391a561225so2931408a12.1
        for <kvm@vger.kernel.org>; Sun, 13 Jul 2025 17:56:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752454600; x=1753059400;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qUmVGWmiQ9qj6UDI8yyGeFapyi86on9NnjOakrMOqpk=;
        b=Gjz3OCRs+VqTqCf7cHQJv0rYu7jREm7dAKU8fRbq2efnFk8uxMTWiIMyGTJQTW6WSI
         D/mniiX/uX9dMqTc2hBNPOtZvxdHKgmhXraR2zF4sNkjdKY3Iv24hjN32QB924x3tVV3
         yMjx53lLDeHLdgrpRC7ZD9GYgSosOgaRyYaYU4WliYPmM/4ZHWZH1Z2FhRo2+GFhkYHn
         d9xn7UgU43XDixX6+nvulwrzKJ4FEwkGMjdvaqYyfs5mstQvMUyhefeWGgAEQE+7sPYV
         DssiXm80RVkns/Va1gs0wwV83/NrQfTTlTxypECPc18LVuVqvnvfvLheQ8aGKSrDt2My
         kXfw==
X-Forwarded-Encrypted: i=1; AJvYcCWkpZFhYRTnV9mZxT5xtz3AuJn90l8m4+zQlTRaltuapzPKl6txCx/wBLioxmCmHRsSIjo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBg7N2ajY96X9pkEeBhOGqnSJ9w3+v7/cxvZY1jlo9x7mSGtYG
	+tP5pOWLs29v/XxopEfgVdMJuN+Lw0Lxk6l5VWpEtlTe2IWQX/gkOaKWK58OKkSXHP16hOY4Y+F
	zToXmxpi69J7I9B/wEaY2Ywszj83C/qr1IkQApxFGPV1fS0tNYc0jhg==
X-Gm-Gg: ASbGncvRB3kEEFJ6enKJo6iQ5Gs0s2bT8tvAjLiZ014/akNHejlWSCjEoBbWIaNWztY
	ZRjeXQW7atAQsPFoXZX1IkU9gwSWxgWpVUosbIXYz3VTHlUsAJvy2F5j/nSb10nSru2vOZbvH4X
	OLphyOWHs1oLiv9TBXyv6ig5ov4cdj/sKypqUauo0E5nHEOtHgVL7/hejBkmDc9k6ofE6be/A8z
	Bzd2xmu3t+FTS7/GVcpj4FNd8stN93ytdN//nc0VqyFkxHegIVhPmHOqGmuxPYkhqzUUq05MhTn
	DeAfcZaxrVZFuYlnA7JOJfHqwxwy5viFBbj6EB0jQZq66gMv946dkb8NwjwoHKM6VlbISk53YZA
	VxWs=
X-Received: by 2002:a05:6a20:a108:b0:1f5:95a7:8159 with SMTP id adf61e73a8af0-2313504eae8mr16343998637.10.1752454599971;
        Sun, 13 Jul 2025 17:56:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEuM+Zi92A0hbUgn10WrjgmwNif+FKdGvokkBLHmwp/rW6/7cd0fjnuie824/YWyiFVdE8dUA==
X-Received: by 2002:a05:6a20:a108:b0:1f5:95a7:8159 with SMTP id adf61e73a8af0-2313504eae8mr16343960637.10.1752454599481;
        Sun, 13 Jul 2025 17:56:39 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b3bbe727e33sm9168382a12.68.2025.07.13.17.56.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Jul 2025 17:56:38 -0700 (PDT)
Message-ID: <05605650-2dd2-4abf-b0a5-f727753db7f5@redhat.com>
Date: Mon, 14 Jul 2025 10:56:28 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 (RESEND) 00/20] Change ghes to use HEST-based offsets
 and add support for error inject
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
 Igor Mammedov <imammedo@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Shiju Jose <shiju.jose@huawei.com>, qemu-arm@nongnu.org,
 qemu-devel@nongnu.org, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Ani Sinha <anisinha@redhat.com>,
 Dongjiu Geng <gengdongjiu1@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>,
 Shannon Zhao <shannon.zhaosl@gmail.com>, Yanan Wang
 <wangyanan55@huawei.com>, Zhao Liu <zhao1.liu@intel.com>,
 kvm@vger.kernel.org, Cleber Rosa <crosa@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>, Eric Blake <eblake@redhat.com>,
 John Snow <jsnow@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Markus Armbruster <armbru@redhat.com>, Michael Roth <michael.roth@amd.com>,
 linux-kernel@vger.kernel.org
References: <cover.1749741085.git.mchehab+huawei@kernel.org>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <cover.1749741085.git.mchehab+huawei@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Mauro,

On 6/13/25 1:17 AM, Mauro Carvalho Chehab wrote:
> Hi Michael,
> 
> This is v10 of the patch series, rebased to apply after release
> 10.0. The only difference against v9 is a minor confict resolution.
> 
> I sent already the patch with conflicts, but, as you didn't pick,
> I'm assuming you're opting to see the entire series again, as it
> could make easier for you to use b4 or some other script you may
> use to pick patches. So, let me resend the entire series.
> 
> It is nearly identical to v9 which addressed 3 issues:
> 
> - backward compatibility logic moved to version 10.0;
> - fixed a compilation issue with target/arm/kvm.c (probably
>    caused by some rebase - funny enough, incremental
>    compilation was fine here);
> - added two missing SPDX comments.
> 
> As ghes_record_cper_errors() was written since the beginning
> to be public and used by ghes-cper.c. It ended being meged
> earlier because the error-injection series become too big,
> so it was decided last year to split in two to make easier for
> reviewers and maintainers to discuss.
> 
> This series change the way HEST table offsets are calculated,
> making them identical to what an OSPM would do and allowing
> multiple HEST entries without causing migration issues. It open
> space to add HEST support for non-arm architectures, as now
> the number and type of HEST notification entries are not
> hardcoded at ghes.c. Instead, they're passed as a parameter
> from the arch-dependent init code.
> 
> With such issue addressed, it adds a new notification type and
> add support to inject errors via a Python script. The script
> itself is at the final patch.
> 
> ---
> 
> v10:
> - rebased on the top of current upstream:
>    d9ce74873a6a ("Merge tag 'pull-vfio-20250611' of https://github.com/legoater/qemu into staging")
> - solved a minor conflict
> 

[...]

Just head up to check if this series has been merged? I don't see those patches
show up in the latest upstream QEMU yet. The reason why I'm asking is the subsequent
fix [1], which depends on this series.

[1] https://lists.nongnu.org/archive/html/qemu-devel/2025-05/msg06433.html

Thanks,
Gavin



