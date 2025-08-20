Return-Path: <kvm+bounces-55102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93481B2D5D5
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 10:14:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 73CE6586458
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 08:14:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBB602D8DC2;
	Wed, 20 Aug 2025 08:14:07 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8856D2D8763
	for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 08:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.0.225.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755677647; cv=none; b=cNHkV+SI0hKZrtrJB+nWG/01Wa1hme30lPD7tl/V5yltNqhuqnxiQ6zLaPfI6TvoO8pVayK0ikVS7NqnG4OvntjIuqlqKJRpmDgPo1n/Dzq6NRGmRN/Yh7U866TTo0pNU6ykHnw92TPvySzo/jJQWl4lAr8lAGnUb92gWKJ3k+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755677647; c=relaxed/simple;
	bh=eKuLTiUrmLv8e/vRObGoxRu1VKsLAAlmJ6yv2fO3pqE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Q3r/H85Y/tul+gS6VZmXCA0ztbCdvRrLc+7RHNJcuR3HUl7JRNnmY1t9wvr/MJG4YbeiP84lDWhFKDDLE9bnUNrdfZvi9vyz7yHCOllswx5Qi6A6Rj+kiFbqtdUk3SG0py5KKt3Dq7tNe1CEwygHQPvGe1hBL4CjC5Jzkhar/BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=210.0.225.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1755677633-086e232956252630001-HEqcsx
Received: from ZXSHMBX1.zhaoxin.com (ZXSHMBX1.zhaoxin.com [10.28.252.163]) by mx1.zhaoxin.com with ESMTP id yeIMTAfFGpFlv0E2 (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Wed, 20 Aug 2025 16:13:53 +0800 (CST)
X-Barracuda-Envelope-From: EwanHai-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by ZXSHMBX1.zhaoxin.com
 (10.28.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Wed, 20 Aug
 2025 16:13:53 +0800
Received: from ZXSHMBX1.zhaoxin.com ([fe80::cd37:5202:5b71:926f]) by
 ZXSHMBX1.zhaoxin.com ([fe80::cd37:5202:5b71:926f%7]) with mapi id
 15.01.2507.044; Wed, 20 Aug 2025 16:13:53 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from [192.168.31.91] (10.28.24.128) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Wed, 20 Aug
 2025 10:03:53 +0800
Message-ID: <b7a6b660-942c-46d7-ad8c-b60be6790512@zhaoxin.com>
Date: Wed, 20 Aug 2025 10:03:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: x86: allow CPUID 0xC000_0000 to proceed on
 Zhaoxin CPUs
To: Sean Christopherson <seanjc@google.com>, <pbonzini@redhat.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>
X-ASG-Orig-Subj: Re: [PATCH v2] KVM: x86: allow CPUID 0xC000_0000 to proceed on
 Zhaoxin CPUs
CC: <x86@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ewanhai@zhaoxin.com>, <cobechen@zhaoxin.com>, <leoliu@zhaoxin.com>,
	<lyleli@zhaoxin.com>
References: <20250818083034.93935-1-ewanhai-oc@zhaoxin.com>
 <175564446520.3064288.7316885414458356151.b4-ty@google.com>
Content-Language: en-US
From: Ewan Hai <ewanhai-oc@zhaoxin.com>
In-Reply-To: <175564446520.3064288.7316885414458356151.b4-ty@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZXSHCAS2.zhaoxin.com (10.28.252.162) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
X-Moderation-Data: 8/20/2025 4:13:52 PM
X-Barracuda-Connect: ZXSHMBX1.zhaoxin.com[10.28.252.163]
X-Barracuda-Start-Time: 1755677633
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.35:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 507
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.145999
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

On 8/20/25 7:11 AM, Sean Christopherson wrote:
> 
> On Mon, 18 Aug 2025 04:30:34 -0400, Ewan Hai wrote:
>> Bypass the Centaur-only filter for the CPUID signature leaf so that
>> processing continues when the CPU vendor is Zhaoxin.
> 
> Applied to kvm-x86 misc, thanks!

Thank you for your suggestions!

> 
> [1/1] KVM: x86: allow CPUID 0xC000_0000 to proceed on Zhaoxin CPUs
>       https://github.com/kvm-x86/linux/commit/1f0654dc75b8
> 
> --
> https://github.com/kvm-x86/linux/tree/next


