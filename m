Return-Path: <kvm+bounces-3048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 372EA800152
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 02:56:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E8BA61F20F77
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 01:56:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD42F4C8A;
	Fri,  1 Dec 2023 01:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g5m715rX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF181198
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 17:56:14 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-db53919e062so86667276.0
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 17:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701395774; x=1702000574; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UpBBsyYVohX+FTYFefwcFtMNMJUH3TaZgqYxYwvBXOY=;
        b=g5m715rXsbq9RB3bNRG5/IBH8hxMp04MOk0EWtbLXOSTJCO6vpUpL1MsKBIJxrBGJL
         K+O+W2A9Htua6xG3Gn8lu66ukoMwPz3TRWKyKe1UlUJ94evpam+AiB35gDT9LN1x0lt4
         rzqgGZiVJfufOgTX/Ewp0vLSBRDAjBFgxbZf24NffVTQNrkDSsa+OZJ71akRtQcZcQVO
         cqHwNVguBSRWagwWAD97eAvEPIvwtWVITzNY9X5v3U4gufeQQ8RriFGfUFPqL/NRwi23
         Gr1ei7C3Not9JRfnEoEPz1TITofmdN4WoWkYAaHO3v7DBzatXykvcMYg5g/nMUVZABUE
         k4Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701395774; x=1702000574;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UpBBsyYVohX+FTYFefwcFtMNMJUH3TaZgqYxYwvBXOY=;
        b=A9L6Q43/t/gbuVe/wZAydga0RoD9vkDMwubiyOlGPHlFbcFlB1E7z8hvDfgzqwetn7
         EbAvs+FVidTrD66DNm0MOWeW2oqg634C1xXi/BF3ZnbUo2IynpGWsW8CADeR1jxZuf2X
         x201CFMQvovjskroYJlyItmn9YChYd3qABS20G7zBlnWF3Daf6iH403HLCeKbSXqq1UY
         p/lSKQsAwZS4mV3RppxCOPIIgVTY6SxLW2nE9rZBcVYBY4+dBsAsHA29E5gCWM1A63Gk
         1n6Dj+oc2Me4mFV5bMcuUoleK8/Bic98TIoevihHS+QJUMe1ygmteyl1TCcX9QYwDpvs
         u5/w==
X-Gm-Message-State: AOJu0YyXd4gjGg3i39y5PcnGzKl27iJl7LflwKsDybYYLxd1ysWLcKwB
	lbUSt6UjYosE3B02bmCKlVorO/6ZWPI=
X-Google-Smtp-Source: AGHT+IGzAbxxayMyLDqWERzPqpD5Bo/x0IIJ65uHtJJNm2ABavlKe6+btFUsWJ9cdfFF3T0n1HeMmR7p1Cw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:3d44:0:b0:db4:7ac:fea6 with SMTP id
 k65-20020a253d44000000b00db407acfea6mr711502yba.7.1701395774125; Thu, 30 Nov
 2023 17:56:14 -0800 (PST)
Date: Thu, 30 Nov 2023 17:52:24 -0800
In-Reply-To: <20231103230541.352265-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231103230541.352265-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <170137839352.665680.16618790592517929019.b4-ty@google.com>
Subject: Re: [PATCH v2 0/6] KVM: x86/pmu: Clean up emulated PMC event handling
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Roman Kagan <rkagan@amazon.de>, Jim Mattson <jmattson@google.com>, 
	Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 03 Nov 2023 16:05:35 -0700, Sean Christopherson wrote:
> The ultimate goal of this series is to track emulated counter events using
> a dedicated variable instead of trying to track the previous counter value.
> Tracking the previous counter value is flawed as it takes a snapshot at
> every emulated event, but only checks for overflow prior to VM-Enter, i.e.
> KVM could miss an overflow if KVM ever supports emulating event types that
> can occur multiple times in a single VM-Exit.
> 
> [...]

Applied to kvm-x86 pmu, thanks!

[1/6] KVM: x86/pmu: Move PMU reset logic to common x86 code
      https://github.com/kvm-x86/linux/commit/cbb359d81a26
[2/6] KVM: x86/pmu: Reset the PMU, i.e. stop counters, before refreshing
      https://github.com/kvm-x86/linux/commit/1647b52757d5
[3/6] KVM: x86/pmu: Stop calling kvm_pmu_reset() at RESET (it's redundant)
      https://github.com/kvm-x86/linux/commit/f2f63f7ec6fd
[4/6] KVM: x86/pmu: Remove manual clearing of fields in kvm_pmu_init()
      https://github.com/kvm-x86/linux/commit/ec61b2306dfd
[5/6] KVM: x86/pmu: Update sample period in pmc_write_counter()
      https://github.com/kvm-x86/linux/commit/89acf1237b81
[6/6] KVM: x86/pmu: Track emulated counter events instead of previous counter
      https://github.com/kvm-x86/linux/commit/fd89499a5151

--
https://github.com/kvm-x86/linux/tree/next

