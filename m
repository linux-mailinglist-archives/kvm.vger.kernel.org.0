Return-Path: <kvm+bounces-37769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C8D4A2FFFB
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 02:17:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0BBE77A142E
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 01:16:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 339CC1B87F3;
	Tue, 11 Feb 2025 01:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vkxekRZA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B022AD16
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 01:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739236608; cv=none; b=OveuVKx2/rAP4Dga+DL1a6dKDqe78EHrgkKcCt9bLUNP8Oan+TcCp/Dc1Azjg71OM7O95GUSrGcBiGsbjD6ocpv6KACAbbOlpVdPc9pfse3Pq164VRrQGjGx5+Ggu1tDCYlV7bgh/M3lx+P21UWCbIp998LH98jpNXeGTN7wbus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739236608; c=relaxed/simple;
	bh=4bMf2krmehBME/JGGSJ2OFdq4bknMLcJ1KY7t6wdCdU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X+PEiNfC6HfeDOXRfkJFRi1taPCr+JNl7z+QtnSaiHQEn8lBgduN51P7LyHO9WZKhXpSaGSrcU6WYt5qVFOOgrfJZnHnHU4WaWohnxz7c6B7gDJC3T39Mqm7j7DGrb+yFJjzmNacBehyiiLra8Ie889F+7k/SENR4cxoZ/LX9M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vkxekRZA; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5440f27da4fso2876e87.0
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 17:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739236604; x=1739841404; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MIDLn0ElhLkZLGHEXZdCvG2zMlN0W10JkA618ESIp5I=;
        b=vkxekRZAi6lY5O53eCJluc66k4fUO5y0FaKA0jM2rD6BAlweuG28El+AdS4hhV8VUg
         qS8BR7JsTimggOLKhFV5QfJjVNlKnt7lftYyHB3cOtEU7hftrN/03MWApQjrajUa8EcY
         N9PiXRymasmWlA8C4kI2KxH8hrRYLF5XjOdC09+BBNByZ6/ERFdhUKfh3QWmcAdwJiyw
         Va2iE8HDVk3SxjKO6DBI3y9Tc08kuHCNqoYly+XcCJkWCJsWK3tnpsiATui45VQUC/De
         c8CnPecB7UcVPbu6NY+Iw0ytUh6xyKPkyk+5KpkXyk+q3842pr+FJ7HKnDy2OzqkcplA
         YaIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739236604; x=1739841404;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MIDLn0ElhLkZLGHEXZdCvG2zMlN0W10JkA618ESIp5I=;
        b=Qs6TCNCmyZDCLabss2IskEHhnXuYxCVeSNf+zpcWDTcabJGdqqaw8wm717f13vgqPp
         FS/61su7qVTZNwh6MRKJ/yljat4JAO8ZVRvzU+AwZzbvQEZP2m4bbj61SgZXwWgd2zPG
         m5VZKaeS6oj3HaF8irAWPMRFoXOL+/DXWBWCOe6Ugfqz2zhTpFZlvMXzw7Jc1rhkOJ8a
         AuyDMbZRZldVicyaosfzit9gVi3ZT5kJaUv0hac93+RrexS/29RYKyio6C6d9s+n16wH
         SgBvc0Vb2AS6hVfV79tbVoCCZUz4UzE4LIMSp6SNGf7/yZrDnZnnj/nOWfo8krKvWaM/
         Uf8g==
X-Gm-Message-State: AOJu0YyjM1cjKuwMv1b/nvknFCNHeBlLHfrwB3UspKGma0AvWXqnvrDM
	+BMn1bBEdTunprzoV8FP+4Tu4L9ov/zvD3PJJYCLLbpWroEbJW+LRrhE0svxPddhFjnfAFZJCIe
	YGQiTNuXNuolR8HrPBMKKi8/axkoTcQqPsdDI
