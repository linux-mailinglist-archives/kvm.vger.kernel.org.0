Return-Path: <kvm+bounces-51770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 67672AFCD89
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 16:27:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 305771C20FB0
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 14:26:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 842332E0B64;
	Tue,  8 Jul 2025 14:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TMfhbosk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342C72DEA98
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 14:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751984697; cv=none; b=loY6rDZAoxvstgXgEaSioqNfrY+fNFORmBOhEsXR1/8d39RLpw0M/vJAqW+L/U6nF5YnbA9AedEAB8NUj5auuCS1YutUb5qDKnQf2Gtx35IZYQJOwtqNnCeCkjnfdv3g3NMDwxKtlm2MQHfXGtCXIYl5XjV9Nr4SblJKFYNWPAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751984697; c=relaxed/simple;
	bh=B+JOpbrgnQUARzMxGPuyQzQbSxpka8rFnoYh0/4Z1KA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EEgMpEwpX+9j7uVIw7gkQCrZ+1yHMIQ2qzZbzblPro8IA1MtJdbGiwKJwRmtboV8x/8OGpzHkTNzCIWBcyGMZPg1xNtJ9EjI3kq5PViN5ry4YZpiFiTfH7WCmVNf6hJfazR3HG6ST4NzkUwc9Hw0eyap0oZjb/HAADNgpwOFHgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TMfhbosk; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3a4f72cba73so3536665f8f.1
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 07:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1751984692; x=1752589492; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=aGD5qf+W7iUuNQ0dw7d26qPURGpSWS6QvwWe8Qj/asg=;
        b=TMfhboskROtal/Z5evIqnxlGTwUW+C50ir/sD81DkDtvlxnkYir4EQ5RHW257gGp5E
         uZrPdpGa4wYqErExkzYT/LkTtUQAtJDxEbwTbMs/Pu8P6465vBL67zsKxViLSo22Djko
         jLrAyIsaAjIQmfhLihciTEOSwE7oHP4NebBCJoLuFlpdz/y9y8S2EUzFUEVGfNOpLjXR
         NOc50L4je/mEKpHT32AJoYe6QveSYO6e+7oZtNXf0YiFpdxouA679E5TQfvA3zX6N4MG
         +DnYX9TuHxjjkixbXyZ2+pTvomnTKecNG8HNI4zREd9s//mpJjzpBd4sKp0tQg5uGSX3
         BbBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751984692; x=1752589492;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aGD5qf+W7iUuNQ0dw7d26qPURGpSWS6QvwWe8Qj/asg=;
        b=RAIaovZ6JrH8pTaxXUcLCN8x1O9oCXKci4pek1KCagDiwb8+GYjDwm/kuNWHenPyRL
         IMZsP6oWUi2lcdRI8ubla0JU4EnrvIJEi+sxA4+AvTrRCa8FdQNqk5bSZ9/GEpLiegN1
         5m2r4SrDUcDA1b3QWNwNn0NFvKVGjiGXn+Ugkqseder7+odSGqKoHkCUGn/bniABPrRl
         /RUeBmqzQdGX1hpJJVfkMaeDQve9cGuEOoHjq3Zy8KBI8pAcqxC0ABgUBU+BDzWhz2oQ
         IR3v3Wo5i+TfFNyE3Vkcg71Ut8R56PlcHQJCkGIvut5BuW7UZbCE1+hcWzWRezZVo3lp
         79ig==
X-Forwarded-Encrypted: i=1; AJvYcCUUiEPQl6mIPMGaksIEX8/idqrSErptgegbFwS5Xsz/SgYVlXKJbHV9TJidWJ4QAU0bc7E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxq5TRVm2+2c9fOPfrrUTQ1EcyMpuVoXosTxy3dA2OHSj0HA1EH
	SW/2Ed49pxX/cL9jeX3b7zePujJwPcE12C5Tf/Rb1gcW8Tjw3NuK/UjTdi+/H3wOf4A=
