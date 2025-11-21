Return-Path: <kvm+bounces-64126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BF2D6C79069
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 13:33:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id AFBF82DA9D
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 12:33:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF1C5312816;
	Fri, 21 Nov 2025 12:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NrBaNW01"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FD82EBDD6
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 12:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763728424; cv=none; b=huwQfUb4nR4dK3MyyI0gxc9Nr2zFx8iqpL4xMwVfMq9tCa6hsv2Umv+iCPtH9WINPACaXYQ/iKCllzO57YRxpcJPWrb8nNL3Tuj0/6zfVBYPPFqFbsGqCXQtsb//Eo2YdHovNYx3rGgRnMqe4Ana9xABvdyJb3UuOZdZsMSafDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763728424; c=relaxed/simple;
	bh=We+RK2t7L/icmLWKTcWMLB+AL1ZVy8D0dTK1FclInXE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rklazwzPj4MM5J5ok0m6RRk0B2leFJG5Zqw6KcF8d6ReHSVrq171bwbhqA1AZ08370ixJ9zK9c8aATKxmcyGQ4W41l3B4D9Stdvto/5O0GMGAxqo6RvNR86TBOWXe6jBsxO3WSjqJ0lKpbtV8gE0pfCsYDAibhkKwI3zKITV4i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NrBaNW01; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b71397df721so364685066b.1
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 04:33:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763728420; x=1764333220; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=rwWokcp88y0Xy+2dctPcgYbaRe8Xf20qtSwDBPH+lwc=;
        b=NrBaNW01DRvi71iwRKsiLBX1nYmFW+UvB1BV1XP5TEgCoij1O/2uKcS+ewtyLAFEYy
         sKTrdSNxAqiwZL5tRIjnW3qRcN5G+FtYfNyN6GatnODBCFtzxg7VE6GkwcNW3M+H6H9+
         nlEgp+v7Yd/b9yS0G6syDCrP5h5++eZ3ZUMnGBmxn6cyaqbqCAHC9tblQNoK+LpbzfE4
         6rx/0gMvtz4M35ZRRtm14mxrZUsku6WonKfNmNLlmsIIvCtKRXb9Pwq+CNcT1ToLzl2b
         gu3HpFANxQ37MJbSN0oxCFk91CjnQb2ikALZf9TGunXhzuHcyDQNUhfe5PIE3udXpcdq
         SMmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763728420; x=1764333220;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rwWokcp88y0Xy+2dctPcgYbaRe8Xf20qtSwDBPH+lwc=;
        b=SCuMgAtFgvKAR5zXJk4Wle7TfFZ/lq/PCZwmwBMi+wZyXLhLYjDoHJo4vxkmOlO1yb
         yto+IJg4wMGrwIW27qQcWdTykPDT3kaAtRpIw/HJjh49GFoLzZoJXQBaBW4mc+jCmOXd
         v0Y0js+qhFUMHWGDu5A353LIMgWBfCuscqeL2mzPAi8iB3z7wx9xPcID4QKDbVPa9OmP
         +WrT8jmUSq9FmrAadOKtTYJeHILF2hVCbtmifYBI8PN7XLbwxUTU8Qv4C6VtyN6RjuNv
         8C9Qph/KYz5YSBleFwa9jB+sXTdwDF7yAy2B6x4yqL7MYdTuOR7eQOHzZrwAk4uYjHyE
         UKeQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKRID81Z/9zSZ/u2kId4hdYzrhamtHS0ptYVrgDgVFbnFdrWCWO2YGqEv/NioTIxdm81k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0M0k7gxtQcqD6mV1uiboc82sqps01liVUno/BV9SjxLGWyy4F
	Adh+UdqTJuzTHFVP9jKNzXqJn9XYGMR92xjpqvs49CnU/SMFhqly3dGkQgoBpDtTiLk=
X-Gm-Gg: ASbGncsiZ3zFbQ3I0X09G2iTHKPfQcroez7OGITZDT8tF4z4JeRz6PuGnB/9KIsdKuo
	pf0LJssuAF0SCf57FmyXEqzzZDu7LqWWns74AMsGSvddOGFAPTAAsOMcKqVac56WYTzuSF/xWpy
	IasqcGyHtE3aIj4/hBlGyVp/2knJ9xjPt/KJumyjFIn4NjD/LeHFDrSfjCe0jtqaRp2uccgHsGp
	qV3IbCBOn3RDnkObK7kgbr1miu6fx0e9sfDRagx6qovpkhVSbw5ppb+RD8cP8L9l1YLq7prLGlM
	o7dYQ3GD7Mk0ge2l4KaZYz+TL017BC4mysboQpy3WXJ1v6+uceuu1VXo0/OXJC5hWsvvxVebtet
	C6cAEvBm3Vkxz1pvfuELiLt/Rm+lwbYzxRR68fxBZP5JN9r0fhEXMw8TruNwA9ZHzRNfYAtbTW4
	nTCM7QyKf/4lV4h323NTsE9lwmZysk97tt2+7yP9i1zw+xAcY=
X-Google-Smtp-Source: AGHT+IGsGifeSMN2TPl3sbBA0J/iLAD0++giOZXZKBOu/HH0S8KfC6LE3T5jqoLt8s+Tj/B77xua+g==
X-Received: by 2002:a17:907:3c93:b0:b72:598:2f32 with SMTP id a640c23a62f3a-b767185b3eemr258108866b.42.1763728420137;
        Fri, 21 Nov 2025 04:33:40 -0800 (PST)
Received: from [192.168.0.20] (nborisov.ddns.nbis.net. [85.187.216.236])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64536443715sm4320598a12.26.2025.11.21.04.33.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Nov 2025 04:33:39 -0800 (PST)
Message-ID: <8b657ef2-d9a7-4424-987d-111beb477727@suse.com>
Date: Fri, 21 Nov 2025 14:33:38 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/11] x86/bhi: Make clear_bhb_loop() effective on
 newer CPUs
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
 David Kaplan <david.kaplan@amd.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Asit Mallick <asit.k.mallick@intel.com>, Tao Zhang <tao1.zhang@intel.com>
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
 <20251119-vmscape-bhb-v4-4-1adad4e69ddc@linux.intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
Autocrypt: addr=nik.borisov@suse.com; keydata=
 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
In-Reply-To: <20251119-vmscape-bhb-v4-4-1adad4e69ddc@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/20/25 08:18, Pawan Gupta wrote:
> As a mitigation for BHI, clear_bhb_loop() executes branches that overwrites
> the Branch History Buffer (BHB). On Alder Lake and newer parts this
> sequence is not sufficient because it doesn't clear enough entries. This
> was not an issue because these CPUs have a hardware control (BHI_DIS_S)
> that mitigates BHI in kernel.
> 
> BHI variant of VMSCAPE requires isolating branch history between guests and
> userspace. Note that there is no equivalent hardware control for userspace.
> To effectively isolate branch history on newer CPUs, clear_bhb_loop()
> should execute sufficient number of branches to clear a larger BHB.
> 
> Dynamically set the loop count of clear_bhb_loop() such that it is
> effective on newer CPUs too. Use the hardware control enumeration
> X86_FEATURE_BHI_CTRL to select the appropriate loop count.
> 
> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>

