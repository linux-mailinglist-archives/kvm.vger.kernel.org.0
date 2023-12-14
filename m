Return-Path: <kvm+bounces-4411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE3B08123CA
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 01:18:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF9AE1C213F3
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 00:18:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0CB138F;
	Thu, 14 Dec 2023 00:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QljGPwke"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B137E0
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 16:18:11 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-dbcd4696599so1118118276.1
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 16:18:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702513090; x=1703117890; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a1T9KSqGwtMQv1hbNnbP8po9bAmmjqCZKAuvRphoWag=;
        b=QljGPwke04rTAIDpxA57e8MCTdWrGyzqMN/uqmv2hZx8HqDwpbYHRybX+f18RbsG0m
         wd46C0oeTmjRT0KGmlGl8vQru/PWK00dHimIU0rkzCCxEK6AWlN1Rrwc/AYT9Rrf05hL
         DYCimFEUTIfM1zXFoR5iaif/zz2CQueikYCxqK3f64Bsl4vDcTjmRRYOXcvMvbfrF2IR
         tF+JMMDOZIb+GTXqBdovPbPMU/n+YoFhcCwsVZTP9IDxmS6xAzHEc/UP/OivMuYvr4Q7
         gYROy4S0EPdxF2Tx3Xgtm0oFh3xixDocyzYEvydTa8YJ/OwozzjiJgqGB+elC21I+El1
         lqmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702513090; x=1703117890;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a1T9KSqGwtMQv1hbNnbP8po9bAmmjqCZKAuvRphoWag=;
        b=AZG1BDv21MVKPOGRoQ8AKPMBxc8li8rO5k/ooYguIu5PTvmGRT1m4a9fPq4B7h1MI/
         Z2dv1fsGNDbeSd+8ZC60Vbn0DLyK/N5LO3+EVGo+eDcXl1t3eaxEUtlwgxv2U+f7bsl+
         kp5KNbSuTBEt2nHrME5nWVS6sunnwqFLEFK6jcsdvrSNjR9atHPaC3BiMgz/5R1jC5Uj
         bLu0lUyPTjUfM2YOANi76rUnR7hRSSsznpLjEE7RhlWB/HwbuiWRqaMApZMXpannwpJ2
         kSzb4loBl78TcrQR5ODvtVAlppjjO3jXbLA8zGZUeoVkXLzhe18FqccsLD5Yupv4eNmC
         WHVA==
X-Gm-Message-State: AOJu0Yz1o+poWFjjlwI3x4pwW4gees3RmKTDo8bokIIUG/TPXD9e8Ol1
	INhvnvIFBWmfdQuZTPA4vC6jzthxyGI=
X-Google-Smtp-Source: AGHT+IFmk5v2l4+Tqax5+3GuiZuNT+GmYDfAm4pBLEOyYVVFFdfKEC01FLTLs+5lL7EdyQE6E4BpTfIGm7U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:b84f:0:b0:dbc:1b46:9aeb with SMTP id
 b15-20020a25b84f000000b00dbc1b469aebmr71552ybm.2.1702513090354; Wed, 13 Dec
 2023 16:18:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 13 Dec 2023 16:17:53 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231214001753.779022-1-seanjc@google.com>
Subject: [ANNOUNCE / RFC] PUCK Future Topics
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, James Houghton <jthoughton@google.com>, 
	Peter Xu <peterx@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Isaku Yamahata <isaku.yamahata@linux.intel.com>, 
	David Matlack <dmatlack@google.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Marc Zyngier <maz@kernel.org>, Michael Roth <michael.roth@amd.com>, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi all!  There are a handful of PUCK topics that I want to get scheduled, and
would like your help/input in confirming attendance to ensure we reach critical
mass.

If you are on the Cc, please confirm that you are willing and able to attend
PUCK on the proposed/tentative date for any topics tagged with your name.  Or
if you simply don't want to attend, I suppose that's a valid answer too. :-)

If you are not on the Cc but want to ensure that you can be present for a given
topic, please speak up asap if you have a conflict.  I will do my best to
accomodate everyone's schedules, and the more warning I get the easier that will
be.

Note, the proposed schedule is largely arbitrary, I am not wedded to any
particular order.  The only known conflict at this time is the guest_memfd()
post-copy discussion can't land on Jan 10th.

Thanks!


2024.01.03 - Post-copy for guest_memfd()
    Needs: David M, Paolo, Peter Xu, James, Oliver, Aaron

2024.01.10 - Unified uAPI for protected VMs
    Needs: Paolo, Isaku, Mike R

2024.01.17 - Memtypes for non-coherent MDA
    Needs: Paolo, Yan, Oliver, Marc, more ARM folks?

2024.01.24 - TDP MMU for IOMMU
    Needs: Paolo, Yan, Jason, ???


P.S. if you're wondering, what the puck is PUCK?

  Time:  6am PDT
  Video: https://meet.google.com/vdb-aeqo-knk
  Phone: https://tel.meet/vdb-aeqo-knk?pin=3003112178656

  Calendar: https://calendar.google.com/calendar/u/0?cid=Y182MWE1YjFmNjQ0NzM5YmY1YmVkN2U1ZWE1ZmMzNjY5Y2UzMmEyNTQ0YzVkYjFjN2M4OTE3MDJjYTUwOTBjN2Q1QGdyb3VwLmNhbGVuZGFyLmdvb2dsZS5jb20
  Drive:    https://drive.google.com/drive/folders/1aTqCrvTsQI9T4qLhhLs_l986SngGlhPH?resourcekey=0-FDy0ykM3RerZedI8R-zj4A&usp=drive_link

  https://lore.kernel.org/all/20230512231026.799267-1-seanjc@google.com

