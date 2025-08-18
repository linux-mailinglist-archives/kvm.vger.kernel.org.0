Return-Path: <kvm+bounces-54931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ED07B2B508
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 01:47:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6CC98188C434
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 23:47:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 028FF26F2BE;
	Mon, 18 Aug 2025 23:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QpjsCACT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF891D5146
	for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 23:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755560838; cv=none; b=JWHb1FnWFBmHmOpi0OmFn6pOvdsEjFb2yJDjfP09DNXy3Z48jOGesiCAc+hFKX5muhNarQfKov16JmZBHbZyzjmAL8jnivohwkC7BQkajirQ6EzGkxgSlnjARuWVjKyjS/RuUS/WwmfLmNAgB31iRVQSth0Osx5sUx4BU5l2Otg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755560838; c=relaxed/simple;
	bh=Jh2c3Xgv7k+vbl3jw8SfiKBooJ7lBXdpty8Vh46PmPM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ktleAqH4hRpDYyQARMBNHyeumKbBwLnS4cgrA1uiRa4zmLYfT7Wpa3ie1Ji4nklq+4jcErr+oPXFSKvPM3/+hFr+tkC220rPyMMWydwDegqCwOuZj5/jEZifQUh6fDQLk5Q1t0R0oqxetqra5fNDU1OMf6zwBuQ/oA8kRTPDROU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QpjsCACT; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-333f92cb94eso36688961fa.3
        for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 16:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755560835; x=1756165635; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jh2c3Xgv7k+vbl3jw8SfiKBooJ7lBXdpty8Vh46PmPM=;
        b=QpjsCACT1NRhd6pqker5TfK8rCFyGwg91wpqJD+hZokfs/4ARt8nS2vS3H7tolWczc
         TPJTwEXRpLYdobGtUKIeZJN+ncW7zP0DQNqS8FCPcmyRlzwzRCwytCdjeYtHFXEbkEAv
         8GqEwZtNIiNp7FHrdCZQipOSljLaz1LBD3wxdyuEHhhFK0korl8fDF6k28+RRzUSjn6O
         YSMZT9B5szpmD9jxglEBQo+2r3gOAd45d/jQ9A3BNDECj6aRfP7KvFCbaVS4Aqb8S1hO
         wSGsI8P/YbPqRjr/1BctDuQTwXQSUClKMKXfgQL/EOzh9j83mPumSa5B87cUJ0cgm45X
         R8vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755560835; x=1756165635;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jh2c3Xgv7k+vbl3jw8SfiKBooJ7lBXdpty8Vh46PmPM=;
        b=OeUDmTbvVoZeEkapnOqqQHB1aRPBmdNQKI1wcdm6UNv3lRlaAs8/xJYlh30XEb6j/7
         SypzYMKF4KPoCmq3QTTg76BG3toohqmaf/i593NAB6KUW0ga0GGTbNg25phIY2MhyK1c
         SWzzeU35TwQZMZnknrYTS2rhv3OPCFF1jTloZBtEImjjjubc04GZHwlD6p7D2svyIh9J
         tMi9kkc+2HmuJLn9fvlrhGseU5iZGxF/D5RbAPK6pk1iolk97lMTWMQNd8B7e0elS/BH
         D5GaYm0PNckwu/K7qG8UwlbBWKeNf628IzHmOfUyxcSEIvkJXsXTsfydKuQE2PwR4tyr
         n+hw==
X-Forwarded-Encrypted: i=1; AJvYcCUAmqViEKEkW025hJAP5jtCN21oALfHqQzp22UskDKszum7VkbV51N2aQBuNmpfuwPc+Ag=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDahrS+U9Vhcmcho8GbCnAH3O9s9Hku90OychZ/XbR7r7uL5B+
	11fPS1eUR6jyF8BFQcWGxypqFnh/vncUb7tSEQZZxTxiStVQqKhK6+u7vsLjhkUtoW20eWp6IFt
	vhvYx7oTTWu5bwQT2hV0hBtg+zS82OeblCc3aNpsG
X-Gm-Gg: ASbGnctDEa9tYcsODzljPbQQalwyjxoE92v4Aph9oQfIpYGUYjuwVEp5n4SmpLW4+aF
	fEgnhE+lKAEs9PT/N/EIJ9943BRP5gq51VlAipxfE/kCY7mScPLU+MOEZuMyvUBVxtNxf+Ei4oC
	ZGlFRncsQZepKfex4akgWwnYpyEs2gxVQa9REgbcCQietniUEL9/ezehPy6ib8P2XK2G49Fb9Wz
	B8/zSgd61QyipXm8peSmxyj
X-Google-Smtp-Source: AGHT+IHOfhSl5Cs9AtJcBsjDbujYEyScxuL2NkyIn9iTc+B9ASTbSmneYkCeqWiBvFsZ6EG7khf5SYWDM+bYwtXqGoA=
X-Received: by 2002:a05:651c:1986:b0:333:aa78:db82 with SMTP id
 38308e7fff4ca-33530725c56mr1368701fa.27.1755560834452; Mon, 18 Aug 2025
 16:47:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250620232031.2705638-1-dmatlack@google.com> <20250620232031.2705638-13-dmatlack@google.com>
 <87jz302owi.fsf@intel.com>
In-Reply-To: <87jz302owi.fsf@intel.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 18 Aug 2025 16:46:46 -0700
X-Gm-Features: Ac12FXxTYkl5PEdMv5V_lQlu80HYiuMyLIbG5FcXK_PnHOYCMwQD_4jK5F8u78g
Message-ID: <CALzav=frg5WqBNYWSvAsKJzR=kvX-fEMBuGid6ibxSwnw5_nvg@mail.gmail.com>
Subject: Re: [PATCH 12/33] tools headers: Import iosubmit_cmds512()
To: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, Aaron Lewis <aaronlewis@google.com>, 
	Adhemerval Zanella <adhemerval.zanella@linaro.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, Bibo Mao <maobibo@loongson.cn>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Dan Williams <dan.j.williams@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, dmaengine@vger.kernel.org, 
	Huacai Chen <chenhuacai@kernel.org>, James Houghton <jthoughton@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Joel Granados <joel.granados@kernel.org>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, "Pratik R. Sampat" <prsampat@amd.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Vipin Sharma <vipinsh@google.com>, Wei Yang <richard.weiyang@gmail.com>, 
	"Yury Norov [NVIDIA]" <yury.norov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 18, 2025 at 4:25=E2=80=AFPM Vinicius Costa Gomes
<vinicius.gomes@intel.com> wrote:
>
> David Matlack <dmatlack@google.com> writes:
>
> > Import iosubmit_cmds512() from arch/x86/include/asm/io.h into tools/ so
> > it can be used by VFIO selftests to interact with Intel DSA devices.
> >
>
> minor: perhaps move this patch to be near the one that adds the DSA
> driver? (in case there's a next revision)

Will do. Thanks for the review!

