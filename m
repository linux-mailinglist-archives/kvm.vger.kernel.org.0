Return-Path: <kvm+bounces-9481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 47672860B1F
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 08:06:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A98441F228D9
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 07:06:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82EC8134AD;
	Fri, 23 Feb 2024 07:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CwTQs/2U"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2611C11CB2
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 07:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708671990; cv=none; b=eDFw34CYGY8xracrwG4wLG9HLh+4sTOlorhqQv89GlTP0paiv88i2Uajz8dax6i/Vv5YoSyqXZFmPDil0dTvDdcbrOd/lD54tLQl1/NLCKPsliKWaKPxcN22s6R5p5HGLpcu4Oe3m3Ib8TwHh2rfXkDLE3bkESfZkjTv30UjQUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708671990; c=relaxed/simple;
	bh=pmhSqQma4mPAwB5S2erYwmJatbkcNNUJOPrvTZJemDE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eiTd/VBMoOoso24ZwX/yaG2X5Tod24U42TSUL1MdjtnmVMK6tZa5Y7hutN0/plXa4yGcKK4FHAxfmcAYhRUX5vAP+e4iMx3siTwkUDsZYKCXXqW1dNBO9WgKMROC4aEDkD1pLKaXI37PMEa9+cWbn4xxLnuoyNosMSqegfzCvpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CwTQs/2U; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708671988;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BRHsJbNJikGXBIx8gHv6naumiMpOU3Z17cOC43xcz8U=;
	b=CwTQs/2UFU7geIo/RYIfSrJc+LRlDJE54v1zdLZKhkwy5zSqzv7N0ubj5xTn47K5VvPqPg
	sUxUkUA3+4LTATGDyT81LiMsyijNwyufC9VC4hTdTF5qG+d+21tG+o1fDrKyQrLbEjerzr
	42ka1KE+3vGnlDE8ZYL1NtbO3/D+TDw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-JgURjTivMKOzwMfpF37RSQ-1; Fri, 23 Feb 2024 02:06:25 -0500
X-MC-Unique: JgURjTivMKOzwMfpF37RSQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-33d30a3d6f8so168128f8f.3
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 23:06:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708671985; x=1709276785;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BRHsJbNJikGXBIx8gHv6naumiMpOU3Z17cOC43xcz8U=;
        b=CCCgHkg/78pduJGZzI6AFnKHdG01+FU0DE11qSoDVL/MTR5eFYwe7il/2b5hNPG0OM
         PkIyRR5KXAO5yIC68IN9XiuEHy1joQqCOg3yU8xCWrwYNJ+9gW9m/B3h1WdUHQjX6pfq
         iXu5e9ZiaGniJyBoNqRomz7+ZnLJ0mtK8+vvb2pd/23cycsR4qyaYJerVG2TLix2+Bdw
         hrGuEq2mR2KZSx+s0j6e/xkc1+/u12SQaO7ZnHiM5jgPbXOUzxep0QT+swYhqqaRxmce
         UdmiixGM5KzSAP5s/j8R0eUaA8F47iDzcl0Z2ySrkLQU43fqmT8tsMCh/T+FItFGp6BY
         6huQ==
X-Gm-Message-State: AOJu0YyZrxuh4g5N2lzIg8YKGiTbqeQaCs1Wu4nIO/mjPbjO2y6DBklI
	bFwUaOz0Q1+3YoQNiortCH+1zD4eiOVGp8/EeL94YyAbdovwAZNYlcr3XYffg35sBsl1/DpOOmi
	4bOuMvtXHkab9+JAJLFGlueSKNIP2lspXLYtBNgVVLgoHKjWRvQ==
X-Received: by 2002:adf:db46:0:b0:33d:1d94:cd58 with SMTP id f6-20020adfdb46000000b0033d1d94cd58mr755797wrj.31.1708671984940;
        Thu, 22 Feb 2024 23:06:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHvalV/mlPmxxuta0pv2rPSMKjBHyQZ4hLhmTogmzrMTWSxsy7nviVQ+FZm/pm87v/fSkTEWw==
X-Received: by 2002:adf:db46:0:b0:33d:1d94:cd58 with SMTP id f6-20020adfdb46000000b0033d1d94cd58mr755780wrj.31.1708671984569;
        Thu, 22 Feb 2024 23:06:24 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-178-100.web.vodafone.de. [109.43.178.100])
        by smtp.gmail.com with ESMTPSA id bx9-20020a5d5b09000000b0033d568f8310sm1655586wrb.89.2024.02.22.23.06.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Feb 2024 23:06:24 -0800 (PST)
Message-ID: <5383a1b2-20ca-4d07-9729-e9d5115948dc@redhat.com>
Date: Fri, 23 Feb 2024 08:06:21 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v5 0/8] Multi-migration support
Content-Language: en-US
To: Nicholas Piggin <npiggin@gmail.com>
Cc: kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
 Shaoqin Huang <shahuang@redhat.com>, Andrew Jones <andrew.jones@linux.dev>,
 Nico Boehr <nrb@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Eric Auger <eric.auger@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Marc Hartmayer
 <mhartmay@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, kvmarm@lists.linux.dev,
 kvm-riscv@lists.infradead.org
References: <20240221032757.454524-1-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240221032757.454524-1-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21/02/2024 04.27, Nicholas Piggin wrote:
> Now that strange arm64 hang is found to be QEMU bug, I'll repost.
> Since arm64 requires Thomas's uart patch and it is worse affected
> by the QEMU bug, I will just not build it on arm. The QEMU bug
> still affects powerpc (and presumably s390x) but it's not causing
> so much trouble for this test case.
> 
> I have another test case that can hit it reliably and doesn't
> cause crashes but that takes some harness and common lib work so
> I'll send that another time.
> 
> Since v4:
> - Don't build selftest-migration on arm.
> - Reduce selftest-migration iterations from 100 to 30 to make the
>    test run faster (it's ~0.5s per migration).

Thanks, I think the series is ready to go now ... we just have to wait for 
your QEMU TCG migration fix to get merged first. Or should we maybe mark the 
selftest-migration with "accel = kvm" for now and remove that line later 
once QEMU has been fixed?

  Thomas



