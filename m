Return-Path: <kvm+bounces-52332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B795B040BB
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 15:58:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D64D73AB1FB
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 13:56:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 841FE2550AF;
	Mon, 14 Jul 2025 13:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vpcBp9V4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4635D253F35
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 13:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752501364; cv=none; b=rzE00cg/et8eTloHQjShBsAiOHpzmsRrWZIRfnZXKv4f+4hK3JMju+TnXtpbgkcx0cNEq3hGpEsAMbp8i7wXLSO2Cs4SSYNt0RtooGPZy79kP/c/fWHVZxtamzUkhS2OxjHXptHRy3B4qArQhGPPuxxoumy+he5p9Q1jcD7rXVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752501364; c=relaxed/simple;
	bh=rGhecsS5zqdVzGkJ8mfxbZvJAAAPC3oLxFoLmPkse8g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oxUBMm35L1GcNxYJ849e5buKCRThU/5mfJ6UfrgKxM2o62dL5Y2n221jgu5o0jgp0TsR16YIt11o16zy+suDbUhCKvmp0WJR0r/v06JDx+6+GXdbdSa6W8D/UXl3eL57MFBOVgbdUgFQMcmVWe0kXVJWQUiigPbtz570keGaWko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vpcBp9V4; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b3510c0cfc7so3388257a12.2
        for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 06:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752501362; x=1753106162; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EXh0L/pGZDzDzCdxhlAQW5J9KGhlFeCsERcM0Y4KBG4=;
        b=vpcBp9V4U/2qTIDXUzketDvpstEx7/Vy357Ts/dZgiEdLmwvY1oxpbEpunz/YO6KYP
         j7NtH9eisRlLgCJpY6W/8FA8IoC0mmiBRi+1BWt1ipEkS44OzL6TkeSfLRF8IsJhxzkB
         g4PyW+fiuI6wyrs4w5TjglBi953yn/Pce70w0kdL3G91yQ4MhkTM1sOBZShQlO+wvwn4
         Mwh1ukvd7U83FBytRr7dhqLQSHiDHVbFcAfOgQZKqMrRgIJsURLejsg6TIwIRZyiAUNZ
         +PXiZe/uu6xXOho6D3Qjwcn4r+MPLwJnGmLJ+h62mxeodND7jWbctgG8N2TXoDQ1B/TC
         abBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752501362; x=1753106162;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EXh0L/pGZDzDzCdxhlAQW5J9KGhlFeCsERcM0Y4KBG4=;
        b=wVduDqZ+oukdhFp32qAKzk7O/x4otFPKKlxzZWQ6TZ47YBybcbleXY5sfm73Ts5MCA
         wcroB7nGXjJMof4LCXWypU7pVO56oJ1huq5Dh4LqPJD16LRGFHi+UbSwQCt1IlFR2uRP
         uk7uxE8jiHUQk0ET1s+hU8TdyEe4djjLTgA+nC3MLM1DG0UZV8y+kuCIIIMwPK2hvhns
         ABky8sR4PEWw6JLvtauLU/ph7ELbQzYDNJxkEgvoiyOM0nA0fcYRiIHT5Q/3hAsmg5yc
         mbSXFtTAbOcX7hoLyYIyTcaFkci8fedMGmNknC20vVoV0Q30MOIRSTXNkRf4wwafxBsM
         nUaw==
X-Forwarded-Encrypted: i=1; AJvYcCVfZJLX/dmImInvgz3gBeXdMjoVVb8dFA/CYq0AJNKmgH1KJMAEb0UzNMXOPqFm92hOUWM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrFl5LDDQOrbSwdI7r2Jr1DcTsct9wx4L9dxees+q6b2mr40CK
	EhC1SJepoVsVf/9Fp3MxsDr8SgozzkKv2ibZDjHWo18kgGZbv4P3slG0Yv7V5tqrdQiH3tiYZcr
	e2kXCdg==
