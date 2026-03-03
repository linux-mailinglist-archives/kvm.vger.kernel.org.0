Return-Path: <kvm+bounces-72603-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CAuPOiNOp2nKggAAu9opvQ
	(envelope-from <kvm+bounces-72603-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 22:09:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 86C1D1F7346
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 22:09:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7F2D73090D3F
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 21:07:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 759FF26FA5A;
	Tue,  3 Mar 2026 21:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WpfoZ99p"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010030.outbound.protection.outlook.com [52.101.201.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D7F381B11;
	Tue,  3 Mar 2026 21:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772572067; cv=fail; b=KM6sPpV3/wLLRW1sFyg/biDDbE9mqugiYyhwnGqED4Vl7LXck6myLHoucB09F5jBTKYQjueJaerDTou6dsoogAAHct9HSjkZ8sHw2yGXTs6BQlYw4HM3XKrpDgr0C+bZbkvy3E3OdsPZ3aclJflfz+rzGCUzryUUFKj2zhQguL8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772572067; c=relaxed/simple;
	bh=YRyy1ie/F5bjSngml4vZfKUAoC45awNXrJ97LzfxJgY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FdnGQib+UhH2l7RPknLEaE6N9I/vqCCOnlJNxIKvC9csXeEJrTXyXS+d314esjlpTK009YtjTpOvyq8M2dWvM7Wk8Dyth2UQysB8URsxILsvPPMHOzbnMtP+EHCgf/5UM0nExU9Sbx3otwCOIQAkZTO3G77QwJz6z5gjJVxGP0M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WpfoZ99p; arc=fail smtp.client-ip=52.101.201.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xp9xCQAKWMwB1OW3SPM9ecm08trc03TalRQ4OMTknF3DkVnqVDtEPGRoBdX6ytUgrfxxdyjN9EWeMsZGdXXhvb+e5laiHYplZTQe8omzFMyvQDNfmDuQJnu7daFlBXnAAovdk7UsiEE7JK7zFMSceS6csBUHIDEpGFcjgNcxEcS7b6/mFC99+TurRvFbRRKmdyEyNJz62p1SxW5fCuzKKY1EgBWnlRnVrKdeWeb0xFpNgNXQOkocel0YnzOMKeux+/n3y9b/f/OpWqB2yxkmOhhpEMCP9B4UkcdYoQqtRZf4ovlkJWyf4iN8qv8XyN0GQXMnrMm/tzCsxbDWLN1zDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1int46pg7/SmrP32nI37fl+pb2zItb6909bFbhtIHeg=;
 b=sJbAL+zb9fs61T2vmPIxjioxDekv3M6V/80erfAzzFhU3V9R5VHXaWDieIuSgenIB0FBeqYXUBFRtsOgtZbivsCPjYEbzFdt05icptSD12UdLgtIfMQz5Rk9dJEaZil7NvM+s84OHalXaWNKDQR2WRSHmVrUXTTh0T9rKLJ36jW4T9Mwv1A2/kOhkgFECilyR+NYHxOY2R2uONPcJatkgbF9fhDjUaueuOM6eYu83EJLgsdOVdz5MOjO8v/Rgt0dWTnDrZgEewaEYzNeAscU+wnLHSgrJ30XF6kJzmA+RiqjsiTCBtkwcAdJ0sLmykw20lJIMjS2A+eIKyZpvEPtqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1int46pg7/SmrP32nI37fl+pb2zItb6909bFbhtIHeg=;
 b=WpfoZ99p1s0bkiLsY6M1yO3HvE0pQwAIOe9aaE2BscMUDJP3FLv8nwp6bby61S7wATEcYFjRXwOr7hiXT+N11KhvwPW+4MnZwBHXOhAHPRRRdbHTm0QCakA554sKNRpUtYri5v4v3qxU7d2gi3haOE2VvyX0tlNYppxXVyoT+pumdCTVgJ/Q7tqdZLXwDdErKSutpZzNgU7683rVBP67a4C7tcCQq+ziEAvD71nS3i7a9wYWndIcwAoMmluTtwe2ICJ7LR+rBGk//O5HRlejiaZhR/SzTkCfcl4kfdydVZQ3VKuwdOM7/dru3Cl13jw3ycU3fux/oSZLXkR+yq8Zew==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SN7PR12MB8004.namprd12.prod.outlook.com (2603:10b6:806:341::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 21:07:41 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.022; Tue, 3 Mar 2026
 21:07:34 +0000
Date: Tue, 3 Mar 2026 17:07:33 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex@shazbot.org>
Cc: David Matlack <dmatlack@google.com>,
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
Subject: Re: [PATCH v2 07/22] vfio/pci: Notify PCI subsystem about devices
 preserved across Live Update
Message-ID: <20260303210733.GG972761@nvidia.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-8-dmatlack@google.com>
 <20260226160353.6f3371bc@shazbot.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226160353.6f3371bc@shazbot.org>
X-ClientProxiedBy: BLAPR05CA0014.namprd05.prod.outlook.com
 (2603:10b6:208:36e::18) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SN7PR12MB8004:EE_
X-MS-Office365-Filtering-Correlation-Id: 6505d70e-b3dc-46fa-77a9-08de7968e43e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	T+Yi6IRFoObxV2PZdxtZ78hhvw1zNtDlDimXpnZ/XwxSpbejvih259V1kponx1+88eIFh9rrL8NOTWw87pe2zdJBe8VzHR5POPN8srxyGdnn9CmU7arCqqbvsoksDHDuCN51MqHwISZ6pjhsCbzISeQOX2pR0GUC2Bw2OFhSsPUbpmIAG8h7j0+P+kINYEHDwDUFCov5Uwg6Fm2jw+n8foUs0Rl3rVDHfOc4SVVlT31bAv1lPBtv18hi3B6mbE8C1hxRzh0f2j2f36cUvHfq1qSgR/F84DD/daYj4iAR9vU0LhMiDp24rfHIYpkXUlgQQjDjNfX0/PBgI3IWTk98vx80xfzD7osDy6vUsMUUNCZUNODmwfT4BalljW9XAqW5NWYa2zI56cXHW+/xCuNCOmfmmDwomVs893Uy1L4rjJO+6qXDNxf4Up/ZIN0uFpf5RLm1xRRAT9f0Q0eUvYzv9UDFf+q3QSBaPRyssF1w4seH6xR/etAEVxeQv51yjHE8M1f58/CfWogEDTTzAuOuQe0fQvjbgp46XPe2m8p5ToBjnG2huw/BJkvBE0a7Ek4VZ+7tIKDDG+87fTcJg6G1QqXJfKuMsaTVrF3UDusXP0cRhNUc595zujSrHWXHAC5qmGZM8jS0qDWcHuf4EreVVKKYzMewOlKhLieUO6rND/KJ8lO3d28ZCt6y45k+N0FBLAKmzYlzY2p1aVeQGJY6NnSRzo3OWYnUtKwVNrfOzA8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PoxwKr+e91LOj8cswy8rMU/mYejo4hXivNlX5nsIVgEu5ob6Gg2WaL+2dbAc?=
 =?us-ascii?Q?OvYQFOfqaaRB+YsvBY8npZYKQX8wO0EU5QXSMz+TVFqnjWCjW4p3CNv/x9PE?=
 =?us-ascii?Q?RZGe8PHJlWInXLbGqEkp6HAEfr3xMZX7ujv2urMThwtX6lX06OQDxq8qMV8a?=
 =?us-ascii?Q?nL9utRL49cOVd+NRxFmbnFmuKxf5vz75oYCbfgTFJiwP0VyK4EjI2CfccsQ9?=
 =?us-ascii?Q?fLmnwraAWWRX0jmF4l7YzxTRwq7Q1qveWMrdRfmYuaLnjl4xSKnY3fdzIm5I?=
 =?us-ascii?Q?2ub3wIMpUB7fZ47Vs/sqc74txNM7qEJMQ0HNb/ArxKbhAQTksOoN98PQaLYX?=
 =?us-ascii?Q?Wsc3th4R8i56Wb9JfqMeNn+UpAuCX/g+VhfrQMwkoEW3FJkyt1ywpngUgCUn?=
 =?us-ascii?Q?0EEwz45m/i9tHs4y0jKsC1pc82CDv9w4WtnFSYvsYmqrA8PGFvjX1vyfulUv?=
 =?us-ascii?Q?uAsljHRLiYRd8LVj2ykNYj0yPDOs5wQBSz2gq4qU0fBHPsVKBwVdWkCE82Ut?=
 =?us-ascii?Q?yvTqpx93oaPaBiSc/lWH9QNu2m8PBUCmSEsfmuNzme9n7nWeafGGsk7boCcj?=
 =?us-ascii?Q?NCqn4r/h0Ft8EbONzvU5/7mE29pce2JL9iDbfzWTuoUCQ0yTfqD02YS3ylxv?=
 =?us-ascii?Q?KIhT3RWwrHwGh7j9+lTXBOTZEu05e0Q8pxspNtFimoT6pSKOBimkNRwZrgew?=
 =?us-ascii?Q?chFwmoR0+nA7UkFrLEDt6P393CjG6cOxSwxrK3dFlCembduNIP5MwiRVdOWI?=
 =?us-ascii?Q?6UHPsrSE59WuzW9jvAmIQegUjXR1X9t3mDPImBjM4b+mTvur7pVEcnlipzW3?=
 =?us-ascii?Q?K1Sdpx9TOcbsdMuQn1HTXDlIC3q9jJj6y9iRcxI3DFBP505WLLXQvovMzFl7?=
 =?us-ascii?Q?sdfdChufn2brzqzr5Y8b+Jc/XLJhptSlEDMZv1lcWjLb1AYWx3MkXYMDQwma?=
 =?us-ascii?Q?K4KjNjoKmyPpkkh4MJfZ1tAayXRl9N1AD+3QPAR9sIuW4e6dfBwERqNMc0RQ?=
 =?us-ascii?Q?KOSXsV4c/A3LJMfg7LBLQv8twXQmHrf/SzkjHv0ms3buS+Xs21+aJJ3NYUCd?=
 =?us-ascii?Q?XYEyvnUsLPiZ4BMfJ+npJ8Qdk9RB3uqV6ZaHxJkC4MU+jm8hFbQLLfU5t2Pv?=
 =?us-ascii?Q?Jgz9iDPZwG/EK2FvGFaI2BObexyW7awCZeCtjtt8vH38SPQJ+T25DAo2Mmtt?=
 =?us-ascii?Q?Rm8d2z6HFwk6J9KXUrNArCSSc225Xn2QW0Ptq3tE7NjOUZmnccebmj6HO3TR?=
 =?us-ascii?Q?nmwn5lmvWt8JY6+wFjytatcxFNKCGHhKhIqJyX5O9u/2nE9m17S8WFGBv3KD?=
 =?us-ascii?Q?iSkVf/WaeAMgUHSoYCh90FWugY8ldRmPo3Oswpv1CjhMdCYHbAzTAWSn0Nuz?=
 =?us-ascii?Q?e6E3U6jrGe+NCay7LIauzlcTjWN0XABnJ5LXXzb1dZeMmLTu1e+kZl//QY5L?=
 =?us-ascii?Q?4B6WP2K8dYgF+qRPYoIq+tYKLc215Hcrj71qxLz3ROolTGM008r49IE6djJN?=
 =?us-ascii?Q?+8E9ffpRDh1DVG3ICzAF8zhx/SJg/mt7lpNP/Dkdj2z3wNl3cKBfGF/Q1BN2?=
 =?us-ascii?Q?c4t7h8t3qlN+nIMUp4P4PuEQsTAcPq3rqMs30/jK3cfcT9gRyxaN64Ccu56c?=
 =?us-ascii?Q?HMpSPXUlevDAEZhUnbEzmiRjn4F0+zoJM0I+B9X0Nk7qKJkdjpkYmM0LnO2e?=
 =?us-ascii?Q?Kqmo/lSUBECZcKHro0VjDU9zVsQFYzlAxGEajPVzqaPxu1D4M9U3pEawpgc2?=
 =?us-ascii?Q?2SZ4j2Cf/Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6505d70e-b3dc-46fa-77a9-08de7968e43e
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 21:07:34.8502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hVWbuxg4W6OOVBaBZvbZXMCfQdncLoVo5XFD4pfP3VVxBgypnJOa/N6LgLJ2zi85
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8004
X-Rspamd-Queue-Id: 86C1D1F7346
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[google.com,nvidia.com,amazon.com,fb.com,linux-foundation.org,kernel.org,linux.microsoft.com,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	TAGGED_FROM(0.00)[bounces-72603-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[43];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,nvidia.com:mid,Nvidia.com:dkim]
X-Rspamd-Action: no action

On Thu, Feb 26, 2026 at 04:03:53PM -0700, Alex Williamson wrote:
> > @@ -203,5 +225,6 @@ void vfio_pci_liveupdate_cleanup(void)
> >  	if (!liveupdate_enabled())
> >  		return;
> >  
> > +	WARN_ON_ONCE(pci_liveupdate_unregister_fh(&vfio_pci_liveupdate_fh));
> 
> This is propagation of a poor API choice in liveupdate, the unregister
> should return void, it shouldn't be allowed to fail, IMO.  Thanks,

+1

"destroy" functions that fail are evil. :)

Jason

