Return-Path: <kvm+bounces-65635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 185B1CB17D2
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 01:29:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 39DD730288ED
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 00:29:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2266B1A9F91;
	Wed, 10 Dec 2025 00:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n97u0DNB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F2E19E97F
	for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 00:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765326553; cv=none; b=AqCIkUJspR6ay4bCVW8kvQPovGO1OWZ5I4hEKXbvcYlzwK4XYyyZjMV/Zb46VN6x5VqoGMiizwnMD9c+xityKIworzbcPw7yQe/wf2wc73aPXuKX7xb3+AfmdlQQxp3BOq1lRBsNZVdjCCeWvpSnlU25CAv/K/MIiEgpip3stOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765326553; c=relaxed/simple;
	bh=7uJN0jD1QHwTlzzksHbnYpmgCovWBrN4pm68Xr0uEjQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iur5qRXVP6u73vMWSLyJVVqzg1pzZkalNGcPNEXEcQrf6fDe2pUL5nHNoaHs6ZoriQldf+HAUVdxaMpx5lsGjItDlk0uDeV40L10aAbBz9p9CLtf1QbTdY6i6aXPBWUqhIu+HG+ADpjypGYERQxJsYcYMHBtVwWPEiGTaYKOXkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n97u0DNB; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-645ed666eceso3105a12.1
        for <kvm@vger.kernel.org>; Tue, 09 Dec 2025 16:29:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765326550; x=1765931350; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7uJN0jD1QHwTlzzksHbnYpmgCovWBrN4pm68Xr0uEjQ=;
        b=n97u0DNBaITWCzxv2s0FWtuTKOx1224yhbESr4bIh96b9Nj+0H1SK9au/jgsSGSA0G
         CNXZnrD6i8tqnk35KRBvvWs8Bwixlf43k6M92SMWkj2Kt/x1EEWb9Ecyuju8r39QcoWV
         gcXZlcYeSwqOGJyYnJlVIOOvM+m+x6pn+GVVIrkiIDqCE5bcwlrTBbw6AMI9tEFzeRz0
         s7EAVDLIBmpGSnpw/roqgn2oIQd3Utk2WxV8O+UjhmcLoYZdPTLckpfS5ZYOs46ytxUG
         9quw0bMaftY9Qt3zqEE//9vLY9FvaYhKDluDqlrUQt0awl5q0/Mvv8B1gDLb1a8cbIsd
         aj8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765326550; x=1765931350;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7uJN0jD1QHwTlzzksHbnYpmgCovWBrN4pm68Xr0uEjQ=;
        b=rmO9056c0NZxBfy0lZ59DDYpJwGPZCq54m0+Y6C9qwH/ayKVEdpuEqoilnEXg6+oUn
         YBW6q696JtIrrq3+PLv8wjEwdWx5ifJXoXfwOMZqRzwY0TUuZp8YAy3kKCZXoX77CGAA
         msnZu2GnHW6QULt84t6TWc3NiWXtDdKX8ZWEaxyNwUP4HPXKNSUnDm3DAc5C1Vb2Cmem
         X+OzN5fnEzxLbToqsokwR7kJLdFSd53OELGnlyJ92cXOnMf1UQ6iL3+MiBmnLH9frZPk
         WbhBUhKwvVRojdJhHDlwzNt2190oPvGf8WlkuoMR70ytQ2goXJ3OBWWzBPv1CeIbkCnj
         9DTg==
X-Forwarded-Encrypted: i=1; AJvYcCW9unsxLsPdJmmAwhb9S/LeiqIDM2Il7lzqrVMeGelRfwOasLszlEP+o6jZBSy/iwfQ1vU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy27yTu9KrT1i13oTiEDuqFH/kDLg0FNCr8SI7W65bp+XZGGOdy
	dejMiECGsfcmIkpbKR25yRxNlHcRScY8gJPBfSMo3i318XsN/4ObKknF6s0/g9LH6eN5nnDSAny
	Imy3dBG2Z+FXIEUA/vVkjEBcOfeZY68dCSJvwFyQO
X-Gm-Gg: AY/fxX63Q41FDVX63qBwVfTagXKuS9YPgofbq8+C3714e0Ol6+xwch7XzuKpcO9l/UB
	91Dz6BR6GaJOz6+6Apy7roYkuTZBnlpIFp24jPC0WM3ZvBYvljC0aqTz8WGMPE6MCNzYevJgzWU
	w0Zg2kLpWo4wIPTMQ8dcFZ98eJmlEI+3g/7/blwcW+lih6JI6h7EdJ6WjrlNu/8a435Vr/jHgAf
	KB0fiOlLMoa3eQyO9eRptrJ9Wh3JCrrSYckPg8f2MHM1UvZCPNmv19ES0iVGIhqjwUWRkWeNfoO
	tSRWJ35xY/Vp6sGVx7wvQfxO1Ww=
X-Google-Smtp-Source: AGHT+IHS9pcQ+7PxKkLkyJuKGJUchfEDtSRbVHDtCuNTpu8qPm0fI/M4Me4rppfLslY9EoZwgLXkPPLBtyAYO4qeLko=
X-Received: by 2002:a05:6402:d4d:b0:643:bfa:62cd with SMTP id
 4fb4d7f45d1cf-6496e5644e0mr7162a12.11.1765326549570; Tue, 09 Dec 2025
 16:29:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250807093950.4395-1-yan.y.zhao@intel.com> <20250807094333.4579-1-yan.y.zhao@intel.com>
 <CAAhR5DGNXi2GeBBZUoZOac6a7_bAquUOzBJuccbeJZ1r97f0Ag@mail.gmail.com> <5b9c454946a5fb6782c1245001439620f04932b3.camel@intel.com>
In-Reply-To: <5b9c454946a5fb6782c1245001439620f04932b3.camel@intel.com>
From: Sagi Shahar <sagis@google.com>
Date: Tue, 9 Dec 2025 18:28:56 -0600
X-Gm-Features: AQt7F2r4RlPpNgn1UdytByJ8XIgq_nuS43-qyNEiCXLRa1fbHZ4vOR1VxRpm6ms
Message-ID: <CAAhR5DHuhL_oXteqvcFPU_eh6YG38=Gwivh6emJ9vOj5XO_EgQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 10/23] KVM: TDX: Enable huge page splitting under
 write kvm->mmu_lock
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, 
	"Du, Fan" <fan.du@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>, 
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"tabba@google.com" <tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com" <seanjc@google.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com" <ackerleytng@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"Peng, Chao P" <chao.p.peng@intel.com>, "zhiquan1.li@intel.com" <zhiquan1.li@intel.com>, 
	"Annapurve, Vishal" <vannapurve@google.com>, "Miao, Jun" <jun.miao@intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "pgonda@google.com" <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 9, 2025 at 5:54=E2=80=AFPM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
>
> On Tue, 2025-12-09 at 17:49 -0600, Sagi Shahar wrote:
> > I was trying to test this code locally (without the DPAMT patches and
> > with DPAMT disabled) and saw that sometimes tdh_mem_page_demote
> > returns TDX_INTERRUPTED_RESTARTABLE. Looking at the TDX module code
> > (version 1.5.16 from [1]) I see that demote and promote are the only
> > seamcalls that return TDX_INTERRUPTED_RESTARTABLE so it wasn't handled
> > by KVM until now.
>
> Did you see "Open 3" in the coverletter?

I tested the code using TDX module 1.5.24 which is the latest one we
got. Is there a newer TDX module that supports this new functionality?

