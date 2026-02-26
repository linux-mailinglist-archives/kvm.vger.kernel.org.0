Return-Path: <kvm+bounces-71911-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uB7aKxyVn2k9cwQAu9opvQ
	(envelope-from <kvm+bounces-71911-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 01:34:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A17A19F72E
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 01:34:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8657D30219EE
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 00:34:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7D44344050;
	Thu, 26 Feb 2026 00:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a35g98pI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE59B33A9F9;
	Thu, 26 Feb 2026 00:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772066062; cv=fail; b=qIPD6tGP+h2AyV7B6F4QIrNDjm2s8qLJXU/dtn7+Tks/ESItsF7ZUODCRQHOr6AWSKBPVCSidR50wJWzD9p6O90eoEIQsMFaHWDk3uLmlzrWlQ2/cc9uwLx/lbzfQIW1vxmwC34dz5iGz9NWg+McwnFa2aAvHWz3wslJWI4qAp8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772066062; c=relaxed/simple;
	bh=dPg/CKIOYjm/ZhpLslNBBYC8ZU4miJSgS8kkcFg7tMg=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=tp8BuOASuy+qZZjBxbA2F3ce9Nh3jzFxntbvth1TgCQ2uTV2BOAijflisXUtK8UKozjQootzj0aOd7AsO2K7wbtdL/KMHufpmCI9Teos26en4rl4mi+lwAQAbRnkzXyp16o9H9JvyQdE4oO5qJ0POHvE3mXm4S6psWeAzMZjoZs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a35g98pI; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772066059; x=1803602059;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=dPg/CKIOYjm/ZhpLslNBBYC8ZU4miJSgS8kkcFg7tMg=;
  b=a35g98pIlFJLSf05jygqG55r9knNBKSroLoctfGYYUObkjvIZsjwVz5q
   tC57i6gIiawjEPusTFuaNFEYYZR8Xyog1YjaBm2irF8DTrtp6dtvZecNe
   b8mBNf0+N1xyIBGKhy0HTN8dJq1UCGkaZdUiwKs9LwQZ6htoH+gKUiLu5
   MOX7lDxvY7SFUCKVySanSFsutMp60Iv1Ea4vv4MUE0Uv28oj0+dOuyfsu
   /8th+xVmgjhKD32tNYKv/fX6brzcdCqxS3SXmkJQZjh8CoVlg4JNeuwgd
   NPKoy1BFGgY6CmUMr4/7SUTGWhbdjkGBC1OxlzDnNqf+QWdpyFS1oZd2V
   w==;
X-CSE-ConnectionGUID: W8qstnuNSoemueND8QCp9w==
X-CSE-MsgGUID: U1emgEtsRce04sOdhp+mZw==
X-IronPort-AV: E=McAfee;i="6800,10657,11712"; a="83828417"
X-IronPort-AV: E=Sophos;i="6.21,311,1763452800"; 
   d="scan'208";a="83828417"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 16:34:18 -0800
X-CSE-ConnectionGUID: JK4VsQNcSA+uFh6qBeMRpw==
X-CSE-MsgGUID: lL5MsZChSXCpWwgjLf+v8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,311,1763452800"; 
   d="scan'208";a="215508039"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 16:34:16 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 25 Feb 2026 16:34:15 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 25 Feb 2026 16:34:15 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.60) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 25 Feb 2026 16:34:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mvNyQwqZKOcIGsPyIlJzHWf01c4u/RiyN7wWs/IKvsoYm+bi1ksDY71HpaTn7APeilDlw7+sy//OlDoyLwqfDwe8XORhybS+19FvuPo+7qULVwrmxlYQn+EE38Ts+JOin4THH/Cyi9G4aakkZ+bXdwC9Xp0A+0tS1Ii/xGweqPmQio8IzPqI7N29sh9KmKD8XuC0kF4QbkUYRt/sB0rp8mvixME420uxuNV7NNKMVXWX3QS94gfRSbAq5rOkhXDRzIIiel1mqZVIeZZkhpvyj7fUPEEyZ4eoucV8vASPh1lfq6OxIWpCucXAPRGCQ3+TF6kveZT2MUBUc3FgH8LsFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jsh/fSCB9u1csUpHyy3OdQWWg067//302H+JkHKUJfk=;
 b=yM41OopR14M1vLkH+7o1fSoM3vpM4ZWuLb1nXnqbUDtqhwFXzbQwQCG3dHYcV3AgpN6MLeohK4aJl7cX4+J0eUlfA049rLfzjHPzjdSqv57QCCp+41LpoqcqjLBuni1WZYeQop4yZUmRQ4YCiFyx+B9rSa8GMc1TItFR3tJ3oUOx+kdMbXfDAFg9iwKZDqkrhTeX7Lzek82UP8ASozUDkcUlgbApIPNBnfkSmJy8mGuIyvk5Y3612K1ngn/AmscQ04GuQtuL1To+D3+fGJ/0FunpjfH/G+1jOQhcr8NPfKyGKf2Msj/P8dz67/R0Cwpvn9EZtv+1wVQIsWwxjYlWsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by IA3PR11MB9397.namprd11.prod.outlook.com (2603:10b6:208:573::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.15; Thu, 26 Feb
 2026 00:34:12 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%5]) with mapi id 15.20.9632.017; Thu, 26 Feb 2026
 00:34:12 +0000
