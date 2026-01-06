Return-Path: <kvm+bounces-67182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D212CFB175
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 22:34:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CE74230519C6
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 21:26:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A195E30171C;
	Tue,  6 Jan 2026 21:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V3TesJHx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6382FD7A3
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 21:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767734798; cv=none; b=p4AaePjXfyv/l5SXqn89pyzKtBVe3c/Z2Ih+lgwaLqZ7m3Fi2A8ap1QhxREXE/bawHtmMH95I5Pq0KZW2S8fFTCTYMZONcHUqnMMjEaiTgDOWxQjMI8b2+dUETxB4rpb+SrLNlTTf3uKIogJSIsVVx2FdWe3hOx27auA+aM/wzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767734798; c=relaxed/simple;
	bh=AawD7qtSH9hUs5KkfCkC/LC6tTxlvNh+sEm84JwcADk=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iGuUjSCJuON6IFWoesko5br7IwAt+WkSUxRlOmFk/okzM+zzvFrmYh/uM7Tqs4JwbG6j3azfkwItzdCUiokA10tvP8/9T/W3eY9LiL245IrdVgGEfewdgBxenF3KUkvugl6uxXEUlrNMbPdLJFGjciqfx5pRoSGHxeXVAms49p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V3TesJHx; arc=none smtp.client-ip=209.85.221.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-55b265f5122so393691e0c.1
        for <kvm@vger.kernel.org>; Tue, 06 Jan 2026 13:26:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767734796; x=1768339596; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KBOhP0QQvQUMmW1iOc39A/E3AcEgj1oxLToHtOHin6I=;
        b=V3TesJHx4jvzlz+t73fn+Mk2/rBZYA1r6CScmHToRa0lUyNGaKAnLZ+XNeSvnEWP4n
         UMsXRQR2JGc40CUtyMZu4xCH0D6vwrXohPIqQefmx2SpCTAKBTLE/UAexB0y5PzsUJHs
         sapI599EibNn1vu56fEE7e6T6kYpm2ZM1CfwY4b6rWFTPETkxYA9IjIpw9Ric3NFdAll
         iSZhW5DS4tBPB+diN73llUrnMzi1f4WB53gF26yWmvUrOOhjUwLdyF9eHgDVo3i0lpHw
         fU08vIq9gIP4GjmF09oQIO4FnyWWMweSKjSPXSlRAdudCZ32EcnbQvV1o6KApbjQwc4l
         vckA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767734796; x=1768339596;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KBOhP0QQvQUMmW1iOc39A/E3AcEgj1oxLToHtOHin6I=;
        b=YwouaLGZNiPZW4rtjt4srYoWHroCYq/821x5v0yFBgS2JaGqnW8BJH44ZuvLyvtpLY
         h7THCeR6eUB3YonjEZQ5EFiR1DRql97SsFwamgNUlqaQk0ww5XqHivjHjFIlS/8OXbzB
         h7jmTwq2AT6+v04SYfWuAJ1DnVs9A/s+1ePLDTDO63nqdq2ux+/lKk1TokBGAjmHgmVB
         UzwVo59dpd/K0IGKtJPrELiS0ZJPcDHKfKKtSFhR2xD0nxbw/Odp1c2yY9zgoRIDQuTH
         qpVzEOb5gD3jH8lsqYexSeyURtpybt7fLdlGf4q1WuxGvz3uTMvcFNn7sx+S0aS6bAkL
         slyw==
X-Forwarded-Encrypted: i=1; AJvYcCUkVZAqqfbE7o73RdEvgAcI/MXOM1RHW0I9y5U0usnfQpEdmQ7LzCQGXSNo6OfJeJh9vqo=@vger.kernel.org
X-Gm-Message-State: AOJu0YznpEKJj/1AxTuHg6HojxXVAaB+e3ChMShXy9hqU/2/xWw31B5l
	Hd8liD+Vu95o16yC2oKFmSjUcMvJmBm9z1H+n8BnU9+x+a12vEbD29PcmbljDgMFsZsc6VWdAsa
	dJOdnxl2UBgzvYGh4e0bFg2JePeG2sS0gMQALsWvT
