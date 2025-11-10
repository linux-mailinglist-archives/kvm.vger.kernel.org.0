Return-Path: <kvm+bounces-62515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 42337C47846
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 16:26:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 78AB84F3127
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 15:19:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 226C523D2B2;
	Mon, 10 Nov 2025 15:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FSf2bZdP";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="J6SfizIQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7798A18DB37
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 15:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762787934; cv=none; b=iKlwlMYaC+9Y3qVqkCxIYXPxE6WhEUWHymypKDgLuWNff9aPnjroPPhcEIMPVltVKWuMRwB081GbykJJjLGkmn5zDkT4e3IUYiRyW31AZjshiOLMU9BkxnQISp78h4n+PKVOibiaLBXrEMW/osMT331Z5cl1Rc3zckMzpHWT8Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762787934; c=relaxed/simple;
	bh=ipX76GJ+E+MU92+t7o//0oqh+sfpvzqejU1G4XYNo1o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MwhMH/e3W72I1Bj8zqAKfqn6a9MdiIizBWT13LFgCkjy9CqPP0O9LxoIgI1LE1/D1G3yGntZYR+WEln/pJiVqUyKmfVWU9+sTOrgO6wYYfenDcX+mq+MRQT0n306vce81DY9kYUrtPUWEzPWNs9L0C3LCOjrfO1+s/vyot2e9eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FSf2bZdP; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=J6SfizIQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762787931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AlA+x0tRAsBDGTDa9nRiETe1XJez8KQz5PhSrdYv6ys=;
	b=FSf2bZdPyXz4BPBHFx70cWxbGN5oqjZFP/4/s+5rV9tvJf5Ys+vLlwtVrQcUReeQ/YO6dx
	B0PRLQr+xiBig08K+msob//izGRcuZaMmtL/g6YcbWo7AhZVYTwCAkb/Xyg2q973KvcZ5A
	d+or1Tg+OvpDW5OHx7uigg1VpC/gTck=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-543-PIcJkFp3M_WFqEh2mEA90w-1; Mon, 10 Nov 2025 10:18:50 -0500
X-MC-Unique: PIcJkFp3M_WFqEh2mEA90w-1
X-Mimecast-MFC-AGG-ID: PIcJkFp3M_WFqEh2mEA90w_1762787929
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-7a9fb6fcc78so2458492b3a.3
        for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 07:18:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762787928; x=1763392728; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=AlA+x0tRAsBDGTDa9nRiETe1XJez8KQz5PhSrdYv6ys=;
        b=J6SfizIQTfgOSs7RVTnbI68sLJ8L3ozByVForhOJDam7Jlh0cETc2kakFalNEWYXxx
         sQr4OqlUXPVISE3r3MWNxQbtxQv16SDfIKv+l2FnOiWBQyBY/+V89atJ4mK8bhD1MCnW
         UlPiToOZLxv0zjA2gHEIAFw/jxRbxplXB4k+PswjR9sG8CyCgUsscc6AYvM0dg43dAbQ
         N/RtsOal5RZZTbdclUDWfej+3KBZHCVNbuuf9u8Z98VDJYhKj4FedoQ9VYhxmCYvNKzl
         L0K0Suw4uhQI8aRAUwRdzQhsXAoWCmblbIsXwBVTj+PLbKBUkM2t0jH6X1/OAeyknBL2
         g7GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762787928; x=1763392728;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AlA+x0tRAsBDGTDa9nRiETe1XJez8KQz5PhSrdYv6ys=;
        b=q7a572hAkGLvqAjDAO6pA74YmMOi39rMz/3kLXz4T1Qw6pAB6HzHw+S0C+Ah0j6A2k
         3hpmt+2HVHdjgKnP9tES/cg+B1GKDxJBcWGmfU2BThz2pwY4SxVJwWwfNq0bUO8NOiJp
         gJ/CqsbajtPDpcQaWfU74SHA0XW6atzDlfsto2DWnf5np5c3Z2jIwKvDpf0KkXRR7T30
         vggufDByabzm4kHV7ZWE5rhz+ie4cbfHNQfsmXbk6vbHvVF28iWWcY1ICMCy79/kNhRK
         VIN5eZmR1sUaeprUd6oj7l4GmI26Sau8sAHHlg/xCu9O7ec5hpa5jn/QvAnBefA+nmQP
         nmBw==
X-Gm-Message-State: AOJu0Yy4y4YibhvROXiKb8QliOM9XJJsdxwRvP1GJK1bgspf19BH3uUf
	uQthXIJg60Wtn/Lps3oaiyLxgvC7LlYLPONTTzpHhSrWIbl84tqsCJ44dRFhiPtLObVQcivwsKR
	Uv3I0xTMAfAVu0DcP2ftbruNkutYnonXr8ZniXxbZpfEZd70MwEVDj65hqpHScA==
