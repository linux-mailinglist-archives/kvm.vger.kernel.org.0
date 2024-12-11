Return-Path: <kvm+bounces-33480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 852C29EC7CA
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 09:54:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE64F1884900
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 08:54:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CE301E9B31;
	Wed, 11 Dec 2024 08:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="jgRS2uZJ"
X-Original-To: kvm@vger.kernel.org
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219741C5F12;
	Wed, 11 Dec 2024 08:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907262; cv=none; b=GKEn6Q3dk4X8yEpdMqVqWbKSU11Vhj4/HAlFOK7WSW5MZImWKwf2uwRJvxxXyHHCGXsJep1lQc85l2xh4Oha/8T1l9KbQWVNsfSee0HuK26RoMvpiMbj/HFUwX3fnnWdvRsMLJX58f10e61qXTm581nWRxgTO3ch3PdQ5xPFsdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907262; c=relaxed/simple;
	bh=gt/brD+bFKcK0ciXmNboabynGmPsZN1ysJlSHAaLOWs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=le5sjdv0s5tdFmEiHFtxliGmmJQ+8KSgplJQj7Ft1xA4d99Y1NHUDjIGmeOvztGB95a2NpZDxRzrndwL6do44GzP+IsOayvvh6ScVLAfU6WnggcM3haW7N8VygT2ikvd+3mOewFQx1G/2R1h6TQpVCaAcwo2wbus+tpq5pG2E/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=jgRS2uZJ; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4Y7TtJ3jS2z9snp;
	Wed, 11 Dec 2024 09:54:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1733907256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hgxGiDC40w1nBBtzUl+GNZ+rfEtSNj7LHPhUGuQr2aw=;
	b=jgRS2uZJNbPEVpIg0Vr8fWPf3xxgJzwuh4TArvMRlD9w4XwhDGYFI0KEyebhNhgGXe4GvS
	iwyXoiNqIxiTTd+my5L91J9W5hXPwfF2o/+9sXsMlNjlRqiph8c3vL4ZsMynrDI7EJtSn5
	8Zaj2Op4NrSS/426FhGFX91TSCSwX+JxNQ/+//7B+UpKmFonktE/Oil31RBk5UCkOrGPuv
	xm7KuTWswkAM8XaIaaoOmO6fYuufgO5dEpKI+UWu+68iVwOs+3DqAOtF3iSDCSGn6cuxjj
	vmvAMzEV/OSU1FN8zeOJu8kAM7bYRhqDuzMFB2bsW6C028mEFBGlqg1Z87EYEg==
Message-ID: <376c445a-9437-4bdd-9b67-e7ce786ae2c4@mailbox.org>
Date: Wed, 11 Dec 2024 09:54:14 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [REGRESSION] from 74a0e79df68a8042fb84fd7207e57b70722cf825: VFIO
 PCI passthrough no longer works
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 regressions@lists.linux.dev, Tom Lendacky <thomas.lendacky@amd.com>
References: <52914da7-a97b-45ad-86a0-affdf8266c61@mailbox.org>
 <Z1hiiz40nUqN2e5M@google.com>
 <93a3edef-dde6-4ef6-ae40-39990040a497@mailbox.org>
 <9e827d41-a054-5c04-6ecb-b23f2a4b5913@amd.com> <Z1jEDFpanEIVz1sY@google.com>
Content-Language: en-GB
From: Simon Pilkington <simonp.git@mailbox.org>
In-Reply-To: <Z1jEDFpanEIVz1sY@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-MBO-RS-META: 89z9y4wrg7c6jtbyixkhzihp6uj115ee
X-MBO-RS-ID: c5aa5748a771390c19e

On 10/12/2024 23:43, Sean Christopherson wrote:
> Unless you (Tom) disagree, I vote to simply drop the offending code, i.e. make
> all supported bits fully writable from the guest.  KVM is firmly in the wrong here,
> and I can't think of any reason to disallow the guest from clearing LFENCE_SERIALIZE.
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 6a350cee2f6c..5a82ead3bf0f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3201,15 +3201,6 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>                 if (data & ~supported_de_cfg)
>                         return 1;
>  
> -               /*
> -                * Don't let the guest change the host-programmed value.  The
> -                * MSR is very model specific, i.e. contains multiple bits that
> -                * are completely unknown to KVM, and the one bit known to KVM
> -                * is simply a reflection of hardware capabilities.
> -                */
> -               if (!msr->host_initiated && data != svm->msr_decfg)
> -                       return 1;
> -
>                 svm->msr_decfg = data;
>                 break;
>         }
> 

This also produces a good kernel.


