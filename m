Return-Path: <kvm+bounces-72322-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aPCJDiGQpGnZkQUAu9opvQ
	(envelope-from <kvm+bounces-72322-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 01 Mar 2026 20:14:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 94B751D1364
	for <lists+kvm@lfdr.de>; Sun, 01 Mar 2026 20:14:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 85DFA301828C
	for <lists+kvm@lfdr.de>; Sun,  1 Mar 2026 19:14:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BE05337B8F;
	Sun,  1 Mar 2026 19:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RkI3T2e+"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013038.outbound.protection.outlook.com [40.93.201.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF71311964;
	Sun,  1 Mar 2026 19:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772392463; cv=fail; b=olBoqQMNxBu0Oy4/PGo5esHysTHph/RLgymcRhUBpF/V2tV2Si0uvIpb7ZDIfsR3ZpQ501F1yIrATAyCxHMeG5oOl7qtzBAP8OGefnDmIZq3EwB5GKQ0cdlUfPw7vNSrArTciSGVOmRXhrtP6hAs/RXFJj9hCv8zH38h4vAwOZc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772392463; c=relaxed/simple;
	bh=9KRZ6R1Gz/JdZ5gssYDevSbB1/ZIXnYAmzONC+5VMn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BLPyUUorwgyBtNYG73LVn8VCT/pIYHEaMh06ZjM9UohIVtafFV3NMqxFVHbDVFFJdQtT1uT4C5+paq0IqAV733p3vNcnaeMIIIf/nd+TRE6LA7N2Vh5tM5RBGpBK+R/acwnHd+2OD4stdnwk/gZa/MlmMS1/btiayz3zVOIMFFU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RkI3T2e+; arc=fail smtp.client-ip=40.93.201.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yMt0Af2QUM4o0e+hdpuAWvvrsNcBRoXQNzh1m168BDrjS2WxaJhSDadtoYAdUAofOXrT/0iVOlA8dXOjjKJqYcyUACZ1oot044B4MXARkJmy58v9834PSxvoZ/qeHOlJ0JL+EM9jTSjSdrUnUM+dRxOZnBnpAzhsi+WnBhTwoN1cM1HMzf6BJO+KBt7dD2aB2Y0Uk2WgpH88BO92YlnjQ5SZhlWmd/bTSc0Ut+nia3ZPrVRxx3rtjgKYefIY12Gx0KWm7Gi+JbrCE5KDXBcpkNtVfyFVqk715F9gByIg/tKTFCuFb8j7IGS765m/3D6PqUU6T/EfKapCHka+83PMVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RPyjmujpofD3jpHT46935+mfJWcwox3E0goTpqhU++o=;
 b=HJ2Far3pAB1sJZo7x5WbHQLVvxYWV2hayhA5uO+aJfVKIqhp49Vo4fYB8O0EUvNwVLggT2uBRZTZ0IQXaUDGrxxReAg8CkmCKRRGpaRMZIUNQh3ORhSHPSAXulkbcnrEgF2mxZ616Z9TNJIWP+NMTz6zbuL7NAxfFpfgXTJ3fZJaVRTGLrY61w0Sb1fP+PvLq9Z+gNtBDUVsDWDe0a0RyIRhqs3G+eVUVGZ16kdbxwcfMYOS7s71nV9Zu2f2T6AKcufUl1rXVMeMD0zLcDUiKz+2+sOiqDeeOuLEiZpzPfydHRyhkbEZh8L4AfvZpNRrGEJvVP7UrJpPrI5UaGjwyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RPyjmujpofD3jpHT46935+mfJWcwox3E0goTpqhU++o=;
 b=RkI3T2e+VSLSnhxcevE2cipJQNzg5Iz2RBE5hykMFm5yeNT00gdy+gkFTFWcU+aPDiOFCpGPTAc9Pb/+zB9VGEkbIwckxhTYlZqKNQxydSKfuPYFGZZm6ckRREyf5joI5goSU6/DZ5olAHePf1DrGOqHB4B7KEvO2BdNr0C3gqo9BG3Tsd2BdKNhyLH/TFSR3Jdp6qDCwDulHs4RwzJXP44j9g5XCMnAH5+a94pkl9EAbVCYK+uDrLOZO4l5rDVGEwJad2+KCOoSAieJJKn78YtR5tkiplbsH+WrWJLaSvaXjxm60ANfY6aEVE7SLMmF7IJCdDyhsBwCAp0TI6qOgg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by BL3PR12MB6524.namprd12.prod.outlook.com (2603:10b6:208:38c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.18; Sun, 1 Mar
 2026 19:14:16 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.014; Sun, 1 Mar 2026
 19:14:16 +0000
Date: Sun, 1 Mar 2026 15:14:14 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex@shazbot.org>
Cc: David Matlack <dmatlack@google.com>, Bjorn Helgaas <helgaas@kernel.org>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org,
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Lukas Wunner <lukas@wunner.de>,
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Tomita Moeko <tomitamoeko@gmail.com>,
	Vipin Sharma <vipinsh@google.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
Message-ID: <20260301191414.GO5933@nvidia.com>
References: <20260129212510.967611-3-dmatlack@google.com>
 <20260225224651.GA3711085@bhelgaas>
 <aZ-TrC8P0tLYhxXO@google.com>
 <20260227093233.45891424@shazbot.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227093233.45891424@shazbot.org>
X-ClientProxiedBy: BL1PR13CA0220.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::15) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|BL3PR12MB6524:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a50b0d9-c18f-4659-acf4-08de77c6bad3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	teIeqMr5ernaSH2fpQcgAeRIaC2NQL1PRAxoMrnOXEiWeQj8GfAu5xXVTUxWjVJEF6eFaPEHwfoXosVmpRSL7ItlwyJLWlRPOdnW2wKmpi3c9/aX4I74s9qxCr4UA/BZvDchTu2SYojG8X+8HLrD2PILGt/gSx88VyHbl6xTpzW6/X5RmMf+EUh5J7s1hB+HtgyOK6vdOB7QnXxvCpgDimaf1ITaDkGrTE4khEH1xcTgMTeWPHV+peY0md3Nmdld57pt4MXxXV/hwNQvaByjStWYiBAcsxB2ODygEJYxwxwxmJbxP8oOTysMCoPo3RSmiMAs+tjbXrOj4U0H2sPcCJ8ICpkj3N2vxPOOQ+akpm+brPunrmh5frffsFqm24H3P3CGDc6t8PTrXH7SSti9bTXDeAQJ8ByhIht2n6D18UVOWkzSdrEE1zuJ0Z+hzB7WUTIYYHdG7p0fXukVE8q1YZXjW7ycUx7Hqy6sx5joyWJZZLzsQBt1Kkt6v+dXGEKgEw6Cgg0mePOqJlLpROpIz9WzkCfmtRU4pVjFcMz37/EsQjZxv4hWTowyGM7IGFusexygn1DqHkEpFtyZBGU9Z/Hkr0BjfDRqN9H48DsAlSXwQJ5RsYCZTY8WmyFOiEHe60P0PuWIs+AL70PGh5EgKUDOFzueYQky7qhyfiv0SfkxkItA/QaxFkG82JtE5euNYyV65NPqWCj9BraEigWHmBhYFL1Xc1W6aYraQN/wYb4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QbKAD31y4kwpj5brPQL9dAVbpmGVtAEV76bVLe5Nmo6AVXSrZLV+bX2654yZ?=
 =?us-ascii?Q?CQ7o2LLKamIQhba92NQV4UjJiJwphfsl1bRmkDEPPAxdb/FkbMIqanjA9GPs?=
 =?us-ascii?Q?tcYnSZSG7grPQiBPM3D2ne0LfdyTxxDP78V93phvLtfDPVwnG9z/Kevyz/Q8?=
 =?us-ascii?Q?/6Gv6XrRUGSLNDQBigCyAulvnzoc1xiP/o0tGuRgcHr2fP3cUB84jPBhQrCT?=
 =?us-ascii?Q?F2cjxivfd7ZIzn8fsBMShEKDi0Ispemmle3ug93HWWUks03+g/FccH88f03R?=
 =?us-ascii?Q?FzdwfX1UEOjUB0qmGlxP/6Hzx4m8l/rTj/6MILULLrLtRcDa+HhvWvJRqkGt?=
 =?us-ascii?Q?uT8B+V4VjSpIVC4vVH+uBOJ2nEs80zKGLIDFQXy5/Q0IKD9beg9dYhws6vz+?=
 =?us-ascii?Q?TSIX1A+LI5JKd0pLvUPsPLbAQonORUaYZfWMlOGirU0Ye1ClfVGOmBpFZVq6?=
 =?us-ascii?Q?9NTq06Ty/z3LZhsBapFuZ/4NNMeVomzXzY0tJxV5xo2LMjz9FQKdgwnvvygQ?=
 =?us-ascii?Q?THn5+619imvJqH0pKVGFBez4nk04qeb7SIFBeUfNA+jv01FmqidhRmJdIy0f?=
 =?us-ascii?Q?CP5NWzYhcu0bKs+mD/Ljzg+ovToMlWmobhXFjX/k8lW/vwnvc+ep/FjQItkO?=
 =?us-ascii?Q?zGr8nhnavGdKBMgBGYpccWQrksmuHshvSSCjUqn3Jy7IphGI0a+vwpG2e1I0?=
 =?us-ascii?Q?qY2k3OocEjshSVGY6fog77JYAH9lWehi98J90zfZz2XfL2Y5t74zDWqur+bd?=
 =?us-ascii?Q?sJXbla7BD4den6QGWFecjt+Uf8ywnz51ouh6bqWYG8F7h4g65c+2NKvis9uX?=
 =?us-ascii?Q?U73RierkyFXx14Js5HkbiZu12Zlv3DgA0bilhMtM+EanxfIJ2jaw7kNiB5tb?=
 =?us-ascii?Q?Qbp0SDXabBy7AQo0gfKmGZGb34gIqHPOBwL5vgCGFgHjwBDOfEk3QBJoH5wh?=
 =?us-ascii?Q?nTOuCr4kDbLvuPX+jaLIc4vP2rUzTm60KvnsDv10tCrWZd0oeH1eb6G9lBQJ?=
 =?us-ascii?Q?p1nWsJwCUai9WqrwENt7Mt+/19KgmqCHhlYDSdP27QZZu0IOEDvtLem/QoaY?=
 =?us-ascii?Q?lLYE02tcbjQqZ4MZ+/aSVd4db/gy59T8lz5820omgNfD9isi0tMhY/tMQm8f?=
 =?us-ascii?Q?aJWYrEVHUKVzSPq6yZcc2fbzGup0X7s7DroNjNF3e93r/67CMVvxyQsEzYYv?=
 =?us-ascii?Q?d6p8wvB5fWVIYC25vssluW+rQgO3hFWK4SLayhhiucik46BPqsSbqfrJwNnc?=
 =?us-ascii?Q?+d2WaDIpQ6hLhvh/Ersd68msr9XTPcHZ/Ln72C2qRbt+zpkdZDlAR8LKLe1e?=
 =?us-ascii?Q?kZdLtp4uJop6CzVhcWKza/xrBz61jPfdWkaV/Ai5Vs3KdrzxTRAcNyFFEX+r?=
 =?us-ascii?Q?BtAY+bvktx6mc8ZfHFiJJpvedSscVhasg6EBSp0A6c2pAM2Uvt4OvL9hY+Ko?=
 =?us-ascii?Q?DGgIwIL27f74vDARJMDu3tZmaruK1zbW4gq3sKs31w+nvKuBwyPKjsIUuISd?=
 =?us-ascii?Q?89rn+aEQZfaCygP/btdnlnKgrTY2ohRWKWXGeKwRP7GWcXTGSuI6UklcaIlT?=
 =?us-ascii?Q?ebm9a9Y7jAP/dKew7dCzOX4r2L6RvBm30nfv4U5UMOORtG3h8N4jhjRxNz2/?=
 =?us-ascii?Q?vf8z8SSB2uELi6VRh9l5fsKfrJRVebSm0oL5FG7HtZuF7XuSd+YBdP0Vh6JZ?=
 =?us-ascii?Q?bvwbNev3UStQAWlp2LR/Neu0/nohE1dP92sLIHexoJVrHNfs6w+nSdsEHHCt?=
 =?us-ascii?Q?fOLVrxylGg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a50b0d9-c18f-4659-acf4-08de77c6bad3
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2026 19:14:15.7689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z5kM8zkpqi0F7rTNdLz2qXNc7yyQjgmnTqqRoL4UcuNovvqfdmAYDDOjiQOZvzR1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6524
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[google.com,kernel.org,nvidia.com,amazon.com,fb.com,linux-foundation.org,linux.microsoft.com,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	TAGGED_FROM(0.00)[bounces-72322-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@nvidia.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,Nvidia.com:dkim,nvidia.com:mid]
X-Rspamd-Queue-Id: 94B751D1364
X-Rspamd-Action: no action

On Fri, Feb 27, 2026 at 09:32:33AM -0700, Alex Williamson wrote:
> On Thu, 26 Feb 2026 00:28:28 +0000
> David Matlack <dmatlack@google.com> wrote:
> > > > +static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
> > > > +{
> > > > +	struct pci_dev *dev = NULL;
> > > > +	int max_nr_devices = 0;
> > > > +	struct pci_ser *ser;
> > > > +	unsigned long size;
> > > > +
> > > > +	for_each_pci_dev(dev)
> > > > +		max_nr_devices++;  
> > > 
> > > How is this protected against hotplug?  
> > 
> > Pranjal raised this as well. Here was my reply:
> > 
> > .  Yes, it's possible to run out space to preserve devices if devices are
> > .  hot-plugged and then preserved. But I think it's better to defer
> > .  handling such a use-case exists (unless you see an obvious simple
> > .  solution). So far I am not seeing preserving hot-plugged devices
> > .  across Live Update as a high priority use-case to support.
> > 
> > I am going to add a comment here in the next revision to clarify that.
> > I will also add a comment clarifying why this code doesn't bother to
> > account for VFs created after this call (preserving VFs are explicitly
> > disallowed to be preserved in this patch since they require additional
> > support).
> 
> TBH, without SR-IOV support and some examples of in-kernel PF
> preservation in support of vfio-pci VFs, it seems like this only
> supports a very niche use case. 

Well, this is a super complex problem overall and it has to start
someplace digestible. There are real use cases of PF only devices,
like GPUs for example, where this is entirely sufficient even without
SRIOV support.

I expect a long trickle of series building on an enhacing this
mechanism one brick at a time.

> I expect the majority of vfio-pci devices are VFs and I don't think
> we want to present a solution where the requirement is to move the
> PF driver to userspace.  

Well, I do, and am strongly advocating for this. As all these series
show supporting live update in a kernel driver is fiendishly complex
and most kernel drivers do more than just some bare minimum to operate
a PF for SRIOV.

Given we already have PF drivers in userspace and that is working
well, lets start there. If people really want to tackle the nasty
problems of a kernel side PF driver then they can go do that as a
followup.

> It's not clear, for example, how we can have vfio-pci variant
> drivers relying on in-kernel channels to PF drivers to support
> migration in this model.  Thanks,

Probably not without tremendous work to make the PF driver side
kexecable.

The initial use cases for this don't include VFIO migration, I think
you could say people are interested in this significantly because VFIO
migration isn't viable in the devices they want to use..

Sure it would be nice, but again, lets focus on the basic simple
cases, nothing precludes building more and more complexity into the
kernel to preserve more and more state across the kexec down the road.

Jason

