Return-Path: <kvm+bounces-31654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E23DB9C6041
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 19:20:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 71D271F21EF6
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 18:20:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5461A215C77;
	Tue, 12 Nov 2024 18:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XFAQXMtr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701231FC7F8
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 18:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731435600; cv=none; b=OJ9QKte6RUtEjWCoDW9WhfiD1zBba8cJfjuMtviuvlOkV/1Rgb8w2m/ty4JFEdfbM4qPOLGd33GBxVDDwr7PPbBaimzOIwFanEMT6obt6EfWI+IVb1uksYNe4Jk4aSqucydyP/HyHhm1Q9hcn5HaXIHUmu75ZFmk43hMgKpckQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731435600; c=relaxed/simple;
	bh=607JxGePV31YDPrcVYVerebZsBy12/iJ53pv+Ezu7aw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qp3DmU92D0eMAlzHbRhdxCHKLF5j0Vg9Z/qgvf5xsMTGQdooNgakgUFLq6ecg+D5RviQKFPAD34joPUMGsy2FJ1jZrflSFQeqk9+22NmELwrdfI3/vd4ruhnyLDpP6/YYKxHGoCyOd3wkwu5IFVNcRxuEZQZMu0GGLsYhl7+AD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XFAQXMtr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731435597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UyJD1azZXe59qGbfG3z57FggsNFI1wwhJSjnn8SVIuY=;
	b=XFAQXMtrSLgIHZy3xQyhluKrEJa/OVl8BdqThn85Oa0uUDI9+ZgLef1mz+O/Rf/P2vf8HU
	yt4wQM7f2Le7yrTtBfn61ZUi34Chh4e44FPkn946DQYq3tFKjW3IGtOXFFZS+YG/OCmCF3
	K+EGL1qRURIs1A73njPNXj2Bsvpaj/A=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-490-uo2YXyY0P5GtdT9xNR-ygg-1; Tue, 12 Nov 2024 13:19:56 -0500
X-MC-Unique: uo2YXyY0P5GtdT9xNR-ygg-1
X-Mimecast-MFC-AGG-ID: uo2YXyY0P5GtdT9xNR-ygg
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4315eaa3189so55684635e9.1
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 10:19:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731435595; x=1732040395;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UyJD1azZXe59qGbfG3z57FggsNFI1wwhJSjnn8SVIuY=;
        b=iw/B0tIyVEvrZWhAWk1QEOfSW7LoPjQxYWA7GrTLOzP9/BMk9+r5vSLvwa+21PiXir
         Lv4UG9MJTLZ7e9oQYGKh5RO5Ps6M8Nh3kv3CffUzsBEg1U0J7lL/AIQLqOS2yhF2+A4b
         09u+KXWpWx9soGSo+aNSVB0xW6trzstrYStq+pbC9IDAl/wBijFblfRQjV7EJl8s7+lz
         T+BJ56EEZem8ocArC4OKLiZXow5Ctfn/Hc276PNYxVN+KVO47L4G0Gji4r61Dxe6NtPm
         UubpHUmVj7WsZwg9bzkSrKEfJzdUtffttfHFD64N5O9LImMrXOCE1kFJPo5cHal/athf
         K0OQ==
X-Gm-Message-State: AOJu0YxD/8Esq4PokUkGY2A5S3nhL71YheYK6hL7TgiKNe4d6KA89OQw
	8yAq9uaNfLOjNZUApCb+qlEuYOrAn0H36TP3vLQiDWw5DNrQ8v4CR5eo7KR1GP8utGskm1pxNOU
	cA/H08V4luprWJVdakW0JlnO1dwmCB3ZzA9Y/QcYFYcxoW93Azw==
X-Received: by 2002:a05:600c:5107:b0:431:59b2:f0c4 with SMTP id 5b1f17b1804b1-432b7503e9amr193463785e9.8.1731435594803;
        Tue, 12 Nov 2024 10:19:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF/9e254x4VdTUwKfXr4KabOa7yvghTDK4yLFW3uwE1PofbXbjJw5CBosoXcMYjPQt/JZMWrw==
X-Received: by 2002:a05:600c:5107:b0:431:59b2:f0c4 with SMTP id 5b1f17b1804b1-432b7503e9amr193463525e9.8.1731435594427;
        Tue, 12 Nov 2024 10:19:54 -0800 (PST)
