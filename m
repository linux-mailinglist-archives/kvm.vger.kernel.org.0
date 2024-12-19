Return-Path: <kvm+bounces-34168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E847B9F7EA7
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 16:59:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 837427A2E5C
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 15:58:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1179227583;
	Thu, 19 Dec 2024 15:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HGjeLgGe"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3964B22756C
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 15:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734623826; cv=none; b=ei4SIyfHOVxL6UygYm3IWxeSm/gebtItxaqi0lIGRUCh9TrHvcVATxao+cZ89ljZn3IZaWBPNAVk41VFi0GvjJwRzfpFUQhMkGT2Z38sJd5Af3E1AqbQe2hdFQg3Fs22NhGPujjaUxfjTKFCe3lxovvVdppSxh5eSdti4qHSZec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734623826; c=relaxed/simple;
	bh=NZXbDOnsbueY/bTYnolr7LLXf3fkhWEB1EVBmrjmw3s=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dLYixCU2KMYip9yYL2hYkuxv/gZj5ZzuzjCwvN3qOXTLxc/yUKZ14rwnPHUGLGJTHVwLQQR4Y5gbsxeOtVOi/y/iA+JoBmXhhNIurEipmGg7p629oU2m2f9g5j2c6iDem/zyseOsEzjv6vFt8xgJS4fUh97Ab3WydUchBVnwyHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HGjeLgGe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734623824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BSRf2lahUcjGUrwQe+FmSLq/2A9QSO0QlymJM9SaP8g=;
	b=HGjeLgGesdKTcvw6l0FXS7haCsvieYDsACCnvVSkL7914CoCfLM8EBJPIZeEsG5/+PL22q
	33Xxk2rqvzY2poYC4TAb8QKEvHTec9Ty7rxjo5/T50f4DHvL0RccrgQB48OVOrEPCPPdr9
	7Kkr9ynsVEo5wORQiXsv1jEUSW8WDSk=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-7p2Jxd7uNzuG20ofBYw60g-1; Thu, 19 Dec 2024 10:57:02 -0500
X-MC-Unique: 7p2Jxd7uNzuG20ofBYw60g-1
X-Mimecast-MFC-AGG-ID: 7p2Jxd7uNzuG20ofBYw60g
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a7d60252cbso8626765ab.0
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 07:57:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734623822; x=1735228622;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BSRf2lahUcjGUrwQe+FmSLq/2A9QSO0QlymJM9SaP8g=;
        b=layJGibVy31Z7eii8BjUvv8he8LrVbncOUg3muXTzkiWzicij549K0qV23VLerCO10
         Yo4eR2gH5cACe6XEiFyznfjbZS5nNcj2B0hyFnYYaVq6J9ahSmebl/DDOU7uq+EPCAqc
         Xm0xLOWNVN29XI+5DWgN+AzVKMyKo5BPBDRSQQ+XtLFWhec3A5HBTdyvTRp/Sgn2/wk/
         hC/bvPUZY4gJv0ddFIRR1lwmKBUTsVKX2XTVdss8a+I4rfzRD6zrBq1m+9y1yy/G/XFT
         jrvPOP1shC1xoUZdwHTnrjzzC7koToPEwtWZRYqBRXxC+A35tnefQi27qb7Nq/xI6goO
         HTcQ==
X-Forwarded-Encrypted: i=1; AJvYcCWDMRbIpd8pMDRXJXSFAum/01H1cB91jSjf0BfaedQhY1nMWPQKo/suLpbWLoh/Fil8mCE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9TmibUSZdBjtErq4Jf/ttc/BVRQ6LVJBzVfvdTj4k7M5z8dKB
	dgSfusS6du1QIEjb/qJtmtUMAWwXbSq8Q07zofBRfNZE/YjbMXNhG0HEWwJxxZY/p3nmzp2r+6z
	ojTlpjS4ecpTAFyPj0x4Wm6usvlGYMEAsA0paUjXk22PW9/nXdA==
X-Gm-Gg: ASbGncvh5Qi+HEnMyFAowgpTFFFZc2bSASqCVGPB7IoBGjLPhQakqoP6XpqQKw2K8GV
	qvhEsA8odXZKgClrGUFI52YVuFnN+lArnA6UJ0ciY6C31iDs59t+WU/GdIWjFJOP/keJ+NMvkjA
	NoYDl2AWt7PqC/CEYRmQ43B56CRG4z4Vgex2gU8Odt8uDS4vVKF9kxeeltF8XOSUWXmL1eY5aTV
	Y06ah4JwqXOhgUvbnbX2Z2xGkGyIZxDTooumT7j10TWRjWZ94zfp/M/
X-Received: by 2002:a05:6e02:3b03:b0:3a7:d02b:f653 with SMTP id e9e14a558f8ab-3c02773b83emr24377795ab.0.1734623822064;
        Thu, 19 Dec 2024 07:57:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFTroMO2mMF9jsTs4bhAlwpMmc55xNPTwCrKo0X1dMF4R3mM/rFQFiTHfNe78bttZIpNUF0Aw==
