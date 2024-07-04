Return-Path: <kvm+bounces-20937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46CF5926FFA
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 08:51:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F02B9284B3A
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 06:51:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12BCF1A0AE0;
	Thu,  4 Jul 2024 06:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bW4SnjF3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F261B960
	for <kvm@vger.kernel.org>; Thu,  4 Jul 2024 06:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720075884; cv=none; b=JD48fDrLGcQPmSYsaLpYfFULIZPKWLtwNGQZIIEZKcfMxOcc6SDx7JszZ179dQtmWCB2jyV1GhYYQZQSDqYBw7vjK8F4uqy056aSrXhdJBUpkmLv0aZra/d2x55PJL2EzFBlVm1f06mRRE5xoHJMdkPkPqTK/1+fdvHCyNkd6Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720075884; c=relaxed/simple;
	bh=AX+VbwC/efdpssXra+18rkcc4SRKBdw0qdowMNHV8Sc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AMU45bBUuljS4yaohWOkOrJ4ceLghcdeNQi1a8lSBG9gK2o0Q/26AyW5OaaZVDUVHYjb2UnNlb7K4K1a8KziUTaQAbooPjF7zfkOXTdyX8LXLoy/oBWshdspNlSCYY1KCmNUPbZItBfk/5XBkatWth1iwRw73+OzE6qXvIimJTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bW4SnjF3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720075880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s/AVilcDu8v/3xKecAEhUmXHTQ27Du9KXpdz07eQ/YQ=;
	b=bW4SnjF3k2uv2nJaQG8COJE/CoQUleVJh2lUt8PX4zdwHy0h3zAp7kUycWH296wCUSQ4fR
	oKV/A2l4iXJYEl/572i0dvk50hTgX4pTMf9yMNaTpnX3cAn3LhAi+TgjqB2AAjTP5wxy2h
	TeK+6qItnm3TZqNiphc8M/IeJ9g3y/o=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-176-07evh6XRMHip_OWNHLZ46A-1; Thu, 04 Jul 2024 02:51:19 -0400
X-MC-Unique: 07evh6XRMHip_OWNHLZ46A-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3679aa0ee0aso235369f8f.2
        for <kvm@vger.kernel.org>; Wed, 03 Jul 2024 23:51:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720075878; x=1720680678;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s/AVilcDu8v/3xKecAEhUmXHTQ27Du9KXpdz07eQ/YQ=;
        b=KfP8j0gKPLTuCXMJNXeeBJhr9GcxdXv4Vg80GtYcfATgO3OZKtxE+j29iYti6JmUfh
         ZpPesfSPiza9wh6od76uWU6ZosNH61RYYnP2UivEXSLBUgWoIJesN0Xp9bdA9zRRRFx9
         H1O0eks+gnl6eoWRzZh75xwm1gq/LfZFFhcRwizlBoVwJeaBrNnAfuwacKyxivea4+My
         vNbK3IQiSNMUWJ1VnI9zzdLrWgLHnF5TTx/c7Mhg6ZR/fiJ+gPsFh4FliHP6POh55wQ6
         6jAdxrFnWOBzZm43LphjY0R+IdSdA4CshGbTYQmdMycTq3nl6aIW6UjV5DgOUmYT60V/
         71uw==
X-Forwarded-Encrypted: i=1; AJvYcCWeypnl4lOG1KudtCuw+P37tisQK+Vp9sbJuvrXYTP7OcCm1fEC701gcUg8s2eIlb/zQIKNJJYN64vaix4cOrzIprow
X-Gm-Message-State: AOJu0YwmB/1YLj8cbUxKjo+7TfZGa97BAUTO6ybtRA0SJB5F6Rgur94Q
	jDQA0OohtO/QdlDXxwCZSmuI9+rfs6DYAew2bjZ2Hw+dK77uLzBpWVrI0Jq9Inq0KY5IeOQss2/
	Mf/jlrYo8Gxx/2AjAfumFQw4lxtpnW8k1GlobrEwuxMatJiEnXtecUwJkz9ZWAPB/tQXyZn9jVw
	A2XurWw/hF5/U6XSRW29538mVu
X-Received: by 2002:adf:f043:0:b0:367:980a:6af with SMTP id ffacd0b85a97d-3679dd718fdmr683385f8f.59.1720075877990;
        Wed, 03 Jul 2024 23:51:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE5yI3p6ZTbveCHvrG7CXdXgJkbt2ZxrfLmKKgB7cdkvlItFYJusQWTUeG6QgDhMqVhz4m4jpfoK1Yj8l6nfi4=
X-Received: by 2002:adf:f043:0:b0:367:980a:6af with SMTP id
 ffacd0b85a97d-3679dd718fdmr683367f8f.59.1720075877618; Wed, 03 Jul 2024
 23:51:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240704000019.3928862-1-michael.roth@amd.com>
In-Reply-To: <20240704000019.3928862-1-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 4 Jul 2024 08:51:05 +0200
Message-ID: <CABgObfYX+nDnQSW5xyT3SjYbQ72--EW5buCkUuG_Z_JPFqfQNA@mail.gmail.com>
Subject: Re: [PATCH] i386/sev: Don't allow automatic fallback to legacy KVM_SEV*_INIT
To: Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 4, 2024 at 2:01=E2=80=AFAM Michael Roth <michael.roth@amd.com> =
wrote:
> Currently if the 'legacy-vm-type' property of the sev-guest object is
> left unset, QEMU will attempt to use the newer KVM_SEV_INIT2 kernel
> interface in conjunction with the newer KVM_X86_SEV_VM and
> KVM_X86_SEV_ES_VM KVM VM types.
>
> This can lead to measurement changes if, for instance, an SEV guest was
> created on a host that originally had an older kernel that didn't
> support KVM_SEV_INIT2, but is booted on the same host later on after the
> host kernel was upgraded.

