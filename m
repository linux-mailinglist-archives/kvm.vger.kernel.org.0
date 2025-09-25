Return-Path: <kvm+bounces-58761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A451B9FA5E
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 15:45:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 498E52E1916
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 13:45:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18367279782;
	Thu, 25 Sep 2025 13:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Gwqrv2UA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371A52741A6
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 13:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758807899; cv=none; b=Rz0IBex3CMWBq/85gpIdJ7WNrsUabXziJXR8PylqNDfzPbI95h9ojsctsz2XiPbyfXoJaR80LnTpo5Ma79908Im7NDPCRULVsGC+2kIjYW78ukXTUq5bUG3KdxMZMgMth77aIpOwEOkANo1U9hoI6UMQuM3umaYFV2xbd+ZtQ/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758807899; c=relaxed/simple;
	bh=Z0F6rvv+vHHHgqN2/7WrnWaBdoTfLfsx+4E1sr2dpYo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tIwlnq1m1dA580Q8eRa5tmqJDpM79as+4i3CJMNxRkWS31zeA69WqA4BdMmZ52GRf6662p7SNGGYW5JU6Ahff6E1jvcQXnBqoDo4dC8Hx/qoERB9ufW6u6Ai7Y8Erq+jW2cnOTHKgjZ5rwYXiJZHep+Y8ZDHuY3eqiqRVg/zEgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Gwqrv2UA; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4bb7209ec97so1147421cf.1
        for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 06:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758807896; x=1759412696; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=N5TRZaIKsL5BDWNX1fB2oE8143OJVf1xWjoYHdxo8R0=;
        b=Gwqrv2UA8Ax9RMydlVr9JpasaE19jt+Hwkk1c1vdYAnZtfqiEPHsQxMynF99pQG/IS
         S8OZxZo7rqlTttZ3/KiyDoN0eF9CvW3U1Icncy+Vggtt5ITg3cvEEsINE3Bdw+YLiJwU
         ZojJSpH0r+jF79v9bGTUMSEHIqlAHs1SqWv4KwDamrYyOyvJ5/Y+CRDgO6R6/M02lhWf
         yoJjCmNGR924SUhz6cp0Tw82lX9eW9B3yhFYRk1nxobrOLdS0qBVgDRUn84dFLu3YqcN
         UIXJRlB4/unDwbCsUBg7V+Mm9yc+pUkWa6oPuU2w03cAMTxNxJ4MXZtvPj58sDGwGO7S
         /v5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758807896; x=1759412696;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N5TRZaIKsL5BDWNX1fB2oE8143OJVf1xWjoYHdxo8R0=;
        b=tRCwZ1CSgVeyVmbo395P8khPrDPuBNMcBIaO6Hzm+XaC75Gqcm6DBRAyvNv/lG8ku2
         vcJVDGumI48ho/WPSfjp89ldA3DCs5xYkF0678Pc4FkTxbg1ZQNwP2g6hrolpnI+saG2
         aGJZc9WU1fbRZlgIrRcvyMxLX3MTTY/WdKPaEApXUiKf0gNRznI6m3meb9hPEzfJeMIA
         ZJMh3zxgBfewpXX/cZ224niJHUAvPvKBJnUd1Wbb2y4pMfYzcGD/HRfCV5lYrz9Zs9ez
         OL1KMixvdEvJuO5N4kbW/cW9OF2eBCMFhUb0Og2nFpdfVMTcN+Fy6RZARG5f088TzEgP
         ZD9g==
X-Forwarded-Encrypted: i=1; AJvYcCXYfpaoR+p+9SlhLR1xhOAuOZhEG9SQxlmFufWX3mwLvFfqiubl3eUMxdIb9ZPeeXxnqaw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxx0qu/cVskUxfXTpFZYuiF4n1Lh+5YLbNyYPwCfFuKGaZz96P/
	+fkNHY3y/g7ZIZldFafKKAEOLBy5enCZj/V/Pl3uAj9uyaPi0TVDVxaUUoXRhxRJgsi4eycrIer
	ZLWT1CTSUORweFPLbPF8thIg5aZtOx2F41eUPKAwb
