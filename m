Return-Path: <kvm+bounces-57209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4251B51D38
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 18:14:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 88F357A33CD
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 16:12:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22A6433438C;
	Wed, 10 Sep 2025 16:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZypZC9Zb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2064.outbound.protection.outlook.com [40.107.212.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25B03314AB;
	Wed, 10 Sep 2025 16:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757520845; cv=fail; b=TGgwk4ZshFa0r86ZHL+2VYbZfZNu/U5NjVHk4AL8DF+quiDLPHriNL95fgsJuNPIwCoaIKUFtPSSW7e56GywiyocyI6G02jJSr1Kt0LJoLLhjaoLbv8OELDdvSL5Wziw0ELrjblL9NTAj1/N5Xrq7ni9oMWdE9nWfjV+oTYhO2A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757520845; c=relaxed/simple;
	bh=kmgLlZG1dpwKOKeZnazLgOmbw7BPH5hcAkTf7yRQeF4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mWVkNcP5DK0GrQG/4xOJBiJnDp1DcTh2/XYlO4zKMgEGZDcmcqkyta9kc85Q+HNirVNoUl0QJMxVvYei98XQBfKB+Kn2Xul8xkPF8Xpw9WUP+njld7/aKWahOfDxP8g4ngsScTdpyjd1o6cD4rO948PKlVlA20KNP/iCz71/u9Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZypZC9Zb; arc=fail smtp.client-ip=40.107.212.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Iz4baO/YChUD109eL77a/HwF9e3fn/cB8iSG39QaBGYOIbevM6uNRI1xgw323LhC9HkIOHRz4E1lX2pjKQob1QkG+NBZBClBvaoN0r0YH2R4O756TsrSYGU9G69TdA6vwVD7FtUlTMnHIDiRFnEEFDxnEI7ou7voVsomLDh6UTtGOusAZX7qljcwH11pY9Nlsh4MdyrI7SoA5+mmTA9A+UetXmO3wv7xjx9PDVJILq2+rd2a23UObGQMWSVwy0Xqp5Co7qUVYOtje8ySMEOLy1P3jhDDLTt+KIIHze18V4/UkqC1jt+TfwS9n/2sdqG44QvlgtwK2T96tIVlxkPbiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nV/onsRFORYIxVAIGxVoOOpgbLDONxCpZgACQBPyjW4=;
 b=Aulr0/I3A9N+Enlr7KWQGGikXTer24RFD2zjJWtHoc151QJd9bap4hHxikJl3S8naNXax8okHDvxhWTK20QR9miYkygDx7iPeUEQO15wFRpWql7vh/oxyFJPbUXNsiaSUAJYx+NRjqDue2oYoCLtDa33JiuyhqfFP/QOOfviIJR/8a7se6py64I3JXpPdTF2LtBBMMQq5y7mPnbAr1mkpt8heWfzcTwIgwJ3C5N4I3hq5udYTwu7JSHMKp2d2XoCMDzX1fMSjldXqkHuZLs8dNwkq9MhPn3EthdAlpcUcrOrvHR2vMlwDF1WG5mOing5qeE4tIUL8yVJyENU9dSrBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nV/onsRFORYIxVAIGxVoOOpgbLDONxCpZgACQBPyjW4=;
 b=ZypZC9ZbKOojDLP6+xw0RuLcIqEoLhDJGKIKS+wSTnvJBwJ3SVfmffIDy2uN1cIVQPcVkeSukf4fnAv+0jtZeD6gmvYFc5lKtCZaxIGgrleMVzpeROQtQADc5NjHS6I3A0cTpmNmfuGCBGhuFR3r9UOYvfnbY6S9kJU33yj0RdB4VI1MkE/bt3JmjeWs/xVO03/3LAgSDMZyk1uuLnaOpZ84ioi5mKg5Wwtkx3EySP9LX2phQktotG/IA7n1RodrK7VqduxsNsqvGAGLWOgljsm9KRUjZKCyB/tBLSjBkiZSM0tVFsFpYGVo7WuYDNakzPsNal+nievpRMEpUyb9rg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by MN0PR12MB6246.namprd12.prod.outlook.com (2603:10b6:208:3c2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 16:14:00 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 16:14:00 +0000
Date: Wed, 10 Sep 2025 13:13:58 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Donald Dutile <ddutile@redhat.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH v3 05/11] PCI: Add pci_reachable_set()
Message-ID: <20250910161358.GA922134@nvidia.com>
References: <5-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
 <20250909210336.GA1507895@bhelgaas>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909210336.GA1507895@bhelgaas>
X-ClientProxiedBy: MN0P221CA0013.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:52a::18) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|MN0PR12MB6246:EE_
X-MS-Office365-Filtering-Correlation-Id: 862010b0-3b79-4a77-9048-08ddf0850d3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?f6XhWaFy81De3Zp6g36EJC2s77IyCoVE+m3ajGx1+RuyiW11lTpuqsPXEQBe?=
 =?us-ascii?Q?okqHFFExZUwMI6dZsEEnxX9V2UWOXxIq+4kyTOab0SYyH0naRjDgDa0VjFoe?=
 =?us-ascii?Q?BkTEKkd9T6HB6Rw1RKjJDs/YizJWDYw1mCmxdvNDpdsEyQsUTbuH6TPTAsP1?=
 =?us-ascii?Q?I460CdxemDeoFqWIOY/Ude/+SHcQf328y3+DaIOSq7XcXdPZ/cq5XE+Kit3H?=
 =?us-ascii?Q?wwa3tBrwMC273gGAS1+43VIGdNgqw0M1kZ/vRgdwfsfyemZSsQigYNrgoUPn?=
 =?us-ascii?Q?YAi7zsFTxb7G25Fu3ObEk3IiWD+4hlTTw/JmSpKp7ed7RiNelxqRfsupOTZI?=
 =?us-ascii?Q?qcGE3dP0kpDotFn5zrWH2YFHPDEGTNwl2mwGVfuKfK7aP61JWf5yQOEc36PN?=
 =?us-ascii?Q?WKrrQlQBLAMlaLNUpHHHYvQbhNzFYEExkKiLJ2K/Rf9JBeOGJNex446dm0N+?=
 =?us-ascii?Q?mQbhm7NSv+NOqxzFlBYsucJsOKlv9dTc8IFu24D8IGUJDw5yM3n0UX8nzTS4?=
 =?us-ascii?Q?8GrvCz1vQYjmgnr65sSpLZif6ZeK9ztHGOvbJ/MIsjOWDEZd3qeCWqQKcxGb?=
 =?us-ascii?Q?msBil+1SutuV96j7jZrLJb3GKGxvwuXEw7dC7Hpkx14UhWMklEpPWuOImThl?=
 =?us-ascii?Q?LnKr+AFAyzKIIj5Bb9By8F5sIVGnnoGoErgG9Mp3FlgDI39T+ddOHcarnels?=
 =?us-ascii?Q?QPdnCNqQoGjPRIoAnWGz6B7nmkZg/rq2ZhGrWA/CE0KQscyJKib6wGbXDhfu?=
 =?us-ascii?Q?la4w+cW4mR7yYo4MlINn5zG9a37EvgQC26aZc+hNSTXdtKL/2kEElEQ4tFes?=
 =?us-ascii?Q?kxFZ/88Ee7ymUpda1MIUd/lySDc1RTZm+j4WQ2uxAvly9/ff/c3u2G4JgOKu?=
 =?us-ascii?Q?HEb8iNmBH01d6aYwvh4J74BLUg5bPoir7S/vQGHpxIhF5x1tpNeY+Wncg92J?=
 =?us-ascii?Q?20Hk1Jwgn+3ymc4mJm/cews1I4WBpTqzpHFf6+VsYEbOuKVTpeViMt6S8I5s?=
 =?us-ascii?Q?dOyhsSs4j2eIyDYnqHWeHxJfH9LwrTrj88cvY1uSTGCFoEY+fi4yyxgcEf0w?=
 =?us-ascii?Q?UajeZ1RMq+UojPUvHPFLi08QNmiQjCyOxrpkzJ8799wMwLm/KdZ38SQiB/Hx?=
 =?us-ascii?Q?Ov7mcMxx8O6YuflklZNPwf0Clj6lylzDuteJR53MVGKsUbbnhf+MevL3FcPG?=
 =?us-ascii?Q?6C2lMOGw56Isyi3XOHJmU/qL2vjNcMTWTaX0vk5+bf+CPD+vDfa2+fPEW2In?=
 =?us-ascii?Q?DAHjIHbwkP9P15RNVS+0cseWR9ZWjEVGTjDLximtIXFL1zYl/xU4c/NeMuih?=
 =?us-ascii?Q?gp+XYE0MULvvGu0Gk/AL7U79mt0mZbm7qUHk4A4bVkWLqtEvRRVz/t0Sjc8E?=
 =?us-ascii?Q?YMfFWSNkHzAH91rWKTR+RGLF0axtOS6Xztbq7t4zYqxtM6e+Sooz19pjpO5p?=
 =?us-ascii?Q?YQ3K4HB+p1I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8/QnYf55Ksrwd3a+DGcMebGBDmHcLJo6thqFxRFIjdSM/4FeCTUTmEBlC9f+?=
 =?us-ascii?Q?bXyarF9Bs0Bwyc3L1aiiWWvIZ9SlgkElgz8WkwrEKNoMeDUz86Q/Yz5si7I5?=
 =?us-ascii?Q?dTK70ywtMW1X3Qvdg4o0IRjmpRfGgumsM7ttiJVhkpwkrs0ZiiPSU7L6qEl+?=
 =?us-ascii?Q?9k5uLI2+kMCD4NvdYgkjSx03T0UJL8y+blNt1yx5MeBjFjGqLCN1kj0fOIrT?=
 =?us-ascii?Q?h9oDDosqhWdUw51w5d6xD6tgXGHi7gL1cRTrVzHnJ3KJr1TcJlGMFwNl/9ek?=
 =?us-ascii?Q?v6ZIxKbCNwODqO1/HGHzLE0XFeAMahl9mGw1CQ0IRZkzxh5Qiv/e5egTHICq?=
 =?us-ascii?Q?2HzNDD8D0gwYnLpmKUL99ZYBb3D2jXUcgZIFurGr0a9r5fm9kKAxRWydutA2?=
 =?us-ascii?Q?zpqZixVsTZ8JYoe3jmSuAMSnLzI7pyG9itNxQWaAyF7IYbYwWR3CGO4D2VGk?=
 =?us-ascii?Q?OQy3MRTaEK1wcVR/RbfLUWKI/dn6BkC/rJTZFQXRqazih96lLYP1pCLtSGlA?=
 =?us-ascii?Q?zyOGGAQOs48LvrWucdzKIvOaqOIDt70v7np6Vs2DpaZO6M/pbnhSMcekL6PL?=
 =?us-ascii?Q?bhK4zBWkVK9Rhg9yQn4ZTVEMXX1VZ4CYOTO1RUgXw2mQlz2rKWyC5fUYlNXb?=
 =?us-ascii?Q?sjj1bCe9YV0S7DjDZOzIixbBrqlFZidKC/qmOZV7X/quAPY0XQlTDj6j+PBD?=
 =?us-ascii?Q?1oMZ0Bj02Xxys3AFwFlKC+QCQuwVroigbZY10F6rwLwmw1Kh+DfEU86LAtr3?=
 =?us-ascii?Q?+xL1CRtQAYrXz6G7UMhL5dVVT4tz9l9hD9qO7cqEPgqINNBgzwrs53HkGVaP?=
 =?us-ascii?Q?HzLjzykFfA0hjNdA6AnCy4DgmGwo4CVreXPCgvP375nnXCqctNFS61ED0vKC?=
 =?us-ascii?Q?rVVgjlC2mV9R2TvQtpa1rEa/RSORIT3hSG9PYl+3LTZFe4uoK/54fPfxXU/3?=
 =?us-ascii?Q?imvOWMLaVIAWtrzmyIW0ebp55aNkrv+e0ykDa9NbQWjVSTbfDAeL1IdUufvL?=
 =?us-ascii?Q?yjPVIauNFPeSMsxsAx5Q4euzYUU63pb8Epyuw7ZmzK/2/cQubEARih4hK6Up?=
 =?us-ascii?Q?ofmLKfdjRYnmGGlo7KwPRat9gXh1xA9n41aKMaXnxITN9OLa2ptKZKbIkjLM?=
 =?us-ascii?Q?QiwICylzT4DpEE2hLP6dIuvnrpCoKDf4V7R1TjbYIKRNMZk8eUPuEUKJ6RnQ?=
 =?us-ascii?Q?jZei3FMeoi2C+EkuBE4MWrFzQIxmovpcumuHCfEtkhe8pA8pbzzoK6AT1gWi?=
 =?us-ascii?Q?FcLydHC65ZnE0L0jbNgrNIR/j6m0eHVLkCVUrsWaPZZpuQ1BiLO+lGhgOKRd?=
 =?us-ascii?Q?BhRlm3jjpisIgMoX+8/rmyFUy4U8CIUnIisVAzJIr5HQwv5VcqnyjsVfADWa?=
 =?us-ascii?Q?mWD7W4QFm4/QmKYgRkov8Lu3vFwGcT2rcBAvs90xBid1qw4ZDYy7gJxXXntq?=
 =?us-ascii?Q?HLB/m5Wh9JNxsOmGDALQgPVjorycx7v/Z8m15zTEuCVzgfn+zMvNDmueat9i?=
 =?us-ascii?Q?Rbg3H37zIhfqa1FLxMXjoVRzNbyEOl0kVILXiJhIScuCIITNDZDrQJxbVXLE?=
 =?us-ascii?Q?c+RenO7mEbOhB2durQM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 862010b0-3b79-4a77-9048-08ddf0850d3f
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 16:14:00.1413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: anvSpttWp/lgyIq/p5tHsawBv9bP5Y2Ymo0IxoQz+kkgJr3oVjbRj/X12rmKKRO1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6246

On Tue, Sep 09, 2025 at 04:03:36PM -0500, Bjorn Helgaas wrote:
> > +/**
> > + * pci_reachable_set - Generate a bitmap of devices within a reachability set
> > + * @start: First device in the set
> > + * @devfns: The set of devices on the bus
> 
> @devfns is a return parameter, right?  Maybe mention that somewhere?
> And the fact that the set only includes the *reachable* devices on the
> bus.

done

Jason

