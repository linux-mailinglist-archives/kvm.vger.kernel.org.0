Return-Path: <kvm+bounces-34010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61FC29F5ADD
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 01:01:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9525C165F9A
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 00:01:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B85B776410;
	Wed, 18 Dec 2024 00:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P42JQ0QB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496F928EA
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 00:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734480045; cv=none; b=c+ndV++vRsVtRkAWEKiRlme/IUGrkcZ0Twh9H2ClQC/CpLZN9Y9A7DpPFMi5GKKwv/GB/DpZuCSsuP1ThqP+2mZkRovg09/ymA3PMupPIgpmd+AxSu4o+gyV2rnQrniaDkl/cl3UmrFcOzqhfBE9RDeqDhIcnqbDb2KZHrds6PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734480045; c=relaxed/simple;
	bh=IEclRw50IlWafe/HOJ55QWSCxVIkHZZ0nGPNVoJiLWw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GTth2qMtRnRna729NPPYjk0PBsrJKw4QJIW+c7bW23UsFCKVMySOcuv/omef4GqEK7Rst+95tVnqqxYR2h0FwxQUYi/Lx2dWr+1Lw4eYSMlajmdIBcYZ9eX8w6g54aPWlpFYEWbVeQBysAT5kbpEMd8UFCC46oN50I7g3dDE5O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P42JQ0QB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734480043;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GAB7b7lxkUE0WLtI3lfSURqgKFaDexqrbJ32hTQPVN4=;
	b=P42JQ0QBE96b5iZaiI/2HP0/OwXyjab4VoxCdpkEm7bZxGjC8ad3OvqNwWdgOqWhFsy6sJ
	T3F+JNWfvFyv9LnzSeSBIRpRe+mApx1ChTpRgANKN27Bkyw5c/TK4kQKQq/Ix1s75K1hZu
	fMwVL0OdhUTBuKtDSi40GPTrbQ0/IBk=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-694-C3iUbB0WPAaJn-f9yqkgfg-1; Tue, 17 Dec 2024 19:00:42 -0500
X-MC-Unique: C3iUbB0WPAaJn-f9yqkgfg-1
X-Mimecast-MFC-AGG-ID: C3iUbB0WPAaJn-f9yqkgfg
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-844e619a122so449467939f.3
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 16:00:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734480041; x=1735084841;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GAB7b7lxkUE0WLtI3lfSURqgKFaDexqrbJ32hTQPVN4=;
        b=DRvEnVmrDUd1L6F9v19k2nYEMXO6HLIoq0yyWj62rfI7yWjwdhXVpt7CNAFvazcBlc
         hFUHwZQpmo2yC2evahoGignu38LdDI80jwcLON83gMQH4lLFmVUJhVeQB6HqgSP4X80z
         RV4aWpTAxB6EUyUEcxFIXnl5d3IVKV8VHfFd2MkHO0lAErg28zcUvcaZKHcrAXEbBMhb
         ULtc2jPUVu31mjBfCDJWewZyPvNFmdsc6wHLg+QSvc4stKybu31isgOTMMXQ/4PgKiWP
         v5JWStff0AMJ/pRJLDm8OwmDbBBRZIEbUrtZV8u/QAAKm76h10dy2+IOP68zuBTor+gF
         EwUA==
X-Gm-Message-State: AOJu0YxqKsxzINe8jb/5JeRmdNIe4yf/eWjonwBlRIYmfalS+lAhzAJ+
	caBv5M1hw87UeDk5qgjA+PE1WrlwP8zYrJS95EDn3siqcGLhYKF3BIX+k8VNy+rj4ju+hTKWlas
	bx47dINeJ9h5yeUdIlLpY/fO0TT5c6mubVnuOqdnnE/o+I1HPRsWObzYDPA==
X-Gm-Gg: ASbGncvB+el/bhUhW6iDXHleWGDSAYnjHZpS1/fgs39D3aY9sF7DX2pnd4TXq5CN2xN
	TyGQmyGTx/tsx2osI4RQfjtNBfqxebVnmsIE9RqDEj9Xa6N4TLiNjsxL584AAMwpfMpSzV+jGE8
	zmdE8mhsKshKzyuhoOLjJ54ricjSsadP5IdOXFiYk8Rl0Rtr+ONMeXY6aap0gghhxY1jSh4dw4W
	1jTdbl0TrSWEkPp500iQW6N/QRbVwxMN71u3cZ8fUWGZ9EBYPIXFOqj