From: <dan.j.williams@intel.com>
Date: Wed, 25 Feb 2026 16:34:10 -0800
To: Alexey Kardashevskiy <aik@amd.com>, <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Sean
 Christopherson" <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	"Andy Lutomirski" <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	"Bjorn Helgaas" <bhelgaas@google.com>, Dan Williams
	<dan.j.williams@intel.com>, "Marek Szyprowski" <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>, Andrew Morton
	<akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>, "Mike Rapoport" <rppt@kernel.org>, Tom
 Lendacky <thomas.lendacky@amd.com>, "Ard Biesheuvel" <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, Ashish Kalra
	<ashish.kalra@amd.com>, Stefano Garzarella <sgarzare@redhat.com>, Melody Wang
	<huibo.wang@amd.com>, Seongman Lee <augustus92@kaist.ac.kr>, Joerg Roedel
	<joerg.roedel@amd.com>, "Nikunj A Dadhania" <nikunj@amd.com>, Michael Roth
	<michael.roth@amd.com>, "Suravee Suthikulpanit"
	<suravee.suthikulpanit@amd.com>, Andi Kleen <ak@linux.intel.com>, Kuppuswamy
 Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>, Tony Luck
	<tony.luck@intel.com>, David Woodhouse <dwmw@amazon.co.uk>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, Denis Efremov
	<efremov@linux.com>, Geliang Tang <geliang@kernel.org>, Piotr Gregor
	<piotrgregor@rsyncme.org>, "Michael S. Tsirkin" <mst@redhat.com>, "Alex
 Williamson" <alex@shazbot.org>, Arnd Bergmann <arnd@arndb.de>, Jesse Barnes
	<jbarnes@virtuousgeek.org>, Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Yinghai Lu <yinghai@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>, "Aneesh Kumar K.V (Arm)"
	<aneesh.kumar@kernel.org>, Xu Yilun <yilun.xu@linux.intel.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, Kim Phillips <kim.phillips@amd.com>, "Konrad
 Rzeszutek Wilk" <konrad.wilk@oracle.com>, Stefano Stabellini
	<sstabellini@kernel.org>, Claire Chang <tientzu@chromium.org>,
	<linux-coco@lists.linux.dev>, <iommu@lists.linux.dev>, Alexey Kardashevskiy
	<aik@amd.com>
Message-ID: <699f9502bd87b_1cc51001@dwillia2-mobl4.notmuch>
In-Reply-To: <20260225053806.3311234-9-aik@amd.com>
References: <20260225053806.3311234-1-aik@amd.com>
 <20260225053806.3311234-9-aik@amd.com>