X-Gm-Gg: ASbGnctrVoPp4ASS1Q31+a0MAH0Aa1GSjZRe4XZFgC4DXzx5UBGZnGAxGJoJVtFHJK4
	gkehQFDqtrkd/yVZTwESIP3+TJsUazS65gLpmP4BIcoWpAYKvxRfsEnmaQWxId+GpEbi0nPEj3Q
	bxCFWCRwVVGdMggnfwlL8/oMq4Xd6i9A==
X-Google-Smtp-Source: AGHT+IGrKDG92DdGOlwP7eJ/9LFEBgOFycMhnxSp1JHwnKefb0ClNrqUUYEZEfsa6sdnN6IhjulSH17jSWCq6Fyov30=
X-Received: by 2002:a05:6512:1387:b0:542:9910:b298 with SMTP id
 2adb3069b0e04-54513af6b32mr59896e87.7.1739236604383; Mon, 10 Feb 2025
 17:16:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241212063635.712877-1-michael.roth@amd.com>
In-Reply-To: <20241212063635.712877-1-michael.roth@amd.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 10 Feb 2025 17:16:33 -0800
X-Gm-Features: AWEUYZnu8DZ9-gWy_ugkJ_6BkgXs-pViupxKo87Cy1AcHvUKcORw34feJYU-gN0
Message-ID: <CAGtprH9ehiz+yKfQqj6JeObaPv0DPUsoAH+YVdSeuzL9zhw9tA@mail.gmail.com>
Subject: Re: [PATCH RFC v1 0/5] KVM: gmem: 2MB THP support and preparedness
 tracking changes
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, jroedel@suse.de, thomas.lendacky@amd.com, 
	pbonzini@redhat.com, seanjc@google.com, vbabka@suse.cz, amit.shah@amd.com, 
	pratikrajesh.sampat@amd.com, ashish.kalra@amd.com, liam.merwick@oracle.com, 
	david@redhat.com, ackerleytng@google.com, quic_eberman@quicinc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 11, 2024 at 10:37=E2=80=AFPM Michael Roth <michael.roth@amd.com=
> wrote:
>
> This patchset is also available at:
>
>   https://github.com/amdese/linux/commits/snp-prepare-thp-rfc1
>
> and is based on top of Paolo's kvm-coco-queue-2024-11 tag which includes
> a snapshot of his patches[1] to provide tracking of whether or not
> sub-pages of a huge folio need to have kvm_arch_gmem_prepare() hooks issu=
ed
> before guest access:
>
>   d55475f23cea KVM: gmem: track preparedness a page at a time
>   64b46ca6cd6d KVM: gmem: limit hole-punching to ranges within the file
>   17df70a5ea65 KVM: gmem: add a complete set of functions to query page p=
reparedness
>   e3449f6841ef KVM: gmem: allocate private data for the gmem inode
>
>   [1] https://lore.kernel.org/lkml/20241108155056.332412-1-pbonzini@redha=
t.com/
>
> This series addresses some of the pending review comments for those patch=
es
> (feel free to squash/rework as-needed), and implements a first real user =
in
> the form of a reworked version of Sean's original 2MB THP support for gme=
m.
>

Looking at the work targeted by Fuad to add in-place memory conversion
support via [1] and Ackerley in future to address hugetlb page
support, can the state tracking for preparedness be simplified as?
i) prepare guest memfd ranges when "first time an offset with
mappability =3D GUEST is allocated or first time an allocated offset has
mappability =3D GUEST". Some scenarios that would lead to guest memfd
range preparation:
     - Create file with default mappability to host, fallocate, convert
     - Create file with default mappability to Guest, guest faults on
private memory
ii) Unprepare guest memfd ranges when "first time an offset with
mappability =3D GUEST is deallocated or first time an allocated offset
has lost mappability =3D GUEST attribute", some scenarios that would
lead to guest memfd range unprepare:
     -  Truncation
     -  Conversion
iii) To handle scenarios with hugepages, page splitting/merging in
guest memfd can also signal change in page granularities.

[1] https://lore.kernel.org/kvm/20250117163001.2326672-1-tabba@google.com/

