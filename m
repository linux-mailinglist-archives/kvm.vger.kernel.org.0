Return-Path: <kvm+bounces-30386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 110569B9B50
	for <lists+kvm@lfdr.de>; Sat,  2 Nov 2024 00:54:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32CF31C21241
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 23:54:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CD0A1E7677;
	Fri,  1 Nov 2024 23:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ve9RlS3/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5691CEE88
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 23:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730505262; cv=none; b=J7iRqyPctr5tIkmgS7NWSGBSoLue09UBDe9GvyF+CtuSI2UQehsb9UcJmuj3wqX7pgxZrqAa1mubSm72x99oTWnP7o30YwKAicDyDcngJar3toByFPhGQpoUNL4Kq7hOmCWwF3os5Pn2puKw8mmFbHSQkX5XqRWf9NDKzhE5KYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730505262; c=relaxed/simple;
	bh=yTJKn1AFIFfuDgNX/0/sXW9FSsYOmdezLZ0LPNEMizY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h5VBU9e5heq9YK9HtpXLuVIcpDu9ZS8roFbDolYv7OcRd38MgYWOkdOHCfBsjZy84Lk3ZxXSuZeZyZOz/aecuV5g2gDidQKj9Uwnim0X3wrEUU5BiJxAU14pCwz0hjRWO+A9ULs+A0guy//1UyGoBv/h5mblXoPYtLYloEhM+qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ve9RlS3/; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5c941623a5aso6102296a12.0
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 16:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730505258; x=1731110058; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s46yAeYtRZRXErnvIrcHa5aBLJ0YN/7lb71VHZ7n0/8=;
        b=ve9RlS3/YK6sM0Tiiw3Cs7epWWiYoJtx3VjgN1EN/iZi5FyROb4LB5hEjP5gfwnmK9
         PiXdmoSj9UdbsSLby+ElyvEs8L7MbUAcm37NeIpOvZv0lJFvtaltuEf0/haAs9nRNvOb
         mE1liANwBEXuh+o3NuKJqgqi16N/oHO/jgsupPfyglaO2mNbO+BD+CRPlIB+dV6uX2KU
         H5T77qM9yJbHCDpPZwU/pYFQ5anEe5vhyWjRV072KfKWVz/3byDXeUqyUWNFFo6wQguA
         BH5zUvsq2i1bQ1C7qlZrBpPMj3oB7eTHwjCc1zToaOymNU4dkax7wo1hkg8uZlV+9ISF
         GBzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730505258; x=1731110058;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s46yAeYtRZRXErnvIrcHa5aBLJ0YN/7lb71VHZ7n0/8=;
        b=FQPOSN4VKyLzfE5no3mvKi48axSLINeIUI1tst4lhpsaACBLxfNuFPPSgk4x+iPUSS
         SqDvOwEnlcWY3rHQMxRP4mCWA40eCHy5OdpcRbtACikBo383j/D7QgV88CY//QZ240R+
         XAoQKu/QqbNeuZO5cN2+BEasnCSjNe99TvbrvMq/HoWrwS2QHnqVoAqTSOjM/YTOfgaP
         O43X+ev8Pf01qHFD87wHQ0XPDAo4aoIYqz3J3YyRLtXqmJD3fzfXgNEIppcSrEktISmj
         MHyEyckPaWjPPllaPR4/tsctMp5IZoc9LRlCqUZRPwpJrCq2BS288PPBoLGFZKYMppbQ
         xDXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXYL9I3RS8Igx/SvqPXOCAWcTqp40pg/QEqT5kLT2Ppy1IuZXG2smdi5mdzx/Sv+QEdp2I=@vger.kernel.org
X-Gm-Message-State: AOJu0YynkYgLLM9A6FZmsHLg1k4Z5oHuUZsxwXFZRS5GppwKn7LlNTZO
	yqHiWOKjRuoAHzOGlkMZBfASNaaATTn3kux9TdFkS9a6H+ImJ07wQ251TDR13YchgnMrmBv43di
	wDBWIuLVMvKx3zjUb8UGx7hXtmz4yPhujpLhE
