Return-Path: <kvm+bounces-8431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E25384F66A
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 15:02:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8BBF283618
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 14:02:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A4C0679FE;
	Fri,  9 Feb 2024 14:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GGtZklbH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2079.outbound.protection.outlook.com [40.107.92.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAB75025A;
	Fri,  9 Feb 2024 14:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707487353; cv=fail; b=H4qMKYQEXz/gTxwsuw0FyP5X6/KXAbzC86HShG5Mszwlwj7wa3BI1yvq+4G/uI1kUD/BeTExFXZUOzvO+n+1Ht06O3U/+tF9t39Gc56kkZOHyfpMclHgZ1sGxZVpfMXDuhtbDo1nrrllBw23q009tdnMy0oU06U2zWCvd3SXSkc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707487353; c=relaxed/simple;
	bh=5YqK8X+Nssx3UghroxhO0qywGFZVoj1dCa6QT5ZwvLg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=a3NLOFHGDMcYBoTD4MDAq1bNWuGh/Z6BfrPYG5shCartis5SbtWjKElhMfkoT2YxPuC2Of9lLVQ0czCEbG260L2hUudMUXOgYLx9WAKcsgy3fF9cFqwa5mmtQX5r8kP+Fu5tx0f9HQ+3I6fmim0e2tJQUNGvg1f0Ap3ar3o0nF4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GGtZklbH; arc=fail smtp.client-ip=40.107.92.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jbcDoUEz85IEiWYSwE6ny1DpOSGHxtpVJBPFawwwD21/EmLvtXqQBIwXHKeqk1FfnxAE34F5hpiRauqVwnml9STPFusk4t/o0Vfo//oGlOuRsmK8D+JUVPaiHAskLb57Xb9ggfLyabzCtuRMAIWu0Nqtl77HRvfnXwFqIHHuFXa73tfCzkG9G2PNEmCyxzk7O+de0xx/dhczZrPJya+v/O9wO9w5yDALdn1WzA1Ec7tpLJPinykWFRyZZ1moO5ITl6hqHRGndm8DN356jqvmgePCC1irerEQXzuqyXBKunmbbgb1TQwuvl81uKc8lWhKAQQQJzgA4KqMyPYT35ptzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mMPm/yRzS4LkriLfnWCP9NS7k227165nkluHgTDLY64=;
 b=FP1WIZ7QZR0Fy9zyGgjqmAMUMXsjQheWKi7+9Myt6D6C5tMmIut9JF9DzNLwR27PQx/K9tqbbEQIS3usOxZ0T+J4BSJCOAg2tAyBBZmR7yaEz6jjsTuLe5LE0pfcuKKYnDBENIQUYYxQZLFhOjK+A4ARomaTWId/iGjTqh1cdds24m/eyZT1Dzl5gjbhD+ZDvbSydqgQSP+HXRo054XWMvVMB2kUkQFBw8AjZLEYE7VABiyFxHQOEqDs2B7MLw2IZ43lFCwwoixLB4gDzz7MAb9Gs8islwbvweceM9bnNmPDNDXPzY5f+9iTa+1Rh3vwLwURTeEb/+X7ffTog9j+2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mMPm/yRzS4LkriLfnWCP9NS7k227165nkluHgTDLY64=;
 b=GGtZklbHDXSlCc14xgT7qzdoWZqEsdlZuz8A4OE3L0ybqhjxiwj0ZG+XeJN7z53cyfDV5TFO1BmQFv2dIIRMLv3Bd/IJwwjb/lqCWYhe4FdhBd2KgzcY2dSMoKHep9f7Ajj1A1JnvnGUFXqFWrPDc2AOZV8VKboKsrlwBrNbR3jBbd9SGEpFBF1VbNp17knjbaI8PW2sq+UiB4fzjU4O8mi8hzlbED4XfHaKtvwQ0tXqZoawZKR+CgV2597fZC9cY4tsUfqcSwhmnKiHEVQbOs0tAvrwaDax3h8Mjk6x4a2DaOGKAzok6+cLMNbVpvo+JlRGZJGwnkVRwbg7mQfwMQ==
Received: from MW4PR12MB7213.namprd12.prod.outlook.com (2603:10b6:303:22a::18)
 by DM6PR12MB4578.namprd12.prod.outlook.com (2603:10b6:5:2a9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.12; Fri, 9 Feb
 2024 14:02:26 +0000
Received: from MW4PR12MB7213.namprd12.prod.outlook.com
 ([fe80::b68c:1caf:4ca5:b0a7]) by MW4PR12MB7213.namprd12.prod.outlook.com
 ([fe80::b68c:1caf:4ca5:b0a7%6]) with mapi id 15.20.7270.012; Fri, 9 Feb 2024
 14:02:26 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "james.morse@arm.com" <james.morse@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "reinette.chatre@intel.com"
	<reinette.chatre@intel.com>, "surenb@google.com" <surenb@google.com>,
	"stefanha@redhat.com" <stefanha@redhat.com>, "brauner@kernel.org"
	<brauner@kernel.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>, "mark.rutland@arm.com"
	<mark.rutland@arm.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"andreyknvl@gmail.com" <andreyknvl@gmail.com>, "wangjinchao@xfusion.com"
	<wangjinchao@xfusion.com>, "gshan@redhat.com" <gshan@redhat.com>,
	"ricarkol@google.com" <ricarkol@google.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	"rananta@google.com" <rananta@google.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, Aniket Agashe <aniketa@nvidia.com>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy
 Currid <acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John
 Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, Matt Ochs
	<mochs@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v6 4/4] vfio: convey kvm that the vfio-pci device is wc
 safe
Thread-Topic: [PATCH v6 4/4] vfio: convey kvm that the vfio-pci device is wc
 safe
Thread-Index: AQHaWgb18It89LNRq0isaS+c2RvzNbEAtO4AgAAGx4CAAVCChQ==
Date: Fri, 9 Feb 2024 14:02:26 +0000
Message-ID:
 <MW4PR12MB7213C81E5CD611CF3AFCB0A9B04B2@MW4PR12MB7213.namprd12.prod.outlook.com>
References: <20240207204652.22954-1-ankita@nvidia.com>
 <20240207204652.22954-5-ankita@nvidia.com>
 <20240208103022.452a1ba3.alex.williamson@redhat.com>
 <20240208175437.GN10476@nvidia.com>
In-Reply-To: <20240208175437.GN10476@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR12MB7213:EE_|DM6PR12MB4578:EE_
x-ms-office365-filtering-correlation-id: 7e15f7c7-7b5e-48cd-2b5e-08dc2977befb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 V/LesF/vko/Gd0I0U6G3uKJZaY7QTmhxWckDsxj77rsW/ePmxJpWRow3g1+UL/Vi6m5mYY6Q+4vES8JMjU9rMRdeJZSPv/Wvjrzkbz8S7CoGyIKej1NzwjUmq7cVtYQllCkvEQyHmcTxwkFj24TAgTrvxvQ+o0oyWQeqL9o27AKpUYXjJq0bHmzZntyKXxOzXtaMFrdMWaIJzI2DakgH36UWhej4XwZghrph4NmuvcFB8k2L8EAIRN1OaItz7TpuL2rNSb38/inmulgDWkX91C8QPAOTT/rzb5V6HNO3wr8qhgCbsceY39xO6gjDqZZBnRz5ZTRBCAhkpcYjYuFXLXd20wRrOe8bK0hP+UT02xvfMK2w2xViVVGjqlZvCbQ6cxC5pRrICfTeClovPqiB/jleKGgocCnbhVqM8JudIwXd3VOQzVN6VzcAVuECSqxAeotmlTkhr5dhI377Emr9JBLIm6ijVefZ9L2VzvJoFQVtOH7bU1toHFRoo1BBiGKPKip0mfGi8NlbwlgKf0vkKzzbzB0SefN1oe1um0lpBUXiKuq1eEF6GEciZDuRCGs7r/C5bm9OocJeKf4WMxL4d6nn9iOly+NTA4HJ4heBFeXSWspcNuj8BE8iHAU0x9qA
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR12MB7213.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(366004)(376002)(39860400002)(136003)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(86362001)(41300700001)(38100700002)(122000001)(55016003)(5660300002)(64756008)(66446008)(66476007)(2906002)(7416002)(71200400001)(478600001)(7696005)(9686003)(6506007)(54906003)(26005)(4744005)(38070700009)(76116006)(52536014)(4326008)(8676002)(66556008)(66946007)(110136005)(8936002)(316002)(33656002)(91956017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?Z6XFeR8ZoIrJ0HBz0PiOzIvGulNuX6GMAru4AHjrG2hmIpvRIoE9fSAxmU?=
 =?iso-8859-1?Q?wjqPszVlYZOqqDKDe+hvuf+ICu02p3IfvRo79yeVbaNrZh3cehSHGKAJO6?=
 =?iso-8859-1?Q?4QGqx71SkhISysuZx02wjGIQy9F8+JAcyLxRbmTBzxTxHBZrgf+JcjuypN?=
 =?iso-8859-1?Q?iISoFW3TdEQMfFF6YFH7sdClHQeHpqOWXYLec/YMfBzL5M43uQYpVsDuBs?=
 =?iso-8859-1?Q?TCrMbangX4/3dAFERHeJUyNqEchHV07fe0XXYH+pRKAQagBHJJbik9Ge9f?=
 =?iso-8859-1?Q?u5rkEaFcWwLr21hrUkaHmuQB+IooweYwPhAWw33dJa+Yde9xsjBMuntJS6?=
 =?iso-8859-1?Q?ZAJDy7Cm+6HN2rMHDcSok9SfxWv74k6P0mNeNp70evFxGr4+LR+epHx6DR?=
 =?iso-8859-1?Q?3THlsJsFR0QXIB/XmMiU+BGUKwmiac5BJDJC7sPYjAxSTEmZIQftwp+Vet?=
 =?iso-8859-1?Q?1wf4neJIhMITuzpE4bIDiAH5vMX8v7JFZuWBEXYCmNSz9DB2sZ3/rv5DZK?=
 =?iso-8859-1?Q?ziZK8JA22hyxtRfmcMsV7EGSgO0JpJ/X0uXSVG5nt+VVRbEKNVvX+n52iC?=
 =?iso-8859-1?Q?XMkvqCi1WGO//XcJJ44ePk38fHONDWMRxbqQSrWSy+HWWFoZk5wzs+E72z?=
 =?iso-8859-1?Q?Q0Vk7SimZttJgT/LZ+KYGFHyM61CY3rIB+RpDi8vTF33HhjgzUcmx96voV?=
 =?iso-8859-1?Q?cQjrxiCf9uYUok4jHH09BogVCIbGXN5c336Exy9WKXcDq+rVlFBo3szid3?=
 =?iso-8859-1?Q?LsO6qTBMfiB24mIA7pZ/nojYJqXZ12HTHX45vG6fFhy9RR6zbmsWVfqKbM?=
 =?iso-8859-1?Q?vfhwRVLkT+L5pR79cLcdpFOXOSAe9pEFQ481+jhEoa920YfnvU806otZmY?=
 =?iso-8859-1?Q?w3kJ6XA0DROsWcghjzVfAxP1n5BBTnvRsdBBqLKBnFwM/nUqySk//vfoej?=
 =?iso-8859-1?Q?y62ueb7ataurtQub1PBUYC2L3CzKCpocxmGpHstUQx5apqRJ2oaDdPW80X?=
 =?iso-8859-1?Q?KutZEEQW0c9BBXhnMijza2uOIrmadEFu+R+6oXbHZ6MIL/UxQUA5TtCh2C?=
 =?iso-8859-1?Q?MPb+ALwb0CBSnxs3uIex8eyOLiNrhmRJK/4xEFL4YUiHUrYbdmaSHdYCc5?=
 =?iso-8859-1?Q?k0PPNaTklYmcNrfekuOR7JLCt5vZYFLmBvRN+zG2u5fdiY+5rowUBJLX5N?=
 =?iso-8859-1?Q?ueaidSRiitvQTczVxP0b+pCrL2T9Mzfg61hEdcKbk4wd646QtANzB1qRYj?=
 =?iso-8859-1?Q?b50DC3q6qgPPEr3kTHwh0fVcmyScxh2gVWh2T/9pNOLWkl4lkwdle5B7yF?=
 =?iso-8859-1?Q?3XSA5nOmQDU8R0hNKNjk/nr2N/rI+BVSPvp8G8p8/jJeJZjKvCJsliRr+s?=
 =?iso-8859-1?Q?z9SGJxhBzgHjfdEX7752Ss1Mm5aybDYIE8iJsI22vBvgAAKx4IAycAUmOq?=
 =?iso-8859-1?Q?8TK44BuRc6aJL4spWrG8kDSzZLFn+dTYruaOkrwb6erbwBKNKiIl9YLrMN?=
 =?iso-8859-1?Q?WBsY5GeKK70A5wEm8XXK3tswFGGRjueQrOTUlne2ahljp4Z+mdQ+q/PcT6?=
 =?iso-8859-1?Q?d4sGZNgf1zBKEIGGbZX35pzdUlNa39EgZ++2DY8GqzTtTLkRjOOAapcsmw?=
 =?iso-8859-1?Q?Frb9hENMpG7o8=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR12MB7213.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e15f7c7-7b5e-48cd-2b5e-08dc2977befb
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2024 14:02:26.1571
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tfo7sRb7XEpyHe3J2SJaGSoit7N8MmmIsOXTEQBBfJibEtxGUybdO+Mki0mEJPxorQIBPQoAxVYN0C/f8er5Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4578

> The comment above this is justifying the flags as equivalent to those=0A=
> set by the remap_pfn_range() path.  That's no longer the case and the=0A=
> additional flag needs to be described there.=0A=
=0A=
Ack.=0A=
=0A=
>> the comment where the bit is defined and we could use a name like=0A=
>> VM_ALLOW_ANY_UNCACHED or VM_IO_ANY.=A0 Thanks,=0A=
>=0A=
> I'd pick VM_ALLOW_ANY_UNCACHED of those two=0A=
=0A=
If there is consensus on this name, I'll make the change=0A=
s/VM_VFIO_ALLOW_WC/VM_ALLOW_ANY_UNCACHED.=

