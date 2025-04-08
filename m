Return-Path: <kvm+bounces-42943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 56AA4A80D07
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 15:56:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3AB4518958EB
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 13:52:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5069D1C84C3;
	Tue,  8 Apr 2025 13:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YiY2PUKC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD451ADFFE
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 13:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744120310; cv=none; b=h7uEjdMARK65+4ERH2jscl2Dd0YFmRs2SD8CvlC2b1aIWAuafpf7vwbeLQxHclweG4o2PPEsT7oCBUf1ca3Hq/JrmxVCQk865aiLv//iXkykzG87ZPD1CtheSO4uyxmpC956S+vLgWAD8HFFh6ZQ0fQfEEnxIfhslV9YSQ16zhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744120310; c=relaxed/simple;
	bh=HjUH4u/gXQA7jvskoayr8M1QIhDAl7N9Voq5JiMyr8I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rH9QRfU7ikCtSQYDmzf5WZsaOvkTmaSoyf+4Sofu+dPg7uHkVyx5cgZ50UXuKYTvaBvXnTnIXFONGQpOCYrDiBOQq7lv3kzjrBh1wGSYcn67PmK5iPcDVseajJBAgJgjFGQiDLQhBwB3WiUx1whfvTCbdxoagayUkstvaHhwoxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YiY2PUKC; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-ac339f53df9so982209466b.1
        for <kvm@vger.kernel.org>; Tue, 08 Apr 2025 06:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1744120306; x=1744725106; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=weXcsN2ApD/Kp+q3Og2grYGoCb9Y0mUAD/roS+hqTB8=;
        b=YiY2PUKCCa7ooVvAGGJoBJiVJxd/URK/cgV/w9BBk45XzB6SqczEUwV6XbYIJTzkbv
         +fq0tdn3xnG8ui2MgVt7qnBXf/beTs4kWiBF/vVVKZUrXuNoWCEh/Y7F5ElYWkBpgsQg
         MTj3aWd0dylC0OaU8+p4h+03dYr5Eq+9opDyu7oCdkIEwVH+yp75I9BOoDgqcTgg21Ef
         kZ6gnVOrqe8jKBLfPatzMGgMugVnsfaDmyNv6TJPsOWJN/WAwWU6yb/72cxlkFIwl1gM
         x6CgXkeCO2qHkLyHBxXZ6Ad67PVJ2cbqyLuXO7DyFeGaQ/1fg8Td+wXvybfmM2tV60Nw
         bi8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744120306; x=1744725106;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=weXcsN2ApD/Kp+q3Og2grYGoCb9Y0mUAD/roS+hqTB8=;
        b=syVfGxXVenvJiYvvvEL/aXAgFwGLk2hOYBsp9W8hJTnbu5V5jZRiZO24La09zr8JwQ
         gtuKNYPmpt7j2PzoY9DsyuD5Kws2dRcagXwjPI59TFEmEW4obPwTWx9eGZULDLiki51U
         rZfKKMXCXgVML/y9SWfTtHKWbtrq2keVQokEuGo9DPaaMMY6EOD9CiKTRI2ujJW+DrB4
         wW2dBU/UoxHRpsKcgjqc8YltQZIDe+dKFwHKn3Y8LSPXYc1UsLjRhRJl4ytnPZzupdGZ
         +ab2WZ5nZ3WzK3PTwlVQuYCOwGjuuI6II+YSgEIyyZjOPD45j0gIsZUFmP7PjuYBKRWi
         p6qQ==
X-Forwarded-Encrypted: i=1; AJvYcCVt3v2NAODc/0nHdqYF5TPccDBo7uvwbB/08EDabB2bv0q46RLG1v0vynaKl1SZUKSgWM8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4MTSQSJQ9u6dgpi0CuV/Zxe8jly2UAKJPzO+oT94P3b+ywjhd
	J9uuodD+sWC+HECPsQvlnDB/it6QUrTY7vOKDwDsqbgsxB4RrDbdYGMfdJ1rgsY=
X-Gm-Gg: ASbGncvLyAa/NgLt8VhTVkskTZVHJZj+nasy9RyPP1dlS9WUl/mtTEo7V72qmROY9zz
	ysMlnoqCHuyn+pkOftlVfXObjeqIrEDY7mkBkfgrNtQkzhzBMpeCzd0s+7v2FBcNvGSfvdN5I5L
	uJARuKc4gtZweJfQDnfcBd9xrSceJPya4DnldHyl3nz/HvTRdRFLWWdlCOdcgok76U5JBWnzu2r
	UuuaZW3zfwK4SjT+T4c8M7MoEGVV1dxJx/vivxvum8oFD2h4Sd2x9dXBhY0yTb2iw1Tk9i2f4CS
	5Wqjz35SAetF+JATCFi66PMNI3yk964SKpWOrmP9cCd3YQLzaw==
X-Google-Smtp-Source: AGHT+IGhZUDOCoq2lG8Mqv46Byz/B7FrIQsVC8SlQB7RTR8NimqTY+nanpEWwoC7+6x18hI7s1bySA==
X-Received: by 2002:a17:907:970b:b0:ac3:cab6:719e with SMTP id a640c23a62f3a-ac7d1854ad4mr1332725666b.11.1744120306606;
        Tue, 08 Apr 2025 06:51:46 -0700 (PDT)
Received: from [192.168.0.20] ([212.21.133.214])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7c013f363sm924386266b.105.2025.04.08.06.51.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Apr 2025 06:51:46 -0700 (PDT)
Message-ID: <80e2557d-b4b0-4097-9662-8772d2af25fe@suse.com>
Date: Tue, 8 Apr 2025 16:51:43 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] x86/bugs: Don't fill RSB on context switch with
 eIBRS
To: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, amit@kernel.org, kvm@vger.kernel.org,
 amit.shah@amd.com, thomas.lendacky@amd.com, bp@alien8.de,
 tglx@linutronix.de, peterz@infradead.org, pawan.kumar.gupta@linux.intel.com,
 corbet@lwn.net, mingo@redhat.com, dave.hansen@linux.intel.com,
 hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
 daniel.sneddon@linux.intel.com, kai.huang@intel.com, sandipan.das@amd.com,
 boris.ostrovsky@oracle.com, Babu.Moger@amd.com, david.kaplan@amd.com,
 dwmw@amazon.co.uk, andrew.cooper3@citrix.com
References: <cover.1743617897.git.jpoimboe@kernel.org>
 <8979e2e1d9f48aa4480c2ebd5ea0f9e31f9707e5.1743617897.git.jpoimboe@kernel.org>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <8979e2e1d9f48aa4480c2ebd5ea0f9e31f9707e5.1743617897.git.jpoimboe@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2.04.25 г. 21:19 ч., Josh Poimboeuf wrote:
> User->user Spectre v2 attacks (including RSB) across context switches
> are already mitigated by IBPB in cond_mitigation(), if enabled globally
> or if either the prev or the next task has opted in to protection.  RSB
> filling without IBPB serves no purpose for protecting user space, as
> indirect branches are still vulnerable.
> 
> User->kernel RSB attacks are mitigated by eIBRS.  In which case the RSB
> filling on context switch isn't needed, so remove it.
> 
> Suggested-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> Reviewed-by: Amit Shah <amit.shah@amd.com>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>

