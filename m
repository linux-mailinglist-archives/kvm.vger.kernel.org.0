Return-Path: <kvm+bounces-20188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 72E30911673
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 01:11:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C5733B21CCA
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 23:11:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E07E514388C;
	Thu, 20 Jun 2024 23:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uczZss8T"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DBF82D83;
	Thu, 20 Jun 2024 23:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718925100; cv=fail; b=IXipdjCF9T2Nm+mOhoUPps6thxyNLRP4Bjk4Li4CMqac3bHMEZei8Clha4HWoDoS+sgZEwUYXUIS/vI2iYfrtOT1EwkgAQ9pZ0bm5RAzmdNic9Ec5EsX6CquX04XiLsvSKZmY510yAjmMoQBwyJlut4XnshA0FQmvnIGGS4sEwA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718925100; c=relaxed/simple;
	bh=en88DzFweWVf1WNwRMTV09u1VsCl/1qH/1V1NlJGb+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bmdwIAsQawinWi6Nr3fW4JYT/5xpetLTSHASg+AHzOzKjSLygihHCkv1PhD/bjOZKFCeWecJDSz7Ab7iVd57hOs01hWECM/KQntXtauLHn7hzX/B0FxJbWxlArxJx+DKYhtAfCa5BqF8Tga5MxhmnNmVVv+nnTjbJ4nLKwktqBA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uczZss8T; arc=fail smtp.client-ip=40.107.93.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QRjT4ZDifkjeOg4cIWGulk/bN7QXr5B7zRBlC8DpKUB86XrSdXnozOU2rymgFQY77HPRPZinQ7Erwy1poF4BdAIr5KHBYOAF+BLTEokaVlrYJ2XtoB9Z2CVyZfxL7XlLtBALkXvfN2jGbpzuPW74zLuUgaeUwLl7acQ+ZDfhQIDW9+4wGFYAwvwnmyWlzECg7fB8JD4qRjek6JpM5wJ+uVmUpkLWoY0ZOXw/Ybs41HFZ52r4i/ss/7a+OYPKwFMNsu7+Suux4fFvcQDuIgssEbKehkn0Qb4A4acXDtdgrzQNkwjOl2I4coj1/EQ8af444O7Id2u6XkQBsLIVB7d5yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3QUG8o2x4KoTXZg+DxKhZB8v2C0KFM98ikBqhwz+O3A=;
 b=XyxdwzbDZnCIOc+fdbYfzzl59YB6XnJWSXrWrogLRgbq9E5mqSAwA+wfgZpOjatwV1tiBfi5yF9b/nUe2QIWT7fPXBvEULae/P7m3Y0IqcB5SBDIGZfnwcLD+/4jn7yttQTTb0+C59OO/TdurOX8kWpQW/zaAEbxFNtekn+AYQsEBO9H+pMIJuoF95gUA+0n5Il1XCmLjlfxNRchWz6fB4kCOf0l2SW+UWEvSIMBOnQ4qC+tc4i8duNbXhy6+XDUfG7C5ByfBmUqovaCPzOdXYhyRGR2Rv7Fkj6JO4cp78yhwvcwJWTP2UzPtXgC/1nAB9EBH6sGqWzG06dNPI8e8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3QUG8o2x4KoTXZg+DxKhZB8v2C0KFM98ikBqhwz+O3A=;
 b=uczZss8T+uRawr8ko3cJCctvQlfadKOm1C/5tRnQc2cT0/0o2ON5HAKoipZy7BCAC/2ljtQeY4+aHYALdEmfsZa7uS2Eh/OdzI3LCyMAlViyFDpFplF6lM2urNeid7D0Nz+ZdOiE4lCX2NzYOwRxy9RY5faBzo2E42v6JcNu/0pCf2nttrXNUU0KUo8wobi38z4wst7RmhozgMme693/BZsAJsCZm8mkyGjZW/Rhsuk3ANyGL7AZ0JQqmWw0Ghx7HabLibeUIp90ASfyO0OOWnTdwm5r7gjpJoA4IqKeJ97YmjyMcs6n6j43q09sL5vbOIAjeroao14ePjKlDlmK+A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH7PR12MB6884.namprd12.prod.outlook.com (2603:10b6:510:1ba::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Thu, 20 Jun
 2024 23:11:35 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%5]) with mapi id 15.20.7677.030; Thu, 20 Jun 2024
 23:11:35 +0000
