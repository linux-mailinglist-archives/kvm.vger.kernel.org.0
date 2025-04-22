Return-Path: <kvm+bounces-43839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CB274A9732E
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 18:58:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04F3E17C10A
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 16:58:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A3E729617B;
	Tue, 22 Apr 2025 16:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ItTTByQZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CB8199252;
	Tue, 22 Apr 2025 16:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745341095; cv=none; b=PX7wvr1MvJ5B9ALfK5VwlvBYL+H3HwkjIrvjvZ9PZYikcV2atiAFYaF+TAMrvhlBjokEN8k9dIpGq8pc/hP2CIm6anoBfCd6eRy6lNC5HXGToL9XH4Bb6va00ZQMU7/IWqthSKEd8/g8zNQFaWdS5sf+x1ye4RjJs+Z8dgkSHwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745341095; c=relaxed/simple;
	bh=MuvQcvSlnU7agw/bUMjmKpAtXZ7ze4XGy/lS5CtGSlw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:Content-Type:
	 MIME-Version; b=l7vgIstATMrYlD7SZtD/HyWF8kPrsnc03UihozwWoMaNo3yol248Hy7IFwWdKdLcNJ2w4/afSfRj8q/BPlcm1wwhvtk3Bv9maBOu9uuXCIvvRt3I4TdwMJXVKrhdyatUkR57Dgqjk8UEH69FFrJP2ZLdEiKysZj8b9IcprF6lIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ItTTByQZ; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43cfba466b2so54988425e9.3;
        Tue, 22 Apr 2025 09:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745341092; x=1745945892; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tU9oZ884evBT7E6EQ/eFqXnt47vbNQSdohv2MRLF06o=;
        b=ItTTByQZ8xdOClh3TozpmYb9u6/H9nKoPc9CygV39BTzypQxoirbqtAdEUhFxRiOJV
         Of0+AZxJovA7pqZAOXn8s3w8kSWRS3LuBBjAibDI23I0GEk2QTGiseg52ByXIQ7sPMg+
         ayu71oUCFKA6z6M3Z0pP1vY6rqpo3fs41JIk4fZDQEFIa/8TDYGWb5JcQH6krGQYXwgj
         MmLqDXnv3WVS9P0aIgvbajgE9/bVv9J8P+4zfNhJ7UYehDF9lYv7UqJtuadLQYCD+IqP
         X93vEOmYfCn6gbNrCrsAeUhncgRHf69+VvrQHEWLHkln/JYOwDggaumEPJs1orGTsQHw
         U8TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745341092; x=1745945892;
        h=mime-version:user-agent:content-transfer-encoding:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tU9oZ884evBT7E6EQ/eFqXnt47vbNQSdohv2MRLF06o=;
        b=GSyqT5V8L0Sc6I5CsN86rEY+Hsjk+bNRdAMPFugqRM40VkGJXZw8zs2AMsCd8qZDKf
         RgPO5G2ztqJFi7EjTcCEx+xPA0v3zdLHJmU8CZ9MUb2xSs26OF/uEEmvvvJhgIzDF5ae
         PgOFxqf2Ixjr1MWRNGUTbx5sj9fCLfHfh72WffnWzEqCpSh885yTmiGMIGLP2uAGuNG7
         Zxbqn2vk703dJr0eyh7MA7hT4qcGnFsxcwxZrASOKpmsOrdLJVZ7ev49qIgVQzcw4AKO
         Mb3y0h/LC3OETh6oBxHQm5MzhqeEjVBecokqr4BlKWlarYJQsB61Bp6ckN/b3/YkHLIe
         uUkg==
X-Forwarded-Encrypted: i=1; AJvYcCWfbavWqbHHmhWWB4kt4RT3+l8abKow2TutbWYG8eExLbMiB5iakdVT/FFWZaKaEu0ylk9uXJlw/MEGSDOk@vger.kernel.org, AJvYcCXzDt8rgngrszuqBd94uHx2ViJACp4aK7ppXOV990qWRgvo+Cb+AsFRvWIKbTpP5dSOw5w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbJ/Y2WLvrcykC+iofDdeAWQMk1vvSP4Whr8SR2aruDTm8/lwB
	KhBruHprBOAfkE/y5xTf4e6tLS/lS7M2QBRdjMJJGNbRHvPyrMxx
