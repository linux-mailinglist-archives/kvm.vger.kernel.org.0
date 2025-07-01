Return-Path: <kvm+bounces-51227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4608AAF0603
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 23:58:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7DF701C20BDF
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 21:58:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0802285C9F;
	Tue,  1 Jul 2025 21:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m1TEvbpk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C93230BE4
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 21:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751407082; cv=none; b=M9fJ2HtvcPSF7lQ3enog/n3IGe4K39HFu7HdYTm6sjP7HBSQpIEU4NpffDS4/hfJ2qKOCKg07fk4Rctd3YR2yxu7mIOt8SMiboxP5tptxhtahd04U72NousSPvJPpAWTPbhwBfdo79V6oUKW5M0KB5IbaP19Q384DEXJmsMzqUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751407082; c=relaxed/simple;
	bh=mDm2ehfj5Q3NF8ozQa+enr7H58lNW9py2cKuCC+5zPc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P7v0FN6jsNLLWlMAWUVy9up4O7EC02UF4H3tHNI9glY1UA7hpwFcFlkmkYym+vqO5E9ezzEngjeLgPMsTm2SSSTd3rmUoi28h9+pcoYk6x8ZTrMyNowzY5EjjeVv/SA8zJ70lO7nHpAcw0TMyG7P4Wc9OnsIvgCJwRbNRlq11Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m1TEvbpk; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b350d850677so1793145a12.2
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 14:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751407080; x=1752011880; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DEMJ9ahJmlFLn1yESDOTbai4m4HBBaTLoX/RasSIl9E=;
        b=m1TEvbpkgRQQf5G62WbXxu99elt38gBJSF813KPd5nZsRHb0mUbtGcuLXBRorQwZOV
         4bGeg6sFa/F+UlFB7FSTlvqnKqkcZFm4vJId8Geq0lJh0jfyLL0RgvJ+WFqqagCIFeRK
         2sPqnStKmzTDfuVAjzEqIFqRHaI5obMCFL9y5BqHCPixlPmV+YpJ39LfW1jsNGp9DnEq
         E968aQtk4B4fKyH8HtKZA2uZHvJj3S0+4yNg/br19nl6lWPX0oLWUyFGZuMWpVgR4RQi
         FRuxtJhdTEQSl6KhnBmSH4bhxuNzxQzyjFL3s+hFpNJQoFqMOthWPSsIw5HV8TJEet6a
         EgSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751407080; x=1752011880;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DEMJ9ahJmlFLn1yESDOTbai4m4HBBaTLoX/RasSIl9E=;
        b=hudzBqDgAis6DPuRyvxt+hERZ4MCLLUZ0o4FA8TkuC2kZYR4YCeEr5B8VR9SN+s1ck
         5y8I642qsqtIestQtpIlzFyRcu25jKzb9LGFEk0bKWcNluVQs1VUexokEEod1o7026N5
         pp3YiBaPU3vy0XiRDaL8FfE13TubaGzUQI5Wb4/tBD/EyqDxFiSg5/3kzL/noejwNdLa
         aYoPRUU3K1WCyZwyMehvpRDHz7XJfGdDKFp47VNc7dEAqJv0l34W3e9+DOXYBtzTLw8a
         pagwPiipSoI0VZtWa10kn7wkBcUWVIQevzS2vZN4e3Qm5YqDzpQhvBp+gNBMifX3dnIQ
         vD/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUelCp1TKJG/PG+yEEpM2CCKz23i8hT4i/9wEetd0ObxIA+1/PGr0jVv/UyqpYnY/jYc3Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyu6LjMO8jzSeAxqBgSVLrl2g+BL9i2AaLLMjmr37rYZc/bHmR0
	NO5YWEBsBIiuAhhbMhpxYWbsnVLkBq9txwomHlWB9Rc5BAzaOWHlWQrjII+NAxB+BK3r7egDLeO
	2rfKZzw10jXD5dNTS3ZFTc2p1nA==
X-Google-Smtp-Source: AGHT+IHI1rzsU+9GV8xzFMDh4yw3G10yPBB7NoB4Ea/5w0yFsZzcT9zZm65gbX0Rlw8COJlOytlTQlVzIX/NQMS3gA==
X-Received: from pfbbx7.prod.google.com ([2002:a05:6a00:4287:b0:747:b682:5cc0])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:3948:b0:1f5:9016:3594 with SMTP id adf61e73a8af0-222d7e16281mr1203700637.18.1751407079873;
 Tue, 01 Jul 2025 14:57:59 -0700 (PDT)
