Return-Path: <kvm+bounces-55763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8375FB36F94
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 18:10:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9709F1B61274
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 16:11:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0F9B2BD5A8;
	Tue, 26 Aug 2025 16:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VqI8YPkZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AE831A555
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 16:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756224639; cv=none; b=fWoZZEXi0Aq+oVk+rylJ0Z3W2NEoz2BOfrqHBgfME5+H7OfaQn3/nteNADpZigMRLGoPYY6J6+5w6nvLOSH+QKCB/EYYtfX7mhECadt5YGQKf9qc/Miy1kG9pFK26KmamrR5QYkWgqhKwfvQqAgzTki7QmtSXlE9XUnl45drjKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756224639; c=relaxed/simple;
	bh=uUnVxVTDDWqmWBh2MGBUnTCtl2B8bgs4dvqdJBWjcdw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mctI4/KJ1JXa7npfICUZv9lTZqJZUWaBEzRB8fBsNccEMwaChzZVrsOKoXgJauZQajbgGmlAmoFRVbbmg2kvBYG3+0z+dVnGv6EeloHOIMuqEi6U43ZIXyG7P+WTrQhQwRdwvI7wSRKGPO9+yq07BbIL1kRn2spi0XhuqcDFuAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VqI8YPkZ; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4b29b715106so270991cf.1
        for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 09:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756224636; x=1756829436; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vZ5a9wW/sXjVhC8FVp7iGuvAwGNBd64MKlntfi+5SYs=;
        b=VqI8YPkZdcakCUIOg0W95u/5xJd46E9f/RukLu7o34XennhQ3iadNtDxw9fkeM9/wV
         lmdxEbw2+1ga8lAyw/muWK/lmhJiihLxrgxt5/ngmdf9QeXjUqCdHNd+b/pSLBa7VAyP
         YRc6M/gUkdmxZc9MltIo5EZlUfh1yYJ6lVpugy9WK17E/qPV1CnLwZjOsEOSvZ4woGY9
         Wsn+HHyCEDgHHuy8MJ0RQge3rVBMlmoBQ95BfluhlDSFrf0nbJPIGVbEO7iFJU891mFt
         Ayw255a3hBGsnS8ee6lrJUUle9zgqucgUXU942jUh3jWP+lSiwJI+rQ56rr5+yU9f+bF
         FCvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756224636; x=1756829436;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vZ5a9wW/sXjVhC8FVp7iGuvAwGNBd64MKlntfi+5SYs=;
        b=ngasYyTnHMcvmsH763SaQL1v2p2EoV466e+UbjuMvv4Xctogl3Xq/y3Prm9fLf97Du
         DWLW/I8o5cVG/BxsNX9wdkgpfQtrBZph5l2wdjU0KdBnBU4vvS8pVrAksbkx9puONDjU
         A3bV1Wo2F9htQh/cN0HkSTujcMtyX/yVKrdbNEJccPzSEpjuBv6AcjHjEz4VtzqsVxj6
         gRoLcqDg6MQwt4UF2s8ssU5ZUayX7mA3Ai3IpfGm4j06HXmp4iEOyrXEF4KfZicJ7Pbr
         9M2e9OsvtNEa1eDglJEmyhT1Hz9IWLzZp8gn6SaViApmMNpj0ibCqXiz3Z9jVH77rrPG
         aoEQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRkDnENOaa/i/XySs6kk55D9SvDHa0a1UIdMj3luM+k/vkF7vwV2aLwREpM/Umnq/2Img=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzPUhEZwiIG2zaHgHuGiTBXA2pVr/l+sevr/1PwYdCUFWY4hl+
	WLvIkHifQlP4QThF35o1B6GV4SLEP6lAjekZKHF05ydntlXpESAzEr9lzd2nssIbpdwITttJin2
	TwPdRmsP1cQ+HEgFtq4PfQKp8Mnf27tCkfTDEBqBU
X-Gm-Gg: ASbGncvvGjDwWb4PsDzE4L0TmC9zeu2IDtF8YHge8CeWX0IghWmJ+XJoQrPaL8BpGHZ
	7bWNIK1rl4wv65Oj2GnYCMLZYu11M+XIKk1wsPpnE0dI1z2Ep7e8K4OvtCCE11m76GEsll2VpMo
	/lcfEPXuvCUnc/mAoQ8jxPxoK1Q7jGxb6/NqFyscKvtpeyecqR+07Pn0w/7ByRiJdIfIqB3gdvi
	oxMYiLVSETabB3EoHldyfuALZ9ZjkC3hi67ZUuldJh8hw==
X-Google-Smtp-Source: AGHT+IFWTBnegYsgo4t+bTINOKl+X+5UHJwlAppipz3z1BODi/VrNOUY4vQo1AxTw0v14VFVG4iZb3RcvckoStjmph0=
X-Received: by 2002:a05:622a:118c:b0:4b2:9d13:e973 with SMTP id
 d75a77b69052e-4b2e1b31275mr6506651cf.0.1756224636084; Tue, 26 Aug 2025
 09:10:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250821042915.3712925-1-sagis@google.com> <20250821042915.3712925-9-sagis@google.com>
 <d780a249-ecb2-40e7-9520-19de8728c703@linux.intel.com>
In-Reply-To: <d780a249-ecb2-40e7-9520-19de8728c703@linux.intel.com>
From: Sagi Shahar <sagis@google.com>
Date: Tue, 26 Aug 2025 11:10:24 -0500
X-Gm-Features: Ac12FXzjoQma6pYvJ2NYaJoeraToE-BsC5fTbwE_cSx2Q5p4AW62eAtBhQOjCPE
Message-ID: <CAAhR5DHVhS29egfT4aDA5HGnHkM0fQRfU5600ossaVGdvNgCGQ@mail.gmail.com>
Subject: Re: [PATCH v9 08/19] KVM: selftests: Define structs to pass
 parameters to TDX boot code
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Roger Wang <runanwang@google.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 26, 2025 at 1:52=E2=80=AFAM Binbin Wu <binbin.wu@linux.intel.co=
m> wrote:
>
>
>
> On 8/21/2025 12:29 PM, Sagi Shahar wrote:
> [...]
> > +
> > +/*
> > + * Allows each vCPU to be initialized with different eip and esp.
> > + *
> > + * __packed is used since the offsets are hardcoded in td_boot.S
> > + *
> > + * TODO: Replace hardcoded offsets with OFFSET(). This requires gettin=
g the
> > + * neccesry Kbuild scripts working in KVM selftests.
> neccesry -> necessary
>
> Also, are the comments about "__packed" and "TODO" out dated?
>

Thanks, I forgot to update those.

> > + */
> > +struct td_per_vcpu_parameters {
> > +     uint32_t esp_gva;
> > +     uint64_t guest_code;
> > +};
> > +
> > +/*
> > + * Boot parameters for the TD.
> > + *
> > + * Unlike a regular VM, KVM cannot set registers such as esp, eip, etc
> > + * before boot, so to run selftests, these registers' values have to b=
e
> > + * initialized by the TD.
> > + *
> > + * This struct is loaded in TD private memory at TD_BOOT_PARAMETERS_GP=
A.
> > + *
> > + * The TD boot code will read off parameters from this struct and set =
up the
> > + * vCPU for executing selftests.
> > + *
> > + * __packed is used since the offsets are hardcoded in td_boot.S
> Same as above for "__packed".
>
> > + */
> >
> [...]

