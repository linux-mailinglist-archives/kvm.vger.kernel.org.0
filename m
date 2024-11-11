Return-Path: <kvm+bounces-31496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 485559C42AE
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 17:32:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 019B41F216C4
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 16:32:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 593531A257C;
	Mon, 11 Nov 2024 16:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="e1MTcKfQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636AC19C569
	for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 16:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731342752; cv=none; b=DZRQzcP1DE3V26jfL9f2vdjrEU+xZMlZbBnyKDcV0p4fgdVc212srHHqwMAt8M7jeHqch+azgTcNDVMf0XzLT+XKQ3WhDEwOo2ByW3Sn6N4S/KqhIMGEmguIInPg4iSP0YlZxYCBrI0x/tcl+SBElzRfGQtmRahke5A5dANEvUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731342752; c=relaxed/simple;
	bh=wgPgZjiap0AW6XOsWOQNirQ5MtbEYQMVp/D2VL6PP6c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eJpl2EyKISKsZ+jG3y01QBJeohFn8+p+M7XBZZcUOhk2hmUlxziN2nY4IpS2mRSGDtAoKstZ5vFgtuteH6mZcDecpTo+jmFPBvrrrTiOck+Gi28ksFU1jjRUN9fYFZmL3CzUYAyHo9eawooPQt/uDBr5RTLOQRUkTOFxz4S/nZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=e1MTcKfQ; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-539f58c68c5so7954287e87.3
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 08:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731342747; x=1731947547; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iBYAHP+O3hcuMK9k5NB3Be02x+OSCZv3yyXgIhdeSc8=;
        b=e1MTcKfQTQf468hzFbDI6QiHOUUE4NzS6GrID85/QBXoI8Ij6Fel/vBTP0JpLCQF8f
         Or5wnJtwsoOeeG8TcNkfkvqioErf7oqHKi4vllakhfgTk1PxH7pAxvUIoLIroIdQ/kOm
         7h+lAK2PECJ7cb3VcGaVlOC3KRoMwcnxtob55cfND9aeDtwc38DVNnF7NFX2FnwGJzYj
         upenOGdhPKl717wiWFxPoNct6MFfZAM9S9pKFWT6KwYKH7awzZwXXSoTtp4oMVtRfy38
         UeqBWVc9qVmU7H1fyRCp51JkvROTyw0GlDRAbP8C/MZmgs7vcrQ2HM25RD6DDaUX6QwI
         /+mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731342747; x=1731947547;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iBYAHP+O3hcuMK9k5NB3Be02x+OSCZv3yyXgIhdeSc8=;
        b=CZIp+eLeZGPacKBt30XRqjYXcJZAzREWSQrEAuLno3KrCwDMTszLJZ3nR/BU6q/cIA
         uq5jLtVF9CcAHmJTXMAUqE9Rddhbaiq+Ly9X0xkvV5sGaHH5y0aawX78rUPhGzYU+MDT
         B2V+n195Jke9aL7UIEv9+VOqMtCJJn/7JOCWiD6vDjGNrtkwMQjZyaVkMldLFQfPCzpU
         St36lacoQIy+CEbnDvThoRc23pHSL15n3P4/Jexw26CxlO/BvmGBDHYf9+1C+T4pqcNY
         otWza2WZ00gRZSXMvJpAHXS+4J0zSIOKxAdodRUrmeBECiZZYjMrhHglsBWuKati7ExI
         qi7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUGWOvxot05hNAlTphawS1hSdA9FRoICnM+z9Uny78K0L2J0Ya9jgX/VUI4DXizaZCsb7w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy70QX1rbDp+wSrvSTTFi+kweLIrTfzRbJ3MZGeFwUqly3MGrLn
	q3iPHVPtFu6tx1sWzrdR2x04ItNAvwxajQ0FLnRh9phZ/m08zPK0W4aHO4egpOI=
X-Google-Smtp-Source: AGHT+IHN23iRQMnByCFkyICQ+iUaWQ+aYPKOc6IcG+d6Jg86X+n2ilMatHSTOVuqudNP3Pp83tQmsQ==
X-Received: by 2002:a05:6512:1594:b0:539:8f68:e036 with SMTP id 2adb3069b0e04-53d862cd727mr8436995e87.34.1731342747469;
        Mon, 11 Nov 2024 08:32:27 -0800 (PST)
Received: from [192.168.0.20] (nborisov.ddns.nbis.net. [85.187.217.62])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee0a48585sm607966066b.45.2024.11.11.08.32.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2024 08:32:27 -0800 (PST)
Message-ID: <46f58028-9787-4363-96b9-e9b2b3122396@suse.com>
Date: Mon, 11 Nov 2024 18:32:25 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 07/10] x86/virt/tdx: Trim away tail null CMRs
To: Kai Huang <kai.huang@intel.com>, dave.hansen@intel.com,
 kirill.shutemov@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
 peterz@infradead.org, mingo@redhat.com, hpa@zytor.com,
 dan.j.williams@intel.com, seanjc@google.com, pbonzini@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, isaku.yamahata@intel.com, adrian.hunter@intel.com
References: <cover.1731318868.git.kai.huang@intel.com>
 <fba5b229f4e0a80aa8bb1001c1aa27fddec5f172.1731318868.git.kai.huang@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <fba5b229f4e0a80aa8bb1001c1aa27fddec5f172.1731318868.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11.11.24 г. 12:39 ч., Kai Huang wrote:
> TDX architecturally supports up to 32 CMRs.  The global metadata field
> "NUM_CMRS" reports the number of CMR entries that can be read by the
> kernel.  However, that field may just report the maximum number of CMRs
> albeit the actual number of CMRs is smaller, in which case there are
> tail null CMRs (size is 0).

nit: Is it safe to assume that null CMRs are going to be sequential and 
always at the end? Nothing in the TDX module spec suggests this. I.e 
can't we have :


1. Valid CMR region
2. ZERO CMR
3. Valid CMR

Sure, it might be a dummy and pointless but nothing prevents such CMR 
records. In any case I think the mentioning of "tail" is a bit too much 
detail and adds to unnecessary mental overload. Simply say you trim 
empty CMR's and that such regions will be sequential (if that's the 
case) and be done with it.

Because having "tail null cmr" can be interpreted as also having  there 
might be "non-tail null CMR", which doesn't seem to be the case?

> 
> Trim away those null CMRs, and print valid CMRs since they are useful
> at least to developers.
> 
> More information about CMR can be found at "Intel TDX ISA Background:
> Convertible Memory Ranges (CMRs)" in TDX 1.5 base spec [1], and
> "CMR_INFO" in TDX 1.5 ABI spec [2].
> 
> Now get_tdx_sys_info() just reads kernel-needed global metadata to
> kernel structure, and it is auto-generated.  Add a wrapper function
> init_tdx_sys_info() to invoke get_tdx_sys_info() and provide room to do
> additional things like dealing with CMRs.
> 
> Link: https://cdrdv2.intel.com/v1/dl/getContent/733575 [1]
> Link: https://cdrdv2.intel.com/v1/dl/getContent/733579 [2]
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>


