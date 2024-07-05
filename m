Return-Path: <kvm+bounces-20979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B7C19927FA0
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 03:17:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6494C1F221F3
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 01:17:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 968E71758C;
	Fri,  5 Jul 2024 01:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AkqqBvpx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6822014A81
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 01:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720142247; cv=none; b=gTyMxxkgrs9G0VuFQ88BmcITsxL+rz99kIK+RRknskr9EltXOVHNB+BAXgv+qr/XIFQcccCIvIy96Vo1tnMwCcCfF8+n+hUyQUDji2W0CRtWSU+qcSNZ6K1JDzrCHLCtYqMVhHKXzD1WZzwQoH1C5+mm3IL18DXuSZaA4EYiEbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720142247; c=relaxed/simple;
	bh=7KFDUQ4i2KfzsoICKnOvEAIga6Wr9YS9PFL1rZgpsZ8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XHvEDBQN5+bUj0/zjlFwQT83HqCM+uIZQnBvq8jjdy5cCiSGppSVWtO8L2FIJHrS1DTOkM/hq7ssDaV0WG0yKcrswEkddp0H2g8Xg0+aipXitdWd1eCQzaVMtEKhgUGUhjR8FpvgjYfW4cGcQ7LRW0buB08IwpWrRaa89+pQmCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AkqqBvpx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720142245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zv/K7RimCAw7h/gUAYVzyoMilwvhFYo3U7YRoPRf6MI=;
	b=AkqqBvpx5JS3DjDJNK0aK/tguQA4E30XuP+YR07yAkkuY2SifeoktIEtgCv2CIqYhksFMu
	3FM3Db9x+Lv6wLP78Ub0gvtAfZIgSdqdktjtRt/zUjlQOI5RjACB+MMEZZcgkR1IYTTjAJ
	o4YSYgq+5K7rCnUaM3jx3g6H3KY5ZAU=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-403-H8zWBlzDPPqOBV-b-wkVWg-1; Thu, 04 Jul 2024 21:17:24 -0400
X-MC-Unique: H8zWBlzDPPqOBV-b-wkVWg-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-444ff2c9a07so18491671cf.0
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 18:17:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720142243; x=1720747043;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Zv/K7RimCAw7h/gUAYVzyoMilwvhFYo3U7YRoPRf6MI=;
        b=Je2/SCKfwAca68K60ymChUqdgFH0n6hORM93ZukisX1Dw3H5ohpsXrXBPd3Gz/t1La
         SIY/3YUydLxFRcPsKIIMFPIVo3mVLgl38E4XQn1O90Hph9jA6rt+zwbI/JS+jtmk4+BF
         xoPg1UDzjSywhY4kUEkZK4HLGqRNP00eAZMlHnuAow7jHeC7Juy0lZBpW8KdcSc4rIXK
         B5DVZd4nC3aXsQXeEmrlaPP1U1+GE1GggkV3N79wyc/H6aAhD3kfsPMSuZ150RDzCiY8
         kdjt/4yC4aFqP7SgvnVtTZKPXuHUsQVF4tJi9xE/ANQw7eIJU09d9sNtcn4aR/IM5TbS
         R1Ag==
X-Gm-Message-State: AOJu0Yyeq1X2VBjx+hT1kCoI7ygJ7hth0Iqbuzmsu6NZaRm7B4iaSDPj
	9828IFKjY4zMaxowxVeMCLyqWg/3FuXXM8GAt1zGd36vlRaXT7eC+rKsDKrRHlqtgYm+Cah64oy
	pwSTHans4TOCm8wDpp61Pcn49V4W0GbeypctYPAKvVteYRO8Zhg==
X-Received: by 2002:a05:622a:4d:b0:446:5cb4:aee5 with SMTP id d75a77b69052e-447cbf9bd8bmr39804501cf.57.1720142243592;
        Thu, 04 Jul 2024 18:17:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEvciF+mekL9iBg4wcfjxsPvLLuu3SDUytKN7W+i5u1R6EpX/zdVmucz/6HcD89Vrn16hFjSA==
X-Received: by 2002:a05:622a:4d:b0:446:5cb4:aee5 with SMTP id d75a77b69052e-447cbf9bd8bmr39804311cf.57.1720142243287;
        Thu, 04 Jul 2024 18:17:23 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-44651428177sm65231371cf.40.2024.07.04.18.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 18:17:23 -0700 (PDT)
Message-ID: <5d27e799daf7677a8d26c7769a5d24b6d3459aa2.camel@redhat.com>
Subject: Re: [PATCH v2 13/49] KVM: selftests: Fix a bad TEST_REQUIRE() in
 x86's KVM PV test
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 21:17:22 -0400
In-Reply-To: <20240517173926.965351-14-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-14-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2024-05-17 at 10:38 -0700, Sean Christopherson wrote:
> Actually check for KVM support for disabling HLT-exiting instead of
> effectively checking that KVM_CAP_X86_DISABLE_EXITS is #defined to a
> non-zero value, and convert the TEST_REQUIRE() to a simple return so
> that only the sub-test is skipped if HLT-exiting is mandatory.
> 
> The goof has likely gone unnoticed because all x86 CPUs support disabling
> HLT-exiting, only systems with the opt-in mitigate_smt_rsb KVM module
> param disallow HLT-exiting.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/x86_64/kvm_pv_test.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
> index 78878b3a2725..2aee93108a54 100644
> --- a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
> @@ -140,10 +140,11 @@ static void test_pv_unhalt(void)
>  	struct kvm_cpuid_entry2 *ent;
>  	u32 kvm_sig_old;
>  
> +	if (!(kvm_check_cap(KVM_CAP_X86_DISABLE_EXITS) & KVM_X86_DISABLE_EXITS_HLT))
> +		return;
> +
>  	pr_info("testing KVM_FEATURE_PV_UNHALT\n");
>  
> -	TEST_REQUIRE(KVM_CAP_X86_DISABLE_EXITS);
> -
>  	/* KVM_PV_UNHALT test */
>  	vm = vm_create_with_one_vcpu(&vcpu, guest_main);
>  	vcpu_set_cpuid_feature(vcpu, X86_FEATURE_KVM_PV_UNHALT);

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


