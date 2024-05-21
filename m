Return-Path: <kvm+bounces-17865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4488C8CB4D9
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 22:47:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EFA65284821
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 20:47:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3357814901B;
	Tue, 21 May 2024 20:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AWGJg9jC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D427F49F
	for <kvm@vger.kernel.org>; Tue, 21 May 2024 20:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716324438; cv=none; b=bwCCXBR8gXlpDwFU9l9je+aqD+7ZsaIHID6kTLh0wcTjzWMpz1S0jTjdeXqfpPsLJgSO17BdS9/KTZDlx7RuKS6PeRxa98dS1Bn7bLBxdef36Lg0thYi5AXJh+4bNp1S2CgqPui8291rjMPaFt5085YHm2mbJb5vu1F6fKPPSO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716324438; c=relaxed/simple;
	bh=/RrA+IkihiMWw6BwGKsHsXwxUySSG2WGe39iX7tOFL4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n3S9ga87rdilABt5LoJk0SAt2wU5U2ohnbYXVKsxObxwaG7TTdeT91LD99nU+UgQ7wMxnhUwTOekQYUhY+ZhxfLPgiCOqF1lzYUCQE+oGyrE5u+VQgNeR4SJd8/qFZI8BXuSrGMQBozn1NWU233hVxmBMqc/e0WgD3eKNrQVD6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AWGJg9jC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716324435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ASHds6F2Qt89jBYBISFH+hUHw17yTjB7XJcTzPoZFHU=;
	b=AWGJg9jCm43qJN+O+MwnI/NHrExeB8ga9rbW268BPYH5pqSxQN7rU+eX4fkBVASh4f+J+d
	qtBGZhamze/OMwKcAk6Cvxb63CgToNY8c9oaOBCiTLSUjSzWvzW89OahpPMSzVz+VdVaoJ
	9m0jzPQ29B87hcVjgpdybIYUe3aQRK4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-208-tbkysa8XNwahIVV-SRW2tQ-1; Tue, 21 May 2024 16:47:14 -0400
X-MC-Unique: tbkysa8XNwahIVV-SRW2tQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-354cdfb204fso1162494f8f.1
        for <kvm@vger.kernel.org>; Tue, 21 May 2024 13:47:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716324433; x=1716929233;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ASHds6F2Qt89jBYBISFH+hUHw17yTjB7XJcTzPoZFHU=;
        b=xUsUK1W1XsNNwG4vWS335xOBqWptF1eysXkZ79biWO3rnKXcwHsTFkNndKG0zoLMOg
         mxiOkBeav8+/Y8yLgx6b3NcqVYOcqfq20xqDgi3o9XQ7HWBsQtKF/7sPwnTpT01TqEpw
         XLS1qpUIh3JG3eoFBkFuw9C+W2qiN/otg6MbIu14nWnDqMgqK7wwoTXARsPucKdUa6SL
         7wLMtNo/qaTS5ubPT4UXDpXZcCDgqr+NO3EtYktAldJoZhmyqZV/ira0CIZ5D/HEPwdi
         0aqcNl9iw/UJim2UfjqG6Rrisyvq682rUF4Hf/x1uzbCQp5kzVf25VC7ZZH+lUG8ZeLu
         PFZA==
X-Forwarded-Encrypted: i=1; AJvYcCV9dD98pHBDz9zKDADJ3UP/p453eTQWsgH+awrVaRA9t6aQr/7WZptE/dAKbxeBsdugOFOk38riBw6aJbN+nwF1iZts
X-Gm-Message-State: AOJu0Yz4OeTQgcTsq0f8BHR5yygRGfd1NML2Z2lqs2QRlTZesiuanIwi
	HLjVfUiMuOoD65Gd/hznqirVeEH5ULswz0iXvWV288Js+v1DJJj8UzXdKRMGzhDw6hvwj9Kr6iU
	vkQQoYpu5kughExFRCRToEzc9xBncFz0XWXDYvCDaRbmA0+FyKvmskEZHrK4rQa7HLpi7MzHr5a
	5h9R+VHe10mdI206fYytKL9Nru
X-Received: by 2002:adf:db44:0:b0:34b:9cd5:76ae with SMTP id ffacd0b85a97d-354d8cc8fbemr47424f8f.8.1716324433267;
        Tue, 21 May 2024 13:47:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEciNx0iM19slNMQ4HXnGJhE7jgh7LrOK8zYmVZz4vNdplHjhoIh1dd/caJ/D7gzzYeXDIvXiE2C+R8w8AY4R0=
