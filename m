Return-Path: <kvm+bounces-41450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7494DA67E7E
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 22:11:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B95BC19C3FFF
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 21:11:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9510A211471;
	Tue, 18 Mar 2025 21:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L6/fGOyI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539C51D9A49
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 21:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742332276; cv=none; b=j+1SiNFupTj5gZCQu0mHeX/sNZxv8CTuaE8FVt/IY5f7+uuOnNx4Dhc8ilh8FmChZQ3drvhi5hmJ8UNdLE6teoWkiT+aPBV4R1RDtgTni25IKMGh7XXwOftpNgu5EDzvGNd4K8eZi+4GemWhcVx1P7byOGxUCvyUheqPMh6rgPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742332276; c=relaxed/simple;
	bh=dKX7d6/PBEnCBg2zkWoFk8K9X6y8ZPUjTHQFD+gcWQQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BcOlswh2Jl1liKfEEP/+oa3Ys4jaxCTiUpvo3UxQtKR3ACkBQmRq7/Migi5QR8krPhg04CjWg76b8FVShOPVwLB1yv5CxeucYzFpuuM5QS9nq2il90Zcm7tWmRN2CrWKBHpnpf3hwfsYh0DG8SH7KnGShSi1A7cM43yXnxyNUj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L6/fGOyI; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-225489a0ae6so70515ad.0
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 14:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742332273; x=1742937073; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ELk1b1nqpO/LqnlYtTtvebO9oIOSeNJWbhKVNUR8CFg=;
        b=L6/fGOyIVQXAqPiDJnrpVsQ6wW8laGIwpijmU3e4XbZHiCxTwj8u2PqJ7hsWLuslT0
         DoWlGodg8/D7Ss6Hk6Ei+HIyWDlm07i1n011CmywMEsRVvno+PPNJWXSktMs845K+aEU
         /Aj2ac+lpF8WHnDWFeX98tVLXqMBJdScV7a8w5mu8c26IrbtReEpkzTCGmtNaFHNZfRK
         7LlZ7wQttj3tVVEjrWGNZaD8b63wYXSewDK3eNdCIvwItYc9h0ttQ0osgrxl7nhW4GGV
         bDdduTT+jQmn1C7Rtu8SJ90auykdgfG93zHp3OmNCIFpUzBte7yxrji5DnJApVcyaEYl
         eDXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742332273; x=1742937073;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ELk1b1nqpO/LqnlYtTtvebO9oIOSeNJWbhKVNUR8CFg=;
        b=gk2rVy99CrK2DnM/kWMC/taVeRbX5r6pwvf1sjEcXtQ5huYiLliyBzA0kcA7yiSBGU
         Y9W4xczAfEuvPz1ei2/FDD09JcnM7ld//LFq0X7ZRLN4Cf+OiTgdumgs6CzT2BbBUhm9
         SbxvQACeWyaGhW4O9xmwQxFKKvbpV3d2NU9mOL/pJK5S7uU7wcbneBwgps0KvQecFLOg
         M+/vu+uetOxktv2A5nkJn8Acp4JMG372RYQeyRUHWF7yhoFfhKhmTFehQ8uxxXdnUOHI
         CcRtTkV0u8/CM1zlUUUiXE6nzzZhLsQmyRMKbGDZd3DCfYGtmMihkX5cfdxXnU7lAx4z
         VEZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUft5bcwfimH3F8v5GWqnVyBtUVH6nminjL0AM3DMbuYHXo/NaA3bVe1ZoCZL20muVHrYE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvwQeZdXeKiMjUGpxhzHiMT8s8pytgV9yWhdj0LAmo9dL+HwW/
	0f981QjH+0WiIJCWWNr7IOhEQevB6fsqf9Oo13OBZzYCISQfVJoDiVl7ih2g9wkO8kA5lfOv8m7
	cxkE5VqPyKtv1j7WQK/C47eFsGUIhZMmZZF9o