X-Google-Smtp-Source: AGHT+IH/ohEDCZvXVI6OyWtqbyKy+nUacKivhLLATC82VvTVw4yqwsTLZMDifM/YCBBO3VEWbdD1oCAxD2Zn2cJ0Hi0=
X-Received: by 2002:a17:907:60d5:b0:a9a:e0b8:5bac with SMTP id
 a640c23a62f3a-a9e65434d81mr490930566b.23.1730505257962; Fri, 01 Nov 2024
 16:54:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240621134041.3170480-1-michael.roth@amd.com>
 <20240621134041.3170480-5-michael.roth@amd.com> <ZnwkMyy1kgu0dFdv@google.com>
 <r3tffokfww4yaytdfunj5kfy2aqqcsxp7sm3ga7wdytgyb3vnz@pfmstnvtuyg2>
 <Zn8YM-s0TRUk-6T-@google.com> <r7wqzejwpcvmys6jx7qcio2r6wvxfiideniqmwv5tohbohnvzu@6stwuvmnrkpo>
 <f8dfeab2-e5f2-4df6-9406-0aff36afc08a@linux.intel.com> <CAAH4kHZ-9ajaLH8C1N2MKzFuBKjx+BVk9-t24xhyEL3AKEeMQQ@mail.gmail.com>
 <Zx_V5SHwzDAl8ZQR@google.com> <CAAH4kHaOy0s93vp96-ZeX3PykCv_XsGM3z36=Fr1dEADsctMrg@mail.gmail.com>
 <20241101215216.qzexyzahj63vfw4d@amd.com>
In-Reply-To: <20241101215216.qzexyzahj63vfw4d@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Fri, 1 Nov 2024 16:54:05 -0700
Message-ID: <CAAH4kHa3jrW4PqNVfKYm46g9FYJqy2BhaLqHerLwZb3dp8e9aQ@mail.gmail.com>
Subject: Re: [PATCH v1 4/5] KVM: Introduce KVM_EXIT_COCO exit type
To: Michael Roth <michael.roth@amd.com>
Cc: Sean Christopherson <seanjc@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, kvm@vger.kernel.org, 
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, x86@kernel.org, 
	pbonzini@redhat.com, jroedel@suse.de, thomas.lendacky@amd.com, 
	pgonda@google.com, ashish.kalra@amd.com, bp@alien8.de, pankaj.gupta@amd.com, 
	liam.merwick@oracle.com, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Chao P Peng <chao.p.peng@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 1, 2024 at 3:04=E2=80=AFPM Michael Roth <michael.roth@amd.com> =
wrote:
>
> On Fri, Nov 01, 2024 at 01:53:26PM -0700, Dionna Amalie Glaze wrote:
> > On Mon, Oct 28, 2024 at 11:20=E2=80=AFAM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > >
> > > On Fri, Sep 13, 2024, Dionna Amalie Glaze wrote:
> > > > We can extend the ccp driver to, on extended guest request, lock th=
e
> > > > command buffer, get the REPORTED_TCB, complete the request, unlock =
the
> > > > command buffer, and return both the response and the REPORTED_TCB a=
t
> > > > the time of the request.
> > >
> > > Holding a lock across an exit to userspace seems wildly unsafe.
> >
> > I wasn't suggesting this. I was suggesting adding a special ccp symbol
> > that would perform two sev commands under the same lock to ensure we
> > know the REPORTED_TCB that was used to derive the VCEK that signs an
> > attestation report in the MSG_REPORT_REQ guest request. We use that
> > atomicity to be sure that when we exit to user space to request
> > certificates that we're getting the right version certificates.
> >
> > >
> > > Can you explain the race that you are trying to close, with the exact=
 "bad" sequence