Date: Tue, 01 Jul 2025 14:57:58 -0700
In-Reply-To: <diqzy0t74m61.fsf@ackerleytng-ctop.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <a3cace55ee878fefc50c68bb2b1fa38851a67dd8.camel@intel.com>
 <diqzms9vju5j.fsf@ackerleytng-ctop.c.googlers.com> <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
 <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki>
 <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
 <diqz5xghjca4.fsf@ackerleytng-ctop.c.googlers.com> <aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com>
 <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com>
 <diqzms9pjaki.fsf@ackerleytng-ctop.c.googlers.com> <fe6de7e7d72d0eed6c7a8df4ebff5f79259bd008.camel@intel.com>
 <aGNrlWw1K6nkWdmg@yzhao56-desk.sh.intel.com> <cd806e9a190c6915cde16a6d411c32df133a265b.camel@intel.com>
 <diqzy0t74m61.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <diqzqzyz4lqx.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
From: Ackerley Tng <ackerleytng@google.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
Cc: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>, 
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, 
	"Shutemov, Kirill" <kirill.shutemov@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>, 
	"Peng, Chao P" <chao.p.peng@intel.com>, "Du, Fan" <fan.du@intel.com>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>, 
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, 
	"Li, Zhiquan1" <zhiquan1.li@intel.com>, "pgonda@google.com" <pgonda@google.com>, 
	"x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Ackerley Tng <ackerleytng@google.com> writes:

> "Edgecombe, Rick P" <rick.p.edgecombe@intel.com> writes:
>
>> On Tue, 2025-07-01 at 13:01 +0800, Yan Zhao wrote:
>>> > Maybe Yan can clarify here. I thought the HWpoison scenario was about=
 TDX
>>> > module
>>> My thinking is to set HWPoison to private pages whenever KVM_BUG_ON() w=
as hit
>>> in
>>> TDX. i.e., when the page is still mapped in S-EPT but the TD is bugged =
on and
>>> about to tear down.
>>>=20
>>> So, it could be due to KVM or TDX module bugs, which retries can't help=
.
>>
>> We were going to call back into guestmemfd for this, right? Not set it i=
nside
>> KVM code.
>>
>
> Perhaps we had different understandings of f/g :P
>
> I meant that TDX module should directly set the HWpoison flag on the
> folio (HugeTLB or 4K, guest_memfd or not), not call into guest_memfd.
>

Sorry, correction here, not "TDX module" but the TDX part of KVM within
the kernel. Not the TDX module code itself. Sorry for the confusion.

> guest_memfd will then check this flag when necessary, specifically:
>
> * On faults, either into guest or host page tables=20
> * When freeing the page
>     * guest_memfd will not return HugeTLB pages that are poisoned to
>       HugeTLB and just leak it
>     * 4K pages will be freed normally, because free_pages_prepare() will
>       check for HWpoison and skip freeing, from __folio_put() ->
>       free_frozen_pages() -> __free_frozen_pages() ->
>       free_pages_prepare()
> * I believe guest_memfd doesn't need to check HWpoison on conversions [1]
>
> [1] https://lore.kernel.org/all/diqz5xghjca4.fsf@ackerleytng-ctop.c.googl=
ers.com/
>
>> What about a kvm_gmem_buggy_cleanup() instead of the system wide one. KV=
M calls
>> it and then proceeds to bug the TD only from the KVM side. It's not as s=
afe for
>> the system, because who knows what a buggy TDX module could do. But TDX =
module
>> could also be buggy without the kernel catching wind of it.
>>
>> Having a single callback to basically bug the fd would solve the atomic =
context
>> issue. Then guestmemfd could dump the entire fd into memory_failure() in=
stead of
>> returning the pages. And developers could respond by fixing the bug.
>>
>
> This could work too.
>
> I'm in favor of buying into the HWpoison system though, since we're
> quite sure this is fair use of HWpoison.
>
> Are you saying kvm_gmem_buggy_cleanup() will just set the HWpoison flag
> on the parts of the folios in trouble?
>
>> IMO maintainability needs to be balanced with efforts to minimize the fa=
llout
>> from bugs. In the end a system that is too complex is going to have more=
 bugs
>> anyway.
>>
>>>=20
>>> > bugs. Not TDX busy errors, demote failures, etc. If there are "normal=
"
>>> > failures,
>>> > like the ones that can be fixed with retries, then I think HWPoison i=
s not a
>>> > good option though.
>>> >=20
>>> > > =C2=A0 there is a way to make 100%
>>> > > sure all memory becomes re-usable by the rest of the host, using
>>> > > tdx_buggy_shutdown(), wbinvd, etc?
>>>=20
>>> Not sure about this approach. When TDX module is buggy and the page is =
still
>>> accessible to guest as private pages, even with no-more SEAMCALLs flag,=
 is it
>>> safe enough for guest_memfd/hugetlb to re-assign the page to allow
>>> simultaneous
>>> access in shared memory with potential private access from TD or TDX mo=
dule?
>>
>> With the no more seamcall's approach it should be safe (for the system).=
 This is
>> essentially what we are doing for kexec.