X-Gm-Gg: ASbGncs64Kq4T2AziuS0TpZDauU5HmbnbCy4haIiL9o0bT8OHgTYSmkFQBLHZbWiVhu
	yS9CO0uesvouyyXwaF6DB7eg3NDyOhVJ9pDaH2AOxPqpeby7ZYFKsVzvi3X4NeKMLDeONUGEElj
	3ePu1mFUbp+a2999sVpWGAC/VRda3ojBQkW/u4w0mbVthoZBwVJo3P1jZHuapqhNylFVjAQiVxG
	q8fZKYprAcr6xJVbuNvp4MPe8y0kTfaRHuACSzyt8HJq4ibS1ZzPrfYYz9EK1eeqy04q++r0q9x
	eIViU68NfTNsKrfy8/WsWA3xt8eKHn2Bk70hqNF9lvFn7PC2z/rpkz6yEGVr5kmvjEJ6duW9qN1
	XzGCiRSMsLrY3Eg==
X-Google-Smtp-Source: AGHT+IG0irpwA7N5b4P0TSBLPOgiP6YNu1Phtt6O8oEGN9SQbgz/Iv4AemaHRchokErh3x8EtRRO/A==
X-Received: by 2002:a05:6000:25c1:b0:3a5:8601:613b with SMTP id ffacd0b85a97d-3b5de124084mr2471405f8f.20.1751984692315;
        Tue, 08 Jul 2025 07:24:52 -0700 (PDT)
Received: from [192.168.0.20] (nborisov.ddns.nbis.net. [109.121.143.125])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b47030ba54sm13010634f8f.8.2025.07.08.07.24.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jul 2025 07:24:52 -0700 (PDT)
Message-ID: <bff2170d-680a-489a-8f38-605e37624037@suse.com>
Date: Tue, 8 Jul 2025 17:24:50 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] x86/kvm: Force legacy PCI hole as WB under SNP/TDX
To: Sean Christopherson <seanjc@google.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Dionna Glaze <dionnaglaze@google.com>, Peter Gonda <pgonda@google.com>,
 =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>,
 Kirill Shutemov <kirill.shutemov@linux.intel.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
 Binbin Wu <binbin.wu@intel.com>, Tom Lendacky <thomas.lendacky@amd.com>
References: <20250201005048.657470-1-seanjc@google.com>
Content-Language: en-US
From: Nikolay Borisov <nik.borisov@suse.com>
Autocrypt: addr=nik.borisov@suse.com; keydata=
 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
In-Reply-To: <20250201005048.657470-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/1/25 02:50, Sean Christopherson wrote:
> Attempt to hack around the SNP/TDX guest MTRR disaster by hijacking
> x86_platform.is_untracked_pat_range() to force the legacy PCI hole, i.e.
> memory from TOLUD => 4GiB, as unconditionally writeback.
> 
> TDX in particular has created an impossible situation with MTRRs.  Because
> TDX disallows toggling CR0.CD, TDX enabling decided the easiest solution
> was to ignore MTRRs entirely (because omitting CR0.CD write is obviously
> too simple).
> 
> Unfortunately, under KVM at least, the kernel subtly relies on MTRRs to
> make ACPI play nice with device drivers.  ACPI tries to map ranges it finds
> as WB, which in turn prevents device drivers from mapping device memory as
> WC/UC-.
> 
> For the record, I hate this hack.  But it's the safest approach I can come
> up with.  E.g. forcing ioremap() to always use WB scares me because it's
> possible, however unlikely, that the kernel could try to map non-emulated
> memory (that is presented as MMIO to the guest) as WC/UC-, and silently
> forcing those mappings to WB could do weird things.
> 
> My initial thought was to effectively revert the offending commit and
> skip the cache disabling/enabling, i.e. the problematic CR0.CD toggling,
> but unfortunately OVMF/EDKII has also added code to skip MTRR setup. :-(
> 
> Sean Christopherson (2):
>    x86/mtrr: Return success vs. "failure" from guest_force_mtrr_state()
>    x86/kvm: Override low memory above TOLUD to WB when MTRRs are forced
>      WB
> 
>   arch/x86/include/asm/mtrr.h        |  5 +++--
>   arch/x86/kernel/cpu/mtrr/generic.c | 11 +++++++----
>   arch/x86/kernel/kvm.c              | 31 ++++++++++++++++++++++++++++--
>   3 files changed, 39 insertions(+), 8 deletions(-)
> 
> 
> base-commit: fd8c09ad0d87783b9b6a27900d66293be45b7bad


This prevents TPM from functioning which in turn breaks attestation on 
TDX enabled guests. So what's the status of it?

