Return-Path: <kvm+bounces-51192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 64943AEFAB5
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 15:34:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AB8197A730B
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 13:32:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93EEC274FFC;
	Tue,  1 Jul 2025 13:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zb0eajEm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456611487E9
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 13:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751376773; cv=none; b=YO1cYKe7Q5LKbh/IZebu2LvLKj6eWSYLOjKeCs87oUVFS052uLCNCb5w/EOxHlg4kLanVcdarvq3HuvlESImM5riQXlb9grE3PgD86khsxvxmLppc1TTZgZBquMq8tHX6YdkdF1Js32PuI738I3bsJbb/wEqy4Vc4WSWCze+xEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751376773; c=relaxed/simple;
	bh=ynymbXXmqQCfqites0P4IUA7UVoWDJGePQgacU+m3a8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kbV5fdGfe7D64MjU1iqYMUFJEnEIgg/YwAVUG0ZkgTpKCyyGuuuh5F50LCVleZYj+JQE6noYsVGXaP3PA745DO1VpV4CgsMAhj4SttuzZXAo+p8CnO/1RAxILrOjA3zkFLxLRGCWkOLHfudBfMVFe0j9NiNpnfaT7w+n81hYtTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zb0eajEm; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-235e389599fso220305ad.0
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 06:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751376771; x=1751981571; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ynymbXXmqQCfqites0P4IUA7UVoWDJGePQgacU+m3a8=;
        b=Zb0eajEmnnNRGKDKAHOaJBuJLdtTEkWiOZvJEa7qwjd5z/NPzqBHehYBzB6dttrtyX
         EBPK5CxxJwjIe7QY3tigyHZTpzLrHB0HSfNyNeJoauepJHdUv3AHjOw7X23PPS3UI51D
         03XEgQJlvvq2BUMAkc/vlBFUwryFQMaPlNFACDjePrAGVqTatfFArSKMNuPlAzNLwE67
         zggdGkUTGNW7Dd0Qf7CnMiilShfC/E71PAZ8rLMeWFuiSaiOvsmHoya4TWJEPRJNmyhu
         8M3vNEaHlzQ197qlS+knyd1WEzVliB45Y5VPwIL+KFqM3GgI9pegAOlA/fD7aAjKoQ3R
         ZyEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751376771; x=1751981571;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ynymbXXmqQCfqites0P4IUA7UVoWDJGePQgacU+m3a8=;
        b=ezFYoL4PxpKizXL/shDiGWFeoFaexHjEwdqV3Y3VUOu6j5WjZQxRzGhNddyEW7+x5f
         BchQnFlIr7IR3vNHZtvq6pp3mgF+5APLCqyMzTP+/CgOGzzWcqDwphXWtMOTngzAXB8O
         QlMx1BGZVWgqswaT12xgIlGZVfrMmBtZ0B3Evvr4WjJFBGXHFmai80hNtRCZb5WtZEsM
         0kGM8en2ruOlS6vEj26eQ5thP7JS9tHmDY4zcUjOSDZNEt3+0Vksm8YkCU5PEr6H1kb/
         6HsmOPGRvKwwX8QM+joydomAFrmmsPx/YrmBl6l6phs2yYnTcPv/nedodlI/KgS6fEis
         ZUCA==
X-Forwarded-Encrypted: i=1; AJvYcCWngUouB49Udpj5j+SeiJAJ6h+/PG1g65LYIk21jhz4+XtfQ3rbEx9Vy+8fC/1lepVhVZ4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7zmzNeImZx9QwRWx4RdHXNtXO8XitZ2krE7Oe5d4pNqT3Ts81
	Z3vyEEt35FDq7nrN6D3C6MNxUg4kxVvDQawMGw77hdw3JjUOG/U1gvdi1HynzZteSwUSufkqyX1
	rheculuZgev74wNcy5e4pe7YRysf6qy7/fRl50UHo
X-Gm-Gg: ASbGncsvCTO9q/wY+3jXMaQEyXavrUZ8zMBwRtoEruYY2l+CGkt87r7banLkHe06G2G
	HIiUJbn4Qf4UxdnFBztP7hz4dn4dZy5TGBbick1fRL+QArXNS5m5AU5d290li1Nitdg6FbCKjUO
	YdOsqrJzcWi9fbGNno5R4jE33GOp3qRQ65Ux5EIW207G14hFYcT+uY/Dl6OacmWWp9JPsOIaON+
	rztzA/rgYUqZ3Y=
