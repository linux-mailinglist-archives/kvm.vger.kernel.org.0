Return-Path: <kvm+bounces-42103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B8050A72B2F
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 09:15:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 260F6176A02
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 08:14:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02DB31FFC74;
	Thu, 27 Mar 2025 08:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h1qX1ibi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE621FF615
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 08:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743063285; cv=none; b=haKj9Tk7Z+dDAPV5If6FEZOUIKyGg4LT+KNxSske0zmzX3qbVE2S4O96b0oPL86inhoSJm34k8mQzdmYkiM5QbGomF4ta34oKJfsc+xWc6Uf0VLPTUufMBH+X5WiGpgakCPXSnv8j4s4D45ma8Qjps1nU5suOhIMshwrKnCrLps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743063285; c=relaxed/simple;
	bh=dqDAKLbnS5sjnD7NkwvXo/kZFn7+fO2d0R6Ff+ZBKJc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q3DqnPLzHe+L786wPjfluYOsnLAK1EV5KVTbwrQJzJci61Ha0PQ6lm7AQfdGWSAS3e76DYKm/8cfmHxYsTTsDs0sG/8lfB4FXQnLl6NLXneIIcPfd8AXAzUgIV4bID3ZQeasoVpjaUfOX79bUqwk94Uhbi9YEmekk3NghWBCo9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h1qX1ibi; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2264c9d0295so152685ad.0
        for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 01:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743063283; x=1743668083; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h9a5QRkmmOyJeIvB5Cn9PmXfV97y4kQAOBXvf9QzfDM=;
        b=h1qX1ibi9fM1XUcL6NrpzaPOn028Ine3Rf2tl6ZF1NVV0eQRqIEx6VhdC3oSKoGpgg
         THur3ZekWWo/5f0FUBO/ij9ah4vMBpjJ1Btliaj9X06+TGfUeMIwjyTDjHC1/UY4jrBX
         6RPBF1oQS/fSpDzJa7T5j3gWDMFFVIySuDELVGmot50uzj0nlNq7zNBZN9vdyUjxFPcD
         iI939mdFfF2h7k8wcYuulfLD50UH03ekSjFLpkxb7AJpANJzymGs3xzYPC8qdvAJu0QS
         OOwgR+2ZGy1uemrZ3ioc2Mv5QH+PBJI0WbqWoDwlnjxnPObh1OuyKZ2qBvuiytfIcSQk
         5ufA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743063283; x=1743668083;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h9a5QRkmmOyJeIvB5Cn9PmXfV97y4kQAOBXvf9QzfDM=;
        b=YDmjT/F6ivZgoykxFn4ko+RHmpcEAsVWYidMI5Vu4+Yo25hJQFS90PyzY0YJLUBrOl
         BnZBjgiTTjU1AHPqD1nlJGDdN6POk+NMiYkNOOdpQcqt7SDXHzO5kpFjc6iG0J+SHdLA
         hZ3ypMSqhDo8sPiU7sSq5neaoak2MSYuxhbg1r/KGf6EEJZ17fbeHGLX4fZQrSqhTxAs
         Gp6+zTZQJli2klW0+FuvIa02p5NDArQiz4FXlwNVVJ470Sp0A78lhXTEsLbyNnDXJ+07
         VcShK3wDvi6V/Y66t2HIIYHspIxb6d05gBgEVkh5eL2tsmI/mVsAmuZKrDzwHOa6+ijB
         v4lg==
X-Forwarded-Encrypted: i=1; AJvYcCWTKVMNJ9h5+/Bb5hV10My4ERh1bzG2Ex67OMT+GlervUeIhGRWe57wTD1Qhcp2wfseSH4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiudS6U1nerSn4gGiTT2KW3tEWMnu9PMgyBxiwDriuBtZYkfI2
	ms08fOIJWpi86A+RWs8X8G92emf3aUxCNyGx7MT4YItQoHPQ1YAu1PZ5z+WOHmpg9dk9WRBZrtX
	xUmjV4UKbQoneOvXCXWn9l8Ask4mPb0Nez/+R
