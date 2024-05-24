Return-Path: <kvm+bounces-18121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 543E58CE627
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 15:26:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0BA871F2202E
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 13:26:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE1A112BF39;
	Fri, 24 May 2024 13:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C6ciXNQ+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427883FBB7;
	Fri, 24 May 2024 13:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716557172; cv=none; b=YOL3903mIk1AMdJxbspSlnLl9BUe6+4rQUtc1XGK8yeEIJBEPGQdMMkaCYwi9sSdSrxjBoBV4hjS0M/ynejp3r1xpX9delT/PT4caQVxzJpZoBT5i4PBpZNsy86zI7BICOnxo6D/ClWdM7pEV7osdEUoB4fy/biuoPHAUxLs1fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716557172; c=relaxed/simple;
	bh=j5xm6XpzuOK09zeyH58U/GJ0F/Rrq7mRKYGfu5Vr8sU=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=QfGXFWYd7voIZBBeYpUcBI5iN0QoVmznmR7GSsPhvR8aftfXAHxI6gHCAeNYKZtdiLRfEGvZ5I+zpO1zWsWy0CQdu/7AknIa9QdO0XuI3tDqSjMt5+ZcNvHOEkUdccepKsB2Dn8YLX9KLMJnHVlDT2xpNMfSl1rlX93R9pZaSWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C6ciXNQ+; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-523b20e2615so10190541e87.1;
        Fri, 24 May 2024 06:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716557169; x=1717161969; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SolOo+u07aKBHiQy8wdX4zOZwYE5CwLfUJ/MrBrsu9A=;
        b=C6ciXNQ+ozV+RbxvAm+P3kraqt9qGdz5v5oCaahZCLtnda1KTk69ea08wyHLziCJIO
         FBgQUuvKgwHvUvKV3dwm0VfwIAba2EZuLYRFZYHds0FbZAN86LIlbAc77QEw5+Q4wO4i
         uuK35b1pu3Ws0N2AdTCj9MeFEHs1xw9InU8eoe0ztsDwbmQB2krJk5LJ2aXhSYtNnkzK
         qp7KKlxXEY0kEYpKNNGkldolz+1KFTH/aPmnJ+7GLI6MG2WHuXhUN0TVtnWcKozcMtcN
         HFNMVax+ZqIw3U+VaE/R9e5KLf88n+umttjKEQvDS7v7lr9R5syWmhEUUEPu46hr8ErK
         7AeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716557169; x=1717161969;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SolOo+u07aKBHiQy8wdX4zOZwYE5CwLfUJ/MrBrsu9A=;
        b=i5uV6AdgUO+48yhFs6S+XvjAvRADICy4++CZycD0rKZQ96XiyjOf4mLDXFyvaygB9d
         KjVo8gN2pq1KsFxS1Gir/dr//zAqHhkJAi+hW+u151nTa9uDMS46O1Q7et81CyCAHYbn
         zldhG5jSpT833ymno7pxh63gnss638i+wMwEg6YUin3ILq8KsSCymskh2CkCRUsxLVPK
         HsjnAVNv0ut5/oka2+dtLFQnOw1M2GugoaEGIaGlRB2J6PBw3JqZ4FIs1XBEzUJeiyll
         ROXB+ou5/eCg7AJ4nnLD3jiy8Ei+8sbvZDyTriopLyUnR/5Zb7uvNN6SDijNtURdyK4c
         B+mg==
X-Forwarded-Encrypted: i=1; AJvYcCUOkQiD4htE5L5+0TSmtpZ+PRkWwHs8e7IzWxuWHlsxqaGBphGk4R+Y0zTFhEwD+VUtCxbsumFRa6Z1ck/5sJrL/exMVB95OnTbuGRRochF+sdw0DQL+I0sEyi865ZFY8FEKslp/WC7Y5dDHEIdgSUpsIu92mw4uA91HkO3
X-Gm-Message-State: AOJu0Yzx2YZzkGAaq1xVy78Pnc8oVRDaQCH2wPr4ftMLHa/fnT2v6ZAK
	iQUl1qZnh8ibZ9kv7FlSGWNOTQ/TVy6hsxdhuSFD1pW+0KjYBZsx
X-Google-Smtp-Source: AGHT+IFGh7TCiQVYt9mnW0TnwytSQeuz6H7Wje6MGjSHup+2uqOwzNsF+g21tmM03dC6ido3Tttubg==
X-Received: by 2002:a19:f506:0:b0:524:34ad:ba7c with SMTP id 2adb3069b0e04-52966d9d996mr1260613e87.66.1716557168974;
        Fri, 24 May 2024 06:26:08 -0700 (PDT)
Received: from [192.168.0.200] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5296e887a33sm181182e87.45.2024.05.24.06.26.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 May 2024 06:26:08 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <04a1543d-4156-4048-b4ec-99240a43d4c4@xen.org>
Date: Fri, 24 May 2024 14:26:05 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [RFC PATCH v3 10/21] KVM: x86: Fix software TSC upscaling in
 kvm_update_guest_time()
To: David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira
 <bristot@redhat.com>, Valentin Schneider <vschneid@redhat.com>,
 Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, jalliste@amazon.co.uk, sveith@amazon.de,
 zide.chen@intel.com, Dongli Zhang <dongli.zhang@oracle.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>
References: <20240522001817.619072-1-dwmw2@infradead.org>
 <20240522001817.619072-11-dwmw2@infradead.org>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20240522001817.619072-11-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/05/2024 01:17, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> There was some confusion in kvm_update_guest_time() when software needs
> to advance the guest TSC.
> 
> In master clock mode, there are two points of time which need to be taken
> into account. First there is the master clock reference point, stored in
> kvm->arch.master_kernel_ns (and associated host TSC ->master_cycle_now).
> Secondly, there is the time *now*, at the point kvm_update_guest_time()
> is being called.
> 
> With software TSC upscaling, the guest TSC is getting further and further
> ahead of the host TSC as time elapses. So at time "now", the guest TSC
> should be further ahead of the host, than it was at master_kernel_ns.
> 
> The adjustment in kvm_update_guest_time() was not taking that into
> account, and was only advancing the guest TSC by the appropriate amount
> for master_kernel_ns, *not* the current time.
> 
> Fix it to calculate them both correctly.
> 
> Since the KVM clock reference point in master_kernel_ns might actually
> be *earlier* than the reference point used for the guest TSC
> (vcpu->last_tsc_nsec), this might lead to a negative delta. Fix the
> compute_guest_tsc() function to cope with negative numbers, which
> then means there is no need to force a master clock update when the
> guest TSC is written.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk > ---
>   arch/x86/kvm/x86.c | 73 +++++++++++++++++++++++++++++++++++-----------
>   1 file changed, 56 insertions(+), 17 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>