Date: Thu, 20 Jun 2024 20:11:33 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>,
	Christoph Hellwig <hch@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Elliot Berman <quic_eberman@quicinc.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>, Matthew Wilcox <willy@infradead.org>,
	maz@kernel.org, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH RFC 0/5] mm/gup: Introduce exclusive GUP pinning
Message-ID: <20240620231133.GN2494510@nvidia.com>
References: <20240619115135.GE2494510@nvidia.com>
 <ZnOsAEV3GycCcqSX@infradead.org>
 <CA+EHjTxaCxibvGOMPk9Oj5TfQV3J3ZLwXk83oVHuwf8H0Q47sA@mail.gmail.com>
 <20240620135540.GG2494510@nvidia.com>
 <6d7b180a-9f80-43a4-a4cc-fd79a45d7571@redhat.com>
 <20240620142956.GI2494510@nvidia.com>
 <385a5692-ffc8-455e-b371-0449b828b637@redhat.com>
 <20240620163626.GK2494510@nvidia.com>
 <66a285fc-e54e-4247-8801-e7e17ad795a6@redhat.com>
 <ZnSRZcap1dc2_WBV@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZnSRZcap1dc2_WBV@google.com>
X-ClientProxiedBy: BL0PR0102CA0003.prod.exchangelabs.com
 (2603:10b6:207:18::16) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB6884:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ac95483-86f9-4063-d8bb-08dc917e548a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|7416011|376011|1800799021;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SdVks+SwLVeoLASY8w5wCtzz9wbzqhQzAyHtVO09E8YRRVaRfz0gWT+QeW9U?=
 =?us-ascii?Q?DuspEZavuEKzZfZi4S4sSGbA1ZhDSnfqDXmhGfcnZlxO7Q8vCD/PMcxs0GAT?=
 =?us-ascii?Q?ZrQjGkqPaDhJpuoceYrpMwsiTQUr7BZtBTRBN3x38MkbKUGlcwluVWiF5BdR?=
 =?us-ascii?Q?a2/f7p5P3ccNKH/7c3+sbyY3k8/hxRVvir1JIuSwnw8anpXaxBUPdZUJFBIO?=
 =?us-ascii?Q?XTYKdUvZ9q5awLK4sPA/k+IYB4GDvvOMgrXfVc3DpfUds8Fgy61DBmehKQcS?=
 =?us-ascii?Q?Q6U3yVTlKyMOwSO8oHB3hBbsJD9BcMvEWu6w7AA4RoMhlUscaKyQZxd7MCtm?=
 =?us-ascii?Q?aqcQGCaw5UL3hLbZKSwfCj586DodHiu1si0GAovza0zGSWeg19qioIX32SCr?=
 =?us-ascii?Q?uSwfdLTMxAqXxv9jvjiwq4k62okE+EYwGTdR8DMCgR6u0xejdG4Z/66YhRNU?=
 =?us-ascii?Q?YcWwJelVSbw+e4yWVBryiyKaYhE425fomvuX4aOv3baQwoUJLqFs7QXbNKuA?=
 =?us-ascii?Q?5xcMhciQuMkmtXFL1WwQ8ubsMV29IcahrdYairFukIR7JYLtvfQo9grPKHY8?=
 =?us-ascii?Q?dh1/GdOMlrW+9PEZoJK19N5iYVxCwSjcY2uHsJ1r4Ega9muingpH+LdajYc3?=
 =?us-ascii?Q?k+S4a5ZGdadlmo/+X38u8LFyaB6pcgcFZPA9IjJvx0+VJBg5DIqL+MuI5M6Z?=
 =?us-ascii?Q?RLBw/2EMiRANN5IiGz6rNeAt9nL2PB/SgNrRNFeKACbr/llkMAZSS1ynak+/?=
 =?us-ascii?Q?IRm89C6aE32kE90ltEBq/+HLbl87D7zK/GQWQ8EFQHJFbFdM9A+bogqIFotu?=
 =?us-ascii?Q?LDVH3MVuRNr5Cz1di3mWqae4jRHvpve0r84rTheiyc1HpjLciqpsUWsuzhl4?=
 =?us-ascii?Q?irIzdEs85gwajZ9OTWEpT5oN+O+gVkP0UvdmS/b6Opopo/N5DMGsymCCY5j7?=
 =?us-ascii?Q?vxeYUHpe8HrUJFQFGx1ezYgVpmu9E6HBqNqcfEUCElgqqGXf02LxcBbLZhJx?=
 =?us-ascii?Q?cqa1lGaajfTIlH839CiFrYpn2O7/W/bxcQK71jkngC3ZI/i7z5sm7RiXGr32?=
 =?us-ascii?Q?L/fUSW8kgWwMj2UZ/iTgF2At6ODfKUXlyqfjOR0bQi7fcsujwGe7pK6Wg8PF?=
 =?us-ascii?Q?PAqWxQ3r1mKJ49V56iuW4nuTHQh7EWYLBMy35OdmcU1rKMucbiDxm7Oeep3B?=
 =?us-ascii?Q?Uaog1YNK2sPngUYubKhVi5Rq4gJSvpNmWiZzacHAnzD4mNX1f8KKG+IoTjPl?=
 =?us-ascii?Q?8gw1TMFQsDQof2p49OKXGMECtO70gwJC21LVdzeBffa1fLtIp6baNyLRAgIT?=
 =?us-ascii?Q?qSty4ma6uDgVT2A7fRqdxsNE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(7416011)(376011)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LglOt4g2lcKNtM7NlWhPnlnwQNF7c0nRIKrww5oWc37bxmhZWRmRFes6VDOD?=
 =?us-ascii?Q?6wi57wa0J06MlI/jAvURzmS1fZl3+p01Of1Cf9HJVsw1iZr4VlMot1KjgWWT?=
 =?us-ascii?Q?N1r5Q5inrJVy5zLxL/L9sS6oTJYNjT3N6USN3bdfe02XMHvEN7myeAXaH9U4?=
 =?us-ascii?Q?OpBskrjn5lyLPmFh7o0BTMs6mq2QBU6JHxtzPp1ykRz0H+kaT/Hyiq5vmATL?=
 =?us-ascii?Q?BXtJqEkBlqWoIij47plIPXRAg00u9N74fDyxUE/LdP/8e16OJBrIzLLS64TT?=
 =?us-ascii?Q?nkkrXIoaVgWM2U75QBZY32vsk1L23W9QiU1WOZSw9rTs26oTzChUTd24lG1h?=
 =?us-ascii?Q?1J0VsME5z5MLlURVBOVTlWohZy/SmcpcHRJrOdnzvGdrwVyMQXMpbHQXoZhk?=
 =?us-ascii?Q?oRAdyaPTTxosDpiDlYCyg2ilcX93u97bThzr4N216kbL8ywes8styz9oJd7u?=
 =?us-ascii?Q?gtxSRbmbXCF10vUjMCtvtwYuSG2pgcOqXJJhlHaOGrzUeohTEnCbyXlLEdSl?=
 =?us-ascii?Q?4WJw1+Ss19XO5VmHYEq1AtqzKouqe3qzhMUZrVmOHRyrsQ672eruT4PJMtNs?=
 =?us-ascii?Q?s+FZLZJXXUYDuMsiWnd0nEUHXP21JiM3U1aYZ4gx6LZ6e/z0LYbBDH1DmPhT?=
 =?us-ascii?Q?fdPIlTEMNfev8E07iX9Z5VYCuh8FDfxVJRN1Kf4LM8wIfcP8343QV4h4tuI1?=
 =?us-ascii?Q?UlFUkyDC0MPYwiOCNcHNBXzVL5Wph4Ne8TEGHMlMzU59LEAJnJjhafvtuoiV?=
 =?us-ascii?Q?nXSesOGtvZ8KpI2u2TyWHyL5BfucBjZEX/wj8cq/82mOAz16HWawHm8FuPO+?=
 =?us-ascii?Q?TaJepAdxuWxt31er5wUj3asmaFjTJP4cx2rc+Sgzlvww9tQR7bLdjTFUNYIS?=
 =?us-ascii?Q?XLA8koqKtUDsRZS0Y6DF5AQHhjtI6+YNQ48VhhW/pO0T1qViiq43+ml/RoiQ?=
 =?us-ascii?Q?9JkmQLTL6jPHPrD02hXtOGGO7Vr63SFv/ovXP5/BjVg+2hppDvepcfX3Jpst?=
 =?us-ascii?Q?vtt/gYY9ZX4E/IWOl2UOrPFbZHK4+Y5jpDbn/jvKgi+J7dBqJzy+epLbpcBy?=
 =?us-ascii?Q?7x+LHmMqut7ej7ZuF6o3sarLdyZZqCT9P759ZdP4ksyyHi3ZWOnnS6uH2jWG?=
 =?us-ascii?Q?rjqPydDzY8TV+fZYdGW5stUQtVWRfItuo1vb1eeMU9/Hm+fArfUwmFgetn87?=
 =?us-ascii?Q?SBU+tn/sGHv3GaRKrPPrpapmzHoLwtVmlEkUKKR8WdNBhQEwRnbx+9X/5rOf?=
 =?us-ascii?Q?S2nP4TLQV/QT4awo+1FcymPxrorXpGoVug87vEDatOAuciYyGYZKGxTYMmuo?=
 =?us-ascii?Q?iAxyHQwVJSoZFUiWsVieQNDXpPEexEezH4nD47FiO+5n5MfQbP6OBcjUMHab?=
 =?us-ascii?Q?icaBmVI6J7dEFYQRHt8sKolWo046F7vdaDdydncsQaGKAfuX0Zn6SLqXIDM8?=
 =?us-ascii?Q?ODMJig5SPuz9tMRxQHRmxHkh7/3voUjfrgU8tP7WiCBa/NZ+EQi58BZ1n7Yp?=
 =?us-ascii?Q?FEojou97kHCF+3tlbNxXgKRoXp0iASLPZEalrBDc8/nnxOeh0mgZfJFphJiy?=
 =?us-ascii?Q?MwyOyjaowwRDIIBCjMU5IgdGYBbeUqJ2MIfinT14?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ac95483-86f9-4063-d8bb-08dc917e548a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 23:11:35.1123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 57BSaO1vHHngyLxtjzla3Nanxt90n2fBr4w5ZEfCdRxnOZA2oJ/fiz6Z35O7VLuh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6884

On Thu, Jun 20, 2024 at 01:30:29PM -0700, Sean Christopherson wrote:
> I.e. except for blatant bugs, e.g. use-after-free, we need to be able to guarantee
> with 100% accuracy that there are no outstanding mappings when converting a page
> from shared=>private.  Crossing our fingers and hoping that short-term GUP will
> have gone away isn't enough.

To be clear it is not crossing fingers. If the page refcount is 0 then
there are no references to that memory anywhere at all. It is 100%
certain.

It may take time to reach zero, but when it does it is safe.

Many things rely on this property, including FSDAX.

> For non-CoCo VMs, I expect we'll want to be much more permissive, but I think
> they'll be a complete non-issue because there is no shared vs. private to worry
> about.  We can simply allow any and all userspace mappings for guest_memfd that is
> attached to a "regular" VM, because a misbehaving userspace only loses whatever
> hardening (or other benefits) was being provided by using guest_memfd.  I.e. the
> kernel and system at-large isn't at risk.

It does seem to me like guest_memfd should really focus on the private
aspect.

If we need normal memfd enhancements of some kind to work better with
KVM then that may be a better option than turning guest_memfd into
memfd.

Jason

