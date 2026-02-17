Return-Path: <kvm+bounces-71159-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id NYzJESCMlGn6FQIAu9opvQ
	(envelope-from <kvm+bounces-71159-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 16:41:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AA2EF14DA77
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 16:41:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 05A3C301AB99
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 15:41:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A813836C5AF;
	Tue, 17 Feb 2026 15:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wQSduV3i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4AEC36C586
	for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 15:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771342871; cv=none; b=ZVgCuqaTikeuxhDCMTgaN9kcsxrmAensjW/NTVnP6DqPSvwq6sQjJJ8wp87GNbN0PyNDvOrfiHw8dDW9db6TtTs5RzWkWKDwHxtjoIX49T6RwA/k8Ldi1Yu1fDMnz0i0+zP0LguGBuUrA74tukBqGzoe4o/c7IJXoGQ1mKOdQP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771342871; c=relaxed/simple;
	bh=YTanmRYEgpEHKRXP28nQ4qOeELASrBPVyUuhx8CtiBs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YTbSwsY0SWa5Ff82RoqBqKceZ7C6/0LGunq2jZV6r6Nya58tSJJPs47K365oHfJdbm6TOmfp+XXChtTQaoKSrgujYVERcRm2unsfRSLT0xSV4i2DUbKuJEmZDbbCX216lAuGzA5ps8l/faeNXaBvjJfyxe0JATD172A6y3VGa/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wQSduV3i; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b6097ca315bso17738968a12.3
        for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 07:41:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771342870; x=1771947670; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bjU4x0MpvHQ651ct0W6WyJizCAzDQ5P6Z6Jf42LSxUU=;
        b=wQSduV3iY/NEMcmMqGmhMbcNPkCQahje6QSWYcgH75wAfnOMHW/xnZ6+GHSOjpCyP6
         w02TeM/fehEoQ0ZPXDdxWiK5IvJrAuGKwdlmEeNj9EbEGEN4EUWHIEKLANhzxEYn0CVM
         j3CUymnE90nlQ+HIO0t0eyJbhxxe6h1thGQ5kuf9MRcGFjqwuDNR0Vvgqli0HERwRhyu
         mQHjtKlJ+O1zlKyXk8xGMaZZxcV4LHkGEgfNq/dye9RxPN53G/l+gEhaMDeoCX08BYZn
         /FeT6kFHc8HJT4Z/vot02UKaCilatv43vhug5+w9xmayHfXisj3AJrnHTxj5AzrcHBM4
         PJYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771342870; x=1771947670;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bjU4x0MpvHQ651ct0W6WyJizCAzDQ5P6Z6Jf42LSxUU=;
        b=IXlVWyhcJXnBHM/ZtdbihS2D77UtKRYsNtq7UugFPqLbLvuIPJ8ZtB0aa2LhRmIC4I
         pIMUOlHk6hzLyFvjnHh95pg4Y8s9kcUlX9+/yivtoEd0trPsbX4YgIQWrnSnQGc+zwpI
         f9CBzgchcWO6mSGBnAkdR8EsyV0DCCn1uEn13nyqxcdTzwz9DZ/0Cql1PTDCzhysyhuz
         eC23LO6FcE2bV3INgxRKBkOm2B8FJiDmdWMMaIgHyHxg29DKBB4ZTZ0QThZ1Rcfn7Ayu
         2uPiOjP+FvsNpnZ2368WTD5nw05LoUycjRmipclJ9oAlPrIOh4eytz3vbdyCb6/OpslJ
         MQeQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4bmr86map0Z9Qyuq1ByQFMHsAj6hUj2Gv0Tt8wp2U4FY8knQ2kj9e0aEpDzCXYZ4v0oE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz91mbMo0juvmjv+H2FyxwH5KjyUputeoHawMcQvCUZwyHdEjIz
	Z4HnRZn04txvQXesbQFYVzI3ZvlDn3wjX3imx7OOgdlFgrz92nhwbSVVvJ6AF4H9B0QmXlLg0vD
	soX1Weg==
X-Received: from pgg23.prod.google.com ([2002:a05:6a02:4d97:b0:c6d:c1c4:8cf5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:cf8d:b0:38e:9c64:bd39
 with SMTP id adf61e73a8af0-394672ce209mr14662564637.44.1771342869976; Tue, 17
 Feb 2026 07:41:09 -0800 (PST)
Date: Tue, 17 Feb 2026 07:41:08 -0800
In-Reply-To: <tencent_A1CC0E76805991513AA0C982068255A6A306@qq.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260215140402.24659-1-76824143@qq.com> <tencent_A1CC0E76805991513AA0C982068255A6A306@qq.com>
Message-ID: <aZSMFPgRO6s_fUQO@google.com>
Subject: Re: [PATCH 2/3] KVM: x86: Skip IN_GUEST_MODE vCPUs in
 kvm_vcpu_on_spin main loop
From: Sean Christopherson <seanjc@google.com>
To: 76824143@qq.com
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, zhanghao <zhanghao1@kylinos.cn>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71159-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[qq.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kylinos.cn:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,qq.com:email]
X-Rspamd-Queue-Id: AA2EF14DA77
X-Rspamd-Action: no action

On Sun, Feb 15, 2026, 76824143@qq.com wrote:
> From: zhanghao <zhanghao1@kylinos.cn>
> 
> Add a check in the kvm_vcpu_on_spin() main loop to skip vCPUs
> that are already running in guest mode.
> 
> Reduces unnecessary yield_to() calls and VM exits.
> 
> Signed-off-by: zhanghao <zhanghao1@kylinos.cn>
> ---
>  virt/kvm/kvm_main.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 476ecdb18bdd..663df3a121c8 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4026,6 +4026,10 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
>  		vcpu = xa_load(&kvm->vcpu_array, idx);
>  		if (!READ_ONCE(vcpu->ready))
>  			continue;
> +
> +		if (READ_ONCE(vcpu->mode) == IN_GUEST_MODE)
> +			continue;

This should generally not happen, as vcpu->ready should only be true when a vCPU
is scheduled out.  Although it does look like there's a race in kvm_vcpu_wake_up()
where vcpu->ready could be left %true, e.g. if the task was delyed or preempted
after __kvm_vcpu_wake_up(), before the "WRITE_ONCE(vcpu->ready, true)".  Not sure
how best to handle that scenario.

> +
>  		if (kvm_vcpu_is_blocking(vcpu) && !vcpu_dy_runnable(vcpu))
>  			continue;
>  
> -- 
> 2.39.2
> 

