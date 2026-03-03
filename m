Return-Path: <kvm+bounces-72521-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CBRjDevXpmnHWgAAu9opvQ
	(envelope-from <kvm+bounces-72521-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 13:45:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F4301EFA94
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 13:45:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B08533030768
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 12:43:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD0FA34D93C;
	Tue,  3 Mar 2026 12:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kUJ0gsUK"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013038.outbound.protection.outlook.com [40.93.201.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF04634D3A1;
	Tue,  3 Mar 2026 12:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772541798; cv=fail; b=KMRYpDfs7Y0TjtbG/p4bQ6xHolzGIubPVJxg7pOicNnqduYrkjhrCK1xktnNr4Cpk4Jh9MuvapWLxs4R/3JtgXYI69aBd3q1faTSoGnoecofk6nJyZIhMyvSUl9VeWiuKLQHh0LrRZ+KqdGErQl454DjDXAp0ZoU9wje4Dsu8jc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772541798; c=relaxed/simple;
	bh=pCodvG6Wz12A13NVRhhPJebRAA5/RTiJYfAF1KSdVSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oVtneyP5Ba4YTQ93Ju/SkGff4HWPjOdTxT0N4oqbusWQba5Digx4DRSXPod6AWigAUaGuYBoUxdNgfhBkpy0OHQjJGfUOU8vq2Mpq0NvM5VTnDBVqM7VA9RJl/C+EywH16QSqop+8GDfQwhXOUqnjvRUeF2GYq8hgsRgI5WWZxI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kUJ0gsUK; arc=fail smtp.client-ip=40.93.201.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ap3K+2iRxgi7ALgrZ18mDJjAUMBQ1M6+RAlhi65ytTUW2w6cfPdY22XO5kJ+25OC37+czV6bGUHgdVpy+fGJOYwrFmA3q1jlh5dTms61Sdi/o7LZGQbNxW0PlhM4C7ayv66iBHfN9AB5C9Cl6TpZfcy47Y2BVCPetooqeeSllJbSej4PbGeTqBTPHB08cAt9ISB1bv60k032RTaToblFehMg0tLzE0CiEQcpE6SNvg0K+1RTl5sLEpnOLLmfmMCxbx9HO+8khmPZLrE4e/63WRapQltvWlMDmAJwCsWM8jn744UFyzWFtKuZ4elFC/cdMLcPPj71vkKs/ldE6HRE5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r5iFR4fsyGrgG+n9F+f2Xti5Hjq4mMnaXvEfbkaEOvQ=;
 b=qIKJQvFoW9QJzy+US31NJKRjS3RaTDOfNrJDjt00IqA+fgwBzQrlo5OyWMnO2FiIyXSGzvzLNVTk8X5HgNyjYgXdN5ZiaKu0t6HZhJ3nIEQXokVOThqtyCna7IlBZZ/PpKz9h5KOr2wC6OD0nr/1kOlpmyEWUzb5DqRMzS6IlpaieRBQJbVTpndaXB3xIJEFN7bIi3byA1G7VxgC52X7L9VP+EGqvZWgPMk0Mz2C79WerAc5bJKpG8nQfPX1Pk3OfVx+9aY5/K5DsIcAt9k2X1rFtULPWhbCGjih5FFl3i+5vanijp3Lwg1hwgnwp6CLqKMfI32LKuEbnpjAh5x6iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5iFR4fsyGrgG+n9F+f2Xti5Hjq4mMnaXvEfbkaEOvQ=;
 b=kUJ0gsUK9WvzakDYopWR/xRzXI7lQeneHkaljdVhsik0s2jJzIW0hvgiQJX15xuyYmMlxsLWGFmdglBIrjOnx5mxBRDzjpu0L37Y1x28dKtZPKhFFXhrRc9X90Wl7oU3njDxv0qgX6n+npgsZsT2bRTCf6yMC11lrjlXcmfj9uMBK4KkQ2MyPuo9YV6WxsKIlLoTxc0vYhEzfrjhaC/l088ykWeq2XiA3RI1xGlJ8PzV9FDqvLUjudztMdCw6GuxKs/qWgrlu6qbTA7kZnGw7oYLvGH+cp65e6Mc1aDuXq5gk54oJstNngfTYZTD8cIujMdA/7d1yhTjDSvO/mBWnw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DM6PR12MB4251.namprd12.prod.outlook.com (2603:10b6:5:21e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 12:43:07 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.022; Tue, 3 Mar 2026
 12:43:07 +0000
Date: Tue, 3 Mar 2026 08:43:06 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: dan.j.williams@intel.com
Cc: Robin Murphy <robin.murphy@arm.com>, Alexey Kardashevskiy <aik@amd.com>,
	x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-pci@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Mike Rapoport <rppt@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Melody Wang <huibo.wang@amd.com>,
	Seongman Lee <augustus92@kaist.ac.kr>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Andi Kleen <ak@linux.intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Denis Efremov <efremov@linux.com>,
	Geliang Tang <geliang@kernel.org>,
	Piotr Gregor <piotrgregor@rsyncme.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Arnd Bergmann <arnd@arndb.de>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Yinghai Lu <yinghai@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Kim Phillips <kim.phillips@amd.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Claire Chang <tientzu@chromium.org>, linux-coco@lists.linux.dev,
	iommu@lists.linux.dev
Subject: Re: [PATCH kernel 4/9] dma/swiotlb: Stop forcing SWIOTLB for TDISP
 devices
Message-ID: <20260303124306.GA1002356@nvidia.com>
References: <20260225053806.3311234-1-aik@amd.com>
 <20260225053806.3311234-5-aik@amd.com>
 <699f238873ae7_1cc5100b6@dwillia2-mobl4.notmuch>
 <04b06a53-769c-44f1-a157-34591b9f8439@arm.com>
 <699f621daab02_2f4a1008f@dwillia2-mobl4.notmuch>
 <20260228002808.GO44359@ziepe.ca>
 <69a622e92cccf_6423c10092@dwillia2-mobl4.notmuch>
 <20260303001911.GA964116@ziepe.ca>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303001911.GA964116@ziepe.ca>
X-ClientProxiedBy: BL1PR13CA0158.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::13) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DM6PR12MB4251:EE_
X-MS-Office365-Filtering-Correlation-Id: c1860a19-3477-4d94-c45e-08de79226b72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	Onq82mpx1AeeBZR3k+9GjAkOZhv+/1UbFF/+ukqzykuxKLAr1xHA0IGNBk5D3u94NoYstBaKfpanCeAj/t88foiU/X+ST50sDTt5h2HS5HRoLGdSvC+6Q4b99jcaCIeRDJEwljRoNopDLvRutYRtZYJppPCXECyGWvvsOJcFvNHk22D8/rsNQYqCSVuo/uELA5iuv+weoB7bAr/SAUwFATnmRyT7Y6xCy6RElJ02ZRLlLM+YhjyoNbwXJa6xVCzFrxhZlaE90+7Jh2VAs9Su9MupX8xGzqMD1fiiL2seaPbRb8Br3wKvHiBZdGJXZTsRZnHMP76210vm1/dPsvL9YblP0/oMmkp+OVbJ6TKUfIJ9/suLP7bh2auSAjOxszKV+MWqH39udYIODzH8Rj9JVvb7V5DBfzAtcrlYvpLgyVfl9er0n4exg+ZdWV3Is/LACNuKRnFFOJ3V9RqoAq9/8TwWtOsvdP46gzHZXhxEOpmXJEg1Yxlgs6dj/3G9LWFLzvQ4G2fr7nDEyBkMnPyQe+6fp6VJrkTX+3eNoWwzHsBXwMXuKSL1cY4bxwLx37QDZ3URz5PrhSDaIQqrFM4yTD9/qEadoGBCL2dE6D9QuAYEVnyabBjqc4UHgbm+w/cAF4We4BCGFb7eGO5XgGVGNTz+9d4FtGovUpyUli3A0ZM9b5L1MAt720Nocu+TZv3J9KVYIF7PkrGmtAdepHsHRQIPzb6dQWQt4F0P5Xq5zxE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7a1E45o0/p6TnHClfQ1x1vzVhOG2Rihj0R18O8pWwN5j0pSVfn8uVUInJUuW?=
 =?us-ascii?Q?GNEIegvvdFFxOzOuoIiN9osQgIH7h0WlSlrSUleP0HxwdeXkC/sSWXkemDGI?=
 =?us-ascii?Q?azJ3ouG6RhIhswxenKmSTlHKxafIFYR1va5YGnWv1dm+9FfrI1b/E90q/g6W?=
 =?us-ascii?Q?EtDBTqP645oVlv6He8s5fxuWQsZI/YOAOz3ET4tue37Awt/nuSm2Bed3tYdC?=
 =?us-ascii?Q?LokeaGQSgTB66oaqWRZ9lEqpqMTVuRF5vNpDpJfnOkk7cIx/b2fjLd/A65oL?=
 =?us-ascii?Q?pviENuH7kJMTGtwIk1KUsWT/3cVzxbnLJE+gpvOUbs3zx8V4iajR1cU/5gKz?=
 =?us-ascii?Q?MzVOaA7x7jxtTXbzBzpGWj/oXocHEn3arOA3aQktX8HqDXLYSnogWfpOdSJ9?=
 =?us-ascii?Q?KHTCFQEdVlDJiwcJeoMPGEU6dRnJWzxa3c4wDB6sqJmk+daThvomnOUZYCAh?=
 =?us-ascii?Q?sM1I0BvHg+bOADyfmqDxYAVtZ+18p3wjG9RCQC3pPKSo3mVbZQWS3BI2PU7S?=
 =?us-ascii?Q?W59T3UOU5hzlpTtODxr7HrcXS5hEyEnaxWp12Ue+kZ4TK81eODqHqcNTOXcS?=
 =?us-ascii?Q?HycPFKCUrdhjI7mfpD5abRCpZD9DFrzjNaJjqauC/2OMNxuEFcPuyHLJfTcO?=
 =?us-ascii?Q?i1UHV4lPg1+eivSSVoQw98MR9/creSnGKzKnMubRjyojOGWrpX8L0d0UjNnO?=
 =?us-ascii?Q?uJUuJ7poAPcFtrVI77IKc/Iln2S7Ulq4x9RNVRLykeN+EZVQ+CQsRTSdn8t4?=
 =?us-ascii?Q?2p/QAk52z4q30V+bL7q2LMW554kCxeGikzSn+//m9FNi8VreFy3f31VEeqiN?=
 =?us-ascii?Q?H7LaYuNIHacpQ6cEiU0oYzPpKgw5wMpHaYYjfeK2p6TAtbHI8YuOeNmyp3pw?=
 =?us-ascii?Q?2T/8hujaihlfRQKXvrfwEwHNk31FOzw8bAp67Sv0vi4juMliOiRhGvTcIiWB?=
 =?us-ascii?Q?iqN98RHlFwjV3GOuuVGlWeUdycAfOTIqzJDXjLh1g181iVrPPvOxBaoGSdjo?=
 =?us-ascii?Q?AYZDdcpZxIVljPB+Zpq2gh+SPN3cYaYHfHswkSKPpFAoQKlw3zohq0kEmJ1k?=
 =?us-ascii?Q?O18SSfyx2rZyqH6YysxqiSof8bJHYa0yoyyQUx4ZSJJXfhugsvnOLEzOlwdf?=
 =?us-ascii?Q?8pkm+dSubJRoh8DxLuwtx1KH/Hn6HCziWhTGQrRLA8XNnX/mnc4u7k4naXtr?=
 =?us-ascii?Q?HopJP3m988+i+o1C1RtpiMQwCddRMcbnV3YTYvFnmfuXeMStvGF213VL/Zgj?=
 =?us-ascii?Q?gZkGJM+vcalOn/HCN6O18/draQqBt4qbo3RDVNZgK2bk7lhGji+yEurCeB8P?=
 =?us-ascii?Q?fgjyt+mrEmQ/nSh+M+N9rEo49VOXuvrJOQDRd5ytkJa+yIYLuIZMzLDLR/mm?=
 =?us-ascii?Q?rFvttKJ7RL7GqCryNE0Jzluf3ECLQM8pVcU4wjorsIL6dNMS6V6mIljcCi01?=
 =?us-ascii?Q?Z7Hgi0aXQw1znEHQ5o/Jkm22dR/ckMx2wYUkWA1xIsiyxNsc/duuczfLxWpV?=
 =?us-ascii?Q?WBvnXiBeYb3g4OuXGfmAyTohy3mqoxe9PxYB8AH6oucpf6F5JZhFeF48Wai1?=
 =?us-ascii?Q?4mvCR0wmX/Thev7K2OieKZ4M8XevAvTFtszljaf/gqiseVaCNN40MAiZQAZs?=
 =?us-ascii?Q?ioEsmOFtrm1J3mWPxZnJGotZ698UtJJzP1IDCgMavOIVdquDgWJz+PPbvNSc?=
 =?us-ascii?Q?oG864O/FEUYh+S6jD5B5RwxZA7wokdfLjzIkFYVboZPdQz8av/bSgEKwgh0k?=
 =?us-ascii?Q?bfgiGVS44g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1860a19-3477-4d94-c45e-08de79226b72
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 12:43:07.5558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fJN4OtgOObi85GYAcWoJr6NffFX7hEh/lwj90IzojheEgPpJF5NnJiSW6Xwkp/yR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4251
X-Rspamd-Queue-Id: 4F4301EFA94
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72521-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@nvidia.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_GT_50(0.00)[58];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,nvidia.com:mid,Nvidia.com:dkim]
X-Rspamd-Action: no action

On Mon, Mar 02, 2026 at 08:19:11PM -0400, Jason Gunthorpe wrote:
> > Oh, I thought SEV-TIO had trouble with this, if this is indeed the case,
> > great, ignore my first comment.
> 
> Alexey?
> 
> I think it is really important that shared mappings continue to be
> reachable by TDISP device.

I think Alexey has clarified this in the other thread, and probably
AMD has some work to do here.

The issue is AMD does not have seperate address spaces for
shared/private like ARM does, instead it relies on a C bit in the *PTE*
to determine shared/private.

The S2 IOMMU page table *does* have the full mapping of all shared &
private pages but the HW requires a matching C bit to permit access.

If there is a S1 IOMMU then the IOPTEs of the VM can provide the C
bit, so no problem.

If there is no S1 then the sDTE of the hypervisor controls the C bit,
and it sounds like currently AMD sets this globally which effectively
locks TDISP RUN devices to *only* access private memory.

I suspect AMD needs to use their vTOM feature to allow shared memory
to remain available to TDISP RUN with a high/low address split.

Alexey, did I capture this properly?

Jason

