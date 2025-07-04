Return-Path: <kvm+bounces-51538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 27BFAAF8706
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 06:58:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C990F3AEDA8
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 04:58:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 824211F1501;
	Fri,  4 Jul 2025 04:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YvAy/tHi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FE91EF391
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 04:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751605110; cv=none; b=HzrqpvzJHf8f77ELtCJOLIjeld8I7PZutZmPYNUD0lZTzfnJx5csR4MpMwp1FFP0jqecfZype2OQxr14iaLvTwtp9NKEf6RJZhC0P8M4Fh5+1DiC6BY0Crm5w18aBrCPwhoRrrm61lVplxg4zFwx5CcOnWJfhHkAAYu9C+u0x6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751605110; c=relaxed/simple;
	bh=SR78OUN999y80a2xAo+6NpCQXfueXEeGFkK75F8f5CU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mRiViNqBt6WW4fyNihglXpT3zpNy9T9Y/iVIdG7ZAxNvz0JQ0Wlj0e1tuMyaqcl8f55dtFxdbz8HjJZ52F8xlhknALty/plHORsu514uIrWeGGSl+bYkYqQwWww5ysxbcIJ34sNUFdjwV7bGE626aw3xrmbwHUJMKH4yBDYkut0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YvAy/tHi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751605106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RWA9x7qhxNW2l1p6ltGUfCp8OmCZaJaVxhg1nTkJ0sU=;
	b=YvAy/tHiLYwF7Ahqo3ll4tTgsaZll03gi9AEW1JXD2490i99Umi9ff2NyyRHqAcB8Vx9T8
	yh9rMUWRwB9qJancrqSwuGdBrboXZvbr4KuyTWxrF6gbKg2jfBWCsXQLRDMWhtLlLlHZ1H
	idFNIWa2+meq58FV2uO9L25FFBC+XDU=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-HYOQUAAkNtSV_cR5pcxKfA-1; Fri, 04 Jul 2025 00:58:25 -0400
X-MC-Unique: HYOQUAAkNtSV_cR5pcxKfA-1
X-Mimecast-MFC-AGG-ID: HYOQUAAkNtSV_cR5pcxKfA_1751605104
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-7425efba1a3so675604b3a.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 21:58:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751605104; x=1752209904;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RWA9x7qhxNW2l1p6ltGUfCp8OmCZaJaVxhg1nTkJ0sU=;
        b=OFQ6yufvJzIosY3lE5gjHvPFJJuJI8jAeEFgmp+NDnypnHLqJ1QVt2W/aZ1HPasLsF
         YhkbGoRF7qkULwtTjFURXf8SqZhUtg+bon7fgXdBngTHpXeT8AeTMKqwEOXGVPhCxXDS
         5btazxQYD+dUDuBUfCvI+qgZBwoipfmFU+e5rWnHbuzfW1/5RhkZjk66EC94RG1xae/b
         X35QKR3iz/S3UWR5NR/lqDunyF4px2mpZ9PsCWIEeo4I+PKSBgxzeX5RQHL1trIBhIcq
         8DzCu9B3LqLCuBNc3jRkXgy94vk8+old2LfGr6yYvTeti8jVw+WYafqRMlmC2Lr9AczB
         Mkvw==
X-Forwarded-Encrypted: i=1; AJvYcCV9pPXLHuPRlZ7qwe9AblYTUXbFsiv+bapvnMitVcDzZ+nC/XHdUM7cn/W/c1G4WXbbGG0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQUyRPpuE8nO938W8fHIuhtAZqYm2UDIHYQqr1f5C9VXtFRorm
	ScsvrO4sVWZP0I8Q/+IJ2blle9UxB1bCmy/p3pVUw/RAcq8/O2KFNrjdnQSCQCirOIU/X0ZQ79E
	AUtiybyXlzNfGZTxd7+7LAti/4qHJ+3SBL8fRMnr9bzxtH6JyOSbvEw==
X-Gm-Gg: ASbGnctkoAUcXWfE0FkNuCaIqt29GarmA+SDIpR/yUEcbOFWOzwwgnpeAvHQuLFk4ER
	zXLzF3aQFSIg/GCHzHEjvVE3RFzdJg0rCLutpOgQSnhwYaemL/xTj+Kp+H2JfQB5G2Q/aDyMj0Q
	v6umXQDPOs2bBxTKyn9hELfSc7QRmnHUoBuA4FaxGzSxrhAPWaCKYNhdtylQPlSjQKn6zs5pi/j
	cZaA9JK5rJE2YtoTp5HtQ0gXGjseDvQiTKGz9lOi5D5MLglhHySE3w24Ab1H+47xN4uvGEafHx+
	YK486k21b6rwQDpG37PltH/ij/4stHcPQwGc5mo+VHmBvHoNSqlORwPfjnoGVg==
