Return-Path: <kvm+bounces-42598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DB3CAA7AFEF
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 23:04:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3442018916CD
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 21:00:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52174268697;
	Thu,  3 Apr 2025 19:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WjkUXyhZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E56C268695
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 19:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743710224; cv=none; b=Wv4h+Pbp0V3QsRFN10oqEUtFdIrvSqKGl4dDv3hwHKHxyaf/lsIHZPGar3iZkmunVrBtBmFTY5QFE/c8K4+myOF1PE8L6+wpxks9KyFuPKakBTYNmSoLRVp1kVe8y14FIFxF34SulOuaAZxbJYpz7s0eaXgjse1bOCpgeUOTqMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743710224; c=relaxed/simple;
	bh=XP6la/5I4vrerXRk12ckyABr65qx/Q0V+n/zX+V4iGE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Rr+4UrYqjTCDR4zavzXyPhWIYDZ+dCE995lE31/cyka6IiqAKl5H8hoo/9ACoaK1eBjYSG4SYZeTO7E4ZJnOp2Of0QqqGSp3VEQlQO4jJ7jm1KE//EE/vk0lu1AHE6cQNEq7Pq+mLu2tywWH8ZgbL3vmpfcCfx2w6nzWhUoytQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WjkUXyhZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743710221;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1wzSVzgHMpe559xrytJJz1DdoYHYjfgbIpwM8R8lgqw=;
	b=WjkUXyhZdA0hQbVAV7NrjHz2m45HPKtHMI/DPtV0dDQXtos1SJdTmc/bMfBIpg21xez6B1
	qOg+Lahn/AIy4Zp0WtXCW8qbwYpPrOycueldP+RHRpo0oDgXWCRF+QZ/Z/mxgdvQqNyX+5
	LrrtQxSStDrHExWU7zyyiHUVjSxmmt0=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-519-JhAD91mZOE2QVHStAvaFRg-1; Thu, 03 Apr 2025 15:57:00 -0400
X-MC-Unique: JhAD91mZOE2QVHStAvaFRg-1
X-Mimecast-MFC-AGG-ID: JhAD91mZOE2QVHStAvaFRg_1743710219
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6e8ea277063so23265936d6.1
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 12:57:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743710219; x=1744315019;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1wzSVzgHMpe559xrytJJz1DdoYHYjfgbIpwM8R8lgqw=;
        b=PMxMp0tbxCtBFIoER9Ss/dv1/aBArUiDRqDiZYSp4FIgsC7ZWRJIdqkICfXsnylEQU
         zNLsaHsWPThHz96GKP7YygE6UZxD8UXH8EURXy1cBlo5m6twt+QNLJrHsCO81MHeVLVj
         y+Y6znEfKE9GWBUTROSTqGocn67UCjdtH69lmJKMRxXR3J5cYduynI7vfV5cy0fnjWyf
         2g6+JLz/OADFa4dNqs9pa9GlAjnnistvgaNdCqcbbwO4kcPc6YVJUVmDtZ9bCywoaWQO
         2QbNQTMLOUe2D924QOtVyLGYUZ2Ib5Vr4ukhStPYFDTyW3mCpiSYWvVsP48aG1zeyweg
         GecA==
X-Forwarded-Encrypted: i=1; AJvYcCVEhg0xZw+S/DA32ZsDyPjVsBhwe292mizDaw9qHNG7w/fIG81MxH7RrYNwmX/D3T68gjU=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywyp6uHoC5v16pE9omSQxUK6+UEJiIbXCfvvsHtwZb+5TL1ONFT
	V4hkLrDro/a3F26Oejn3oHoA+qq0cBdlJ7veRYkZdsIP3Ww9Bz1zII8Irt55zfvGB25kJXZ6L2V
	xjIBA9eUQmBLRXfZRJswYblPpSy7Da+P7qL4Wbr4aNU+osDHIWw==
X-Gm-Gg: ASbGnctkN/hIO9BKPgDDsmSHA7AnPfVaWOxD+OVuc94BjA56cpOvbxvsNDuPMWr+JwJ
	05OTgRyD3KPXX7nQ3lwC8SA1TeSmqzwL+KpAGWE6oQFuRxTWpv/xXpAyiZY5qNX7P4ecx/eONav
	qBBn1JOSVepbjUMe6gHpgO4bsLSWoEJcCFjib7K10RqY0RxbL8JOPr46JnIxmkrlKffAXvbyaWs
	9W5FeBLVPss4y7xJat9Swn7gZXzlr3hK+7BbyjqUbTSpwkdk1vGw4SUbg3kT88deuEA9eyKRxT+
	4SvePy0RyLnVsEE=
X-Received: by 2002:a05:6214:48e:b0:6e4:2c6e:7cdc with SMTP id 6a1803df08f44-6f00df30191mr10260266d6.25.1743710219671;
        Thu, 03 Apr 2025 12:56:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHVIXRAK4HfdDj8AW0GRSVQfM3QvF38VAmhcghiRMazHZw/QKTjocVYWwH1sKoV4Gt6kbqVoA==
X-Received: by 2002:a05:6214:48e:b0:6e4:2c6e:7cdc with SMTP id 6a1803df08f44-6f00df30191mr10259966d6.25.1743710219402;
        Thu, 03 Apr 2025 12:56:59 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ef0f13791esm11197956d6.77.2025.04.03.12.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 12:56:59 -0700 (PDT)
Message-ID: <91da48828941bd692b3b9372e57d312f938756bd.camel@redhat.com>
Subject: Re: [RFC PATCH 02/24] KVM: SVM: Use cached local variable in
 init_vmcb()
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson
 <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
 Vitaly Kuznetsov <vkuznets@redhat.com>, Rik van Riel <riel@surriel.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,  x86@kernel.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 03 Apr 2025 15:56:58 -0400
In-Reply-To: <20250326193619.3714986-3-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
	 <20250326193619.3714986-3-yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-03-26 at 19:35 +0000, Yosry Ahmed wrote:
> svm->vmcb->control is already cached in the 'control' local variable, so
> use that.

Microscopic nitpick: I usually mention that 'No functional change intended'.

> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/svm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 8abeab91d329d..28a6d2c0f250f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1367,12 +1367,12 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>  		avic_init_vmcb(svm, vmcb);
>  
>  	if (vnmi)
> -		svm->vmcb->control.int_ctl |= V_NMI_ENABLE_MASK;
> +		control->int_ctl |= V_NMI_ENABLE_MASK;
>  
>  	if (vgif) {
>  		svm_clr_intercept(svm, INTERCEPT_STGI);
>  		svm_clr_intercept(svm, INTERCEPT_CLGI);
> -		svm->vmcb->control.int_ctl |= V_GIF_ENABLE_MASK;
> +		control->int_ctl |= V_GIF_ENABLE_MASK;
>  	}
>  
>  	if (sev_guest(vcpu->kvm))

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky




