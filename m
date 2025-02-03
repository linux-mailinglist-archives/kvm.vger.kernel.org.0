Return-Path: <kvm+bounces-37119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ABBFA2558E
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 10:15:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 479B13A100C
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 09:15:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED2651FF1D5;
	Mon,  3 Feb 2025 09:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KlYvH6HC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E661FBE9B;
	Mon,  3 Feb 2025 09:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738574111; cv=none; b=DopNcpT0fF0NH7ltgoOlYP7+ifpOquTR03xJ9yGss1s1KW6lj2OcwPBKNQ3SVxRMh/csVx0HetFaK91L3Mn5mFtva7m1IEV0nEO1LcqYys09jZtGDXdO6XNyjZ7TkmNX+2H4utVVSxcwh5IbO1mYWs+N9u9GY33KpGdLh53Huk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738574111; c=relaxed/simple;
	bh=cDGwd9F3vu/yJ9NwuWgpMuCzkamBCXWD8i5xbrJpX3g=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=AOc9f/M0oYnUQ7t/pj/JRC31k4wBk/M3Jn/tBVKxtQTKfCYfQmUtaCqYQmDwaeVn1GkQ1J2KPzMA+f14K+jFVSGt2EtNCF7nR5gsbbA/XsAjxiFGihQusU00AE9ru5b094PEtk1/Xaf0b7vVjfnxZw9k0/bNW38xToeT7yZyIwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KlYvH6HC; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-aaf900cc7fbso895393266b.3;
        Mon, 03 Feb 2025 01:15:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738574108; x=1739178908; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yyY2KTX4ajf0Wd2Gq/MW3zJXe3vlFQMKEuCyzvgML0g=;
        b=KlYvH6HC8vG0d545AoTL5rY9IQa24MUQYpVLGFj4jiBqdKhmSmBGvxlj0/290UKtpD
         gVXBISGSHrE0/UiSXEjUO8ytmygM5cc9sheVqxcLPUEX6avUJdBoE8WkdhO4jxSobdEu
         HNwzga6pCysRqZW1Sl+E+3tSrnrWs6sBlkLSIGOglicuQfRmPvlwtp0b/IUO2n9FYDnf
         9ER0h2CKhImYDhJ/cdjOvfJyo5N7/DAi5z+kgAZ3m5hjYjsG3clgr/wmY+gYUCnYHk/T
         WsfCxdjbWzwNSu3MOULhEx9bfGTvNYvDTV7iPUkfejg8g5dOCK+eY/kysNzxTt0Niw76
         Ve5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738574108; x=1739178908;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yyY2KTX4ajf0Wd2Gq/MW3zJXe3vlFQMKEuCyzvgML0g=;
        b=IIsBlFQdt0j7eye90VcK0Q2euqYDt89eNjfigFqE11nJoqcWnKDwHVPTmywKxKJkFe
         w/50OYNBfVV5zgdaK1qMj2xjEgcOIXwpbG9cVsB/35RD1P91Zk+08jZBw5Vmx1oukLIu
         +PkVcDPYwgkybSG3AZgQz5cfBnavQlEOsbg9pDWx6TCvdUnSPOysJuP4kFFi+tXD+HnW
         Krcu7h/NbNjkMZHSqFLZRqsA6PaDH+A44uTLEm3Lz/4j4zkMF19nZdpFQVvpJFp//GHc
         lC7z605QSr+ZQBd5RMJyMXlBXv8utiZMRkfydmO/i147QMEGw/Hc9AmBjM7JkUdB4Sla
         ctUg==
X-Forwarded-Encrypted: i=1; AJvYcCW6POFWsGSceAMTgfu4vATgrxy2qUp6CDM9XZose3pWH3uDGRyk5wDjXc+cBUJVUKvQu11Egq5x1jFwW3Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwekgrvL3u/gHkdLxverN0kjROtkDeSPltjyhT1nyDoFM/s/fYA
	gSDFSjELsYmeFaCYRSUngWrSr7YwCzr6sUZsP7JKNGyMPEeqMNXz
X-Gm-Gg: ASbGnctWh/27oQFH8O/7IvByJILOv1nCzIdxW3pRwCwWimHtYrPoVo5nOUmI7jzPADr
	VQZkFpai5b7hEE+EiSa+dYiLvTtUyCj5bhDA73YFEYCcgVdxGlldp1fkbbqC0lVdzTpRCDgTibB
	5bZWdcz9GP5gvf7ySEGEvteKANxCv5UuEl+e+t1OxPPHcXk4Pauia8Q1KWOE35Au1iMHBE525Qa
	5ya0q1IGhsNdzRiZ46Am2FdQa+QKzvyMp2tH+wKzWfLMIEKBWxaH6QoUCzlrB/vYxfmzXpOM0p5
	dKEXOiVS0AOy7489YgJxBM0oJrkTfps8VJcBk6KU2nMD+KG0
X-Google-Smtp-Source: AGHT+IErdjRd5tOdImm54WCRak0jSoF9BvxjL+WRRBLNF3ddCLqd+WuycTRaXE73HLybmqfj0um4dA==
X-Received: by 2002:a17:907:1c16:b0:aab:c78c:a7ed with SMTP id a640c23a62f3a-ab6cfe12c99mr2555066166b.49.1738574107585;
        Mon, 03 Feb 2025 01:15:07 -0800 (PST)
Received: from [192.168.14.180] (54-240-197-239.amazon.com. [54.240.197.239])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e4a320d5sm723391266b.149.2025.02.03.01.15.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2025 01:15:07 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <2f4752d5-63ec-4e7f-bb7a-a97eecfdfb18@xen.org>
Date: Mon, 3 Feb 2025 09:15:06 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 3/5] KVM: x86/xen: Consult kvm_xen_enabled when checking
 for Xen MSR writes
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+cdeaeec70992eca2d920@syzkaller.appspotmail.com,
 Joao Martins <joao.m.martins@oracle.com>, David Woodhouse <dwmw@amazon.co.uk>
References: <20250201011400.669483-1-seanjc@google.com>
 <20250201011400.669483-4-seanjc@google.com>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20250201011400.669483-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/02/2025 01:13, Sean Christopherson wrote:
> Query kvm_xen_enabled when detecting writes to the Xen hypercall page MSR
> so that the check is optimized away in the likely scenario that Xen isn't
> enabled for the VM.
> 
> Deliberately open code the check instead of using kvm_xen_msr_enabled() in
> order to avoid a double load of xen_hvm_config.msr (which is admittedly
> rather pointless given the widespread lack of READ_ONCE() usage on the
> plethora of vCPU-scoped accesses to kvm->arch.xen state).
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/xen.h | 3 +++
>   1 file changed, 3 insertions(+)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

