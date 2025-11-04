Return-Path: <kvm+bounces-61986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 807FAC32176
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 17:37:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 22D654EAF95
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 16:36:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5379267714;
	Tue,  4 Nov 2025 16:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VLYH8wVh";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ViO2Zbjm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25F9333732
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 16:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762274159; cv=none; b=h/XjpNmlHmWfYfwKVUFcCFSgynKvUgmeNF0A2iz5PTAMUY67syY/E71f22sbug7LVfG6rQsV05DppETotdn89O1FeYtgXirmSSmrGzLV5IOudqRLVy1pLDXB+90pi/EO02WvuLcXaWLbI2oUY8DTrb6wpuwHDqugG/yGa2GMneg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762274159; c=relaxed/simple;
	bh=22b3ohK9x5u2RxLmJrWmv4YPz3yLj8hprRDrvh7jU2A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WxAbIv/DevT/6VWPRuqIcaPyEetmHOUWMq5ujsD61tPCNy0EiHPXzEl6wuIQvO1/v445SKGYQjdYQ6dbGCps/BWkcnAHneN1R5J2JWq4gY/1iWQPgc681lHS5KYA0AXebgpDRvbrCKuVSQ/n+xf5FCp5tuG3jRSF5POhBC75nb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VLYH8wVh; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ViO2Zbjm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762274156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9rioHn4q2CtO9xdrJ8qmmNLav5FO9Ic/TB0mcDozeQs=;
	b=VLYH8wVheZzIwuJUcmhOe1Ma47MJ0KU/QZKWZabraID5kUdYl8St8Wc5K0iQ9KnpF3EgMi
	CtRCiHRJO20QaWapMbecm98nMqs5Wbi6xbvGPfsSf8mvJgWO7iDpn1A5dpy4Y0nZkV8LlS
	0JmN4JwTr2BT5ffPdPP6i3LT9doKZPA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-394-29z_HTqROm6c6Vhdr5ucrQ-1; Tue, 04 Nov 2025 11:35:52 -0500
X-MC-Unique: 29z_HTqROm6c6Vhdr5ucrQ-1
X-Mimecast-MFC-AGG-ID: 29z_HTqROm6c6Vhdr5ucrQ_1762274150
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-640789adcd2so4679976a12.2
        for <kvm@vger.kernel.org>; Tue, 04 Nov 2025 08:35:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762274150; x=1762878950; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=9rioHn4q2CtO9xdrJ8qmmNLav5FO9Ic/TB0mcDozeQs=;
        b=ViO2Zbjm+96n4QKX2+ZsQ75xeTIDfQAD8W5qjT9BWO92UMvQpvnfsz6scRbMKp9uFT
         DeHGeQo2efuBayb2IZvF8UrbIIk/wTnniJXopRy/DCH2ezoOr/k2kwdIQvD4JLniLICG
         Fhwk3SOHmCiN7/olWld2BR1GMV2tnO8bp+EGO6jIn1w2RAoiD46bA3VbWx9TDxadt4+R
         EZ77Ni2iPyBAtfHdSQ0pGRArQAsnMqBh+YuGbyD++FjEXOk7SDE51+JiPaJ5dRx55STQ
         NE/c486yjaPLZ//b+8eiqPeyigFbK2WMtsjuBx7O4/GGNskXy6Joo0BjTPZtbXPpOnfA
         8YBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762274150; x=1762878950;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9rioHn4q2CtO9xdrJ8qmmNLav5FO9Ic/TB0mcDozeQs=;
        b=gIbQSJCs5ovm3Xcn2moETXHwhWtpw7pgKd/7v3nLTJKY4bGk8DlZnrjPT/wpkZcjPy
         +8qxJBReCz4uWo5DnYXzSUZDnw2nj6+KOXmoIC7YdTp3fM1XNpBRq91NV1D+ftuxKVoy
         HzyV2ee06UiPa4fDmrPbVlsWm/DYpdQEcFFBY5ZeoaQaOQhpLu1v84evfeUlYj4KIsT/
         Wzy0RH93SHI/7/2w6MiDfRLBDGLrlX6Il+lERueaaJNWkdC4nEcUOpSStMsfKi/Bb7oQ
         ha8+8/x6m3chmYJab7M1wRMrMFOPhm0enZIG0GAs03ZOrl/CkdDi+jQo+u92/MKlesTm
         836A==
X-Forwarded-Encrypted: i=1; AJvYcCVbaqwXazPjvRiboTLV8YXli40K1rd9qABtJze7qEBzQgL/kjOVbTNNjHzOT31PC3IzxNM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLptVA/3sgIWmsMtFhr4MNrut62ItyllULGvtk4/pg5x4w0gwB
	4Xkhu2B5ZrNXFKMbkBwaYAm2+5+VeiR6AMyrBK6SbyW5cJgC6VH6vUnznI1PtY1cbH1z/EV5buY
	PwHVfuBZfB+f5w6SmOU6A2uBfRWMA3HsvMP2kBSn1BZ5ibLvu7aT3Lg==
X-Gm-Gg: ASbGncuCRxUy3jsgOuTO3D7p7xu9Nlb3Usi9ee0L1vMzx+M3R0Oo8JdlGQPe/5AxZIU
	kStLffYxR1WQ8KqbZ0GgOILWTu6GoEyZDKMJRSH2DgWt5NzCIp0JJeGbhFF45W3nkh9ntZb6m4H
	M/dI7JykIo3LC14TRTBBgTlYBJvDjsupmuJE0PAQvwmvvXJZ4KW+wX5LrjCxz1RmN2unUDHcUiZ
	7y6wFFDLCqpqIZ93+eN+D6lb+HcMeWF5pxSTfqozcYzbr+BA/D4oFaJoEk0JzWAn/+vAArj8DsR
	O/J4AnR3/yeZDczGgF95qj6Q6Qz/WUo1XXL1ZBP1hYCj/qqm7mQxQtmBPzL39e1aBszWjDLnMlf
	eTdM3fNozZ3kazWniR62fk/iqDFdsQ4JuTnP1tl5AiOV+Lc0EhfWKyrLFCWznJr7Q77FaObL+XD
	NAZpko
