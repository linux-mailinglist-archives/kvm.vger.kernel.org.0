Return-Path: <kvm+bounces-43345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 135E0A89CA0
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 13:39:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1FB40188D783
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 11:36:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA3EA28F52A;
	Tue, 15 Apr 2025 11:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RUHtbXBD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D094289378
	for <kvm@vger.kernel.org>; Tue, 15 Apr 2025 11:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744716970; cv=none; b=mgVRRttrsG2KZbJYX13w1ypl6ppjPVNWboujduLokENopFeVrtboIBzIq5krhmzFm4yHtm5kJ9ZB95WqzUS8O7zNqLcsEriGGESWbOFBcFLkCuc2UAG6r14QYyCM1hxPFMOvF4xbqRNjXsJaTMZopdVDq98kNFQIVOpu3fjGoGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744716970; c=relaxed/simple;
	bh=ecxh0DIByMnHf6ygrYZHPedHniG1Gc17UjqLlCDNNks=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ue96mtTPeJ+B/X1yOTW/RDITP+CCUGWef+n4mo6oYUc4Bok7UGRse0K09LGWRG13DOoeRtkqnDjFNwEzCvb7A0tDnepsOpmQ83K1fXYQXXPIMnZNIcyBc/9qWeO0VY0RFHSRHf6ZSNWOucWlti7LjI0UkTZqvqGQmX8b0HSqGMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RUHtbXBD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744716968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lXumDY4xCMKyDj7D8VQa+feWOdO7T/uIrMyU2wfkHqQ=;
	b=RUHtbXBDlE08XPDv8FyuGDYZkwCnNeNWVSC2fKkfoZq79Kh5WZEDjEE+w0b4lnjbyvmmoe
	g1lzC8As13n6hHO4maMe9k2+3UHWHhFjFah6WImfuBsmV7LWTHOg03l+AnRkBiTDzcGAl7
	7eXwva6YP8BzPK6Bn35JLnGQOL0bFsI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-488-_VWbYsQ3OYu9no0mmjpt7w-1; Tue, 15 Apr 2025 07:36:06 -0400
X-MC-Unique: _VWbYsQ3OYu9no0mmjpt7w-1
X-Mimecast-MFC-AGG-ID: _VWbYsQ3OYu9no0mmjpt7w_1744716965
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43cf446681cso35193845e9.1
        for <kvm@vger.kernel.org>; Tue, 15 Apr 2025 04:36:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744716965; x=1745321765;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lXumDY4xCMKyDj7D8VQa+feWOdO7T/uIrMyU2wfkHqQ=;
        b=CytLU6ys0CQ3P6aP52MZ7mUawjkOFoBXa5mxTAGpb8vV3WEJ5relP9gxTlCIqwbiFM
         bmhQPKnOWM71A/lUwLEuRzyX1JhFxCIYCQDYmFwHihtqU/qBPSGLhvd1PKwfMGczSZqx
         AlhlO57IhSGacRX14rKU2jRHS2c+Wav1eqch00uBQtMuF4080kuTMMiNRNRXNARh9NWX
         LCuDs23VALZCw/PLvnwCm8Qqt5oLRekXqnVirLCA8ce7MC3L4m8zvonmuwRONay0Drh7
         bcqTJTdHv2Zsgj3b/WX3+s9C/Ytc7tV9MrZp3iTpDlLilJgX6sWRLRgSlwbAjWcOJSiE
         iS4w==
X-Forwarded-Encrypted: i=1; AJvYcCVEkQwDATK9I9Fh4CiYa/U6f3ymaNOM5ZWs8E2dAemb30IazE0lmvEUPHheQOnyL0vywbA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxpLfYhfcKuscX0CHwmx1FiReT9Nnm7W20IuWKeP5tzvIcIsi2F
	biaAnlHh1HgnoF/1wSaRyBYAEq8q0SvAnaXOiwD4BhnwFC6kq7BscqE4iD7BPUYfjfpu45HL2uz
	6G4dh1BhiyLDBMXtmcrvHC14ktz38TPzNFFYfTXjI9ApCWLx41g==
X-Gm-Gg: ASbGncufFaF1Lw1nQRHVP4Zc1rczh6a7DzI+9CQMU18HGJpDrOsTemkRfWCNoVfNU9U
	x8xUoX6dd/8vUup3MYcT4jx9aa5cVxUz4kHiD4nCKBb4lDUzQ/NqsW5p1nmXixjHnzLmhRSzE4E
	6iEHpbAhBdbYJMR6cn0GCFRYJTuBS6TRnxfZbjVI8UDsIabDK07lPnqTw6g5bp3F3R5sosp4ISV
	CDEDULF7OQcJ5ozTE43eRgcQJZuVrc+9gDhraVo95fRxeyAt9YheiC9wpfb7cie0icKTAeBygno
	qzc3wHsgGXy5LYjL