X-Gm-Gg: AY/fxX4vuj95+7dbzIGWECVP1uEiDrLykhsb9YXHKCIOdw0qaxlEXFbYqfIOkz5sR/F
	qL+BbW2iqw8tBj6jxD706W9oBAw1cckG55X+rnMw/JH7Yi/18xcIafr9rVNfcNmYuZJakwZHRty
	7JL7vQZaDvzpexl4E3hPbELnoQ/OTOd3DgCFC8zcyxLT+sAqqLyfyTci5+224SG3/Tdojf5sUIi
	HDTSTxEjNJlsM0QSoWfYPZM9NVFEeMTMEA5enWpTyo1M91hl8hfOX2FCadiWQiuEdfPWQzG1h/w
	irSVJ6z9w/b0SAbzkeUCjU29
X-Google-Smtp-Source: AGHT+IHFDHV/7YOGF/wIYujTPgamjI2Sx2E2fK+EGMyOElb+vPhjejqpsM9VkKaVUwry/inwhDsYc3YEFkcKyFTvP3A=
X-Received: by 2002:a05:6122:3787:b0:55b:180f:fed6 with SMTP id
 71dfb90a1353d-56347fb49ecmr68873e0c.13.1767734795540; Tue, 06 Jan 2026
 13:26:35 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 6 Jan 2026 13:26:34 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 6 Jan 2026 13:26:34 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <CAGtprH-eEUzHDUB0CK2V162HHqvE8kT3bAacb6d3xDYJPwBiYA@mail.gmail.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com> <CAGtprH-eEUzHDUB0CK2V162HHqvE8kT3bAacb6d3xDYJPwBiYA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 6 Jan 2026 13:26:34 -0800
X-Gm-Features: AQt7F2pLeXlBoea_Ls-4T6t6pl8aU2a6U1p9Tr-27qBOuihl1nh8ETsVEWx9mDo
Message-ID: <CAEvNRgGG+xYhsz62foOrTeAxUCYxpCKCJnNgTAMYMV=w2eq+6Q@mail.gmail.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
To: Vishal Annapurve <vannapurve@google.com>, Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com, 
	dave.hansen@intel.com, kas@kernel.org, tabba@google.com, michael.roth@amd.com, 
	david@kernel.org, sagis@google.com, vbabka@suse.cz, thomas.lendacky@amd.com, 
	nik.borisov@suse.com, pgonda@google.com, fan.du@intel.com, jun.miao@intel.com, 
	francescolavra.fl@gmail.com, jgross@suse.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, kai.huang@intel.com, 
	binbin.wu@linux.intel.com, chao.p.peng@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Vishal Annapurve <vannapurve@google.com> writes:

> On Tue, Jan 6, 2026 at 2:19=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com> wr=
ote:
>>
>> - EPT mapping size and folio size
>>
>>   This series is built upon the rule in KVM that the mapping size in the
>>   KVM-managed secondary MMU is no larger than the backend folio size.
>>

I'm not familiar with this rule and would like to find out more. Why is
this rule imposed? Is this rule there just because traditionally folio
sizes also define the limit of contiguity, and so the mapping size must
not be greater than folio size in case the block of memory represented
by the folio is not contiguous?

In guest_memfd's case, even if the folio is split (just for refcount
tracking purposese on private to shared conversion), the memory is still
contiguous up to the original folio's size. Will the contiguity address
the concerns?

Specifically for TDX, does the folio size actually matter relative to
the mapping, or is it more about contiguity than the folio size?

>>   Therefore, there are sanity checks in the SEAMCALL wrappers in patches
>>   1-5 to follow this rule, either in tdh_mem_page_aug() for mapping
>>   (patch 1) or in tdh_phymem_page_wbinvd_hkid() (patch 3),
>>   tdx_quirk_reset_folio() (patch 4), tdh_phymem_page_reclaim() (patch 5)
>>   for unmapping.
>>
>>   However, as Vishal pointed out in [7], the new hugetlb-based guest_mem=
fd
>>   [1] splits backend folios ahead of notifying KVM for unmapping. So, th=
is
>>   series also relies on the fixup patch [8] to notify KVM of unmapping
>>   before splitting the backend folio during the memory conversion ioctl.
>
> I think the major issue here is that if splitting fails there is no
> way to undo the unmapping [1]. How should KVM/VMM/guest handle the
> case where a guest requested conversion to shared, the conversion
> failed and the memory is no longer mapped as private?
>
> [1] https://lore.kernel.org/kvm/aN8P87AXlxlEDdpP@google.com/
>

Unmapping was supposed to be the point of no return in the conversion
process. (This might have changed since we last discussed this. The link
[1] from Vishal is where it was discussed.)

