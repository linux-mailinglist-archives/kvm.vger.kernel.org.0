Return-Path: <kvm+bounces-16019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AFE68B2F79
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 06:36:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 70E49B21BB9
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 04:36:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B12E139CFE;
	Fri, 26 Apr 2024 04:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="qcLW23pr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A506F1849
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 04:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714106185; cv=none; b=FLdEGS1Z8OKyDf9T72sw+aDuEj659atYdypfEcHPaSXRQV4sJby6JOcutmfBuj/xNTz5nP0EmbIGVgm4r80rjlIxstri0ff+YSnKgwdXKZJ27sHVdDNcqCHFgIqeP1TqQpWY+8vPtwHWGmitiPQybN2IPa351FV7sjL9y6lXQH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714106185; c=relaxed/simple;
	bh=7keaL7YVJWP05k4nk4BE2S1AHpuGUcCrD+sEPoCFgVc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y8EHsqy+Kdjnyh5L1XUEOSrHzEFGhdjjHqmHISaF8r8B/7m3pjzGVAhwxlmLpKUlgVcEv2ZkdfvQFFiUkDeyEFm5CEYYxupEvgXwH2k2nC9QAPxwOc1PKP1qDJn+dYM8FIykTfGX5sYxvD0kabU2jL/0+uzpmMliAgo4BD4neHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=qcLW23pr; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43Q406Yt026269
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 00:18:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=mime-version :
 references : in-reply-to : from : date : message-id : subject : to : cc :
 content-type : content-transfer-encoding; s=pps01;
 bh=G88B4FCXOWJlCV1Zgxmcc8QeTpgCRXs4kSbZUzx+VkI=;
 b=qcLW23pr/W0L549fzl9r/sTVzbmJnd6HQW2QGWVCn8afaB3AJDzzV7gi+hlJFNEmhr3z
 OCcCNRkzd/uCU2hMApVBhXwHLdzaSTXxg44ZGiJbcVwKiK2T3mPrKOEy7Z/uQRd0286N
 ZLknDuGkj/iHCp7f0PAg1CCpYnx7T6nvlZQhEwMUboM735gy5RCCLc+yVRs48sFzGdEe
 HcE8+fai7UY4+yetJguf+QPwiU54dAg7Iy3PaAIqr/nXSpt1R0b5gzQ09+EepgmOpCdc
 lygzbUo9O+eyL/ygAMvPsC31dpYhrKeCRQGIE/m9mGmJmYD9Pimo2urkX0E6tN4iHZbO BA== 
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 3xm9khpb24-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 00:18:22 -0400
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7de914f3fc2so38651339f.2
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 21:18:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714105101; x=1714709901;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G88B4FCXOWJlCV1Zgxmcc8QeTpgCRXs4kSbZUzx+VkI=;
        b=jA8lHGu3nTN5cdDzr4hIno+c/TR3Ou0BrJJSAlIFFtpXBZZ250yClz3FEZe19oeEvH
         x0y5UCx5/7foqQvC9ecQg3OBbYtv+N8T9NUuitR6xqm3/3etUwCp0QFrnxIH8k5zqVSR
         jJQBYcmSG4ppGPRDjRSvw5AfbH7EW+2RPt2aRKU/Dofk9ZEAzS0JKdL0oUT8WvHfhoGU
         5k3vKXml16QgCqhuwebwPcpRNA0vNlbkCOEuWF3HwAPp2bV8MA8W+on1CFD+L+NJ6oD4
         1kgArprDA8HOaaUG8+DPRdR//7dcXR0SEWptVeVmeWNqhdk/t2XRaiYm2eSX6ZQ10wf7
         Bljw==
X-Forwarded-Encrypted: i=1; AJvYcCUVv80C51M7SyZQSrTFsJ7tOiZ0GwhVOSFCuD07fQtikv144ROqamzZUpaBo65vJXHkOCm97mxCtBOA9uktrfG0QhPB
X-Gm-Message-State: AOJu0YzsZMBQ4L0qvI3U7wMdLG2MWb31OSKWneb3ppimd3ptvjeWft4g
	WpeCpHbB48l7rp9tF7XQ6QG4DlhUq3vobsN1HQ1Ex73blaBkkl8JhdH64R9ZZI/0YJzOx8dtrW7
	zt5el6fq/WbZrjdqt5RJHC/0eqNB690A+tWpqkNDmTbItJ918crpUJDsxpkeRyTgy8sC+uU+bv3
	vjlzpLXqliyGZdaf9I8nuYvYFTxBSdH64=
X-Received: by 2002:a05:6e02:1d9d:b0:36b:2ff9:9275 with SMTP id h29-20020a056e021d9d00b0036b2ff99275mr2289869ila.2.1714105101057;
        Thu, 25 Apr 2024 21:18:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEYYqkIK/4iFximYCX6FwUlLfYjRHZuPLiEM/EPRsZhJPl4TSF1MHqh4vFeg9jtOAvS9k0+w5+fXugtICExHXw=
X-Received: by 2002:a05:6e02:1d9d:b0:36b:2ff9:9275 with SMTP id
 h29-20020a056e021d9d00b0036b2ff99275mr2289863ila.2.1714105100785; Thu, 25 Apr
 2024 21:18:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240423024933.80143-1-kele@cs.columbia.edu> <de0096bf-08a8-4ee4-94d7-6e5854b056b4@intel.com>
 <CAOfLF_L2UgSUyUsbiBDhLPskt2xLWujy1GBAhpcWzi2i3brAww@mail.gmail.com>