X-Gm-Gg: ASbGncvunX2bnuANPB5BEl8zpIUpPSbvyQtFLEPtkugYsXVoN5RLHa01G/laVTLHEI7
	VR7M0EgjIfDWN85WD1GIlyCwqTFKqm+wVZg68sNZTQSTHSL+byu+wOPo92RM1Ims9LSsDBWfDt3
	S1/4sQIyXgVwxVqXa/CsPjftrmnFE6DqAAIyv3x1JiYGIA7CSHymi7Xl3FM1p6QQsN86MlvFEoj
	WAEZ61GK6g7dCUMbvX6ppTKIFrhT5OOkQlpd+Skfa1NVJ0nj2PntqhhR6XgrFmdsdwZIXgQ7Z/A
	JauQLkNk6etGkOQg77n6XqRNVerfCG5is+DBrzGoyjt7mRmmtsD7X4vr893yP8xPOniEUDzstff
	zmL3Q9PnXg/vT5nSBdyPfnPREVw5abEnNkn1zv0gmQkILyleuUZAQLfTeXrAmzt3S8gWRNJMRP4
	hhdv8qgZsgj1IyGV/+FroF6WCPnrvc
X-Received: by 2002:a05:6a20:5483:b0:342:873d:7e62 with SMTP id adf61e73a8af0-353a2d42046mr10053485637.29.1762787928212;
        Mon, 10 Nov 2025 07:18:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH2rcG42hzb4L/Vmwsv1WFpuCX/wTouXy7m9UtumHSxM2ed5rjvQJY8JW0zkSSyPLbwhXkjug==
X-Received: by 2002:a05:6a20:5483:b0:342:873d:7e62 with SMTP id adf61e73a8af0-353a2d42046mr10053435637.29.1762787927572;
        Mon, 10 Nov 2025 07:18:47 -0800 (PST)
Received: from [10.201.49.111] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-7b0c953d0a6sm12124750b3a.12.2025.11.10.07.18.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Nov 2025 07:18:46 -0800 (PST)
Message-ID: <e47c4e56-d279-4aa8-8e78-ca1fe77b9f3e@redhat.com>
Date: Mon, 10 Nov 2025 16:18:38 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Enforce use of EXPORT_SYMBOL_FOR_KVM_INTERNAL
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chao Gao <chao.gao@intel.com>
References: <20251106202811.211002-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20251106202811.211002-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/25 21:28, Sean Christopherson wrote:
> +# Fail the build if there is unexpected EXPORT_SYMBOL_GPL (or EXPORT_SYMBOL)
> +# usage.  All KVM-internal exports should use EXPORT_SYMBOL_FOR_KVM_INTERNAL.
> +# Only a handful of exports intended for other modules (VFIO, KVMGT) should
> +# use EXPORT_SYMBOL_GPL, and EXPORT_SYMBOL should never be used.
> +ifdef CONFIG_KVM_X86
> +define newline
> +
> +
> +endef

$(newline) is already defined in scripts/Kbuild.include, is it necessary 
here?

> +# Search recursively for whole words and print line numbers.  Filter out the
> +# allowed set of exports, i.e. those that are intended for external usage.
> +exports_grep_trailer := --include='*.[ch]' -nrw $(srctree)/virt/kvm $(srctree)/arch/x86/kvm | \
> +			grep -v -e kvm_page_track_register_notifier \
> +				-e kvm_page_track_unregister_notifier \
> +				-e kvm_write_track_add_gfn \
> +				-e kvm_write_track_remove_gfn \
> +				-e kvm_get_kvm \
> +				-e kvm_get_kvm_safe \
> +				-e kvm_put_kvm
> +
> +# Force grep to emit a goofy group separator that can in turn be replaced with
> +# the above newline macro (newlines in Make are a nightmare).  Note, grep only
> +# prints the group separator when N lines of context are requested via -C,
> +# a.k.a. --NUM.  Simply request zero lines.  Print the separator only after
> +# filtering out expected exports to avoid extra newlines in the error message.
> +define get_kvm_exports
> +$(shell grep "$(1)" -C0 $(exports_grep_trailer) | grep "$(1)" -C0 --group-separator="AAAA")

Maybe replace AAAA with something less goofy like !SEP! or similar?

> +endef
> +
> +define check_kvm_exports
> +nr_kvm_exports := $(shell grep "$(1)" $(exports_grep_trailer) | wc -l)
> +
> +ifneq (0,$$(nr_kvm_exports))
> +$$(error ERROR ***\
> +$$(newline)found $$(nr_kvm_exports) unwanted occurrences of $(1):\
> +$$(newline)  $(subst AAAA,$$(newline) ,$(call get_kvm_exports,$(1)))\
> +$$(newline)in directories:\
> +$$(newline)  $(srctree)/arch/x86/kvm\
> +$$(newline)  $(srctree)/virt/kvm\
> +$$(newline)Use EXPORT_SYMBOL_FOR_KVM_INTERNAL, not $(1))
> +endif # nr_kvm_exports != expected
> +undefine exports_advice
> +undefine nr_kvm_exports
> +endef # check_kvm_exports
> +
> +$(eval $(call check_kvm_exports,EXPORT_SYMBOL_GPL))
> +$(eval $(call check_kvm_exports,EXPORT_SYMBOL))
> +
> +undefine check_kvm_exports
> +undefine get_kvm_exports
> +undefine exports_grep_trailer
> +undefine newline

(if the definition is not needed above, remember to remove the 
"undefine" here too).

Thanks,

Paolo