X-Google-Smtp-Source: AGHT+IFl/YgxxHUr8RELnZrkLBz3elV9AgIPvwir5e7dKByJGwTe0aB87PdvtxPSEkZwzCbcImbXo4vL0Ko=
X-Received: from pjbpx9.prod.google.com ([2002:a17:90b:2709:b0:311:f699:df0a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b8d:b0:313:b1a:3939
 with SMTP id 98e67ed59e1d1-31c50da140amr19072297a91.15.1752501362484; Mon, 14
 Jul 2025 06:56:02 -0700 (PDT)
Date: Mon, 14 Jul 2025 06:56:01 -0700
In-Reply-To: <3ef581f1-1ff1-4b99-b216-b316f6415318@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <175088949072.720373.4112758062004721516.b4-ty@google.com>
 <aF1uNonhK1rQ8ViZ@google.com> <7103b312-b02d-440e-9fa6-ba219a510c2d@intel.com>
 <aHEMBuVieGioMVaT@google.com> <3989f123-6888-459b-bb65-4571f5cad8ce@intel.com>
 <aHEdg0jQp7xkOJp5@google.com> <b5df4f84b473524fc3abc33f9c263372d0424372.camel@intel.com>
 <aHGYvrdX4biqKYih@google.com> <a29d4a7f319f95a45f775270c75ccf136645fad4.camel@intel.com>
 <3ef581f1-1ff1-4b99-b216-b316f6415318@intel.com>
Message-ID: <aHUMcdJ9Khh2Yeox@google.com>
Subject: Re: [PATCH V4 0/1] KVM: TDX: Decrease TDX VM shutdown time
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Kai Huang <kai.huang@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Adrian Hunter <adrian.hunter@intel.com>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, 
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2025, Xiaoyao Li wrote:
> On 7/12/2025 7:17 AM, Edgecombe, Rick P wrote:
> > On Fri, 2025-07-11 at 16:05 -0700, Sean Christopherson wrote:
> > > > Zero the reserved area in struct kvm_tdx_capabilities so that field=
s added
> > > > in
> > > > the reserved area won't disturb any userspace that previously had g=
arbage
> > > > there.
> > >=20
> > > It's not only about disturbing userspace, it's also about actually be=
ing able
> > > to repurpose the reserved fields in the future without needing *anoth=
er* flag
> > > to tell userspace that it's ok to read the previously-reserved fields=
.=C2=A0 I care
> > > about this much more than I care about userspace using reserved field=
s as
> > > scratch space.
> >=20
> > If, before calling KVM_TDX_CAPABILITIES, userspace zeros the new field =
that it
> > knows about, but isn't sure if the kernel does, it's the same no?

Heh, yeah, this crossed my mind about 5 minutes after I logged off :-)

> > Did you see that the way KVM_TDX_CAPABILITIES is implemented today is a=
 little
> > weird? It actually copies the whole struct kvm_tdx_capabilities from us=
erspace
> > and then sets some fields (not reserved) and then copies it back. So us=
erspace
> > can zero any fields it wants to know about before calling KVM_TDX_CAPAB=
ILITIES.
> > Then it could know the same things as if the kernel zeroed it.
> >=20
> > I was actually wondering if we want to change the kernel to zero reserv=
ed, if it
> > might make more sense to just copy caps->cpuid.nent field from userspac=
e, and
> > then populate the whole thing starting from a zero'd buffer in the kern=
el.
>=20
> +1 to zero the whole buffer of *caps in the kernel.

Ya, I almost suggested that, but assumed there was a reason for copying the=
 entire
structure.

> current code seems to have issue on the caps->kernel_tdvmcallinfo_1_r11/k=
ernel_tdvmcallinfo_1_r12/user_tdvmcallinfo_1_r12,
> as KVM cannot guarantee zero'ed value are returned to userspace.

This?  (untested)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f4d4fd5cc6e8..42cb328d8a7d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2270,25 +2270,26 @@ static int tdx_get_capabilities(struct kvm_tdx_cmd =
*cmd)
        const struct tdx_sys_info_td_conf *td_conf =3D &tdx_sysinfo->td_con=
f;
        struct kvm_tdx_capabilities __user *user_caps;
        struct kvm_tdx_capabilities *caps =3D NULL;
+       u32 nr_user_entries;
        int ret =3D 0;
=20
        /* flags is reserved for future use */
        if (cmd->flags)
                return -EINVAL;
=20
-       caps =3D kmalloc(sizeof(*caps) +
+       caps =3D kzalloc(sizeof(*caps) +
                       sizeof(struct kvm_cpuid_entry2) * td_conf->num_cpuid=
_config,
                       GFP_KERNEL);
        if (!caps)
                return -ENOMEM;
=20
        user_caps =3D u64_to_user_ptr(cmd->data);
-       if (copy_from_user(caps, user_caps, sizeof(*caps))) {
+       if (get_user(nr_user_entries, &user_caps->cpuid.nent)) {
                ret =3D -EFAULT;
                goto out;
        }
=20
-       if (caps->cpuid.nent < td_conf->num_cpuid_config) {
+       if (nr_user_entries < td_conf->num_cpuid_config) {
                ret =3D -E2BIG;
                goto out;
        }