The new/current plan is that in the conversion process we'll do anything
that might fail first, and then commit the conversion, beginning with
zapping, and so zapping is the point of no return.

(I think you also suggested this before, but back then I couldn't see a
way to separate out the steps cleanly)

Here's the conversion steps in what we're trying now (leaving out the
TDX EPT splitting first)

1. Allocate enough memory for updating attributes maple tree
2a. Only for shared->private conversions: unmap from host page table,
check for safe refcounts
2b. Only for private->shared conversions: split folios (note: split
only, no merges) split can fail since HVO needs to be undone, and that
requires allocations.
3. Invalidate begin
4. Zap from stage 2 page tables: this is the point of no return, before
this, we must be sure nothing after will fail.
5. Update attributes maple tree using allocated memory from step 1.
6. Invalidate end
7. Only for shared->private conversions: merge folios, making sure that
merging does not fail (should not, since there are no allocations, only
folio aka metadata updates)

Updating the maple tree before calling the folio merge function allows
the merge function to look up the *updated* maple tree.

I'm thinking to insert the call to EPT splitting after invalidate begin
(3) since EPT splitting is not undoable. However, that will be after
folio splitting, hence my earlier question on whether it's a hard rule
based on folio size, or based on memory contiguity. Would that work?

>> Four issues are identified in the WIP hugetlb-based guest_memfd [1]:
>>
>> (1) Compilation error due to missing symbol export of
>>     hugetlb_restructuring_free_folio().
>>
>> (2) guest_memfd splits backend folios when the folio is still mapped as
>>     huge in KVM (which breaks KVM's basic assumption that EPT mapping si=
ze
>>     should not exceed the backend folio size).
>>
>> (3) guest_memfd is incapable of merging folios to huge for
>>     shared-to-private conversions.
>>
>> (4) Unnecessary disabling huge private mappings when HVA is not 2M-align=
ed,
>>     given that shared pages can only be mapped at 4KB.
>>
>> So, this series also depends on the four fixup patches included in [4]:
>>

Thank you for these fixes!

>> [FIXUP] KVM: guest_memfd: Allow gmem slot lpage even with non-aligned ua=
ddr
>> [FIXUP] KVM: guest_memfd: Allow merging folios after to-private conversi=
on

Thanks for catching this, Vishal also found this in a very recent
internal review. Our fix for this is to first apply the new state before
doing the folio merge. See the flow described above.

>> [FIXUP] KVM: guest_memfd: Zap mappings before splitting backend folios
>> [FIXUP] mm: hugetlb_restructuring: Export hugetlb_restructuring_free_fol=
io()
>>
>> (lkp sent me some more gmem compilation errors. I ignored them as I didn=
't
>>  encounter them with my config and env).
>>
>> ...
>>
>> [0] RFC v2: https://lore.kernel.org/all/20250807093950.4395-1-yan.y.zhao=
@intel.com
>> [1] hugetlb-based gmem: https://github.com/googleprodkernel/linux-cc/tre=
e/wip-gmem-conversions-hugetlb-restructuring-12-08-25
>> [2] gmem-population rework v2: https://lore.kernel.org/all/2025121515341=
1.3613928-1-michael.roth@amd.com
>> [3] DPAMT v4: https://lore.kernel.org/kvm/20251121005125.417831-1-rick.p=
.edgecombe@intel.com
>> [4] kernel full stack: https://github.com/intel-staging/tdx/tree/huge_pa=
ge_v3
>> [5] https://lore.kernel.org/all/aF0Kg8FcHVMvsqSo@yzhao56-desk.sh.intel.c=
om
>> [6] https://lore.kernel.org/all/aGSoDnODoG2%2FpbYn@yzhao56-desk.sh.intel=
.com
>> [7] https://lore.kernel.org/all/CAGtprH9vdpAGDNtzje=3D7faHBQc9qTSF2fUEGc=
bCkfJehFuP-rw@mail.gmail.com
>> [8] https://github.com/intel-staging/tdx/commit/a8aedac2df44e29247773db3=
444bc65f7100daa1
>> [9] https://github.com/intel-staging/tdx/commit/8747667feb0b37daabcaee71=
32c398f9e62a6edd
>> [10] https://github.com/intel-staging/tdx/commit/ab29a85ec2072393ab268e2=
31c97f07833853d0d
>> [11] https://github.com/intel-staging/tdx/commit/4feb6bf371f3a747b71fc9f=
4ded25261e66b8895
>>