Subject: Re: [PATCH kernel 8/9] RFC: PCI: Avoid needless touching of Command
 register
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0060.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::37) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|IA3PR11MB9397:EE_
X-MS-Office365-Filtering-Correlation-Id: 19450f39-50c3-419b-9252-08de74cec378
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: oH5akdYFiB4+/JSrTNF3IFO6mGOIQhZsgL6N5BcXWHegybS2VGbZjEuUQed5dV95ltLqArxqLfHwE8DvD+0NiltxblQ1pxDmx/54tEDoF+uoUY3zAfrkn8VWnTIEgSr70SIcEhqhf7x/wY2Y8nQrqq9Xr7JxDvANxUegcz6pZigOJwmqKrw67ABenxr9kUNT9pteYoA8LhaZWBhS0L1d2nr+l68QsvMuVW9/ulTY0yRZI273eHem8qdxRkEWzOugf3q2blhhNm9QqSSKsot0U/iPYrjrMOLqAY26dSH+MFesYhRjs75amvq8FSuTjiGxk3YsvSvm66Rrb0gBc60XB+fl+pBWSeeBGMcrjoTRjxJrlQNgk3S/G22S8+vSSUNhIjQOscV+c8zm+8zbFReGkC5jjzH+ecFiBuppS3dZKi3I38aVhZ73zYVRcq1LQMgdl3VppS6lFK4Qs4XB722APgtja14GvmzKL8VlI71CbmOpdDZaygct1BhQSs8nqYDASCaqjM4fATlDi82IReYz9ic5tRxbYZx1mfqWTofeOLrrZm4GxRyaEgVVcDJv7RHksD5AZlH+kPyyjLNTHhxZ/kxZHT0jLSENuSY7sR5OIdX7hSTV7j9raGvaTIlmCaGlEFG96eunDLpyOWH0HLk7Xmb7xrmihN/uhBWcIcmCzaIuIqofudMmKR2tPjl005UwQH/SN34srCXB8dQKNatvkr7hRiqe9No2fVF9z03RmWo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Vy9mRDZvWGJ3RmY0SG1idFJRSjZVRDBIcmxKUGRpTEVOVnlVZWJuRXNFSmlu?=
 =?utf-8?B?QS85bGpVUGFsdkVaYmRFcGUweFBRQndIMFRIOFJaM0QzUXhwNXkzRFdBODND?=
 =?utf-8?B?UlZaeStyY3ljWWJQa09xTzdVYTNTTkZqQk5RbEdISC80WkJBS0oybHdiSFc1?=
 =?utf-8?B?TTBIZU5JSXExajB1VGRFVmRBeTR0NEN1aSsyYVlZY3pORC9SQWQvaXk0VG5Y?=
 =?utf-8?B?bFFXQThnTEVpU3ExR2RnN09rVHNBQUdXZmJPL29xcWVjT2g0V1VpQXhuN1ph?=
 =?utf-8?B?dWhlam15OGhwdVFHbEUxczVTazlxSGU2UHYwdHRHdk1wZGhiYm82UnRVYjRx?=
 =?utf-8?B?MGVObk1uWDlnL2xDUDJiL0RwVUdPRFNuYmgwQ0NTRlNYMG5LU094RlU0dnAz?=
 =?utf-8?B?dUNxS3RuUU9mWEVVblR0Q24yRFk5amluTERMaDQ5SlpEUnBScmIxc05kZFA1?=
 =?utf-8?B?aVRyYjAraVZQVUJMS0N3dHRCMHR0eVl1dTk0OVJPWGJIdStaOWFUWkZ3WDg3?=
 =?utf-8?B?Vm5wSUxscWtvZjlNNVVKUWl2akhCYWFtd2hCcE5sTkJaUWQyUEt4d0dBNW55?=
 =?utf-8?B?T1llb0MyS2lLSTB1MmMzeGxHRzkyVmtTTVl0R05BV1ppZzZuN1pDWjVQR1ZC?=
 =?utf-8?B?anZYbW5pbTZOTGU0UEZVUnY4SFI2Z25kMCtGcDVhbE1USzVOcmlCNnJ5NVJ6?=
 =?utf-8?B?VFZzcmpyQ2IwL3pQaWxYc3hKRGJXM0MxblF0OWYvNWovUG9iVXd0SnZMSDdN?=
 =?utf-8?B?czYyME5Hd2JvMk1qaGEzclV4YVpvVVI4QS9NbGVGWk8vb3A5Uk9jQWdOK3Fr?=
 =?utf-8?B?QWVFQlh5VGRqVjBWeWU0YUp1akhKc3pNbU1CT3VsTExXbU9tazN4S1RJL3ZK?=
 =?utf-8?B?eXowZGJEZWd1MW5aR3VyZkQrVHhlNDQzUWtIZEZFbVBiTzF1cjk5SGVwSW9v?=
 =?utf-8?B?UkVLNURZdG1PRlBuNGp3VFZ1TzBzMC9FNU0rSEgvSUFLZDhNSUxzdTFZQzBK?=
 =?utf-8?B?YjE3bUJZQWZWVUZqVlJ2azFvTjlORkNWK2Z4Nk5yNzE4OGZWMjgvNFM0cFhW?=
 =?utf-8?B?eUhpWC9xSldLbE5ZQVZRcHRvZkczaGlzSW10bU1YbnhwTjR6azVKTWJtSE1X?=
 =?utf-8?B?V0ZZUnZmQjlLVkNkT3Y2TkRjeXNRVk9DSnhTaU1wMTNhSFdPSFdKek1LalNm?=
 =?utf-8?B?c2R1UFVFZWN3WnRRbVZBZ3ZUNDN3VmVtQU5vSWtPcmdOUkVQS1loQTlncTJD?=
 =?utf-8?B?NU55eW9ScmxtQnk4dllETlIrYTNldGZReHFZSGFvcmZ5MjFjY0YvOHl6NDl2?=
 =?utf-8?B?NnpqV3FsZE9xTU9pejROZ0haWUV4WG1jemVIZSsrMjZ6MldoR0h0bEZPcVpP?=
 =?utf-8?B?eTNjUDZSZ1huODVHTDNEcGZXOHJIYnJWLzJKd0cwdHpOa1dVdXpNRys2YTRT?=
 =?utf-8?B?cDliUmtIeEQyV0ZOVWVQbzVDeTJOUVlTb2prdnJHL3ZEemZRVzFEV1IxVEZ4?=
 =?utf-8?B?c1RPc3VLQ0NqOGk3MjU1dTFrYkxIL3BVajBtZ3dNb3JLbjRPcWJINVFwcnJn?=
 =?utf-8?B?bEp2Yk1xd2hMUEswTGMrRURiR1pUSU93VWlYYmo3d2F3THp4R2VVMGtqb3RK?=
 =?utf-8?B?VWJ0WXQ3UTdwbnE0YUVDaFVZYTNFcHdiQlNPVjhHNndQN1EvUzAwdVhFbG1s?=
 =?utf-8?B?U1p0NnYyZVUya3MxVC9CYnpEcDhGbjFvOGRhTUdDOWc4TGQrblBRYjdHUkV0?=
 =?utf-8?B?dTlRRTJLNmtIWUhuVVVpMm9kUHJpLzRnd2U1OENLYUY4TlZXOUJPYUFpbzlW?=
 =?utf-8?B?N3hMaE5NNXNIVDk5bEo1d1dpazdmcS9iSjQ0aWJ5UmxMWHBLcjhJMm91aDFJ?=
 =?utf-8?B?cWlzSStRMGxZVHNuYkpCV3JRUmV3WnpQUHBRNmlwRWJ1L0ZFVWtNUVZ4bnA4?=
 =?utf-8?B?UDZPRVhxTVZYT1J1QlViTXh5T0JWbFJJYldmY2ZlNitrNWNTZkNhS1o3WkJt?=
 =?utf-8?B?SElNTmZsNEgrSTArOFBXQ1NGdHhkTkZ1eFUyZXhBd1JPM1ZmbjZ1SnpQdlZJ?=
 =?utf-8?B?S3l4cDRsMG9WQkVJR2JDLzVJSVJxUjB3MnZpQk9kTTFZTmE1UTVETHpYZEFi?=
 =?utf-8?B?aWh5WFkxdUM3dWx4ZTBZY3Y4UmJCdEwyNkFGSHhzMzVwQXRsUUpEZ1R1bGUv?=
 =?utf-8?B?YlM2SnhQTW9keXZoZXBBT1R5NExlbk01aWJiTVFBT2tYVFR2QUFiblpVSGZE?=
 =?utf-8?B?UmErdVoxdGFIRXdZb0F3akNhTVVFREFGMDN3bjVCZXNkREZYbThxc1M1emc1?=
 =?utf-8?B?R1hPajBYenVQOGRJL2xJM2szR0xFRzdGNWZ3MmcxdVBVV2hhTmt5UWhmS1Bm?=
 =?utf-8?Q?P973JnuvWx+qr4EE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 19450f39-50c3-419b-9252-08de74cec378
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 00:34:12.6326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fQJVC6ojupoXqxUlhx6ZmN0QrfpLQ5kKW0e1may64i4LUgVDFFvBoU4hEASKbZnguJXQkwUrG5vlm08TeXUl7QQvY1KEz3fCcvBw/7EVJxA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9397
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71911-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,intel.com:dkim];
	DKIM_TRACE(0.00)[intel.com:+];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NO_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dan.j.williams@intel.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_GT_50(0.00)[59];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 4A17A19F72E
X-Rspamd-Action: no action

Alexey Kardashevskiy wrote:
> Once locked, a TDI's MSE and BME are not allowed to be cleared.
> 
> Skip INTx test as TEE-capable PCI functions are most likely IOV VFs
> anyway and those do not support INTx at all.
> 
> Add a quirk preventing the probing code from disabling MSE when
> updating 64bit BAR (which cannot be done atomically).
> 
> Note that normally this happens too early and likely not really
> needed for the device attestation happening long after PCI probing.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
> 
> This is also handled in QEMU - it will block clearing BME and MSE
> (normally happening on modprobe/rmmod) as long as the TDI is
> CONFIG_LOCKED or RUN.
> 
> This only patch is not enough but reduces the number of unwanted
> writes to MSE/BME.
> 
> Also, SRIOV cannot have INTx so pci_intx_mask_broken() could skip
> VFs too, should it?

Locked command register management is handled by QEMU. This patch needs
quite a bit more explanation about what use case it is trying to solve.