I think this is the right thing to do for SEV-ES. I agree that it's
bad to require a very new kernel (6.10 will be released only a month
before QEMU 9.1), on the other hand the KVM_SEV_ES_INIT API is broken
in several ways. As long as there is a way to go back to it, and it's
not changed by old machine types, not using it for SEV-ES is the
better choice for upstream.

On the other hand, I think it makes no difference for SEV?  Should we
always use KVM_SEV_INIT, or alternatively fall back as it was before
this patch?

Paolo

> Cc: Daniel P. Berrang=C3=A9 <berrange@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> cc: kvm@vger.kernel.org
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  qapi/qom.json     | 11 ++++++-----
>  target/i386/sev.c | 30 ++++++++++++++++++++++++------
>  2 files changed, 30 insertions(+), 11 deletions(-)
>
> diff --git a/qapi/qom.json b/qapi/qom.json
> index 8bd299265e..a212c009aa 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -912,11 +912,12 @@
>  # @handle: SEV firmware handle (default: 0)
>  #
>  # @legacy-vm-type: Use legacy KVM_SEV_INIT KVM interface for creating th=
e VM.
> -#                  The newer KVM_SEV_INIT2 interface syncs additional vC=
PU
> -#                  state when initializing the VMSA structures, which wi=
ll
> -#                  result in a different guest measurement. Set this to
> -#                  maintain compatibility with older QEMU or kernel vers=
ions
> -#                  that rely on legacy KVM_SEV_INIT behavior.
> +#                  The newer KVM_SEV_INIT2 interface, from Linux >=3D 6.=
10, syncs
> +#                  additional vCPU state when initializing the VMSA stru=
ctures,
> +#                  which will result in a different guest measurement. S=
et
> +#                  this to force compatibility with older QEMU or kernel
> +#                  versions that rely on legacy KVM_SEV_INIT behavior.
> +#                  Otherwise, QEMU will require KVM_SEV_INIT2 for SEV gu=
ests.
>  #                  (default: false) (since 9.1)
>  #
>  # Since: 2.12
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 3ab8b3c28b..8f56c0cf0c 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -1347,14 +1347,22 @@ static int sev_kvm_type(X86ConfidentialGuest *cg)
>          goto out;
>      }
>
> +    if (sev_guest->legacy_vm_type) {
> +        sev_common->kvm_type =3D KVM_X86_DEFAULT_VM;
> +        goto out;
> +    }
> +
>      kvm_type =3D (sev_guest->policy & SEV_POLICY_ES) ?
>                  KVM_X86_SEV_ES_VM : KVM_X86_SEV_VM;
> -    if (kvm_is_vm_type_supported(kvm_type) && !sev_guest->legacy_vm_type=
) {
> -        sev_common->kvm_type =3D kvm_type;
> -    } else {
> -        sev_common->kvm_type =3D KVM_X86_DEFAULT_VM;
> +    if (!kvm_is_vm_type_supported(kvm_type)) {
> +            error_report("SEV: host kernel does not support requested %s=
 VM type. To allow use of "
> +                         "legacy KVM_X86_DEFAULT_VM VM type, the 'legacy=
-vm-type' argument must be "
> +                         "set to true for the sev-guest object.",
> +                         kvm_type =3D=3D KVM_X86_SEV_VM ? "KVM_X86_SEV_V=
M" : "KVM_X86_SEV_ES_VM");
> +            return -1;
>      }
>
> +    sev_common->kvm_type =3D kvm_type;
>  out:
>      return sev_common->kvm_type;
>  }
> @@ -1445,14 +1453,24 @@ static int sev_common_kvm_init(ConfidentialGuestS=
upport *cgs, Error **errp)
>      }
>
>      trace_kvm_sev_init();
> -    if (x86_klass->kvm_type(X86_CONFIDENTIAL_GUEST(sev_common)) =3D=3D K=
VM_X86_DEFAULT_VM) {
> +    switch (x86_klass->kvm_type(X86_CONFIDENTIAL_GUEST(sev_common))) {
> +    case KVM_X86_DEFAULT_VM:
>          cmd =3D sev_es_enabled() ? KVM_SEV_ES_INIT : KVM_SEV_INIT;
>
>          ret =3D sev_ioctl(sev_common->sev_fd, cmd, NULL, &fw_error);
> -    } else {
> +        break;
> +    case KVM_X86_SEV_VM:
> +    case KVM_X86_SEV_ES_VM:
> +    case KVM_X86_SNP_VM: {
>          struct kvm_sev_init args =3D { 0 };
>
>          ret =3D sev_ioctl(sev_common->sev_fd, KVM_SEV_INIT2, &args, &fw_=
error);
> +        break;
> +    }
> +    default:
> +        error_setg(errp, "%s: host kernel does not support the requested=
 SEV configuration.",
> +                   __func__);
> +        return -1;
>      }
>
>      if (ret) {
> --
> 2.25.1
>


