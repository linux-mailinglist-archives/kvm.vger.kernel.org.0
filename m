Return-Path: <kvm+bounces-21567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52B6692FF36
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 19:12:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D0289B256E0
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:12:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F53517B4FF;
	Fri, 12 Jul 2024 17:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Epp83Y2f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0715E179654
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 17:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804207; cv=none; b=X/4cde8dX7Oh5SIvTQMasZYai9LBmjv/dT6Va0ptVTr4MKAdk6h6KLEdHq+QDpYgHdr/AxWISkztiuwQM3IbOI9vMCFMZiwVawOcMdW0vSUAIavQ4Hqi/wSdhyqPIfPgj0mnWz4H7u7l+uWG2WO4iYNaEZWHKNxyx0gWRh++7KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804207; c=relaxed/simple;
	bh=iG2xqENYZFTFr1IbouCj87WCkOw9JaByFRY/xIAfdYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fwrr7ASmpcKwGL34O+dtRIcA3gAWGl2abvCueJzKC9z7OwNQG1gv9oGMxIGNmIm7BFCylUpYLxt/qJFB0SPzxnbLOi+ZSRZ/PUZQiP2hvK9gWX3LmA2fzwZfL5iOjfXax1Nlux8yaNED10QCTyrePHVrBuh4b07+vCCYsult7KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Epp83Y2f; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-42725f8a789so545e9.1
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 10:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720804204; x=1721409004; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rMZXVu60zJG58GKh3Q1lSirg7a2qt1HU65yEcaRG7AA=;
        b=Epp83Y2fdc0xyoLw+mqFMtIY1yYxQGg7he4PNAs7yf+32ywBhW60uvKKpJexsNnQ53
         IHBZkffIMHFxw+WBFB/JWg+ADWjTYvRZFPKLBYNkZtslJxSKhTFZYg/gOMrjNoun2UbR
         G1+7h+cIimpCpaQzWZeMS9QKSGsyJ1CdoppEzxz/JzC6RSYV/VuurffUp2nCDMdJs12x
         QJeIQIUgZl3p4ExQWvefvQCfFs5FknQNxjKIXxLqFEHG55r31Xv2jlsQxJTVfgMRvx7O
         ZdC9d6hAFL+f+zfOcG4hqxQBWp35Jz3kTxp5EUCBiPTxX3dlI23u8hWNkLhuMLLzlvwx
         wM5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804204; x=1721409004;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rMZXVu60zJG58GKh3Q1lSirg7a2qt1HU65yEcaRG7AA=;
        b=iTY6OMpD+Ugp4tUEYbYEydj9QTsBh49pd9ZdabyAxc4bjPFQuV5uybDl2Kfaf2oanS
         8LKTQm335XYv0O+qardPoP0l00DY9k2TBUyBA1VCgG8dttFS8ZJhBs5oKYi0gSu6k7Qc
         OUAWA4czT+W69Rca8tmNValvI9ZxJ6FK2/bP4XEJEK+ZFepNqbEapomx2IIO1Oo420XI
         Mld8INyVC4mUnNkc2seskxbXVBJ7woZg8GWVPDpS6xwt6XM7V6lx1TkEbzyQL3Oc8Lf5
         QaLJ8hEjd2Z2bxtqbQEWU04rVKiNWqIiFuF8Hx7qCLSTaLm/TXEmnainsEUDnwLkPqbw
         ECow==
X-Forwarded-Encrypted: i=1; AJvYcCUIyd/lG7wxBNjOWgBu2jVVLhlWsOxVSWZNFrnDCmN8/9hX13cIbbFtLKLHvMc3TxsjYGhsh7NCod1C0jSn420848S1
X-Gm-Message-State: AOJu0Yw3Pi4GJAT3qBhJHP2TPg7YvSedBFBgoGThdttIznYoGJKiTOLo
	A1Le6qppHQ2W4nUpYanQkWki0vy++XT5vQOjs4ydRvoi2VKoSZj8M/35HpV8/w==
X-Google-Smtp-Source: AGHT+IHW4j/Ai/a9CGXSUWjW4J7ti0hzG99uRbbUAmwE86eZrQEMYyuJ3dymC0HiUJLsh8BfgBWNwg==
X-Received: by 2002:a05:600c:378d:b0:426:6edd:61a7 with SMTP id 5b1f17b1804b1-4279f09320amr1596615e9.7.1720804204187;
        Fri, 12 Jul 2024 10:10:04 -0700 (PDT)
Received: from google.com (60.58.155.104.bc.googleusercontent.com. [104.155.58.60])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-426740daf6dsm60948655e9.1.2024.07.12.10.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jul 2024 10:10:03 -0700 (PDT)
Date: Fri, 12 Jul 2024 17:09:57 +0000
From: Brendan Jackman <jackmanb@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexandre Chartre <alexandre.chartre@oracle.com>,
	Liran Alon <liran.alon@oracle.com>,
	Jan Setje-Eilers <jan.setjeeilers@oracle.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mel Gorman <mgorman@suse.de>, Lorenzo Stoakes <lstoakes@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>,
	Khalid Aziz <khalid.aziz@oracle.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Paul Turner <pjt@google.com>, Reiji Watanabe <reijiw@google.com>,
	Junaid Shahid <junaids@google.com>,
	Ofir Weisse <oweisse@google.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Patrick Bellasi <derkling@google.com>,
	KP Singh <kpsingh@google.com>,
	Alexandra Sandulescu <aesa@google.com>,
	Matteo Rizzo <matteorizzo@google.com>, Jann Horn <jannh@google.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kvm@vger.kernel.org, Dennis Zhou <dennis@kernel.org>
Subject: Re: [PATCH 00/26] Address Space Isolation (ASI) 2024
Message-ID: <ZpFjZfgrmhHwZLJU@google.com>
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>

Well, off to a good start...

REFLECT MODE:
    The To: and Cc: headers will be fully populated, but the only
    address given to the mail server for actual delivery will be
    Brendan Jackman <jackmanb@google.com>

    Addresses in To: and Cc: headers will NOT receive this series.

Apparently gmail is too clever for this and sent my mail out anyway.
So, some corrections, more probably to come on monday.

On Fri, Jul 12, 2024 at 05:00:18PM +0000, Brendan Jackman wrote:
> Overview
> ========
> This RFC 

Yes, this is an RFC, definitely not a PATCH. Sorry for the bogus
subject...

> Rough structure of this series:
> 
> - 01-14: Establish ASI infrastructure, e.g. for manipulating pagetables,
>   performing address space transitions.
> - 15-19: Map data into the restricted address space.

Actually 15-20

> - 20-23: Finalize a functionality correct ASI for KVM. 

21-24

> - 24-26: Switch it on and demonstrate actual vuln mitigation.

25-26

