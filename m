Return-Path: <kvm+bounces-13460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C4A7F896F9C
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 14:57:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E07B28F57E
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 12:57:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B36E3148305;
	Wed,  3 Apr 2024 12:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fSZBEQOv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE395B05E
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 12:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712149001; cv=none; b=jwfLsje4Nr/WgITlWfXlw6WiQYxJKCfv0jjTYBK2s+QexKK68Zj+cDAEdDTLHz+cWQ1lPWbBDs5vnsE9ZkX8rzLnQhaOUBq+uIg1+FoifOTwsVcgjM2HKn3jcO+yIk9YGhY/xTD0CfmktNdsUREJbGRjLjthC++29rNwWY3JQOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712149001; c=relaxed/simple;
	bh=k75X6e+xXR/2CHetkCcWpWKqu9lH9n9uyWfcUV8by6c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L2CHaerYTKmKWZNX63IWb9Vay+ZezMwFieeG1/ghquQFq7FnPSTXN+SJuugwS0Mr7H6WcvkNoqwAP3blsirsuJwBPIQ2w9MaizN09zK4vDmEEFsazJ7vzhdgn2EyoGk2g2FLNYkdi7Uq21zQyrGkgOU0ic6cLYx3Bk20z4PM1xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fSZBEQOv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712148999;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8yewPQMR0S+4mdQyXSXgCBzYxRYzMDeDenPXpOjBMmY=;
	b=fSZBEQOvTc0wfYf0KXWHfNGI8sImRmBBDuHVj2nAs4CJ1LAudBlDctCdQx45y61a1zzeNd
	v9euQ2ATcxDfxfKciRK5TdKspHEcJsTEr+blmT4vEe5rooEwHsJQIpzMRKKlOuStz6+60B
	YfND0lCs7lROtGgzMjx5rgKx/E1YvPo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-442-PKJrzwzJP7aatb_XO9U0vA-1; Wed, 03 Apr 2024 08:56:37 -0400
X-MC-Unique: PKJrzwzJP7aatb_XO9U0vA-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3439f7e0803so285075f8f.3
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 05:56:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712148997; x=1712753797;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8yewPQMR0S+4mdQyXSXgCBzYxRYzMDeDenPXpOjBMmY=;
        b=ZyRR5YZAeJIU01904i7W4Q4OS0zDHBOITZJbOenNRkuVP812R/kqawq7YpaSVQg6OC
         S8DZ+f+HCkjrurkhfsmdLdwZcD/QN4Vw+7RXys3b/R/OpwNvd7ShnnYxGpfd5GB1JM5f
         Jwqekd4pxT4SGK3n9J33n17Zn/HyUfDD4oCawXWf+3J2zgpbJEFNVjnJZTZvJqY4bPwR
         6JClGISNWJpMwPancgBH1XoKBIRN9fWbnTLPP4SVtF02/SVGUhrEivNyLWtupVhHN8q3
         zvLy64Zv7dLrDYcb0fRK30nIfHXhP3ruTmW8TvarlQJ9O+mlg/VmDYYFHUsLO+se9di2
         /w3g==
X-Gm-Message-State: AOJu0YzoghR/kIOUWWM7R6kpLTRwdJgrgBjMZLD7F2cr6NVgx31NgpLy
	UVgaN1N/DnzVFZpqoc9yLNOLcf7DME52X4baWK2TV/S/ymk8qqEOJ5pCviawkm0yCfPw4vecurq
	9AWOe3q1ywF5aPRIzSV1Kbqn0Mtr1xqFD4QXrNJCzITKafSyrQQrRCKzghKlVby3745rB7cpVoS
	NcHLuLaJCKEyE3nOTM39APqidH
X-Received: by 2002:a5d:6585:0:b0:343:8551:8d90 with SMTP id q5-20020a5d6585000000b0034385518d90mr2514206wru.34.1712148996807;
        Wed, 03 Apr 2024 05:56:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFE6EvC96kkgT6mLgn0vUrYteEazg+ord6iBHG8W1WaPauUUkwzs1ek0iVVbDOhQrMvTDS6MXHEqaCEHyYWr0U=
X-Received: by 2002:a5d:6585:0:b0:343:8551:8d90 with SMTP id
 q5-20020a5d6585000000b0034385518d90mr2514173wru.34.1712148996414; Wed, 03 Apr
 2024 05:56:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240329225835.400662-1-michael.roth@amd.com> <20240329225835.400662-13-michael.roth@amd.com>
 <40382494-7253-442b-91a8-e80c38fb4f2c@redhat.com> <20240401231731.kjvse7m7oqni7uyg@amd.com>
In-Reply-To: <20240401231731.kjvse7m7oqni7uyg@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 3 Apr 2024 14:56:25 +0200
Message-ID: <CABgObfYPT8yLvCDdc0B+4t4xCbk8deZg_G0_QVY_DcR_7--xSw@mail.gmail.com>
Subject: Re: [PATCH v12 12/29] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, 
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, seanjc@google.com, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, 
	Brijesh Singh <brijesh.singh@amd.com>, Harald Hoyer <harald@profian.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 2, 2024 at 1:18=E2=80=AFAM Michael Roth <michael.roth@amd.com> =
wrote:
>
> On Sat, Mar 30, 2024 at 09:41:30PM +0100, Paolo Bonzini wrote:
> > On 3/29/24 23:58, Michael Roth wrote:
> > >
> > > +           /* Handle boot vCPU first to ensure consistent measuremen=
t of initial state. */
> > > +           if (!boot_vcpu_handled && vcpu->vcpu_id !=3D 0)
> > > +                   continue;
> > > +
> > > +           if (boot_vcpu_handled && vcpu->vcpu_id =3D=3D 0)
> > > +                   continue;
> >
> > Why was this not necessary for KVM_SEV_LAUNCH_UPDATE_VMSA?  Do we need =
it
> > now?
>
> I tried to find the original discussion for more context, but can't seem =
to
> locate it. But AIUI, there are cases where a VMM may create AP vCPUs earl=
ier
> than it does the BSP, in which case kvm_for_each_vcpu() might return an A=
P
> as it's first entry and cause that VMSA to get measured before, leading
> to a different measurement depending on the creation ordering.

I think that would be considered a bug in either the VMM or the
"thing" that computes the measurement.

If that hasn't been a problem for SEV-ES, I'd rather keep the code simple.

> We could however limit the change to KVM_X86_SEV_ES_VM and
> document that as part of KVM_SEV_INIT2, since there is similarly chance
> for measurement changes their WRT to the new FPU/XSAVE sync'ing that was
> added.

Hmm, I need to double check that the FPU/XSAVE syncing doesn't break
existing measurements, too.

Paolo


