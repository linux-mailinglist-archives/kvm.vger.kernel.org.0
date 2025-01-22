Return-Path: <kvm+bounces-36288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49B0AA1985A
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 19:21:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6F0987A531D
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 18:21:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 601F421578E;
	Wed, 22 Jan 2025 18:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Md17kWya"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2230215075
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 18:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737570072; cv=none; b=rVPuu/C4CIQ3nUwfhiduQ9xxD0f1wxQlqs1YXEELBRZaEjAd9GY+CVci6JdQsg0fAzs09yHYH/HPl+vvpjUFaBg6eTt6tsUIuxh8qmLWkqUecTf+D4hn2n1z1GZy7JNmttnWhi6lA8k5kMjRsC4DSESY7ziOFyk5AcEz6Ux5+p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737570072; c=relaxed/simple;
	bh=RWJtNyHWSTJrcUHBLparY72kk5ggigwOA+MSE9yxTKo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l3vphwkGM4dKiwtvEOveTEQvQGauJDhbRj9DEpqB5fUhbpZnpZij9OxnCwQj3umVep1lxf9iarMY8OD9seO/2AwJQ3LMFUonXpU+r9eTMu0d5r7PlrSZRNVQzN6yNsIWWYhvi0aDbICLc2hm30TOEA5xZa4qwWwf7dfEszuWTk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Md17kWya; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737570069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H86MfsNLg9m/tr9gIJHegKq7ZCSOC+/uCRNwxLxp3UA=;
	b=Md17kWyaRj/kze5w02xtEgbChv78Siwg0LdYR3QFOEO5f1UlKJbGDpHxhPfunA3eS81Ox6
	GiXi6d/lzHKcXx4pReXd08spXqy52ONDsecAwkdMtEUpFQrmxOkZgBOhVEN7suzH6NhoSd
	Yd19QyU2aTe1AkXd2y900dg3sYmxp88=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-527-BSjOWLlpNMCip7DJarYbRw-1; Wed, 22 Jan 2025 13:21:08 -0500
X-MC-Unique: BSjOWLlpNMCip7DJarYbRw-1
X-Mimecast-MFC-AGG-ID: BSjOWLlpNMCip7DJarYbRw
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-385e3cbf308so3129610f8f.2
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 10:21:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737570067; x=1738174867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H86MfsNLg9m/tr9gIJHegKq7ZCSOC+/uCRNwxLxp3UA=;
        b=X5hcdC1cRLX1ZuefwTADwGHollqLHY+KH5h0M0hcEsUmhzSF581EjAYrQXC5bjDpIo
         D1a2b5YAqqDG54/uTth2pI9qQ4YKbLtlv7xbTTTnUrz1XqyQapqgB9ZB5i9Q8IKiGN/1
         Kr84O/kQmh5nKoKVKSJjwzKi6NvRelsBmTFO7AbLsS0djBURnxPsns7R8xbggDFLam6P
         vNBvFpoBwKN2y5X2++7BICXblnczNF9JHtg+HOSdCsRF2Vc8ocbZe0c4LzYd2X7dOJMx
         pw4YjgJatoFB5RJi1vUkmKQS7eeZVYOdk87OSQoenaNAioPHNto/1hQZqdriR+Zmagm+
         rnWg==
X-Forwarded-Encrypted: i=1; AJvYcCX8uSB6Ztku6wNurMw3jpG+naR7B1mXliQkNj0tzLwJQK8joM7gZ2fcZKOd67jsNZN+ZeQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkeC5IEW5mzZwXihSO73j6p/Q/0HSXwijesJQJCtqj9eNk2HZj
	7cIdJ8MzuyrMEGUlie94zz9JXZDxVASVYkXp6JXaqcaWObabjFIiREQUEg65+cX1C1M9kLPhK2e
	ezUEzKzKEsZ5CK3Afu+Lvg9OAOwzrGZZ1u80vO/38pWJTOtMZPO51iFcBA6NXVca6f/Iw6/+Pm/
	MADtpLUIkrzQnPFWLmTIEO/D6j
X-Gm-Gg: ASbGncuzBhJ6EQnLVzBNCoozoHtPrUQ96tfyfo6D6mtaHyALi4lf1xkWBnwUasREFxY
	2M9CVa1N3Fb2pEvqB5b0m4gTfYtv74xIKw7WmvLFsH8Hyjn03qv0W
X-Received: by 2002:a05:6000:4012:b0:38a:9f27:838c with SMTP id ffacd0b85a97d-38bf57ce8b8mr20271613f8f.55.1737570067226;
        Wed, 22 Jan 2025 10:21:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHMB9ElCjkyF+3dY60dIilgdLnzIUur2JDlSFqE/fAqKKrX1IrsejUFGblCwxGYRx37VWXUOveYDSSQZvDVXko=
X-Received: by 2002:a05:6000:4012:b0:38a:9f27:838c with SMTP id
 ffacd0b85a97d-38bf57ce8b8mr20271593f8f.55.1737570066841; Wed, 22 Jan 2025
 10:21:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241222193445.349800-1-pbonzini@redhat.com> <20241222193445.349800-10-pbonzini@redhat.com>
 <Z4r-Znz1GQ2E1vMX@google.com>
In-Reply-To: <Z4r-Znz1GQ2E1vMX@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 22 Jan 2025 19:20:55 +0100
X-Gm-Features: AWEUYZkWYTVxW12MMlPHt2DY4n0z9m4X3MzBD8NoHOMQfOmHP83_WCJ5x1_X_tA
Message-ID: <CABgObfZBGGcj5pYsNpzwLShxLg8nxOdaQNnouRicFudxXZudxg@mail.gmail.com>
Subject: Re: [PATCH v6 09/18] KVM: x86/tdp_mmu: Extract root invalid check
 from tdx_mmu_next_root()
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, yan.y.zhao@intel.com, 
	isaku.yamahata@intel.com, binbin.wu@linux.intel.com, 
	rick.p.edgecombe@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 18, 2025 at 2:05=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
> > +static bool tdp_mmu_root_match(struct kvm_mmu_page *root, bool only_va=
lid)
> > +{
> > +     if (only_valid && root->role.invalid)
> > +             return false;
> > +
> > +     return true;
>
> Ugh, this is almost as bad as
>
>         if (x)
>                 return true;
>
>         return false;
>
> Just do
>
>         return !only_valid || root->role.invalid;
>
> And I vote to drop the helper, "match" makes me think about things like r=
oles
> and addresses, not just if a root is valid.

This is not the definitive shape of the function; by the end of the
series it becomes

static bool tdp_mmu_root_match(struct kvm_mmu_page *root,
                               enum kvm_tdp_mmu_root_types types)
{
        if (WARN_ON_ONCE(!(types & KVM_VALID_ROOTS)))
                return false;

        if (root->role.invalid && !(types & KVM_INVALID_ROOTS))
                return false;

        if (likely(!is_mirror_sp(root)))
                return types & KVM_DIRECT_ROOTS;
        return types & KVM_MIRROR_ROOTS;
}

(where the first "if" could also be just a WARN_ON_ONCE without the
anticipated return, since KVM_VALID_ROOTS =3D=3D KVM_DIRECT_ROOTS |
KVM_MIRROR_ROOTS)

Paolo


