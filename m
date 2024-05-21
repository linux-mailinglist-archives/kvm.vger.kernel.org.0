Return-Path: <kvm+bounces-17853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B02D28CB289
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 18:55:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 51F16B22E0A
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 16:55:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C61537F49F;
	Tue, 21 May 2024 16:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tb46SCg4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FBD128DA0
	for <kvm@vger.kernel.org>; Tue, 21 May 2024 16:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716310544; cv=none; b=D2SmKFMs2kzWoWGIYJ16yCtMXE32sXB0L9kDISOYtDuI11AdJ3Y+BtZAItA4i3uwFtrtRC0EUTJKE+Sc9zmoIUrt9pXfykqQDAzNQYLuYHrpfxT4jkPHBLl+7ebTB7NJ7Fsx1iE7UDCT0izcI6m4/gWAHbtW2UDjVQ9ebwKS2AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716310544; c=relaxed/simple;
	bh=/wuAJC1w5yftMI0o8cg7kslpgnu8UCvser+y8SmYrCw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZnEjwSQqbWN/SfHwjCGWDqbqVypTxW1GQEFids9Cd5zzlrnhfGFebYeSikYy5ez/lBOWaKQk5WWUwjiXabgo72srvCvP55HV1Bil8aSFzvMJS7yXlj47H7YrSsRV1GIhh0IC5yuhLbDPWOvu8f0LXIw2LPE8CXpc3slj29aV7yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tb46SCg4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716310541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H+WOIyoRkBFayEEwR1EeFv+13Px+tyGmBKyKL4lnBng=;
	b=Tb46SCg4N3nbE1eqA6l5Elku4KTd077O5Pk3QlKuba6a2ulJ/k4xUfqCPE7PxHUHd4rYcR
	riSmem2MVC8cQiRXNVP04FtHzdD8JdHI7tSoVSwkmu1Lx2cCzfTPq2fvvHlhOEEfVcolfO
	n5h9YXaNj+rgpROh8yqkQBFzC+/pEnM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-_oh9liOwPliog3Ric0F3sQ-1; Tue, 21 May 2024 12:55:39 -0400
X-MC-Unique: _oh9liOwPliog3Ric0F3sQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-34d9deebf38so8094109f8f.1
        for <kvm@vger.kernel.org>; Tue, 21 May 2024 09:55:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716310538; x=1716915338;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H+WOIyoRkBFayEEwR1EeFv+13Px+tyGmBKyKL4lnBng=;
        b=jjMDiWTa3wMJ3ASZdK7OPUiRGVxYjF9NydoSz7dznzp6OTU0RT8ut1oE5W2ED+bKJi
         0PmrypFFyhKpqSJYj7/auwSvbKw/28Z1Xm7jRt6MuaToFIDpYmI4k+MH1gO/haj/RQcB
         wSRGtY7VuR+fqRWz2VGff0EolVw6VIKH4YuZ71FvRhdbyI20BmPIJ0FMeC8oY2Qd0zc1
         4d5PwksI3bbpTJ3gNTADNAmw1dpCxt5KiKJHsjg2dWksPlThHlTmVGrtWCA0TRLGAyQT
         itRjZyA1jFjI/KKzzC+njOM9GcaoCyxn6b7E2uaVpdk6pOgs2l9PIN1VuRIdyHGtCwGu
         16iA==
X-Forwarded-Encrypted: i=1; AJvYcCWi6dOwgNWXiFc3Nxs0HTvHUi23q42OARqiB/k4otVzFeeo9B9M7HWT4bQX/B7WTfkxeNCnTsVnplE+a+ax5p+yNWg/
X-Gm-Message-State: AOJu0Yw5aFwD+PgCQ3FmRSHNwYK/PZu1yGvnB64f4fzxTOCDxvKJqcXX
	lN6YuhIc6b7r4KMPRtzFkLURfVE8rBM5ol12eeKxTMbvOs7mZP0nzfYAhI4x9MrBRzzXAGOxd/B
	QWvX/vMHb5qWGJ+1mKUQjNUo695YJpXyT2GgI2PaIPhueH+Vu0k1PMiFWMC7VFx6QgoTcVOsfPK
	kNNmakxBt7OA3Dt2gCp8QoOcLl
X-Received: by 2002:adf:f508:0:b0:351:c960:b5af with SMTP id ffacd0b85a97d-351c960b862mr22459230f8f.17.1716310538534;
        Tue, 21 May 2024 09:55:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHGqOdd7EWG1bVC7EJzEy0rTU/G02HAaexFKAULe3IexA29zh4Kwm16mv5leNGvtmmzZXrBGU7o+wcQgtPgx14=
X-Received: by 2002:adf:f508:0:b0:351:c960:b5af with SMTP id
 ffacd0b85a97d-351c960b862mr22459212f8f.17.1716310538132; Tue, 21 May 2024
 09:55:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240510211024.556136-1-michael.roth@amd.com> <20240510211024.556136-14-michael.roth@amd.com>
 <ZkU3_y0UoPk5yAeK@google.com> <20240516031155.meola5hmlk24qv52@amd.com>
In-Reply-To: <20240516031155.meola5hmlk24qv52@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 21 May 2024 18:55:25 +0200
Message-ID: <CABgObfbxz9aWNg0G8xjjBQ-aXLvMeS7WO+zJghKmbZSx2XOUpw@mail.gmail.com>
Subject: Re: [PULL 13/19] KVM: SEV: Implement gmem hook for invalidating
 private pages
To: Michael Roth <michael.roth@amd.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 16, 2024 at 5:12=E2=80=AFAM Michael Roth <michael.roth@amd.com>=
 wrote:
> Longer term if we need something more robust would be to modify the
> .free_folio callback path to pass along folio->mapping, or switch to
> something else that provides similar functionality. Another approach
> might be to set .free_folio dynamically based on the vm_type of the
> gmem user when creating the gmem instance.

You need to not warn. Testing CC_ATTR_HOST_SEV_SNP is just an optimization.

Paolo

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index dc00b89404a2..1c57b4535f15 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4676,8 +4676,7 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t e=
nd)
         bool assigned;

         rc =3D snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
-        if (WARN_ONCE(rc, "SEV: Failed to retrieve RMP entry for PFN
0x%llx error %d\n",
-                  pfn, rc))
+        if (rc)
             goto next_pfn;

         if (!assigned)

Paolo