X-Google-Smtp-Source: AGHT+IEagAKqOyClH7SOAfBHMg3NoeEcgu+JB1EzrpoRe0zsCoMAbrQJFAr0ZOE+dMR9X3WzUkkDx4WrYIwLroz2FgU=
X-Received: by 2002:a17:903:b07:b0:234:bfa1:da3e with SMTP id
 d9443c01a7336-23c5ff04d7cmr1978595ad.5.1751376771126; Tue, 01 Jul 2025
 06:32:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c69ed125c25cd3b7f7400ed3ef9206cd56ebe3c9.camel@intel.com>
 <diqz34bolnta.fsf@ackerleytng-ctop.c.googlers.com> <a3cace55ee878fefc50c68bb2b1fa38851a67dd8.camel@intel.com>
 <diqzms9vju5j.fsf@ackerleytng-ctop.c.googlers.com> <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
 <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki>
 <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
 <diqz5xghjca4.fsf@ackerleytng-ctop.c.googlers.com> <aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com>
 <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com> <aGOr90RZDLEJhieE@yzhao56-desk.sh.intel.com>
In-Reply-To: <aGOr90RZDLEJhieE@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 1 Jul 2025 06:32:38 -0700
X-Gm-Features: Ac12FXznEEaVgTq1KoEMvIM8DzuAoBbETAFwoD_TfWy7Ms2Xt9Fv1vPaChxyp8s
Message-ID: <CAGtprH86-HkfnTMmwdPsKgXxjTomvMWWAeCuZKSieb5o6MvRPQ@mail.gmail.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>, 
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com" <tabba@google.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"Peng, Chao P" <chao.p.peng@intel.com>, "Du, Fan" <fan.du@intel.com>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	"Li, Zhiquan1" <zhiquan1.li@intel.com>, "jroedel@suse.de" <jroedel@suse.de>, 
	"Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>, 
	"x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 1, 2025 at 2:38=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com> wrot=
e:
>
> On Tue, Jul 01, 2025 at 01:55:43AM +0800, Edgecombe, Rick P wrote:
> > So for this we can do something similar. Have the arch/x86 side of TDX =
grow a
> > new tdx_buggy_shutdown(). Have it do an all-cpu IPI to kick CPUs out of
> > SEAMMODE, wbivnd, and set a "no more seamcalls" bool. Then any SEAMCALL=
s after
> > that will return a TDX_BUGGY_SHUTDOWN error, or similar. All TDs in the=
 system
> > die. Zap/cleanup paths return success in the buggy shutdown case.
> All TDs in the system die could be too severe for unmap errors due to KVM=
 bugs.

At this point, I don't see a way to quantify how bad a KVM bug can get
unless you have explicit ideas about the severity. We should work on
minimizing KVM side bugs too and assuming it would be a rare
occurrence I think it's ok to take this intrusive measure.

>
> > Does it fit? Or, can you guys argue that the failures here are actually=
 non-
> > special cases that are worth more complex recovery? I remember we talke=
d about
> > IOMMU patterns that are similar, but it seems like the remaining cases =
under
> > discussion are about TDX bugs.
> I didn't mention TDX connect previously to avoid introducing unnecessary
> complexity.
>
> For TDX connect, S-EPT is used for private mappings in IOMMU. Unmap could
> therefore fail due to pages being pinned for DMA.

We are discussing this scenario already[1], where the host will not
pin the pages used by secure DMA for the same reasons why we can't
have KVM pin the guest_memfd pages mapped in SEPT. Is there some other
kind of pinning you are referring to?

If there is an ordering in which pages should be unmapped e.g. first
in secure IOMMU and then KVM SEPT, then we can ensure the right
ordering between invalidation callbacks from guest_memfd.

[1] https://lore.kernel.org/lkml/CAGtprH_qh8sEY3s-JucW3n1Wvoq7jdVZDDokvG5Hz=
Pf0HV2=3Dpg@mail.gmail.com/#t

>
> So, my thinking was that if that happens, KVM could set a special flag to=
 folios
> pinned for private DMA.
>
> Then guest_memfd could check the special flag before allowing private-to-=
shared
> conversion, or punch hole.
> guest_memfd could check this special flag and choose to poison or leak th=
e
> folio.
>
> Otherwise, if we choose tdx_buggy_shutdown() to "do an all-cpu IPI to kic=
k CPUs
> out of SEAMMODE, wbivnd, and set a "no more seamcalls" bool", DMAs may st=
ill
> have access to the private pages mapped in S-EPT.

guest_memfd will have to ensure that pages are unmapped from secure
IOMMU pagetables before allowing them to be used by the host.

If secure IOMMU pagetables unmapping fails, I would assume it fails in
the similar category of rare "KVM/TDX module/IOMMUFD" bug and I think
it makes sense to do the same tdx_buggy_shutdown() with such failures
as well.