X-Gm-Gg: ASbGncvQdsprkQezRknIVgx1aqLsmWrDdmFDTdqvjo1m7mfeNjdK7uH1dif18Ux125g
	fWji0I7D5NRaWKd1n2+tWBSm1fswHuHlR+nnzNZAUMtgc3J+e9dS2Sg5fh/aZhaVpRWdBek/Bo9
	rTVN+X0yb9O8P9uFhAnBdn3wnCGJ/J9VN88Kxs1F2Y83MhtOca9b3TFxXl8v+NmV1Bjrro6w==
X-Google-Smtp-Source: AGHT+IHgfzrQlEamv4gYgjx/fwFVnfQvhKeODD0LFSb3f0rLf6g/j0CVYOoteVLkG0M+nr3xqexqfLuYGBQj9X7EB6c=
X-Received: by 2002:a17:903:1a0b:b0:215:8723:42d1 with SMTP id
 d9443c01a7336-22806bc133bmr1942515ad.10.1743063282486; Thu, 27 Mar 2025
 01:14:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250313181629.17764-1-adrian.hunter@intel.com>
In-Reply-To: <20250313181629.17764-1-adrian.hunter@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Thu, 27 Mar 2025 01:14:29 -0700
X-Gm-Features: AQ5f1JpB0AViQmQuFfLvDkCuf5x_Lo9CiwkMjG3MaJ-5wwbn2bayOkBOcIzzqck
Message-ID: <CAGtprH_o_Vbvk=jONSep64wRhAJ+Y51uZfX7-DDS28vh=ALQOA@mail.gmail.com>
Subject: Re: [PATCH RFC] KVM: TDX: Defer guest memory removal to decrease
 shutdown time
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org, 
	rick.p.edgecombe@intel.com, kirill.shutemov@linux.intel.com, 
	kai.huang@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com, 
	isaku.yamahata@intel.com, linux-kernel@vger.kernel.org, yan.y.zhao@intel.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 13, 2025 at 11:17=E2=80=AFAM Adrian Hunter <adrian.hunter@intel=
.com> wrote:
> ...
> =3D=3D Problem =3D=3D
>
> Currently, Dynamic Page Removal is being used when the TD is being
> shutdown for the sake of having simpler initial code.
>
> This happens when guest_memfds are closed, refer kvm_gmem_release().
> guest_memfds hold a reference to struct kvm, so that VM destruction canno=
t
> happen until after they are released, refer kvm_gmem_release().
>
> Reclaiming TD Pages in TD_TEARDOWN State was seen to decrease the total
> reclaim time.  For example:
>
>         VCPUs   Size (GB)       Before (secs)   After (secs)
>          4       18              72              24
>         32      107             517             134

If the time for reclaim grows linearly with memory size, then this is
a significantly high value for TD cleanup (~21 minutes for a 1TB VM).

>
> Note, the V19 patch set:
>
>         https://lore.kernel.org/all/cover.1708933498.git.isaku.yamahata@i=
ntel.com/
>
> did not have this issue because the HKID was released early, something th=
at
> Sean effectively NAK'ed:
>
>         "No, the right answer is to not release the HKID until the VM is
>         destroyed."
>
>         https://lore.kernel.org/all/ZN+1QHGa6ltpQxZn@google.com/

IIUC, Sean is suggesting to treat S-EPT page removal and page reclaim
separately. Through his proposal:
1) If userspace drops last reference on gmem inode before/after
dropping the VM reference
    -> slow S-EPT removal and slow page reclaim
2) If memslots are removed before closing the gmem and dropping the VM refe=
rence
    -> slow S-EPT page removal and no page reclaim until the gmem is around=
.

Reclaim should ideally happen when the host wants to use that memory
i.e. for following scenarios:
1) Truncation of private guest_memfd ranges
2) Conversion of private guest_memfd ranges to shared when supporting
in-place conversion (Could be deferred to the faulting in as shared as
well).

Would it be possible for you to provide the split of the time spent in
slow S-EPT page removal vs page reclaim?

It might be worth exploring the possibility of parallelizing or giving
userspace the flexibility to parallelize both these operations to
bring the cleanup time down (to be comparable with non-confidential VM
cleanup time for example).

