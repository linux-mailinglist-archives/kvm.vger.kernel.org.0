Return-Path: <kvm+bounces-12303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 965B48811D5
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 13:47:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 130E1B23110
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 12:47:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85F2A40BF9;
	Wed, 20 Mar 2024 12:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BxKYWdZ8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D70240866
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 12:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710938818; cv=none; b=cnds5wqLrTkg6leL9OAEGv/6DjGy3AGATmklzSrlVDNz1+YWKnfDQEiFfMewv8t70CLpfPMTuGup68CDfhuJ0ifm7B+3ra5Lk9ZImg62ZSB9X0JUETJnjegexFMQHVdMNWQEl1bfU6I2KoFigK4uJvfafR6Ci9ia40cZpZSVXEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710938818; c=relaxed/simple;
	bh=5Pc5otTiuaW1G2T2W/OHh2HBC5/VGR6g8aNIheIBxfg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lvC+vFpL15STL2K30VPsQECM0gdlNlGw2JFsUeIJdqGw8aFYv0Lr3ASo2kExHz1KFPhVxUVCFjouJho+o/2y/2QWSb3kntdJT9TqDMYelgvldy8e6OFzJHr29i0InjpHYLiG1901eWWeDCrOAkV6oUJWaOl0Gnamyrvcw7ypF84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BxKYWdZ8; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710938817; x=1742474817;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5Pc5otTiuaW1G2T2W/OHh2HBC5/VGR6g8aNIheIBxfg=;
  b=BxKYWdZ81X1KvPNI3JM8EfzVDz/7FWxOWUF4AYYyeO8xB85VHEzbKFFY
   xkPAKthjyH8BBcEsTKrNcITdsVwjreOqjhMrr6NwkODbQ7yEkViR3eJV5
   QlNMrdXJN17aAfMUNVvMnGH0YgkgNwRu4WTDe5PytFFl8XorP5mDNGwM+
   l2MUyaIOcoQkjJZJGCShh5oV+qzMGSLeHA0Y3MTiju46GAhuKGF9Awuuj
   S5f0JwSNLCHmtRCZ6KO1hwBIk2/uFW2lz5WNANhwmXEs3y46fU42XsrRR
   ygSccaiUfbqILoGeiezLPCcipfLfcgDiWqFdmxRxRUizCFKPVWFRBTY/A
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11018"; a="5980510"
X-IronPort-AV: E=Sophos;i="6.07,140,1708416000"; 
   d="scan'208";a="5980510"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 05:46:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,140,1708416000"; 
   d="scan'208";a="14785336"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 05:46:54 -0700
Message-ID: <e9def9a5-8669-4246-8c81-c4a0fe350051@intel.com>
Date: Wed, 20 Mar 2024 20:46:51 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/49] [FIXUP] "kvm: handle KVM_EXIT_MEMORY_FAULT":
 drop qemu_host_page_size
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 Isaku Yamahata <isaku.yamahata@linux.intel.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-14-michael.roth@amd.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240320083945.991426-14-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/2024 4:39 PM, Michael Roth wrote:
> TODO: squash into "kvm: handle KVM_EXIT_MEMORY_FAULT"
> 
> qemu_host_page_size has been superseded by qemu_real_host_page_size()
> in newer QEMU, so update the patch accordingly.

I found it today as well when rebase to qemu v9.0.0-rc0.

Fix it locally, will show up on my next post of TDX-QEMU patches. :)

> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>   accel/kvm/kvm-all.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 2fdc07a472..a9c19ab9a1 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -2912,8 +2912,8 @@ static int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
>       void *addr;
>       int ret = -1;
>   
> -    if (!QEMU_PTR_IS_ALIGNED(start, qemu_host_page_size) ||
> -        !QEMU_PTR_IS_ALIGNED(size, qemu_host_page_size)) {
> +    if (!QEMU_PTR_IS_ALIGNED(start, qemu_real_host_page_size()) ||
> +        !QEMU_PTR_IS_ALIGNED(size, qemu_real_host_page_size())) {
>           return -1;
>       }
>   
> @@ -2943,7 +2943,7 @@ static int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
>           rb = qemu_ram_block_from_host(addr, false, &offset);
>   
>           if (to_private) {
> -            if (rb->page_size != qemu_host_page_size) {
> +            if (rb->page_size != qemu_real_host_page_size()) {
>                   /*
>                   * shared memory is back'ed by  hugetlb, which is supposed to be
>                   * pre-allocated and doesn't need to be discarded


