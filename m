Return-Path: <kvm+bounces-2758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E5847FD5F3
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 12:43:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E3509B2191E
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 11:43:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF0371D532;
	Wed, 29 Nov 2023 11:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NQ1N21nR"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321B7BA
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 03:43:14 -0800 (PST)
Date: Wed, 29 Nov 2023 12:43:08 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701258191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/IzVIw7aBdORt2nhoQvNCcoKG9vU5ChFOcZ/M34Q/rE=;
	b=NQ1N21nRz8qNBjw/V7KCi1HWbNY49kLfKoljR3O3c5hBNnR2TMLjcVOCLN6m0O+3d724u4
	NxcFdAlsJ3QYaMubhUIQ3ekeVWkPXSwwbL3aqD4R4ErQ5uDpiwOhLArxiNhIgmpcYBg1UW
	Pvz2di2u8tYGFtgCqiEm6ZT8kDry33M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: kvmarm@lists.linux.dev, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Eric Auger <eric.auger@redhat.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1 3/3] arm64: efi: Make running tests on
 EFI can be parallel
Message-ID: <20231129-cbddf8063ae5af7a37aa2e4a@orel>
References: <20231129032123.2658343-1-shahuang@redhat.com>
 <20231129032123.2658343-4-shahuang@redhat.com>
 <20231129-7fbc43944dc62a55cffe131c@orel>
 <a574e4b6-4c1b-d939-e61c-6a97a245341e@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a574e4b6-4c1b-d939-e61c-6a97a245341e@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Nov 29, 2023 at 06:14:20PM +0800, Shaoqin Huang wrote:
> Hi drew,
> 
> On 11/29/23 17:27, Andrew Jones wrote:
> > On Tue, Nov 28, 2023 at 10:21:23PM -0500, Shaoqin Huang wrote:
> > > Currently running tests on EFI in parallel can cause part of tests to
> > > fail, this is because arm/efi/run script use the EFI_CASE to create the
> > > subdir under the efi-tests, and the EFI_CASE is the filename of the
> > > test, when running tests in parallel, the multiple tests exist in the
> > > same filename will execute at the same time, which will use the same
> > > directory and write the test specific things into it, this cause
> > > chaotic and make some tests fail.
> > 
> > How do they fail? iiuc, we're switching from having one of each unique
> > binary on the efi partition to multiple redundant binaries, since we
> > copy the binary for each test, even when it's the same as for other
> > tests. It seems like we should be able to keep single unique binaries
> > and resolve the parallel execution failure by just checking for existence
> > of the binaries or only creating test-specific data directories or
> > something.
> > 
> 
> The problem comes from the arm/efi/run script, as you can see. If we
> parallel running multiple tests on efi, for example, running the pmu-sw-incr
> and pmu-chained-counters and other pmu tests at the same time, the EFI_CASE
> will be pmu. So they will write their $cmd_args to the
> $EFI/TEST/pmu/startup.nsh at the same time, which will corrupt the
> startup.nsh file.
> 
> cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_TEST/$EFI_CASE/"
> echo "@echo -off" > "$EFI_TEST/$EFI_CASE/startup.nsh"
> ...
> echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_TEST/$EFI_CASE/startup.nsh"
> 
> And I can get the log which outputs:
> 
> * pmu-sw-incr.log:
>   - ABORT: pmu: Unknown sub-test 'pmu-mem-acce'
> * pmu-chained-counters.log
>   - ABORT: pmu: Unknown sub-test 'pmu-mem-access-reliab'
> 
> And the efi-tests/pmu/startup.nsh:
> 
> @echo -off
> setvar fdtfile -guid 97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823 -rt =L"dtb"
> pmu.efi pmu-mem-access-reliability
> setvar fdtfile -guid 97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823 -rt =L"dtb"
> pmu.efi pmu-chained-sw-incr
> 
> 
> Thus when running parallel, some of them will fail. So I create different
> sub-dir in the efi-tests for each small test.

Ok, I was guessing it was something like that. Maybe we should create a
"bin" type of named directory for all the binaries and then create a
separate subdir for each test and its startup.nsh, rather than copying
the binaries multiple times.

> > >   : "${EFI_CASE:=$(basename $1 .efi)}"
> > >   : "${EFI_VAR_GUID:=97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823}"
> > > @@ -56,20 +58,20 @@ if [ "$EFI_CASE" = "_NO_FILE_4Uhere_" ]; then
> > >   	EFI_CASE=dummy
> > >   fi
> > > -: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_CASE"}"
> > > +: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_TESTNAME"}"
> > >   mkdir -p "$EFI_CASE_DIR"
> > > -cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_TEST/$EFI_CASE/"
> > > -echo "@echo -off" > "$EFI_TEST/$EFI_CASE/startup.nsh"
> > > +cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_DIR/"
> > > +echo "@echo -off" > "$EFI_CASE_DIR/startup.nsh"
> > 
> > Unrelated change, should be a separate patch.
> > 
> 
> Ok, Will separate it.

Actually, disregard my comment. I was too hasty here and thought the
'@echo -off' was getting added, but now I see only the path was getting
updated. It's correct to make this change here in this patch.

Thanks,
drew

