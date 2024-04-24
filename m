Return-Path: <kvm+bounces-15801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96DE78B085F
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 13:33:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA7701C22831
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 11:33:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D9F815A4B6;
	Wed, 24 Apr 2024 11:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hCRK0G0D"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD87A15AAAF
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 11:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713958376; cv=none; b=eyUcZUWyjdQKxYnJeun9cuoFr/mYN1noEmY5zJAs65Nf2E6winqVA1c4oxJGWbNWQMxDLr9c02bXzfNWXGsR4kEIT8dt89PYZb8nMLUe7z7H/8xUtpoK8eMeFLySuo7rUgpaZbmy9RZW9B5U/FR3SuCqroxepzrbfHvy/g1tDC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713958376; c=relaxed/simple;
	bh=2QYPMI8AePvbfkGI8HsO91enimz+VSXJ9ZfWUH0bce8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rtDuZwgePfG69eDUcc4Y4hgX6sPXV+KjbU1Re3XoxOBUlKv8s6ttCRRVWomjydokChlwMyEfBmRxu3f/xwzrzCbKD7On3mrPtfZYGDg8Dj5gl5MaFhNwVJuHMl4Jv1yb58LDjHwsH9lSel71oBUQeDiJ3ppF+WvAT676WbavJRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hCRK0G0D; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713958373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lF6aa3Qe28Gh13RTVX5fcWmJZIuQko+JwvFAb+pljTQ=;
	b=hCRK0G0D7xWhEvv+aJhPfE+gcdbAP574WRbrem5qNNiwuk72HOIDAXuV9EP1s4F5ERc6qD
	P1aGAKGhkol6FXc3z39yKwcUlHqSehUy9cAIegUd86qLIipvJaO8067nEwst+O/7/X7/CZ
	9imVGGe1azq0Vgdej9TeTKzWkI5RNVg=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-328-1qA0LD_SM6q95VgaWfQAeA-1; Wed, 24 Apr 2024 07:32:52 -0400
X-MC-Unique: 1qA0LD_SM6q95VgaWfQAeA-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4364a84f771so71693301cf.1
        for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 04:32:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713958371; x=1714563171;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lF6aa3Qe28Gh13RTVX5fcWmJZIuQko+JwvFAb+pljTQ=;
        b=A9xnFdSHUBUWjh9VRqC0jvGxK24HrVbefVE7JkQQrTAghqv60/AJr24mpA2wsMXQ0s
         pd8ZIzQz+tordBnnzlx60nZ5zcKnIrHmZSEMdZpG8JIzjk3tg4S8672pbDnVicuNUP4R
         R8nYlP/u8nfQzydI9umKWrxHq8GDpl/NAhIBPemhl6mR+YFoykhJMc1U9mvUGAlMEcaZ
         iUvcStstbuEUKtsTYpmR12anKip8MC3Z6Rtc4do906eC1MP80V9k0PjxPSja8vbV1VxU
         HG1m9bQ2sv79BMk7Cfsq0wXPl7pD8a/5hh5FL9JPoB1WBbReH2baMCSSwocIJLdAo+p0
         TVDw==
X-Gm-Message-State: AOJu0Yx03WHzL2cM8v4OeLLBqDgLSrnLBMJqGpcJMKBH4YDiOd9aglh5
	1RA0jc0RGTBVXzXZTrzBGFIiCEd6aDz2Frfup2R1Uey8c0KUY/zG1mxaqxnvjmRnkueAvG98dHB
	Kqh9BKT9GvDwtMxFkBnllqPa740KbCQpT2BeUR3HrJ2GJJzUw3A==
X-Received: by 2002:ac8:5a88:0:b0:439:884b:859a with SMTP id c8-20020ac85a88000000b00439884b859amr1992175qtc.21.1713958371578;
        Wed, 24 Apr 2024 04:32:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHFJy7XM56nDr2FWB9b6co13dKlWDt2/s1ybd9lSoSPOjnQXviXy8wLafbLt4kuQjAT2Dokbw==
X-Received: by 2002:ac8:5a88:0:b0:439:884b:859a with SMTP id c8-20020ac85a88000000b00439884b859amr1992162qtc.21.1713958371259;
        Wed, 24 Apr 2024 04:32:51 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-177-130.web.vodafone.de. [109.43.177.130])
        by smtp.gmail.com with ESMTPSA id x17-20020ac85391000000b0043770fd3629sm5983928qtp.75.2024.04.24.04.32.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Apr 2024 04:32:51 -0700 (PDT)
Message-ID: <71dfa65d-9f9e-4a8e-b4e8-44ab557cb2a8@redhat.com>
Date: Wed, 24 Apr 2024 13:32:47 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests GIT PULL 00/13] s390x: Improvement of CMM test,
 lot of small bugfixes and two refactorings
To: Nico Boehr <nrb@linux.ibm.com>, pbonzini@redhat.com,
 andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20240424105935.184138-1-nrb@linux.ibm.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240424105935.184138-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24/04/2024 12.59, Nico Boehr wrote:
> Hi Paolo and/or Thomas,
> 
> not much has happened, but a few smaller things have accumulated, so time for a
> PR.
> 
> Changes in this pull request:
> 
> Just a single new test:
> * test CMM no-translate bit after reset
> 
> A lot of smaller fixes:
> * fix for secure guest size by Claudio
> * fixes for shell script issues by Nicholas
> * fix in error path of emulator test by Christian
> * dirty condition code fixes by Janosch
> * pv-attest missing from unittests.cfg
> 
> And, last but not least, two refactorings:
> * simplification of secure boot image creation by Marc
> * name inline assembly arguments in sigp lib by Janosch
> 
> Thanks
> Nico
> 
> MERGE: https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/58
> 
> PIPELINE: https://gitlab.com/Nico-Boehr/kvm-unit-tests/-/pipelines/1264518225
> 
> PULL: https://gitlab.com/Nico-Boehr/kvm-unit-tests.git pr-2024-04-22
> ----
> The following changes since commit 69ee03b0598ee49f75ebab5cd0fe39bf18c1146e:
> 
>    Merge branch 'arm/queue' into 'master' (2024-04-19 10:41:39 +0000)
> 
> are available in the Git repository at:
> 
>    https://gitlab.com/Nico-Boehr/kvm-unit-tests.git pr-2024-04-22
> 
> for you to fetch changes up to 7315fc8a182e50e5c2f387812cd178b433a40cea:
> 
>    s390x: cmm: test no-translate bit after reset (2024-04-23 15:10:35 +0200)
> 
> ----------------------------------------------------------------
> Christian Borntraeger (1):
>        s390x: emulator: Fix error path of invalid function code
> 
> Claudio Imbrenda (1):
>        lib: s390: fix guest length in uv_create_guest()
> 
> Janosch Frank (6):
>        lib: s390x: sigp: Dirty CC before sigp execution
>        lib: s390x: uv: Dirty CC before uvc execution
>        lib: s390x: css: Dirty CC before css instructions
>        s390x: mvpg: Dirty CC before mvpg execution
>        s390x: sclp: Dirty CC before sclp execution
>        lib: s390x: sigp: Name inline assembly arguments
> 
> Marc Hartmayer (1):
>        s390x/Makefile: simplify Secure Execution boot image generation
> 
> Nicholas Piggin (2):
>        s390x: Fix is_pv check in run script
>        s390x: Use local accel variable in arch_cmd_s390x
> 
> Nico Boehr (2):
>        s390x: add pv-attest to unittests.cfg
>        s390x: cmm: test no-translate bit after reset

Thanks, applied!

  Thomas



