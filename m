Return-Path: <kvm+bounces-64485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 75466C847AD
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 11:28:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 2014A3446C2
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 10:28:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3761F2FF670;
	Tue, 25 Nov 2025 10:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Dlz0Zb7h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0292DCC1B
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 10:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764066502; cv=none; b=V/ptMlrKOWWVUTew4P/fM80N6L/iMUCAWrFfVqEZNavU0vdvm0MJP6BQr0x826O2pkmyr0q2qtFu3bD9PjPg/E0meBok+4A+BIn74wUP6Z3AOjcUu3GqCaO5hzV+vjswqM89xV3LITQ/jDFUs9vTGDEt8ctu+bTAqwNBKmL03hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764066502; c=relaxed/simple;
	bh=HcFjcPMY98bAOJWb+c1/Oog7o6EtcbgEewQuZbzmhA4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lmfAEpgCqy7jaNPQ9Rule+3RSiAls7wHkjynNnHMWPmALzDqL6NCk9IWd8EQ1TDarB0ieGLrBlr/jG5tZbH+S89RgzXW4WD/E+8YhITFeLTYVbXC4tSoFs1j1PopSO8iImkWGf4H6GuMEIGtpFY2IFfBxE+VQHn5ymC6GIyMqQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Dlz0Zb7h; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-64088c6b309so8721917a12.0
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 02:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764066499; x=1764671299; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wp5/syD0+o/LyjTyIR4uS8V1NpnQlWuYtR2o807A2NY=;
        b=Dlz0Zb7heh4ZB8ciCQvtssMyOHqqGJovoLiCyNrnZIx6eecvV2o7E/V7PAagKLOznT
         qMSuWYId32aMLEqjFe1ubD7GLwyhJRMf+QmuKBEZkZm5h2OR4TZnxzBj30z+8/7/8tig
         NE/i/jgUytu2YnGY3PoY9YMen4Pi+fyyq3huk/hNHKKaCQChi4s24PCtT+pwmA/r3bQV
         II4OSKVbeSTSZxJZ5LdtsI2zSiYqap+KxYHY34+J7onNeWDZlLDbmhjtNb1zAnGaGkFB
         MiK/ieqNz4MV4XZ/taLoSFMVAQuqCQ+ADrhY9Evy3TGEGEwirqUT5aBRVJywmDjMpwD/
         KDmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764066499; x=1764671299;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wp5/syD0+o/LyjTyIR4uS8V1NpnQlWuYtR2o807A2NY=;
        b=TUaonYwFDt2iZJCUFpCqwi3e4GJObqibyBR+IygQMhCFNiuK3aK4AXHDQugI1SA64F
         45s+k24qqyRgAi0pweaz9c5rZJuEOdJK+MUD20gxcyjsUXi2A1sEGEdyg/wTsbtj9j6G
         lCebrzRGfL3HoLrQD27sh7tmMKiPc1JccJ+q55CZPyQKDwuB9vZfWPZT3WVPEnnv+Uqg
         46azpTHLyVPsFm9G8ncbJc+QeMW1uXwZF6E6/acskJgyVT1bfXuxizOik0Dd+mJDo6GD
         hotyPL1XHH2I33z5GkN1VMYZsBo9ax4lkvO7/4WK6MKRFowv9RqFXsSvE3L9WKVlDgHM
         AiRg==
X-Forwarded-Encrypted: i=1; AJvYcCWrv+omuLWawRlxCLhH+q7IPzHWG0fqKNBMuBPfwZtVXYXQYhaeuNgbDU524yE35lTPdM4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyet6cuB+RW0e0nMlOeLclkzIjaBP0yK7fiM5VUnzl6xTQQuvYY
	p1K1PEtal/61qz8KmhUw3umbz1vhmmt+BW9DeRDCP9S7FDIUFT0Ubc86ixhy4uwUHFc=
