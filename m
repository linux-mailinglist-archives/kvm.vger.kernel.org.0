Return-Path: <kvm+bounces-43687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 97D4FA9409D
	for <lists+kvm@lfdr.de>; Sat, 19 Apr 2025 02:35:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2ABC01B601B1
	for <lists+kvm@lfdr.de>; Sat, 19 Apr 2025 00:35:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E64972B9AA;
	Sat, 19 Apr 2025 00:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hg7kBFCy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB8CA95C
	for <kvm@vger.kernel.org>; Sat, 19 Apr 2025 00:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745022899; cv=none; b=AGcg9X9c1ohnEskJ/cpNN42rAwUGdrkzyb8od3TgTa5QjiI4f/CCeb8cR3tBo3LHrvG8xhfbQzWJwmLiwwD5UblF4xwpggBanxwUa3fyGf1Ey6VSdsrMC5wCPIJEustfVL2FiaPKDiU2pHkYHXSosNDKIZjF5h/aeDGybfOEwx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745022899; c=relaxed/simple;
	bh=ahHG9u0rD9umDxN4xagOg4rIAlbhb7yY3RtmSc4HzfE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YR1nzei3vtwCOMk0q8zR+uzuN26uZNA6V2cJSwDF8/zrf9YaO7imT38bnUdtdkySbMrFcC6o5IQo82RoQH5mZq+uqXlsSSWsT7sqyBS54CKKpK7W48hG7oi0ixWqkRB/WYtvkqXqppiIxXPe22R3DTeJ6tVmHtiWkCwklZxpjZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hg7kBFCy; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2264c9d0295so268705ad.0
        for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 17:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745022897; x=1745627697; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SQ0yR5jl20WEOAV0nC2Kh5pIrclrAyN7Dk/PJZDO1kI=;
        b=Hg7kBFCyBFIRu0gDS8OrQwChuQPQ5BxaFMLQmLnXex80TyPZTeLxdAu2j+PNor7v7m
         zFFCfVkPpsA7W5TTXHs93QGFi9tu3FGwyfgziV2v7AtEw+h6GCbzUsQfV1/Ci0llfpO4
         0zK6giCUsYejEN1lf6gWwPIto/L17LLplXSloIZLll0yIjubbhv84YesCUwdjHycueYC
         Rjp4lM6M12tFoWBnIzEW/1fOSxUgXq/izwBcFDS4kjse9ZDl0jMCVqCN5EwqB+J/k+hQ
         C9d5ycMa7/u0trKO+9AjSJLvOHF1jHwkozK/ue0SQPkepVAwIhuPKksdtx9XemciiUZ1
         2IWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745022897; x=1745627697;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SQ0yR5jl20WEOAV0nC2Kh5pIrclrAyN7Dk/PJZDO1kI=;
        b=vL/xjKcwc2Itakay8WkFW0ttE0abjcA3Y9xdbcbWkhoabp8TavGgVg4Z5rBvbUgfuT
         KUL5ZabVJ3brmH0Ou/EJRepLWzJO5YUtNt0ShEHXDRdEDdU6hfMBmCu8hvV/NtY0CiW4
         t97pCtDhKrzVw9bE9RMk0VTWksKzZoUvuPr4pfxLEApJILiJu+L0f6s5M1GcC0LyCtWK
         McJo3Yu+5UL7kRFH7ngiHVJfZySm3Fv6o2hfdIgny2X6I2gOl2tF0s/v6ReOPfSzVkxh
         0/oC4x6boFXQaSdBykq/T1SUE5jinE8Uimbdyg4sRDvCPKT/tKZpE9jUbuPjDC+gNgqG
         +S/w==
X-Forwarded-Encrypted: i=1; AJvYcCVCSu+eUfXLivdTIVa1nSspSIF34DBR28ISliGOe9LwXU1SNitDMbkHq6kXiCEOxGAtpFI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiyGY8xUNUMR/botUaHA2nADFRSjO0juAAGvoJNrVas8eCrTmY
	9E7kL85+LzgXhnt6uKOu+HBvwOKmzGek4NZ0Z2mi4/mO6ykUufmNFPgk++aaA4xeNCOB9RzK1OU
	TC2nKe3s783WFhfdoUuuVygafIOnJTeAc5QZy
X-Gm-Gg: ASbGnctrzzTIplrak1YjgKjKaN0SVHjm8cZNWxJXJW0dPK7imAgJuvb/UPNpRo6YvVv
	NYIAVL7rS/5i3oYbMP27DYgjA7LDA2iSkdthfCHHMZIXm2h/CFO0i5C/4oF77HSQaQzqA14X7WI
	19C0mpUKuIHty5kZT5WYGFtwnIe7+oGWgPgfwo4bXjpz/MzQtn7Zs=
X-Google-Smtp-Source: AGHT+IGvIbyVLUQqrTzMWiwcyOAnd17i902tnMA/kbj0+Mr4UoTQ/NIBk1rPd2pvIfxIF2nkB3VSPa8wRfsyVT6VhuY=
X-Received: by 2002:a17:903:1b6f:b0:21f:3e29:9cd4 with SMTP id
 d9443c01a7336-22c52a93da4mr3989635ad.20.1745022896577; Fri, 18 Apr 2025
 17:34:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250417131945.109053-1-adrian.hunter@intel.com> <20250417131945.109053-2-adrian.hunter@intel.com>
In-Reply-To: <20250417131945.109053-2-adrian.hunter@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Fri, 18 Apr 2025 17:34:43 -0700
X-Gm-Features: ATxdqUGRPn-OE9rX7bFhLESbA-lhcuPVKmZ_X02BQITuqE72Tc1GwfJL8yHvkew
Message-ID: <CAGtprH8EhU_XNuQUhCPonwfbhpg+faHx+CdtbSRouMA38eSGCw@mail.gmail.com>
Subject: Re: [PATCH V2 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, mlevitsk@redhat.com, 
	kvm@vger.kernel.org, rick.p.edgecombe@intel.com, 
	kirill.shutemov@linux.intel.com, kai.huang@intel.com, 
	reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com, 
	isaku.yamahata@intel.com, linux-kernel@vger.kernel.org, yan.y.zhao@intel.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 17, 2025 at 6:20=E2=80=AFAM Adrian Hunter <adrian.hunter@intel.=
com> wrote:
>
> ...
> +static int tdx_terminate_vm(struct kvm *kvm)
> +{
> +       int r =3D 0;
> +
> +       guard(mutex)(&kvm->lock);
> +       cpus_read_lock();
> +
> +       if (!kvm_trylock_all_vcpus(kvm)) {

Does this need to be a trylock variant? Is userspace expected to keep
retrying this operation indefinitely?

> +               r =3D -EBUSY;
> +               goto out;
> +       }
> +
> +       kvm_vm_dead(kvm);
> +       kvm_unlock_all_vcpus(kvm);
> +
> +       __tdx_release_hkid(kvm, true);
> +out:
> +       cpus_read_unlock();
> +       return r;
> +}
> +

