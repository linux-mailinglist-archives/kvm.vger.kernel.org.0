Return-Path: <kvm+bounces-23192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE4A1947771
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 10:38:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 234A2B21C12
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 08:38:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 571E014EC73;
	Mon,  5 Aug 2024 08:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MEF8FkdX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A9B152E12
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 08:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722847089; cv=none; b=rfDzrpaRwnk98Nlf7rHfdmx1ZharjRKEc23DMyaZlZp6S4fkG36ztFoseH18X1W3dv8QhWyyiVRGAoZ33ogn4mvHvu90WFoOw7s9GYpw6BZEKnJpkksiwfLlHHlDpgKfmlnS+lT4Z7+n9Wy6DvtbVE+IsPcoHW3CrrUC1yfhGEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722847089; c=relaxed/simple;
	bh=xcF6Mfrw40Jw8RGQ0v/6ZTNK3dJLj6b1R4dFkTsR3B0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Sf2SiCkKGsvycHkpw1+wDcbXmIVPcHBU/JuyzxNCSA8sJHJVn9vshm7Qis7zsKigsA28NIJJu9SHWID3ohiATQ35Kyv9Z7dr2op9M0qV2N96JYylL6sY+/B1KWgeBcLd0yKaKfTBZSea1T/VROMGc62vb2Pq9WblhzI7uzcwpqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MEF8FkdX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722847086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XUcHAQllXYYJE9iTeuUZ5vK3MCPBiGRYOafe/DWV6AE=;
	b=MEF8FkdXsEOJCp2EM7clu1X781pz9F26ZogKzinz7pQ/xeZFR6RPqEtpnmAIV2J9PpdRZo
	E2nEYzuR/r0iQGPAqH++uX6iA8VL1KcI1UZezx1L41OuwJXwacLSPVIh95HV5kSQf3N1cn
	kR+oxIqdmbVt1pFcUIrVb8cMUreaYnM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-544-tYfO-WW4M7OPxktfkT-oiw-1; Mon, 05 Aug 2024 04:38:04 -0400
X-MC-Unique: tYfO-WW4M7OPxktfkT-oiw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4280a39ecebso25173615e9.0
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 01:38:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722847083; x=1723451883;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XUcHAQllXYYJE9iTeuUZ5vK3MCPBiGRYOafe/DWV6AE=;
        b=sJPOMJinvD35qGe+0rv/JzFyb8o7Fv63LdQLaKwF6P5b9OvK3tNNMLcFvE2s01IB/Z
         ZO8FoQ7R6UWgEJwPtyVMDcVCmjpc2KeaqosV832v7JVti/i/i/Pff7sSOrkh+Ag7207t
         nGaEJzUXSCV8/ZWD31dn+DelWs75X/k7ifTJwrAn65eLA9+OI41Jzk0pDnnEwAadfUOE
         S7b5QSdkFPqdRiILbl6syNkdYMHEpjl6x5iwU81S7NR6W6zz+PRq7SXJP1AbM5Pk7baY
         iqlUU1+TrnHPCKkBZwjcUfzNFwTBLEHZu2yhI45rsNrmmUVf2pEoAcau47fs0WHETpMX
         yHHA==
X-Gm-Message-State: AOJu0YzMVIZ4kNqWk5roYzjyDdEYp2p0yLKffkMjxu0Krt+2AKsYWPTf
	xOZy3PZoYlV77AjkvxkodQqMF58zzvLBZv8UXWWn/F4x6lEOBm8OclA0kdXgWOJZA2isuHltOEc
	uxE+Q34hpapSed7ED2diSzw2jUdrImRPlYrKGXlQcV6QESpWzDQ==
X-Received: by 2002:a05:6000:1151:b0:362:2af4:43cc with SMTP id ffacd0b85a97d-36bbbe5be99mr7049780f8f.19.1722847083329;
        Mon, 05 Aug 2024 01:38:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH0NE1Ot8rOByWZ3stWd4olh4hwJV37rmCDmeoi9oON5ME/krtX9d8mKmYlwDG6bB1c0zomxg==
X-Received: by 2002:a05:6000:1151:b0:362:2af4:43cc with SMTP id ffacd0b85a97d-36bbbe5be99mr7049758f8f.19.1722847082890;
        Mon, 05 Aug 2024 01:38:02 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36bbd02200asm9095297f8f.54.2024.08.05.01.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Aug 2024 01:38:02 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Yue Haibing <yuehaibing@huawei.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, yuehaibing@huawei.com
Subject: Re: [PATCH -next] KVM: x86: hyper-v: Remove unused inline function
 kvm_hv_free_pa_page()
In-Reply-To: <20240803113233.128185-1-yuehaibing@huawei.com>
References: <20240803113233.128185-1-yuehaibing@huawei.com>
Date: Mon, 05 Aug 2024 10:38:01 +0200
Message-ID: <87sevjgyae.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Yue Haibing <yuehaibing@huawei.com> writes:

> There is no caller in tree since introduction in commit b4f69df0f65e ("KVM:
> x86: Make Hyper-V emulation optional")

Yea, I tried some history digging but came out empty handed and I have
to admit I have no idea how and when I added this stub. Thanks for the
cleanup!

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

>
> Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
> ---
>  arch/x86/kvm/hyperv.h | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> index 923e64903da9..913bfc96959c 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -286,7 +286,6 @@ static inline int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  	return HV_STATUS_ACCESS_DENIED;
>  }
>  static inline void kvm_hv_vcpu_purge_flush_tlb(struct kvm_vcpu *vcpu) {}
> -static inline void kvm_hv_free_pa_page(struct kvm *kvm) {}
>  static inline bool kvm_hv_synic_has_vector(struct kvm_vcpu *vcpu, int vector)
>  {
>  	return false;

-- 
Vitaly