X-Gm-Gg: ASbGncu00elsH9xq/Oj6Xrhx6tbHo5II+2LSO3Xq7ax6FSLQWfLQYJGOscextMb7zv9
	LnaIsKkVJ424ad/xG+GK26d5J4y0d3ExRlMtQgTdp1KYboaC+L7icd9wxcCNTIAhgodOFURgAYi
	mrfXBi/eCyuCVPeYClwUEpxJbobr9Hhs3RZiXBP7S7eYIb4zzRuBq+yS0BeW76R/UJ7AQEgiM7i
	A4bWXOGWUe9oMS7jOk1FGHkST3SNOarApFN3OFM7/CHBO7yy5NQLOg1SYPkMwbAeRn+vrWeqHZ9
	2N3IhYeta19YlwJ6A53Ibxj0ewQ98Sk8qkjqZpE/55aDVHV5GY6LLi7wEQjD0y5D29V4iuptqV0
	pQBhldMsGMnLx4fsv15O7ZQAOQ0/bEp6A6ak9x4dm2ZuKzdWEFb62amBZ0hGqw589BZxQpdRKiK
	Sg5SkZcpxctcLAyOOllpW0zrg3fF/aPuCXB+32+D4OjeDhFzROgrDLzw==
X-Google-Smtp-Source: AGHT+IE3PKjG7rNMmUMO0u0YPkOHg97YVfk6tokccVI/wtgGNpt9SgcH/ClnqkI9yxamQKVM5NvRXg==
X-Received: by 2002:a17:907:868f:b0:b72:5fac:d05a with SMTP id a640c23a62f3a-b7671a47ae8mr1360006666b.37.1764066498581;
        Tue, 25 Nov 2025 02:28:18 -0800 (PST)
Received: from [192.168.69.210] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7654fd43b1sm1532571066b.38.2025.11.25.02.28.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Nov 2025 02:28:17 -0800 (PST)
Message-ID: <a5388c93-124f-42ac-8881-3cae4bb620c6@linaro.org>
Date: Tue, 25 Nov 2025 11:28:14 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/15] error: Use error_setg_file_open() for simplicity
 and consistency
Content-Language: en-US
To: Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org
Cc: arei.gonglei@huawei.com, zhenwei.pi@linux.dev, alistair.francis@wdc.com,
 stefanb@linux.vnet.ibm.com, kwolf@redhat.com, hreitz@redhat.com,
 sw@weilnetz.de, qemu_oss@crudebyte.com, groug@kaod.org, mst@redhat.com,
 imammedo@redhat.com, anisinha@redhat.com, kraxel@redhat.com,
 shentey@gmail.com, npiggin@gmail.com, harshpb@linux.ibm.com,
 sstabellini@kernel.org, anthony@xenproject.org, paul@xen.org,
 edgar.iglesias@gmail.com, elena.ufimtseva@oracle.com, jag.raman@oracle.com,
 sgarzare@redhat.com, pbonzini@redhat.com, fam@euphon.net, alex@shazbot.org,
 clg@redhat.com, peterx@redhat.com, farosas@suse.de, lizhijian@fujitsu.com,
 dave@treblig.org, jasowang@redhat.com, samuel.thibault@ens-lyon.org,
 michael.roth@amd.com, kkostiuk@redhat.com, zhao1.liu@intel.com,
 mtosatti@redhat.com, rathc@linux.ibm.com, palmer@dabbelt.com,
 liwei1518@gmail.com, dbarboza@ventanamicro.com,
 zhiwei_liu@linux.alibaba.com, marcandre.lureau@redhat.com,
 qemu-block@nongnu.org, qemu-ppc@nongnu.org, xen-devel@lists.xenproject.org,
 kvm@vger.kernel.org, qemu-riscv@nongnu.org
References: <20251121121438.1249498-1-armbru@redhat.com>
 <20251121121438.1249498-11-armbru@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251121121438.1249498-11-armbru@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21/11/25 13:14, Markus Armbruster wrote:
> Replace
> 
>      error_setg_errno(errp, errno, MSG, FNAME);
> 
> by
> 
>      error_setg_file_open(errp, errno, FNAME);
> 
> where MSG is "Could not open '%s'" or similar.
> 
> Also replace equivalent uses of error_setg().
> 
> A few messages lose prefixes ("net dump: ", "SEV: ", __func__ ": ").
> We could put them back with error_prepend().  Not worth the bother.
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> Reviewed-by: Dr. David Alan Gilbert <dave@treblig.org>
> ---
>   hw/9pfs/9p-local.c        | 2 +-
>   hw/acpi/core.c            | 2 +-
>   hw/core/loader.c          | 2 +-
>   hw/pci-host/xen_igd_pt.c  | 2 +-
>   monitor/hmp-cmds-target.c | 2 +-
>   net/dump.c                | 2 +-
>   net/tap-bsd.c             | 6 +++---
>   net/tap-linux.c           | 2 +-
>   target/i386/sev.c         | 6 ++----
>   util/vfio-helpers.c       | 5 ++---
>   10 files changed, 14 insertions(+), 17 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


