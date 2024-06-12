Return-Path: <kvm+bounces-19430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E424690503F
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 12:17:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 42092B24FE3
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 10:17:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F244B16E898;
	Wed, 12 Jun 2024 10:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cJpC0VRR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEF816E879
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 10:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718187447; cv=none; b=T4Vaxyni7NS/bYFix1jyQGK/6GemDDfkTQe16SCcLUGQoQ/scNusm7kWZEwFYYYp5VDzWBsVCYx7H5u4x0EDjSXDkCorXffMgkqU0+uEYrSndZ/rFu6yXljdLahcd10fm4WbbGbJOj4lqAA7gffxKEVVjfEuiUrXRiGowRmCicI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718187447; c=relaxed/simple;
	bh=rHGlOU/oRM5sSzupsMjsS3D6A+FGmLQgeOs3Gdr2lM4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tp2CAre1w7SliWxD8XTCk8ZUjXpjAB/qUTsoWgK4VOx5/jhtW2wioYbxHqM0HVlT3+VpyeTIpF4fYzc5PkFce45lBx3VinMFEc5K+SbPDBu6t6K8Dkm/y/bh+kjf2c9Mbw+Vk/WmJHl5w/He6dzV/WBtY7n4gi3jeArGvx9mBVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cJpC0VRR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718187444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ej1/lYBxZEdZ90GHD3zrZYMmXYbqteS4jpwB3eBG7Cg=;
	b=cJpC0VRRSrlO7idxaZRS9wYMRK+KLdst4dEP/ApSzYaFhWqOpfhkSp6YBLkzLSanCufEQL
	5KoUsd5ERW8bbYmczg13V9xZyapibDWpYiAuqY0S52EhsYAZyQsQYs6RxdByfpveC56imV
	rd1V1ZJ0yKGZg8CCCBNa6YUEeTOGdPM=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-Hgj8d43VMai7F7G4IJEI_A-1; Wed, 12 Jun 2024 06:17:22 -0400
X-MC-Unique: Hgj8d43VMai7F7G4IJEI_A-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a6f4a6537f7so26078466b.3
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 03:17:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718187442; x=1718792242;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ej1/lYBxZEdZ90GHD3zrZYMmXYbqteS4jpwB3eBG7Cg=;
        b=vh5lrVb7FQX1yxNo9u76nYbNjJdXFHMHZzxk1FdnhZrpuj2yUmrso5aA/Ee/m0IUY2
         +7u7YDgUq5OVqG9SvwgbBPFO9x0EJ/OZxM80q33DzdeWHVKpALH9vs9R/QBw029LItVi
         1cdcmWvKMFT0hltTt55h/3KDjEvWaUnXe04oAEljWLSg5p+n4mm/zlrrMub/RGZGeAax
         dn2kMgHLaVDfbQdX49U4omudpvQJGoZRe0wci3liUGW4rNbYy6e67y4hcFCCgtV90Ehn
         ZDIKTIjNGGkVA61Q0YgsNTqCwqgS82z3xFEBLUcfXw4P7RAzd+KYXOAzVWxLBV0fFU0h
         tbmQ==
X-Gm-Message-State: AOJu0Yyh9AZThmfd+SLKxYm5wQ+1FAXa2RdCcINfGtmHVeLV54yKli3s
	Tcpjp58zT/uQHQknV9tYdH5DkCoFQgQRDBv3pdPN0UrYFZ1W9/1GMh89iJq+LqaGn960yBsB9d8
	1kmetAePcYZZ1ShL5ddVD+nAdzi/LLBsc9R4qVJpTSJxF65+6gg==
X-Received: by 2002:a17:906:fa8b:b0:a6f:feb:7f1c with SMTP id a640c23a62f3a-a6f47d1e231mr75285466b.1.1718187441854;
        Wed, 12 Jun 2024 03:17:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH8YWjQz88WI3Hmt9+KY6if8mE+LmzZjoofeLw9Faeizny5wZgYslSCrTpO55Kwfy2E1gI5TQ==
X-Received: by 2002:a17:906:fa8b:b0:a6f:feb:7f1c with SMTP id a640c23a62f3a-a6f47d1e231mr75284366b.1.1718187441451;
        Wed, 12 Jun 2024 03:17:21 -0700 (PDT)
Received: from [192.168.10.47] ([151.62.196.71])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-a6c806eaa1dsm879152066b.107.2024.06.12.03.17.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jun 2024 03:17:21 -0700 (PDT)
Message-ID: <76e66fa2-4a36-4de1-96a3-b8893130ed74@redhat.com>
Date: Wed, 12 Jun 2024 12:17:19 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command
To: Dan Carpenter <dan.carpenter@linaro.org>,
 Brijesh Singh <brijesh.singh@amd.com>
Cc: kvm@vger.kernel.org
References: <d9c16deb-6fad-4ecd-a783-4c4e9f518725@moroto.mountain>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <d9c16deb-6fad-4ecd-a783-4c4e9f518725@moroto.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Thanks for the report!

>     2134         /* Don't allow userspace to allocate memory for more than 1 SNP context. */
>     2135         if (sev->snp_context)
>     2136                 return -EINVAL;
>     2137 
>     2138         sev->snp_context = snp_context_create(kvm, argp);
>                                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> What this static checker warning is about is that "argp->sev_fd" points
> to a file and we create some context here and send a
> SEV_CMD_SNP_GCTX_CREATE command using that file.

...

>     2156         start.gctx_paddr = __psp_pa(sev->snp_context);
>     2157         start.policy = params.policy;
>     2158         memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
> --> 2159         rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
>                                       ^^^^^^^^^^^^  ^^^^^^^^^^^^^^^^^^^^^^^^
> The user controls which file the ->sev_fd points to so now we're doing
> SEV_CMD_SNP_LAUNCH_START command but the file could be different from
> what we expected.  Does this matter?  I don't know KVM well enough to
> say.  It doesn't seem very safe, but it might be fine.

It is safe, all file descriptors for /dev/sev are basically equivalent,
as they have no file-specific data.

__sev_issue_cmd ends up here:

int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
                                 void *data, int *error)
{
         if (!filep || filep->f_op != &sev_fops)
                 return -EBADF;

         return sev_do_cmd(cmd, data, error);
}
EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);

and you can see that the filep argument is only used to check that
the file has the right file_operations.

Thanks,

Paolo


