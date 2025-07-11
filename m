Return-Path: <kvm+bounces-52158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 13186B01CFA
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 15:08:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58F50A42D4E
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 13:07:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2073B2D23A8;
	Fri, 11 Jul 2025 13:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u2H4N5Nt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAE95258
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 13:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752239263; cv=none; b=qUrCigDjcVUVSpZFfYi96ihEaBqJZlR64ysK/WcqA5FPZyhk2lvmPgsI6vXREhNF1y5m0VPLzizFHNhltTA56JKnVpvQalgDPa25G+jjvEEKtjJ02FzoMmyixDxriVj/9+PTb6FsuLl6hcZqq7kPPTe75tL61PDT4K6zwOGqxoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752239263; c=relaxed/simple;
	bh=3gOyPpBs/+AKHDq40YEckf3rMBSuIVib5hoitGULMP4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ihveelyIzlIQyyWKQHTvLYnAIV+WOAe60QvIR/fl33fTSgNi/KRftgRIvIOrWkfYQ7UFcmKHhIGNycA4Wy59SJyzAkY8XCWC42jZm4cYYiujp6gKvRDpipV28fmB71e/BqsJGLWA0GUBF9MxXKP9RyG4JFyBi66UM1NbVNs+9QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u2H4N5Nt; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3138e65efe2so2096530a91.1
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 06:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752239261; x=1752844061; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zVyWQES3hodN41s6uctwdy0EIp0i4amF0tvvmSk8ydI=;
        b=u2H4N5NtaRIxwgjwbpkRluZC4JFISex3mNMKwUB/pCm9B4RDIP5FWK5R2PBoPcyjRV
         1PnQMrRcJkyFscWsEKR4VTrvbGRxbvSTtj2U5dZZ0iUucKALOgSx9JT+HwuhtsTD0Vg4
         a5aTLZB/y1lkz2m4NHTMWpuQlHpVidpMZ5w+OAyWuqzJpWGNefc8jxTMflFHwkhDPzPr
         XKC0V0VgbbDkqljptAO71zFhw172ENv54PGzJ1bwNOLjUOYwQdbsiBbe5dBiLLIxCqLN
         yHQo4uadDj1BpRvkvbjlsIP0tFtyg74apPcoTRl8cwURcc7Wga/T73eK6G8zwJ5pwCQQ
         2JHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752239261; x=1752844061;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zVyWQES3hodN41s6uctwdy0EIp0i4amF0tvvmSk8ydI=;
        b=bjXVXAlelWWRyHJNeeSgtIKZCe2Jj2YxBGyio8KVUHSANAF8FtJ/xB3nsvf/9gM9Rw
         V4vstAwOEYJBtk9esnRiQL8sd0YJ3vxKDbUtJz+iWlRYx08akaNe8ITWZH/tovyu/tmt
         HhC8e4I/KYXW60RsTeSOSSxCzqXvzYmC0rjxsz7CYSurjMBqDJIj3SNT/mPINxp9jEU9
         bFfUVcZh0IYHmqMTvlg3hIDw6938wDKPVsaQeLXmVG/7zZtvRGAPcgcgXaMYxHmKub8N
         iFU7Hn9uuqwDsiuzIKrVjSRciipPgrNFN+5Xh+QVYZ/+s/BDCHvgyK14OsI0fZGyMLRB
         2nig==
X-Forwarded-Encrypted: i=1; AJvYcCUDJ9sEIoqWlTTAnztVy3gBuIF8ERsNKagbYV6D1nWDg+Wn7qp0z4DFs4ebo1h7NXlrFt0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzS4Wc6fY1CSQYM0pRhZr1gwHQ8p6soPvCEBMrHbRi8J9TJo4q4
	XogQyYLZTM2lRG9l1zAq7zFs484Fv575UlAQZq6vEwsbrzLHS50sj66SPhJ1FQ0zEVC64+P3gde
	7JEsJ+g==
X-Google-Smtp-Source: AGHT+IHOOC/+9wiGWWnh/yTT2nqMhImKCqPO0nC4pYq1z+Ith+jUv1eZ8PupyDMand7XrcPDwcGaKpGF/To=
X-Received: from pjff7.prod.google.com ([2002:a17:90b:5627:b0:312:187d:382d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:528c:b0:313:287e:f1e8
 with SMTP id 98e67ed59e1d1-31c4ccbc93emr5059733a91.8.1752239261326; Fri, 11
 Jul 2025 06:07:41 -0700 (PDT)
Date: Fri, 11 Jul 2025 06:07:38 -0700
In-Reply-To: <20250711045408.95129-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250711045408.95129-1-nikunj@amd.com>
Message-ID: <aHEMmmBWzW_FpX7e@google.com>
Subject: Re: [PATCH] KVM: SEV: Enforce minimum GHCB version requirement for
 SEV-SNP guests
From: Sean Christopherson <seanjc@google.com>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, thomas.lendacky@amd.com, 
	santosh.shukla@amd.com, bp@alien8.de, Michael Roth <michael.roth@amd.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 11, 2025, Nikunj A Dadhania wrote:
> Require a minimum GHCB version of 2 when starting SEV-SNP guests through
> KVM_SEV_INIT2. When a VMM attempts to start an SEV-SNP guest with an
> incompatible GHCB version (less than 2), reject the request early rather
> than allowing the guest to start with an incorrect protocol version and
> fail later.

What happens with ghcb_version==1?   I.e. what failure occurs, and when?

