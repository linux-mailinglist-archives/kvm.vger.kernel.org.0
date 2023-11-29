Return-Path: <kvm+bounces-2743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BDC747FD237
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 10:17:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C46128165A
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 09:17:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1913F14A89;
	Wed, 29 Nov 2023 09:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="u5dysyFJ"
X-Original-To: kvm@vger.kernel.org
Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B0F1BD6
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 01:17:01 -0800 (PST)
Date: Wed, 29 Nov 2023 10:16:57 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701249419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rgppvU2L/GoQQxYuYgM7B71jluFuq5FiCBFxjb4sYXE=;
	b=u5dysyFJOWsjf7BeYTH2YqD2T9XmFQoY9s15Ege6aXiDrQKb5PmyUqy8H9adiPczkZIAtG
	IYhhUBZkf9n/fDxZssQ+7R3JxKxD2HN1OfF7YOdbERuT3z41zYtT6pt+y405abje7GfcZg
	dgC1Ug3SZjAY19sJz31jr1hS1DEId0I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: kvmarm@lists.linux.dev, Thomas Huth <thuth@redhat.com>, 
	Nico Boehr <nrb@linux.ibm.com>, Ricardo Koller <ricarkol@google.com>, 
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1 2/3] runtime: arm64: Skip the migration
 tests when run on EFI
Message-ID: <20231129-bb64bea98b2259adec0636f2@orel>
References: <20231129032123.2658343-1-shahuang@redhat.com>
 <20231129032123.2658343-3-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231129032123.2658343-3-shahuang@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Nov 28, 2023 at 10:21:22PM -0500, Shaoqin Huang wrote:
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
>  scripts/runtime.bash | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index d7054b80..b7105c19 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -156,6 +156,11 @@ function run()
>          fi
>      }
>  
> +    if [ "${CONFIG_EFI}" == "y" ] && find_word "migration" "$groups"; then
> +        print_result "SKIP" $testname "" "migration test is not support in efi"

migration tests are not supported with efi

> +        return 2
> +    fi
> +
>      cmdline=$(get_cmdline $kernel)
>      if find_word "migration" "$groups"; then
>          cmdline="MIGRATION=yes $cmdline"


We don't need to do the find_word twice,

      cmdline=$(get_cmdline $kernel)
      if find_word "migration" "$groups"; then
          if [ "${CONFIG_EFI}" == "y" ]; then
	      print_result "SKIP" $testname "" "migration tests are not supported with efi"
	      return 2
	  fi
          cmdline="MIGRATION=yes $cmdline"

> -- 
> 2.40.1
> 

Thanks,
drew

