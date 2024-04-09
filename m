Return-Path: <kvm+bounces-14035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C89B89E5D3
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 00:58:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 337791F22857
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 22:58:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA83C158D9B;
	Tue,  9 Apr 2024 22:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HpyWO/gG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73726156C6D
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 22:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712703519; cv=none; b=b1v1CODADIClkZpUrMkVGH4bIs3kyKbP2iSyKAnFHz+5B6CE3HBdhCcSPruSQR0rLIQm0yk1KM2lJ+Cuw7RoDL1XiqLB1MxUY9Ucin0MwcEz7nz9D7WFMvei8Hd3qo9K+uH4ZNZx+Y5DCn+BJO6pnh+TwhE9nz3Jo3Ofovg6U2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712703519; c=relaxed/simple;
	bh=C4UUEPXQ7aNiC2MpIyrA52CI1Xak5d78Q0u4LEWdxtU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OFIB09pg2WHrmJHgzdmc/hga41+AHoluQgmx2Zm8pUnnylgKriaLj9j2NaUs31793Icn8ToxnyGu/ALFifK4OQg8vhX1x6H0EKr1xnh2+ZgcwFzWjeGyd433tTw4NoNiCFKPMtHr3dmTWxYaoMN99RVgS8Jy4An2p23WArVB7Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HpyWO/gG; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61510f72bb3so103969247b3.0
        for <kvm@vger.kernel.org>; Tue, 09 Apr 2024 15:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712703517; x=1713308317; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y6Z88aYJTzgs0pbUWWKLdnj4AYHEigi0XdL5G85Xxlc=;
        b=HpyWO/gGt+0JtTvByGbV7M8zin0ekVf7D9Fc/13dDaZk/nTbaQHXa8csXj5Q+glylh
         IRlG4+E0vX5lSC8ChPgKTktvDAod9TJcNVAtq3KI21fTy4kfAFsf9z4ZiMDqYGDLHBIc
         C6nxCMt0/YrInALIkf03ok1vfeEhTVmVvWGAvO6R+5kE0uEJGHOnkTA/VyL5o2NJYs6F
         0uFcNywiK/nKfDPWgtHYDtKbliVyGAd2cSIannpUTwbK7b0Ij0OAM2de1yKleiCo+/hj
         MsTKLfOTrJS/pm2lT3KtTaWaolIj8AgaHwEGhVcqlw2TfJVy7O0580hnZcA+N0Y565ZD
         gQAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712703517; x=1713308317;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y6Z88aYJTzgs0pbUWWKLdnj4AYHEigi0XdL5G85Xxlc=;
        b=wp7/cqx0/2CuQ0fFxSzNr2FLdqRU+ZARpT/0mH4NAY8f1aLT5riZo8mCRpiiCFmYyn
         h90ufP3mJORsznXdDPPbe9d7Cltmt7T2CnTUFUfDZW0NwG7R/1pujCxiCtD/KeGwuXeF
         UyQPq6m10LbFSZRju1K/CvSim2yJid1gW8A17VRHexf2nW245+mc+psVsD6SsNVqBDhq
         51Kw/s8KyZfuP5xxT+EZPFokmathPQ33GuM4Bz99Ekpl6U16Zk/QGIKZv18/kV9hpJvu
         o9fzBk0/yznbZJEt1W1JVEifyiSYoAVRXJy7rR3LtJ3v/NkmLDibtxbfLnR2/fokUY/z
         FD5g==
X-Forwarded-Encrypted: i=1; AJvYcCX2x7WDYlqhcjddAJRhH6poamBwDzjcY2C/MPergW8mFGHfJadqgKqNmjlrsGrnn+g8nA/867QG9ELOlyFsrvwliF8A
X-Gm-Message-State: AOJu0YyCtZpBU4I+81xudi4o0zlPsT856sPgmQyA1vzH7ln1LnE0g5DS
	w+AxK2H1Z2g1lWz8ghIr9Qu8xb4ngwYD6N31SspOLtistEqU15ePkVpBM4RL7im5qnXDlvu61Xr
	qqg==
X-Google-Smtp-Source: AGHT+IGB7SGhpeqD/kjhTPt66yolVDX+BiT9lMP/+KM/dDzWT/nT5YV37XYXL4pSK7SGftosV6zkbKOS5uo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4e50:0:b0:615:1579:8660 with SMTP id
 c77-20020a814e50000000b0061515798660mr263035ywb.7.1712703517472; Tue, 09 Apr
 2024 15:58:37 -0700 (PDT)
Date: Tue, 9 Apr 2024 15:58:35 -0700
In-Reply-To: <20240215235405.368539-12-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com> <20240215235405.368539-12-amoorthy@google.com>
Message-ID: <ZhXIG6uISrC77BQ2@google.com>
Subject: Re: [PATCH v7 11/14] KVM: selftests: Allow many vCPUs and reader
 threads per UFFD in demand paging test
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, maz@kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, robert.hoo.linux@gmail.com, jthoughton@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 15, 2024, Anish Moorthy wrote:
> @@ -167,19 +187,30 @@ struct uffd_desc *uffd_setup_demand_paging(int uffd_mode, useconds_t delay,
>  void uffd_stop_demand_paging(struct uffd_desc *uffd)
>  {
>  	char c = 0;
> -	int ret;
> +	int i, ret;
>  
> -	ret = write(uffd->pipefds[1], &c, 1);
> -	TEST_ASSERT(ret == 1, "Unable to write to pipefd");
> +	for (i = 0; i < uffd->num_readers; ++i) {
> +		ret = write(uffd->pipefds[i], &c, 1);
> +		TEST_ASSERT(
> +			ret == 1, "Unable to write to pipefd %i for uffd_desc %p", i, uffd);

More coding style oddities.

And storing the return code in "ret" is unnecessary, and arguably makes it more
difficult to debug failures by not capturing the failing command in the assert
message.

> +	}
>  
> -	ret = pthread_join(uffd->thread, NULL);
> -	TEST_ASSERT(ret == 0, "Pthread_join failed.");
> +	for (i = 0; i < uffd->num_readers; ++i) {
> +		ret = pthread_join(uffd->readers[i], NULL);
> +		TEST_ASSERT(
> +			ret == 0, "Pthread_join failed on reader %i for uffd_desc %p", i, uffd);

Preferred kernel style is "!ret", not "ret == 0".

Putting it all together:

	int i;

	for (i = 0; i < uffd->num_readers; ++i)
		TEST_ASSERT(write(uffd->pipefds[i], &c, 1) == 1,
			    "Unable to write to pipefd %i for uffd_desc %p", i, uffd);

	for (i = 0; i < uffd->num_readers; ++i)
		TEST_ASSERT(!pthread_join(uffd->readers[i], NULL),
			    "Pthread_join failed on reader %i for uffd_desc %p", i, uffd);

