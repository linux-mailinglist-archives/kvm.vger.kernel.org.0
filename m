Return-Path: <kvm+bounces-37464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0E95A2A4C9
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 10:40:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E502188806C
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 09:40:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCF0422619B;
	Thu,  6 Feb 2025 09:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RUp8/gWS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3FD2040B5
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 09:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738834799; cv=none; b=RN8mvOCT5WEeT8afwBPTz9k7M9xJbZtIpKf9bgMGywvIyuRweYTCM83vns8Z6PuVTw1MMSGpWaev2+5DAriIph2qNgZ7T/pByxpVWU3fRIyxiTpHvCUuZb90fjrYYL80Pc9RYqJWjqZpTmPLcnvOntTlZ6sF+O2x7H7FSgWsMRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738834799; c=relaxed/simple;
	bh=gUOJAR/IhF6W8eDgXv3ClulP9RNWZufA1luYSwdQr9M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F9cWPCMUKK3hW6z1El0m/gZfyCT0rZreTbBKtEE+BLLwyVAJXM/gpl567b48p1EqFyrB93KmbsbCkzQ5AhcqU0fQg1h3rkkw4pXFP7kBStfj365oc2AmbR5/E8yPPtqo8DSF24lUkaLVUq6wymFXDipKBJHGtSbkepsjP1Tt8IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RUp8/gWS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738834797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Slh+3aS/DFBIr8NU6qSeOiy2+t+1bb6Ex5yCMZLyEX0=;
	b=RUp8/gWSE96jvBONMHeOBNkJUZQxpD92c/pqdixrcS9u6s+tbtILIvXuSv5YgchTsBW+9z
	xKbq5h/h7S2AW+h7m3FDFMb543YuzftMsrWqvHJLX578n8N0jc2phgyUwPV95L5TWI0Oqu
	GTw9T02Bq+Yz1q3KZEGE+cqtbvEuoxE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-94-g45areAkNc-7bvse_R1BBg-1; Thu, 06 Feb 2025 04:39:55 -0500
X-MC-Unique: g45areAkNc-7bvse_R1BBg-1
X-Mimecast-MFC-AGG-ID: g45areAkNc-7bvse_R1BBg
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-38dbe50b2d0so183880f8f.2
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2025 01:39:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738834794; x=1739439594;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Slh+3aS/DFBIr8NU6qSeOiy2+t+1bb6Ex5yCMZLyEX0=;
        b=gankoM3MTRTMRTXf7xIAC5/5MaSRHOM7H8s08f3DXZ7UuPbzzzK13ZUzPrtmJp8cR3
         6V9tlY6m72FgUPAgPlkvSm1QBHxYkNpPxZD5BXd5WvQtMn9rr8fBkxm2cFv14wVZ8r0V
         9cZSx+H/lVpVkEPGpYRjS5+tvhHqTZAk8SHgh8wRmfa4GNLihqBh4XYvRiEo2fKUbBYs
         1NwRclfTLS4u5FCS494bBHjWxJ5Rlhb5/LiqZGUE5X1zNb8uKKguR9fiiLqfPj7Semn0
         GzPJqM30rGKdh+pPDPaU3Rj739PZTMhK83fYqGVea7kp7jmzWvtAd2BsgYuP/1Dyj0h7
         4l4w==
X-Gm-Message-State: AOJu0Yy7Vuc+vCX5Ze2D16YXTbqilTxSfxh+fzV9S4lF6orgaQt1CsJr
	7/cKIh+sYijtR2Uv8gF9umbJKXdb0YiS3lNbNmaX2PpV/QmNKxMJjcbgh9SUd/X2hhrLPQ+VbOD
	2tzx7VCWbxTnr/A+rwdZqG65tfB5IZAJrISTCo8loorIsOS45IdgJVg6M2Gs8udj/5nmSRQ5rV3
	+nkeYuy4ZiyIFia1ix98j4Faru
X-Gm-Gg: ASbGncux012dNbKNq9GIKLH0ysNF5hDh+I4S3bF8OKHN1dywEoxB8FBHXB+lKg2X/vq
	+Cbr2rDLJRIUcPv7EXBsCkDW22RQ2cVvz69xNpz+zy3a8vMmsJ7rsf8wZszZF
X-Received: by 2002:a5d:6d0f:0:b0:38b:ed7b:f78c with SMTP id ffacd0b85a97d-38db48866e3mr4206907f8f.6.1738834794312;
        Thu, 06 Feb 2025 01:39:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFt1CKO3f+CKE86dCJf9SFD0HAGBkgCM6QuRYHkjTayEXfsiwk+GtsfQLqmG4W1+7DCRz/WrjgtbJiqHvGPn30=
X-Received: by 2002:a5d:6d0f:0:b0:38b:ed7b:f78c with SMTP id
 ffacd0b85a97d-38db48866e3mr4206885f8f.6.1738834793778; Thu, 06 Feb 2025
 01:39:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250131112510.48531-1-imbrenda@linux.ibm.com>