Received: from [192.168.10.47] ([151.49.84.243])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-432b05c202asm223988935e9.30.2024.11.12.10.19.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 10:19:53 -0800 (PST)
Message-ID: <bdda9bcf-b357-4859-a76b-9dd3295fa916@redhat.com>
Date: Tue, 12 Nov 2024 19:19:52 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL 00/14] KVM: s390: pull requests for 6.13
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, david@redhat.com, borntraeger@linux.ibm.com,
 cohuck@redhat.com, linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
 hca@linux.ibm.com
References: <20241112162536.144980-1-frankja@linux.ibm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20241112162536.144980-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/12/24 17:23, Janosch Frank wrote:
> Paolo,
> 
> here's the second and final tranche of ucontrol tests together with
> cpumodel sanity tests and the gen 17 cpumodel changes.
> 
> Heiko and I decided to move the uvdevice patches through the s390
> kernel tree since a set of crypto changes depend on them and we didn't
> feel like creating a topic branch.
> 
> Please pull.
> 
> 
> The following changes since commit 8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b:
> 
>    Linux 6.12-rc2 (2024-10-06 15:32:27 -0700)
> 
> are available in the Git repository at:
> 
>    https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-next-6.13-1
> 
> for you to fetch changes up to 7a1f3143377adb655a3912b8dea714949f819fa3:
> 
>    KVM: s390: selftests: Add regression tests for PFCR subfunctions (2024-11-11 12:15:44 +0000)
> 
> ----------------------------------------------------------------
> - second part of the ucontrol selftest
> - cpumodel sanity check selftest
> - gen17 cpumodel changes
> ----------------------------------------------------------------

Pulled, thanks!

Paolo

> Christoph Schlameuss (5):
>    KVM: s390: selftests: Add uc_map_unmap VM test case
>    KVM: s390: selftests: Add uc_skey VM test case
>    KVM: s390: selftests: Verify reject memory region operations for
>      ucontrol VMs
>    KVM: s390: selftests: Fix whitespace confusion in ucontrol test
>    KVM: s390: selftests: correct IP.b length in uc_handle_sieic debug
>      output
> 
> Hariharan Mari (5):
>    KVM: s390: selftests: Add regression tests for SORTL and DFLTCC CPU
>      subfunctions
>    KVM: s390: selftests: Add regression tests for PRNO, KDSA and KMA
>      crypto subfunctions
>    KVM: s390: selftests: Add regression tests for KMCTR, KMF, KMO and PCC
>      crypto subfunctions
>    KVM: s390: selftests: Add regression tests for KMAC, KMC, KM, KIMD and
>      KLMD crypto subfunctions
>    KVM: s390: selftests: Add regression tests for PLO subfunctions
> 
> Hendrik Brueckner (4):
>    KVM: s390: add concurrent-function facility to cpu model
>    KVM: s390: add msa11 to cpu model
>    KVM: s390: add gen17 facilities to CPU model
>    KVM: s390: selftests: Add regression tests for PFCR subfunctions
> 
>   arch/s390/include/asm/kvm_host.h              |   1 +
>   arch/s390/include/uapi/asm/kvm.h              |   3 +-
>   arch/s390/kvm/kvm-s390.c                      |  43 ++-
>   arch/s390/kvm/vsie.c                          |   3 +-
>   arch/s390/tools/gen_facilities.c              |   2 +
>   tools/arch/s390/include/uapi/asm/kvm.h        |   3 +-
>   tools/testing/selftests/kvm/Makefile          |   2 +
>   .../selftests/kvm/include/s390x/facility.h    |  50 +++
>   .../selftests/kvm/include/s390x/processor.h   |   6 +
>   .../selftests/kvm/lib/s390x/facility.c        |  14 +
>   .../kvm/s390x/cpumodel_subfuncs_test.c        | 301 ++++++++++++++++
>   .../selftests/kvm/s390x/ucontrol_test.c       | 322 +++++++++++++++++-
>   12 files changed, 737 insertions(+), 13 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/include/s390x/facility.h
>   create mode 100644 tools/testing/selftests/kvm/lib/s390x/facility.c
>   create mode 100644 tools/testing/selftests/kvm/s390x/cpumodel_subfuncs_test.c
> 