X-Received: by 2002:a05:6602:1585:b0:844:c750:3d9d with SMTP id ca18e2360f4ac-8475854466bmr90732139f.4.1734480040662;
        Tue, 17 Dec 2024 16:00:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGth+e7OyhRPQ8Kdsm84tbHhPWSeCUqVX6p60mHRdsiga7HMV4fbdzjLhEtmh+qbu+WQcFpMA==
X-Received: by 2002:a05:6602:1585:b0:844:c750:3d9d with SMTP id ca18e2360f4ac-8475854466bmr90728839f.4.1734480040341;
        Tue, 17 Dec 2024 16:00:40 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e5e32a33e3sm1927436173.85.2024.12.17.16.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:00:40 -0800 (PST)
Message-ID: <39f309e4a15ee7901f023e04162d6072b53c07d8.camel@redhat.com>
Subject: Re: [PATCH 09/20] KVM: selftests: Honor "stop" request in dirty
 ring test
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Xu
	 <peterx@redhat.com>
Date: Tue, 17 Dec 2024 19:00:39 -0500
In-Reply-To: <20241214010721.2356923-10-seanjc@google.com>
References: <20241214010721.2356923-1-seanjc@google.com>
	 <20241214010721.2356923-10-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2024-12-13 at 17:07 -0800, Sean Christopherson wrote:
> Now that the vCPU doesn't dirty every page on the first iteration for
> architectures that support the dirty ring, honor vcpu_stop in the dirty
> ring's vCPU worker, i.e. stop when the main thread says "stop".  This will
> allow plumbing vcpu_stop into the guest so that the vCPU doesn't need to
> periodically exit to userspace just to see if it should stop.

This is very misleading - by the very nature of this test it all runs in userspace,
so every time KVM_RUN ioctl exits, it is by definition an userspace VM exit.


> 
> Add a comment explaining that marking all pages as dirty is problematic
> for the dirty ring, as it results in the guest getting stuck on "ring
> full".  This could be addressed by adding a GUEST_SYNC() in that initial
> loop, but it's not clear how that would interact with s390's behavior.

I think that this commit description should be reworked to state that s390
doesn't support dirty ring currently so the test doesn't introduce a regression.

> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_test.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index 55a385499434..8d31e275a23d 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -387,8 +387,7 @@ static void dirty_ring_after_vcpu_run(struct kvm_vcpu *vcpu)
>  
>  	/* A ucall-sync or ring-full event is allowed */
>  	if (get_ucall(vcpu, NULL) == UCALL_SYNC) {
> -		/* We should allow this to continue */
> -		;
> +		vcpu_handle_sync_stop();
>  	} else if (run->exit_reason == KVM_EXIT_DIRTY_RING_FULL) {
>  		/* Update the flag first before pause */
>  		WRITE_ONCE(dirty_ring_vcpu_ring_full, true);
> @@ -697,6 +696,15 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  #ifdef __s390x__
>  	/* Align to 1M (segment size) */
>  	guest_test_phys_mem = align_down(guest_test_phys_mem, 1 << 20);
> +
> +	/*
> +	 * The workaround in guest_code() to write all pages prior to the first
> +	 * iteration isn't compatible with the dirty ring, as the dirty ring
> +	 * support relies on the vCPU to actually stop when vcpu_stop is set so
> +	 * that the vCPU doesn't hang waiting for the dirty ring to be emptied.
> +	 */
> +	TEST_ASSERT(host_log_mode != LOG_MODE_DIRTY_RING,
> +		    "Test needs to be updated to support s390 dirty ring");

This not clear either, the message makes me think that s390 does support dirty ring.
The comment above should state stat since s390 doesn't support dirty ring,
this is fine, and when/if the support is added,then the test will need to be updated.

>  #endif
>  
>  	pr_info("guest physical test memory offset: 0x%lx\n", guest_test_phys_mem);


Best regards,
	Maxim Levitsky