X-Received: by 2002:a05:6e02:3b03:b0:3a7:d02b:f653 with SMTP id e9e14a558f8ab-3c02773b83emr24377655ab.0.1734623821762;
        Thu, 19 Dec 2024 07:57:01 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3c0de052f2dsm3679865ab.9.2024.12.19.07.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2024 07:57:01 -0800 (PST)
Message-ID: <bed60b1b671be1e4e2a747b4e6d42ab280e69ab9.camel@redhat.com>
Subject: Re: [PATCH 09/20] KVM: selftests: Honor "stop" request in dirty
 ring test
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>
Date: Thu, 19 Dec 2024 10:57:00 -0500
In-Reply-To: <Z2Q6jK1E0KfX7n7l@google.com>
References: <20241214010721.2356923-1-seanjc@google.com>
	 <20241214010721.2356923-10-seanjc@google.com>
	 <39f309e4a15ee7901f023e04162d6072b53c07d8.camel@redhat.com>
	 <Z2N-SamWEAIeaeeX@google.com>
	 <faccf4390776ca78da25821e151a4827b1f8b3a9.camel@redhat.com>
	 <Z2Q6jK1E0KfX7n7l@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2024-12-19 at 07:23 -0800, Sean Christopherson wrote:
> On Thu, Dec 19, 2024, Maxim Levitsky wrote:
> > On Wed, 2024-12-18 at 18:00 -0800, Sean Christopherson wrote:
> > > On Tue, Dec 17, 2024, Maxim Levitsky wrote:
> > > > On Fri, 2024-12-13 at 17:07 -0800, Sean Christopherson wrote:
> > > > > Now that the vCPU doesn't dirty every page on the first iteration for
> > > > > architectures that support the dirty ring, honor vcpu_stop in the dirty
> > > > > ring's vCPU worker, i.e. stop when the main thread says "stop".  This will
> > > > > allow plumbing vcpu_stop into the guest so that the vCPU doesn't need to
> > > > > periodically exit to userspace just to see if it should stop.
> > > > 
> > > > This is very misleading - by the very nature of this test it all runs in
> > > > userspace, so every time KVM_RUN ioctl exits, it is by definition an
> > > > userspace VM exit.
> > > 
> > > I honestly don't see how being more precise is misleading.
> > 
> > "Exit to userspace" is misleading - the *whole test* is userspace.
> 
> No, the test has a guest component.  Just because the host portion of the test
> only runs in userspace doesn't make KVM go away.  If this were pure emulation,
> then I would completely agree, but there multiple distinct components here, one
> of which is host userspace.
> 
> > You treat vCPU worker thread as if it not userspace, but it is *userspace* by
> > the definition of how KVM works.
> 
> By simply "vCPU" I am strictly referring to the guest entity.  I refered to the
> host side worker as "vCPU woker" to try to distinguish between the two.
> 
> > Right way to say it is something like 'don't pause the vCPU worker thread
> > when its not needed' or something like that.
> 
> That's inaccurate though.  GUEST_SYNC() doesn't pause the vCPU, it forces it to
> exit to userspace.  The test forces the vCPU to exit to check to see if it needs
> to pause/stop, which I'm contending is wasteful and unnecessarily complex.  The
> vCPU can instead check to see if it needs to stop simply by reading the global
> variable.
> 
> If vcpu_sync_stop_requested is false, the worker thread immediated resumes the
> vCPU.
> 
>   /* Should only be called after a GUEST_SYNC */
>   static void vcpu_handle_sync_stop(void)
>   {
> 	if (atomic_read(&vcpu_sync_stop_requested)) {
> 		/* It means main thread is sleeping waiting */
> 		atomic_set(&vcpu_sync_stop_requested, false);
> 		sem_post(&sem_vcpu_stop);
> 		sem_wait_until(&sem_vcpu_cont);
> 	}
>   }
> 
> The future cleanup is to change the guest loop to keep running _in the guest_
> until a stop is requested.  Whereas the current code exits to userspace every
> 4096 writes to see if it should stop.  But as above, the vCPU doesn't actually
> stop on each exit.
> 
> @@ -112,7 +111,7 @@ static void guest_code(void)
>  #endif
>  
>  	while (true) {
> -		for (i = 0; i < TEST_PAGES_PER_LOOP; i++) {
> +		while (!READ_ONCE(vcpu_stop)) {
>  			addr = guest_test_virt_mem;
>  			addr += (guest_random_u64(&guest_rng) % guest_num_pages)
>  				* guest_page_size;
> 

Ah OK, I missed the "This *will* allow plumbing", that is the fact this this patch
is only a preparation for this.

Best regards,
	Maxim levitsky