X-Received: by 2002:adf:db44:0:b0:34b:9cd5:76ae with SMTP id
 ffacd0b85a97d-354d8cc8fbemr47417f8f.8.1716324432865; Tue, 21 May 2024
 13:47:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240416050338.517-1-ravi.bangoria@amd.com> <ZjQnFO9Pf4OLZdLU@google.com>
 <9252b68e-2b6a-6173-2e13-20154903097d@amd.com> <Zjp8AIorXJ-TEZP0@google.com>
 <305b84aa-3897-40f4-873b-dc512a2da61f@amd.com> <ZkdqW8JGCrUUO3RA@google.com>
 <b66ea07a-f57e-014c-68b4-729f893c2fbd@amd.com> <Zk0ErRQt3XH7xK6O@google.com>
In-Reply-To: <Zk0ErRQt3XH7xK6O@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 21 May 2024 22:47:01 +0200
Message-ID: <CABgObfaXAERePMQrrpWg8PqM1TOq8TJT65i3WgU0n0-vePDGNg@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: SEV-ES: Don't intercept MSR_IA32_DEBUGCTLMSR for
 SEV-ES guests
To: Sean Christopherson <seanjc@google.com>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>, thomas.lendacky@amd.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, michael.roth@amd.com, nikunj.dadhania@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, santosh.shukla@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 21, 2024 at 10:31=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Mon, May 20, 2024, Ravi Bangoria wrote:
> > On 17-May-24 8:01 PM, Sean Christopherson wrote:
> > > On Fri, May 17, 2024, Ravi Bangoria wrote:
> > >> On 08-May-24 12:37 AM, Sean Christopherson wrote:
> > >>> So unless I'm missing something, the only reason to ever disable LB=
RV would be
> > >>> for performance reasons.  Indeed the original commits more or less =
says as much:
> > >>>
> > >>>   commit 24e09cbf480a72f9c952af4ca77b159503dca44b
> > >>>   Author:     Joerg Roedel <joerg.roedel@amd.com>
> > >>>   AuthorDate: Wed Feb 13 18:58:47 2008 +0100
> > >>>
> > >>>     KVM: SVM: enable LBR virtualization
> > >>>
> > >>>     This patch implements the Last Branch Record Virtualization (LB=
RV) feature of
> > >>>     the AMD Barcelona and Phenom processors into the kvm-amd module=
. It will only
> > >>>     be enabled if the guest enables last branch recording in the DE=
BUG_CTL MSR. So
> > >>>     there is no increased world switch overhead when the guest does=
n't use these
> > >>>     MSRs.
> > >>>
> > >>> but what it _doesn't_ say is what the world switch overhead is when=
 LBRV is
> > >>> enabled.  If the overhead is small, e.g. 20 cycles?, then I see no =
reason to
> > >>> keep the dynamically toggling.
> > >>>
> > >>> And if we ditch the dynamic toggling, then this patch is unnecessar=
y to fix the
> > >>> LBRV issue.  It _is_ necessary to actually let the guest use the LB=
Rs, but that's
> > >>> a wildly different changelog and justification.
> > >>
> > >> The overhead might be less for legacy LBR. But upcoming hw also supp=
orts
> > >> LBR Stack Virtualization[1]. LBR Stack has total 34 MSRs (two contro=
l and
> > >> 16*2 stack). Also, Legacy and Stack LBR virtualization both are cont=
rolled
> > >> through the same VMCB bit. So I think I still need to keep the dynam=
ic
> > >> toggling for LBR Stack virtualization.
> > >
> > > Please get performance number so that we can make an informed decisio=
n.  I don't
> > > want to carry complexity because we _think_ the overhead would be too=
 high.
> >
> > LBR Virtualization overhead for guest entry + exit roundtrip is ~450 cy=
cles* on
>
> Ouch.  Just to clearify, that's for LBR Stack Virtualization, correct?

And they are all in the VMSA, triggered by LBR_CTL_ENABLE_MASK, for
non SEV-ES guests?

> Anyways, I agree that we need to keep the dynamic toggling.
> But I still think we should delete the "lbrv" module param.  LBR Stack su=
pport has
> a CPUID feature flag, i.e. userspace can disable LBR support via CPUID in=
 order
> to avoid the overhead on CPUs with LBR Stack.

The "lbrv" module parameter is only there to test the logic for
processors (including nested virt) that don't have LBR virtualization.
But the only effect it has is to drop writes to
MSR_IA32_DEBUGCTL_MSR...

>                 if (kvm_cpu_cap_has(X86_FEATURE_LBR_STACK) &&
>                     !guest_cpuid_has(vcpu, X86_FEATURE_LBR_STACK)) {
>                         kvm_pr_unimpl_wrmsr(vcpu, ecx, data);
>                         break;
>                 }

... and if you have this, adding an "!lbrv ||" is not a big deal, and
allows testing the code on machines without LBR stack.

Paolo

>                 svm_get_lbr_vmcb(svm)->save.dbgctl =3D data;
>                 svm_update_lbrv(vcpu);
>                 break;
>


