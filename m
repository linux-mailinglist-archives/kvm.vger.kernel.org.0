Return-Path: <kvm+bounces-42601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D1AFA7B010
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 23:08:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E204A167D1E
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 21:01:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 299D5267B61;
	Thu,  3 Apr 2025 20:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UXiFWHYN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2ECD25B66C
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 20:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743710463; cv=none; b=O2McdtOZZlmMLsS1mmz6phj824W7xi/rd9AZqJHEeLBO2T8o4igH1H+LmCx630bhyIhcnAcoA9Mk4sYvaBTxKhwwj2LMGPIINFteURHxU7xM/jdQRediIp14TqiCH871HCzr9YQQ0pMa8gJvoO6An1E1z185RgB6pOqVnXW3pPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743710463; c=relaxed/simple;
	bh=jENm0PzduFiv1vZoirItmU6tAvlLg945YnZLX4j2QN4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QTuiR2Y5vhaGXcfR/8hHTY+jfEDg2QF0AmFwpETVc/YxyX8qe1+z30uR8zRDicL8P4eHAQg4jsg1wVLnrQA9aIQrA6/kdodSyhyinX3e9VvLlN/8KTiAxNPT70W8qLn+UR4jtOEcobvWew6A4yHWwJQGyhjFQzpw9A6xL679lmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UXiFWHYN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743710460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RR9uwOcgkho9bkZAm9hKk3bpEctgLrbkB+0hOh9pF5s=;
	b=UXiFWHYNXVyvS6VcrmKqpaGKAA2zcG43p07LoySbIY1b6955UZtk9lXOZ4mN6LOxCMGqMx
	MYInRM3pVIzpkbQcjIobSp1E7rijFPj+G457JB04HTQWfEXzvAfYK+2ZmyoQ/0fWgY34BO
	BVCHpDOY2Ik3P1F4m8TLrhCAEyy6FC0=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-450-S6TdHGBsOXWzwilQyi8g-g-1; Thu, 03 Apr 2025 16:00:58 -0400
X-MC-Unique: S6TdHGBsOXWzwilQyi8g-g-1
X-Mimecast-MFC-AGG-ID: S6TdHGBsOXWzwilQyi8g-g_1743710458
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4766e03b92bso23642801cf.2
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 13:00:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743710458; x=1744315258;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RR9uwOcgkho9bkZAm9hKk3bpEctgLrbkB+0hOh9pF5s=;
        b=gNJmVy7N6X5TrCFocqzWAsy5BFPOkUSc68+T3iJ6Sw/xhZCbCVjX/9IJseM35hbLcN
         MD1qiFxx/isIybNDUa4D8OMX7+1WlcQISNTcjlGpgnCWtnLk3TfMxRPs/ZMVkrTw7yFE
         MhCMPfsz1LRVaSSOzbcIItBR0C2CFoTUvWAZ6q6qWIeufOk/8zC6Ecq8hgUeuvIP2/ll
         T8IKQTM5xgBGvjC58XN4XwHQaMfFeRu7HgPG+3uFWGXZUHxFiVWzVz2zYsVfrQWATIuX
         2is8C/XdJi+0GQDZXroakT/PRbHZbTdScfljSQPpZhcQ4GjlT0FDgQPMHYl4WbYa+v6h
         TnqQ==
X-Forwarded-Encrypted: i=1; AJvYcCXIRYWWeAWI5PgQUrwOIMDhNMMsdYoB+5mbv2ZHN2iIxtG/hCWmCA0g2LBh1zwBy1SWjC0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDQ6Gj8PKg4m4BkdQ+Oh9hYHbMWN56SkJiLfTM7ThcIk6bXSkI
	4zxYFQ5rWhsPt9GuZESsP5LWgyDOiai6BnXcfDuJ3tRrq/g2gnUyBcuXf1UMdIFB5LfmmGhtclG
	qVAMkziWhXBN7k6NTF9UCt/29ClJuUjmwWegeS9hVtL6keSBLFw==
X-Gm-Gg: ASbGncvHWsQOyUp7VXbvRlkQmaLS+m4bobWwBEfFsM5DhIfw2is7jBoOCuLRFmTfwWM
	x0ecGpt/rEkpT0eCs0TtUy7hcwvPzsDtcm+s7nGmgINwCO5vLbscvA/Zte3HJ1h7h9o7moZk5Q3
	RFs7X4+/R0dYCZVRmAF/iDXkEcAoKWr5WGkwBK07E4+Zm4d9kWmfukWetZxVBDDSWJy86S3bvgW
	1V3CAbwROP4iqpI9ypwR33iogXd1h1YtHncq0cPzXkP9t3WGH8D7HtLnyrEKYQ9satCxJXUOn+s
	BGwIIr1hQFywheg=
X-Received: by 2002:ac8:590f:0:b0:477:6f1f:690b with SMTP id d75a77b69052e-47924919137mr12296761cf.5.1743710457985;
        Thu, 03 Apr 2025 13:00:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEqGtoAQvzzPSjWhn27Wmfxn7Klkq1YoJpZcHdAtWoVXhMGLG23JAtW/8HipHKEvzkQV/redQ==
X-Received: by 2002:ac8:590f:0:b0:477:6f1f:690b with SMTP id d75a77b69052e-47924919137mr12296211cf.5.1743710457597;
        Thu, 03 Apr 2025 13:00:57 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4791b057d37sm11536941cf.9.2025.04.03.13.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 13:00:57 -0700 (PDT)
Message-ID: <3ab79e6f97a0a3610c4841e52b6233248d1a76a8.camel@redhat.com>
Subject: Re: [RFC PATCH 05/24] KVM: SVM: Flush the ASID when running on a
 new CPU
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson
 <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
 Vitaly Kuznetsov <vkuznets@redhat.com>, Rik van Riel <riel@surriel.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,  x86@kernel.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 03 Apr 2025 16:00:56 -0400
In-Reply-To: <20250326193619.3714986-6-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
	 <20250326193619.3714986-6-yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-03-26 at 19:36 +0000, Yosry Ahmed wrote:
> Currently, when a vCPU is migrated to a new physical CPU, the ASID
> generation is reset to trigger allocating a new ASID. In preparation for
> using a static ASID per VM, just flush the ASID in this case (falling
> back to flushing everything if FLUSBYASID is not available).
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/svm.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 5f71b125010d9..18bfc3d3f9ba1 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3626,12 +3626,12 @@ static int pre_svm_run(struct kvm_vcpu *vcpu)
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
>  	/*
> -	 * If the previous vmrun of the vmcb occurred on a different physical
> -	 * cpu, then mark the vmcb dirty and assign a new asid.  Hardware's
> -	 * vmcb clean bits are per logical CPU, as are KVM's asid assignments.
> +	 * If the previous VMRUN of the VMCB occurred on a different physical
> +	 * CPU, then mark the VMCB dirty and flush the ASID.  Hardware's
> +	 * VMCB clean bits are per logical CPU, as are KVM's ASID assignments.
>  	 */
>  	if (unlikely(svm->current_vmcb->cpu != vcpu->cpu)) {
> -		svm->current_vmcb->asid_generation = 0;
> +		vmcb_set_flush_asid(svm->vmcb);
>  		vmcb_mark_all_dirty(svm->vmcb);
>  		svm->current_vmcb->cpu = vcpu->cpu;
>          }

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky





