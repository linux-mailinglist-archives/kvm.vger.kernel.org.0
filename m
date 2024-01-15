Return-Path: <kvm+bounces-6224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E41FE82D8E2
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 13:25:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D9051F221C9
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 12:25:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E7002C6A8;
	Mon, 15 Jan 2024 12:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AF41lebR"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E163D2C68C
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 12:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 15 Jan 2024 13:25:42 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1705321544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zTO6g2LZko5JQeKkqhwsTGJjM1futr0zuRouqeNssfM=;
	b=AF41lebRoozawPhyxq/N23Ao82JgiD8OE83bbDaP3CrY91/LVCu4JoN44/sIResMsAcbkN
	mQKLOCdUn11V16PCj9Mrpvq8e7Wl7vY9U2/chLgjlJv9oMSDpmAKEQy72hb5a2ZX82H1jB
	hR3YbjkPQHqIqB+QjfV9hiaRI35x5Wk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: kvmarm@lists.linux.dev, Thomas Huth <thuth@redhat.com>, 
	Nico Boehr <nrb@linux.ibm.com>, Colton Lewis <coltonlewis@google.com>, 
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 2/3] runtime: arm64: Skip the migration
 tests when run on EFI
Message-ID: <20240115-92ecda86253ec8b52f348eda@orel>
References: <20231130032940.2729006-1-shahuang@redhat.com>
 <20231130032940.2729006-3-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231130032940.2729006-3-shahuang@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Nov 29, 2023 at 10:29:39PM -0500, Shaoqin Huang wrote:
> When running the migration tests on EFI, the migration will always fail
> since the efi/run use the vvfat format to run test, but the vvfat format
> does not support live migration. So those migration tests will always
> fail.
> 
> Instead of waiting for fail everytime when run migration tests on EFI,
> skip those tests if running on EFI.
> 
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>  scripts/runtime.bash | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index c73fb024..64d223e8 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -156,6 +156,10 @@ function run()
>  
>      cmdline=$(get_cmdline $kernel)
>      if find_word "migration" "$groups"; then
> +        if [ "{CONFIG_EFI}" == "y" ]; then
> +            print_result "SKIP" $testname "" "migration tests are not supported with efi"
> +            return 2
> +        fi
>          cmdline="MIGRATION=yes $cmdline"
>      fi
>      if find_word "panic" "$groups"; then
> -- 
> 2.40.1
> 

This isn't arm-specific, so we should drop the arm64 prefix from the patch
summary and get an ack from x86 people.

Thanks,
drew

