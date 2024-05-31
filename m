Return-Path: <kvm+bounces-18525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 469F38D6043
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 13:07:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01CFB2832E8
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 11:07:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 182FB15747D;
	Fri, 31 May 2024 11:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VSkmh9p8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7BF156F46
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 11:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717153636; cv=none; b=cF3rrmw7M6kwC7FvLSIu/Q6pV6knxB0aM8aCEK/SnS6yif8IYdY6MRX6+cnJd+A5k5DiHKGRHpEFeguiIx6IHvcMXVQOTa1RX2YQomQg6bx8RUKAF3wvn+R8nMm0LhICH3m71TV6S/zQsjgbsJsHgWruTFop1/vW7OQzlgQQjv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717153636; c=relaxed/simple;
	bh=h41e7/O4Pohznmf3PUM6NQc+m0hegoY4EqYAFmWKYGY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Iig/iZ5UWKNW4ACAFmfxmIgq0MIBDX8LdO1YamN1iizWfjbbh3UpAliOL/mTJ9ZVJSduVVN5b+e+ylKBT2CmCT2ccThX/XLAb+yKxw5mvQqmjTHgFiR7metRbqcxeuaHYx2QtE1WPN2Pw/8pkzgiSQ0k4CEoB66Ow4/jG5yJ+WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VSkmh9p8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717153633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KxPgW5AkJNB4ekRDOYHVb71yhNg3xNwdWM1TWklaq1c=;
	b=VSkmh9p8UVknL8/B5aGK4pu33OewizTVEz1R+Vi6n2At8Teu1tocPAMZh/6KcVd5Kdjew8
	QqZJcO2vIePGeFacp1BNUUMcT5UR6flc+7K9FIHx2e+18U8y6zqXJq9jwuTeqq+n5I/yTo
	zB0jUwG3GI2a2FVP5tL+m2Cfim0D6UQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-581-MS4gAmAFO2uAfEGn_CDRNQ-1; Fri, 31 May 2024 07:07:10 -0400
X-MC-Unique: MS4gAmAFO2uAfEGn_CDRNQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-35dc7e6e859so1125566f8f.2
        for <kvm@vger.kernel.org>; Fri, 31 May 2024 04:07:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717153629; x=1717758429;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KxPgW5AkJNB4ekRDOYHVb71yhNg3xNwdWM1TWklaq1c=;
        b=u+6eDcR6ohp+vaR7NGb5pHfiusYs/MxZId/o/8upph8Fg8gKRvx3125PVtQBFBnpB+
         FUwt1uziDjvZ20oV1BVblQXRn10s+2gOAq9WBzcum/exBHHgC8K+k8tfM0qD64grJjSE
         /AGz3pE/++PuKdrzyhipbEhRvJRatzUpFf+kxrV5ov2TTXISUwapBh0hpeZlMpSqMG/7
         PMwbXDwevIM4mCN0KeEtsKovCTL+ZLdkw3566BnF24eXkFJY1Um9w5+u3lvU2TiaaiyR
         +DnotRxu0+F6jHz7RNeoKXV4C7z69LUD47/Ezd/ujmsJLMuZn3LNhnqRPw/7T9UlWEAF
         31sQ==
X-Forwarded-Encrypted: i=1; AJvYcCWRO2tNQ5iKH0AgW/2nwLjkg6qwzEcSyMo37gW6MKSf38f8On9f1ODjUuu4N80d6T9qXq/STUTSb3iWN0kQAa1kFuF6
X-Gm-Message-State: AOJu0YzRA/7BBL25+IaLtTGp1jPsv9P+mh5MTtWez9gXJUV5x6GfI3ih
	82xP93tkZ6OG6aL5qPjV//dBEdyzuddIdBBseLX1zBo1334Tl+CRB48AxwXAZrC1NeFd8z5f7Zf
	UQWtz/hinXxQ64Fw2KWq1suJYYEsAkyGoH4Z+ag7drSIq3ZAE1Cbx4fLSjL15rlNdaECpWq92d6
	i5LpkjCkkoxRsO47yY33uBcBSF
X-Received: by 2002:adf:f7c4:0:b0:349:8ba8:e26d with SMTP id ffacd0b85a97d-35e0f25ade5mr1127944f8f.13.1717153628907;
        Fri, 31 May 2024 04:07:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGKF8DUeAzyTLmkxUc/s/BL3e7Mfc2JhCDsrVEl9JqjeXyX2YUJeVpauWo8dvgyTY6BAjEL7a7hs6T6R7faTFI=
X-Received: by 2002:adf:f7c4:0:b0:349:8ba8:e26d with SMTP id
 ffacd0b85a97d-35e0f25ade5mr1127921f8f.13.1717153628524; Fri, 31 May 2024
 04:07:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530111643.1091816-1-pankaj.gupta@amd.com> <20240530111643.1091816-10-pankaj.gupta@amd.com>
In-Reply-To: <20240530111643.1091816-10-pankaj.gupta@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 31 May 2024 13:06:57 +0200
Message-ID: <CABgObfYvQdLJTv-sc-HfJ1ib6Bsp5=bfgdToWf89s3US3acAnA@mail.gmail.com>
Subject: Re: [PATCH v4 09/31] i386/sev: Add sev_kvm_init() override for SEV class
To: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: qemu-devel@nongnu.org, brijesh.singh@amd.com, dovmurik@linux.ibm.com, 
	armbru@redhat.com, michael.roth@amd.com, xiaoyao.li@intel.com, 
	thomas.lendacky@amd.com, isaku.yamahata@intel.com, berrange@redhat.com, 
	kvm@vger.kernel.org, anisinha@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2024 at 1:17=E2=80=AFPM Pankaj Gupta <pankaj.gupta@amd.com>=
 wrote:
> +    /*
> +     * SEV uses these notifiers to register/pin pages prior to guest use=
,
> +     * but SNP relies on guest_memfd for private pages, which has it's
> +     * own internal mechanisms for registering/pinning private memory.
> +     */
> +    ram_block_notifier_add(&sev_ram_notifier);

"it's" should be "its".

Paolo


