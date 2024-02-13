Return-Path: <kvm+bounces-8622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AF05D85337A
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 15:45:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 254931F28B0B
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 14:45:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58BE25EE97;
	Tue, 13 Feb 2024 14:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="irM0pIq9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98A95EE76
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 14:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707835496; cv=none; b=S1rOz5vSK0uJfnW+wIc/7lqLxXmQx6v7/okXRU9LfaM6SJT6kA0qdhtVi9Ikt7IHQB2roFHtJxR74PkYMpCHHTT2Q5ZP6HZsEbqJUWANJl7jYODh69jyWSGzQTQdDoA4ikaZHzmCm+bVTxXZqVZ3NC8zESuuPUE8wVesGaITxWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707835496; c=relaxed/simple;
	bh=zrp1jYmeufkgvEJ++dKa30QKIP/asFvdIN1B35Li7yY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eB6i1K/SaP2YmbfA2eOcRCahQsO1mqdaXbTq0mW84sN2FhbDa4GCIWJeGPLy3dOZHeibITk7JvuPn+BMjk+8Wf++JKE8JhivvGgEyMEs4YVtl6XuwPL3zYTZQGDmWJMgtqZaTawMMs5MkZER0uCPX+QnW+bUkPXvpA9ghqoCe8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=irM0pIq9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707835493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4DLK0DUt5g/OoNKxvjhPb6fsxTrNbXXf8Ovb5F/JdWE=;
	b=irM0pIq9hcHx77zKbSdaF8pImET/cdVook1DDd3TSl7io9slqq2IrVfm80xuorfZ3ETaJ+
	eA+96oNif+eE3c/0sHNSSjyP36ejfd2QXenIN3AkfOsDc00LnvrwrrGKjOOjUSEFNvsvMp
	L/d0iVWqKUrOBMqODf/57qDVKia4i4E=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-331-wF4fQ0smMBeJjmkAyS6TPw-1; Tue, 13 Feb 2024 09:44:50 -0500
X-MC-Unique: wF4fQ0smMBeJjmkAyS6TPw-1
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-7d302c6a708so3747886241.0
        for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 06:44:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707835490; x=1708440290;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4DLK0DUt5g/OoNKxvjhPb6fsxTrNbXXf8Ovb5F/JdWE=;
        b=VNDc8abYIqNbpp4UFxZuev1Yv3QRdDNk5zMYxMpcMe/6g/zkyBHdBiymjXp5NUEMkX
         qUhgUxxrU7Po+tSfMCZ9Np6T8ZT7fpFFiiK81TGHcXc56pfE06YwxYLykWWtYUK4Z2Aj
         /1JpxczS7xqnxQ0rXQWN1bnaPw7h5BnYaT/DQhLkASCALR09mGdv1T8yjjEQIcx/2sOM
         KhaIDnyAlpb7wx8/GsmZmkBvfgv0f6G5tgA0eN1VUIocKiFCIz/hIKALPDt27yDFSNjF
         moaJTwCQ7Uy+9Fr5EByLa1VDlZ5HNMSN54hxINuMbMzmbvNCEY6+ENCEGDR+xO2/+G4z
         jDHA==
X-Forwarded-Encrypted: i=1; AJvYcCXNYE3sBgAWp1GIK4HbFBPaw2jRLabtI+h2LLSdArV4J477bJnlHX9ortHC60JkIcWejzzqU/nQW29sBWO9XQ7QkoyV
X-Gm-Message-State: AOJu0Yw6R64txku11sORjXGuOeBI1HFk7huM7Kun0RYrIPpnycvV37N6
	dr2TKC4+8MZQLSt0JV3jPheQMETAB2WTrk7HHWt2v5lNfz6z8nPVavqU+MTyYxMJlXYE8dk6RmV
	Dcwp3ncHGmebAllRCqNc6kIyGrR3Ss8BZ7d04fi1Aw9U2cqY9eAag38QrYLXzlsfatlYS1Z7Fjm
	m0CgFhMr3pYQxWR3HKPLsPoxY7