X-Received: by 2002:a05:6a00:18a1:b0:749:1e60:bdd with SMTP id d2e1a72fcca58-74ce5f38772mr2112078b3a.2.1751605104453;
        Thu, 03 Jul 2025 21:58:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHF5wv+DE6Xrth2Z9dMtx7SbYzBfl2e7NF0on99f9M31vN5qmwp6uCO7D9ntAdPIgA97WcR6g==
X-Received: by 2002:a05:6a00:18a1:b0:749:1e60:bdd with SMTP id d2e1a72fcca58-74ce5f38772mr2112052b3a.2.1751605103850;
        Thu, 03 Jul 2025 21:58:23 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74ce35cc32fsm1076594b3a.52.2025.07.03.21.58.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jul 2025 21:58:22 -0700 (PDT)
Message-ID: <0ef9c9bf-70df-47fb-976b-acf6bff4ca3a@redhat.com>
Date: Fri, 4 Jul 2025 14:58:13 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 00/43] arm64: Support for Arm CCA in KVM
To: "Emi Kisanuki (Fujitsu)" <fj0570is@fujitsu.com>,
 'Steven Price' <steven.price@arm.com>,
 "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>,
 "'kvmarm@lists.linux.dev'" <kvmarm@lists.linux.dev>
Cc: 'Catalin Marinas' <catalin.marinas@arm.com>,
 'Marc Zyngier' <maz@kernel.org>, 'Will Deacon' <will@kernel.org>,
 'James Morse' <james.morse@arm.com>, 'Oliver Upton'
 <oliver.upton@linux.dev>, 'Suzuki K Poulose' <suzuki.poulose@arm.com>,
 'Zenghui Yu' <yuzenghui@huawei.com>,
 "'linux-arm-kernel@lists.infradead.org'"
 <linux-arm-kernel@lists.infradead.org>,
 "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
 'Joey Gouly' <joey.gouly@arm.com>,
 'Alexandru Elisei' <alexandru.elisei@arm.com>,
 'Christoffer Dall' <christoffer.dall@arm.com>,
 'Fuad Tabba' <tabba@google.com>,
 "'linux-coco@lists.linux.dev'" <linux-coco@lists.linux.dev>,
 'Ganapatrao Kulkarni' <gankulkarni@os.amperecomputing.com>,
 'Shanker Donthineni' <sdonthineni@nvidia.com>,
 'Alper Gun' <alpergun@google.com>,
 "'Aneesh Kumar K . V'" <aneesh.kumar@kernel.org>
References: <20250611104844.245235-1-steven.price@arm.com>
 <TYXPR01MB1886280D98B07E971424D62BC37BA@TYXPR01MB1886.jpnprd01.prod.outlook.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <TYXPR01MB1886280D98B07E971424D62BC37BA@TYXPR01MB1886.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/25/25 11:51 AM, Emi Kisanuki (Fujitsu) wrote:
> We tested this patch in our internal simulator which is a hardware simulator for Fujitsu's next generation CPU known as Monaka. and it produced the expected results.
> 
> I have verified the following
> 1. Launching the realm VM using Internal simulator -> Successfully launched by disabling MPAM support in the ID register.
> 2. Running kvm-unit-tests (with lkvm) -> All tests passed except for PMU (as expected, since PMU is not supported by the Internal simulator).[1]
> 
> Tested-by: Emi Kisanuki <fj0570is@fujitsu.com> [1] https://gitlab.arm.com/linux-arm/kvm-unit-tests-cca cca/latest
> 

The series looks good to me in my test where the host runs in the environment
emulated by QEMU. With below components, the VM can be started, destroyed and
simple workloads can be running in the REALM guest.

Tested-by: Gavin Shan <gshan@redhat.com>

   host.tf-rmm    https://git.codelinaro.org/linaro/dcap/rmm.git
                  (cca/v8)
   host.edk2      git@github.com:tianocore/edk2.git
                  (edk2-stable202411)
   host.tf-a      https://git.codelinaro.org/linaro/dcap/tf-a/trusted-firmware-a.git
                  (cca/v4)
   host.qemu      https://git.qemu.org/git/qemu.git
                  (stable-9.2)
   host.linux     https://git.gitlab.arm.com/linux-arm/linux-cca.git
                  (cca-host/v9)
   guest.qemu     https://git.codelinaro.org/linaro/dcap/qemu.git
                  (cca/latest)
   guest.kvmtool  https://gitlab.arm.com/linux-arm/kvmtool-cca
                  (cca/latest)
   guest.linux    upstream (v6.16.rc2)

Thanks,
Gavin


