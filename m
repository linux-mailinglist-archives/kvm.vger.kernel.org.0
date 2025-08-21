Return-Path: <kvm+bounces-55315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DC912B2FC5C
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 16:25:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A69AE1C21996
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 14:18:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89B98279798;
	Thu, 21 Aug 2025 14:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HlHq5C8s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B9F25B1EA
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 14:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755785801; cv=none; b=P967yJI7gcstwFRjRMXG7YaXAvIUjV98Uw4SC9Wof2Au+lECjmwUdagISF9CM5A8kb21e1GJkXab/BYTXGjgho28lP+Bf5ocmW1xdHoV1PRMuRgyQHFsNNdrkWBTBZwblPAzhLxk1Zx0/ZuIB1C9H+8iG2KUhmDTTZEGRhTIqys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755785801; c=relaxed/simple;
	bh=1tkAWHqYiQdAV0OaRcTNZKiGmz33b9jBGHqk56CS5E4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LfJzpxXIdal/DIUXNkNS4ANgUQEc7hKy47qK1gVQhnX5CNCl2JorB7DdAkR3qeB1MEa+oVQja5ms7u/YHxQlkG3+v6KiDC1oXbL8QQp1NptcR7uxNBgT+Ht87b8NQkYR/INHQ2xI4XXcY4jj8Zj3rJAmANgM4cQP7LmPuWKoCBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HlHq5C8s; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32326de9d22so1107140a91.1
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 07:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755785799; x=1756390599; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v60JnRg43/Z/SuzdqiagGE6Nvy+KddNpyWfmrQQQLtg=;
        b=HlHq5C8s7NbR0Tjf89lTfqkmWLHSx1U0rsApbUGsfHRUgZnDCAyzCSkwOOguhGl34g
         GkFcwM7Uiji4ZV8F/T4RTKtwuV/yO0yu+E0dEXDDdcQoNE6gbkKkeM+Yv73dbxGra9Nn
         RmJPGFAXlYIHCquDaPcaqKAqgqMa+muAklL3VeAq3gFkfI4YvemJuebjD+gbxrPxvXCS
         PX/oBIg28SyIPXsb7GlKB2B7rcg5wAxb2yZdRTW7aEaS/JZzM9kDcFqqxeARcSpM5A+N
         4/pc5/CKVCohSJa1cXDSoBv7MfBehhPPgB0UiAfpL9wk0O6A/tLo8IPkIz1aQXaBGB3W
         GECg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755785799; x=1756390599;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=v60JnRg43/Z/SuzdqiagGE6Nvy+KddNpyWfmrQQQLtg=;
        b=lPAtp9c7w9SjoRGIcxgkL8lqfie2x0st5FLQHaB2BsUVF777CU2nj9+tBfO7NNrV1G
         RpcCI09VKyfA3GJgbSRlh6Fe7FLhOX9UqUwzpLHaqcGt+fWJ9CQu6ZVLdmbnakFxdItd
         Gxsf6imXteTpDGKXEHL7WoZQ6WiHuGY9P8ayYEMyeusQCBaX3EXcRYUIZLYURRKe1587
         CoFPIpWyxi+TUmIHO+dn1D6paR9zOfRepLewiEmkkd91zWGoLDYAM8S2CM7MFpqazvRz
         FimttNcYVKcLIx1hq1x6BVYGVEsd4u4Dl5wdGDvz5nHyTVdC+Wxd0Ih3oYknhcEMB0tl
         C43w==
X-Forwarded-Encrypted: i=1; AJvYcCXkbM5rOTbOWH4PMEgPEwbn+hUAg12Xd7ep6Si7LTAvogbf3P3BSsJ2W/glFDWVVevdIyA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEl60NOA7TadU6f1gh/toPONWlqIyTvx1yleIMMkvaYPqKiBC5
	Souc5jWoK4Si46WuvaqauG+5ZkCnbefKR/l3Z7GppTwsEn1agueQZKAERAqZRZ1uUlqYzSBLIYo
	HshkIYQ==
X-Google-Smtp-Source: AGHT+IGJFYsu9NhtkqxOZSEJ2yGsjpjSkQ2KDspOo3rp7QmvJlQ/0/W4t/AOd8NImtz2JDxixI4rcFtOMY8=
X-Received: from pjbsl4.prod.google.com ([2002:a17:90b:2e04:b0:31e:dd67:e98])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5848:b0:31f:ecf:36f
 with SMTP id 98e67ed59e1d1-324eecf94b1mr3373124a91.1.1755785799306; Thu, 21
 Aug 2025 07:16:39 -0700 (PDT)
Date: Thu, 21 Aug 2025 07:16:37 -0700
In-Reply-To: <46cf87e2-8100-47ef-b19e-f6a1b76f660d@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1755721927.git.ashish.kalra@amd.com> <95abc49edfde36d4fb791570ea2a4be6ad95fd0d.1755721927.git.ashish.kalra@amd.com>
 <5dff05c1-474e-4fff-a19b-7c17b4db6173@infradead.org> <7eed1970-4e7d-4b3a-a3c1-198b0a6521d5@amd.com>
 <922eaff1-b2dc-447c-9b9c-ac1281ee000d@amd.com> <db253af8-1248-4d68-adec-83e318924cd8@amd.com>
 <46cf87e2-8100-47ef-b19e-f6a1b76f660d@amd.com>
Message-ID: <aKcpu-EilR04YAxX@google.com>
Subject: Re: [PATCH v9 2/2] KVM: SEV: Add SEV-SNP CipherTextHiding support
From: Sean Christopherson <seanjc@google.com>
To: Kim Phillips <kim.phillips@amd.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>, Randy Dunlap <rdunlap@infradead.org>, corbet@lwn.net, 
	pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	thomas.lendacky@amd.com, herbert@gondor.apana.org, akpm@linux-foundation.org, 
	rostedt@goodmis.org, paulmck@kernel.org, michael.roth@amd.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2025, Kim Phillips wrote:
> On 8/21/25 5:58 AM, Kalra, Ashish wrote:
> > On 8/21/2025 5:30 AM, Kim Phillips wrote:
> > > On 8/20/25 6:23 PM, Kalra, Ashish wrote:
> > > > On 8/20/2025 5:45 PM, Randy Dunlap wrote:
> > > > > On 8/20/25 1:50 PM, Ashish Kalra wrote:
> > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * If cipherte=
xt hiding is enabled, the joint SEV-ES/SEV-SNP
> > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * ASID range =
is partitioned into separate SEV-ES and SEV-SNP
> > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * ASID ranges=
, with the SEV-SNP range being [1..max_snp_asid]
> > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * and the SEV=
-ES range being [max_snp_asid..max_sev_es_asid].
> > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 [max_snp_asid + 1..max_sev_es_asid]
> > > > > ?
> > > > Yes.
> > > So why wouldn't you have left Sean's original "(max_snp_asid..max_sev=
_es_asid]" as-is?
> > >=20
> > > Kim
> > >=20
> > Because that i believe is a typo and the correct SEV-ES range is
> > [max_snp_asid + 1..max_sev_es_asid].
>=20
> It's not, though.
>=20
> [max_snp_asid..max_sev_es_asid]
>=20
> and
>=20
> (max_snp_asid..max_sev_es_asid]
>=20
> are two completely different things.

Yeah, inclusive versus exclusive (I'm quite proud that I remembered which w=
as
which, _and_ that I got it right :-D).

> You also modified Sean's Documentation/ changes.=C2=A0 A consistent "join=
t
> SEV-ES+SEV-SNP" is preferred.

FWIW, I don't have a strong preference on the exact verbiage, so long as it=
's
consistent.