X-Received: by 2002:a05:6102:2c4:b0:46d:6e11:c0fd with SMTP id h4-20020a05610202c400b0046d6e11c0fdmr8106178vsh.30.1707835489556;
        Tue, 13 Feb 2024 06:44:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEpLqH2ZnuQY8Xy72ouPWk8IrE0MHvEY8tBhHWMixdHCeUQ+OlENP0m40KanyJY0c/J8dOR5ljyqX+pphnSBUU=
X-Received: by 2002:a05:6102:2c4:b0:46d:6e11:c0fd with SMTP id
 h4-20020a05610202c400b0046d6e11c0fdmr8106166vsh.30.1707835489264; Tue, 13 Feb
 2024 06:44:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240209183743.22030-1-pbonzini@redhat.com> <ZcZ_m5By49jsKNXn@google.com>
 <CABgObfaum2=MpXE2kJsETe31RqWnXJQWBQ2iCMvFUoJXJkhF+w@mail.gmail.com> <ZcrX_4vbXNxiQYtM@google.com>
In-Reply-To: <ZcrX_4vbXNxiQYtM@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 13 Feb 2024 15:44:37 +0100
Message-ID: <CABgObfY=aGJNMk4CYb7nvauBWLJVbwVaA69bOK4bLteH7YyBNA@mail.gmail.com>
Subject: Re: [PATCH 00/10] KVM: SEV: allow customizing VMSA features
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	aik@amd.com, isaku.yamahata@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 13, 2024 at 3:46=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>   __u32 flags;
>   __u32 vm_type;
>   union {
>         struct tdx;
>         struct sev;
>         struct sev_es;
>         struct sev_snp;
>         __u8 pad[<big size>]
>   };
>
> Rinse and repeat for APIs that have a common purpose, but different paylo=
ads.
>
> Similar to KVM_{SET,GET}_NESTED_STATE, where the data is wildly different=
, and
> there's very little overlap between {svm,vmx}_set_nested_state(), I find =
it quite
> valuable to have a single set of APIs.  E.g. I don't have to translate be=
tween
> VMX and SVM terminology when thinking about the APIs, when discussing the=
m, etc.
>
> That's especially true for all this CoCo goo, where the names are ridicul=
ously
> divergent, and often not exactly intuitive.  E.g. LAUNCH_MEASURE reads li=
ke
> "measure the launch", but surprise, it's "get the measurement".

I agree, but then you'd have to do things like "CPUID data is passed
via UPDATE_DATA for SEV and INIT_VM for TDX (and probably not at all
for pKVM)". And in one case the firmware may prefer to encrypt in
place, in the other you cannot do that at all.

There was a reason why SVM support was not added from the beginning.
Before adding nested get/set support for SVM, the whole nested
virtualization was made as similar as possible in design and
functionality to VMX. Of course it cannot be entirely the same, but
for example they share the overall idea that pending events and L2
state are taken from vCPU state; kvm_nested_state only stores global
processor state (VMXON/VMCS pointers on VMX, and GIF on SVM) and,
while in guest mode, L1 state and control bits. This ensures that the
same userspace flow can work for both VMX and SVM. However, in this
case we can't really control what is done in firmware.

> The effort doesn't seem huge, so long as we don't try to make the paramet=
ers
> common across vendor code.  The list of APIs doesn't seem insurmountable =
(note,
> I'm not entirely sure these are correct mappings):

While the effort isn't huge, the benefit is also pretty small, which
comes to a second big difference with GET/SET_NESTED_STATE: because
there is a GET ioctl, we have the possibility of retrieving the "black
box" and passing it back. With CoCo it's anyway userspace's task to
fill in the parameter structs. I just don't see the possibility of
sharing any code except the final ioctl, which to be honest is not
much to show. And the higher price might be in re-reviewing code that
has already been reviewed, both in KVM and in userspace.

Paolo

>   create
>   init VM   (LAUNCH_START / TDH.MNG.INIT)
>   update    (LAUNCH_UPDATE_DATA / TDH.MEM.PAGE.ADD+TDH.MR.EXTEND)
>   init vCPU (LAUNCH_UPDATE_VMSA / TDH.VP.INIT)
>   finalize  (LAUNCH_FINISH / TDH.MR.FINALIZE)


