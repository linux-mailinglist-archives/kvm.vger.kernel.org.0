Return-Path: <kvm+bounces-29854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 68D669B31B4
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 14:30:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1CF1D1F21E84
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 13:30:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8F4D1DC046;
	Mon, 28 Oct 2024 13:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LJ2vzMym"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB2A1DBB2C
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 13:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730122189; cv=none; b=Ancfiz64yT8f+tNcpa8iy9RJ5i028wzsJXxUuJPxpA8nq9djLEjLgrycyU0AvT00C1BLhyj3QX6hBnR/jzxNW5VroGW6ixSI+gO+n12HgtUUYwr2GN/hysU8fw5VoWJ9QYEiznJw88PprTyHL5a1zUFdupHr9Fv57tdHynApcno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730122189; c=relaxed/simple;
	bh=5oyGvkREqDeHRidY85A/FS5BqBuSvvzmECWkFjPbNjw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K7tetKwZtQlFhVrx6BEH+M6sNu7xRPVvVbn+e/NoW1vpOQrUgXrYx5wZNugVsWiqcRKR5wn96ucIhudFSHa0EXDaAQyHrDxDxynLoMIzOv/EEMJQWPEtn3adM3ycV7QNVL3M6QMS2OerfKv6CuhTvbZbeqaNcc8ZMDAUgYnpZwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LJ2vzMym; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-37d70df0b1aso3593793f8f.3
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 06:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730122186; x=1730726986; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w6EadJB8V7Y8cpv+mItipPaoLP4/d3PNTxf1GVBJWGY=;
        b=LJ2vzMymnOGEvza1h1Xs90HPi5qGhobtWJWYjsRe3r2pLdU/uxA1PbTZ15zA7uDcg0
         0Xk/z4fGCSiy6oij+LcAYPBf8gGgFBg5/JiLT44FTK4BduglJd0ZqNnq8RIldZ6i96ek
         XUVqRmg2ER/i20MM1bMBWVDG11vw3PjU6Ds4PiTt4RTrNljeXTAsm4Cjrdyp4WfnOzC0
         7LsgFkDtM7DB/gs3Xk8BznKq2FgbXWeOlfDxzIKCSnI2ZQ9IpVnPzcDaEIBK8aU2a4QR
         BDYAKpGqb39IhV+YbNbCHRqCdAmIApFTGYhsdHgt4sOUWZ56teoJ/aL24L6EYeD9BY3L
         ILzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730122186; x=1730726986;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w6EadJB8V7Y8cpv+mItipPaoLP4/d3PNTxf1GVBJWGY=;
        b=wLozQ4OS8/xxoy2DgAADjQBqcrdmjN8zas33WtqDuJqg07AT7NmCkEfSi6y6M0GlSw
         D5+72ko7XgqHYUXTwyCatTWZPfGnHEWEA5dIZuko02Qva7VekL41CJdIlHLRiNoK3wJY
         BpTGbw1noLydIVKtLQDYYFJJVuhjo3BaQGqOXkPpbD8hmoS+ejnrm9gsdfavtPbNC7GL
         +TmMM8Sc1RtpCUBXuK0mGXPlay8YVi0rIZhV2EnP4DinR7omXbiK06spKz+voH38ClMO
         xDr194+z+N9wXORrGsY6Q/sNkiNYkrHgX9gheIGMEW/PVKOM6JfIDaRQuyCWs/89bfIK
         DkUQ==
X-Forwarded-Encrypted: i=1; AJvYcCXc7tnCNX8x0Nh1gB5c1rYUEzFtmRHqIOHVQHLHN9wifEaUCvdvCJcE8Nhu2A5CpVX/kwU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRTkUPqX/0HK8TlWu7ibZ11WIzTSX44owu1giJ7abceAVqwxIZ
	/kfW8sF3hRoXIGvhBTzmHmdZNJcDXvrtVJwplXBbiHD+Eb6g/DrRTb7FMHnCX18=
X-Google-Smtp-Source: AGHT+IEtvTZNKEmWWIFoMubPfm0ya5C1jtARvcC1GXFVdulw5wHQLnMw/8We5rF0Uedjydxv72ay8A==
X-Received: by 2002:a5d:5f41:0:b0:37d:4f1b:35d with SMTP id ffacd0b85a97d-380611ff128mr6725541f8f.48.1730122185780;
        Mon, 28 Oct 2024 06:29:45 -0700 (PDT)
Received: from ?IPV6:2a10:bac0:b000:7465:7285:c2ff:fedd:7e3a? ([2a10:bac0:b000:7465:7285:c2ff:fedd:7e3a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38058bb4724sm9463052f8f.115.2024.10.28.06.29.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2024 06:29:45 -0700 (PDT)
Message-ID: <1fb9d072-67a3-4149-b5a3-0ea79f2b0733@suse.com>
Date: Mon, 28 Oct 2024 15:29:43 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 04/10] x86/virt/tdx: Use dedicated struct members for
 PAMT entry sizes
To: Kai Huang <kai.huang@intel.com>, dave.hansen@intel.com,
 kirill.shutemov@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
 peterz@infradead.org, mingo@redhat.com, hpa@zytor.com,
 dan.j.williams@intel.com, seanjc@google.com, pbonzini@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, isaku.yamahata@intel.com, adrian.hunter@intel.com
References: <cover.1730118186.git.kai.huang@intel.com>
 <e1f311a32a1721cb138982d475515e24f18e4edb.1730118186.git.kai.huang@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <e1f311a32a1721cb138982d475515e24f18e4edb.1730118186.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 28.10.24 г. 14:41 ч., Kai Huang wrote:
> Currently, the 'struct tdmr_sys_info_tdmr' which includes TDMR related
> fields defines the PAMT entry sizes for TDX supported page sizes (4KB,
> 2MB and 1GB) as an array:
> 
> 	struct tdx_sys_info_tdmr {
> 		...
> 		u16 pamt_entry_sizes[TDX_PS_NR];
> 	};
> 
> PAMT entry sizes are needed when allocating PAMTs for each TDMR.  Using
> the array to contain PAMT entry sizes reduces the number of arguments
> that need to be passed when calling tdmr_set_up_pamt().  It also makes
> the code pattern like below clearer:
> 
> 	for (pgsz = TDX_PS_4K; pgsz < TDX_PS_NR; pgsz++) {
> 		pamt_size[pgsz] = tdmr_get_pamt_sz(tdmr, pgsz,
> 					pamt_entry_size[pgsz]);
> 		tdmr_pamt_size += pamt_size[pgsz];
> 	}
> 
> However, the auto-generated metadata reading code generates a structure
> member for each field.  The 'global_metadata.json' has a dedicated field
> for each PAMT entry size, and the new 'struct tdx_sys_info_tdmr' looks
> like:
> 
> 	struct tdx_sys_info_tdmr {
> 		...
> 		u16 pamt_4k_entry_size;
> 		u16 pamt_2m_entry_size;
> 		u16 pamt_1g_entry_size;
> 	};
> 
> To prepare to use the auto-generated code, make the existing 'struct
> tdx_sys_info_tdmr' look like the generated one.  But when passing to
> tdmrs_set_up_pamt_all(), build a local array of PAMT entry sizes from
> the structure so the code to allocate PAMTs can stay the same.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>