X-Gm-Gg: ASbGncvtstvUHNQQ2jwvWsxC1Vd83Xl76wOQUM3cosGMVEDAZVyUjS+2CjrbiJCveJv
	PYkGTZRjvq6yMez/yLK8e/a/WrCDf6nASicjmiYxVCchOK95vI80SO5OhLBdZZ56njbFZbWvUAE
	bKJjWU+Mtl0qEKoUuhO8F5sme1pLT3EZz5Yep4xK45EpUTS1fTAxx71nck97Pyt/QnZcDZUFqxe
	+u9kisajFMkTWSh69XvXBFSug==
X-Google-Smtp-Source: AGHT+IHMjlzJoU4go98o9OLI3ONqf4XSyVwqhgPkrMYYKQ3q5Z+I56IySJAtT5Z6pWwXAgA4n71MeTiHJXaU1zjAWA0=
X-Received: by 2002:ac8:5996:0:b0:4b6:2d44:13c4 with SMTP id
 d75a77b69052e-4da2f12a974mr6481551cf.10.1758807895145; Thu, 25 Sep 2025
 06:44:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250827175247.83322-2-shivankg@amd.com> <20250827175247.83322-7-shivankg@amd.com>
 <diqztt1sbd2v.fsf@google.com> <aNSt9QT8dmpDK1eE@google.com>
 <dc6eb85f-87b6-43a1-b1f7-4727c0b834cc@amd.com> <b67dd7cd-2c1c-4566-badf-32082d8cd952@redhat.com>
 <aNVFrZDAkHmgNNci@google.com>
In-Reply-To: <aNVFrZDAkHmgNNci@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 25 Sep 2025 14:44:18 +0100
X-Gm-Features: AS18NWD8QPp_e9025CtzHt-1GmqDfc-4KC-skp25M5mSn0nTsRNLyfZiLblKLT4
Message-ID: <CA+EHjTz=PnAOdjaPuHRnXE+CTUHCKVSnf-LA6bgwKpWbapy_0Q@mail.gmail.com>
Subject: Re: [PATCH kvm-next V11 4/7] KVM: guest_memfd: Use guest mem inodes
 instead of anonymous inodes
To: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@redhat.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, willy@infradead.org, akpm@linux-foundation.org, 
	pbonzini@redhat.com, shuah@kernel.org, vbabka@suse.cz, brauner@kernel.org, 
	viro@zeniv.linux.org.uk, dsterba@suse.com, xiang@kernel.org, chao@kernel.org, 
	jaegeuk@kernel.org, clm@fb.com, josef@toxicpanda.com, 
	kent.overstreet@linux.dev, zbestahu@gmail.com, jefflexu@linux.alibaba.com, 
	dhavale@google.com, lihongbo22@huawei.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, paul@paul-moore.com, 
	jmorris@namei.org, serge@hallyn.com, pvorel@suse.cz, bfoster@redhat.com, 
	vannapurve@google.com, chao.gao@intel.com, bharata@amd.com, nikunj@amd.com, 
	michael.day@amd.com, shdhiman@amd.com, yan.y.zhao@intel.com, 
	Neeraj.Upadhyay@amd.com, thomas.lendacky@amd.com, michael.roth@amd.com, 
	aik@amd.com, jgg@nvidia.com, kalyazin@amazon.com, peterx@redhat.com, 
	jack@suse.cz, hch@infradead.org, cgzones@googlemail.com, ira.weiny@intel.com, 
	rientjes@google.com, roypat@amazon.co.uk, chao.p.peng@intel.com, 
	amit@infradead.org, ddutile@redhat.com, dan.j.williams@intel.com, 
	ashish.kalra@amd.com, gshan@redhat.com, jgowans@amazon.com, 
	pankaj.gupta@amd.com, papaluri@amd.com, yuzhao@google.com, 
	suzuki.poulose@arm.com, quic_eberman@quicinc.com, 
	linux-bcachefs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Thu, 25 Sept 2025 at 14:41, Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Sep 25, 2025, David Hildenbrand wrote:
> > On 25.09.25 13:44, Garg, Shivank wrote:
> > > On 9/25/2025 8:20 AM, Sean Christopherson wrote:
> > > I did functional testing and it works fine.
> >
> > I can queue this instead. I guess I can reuse the patch description and add
> > Sean as author + add his SOB (if he agrees).
>
> Eh, Ackerley and Fuad did all the work.  If I had provided feedback earlier,
> this would have been handled in a new version.  If they are ok with the changes,
> I would prefer they remain co-authors.

These changes are ok by me.
/fuad

> Regarding timing, how much do people care about getting this into 6.18 in
> particular?  AFAICT, this hasn't gotten any coverage in -next, which makes me a
> little nervous.