In-Reply-To: <20250131112510.48531-1-imbrenda@linux.ibm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 6 Feb 2025 10:39:42 +0100
X-Gm-Features: AWEUYZldEt24bKTnw1J_kYzAkz0ajMtG1oWtCzM4mLYPm5oA4c2iRM_4HgBti8I
Message-ID: <CABgObfb1BztPabrsJcWOOrM7eb6N9FExas-wrCHf4G++6ngEaw@mail.gmail.com>
Subject: Re: [GIT PULL v2 00/20] KVM: s390: some non-trivial fixes and
 cleanups for 6.14
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com, 
	borntraeger@de.ibm.com, david@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 31, 2025 at 12:25=E2=80=AFPM Claudio Imbrenda
<imbrenda@linux.ibm.com> wrote:
>
> Ciao Paolo,
>
> please pull the following changes:
>
> - some selftest fixes
> - move some kvm-related functions from mm into kvm
> - remove all usage of page->index and page->lru from kvm
> - fixes and cleanups for vsie

Pulled, thanks.

Paolo

>
> and this time I did not forget any Signed-off-by: tags! *facepalm*
> sorry for the noise
>
>
> The following changes since commit 72deda0abee6e705ae71a93f69f55e33be5bca=
5c:
>
>   Merge tag 'soundwire-6.14-rc1' of git://git.kernel.org/pub/scm/linux/ke=
rnel/git/vkoul/soundwire (2025-01-29 14:38:19 -0800)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/=
kvm-s390-next-6.14-2
>
> for you to fetch changes up to 32239066776a27287837a193b37c6e55259e5c10:
>
>   KVM: s390: selftests: Streamline uc_skey test to issue iske after sske =
(2025-01-31 12:03:53 +0100)
>
> ----------------------------------------------------------------
> - some selftest fixes
> - move some kvm-related functions from mm into kvm
> - remove all usage of page->index and page->lru from kvm
> - fixes and cleanups for vsie
>
> ----------------------------------------------------------------
> Christoph Schlameuss (1):
>       KVM: s390: selftests: Streamline uc_skey test to issue iske after s=
ske
>
> Claudio Imbrenda (14):
>       KVM: s390: wrapper for KVM_BUG
>       KVM: s390: fake memslot for ucontrol VMs
>       KVM: s390: selftests: fix ucontrol memory region test
>       KVM: s390: move pv gmap functions into kvm
>       KVM: s390: use __kvm_faultin_pfn()
>       KVM: s390: get rid of gmap_fault()
>       KVM: s390: get rid of gmap_translate()
>       KVM: s390: move some gmap shadowing functions away from mm/gmap.c
>       KVM: s390: stop using page->index for non-shadow gmaps
>       KVM: s390: stop using lists to keep track of used dat tables
>       KVM: s390: move gmap_shadow_pgt_lookup() into kvm
>       KVM: s390: remove useless page->index usage
>       KVM: s390: move PGSTE softbits
>       KVM: s390: remove the last user of page->index
>
> David Hildenbrand (4):
>       KVM: s390: vsie: fix some corner-cases when grabbing vsie pages
>       KVM: s390: vsie: stop using page->index
>       KVM: s390: vsie: stop messing with page refcount
>       KVM: s390: vsie: stop using "struct page" for vsie page
>
> Sean Christopherson (1):
>       KVM: Do not restrict the size of KVM-internal memory regions
>
>  Documentation/virt/kvm/api.rst                   |   2 +-
>  arch/s390/include/asm/gmap.h                     |  20 +-
>  arch/s390/include/asm/kvm_host.h                 |   6 +-
>  arch/s390/include/asm/pgtable.h                  |  21 +-
>  arch/s390/include/asm/uv.h                       |   6 +-
>  arch/s390/kernel/uv.c                            | 292 +---------
>  arch/s390/kvm/Makefile                           |   2 +-
>  arch/s390/kvm/gaccess.c                          |  44 +-
>  arch/s390/kvm/gmap-vsie.c                        | 142 +++++
>  arch/s390/kvm/gmap.c                             | 212 +++++++
>  arch/s390/kvm/gmap.h                             |  39 ++
>  arch/s390/kvm/intercept.c                        |   7 +-
>  arch/s390/kvm/interrupt.c                        |  19 +-
>  arch/s390/kvm/kvm-s390.c                         | 237 ++++++--
>  arch/s390/kvm/kvm-s390.h                         |  19 +
>  arch/s390/kvm/pv.c                               |  21 +
>  arch/s390/kvm/vsie.c                             | 106 ++--
>  arch/s390/mm/gmap.c                              | 681 +++++------------=
------
>  arch/s390/mm/pgalloc.c                           |   2 -
>  tools/testing/selftests/kvm/s390/ucontrol_test.c |  32 +-
>  virt/kvm/kvm_main.c                              |  10 +-
>  21 files changed, 990 insertions(+), 930 deletions(-)
>  create mode 100644 arch/s390/kvm/gmap-vsie.c
>  create mode 100644 arch/s390/kvm/gmap.c
>  create mode 100644 arch/s390/kvm/gmap.h
>