> > > of events laid out in chronological order, and an explanation of why =
the race can't
> > > be sovled in userspace?  I read through your previous comment[*] (whi=
ch I assume
> > > is the race you want to close?), but I couldn't quite piece together =
exactly what's
> > > broken.
>
> Hi Dionna,
>
> >
> > 1. the control plane delivers a firmware update. Current TCB version
> > goes up. The machine signals that it needs new certificates before it
> > can commit.
> > 2. VM performs an extended guest request.
> > 3. KVM exits to user space to get certificates before getting the
> > report from firmware.
> > 4. [what I understand Michael Roth was suggesting] User space grabs a
> > file lock to see if it can read the cached certificates. It reads the
> > certificates and releases the lock before returning to KVM.
> > 5. the control plane delivers the certificates to the machine and
> > tells it to commit. The machine grabs the certificate file lock, runs
> > SNP_COMMIT, and releases the file lock. This command updates both
> > COMMITTED_TCB and REPORTED_TCB.
> > 6. KVM asks firmware to complete the MSG_REPORT_REQ request, but it's
> > a different REPORTED_TCB.
> > 7. Guest receives the wrong certificates for certifying the report it
> > just received.
> >
> > The fact that 4 has to release the lock before getting the attestation
> > report is the problem.
>
> We wouldn't actually release the lock before getting the attestation
> report. There's more specifics on the suggested flow in the documentation
> update accompanying this patch:
>
> +    NOTE: In the case of SEV-SNP, the endorsement key used by firmware m=
ay
> +    change as a result of management activities like updating SEV-SNP fi=
rmware
> +    or loading new endorsement keys, so some care should be taken to kee=
p the
> +    returned certificate data in sync with the actual endorsement key in=
 use by
> +    firmware at the time the attestation request is sent to SNP firmware=
. The
> +    recommended scheme to do this is:
> +
> +      - The VMM should obtain a shared or exclusive lock on the path the
> +        certificate blob file resides at before reading it and returning=
 it to
> +        KVM, and continue to hold the lock until the attestation request=
 is
> +        actually sent to firmware. To facilitate this, the VMM can set t=
he
> +        ``immediate_exit`` flag of kvm_run just after supplying the cert=
ificate
> +        data, and just before and resuming the vCPU. This will ensure th=
e vCPU
> +        will exit again to userspace with ``-EINTR`` after it finishes f=
etching
> +        the attestation request from firmware, at which point the VMM ca=
n
> +        safely drop the file lock.
> +
> +      - Tools/libraries that perform updates to SNP firmware TCB values =
or
> +        endorsement keys (e.g. via /dev/sev interfaces such as ``SNP_COM=
MIT``,
> +        ``SNP_SET_CONFIG``, or ``SNP_VLEK_LOAD``, see
> +        Documentation/virt/coco/sev-guest.rst for more details) in such =
a way
> +        that the certificate blob needs to be updated, should similarly =
take an
> +        exclusive lock on the certificate blob for the duration of any u=
pdates
> +        to endorsement keys or the certificate blob contents to ensure t=
hat
> +        VMMs using the above scheme will not return certificate blob dat=
a that
> +        is out of sync with the endorsement key used by firmware.
>
> So #5 would not be able to obtain an exclusive file lock until userspace
> receives confirmation that the attestation request was processed by
> firmware. At that point it will be an accurate reflection of the
> attestation state associated with that particular version of the
> certificates that was fetched from userspace. So at that point the,
> transaction is done at that point and userspace can safely release the lo=
ck.
>

Thanks for the clarification. I'll need to understand this pathway
better in our VMM to test this patch series effectively.
Will get back to you.

> -Mike
>
> > If we instead get the report and know what the REPORTED_TCB was when
> > serving that request, then we can exit to user space requesting the
> > certificates for the report in hand.
> > A concurrent update can update the reported_tcb like in the above
> > scenario, but it won't interfere with certificates since the machine
> > should have certificates for both TCB_VERSIONs to provide until the
> > commit is complete.
> >
> > I don't think it's workable to have 1 grab the file lock and for 5 to
> > release it. Waiting for a service to update stale certificates should
> > not block user attestation requests. It would make 4's failure to get
> > the lock return VMM_BUSY and eventually cause attestations to time out
> > in sev-guest.
> >
> > >
> > > [*] https://lore.kernel.org/all/CAAH4kHb03Una2kcvyC3W=3D1ZfANBWF_7a7z=
sSmWhr_r9g3rCDZw@mail.gmail.com
> >
> >
> >
> > --
> > -Dionna Glaze, PhD, CISSP, CCSP (she/her)



--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)

