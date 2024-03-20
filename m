Return-Path: <kvm+bounces-12278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F1A0880F04
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 10:49:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 901C61C220A3
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:49:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E8CD3C48D;
	Wed, 20 Mar 2024 09:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TKVXZWlg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC3E3BBFB
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 09:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710928130; cv=none; b=iin6HVjt7cHnfN7Gnz666Cm+zEllMaAxzc7gDMWWXoVyrLtki8Ly1Unfn+2Y8jc84orPqgctoa4622wqnRWWmbg7O2gTisTnIqzNI+cW4CcpJOq1V95oji70/cWrkaueavrmMnP5Md5h76WDBBvvGpUTmZEhccyTOwXh4YagWvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710928130; c=relaxed/simple;
	bh=zPP2pS5iCc/716nm6tB3GifQvq3fkacNtRvxnBwcqhk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SbMMLYLSOAjQONmTOs8VTye3/H3qk/2ItOxIdNg6k+QQxgdS+dFa2QBtBs9tyR7JIhtMhzNoOtwJKvy0q+QfgPQR6bCC1MJYQh6/vdHp1skiTdPL6LG4fnmoBoX2wEUm/6PQXRoFqa+ktU5hHpWQ0S2Pi4EuDLk8vqN/FUxusfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TKVXZWlg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710928127;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BQPHNj5HNBSMyuoftz28f+ScBc7BnpscC2alH68qkWQ=;
	b=TKVXZWlgi21Pr2/fkuL6JWEKnrkpbqPqyoYxABUYuXeVJ5R12miqkXOfOIz4/0NR+tDrm2
	Qoius7jmJk1uHeqXe72fw8t363keGPctwvm7mTW+7045pKSSP9Z6360iorCzxeqgEDNiuu
	IWloyGc01RbZAPflT2Kfr1o8zsddpMU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-34-VWUnDUQUPJiaBVNJmX3UVA-1; Wed, 20 Mar 2024 05:48:45 -0400
X-MC-Unique: VWUnDUQUPJiaBVNJmX3UVA-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-568d55c3b83so2299957a12.1
        for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 02:48:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710928124; x=1711532924;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BQPHNj5HNBSMyuoftz28f+ScBc7BnpscC2alH68qkWQ=;
        b=OLfrLah5o6vHqhb5hnGOfIHejjKT+EpGAStniOcQUID0IqA9n7KBtAwPAJspOfqTcI
         1flNlgsqjkfUcLJ0ReRG/5maRrl33vC1E+x5QHsIusbJwwy5YZjhbCq4WUystkmxYI3r
         phuFaNr3kliqhH+vqi5ou131xSI2eBxdc9je4tXDbwNa9K3pY3Rlk1eBGFopwBg+kik5
         c75wdzm3ephjZJYY03tMsT2jvCkcyRRlTThBIqiJHss887CPMuMS/EgY9KVggOM9UgeE
         rqsp8gPhW/JPjv0hjoR6tyCCr94u4tbaO/aK1Kc9DRUDdQwgnWc/0DDV40tWbP906IJP
         pEoA==
X-Gm-Message-State: AOJu0Yx/dt++tfXLdGhb/d4BIHM23B1lHhT6s1taBLyUMN/vdI7S3jtJ
	S8aG+SsoADJQt40SzpOFHDkmlN2YiHSS2BJZ3yxCiYptWnMmyrSOtMoLAxLLV0tHmubwJ2mRNkv
	nRAoOJQDQ4N7LY/YF87cB+ydUBJm5y17aGGIfODE+yA9upvCupg==
X-Received: by 2002:aa7:dac3:0:b0:56b:b5a2:f8bb with SMTP id x3-20020aa7dac3000000b0056bb5a2f8bbmr407504eds.3.1710928124593;
        Wed, 20 Mar 2024 02:48:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IERx4OIqJeH1xeNZL2HDSL0K9OjfpG6J7/cAG0JM1w8983tChGajXSMWG/nuORYnUhGGTQtGQ==
X-Received: by 2002:aa7:dac3:0:b0:56b:b5a2:f8bb with SMTP id x3-20020aa7dac3000000b0056bb5a2f8bbmr407492eds.3.1710928124289;
        Wed, 20 Mar 2024 02:48:44 -0700 (PDT)
Received: from [192.168.10.118] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id a89-20020a509ee2000000b00568c299eaedsm4763686edf.81.2024.03.20.02.48.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Mar 2024 02:48:43 -0700 (PDT)
Message-ID: <45d636a5-c3b2-4125-9837-097b07bbc963@redhat.com>
Date: Wed, 20 Mar 2024 10:48:43 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 27/49] i386/sev: Set ms->require_guest_memfd for SNP
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>,
 Isaku Yamahata <isaku.yamahata@linux.intel.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-28-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240320083945.991426-28-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/24 09:39, Michael Roth wrote:
> SNP requires guest_memfd for private guest memory, so enable it so that
> the appropriate guest_memfd backend will be available for normal RAM
> regions.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>   target/i386/sev.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index e4deb7b41e..b06c796aae 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -880,6 +880,7 @@ out:
>   static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>   {
>       SevCommonState *sev_common = SEV_COMMON(cgs);
> +    MachineState *ms = MACHINE(qdev_get_machine());
>       char *devname;
>       int ret, fw_error, cmd;
>       uint32_t ebx;
> @@ -1000,6 +1001,10 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>           qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
>       }
>   
> +    if (sev_snp_enabled()) {
> +        ms->require_guest_memfd = true;
> +    }

Likewise, this and the following patch should be done in the 
sev-snp-guest's override of kvm_init.

Paolo

>       qemu_add_vm_change_state_handler(sev_vm_state_change, sev_common);
>   
>       cgs->ready = true;