X-Received: by 2002:a05:600c:1e18:b0:43d:160:cd97 with SMTP id 5b1f17b1804b1-43f3a9aad9dmr116295575e9.25.1744716965524;
        Tue, 15 Apr 2025 04:36:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IENkTE6bgF5Rb9zhuxM/+FO7GOrmCPiOvR+9BRMeJxMAeIAq7zucZTzAlJuAYb8wTmelGeqiw==
X-Received: by 2002:a05:600c:1e18:b0:43d:160:cd97 with SMTP id 5b1f17b1804b1-43f3a9aad9dmr116295435e9.25.1744716965159;
        Tue, 15 Apr 2025 04:36:05 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.109.83])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-43f2338dc13sm213154095e9.3.2025.04.15.04.36.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Apr 2025 04:36:04 -0700 (PDT)
Message-ID: <e6606b04-6154-4823-80a3-dc47392dcc59@redhat.com>
Date: Tue, 15 Apr 2025 13:36:02 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/67] KVM: x86: Reset IRTE to host control if *new* route
 isn't postable
To: Sean Christopherson <seanjc@google.com>,
 Sairaj Kodilkar <sarunkod@amd.com>
Cc: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
 Lu Baolu <baolu.lu@linux.intel.com>, kvm@vger.kernel.org,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 Maxim Levitsky <mlevitsk@redhat.com>,
 Joao Martins <joao.m.martins@oracle.com>, David Matlack
 <dmatlack@google.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Naveen N Rao <naveen.rao@amd.com>
References: <20250404193923.1413163-1-seanjc@google.com>
 <20250404193923.1413163-3-seanjc@google.com>
 <ad53c9fe-a874-4554-bce5-a5bcfefe627a@amd.com> <Z_kkTlpqEEWRAk3g@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <Z_kkTlpqEEWRAk3g@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/11/25 16:16, Sean Christopherson wrote:
> On Fri, Apr 11, 2025, Sairaj Kodilkar wrote:
>> On 4/5/2025 1:08 AM, Sean Christopherson wrote:
>>> @@ -991,7 +967,36 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
>>>    		}
>>>    	}
>>> -	ret = 0;
>>> +	if (enable_remapped_mode) {
>>> +		/* Use legacy mode in IRTE */
>>> +		struct amd_iommu_pi_data pi;
>>> +
>>> +		/**
>>> +		 * Here, pi is used to:
>>> +		 * - Tell IOMMU to use legacy mode for this interrupt.
>>> +		 * - Retrieve ga_tag of prior interrupt remapping data.
>>> +		 */
>>> +		pi.prev_ga_tag = 0;
>>> +		pi.is_guest_mode = false;
>>> +		ret = irq_set_vcpu_affinity(host_irq, &pi);
>>> +
>>> +		/**
>>> +		 * Check if the posted interrupt was previously
>>> +		 * setup with the guest_mode by checking if the ga_tag
>>> +		 * was cached. If so, we need to clean up the per-vcpu
>>> +		 * ir_list.
>>> +		 */
>>> +		if (!ret && pi.prev_ga_tag) {
>>> +			int id = AVIC_GATAG_TO_VCPUID(pi.prev_ga_tag);
>>> +			struct kvm_vcpu *vcpu;
>>> +
>>> +			vcpu = kvm_get_vcpu_by_id(kvm, id);
>>> +			if (vcpu)
>>> +				svm_ir_list_del(to_svm(vcpu), &pi);
>>> +		}
>>> +	} else {
>>> +		ret = 0;
>>> +	}
>>
>> Hi Sean,
>> I think you can remove this else and "ret = 0". Because Code will come to
>> this point when irq_set_vcpu_affinity() is successful, ensuring that ret is
>> 0.
> 
> Ah, nice, because of this:
> 
> 		if (ret < 0) {
> 			pr_err("%s: failed to update PI IRTE\n", __func__);
> 			goto out;
> 		}
> 
> However, looking at this again, I'm very tempted to simply leave the "ret = 0;"
> that's already there so as to minimize the change.  It'll get cleaned up later on
> no matter what, so safety for LTS kernels is the driving factor as of this patch.
> 
> Paolo, any preference?

If you mean squashing this in:

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index ef08356fdb1c..8e09f6ae98fd 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -967,6 +967,7 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
                 }
         }
  
+       ret = 0;
         if (enable_remapped_mode) {
                 /* Use legacy mode in IRTE */
                 struct amd_iommu_pi_data pi;
@@ -994,8 +995,6 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
                         if (vcpu)
                                 svm_ir_list_del(to_svm(vcpu), &pi);
                 }
-       } else {
-               ret = 0;
         }
  out:
         srcu_read_unlock(&kvm->irq_srcu, idx);

to undo the moving of "ret = 0", that's a good idea yes.

Paolo