X-Received: by 2002:a05:6402:304c:b0:63e:405d:579c with SMTP id 4fb4d7f45d1cf-6407704f1a7mr10648031a12.29.1762274150403;
        Tue, 04 Nov 2025 08:35:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHfSKVoOz/UcXUuzGcYyyCkENzxLhVAOsFpoT2QcPPfabeeiEmvInkxL44TAX9B0FoMiDy6ZA==
X-Received: by 2002:a05:6402:304c:b0:63e:405d:579c with SMTP id 4fb4d7f45d1cf-6407704f1a7mr10648021a12.29.1762274149993;
        Tue, 04 Nov 2025 08:35:49 -0800 (PST)
Received: from [192.168.10.48] ([151.95.110.222])
        by smtp.googlemail.com with ESMTPSA id 4fb4d7f45d1cf-640ee0b4e31sm1573085a12.36.2025.11.04.08.35.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Nov 2025 08:35:49 -0800 (PST)
Message-ID: <ceb1a9b7-4d5c-4873-862f-d1bc63731d27@redhat.com>
Date: Tue, 4 Nov 2025 17:35:46 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/3] kvm:x86: simplify kvmclock update logic
To: Sean Christopherson <seanjc@google.com>, Lei Chen <lei.chen@smartx.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250819152027.1687487-1-lei.chen@smartx.com>
 <aO7j7lcqmL-n599m@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <aO7j7lcqmL-n599m@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/15/25 01:59, Sean Christopherson wrote:
> On Tue, Aug 19, 2025, Lei Chen wrote:
>> This patch series simplifies kvmclock updating logic by reverting
>> related commits.
>>
>> Now we have three requests about time updating:
>>
>> 1. KVM_REQ_CLOCK_UPDATE:
>> The function kvm_guest_time_update gathers info from  master clock
>> or host.rdtsc() and update vcpu->arch.hvclock, and then kvmclock or hyperv
>> reference counter.
>>
>> 2. KVM_REQ_MASTERCLOCK_UPDATE:
>> The function kvm_update_masterclock updates kvm->arch from
>> pvclock_gtod_data(a global var updated by timekeeping subsystem), and
>> then make KVM_REQ_CLOCK_UPDATE request for each vcpu.
>>
>> 3. KVM_REQ_GLOBAL_CLOCK_UPDATE:
>> The function kvm_gen_kvmclock_update makes KVM_REQ_CLOCK_UPDATE
>> request for each vcpu.
>>
>> In the early implementation, functions mentioned above were
>> synchronous. But things got complicated since the following commits.
>>
>> 1. Commit 7e44e4495a39 ("x86: kvm: rate-limit global clock updates")
>> intends to use kvmclock_update_work to sync ntp corretion
>> across all vcpus kvmclock, which is based on commit 0061d53daf26f
>> ("KVM: x86: limit difference between kvmclock updates")
>>
>>
>> 2. Commit 332967a3eac0 ("x86: kvm: introduce periodic global clock
>> updates") introduced a 300s-interval work to periodically sync
>> ntp corrections across all vcpus.
>>
>> I think those commits could be reverted because:
>> 1. Since commit 53fafdbb8b21 ("KVM: x86: switch KVMCLOCK base to
>> monotonic raw clock"), kvmclock switched to mono raw clock,
>> Those two commits could be reverted.
>>
>> 2. the periodic work introduced from commit 332967a3eac0 ("x86:
>> kvm: introduce periodic global clock updates") always does
>> nothing for normal scenarios. If some exceptions happen,
>> the corresponding logic makes right CLOCK_UPDATE request for right vcpus.
>> The following shows what exceptions might happen and how they are
>> handled.
>> (1). cpu_tsc_khz changed
>>     __kvmclock_cpufreq_notifier makes KVM_REQ_CLOCK_UPDATE request
>> (2). use/unuse master clock
>>     kvm_track_tsc_matching makes KVM_REQ_MASTERCLOCK_UPDATE, which means
>>     KVM_REQ_CLOCK_UPDATE for each vcpu.
>> (3). guest writes MSR_IA32_TSC
>>     kvm_synchronize_tsc will handle it and finally call
>>     kvm_track_tsc_matching to make everything well.
>> (4). enable/disable tsc_catchup
>>     kvm_arch_vcpu_load and bottom half of vcpu_enter_guest makes
>>     KVM_REQ_CLOCK_UPDATE request
>>
>> Really happy for your comments, thanks.
>>
>> Related links:
>> https://lkml.indiana.edu/hypermail/linux/kernel/2310.0/04217.html
>> https://patchew.org/linux/20240522001817.619072-1-dwmw2@infradead.org/20240522001817.619072-20-dwmw2@infradead.org/
> 
> I would love, love, *love* to kill of this code, and the justification looks sane
> to me, but I am genuinely not knowledgeable enough in this area to judge whether
> or not this is correct/desirable going forward.

Yes, Lei Chen's reasoning are correct.  In particular for the cases that 
trigger KVM_REQ_CLOCK_UPDATE, they really should do it immediately and 
not rely on periodic updates!

Paolo