In-Reply-To: <CAOfLF_L2UgSUyUsbiBDhLPskt2xLWujy1GBAhpcWzi2i3brAww@mail.gmail.com>
From: Kele Huang <kele@cs.columbia.edu>
Date: Fri, 26 Apr 2024 00:18:09 -0400
Message-ID: <CAOfLF_+ZP-X8yT7qDb0t57ZZu7RNhdOGyCNfR2fheZG+h_jZ7w@mail.gmail.com>
Subject: Re: [1/1] KVM: restrict kvm_gfn_to_hva_cache_init() to only accept
 address ranges within one page
To: "Chen, Zide" <zide.chen@intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-ORIG-GUID: Ipohyn0gFPh6_IgLsC0jFls95cwuqacp
X-Proofpoint-GUID: Ipohyn0gFPh6_IgLsC0jFls95cwuqacp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-26_04,2024-04-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 clxscore=1015 spamscore=0 impostorscore=0 bulkscore=10 malwarescore=0
 phishscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=10
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404260025

Thanks for the feedback!  Yes, callers including kvm_read_guest_offset_cach=
ed()
and kvm_write_guest_offset_cached() checked if the read or write should fol=
low
the slow path for the guest memory read/write by checking if
ghc->memslot is nullified.
However, please note that they are calling the static function
`__kvm_gfn_to_hva_cache_init()` instead of the exported function
`kvm_gfn_to_hva_cache_init()`.

Although `__kvm_gfn_to_hva_cache_init()` has detailed comments about using
a slow path for cross page but actually the "slow path" is to read/write gu=
est
memory instead of for setting up a cross page cache.  The difference here
I think is that `kvm_gfn_to_hva_cache_init()` is an exported function and
its name indicates it is used for gfn to hva cache init, while the
return value 0
does not really guarantee the cache is initialized when the address range
crosses pages.  For example, function kvm_lapic_set_vapicz_addr()
called `kvm_gfn_to_hva_cache_init()` and simply assumes the cache is
successfully initialized by checking the return value.

My thought is there probably should be another function to provide correct
cross page cache initialization but I am not sure if this is really needed.
Nevertheless, I think we could at least make the existing function
more accurate?

-- Kele


On Fri, Apr 26, 2024 at 12:14=E2=80=AFAM Kele Huang <kele@cs.columbia.edu> =
wrote:
>
> Thanks for the feedback!  Yes, callers including kvm_read_guest_offset_ca=
ched() and kvm_write_guest_offset_cached() checked if the read or write sho=
uld follow the slow path for the guest memory read/write by checking if ghc=
->memslot is nullified.  However, please note that they are calling the sta=
tic function `__kvm_gfn_to_hva_cache_init()` instead of the exported functi=
on `kvm_gfn_to_hva_cache_init()`.
>
> Although `__kvm_gfn_to_hva_cache_init()` has detailed comments about usin=
g a slow path for cross page but actually the "slow path" is to read/write =
guest memory instead of for setting up a cross page cache.  The difference =
here I think is that `kvm_gfn_to_hva_cache_init()` is an exported function =
and its name indicates it is used for gfn to hva cache init, while the retu=
rn value 0 does not really guarantee the cache is initialized when the addr=
ess range crosses pages.  For example, function kvm_lapic_set_vapicz_addr()=
 called `kvm_gfn_to_hva_cache_init()` and simply assumes the cache is succe=
ssfully initialized by checking the return value.
>
> My thought is there probably should be another function to provide correc=
t cross page cache initialization but I am not sure if this is really neede=
d.  Nevertheless, I think we could at least make the existing function more=
 accurate?
>
> -- Kele
>
> On Thu, Apr 25, 2024 at 9:16=E2=80=AFPM Chen, Zide <zide.chen@intel.com> =
wrote:
>>
>>
>>
>> On 4/22/2024 7:49 PM, Kele Huang wrote:
>> > Function kvm_gfn_to_hva_cache_init() is exported and used to init
>> > gfn to hva cache at various places, such as called in function
>> > kvm_pv_enable_async_pf().  However, this function directly tail
>> > calls function __kvm_gfn_to_hva_cache_init(), which assigns
>> > ghc->memslot to NULL and returns 0 for cache initialization of
>> > cross pages cache.  This is unsafe as 0 typically means a successful
>> > return, but it actually fails to return a valid ghc->memslot.
>> > The functions call kvm_gfn_to_hva_cache_init(), such as
>> > kvm_lapic_set_vapicz_addr() do not make future checking on the
>> > ghc->memslot if kvm_gfn_to_hva_cache_init() returns a 0.  Moreover,
>> > other developers may try to initialize a cache across pages by
>> > calling this function but fail with a success return value.
>> >
>> > This patch fixes this issue by explicitly restricting function
>> > kvm_gfn_to_hva_cache_init() to only accept address ranges within
>> > one page and adding comments to the function accordingly.
>> >
>>
>> For cross page cache, returning a zero is not really a mistake, since it
>> verifies the entire region against the memslot and does initialize ghc.
>>
>> The nullified memslot is to indicate that the read or write should
>> follow the slow path, and it's the caller's responsibility to check
>> ghc->memslot if needed.  e.g., kvm_read_guest_offset_cached() and
>> kvm_write_guest_offset_cached().  Please refer to commit fcfbc617547f
>> ("KVM: Check for a bad hva before dropping into the ghc slow path")