X-Gm-Gg: ASbGncvFhRlT03h659G8H4laALZBIxgrG9ErEGY4u0NmJP2TJSvc619AvPvi6KIhsLz
	hljV6/cLgKQXL082cH6W1a22EH1W24vltMG4Dibk48+GfyoSwgBzPT+9YUPv+01CHNsLGoyA1BA
	ycNichWq+jR57Cyzc0/neI/b6zo8S79I+QzyczpaFhpz1GDYPzQe7uIrKHe3y1a/VYBt65Be1BA
	MMDQL4sUiop1VDpTFGwK68jTS9IeGarUZ6v2Jxv0iyBUFgHbMiHH43le8mQVP1u6GjHmjY7FDHb
	KWmNMhzShgPGHZUmNO/yKMHPYLhUO+/uHvcRZRKv3TOXnNd2kG9ljZkuVMTPFMtN2EmzF6z6w61
	x/2YWKa7hF/ApykdJ
X-Google-Smtp-Source: AGHT+IHVBaYXCX7qFfXSGkqr4QiGl5ketILWsNr5eJOqEJhns7Naep0WKAvAocMkHFiNSrbYcxY5BA==
X-Received: by 2002:a05:600c:5491:b0:43c:fbe2:df3c with SMTP id 5b1f17b1804b1-4406abf9a9amr132717295e9.26.1745341091991;
        Tue, 22 Apr 2025 09:58:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:5d29:f42d:c9a:5c6:9f25:55f5? ([2001:b07:5d29:f42d:c9a:5c6:9f25:55f5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4406d5cf3a7sm181855015e9.32.2025.04.22.09.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Apr 2025 09:58:11 -0700 (PDT)
Message-ID: <75aa80eeecb66050d80c2c6a793c6c20fab22a0f.camel@gmail.com>
Subject: Re: [PATCH v2 1/5] KVM: x86: Centralize KVM's VMware code
From: Francesco Lavra <francescolavra.fl@gmail.com>
To: zack.rusin@broadcom.com
Cc: bp@alien8.de, dave.hansen@linux.intel.com, doug.covelli@broadcom.com, 
 hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 mingo@redhat.com,  pbonzini@redhat.com, seanjc@google.com,
 tglx@linutronix.de, x86@kernel.org
Date: Tue, 22 Apr 2025 18:58:10 +0200
In-Reply-To: <20250422161304.579394-2-zack.rusin@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On 2025-04-22 at 16:12, Zack Rusin wrote:
> Centralize KVM's VMware specific code and introduce CONFIG_KVM_VMWARE
> to
> isolate all of it.
>=20
> Code used to support VMware backdoor has been scattered around the
> KVM
> codebase making it difficult to reason about, maintain it and change
> it. Introduce CONFIG_KVM_VMWARE which, much like CONFIG_KVM_XEN and
> CONFIG_KVM_VMWARE for Xen and Hyper-V, abstracts away VMware specific

s/CONFIG_KVM_VMWARE/CONFIG_KVM_HYPERV/

> +static inline bool kvm_vmware_is_backdoor_opcode(u8 opcode_len, u8
> b)
> +{
> +	switch (opcode_len) {
> +	case 1:
> +		switch (b) {
> +		case 0xe4:	/* IN */
> +		case 0xe5:
> +		case 0xec:
> +		case 0xed:
> +		case 0xe6:	/* OUT */
> +		case 0xe7:
> +		case 0xee:
> +		case 0xef:
> +		case 0x6c:	/* INS */
> +		case 0x6d:
> +		case 0x6e:	/* OUTS */
> +		case 0x6f:
> +			return true;
> +		}
> +		break;
> +	case 2:
> +		switch (b) {
> +		case 0x33:	/* RDPMC */
> +			return true;
> +		}
> +		break;
> +	}
> +
> +	return false;
> +}
> +
> +#else /* !CONFIG_KVM_VMWARE */
> +
> +static inline bool kvm_vmware_backdoor_enabled(struct kvm_vcpu
> *vcpu)
> +{
> +	return false;
> +}
> +
> +static inline bool kvm_vmware_is_backdoor_pmc(u32 pmc_idx)
> +{
> +	return false;
> +}
> +
> +static inline bool kvm_vmware_io_port_allowed(u16 port)
> +{
> +	return false;
> +}
> +
> +static inline int kvm_vmware_pmu_rdpmc(struct kvm_vcpu *vcpu, u32
> idx, u64 *data)
> +{
> +	return 0;
> +}
> +
> +static inline bool kvm_vmware_is_backdoor_opcode(u8 opcode_len, u8
> len)

Nit: even though this is just a dummy function, its second parameter
`len` appears misnamed and for consistency should be named the same as
in the CONFIG_KVM_VMWARE function, i.e. `b`.

