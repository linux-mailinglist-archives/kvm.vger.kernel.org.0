Return-Path: <kvm+bounces-64469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C8CDC83762
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 07:25:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5F78C34C1C4
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 06:25:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E785E286425;
	Tue, 25 Nov 2025 06:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="peseMjg4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785581EB5E1
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 06:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764051912; cv=none; b=HfKyHo949ACVbZVGeoCYsumm1DfZ7iHjX7aF7Axk4bqDXoNjdUb3tiIi8oD5vz1dkYzWiMtpk4aCz/rlaGX43F0jK2hCPeMz5+aedrH4Sd94TMK2AZfZXISltWYMoa2NIBAxMSPpJBiQGFCPhkZlLJDFskb9X9V93VtIt9zVr3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764051912; c=relaxed/simple;
	bh=nGfYkhDlt1dLPRq6HnjmXbC/WgNXoq1Uy+kQUON+g9Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kFMjZTA1eHK2nzukVU1QSwaSSWUmOEYu4xkA7DvcYJx92+1ZK/a6ZmSXlap7L+oT+vKMocHJptcnHlXRh3709JSkg16zJruAM4MWeHcjf2Aksmql7rf+zf+m8hO/UbjTw6GfWLyT8CU22CEvsVEU3tIB1+RQUbOdQPzcSwaECqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=peseMjg4; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-477a1c28778so56101625e9.3
        for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 22:25:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764051909; x=1764656709; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kq1R/KnIl0tjtGNpVBFK4blvRpvREmYvjs4Wzx+ZU8A=;
        b=peseMjg490XsfowKCXEaQRwBhH6CpikRN4+TOIhMzfQ1EqFJVzQDPCgEgeh+rXB4ss
         8s6U2fbxAbVJABuYfPURKlXtanlVOiJbuAdodg2UfO/YJgPeskw4Qtz3YmRvkQu9+afE
         dOifwHmeZ/er8boJFVZ4N6DkGc7MyrxPZjSD8R5o3LG//JDTiFnpNZGmw3c36RNdPtxW
         BfcPko4qju4r3wORvkkO4ckPdf2ODBQLSbOHbls6zEZ+gl+jGAyjiMEjcYYm5wwNsw/k
         5TkCr0MCgLhxf5M8m5KUCLmqPhENiEJJax7Iy2qZnxGdHy9CP3MG1b3Rw7MnSH7xPBqm
         Z80g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764051909; x=1764656709;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kq1R/KnIl0tjtGNpVBFK4blvRpvREmYvjs4Wzx+ZU8A=;
        b=haL3n8buAFH1oG52Fv0P/eDqCqeGxOJOsqtlTVUpWPsgl6lqLFPGGQkdBSsuujKPMa
         /LFC2Sv4MjLoPasU4DDGbbGjA9vKcQdCTWeCquMgerLQM864wMFm/nThaMoLx919WPDo
         +1rkU1sIHrOMXx2RKiSxSnUxz4ejYmUsIX9k4HlU+PUVJLJ8Hj9Yn4lBqcp7p3/4neq/
         dY5Par817AKo6w0UtSUW8uNU1NngurYYam8rmMoYbiZ6nj+anPEOYkgpUbClBSBJfbBt
         TJ7eWEMXFPRt1Gs2azhirgHpO9EZRMgDiNOTlYwu5vLSHMhGTaAnDC3clttYeWG6xGEw
         ZYMg==
X-Forwarded-Encrypted: i=1; AJvYcCWy66UIeqKnuQDVmo3tXbnGVwLI4xt2a0ouUccHTFAbzO2HMyYSLGIGC4yCgD+Yjw4Y9lI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYB75PXjpx3nkNUvHyRVwWu4B8oc8zFLtjSeU3FuZp1s6rW8eK
	5sBwB6Rt1FbW0r3AdhxA6MU3eTqQlSN07MSjFetA9pVP0iUH4fBEGTncMDGMTytZFtU=
X-Gm-Gg: ASbGnctaBml+vOpQbJvhLBPu7612BVJum8b5TUFXYwE8mLzKPWXcDPmy71P8kDKLxxX
	xhnR7tjjQCApvUyQ9Gmvkat+Xl47tdOYhLD2qa64mfm9gRvPBIdEwsJxrhhhiHQoaDaZus7idGQ
	wnts9LU4ICXY10+GU3JkwzB15Gb5hbTJynT2LymAwka+D1jOhki6QLlWyY5EhAOIeikQz7vVW0R
	jOBINRRdJVRMOsHbE7lu0G24e+k4Y6TsXrzi8jIHSY4+8N+aqIngcmAwcOAZgts4RoJ0MLxKsX6
	6+enKF/4lXfo+/PpInz+p2l8eWIHVb1Wf7qkh8qDOj6kAOgJqkc7D8xKoeFL3MLhR9aclHasBxF
	uSdxE8q2fsooxiu35Un2X3moeaqxxCIZzjLG4v+QFMLW9ewHADRbY0dNfN61O+FEmc6pqDTv7tI
	/7PCjSEWyjoZXsJ85GMZYDX3DGZUC5vIpew7q8sJTgA5F/6yzEHn+VDw==
X-Google-Smtp-Source: AGHT+IFprm3vCDsbWVJfgbV9xKa8iHTCEmXL664XoxSCOsyM7eQ2uIrryW9dfBTvUiv91/I4gz9/gg==
X-Received: by 2002:a05:600c:4685:b0:477:5b0a:e616 with SMTP id 5b1f17b1804b1-47904acaf28mr11379725e9.5.1764051908756;
        Mon, 24 Nov 2025 22:25:08 -0800 (PST)
Received: from [192.168.69.210] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7f34ff3sm32968445f8f.16.2025.11.24.22.25.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Nov 2025 22:25:08 -0800 (PST)
Message-ID: <54be619f-1de6-47c6-993c-246fa6252596@linaro.org>
Date: Tue, 25 Nov 2025 07:25:05 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 15/15] block/file-win32: Improve an error message
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
 <20251121121438.1249498-16-armbru@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251121121438.1249498-16-armbru@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21/11/25 13:14, Markus Armbruster wrote:
> Two out of three calls of CreateFile() use error_setg_win32() to
> report errors.  The third uses error_setg_errno(), mapping
> ERROR_ACCESS_DENIED to EACCES, and everything else to EINVAL, throwing
> away detail.  Switch it to error_setg_win32().
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>   block/file-win32.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