X-Gm-Gg: ASbGncvi6X2UH3PnyMnK4y1QJRzAALZwjmRbbXr1E+ocObmeoi4IXYXeMlAts8LUmpA
	VvkwkcPkVcLZMS1pm+KsDhjJSM1VMeZzpiMJVv6sX8LdnZYC4fAnfZJ855U78bEZzdW/M1TN8Yr
	GVtCag74D5Vcqli8Gx9DFux/LFi773kXtKU6mGeDTKVQi94oSr3js5TaBO
X-Google-Smtp-Source: AGHT+IFGG8DLzonr6FKBbKB+H+1z7WyNrHJ731tM0Sb0OV7WezD5Dx0a7Oj/fMw+cPQIPNCBUA8F/Hx36MDDTZiafwo=
X-Received: by 2002:a17:902:e952:b0:21f:4986:c7d5 with SMTP id
 d9443c01a7336-22646fde80dmr790755ad.8.1742332273177; Tue, 18 Mar 2025
 14:11:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250313181629.17764-1-adrian.hunter@intel.com>
 <ful5rg4jmtxtpyf4apdgrcp3ohttqvwfdwbcrszf6h3jnlhlr5@pfkl6uvadwhu> <2ac8bb8e-c05b-4dc3-a2c1-43e8b936e8f3@intel.com>
In-Reply-To: <2ac8bb8e-c05b-4dc3-a2c1-43e8b936e8f3@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 18 Mar 2025 14:11:01 -0700
X-Gm-Features: AQ5f1JpAV6m7FctwYSrZje59SxYw7q6gGxEIA-wiHl6zPKMoWzRxG1yoWxqsye4
Message-ID: <CAGtprH_9nQ02Phd0RLcq7YDVOE7VKuVkvNnFktfpAsVuBUc+Ow@mail.gmail.com>
Subject: Re: [PATCH RFC] KVM: TDX: Defer guest memory removal to decrease
 shutdown time
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, pbonzini@redhat.com, seanjc@google.com, 
	kvm@vger.kernel.org, rick.p.edgecombe@intel.com, kai.huang@intel.com, 
	reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com, 
	isaku.yamahata@intel.com, linux-kernel@vger.kernel.org, yan.y.zhao@intel.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 18, 2025 at 8:42=E2=80=AFAM Adrian Hunter <adrian.hunter@intel.=
com> wrote:
>
> On 17/03/25 10:13, Kirill A. Shutemov wrote:
> > On Thu, Mar 13, 2025 at 08:16:29PM +0200, Adrian Hunter wrote:
> >> @@ -3221,6 +3241,19 @@ int tdx_gmem_private_max_mapping_level(struct k=
vm *kvm, kvm_pfn_t pfn)
> >>      return PG_LEVEL_4K;
> >>  }
> >>
> >> +int tdx_gmem_defer_removal(struct kvm *kvm, struct inode *inode)
> >> +{
> >> +    struct kvm_tdx *kvm_tdx =3D to_kvm_tdx(kvm);
> >> +
> >> +    if (kvm_tdx->nr_gmem_inodes >=3D TDX_MAX_GMEM_INODES)
> >> +            return 0;
> >
> > We have graceful way to handle this, but should we pr_warn_once() or
> > something if we ever hit this limit?
> >
> > Hm. It is also a bit odd that we need to wait until removal to add a li=
nk
> > to guest_memfd inode from struct kvm/kvm_tdx. Can we do it right away i=
n
> > __kvm_gmem_create()?
>
> Sure.
>
> The thing is, the inode is currently private within virt/kvm/guest_memfd.=
c
> so there needs to be a way to make it accessible to arch code.  Either a
> callback passes it, or it is put on struct kvm in some way.
>
> >
> > Do I read correctly that inode->i_mapping->i_private_list only ever has
> > single entry of the gmem? Seems wasteful.
>
> Yes, it is presently used for only 1 gmem.

Intrahost migration support[1] will make use of this list to track
additional linked files. We are planning to float a next revision
soon.

[1] https://lore.kernel.org/lkml/ZN%2F81KNAWofRCaQK@google.com/t/

>
> >
> > Maybe move it to i_private (I don't see flags being used anywhere) and
> > re-use the list_head to link all inodes of the struct kvm?
> >
> > No need in the gmem_inodes array.
>
> There is also inode->i_mapping->i_private_data which is unused.
>

