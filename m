Return-Path: <kvm+bounces-3652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD85180641C
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 02:27:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8986E282278
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 01:27:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6D9010E1;
	Wed,  6 Dec 2023 01:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XhbIRB3N"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D2F1B1;
	Tue,  5 Dec 2023 17:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701826053; x=1733362053;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=smRhhOsu3F8NMi+K0C0qijP5AIEkBLQln1wVq1wtgbo=;
  b=XhbIRB3NHkpOxFggUoW9PD8pS8na4ib/Hdbm5R6Be/SdUevyhCiAaPVg
   ubeSx52udEPGF9HpC5c10LpicU8vqL5CIQLXrK5Zink2lZg/VgCHhqCDh
   3DHoWOBNDS4nusbUjNqc3OeCGQqqW7tGqeC98YaedjBlBA00UeP49P/60
   5UaE1yuoEhKrnqnoBpgCKevo40q8lMcHVpxpTJkycelrtyuwZjygst1Pm
   1Jt5nSlnBAAG5c84qjcSA2H6FxR43XVIT6swVYTITBHwcMJcbLIBjqSl2
   b0NTupOIjIgqmOkhHDY7VmVvrbV8CiTDv6jMogx6X5ofCMdLNfAYfxwsv
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="392851389"
X-IronPort-AV: E=Sophos;i="6.04,254,1695711600"; 
   d="scan'208";a="392851389"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 17:27:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="1018402927"
X-IronPort-AV: E=Sophos;i="6.04,254,1695711600"; 
   d="scan'208";a="1018402927"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Dec 2023 17:27:32 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Dec 2023 17:27:32 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Dec 2023 17:27:31 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 5 Dec 2023 17:27:31 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 5 Dec 2023 17:27:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iYKOZtl9+9IGLERYF62RCabXRLzbd30Pm1vWlVCimCAG8awzyYQQ6FpzhVhAmeHHT09cikP5aEvul6VTgzmqWXEAKYCLn1opSoe7GoCZ/gSHadjpMVTgM+0GmIzXWw39apmGl8Q5TvTIavPDnRO8FLJpTMQyEZFoPWePOmeKXY2/dfgWxQfJpfVSQ7qumoaLDIrdZGFzZsU450vWgNuscw8zMOWBJ0ee1Fof4VggWpHhVDpjaCLFyqn29MWGtl1FMA4Xypn5Gv0097R7k/y65vas7/Kl80EeR0Mc60jejSg3pUDTZa2iZ9gvnL6sCeuJ90NyG7SnOWWzeDGGPUS5ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UyY5QcbH+8Gf9YMId7ifTrBFdemZ5DBDPO85D/viuXg=;
 b=VtEhB60U3+rBUcDiCN8gWalhiSCbwtPlaozSVLIgAnUMaJCW5dimgu0KoXfvSQavO3ivMhW/+yjUTLpnfHpK+siAdvQIy3vTl6QqkGuYy9lSVKnWwI1lfO1QmHYCE1+j9GHZa0oFGj6XnOlYrZKkMHmqpqyAZmzkBDqhRBCQJ8FdH5W6pCNuprEf8Sk08d3RVqjFFI046N9OIe+nG1DGYTz7pBkz69mdQPiLDslHAwcFUQuEWUs71RQGS86BKkTyMRuR67RUMCJZLc0lVNEH3Ff+h6JZc75FmmMKYv6G+33b8Vve4I2AkQ0+9mR4O283LQ0tV5N9ZE7DfZEP6ioT5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 LV8PR11MB8697.namprd11.prod.outlook.com (2603:10b6:408:1fe::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 01:27:29 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::32a9:54b8:4253:31d4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::32a9:54b8:4253:31d4%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 01:27:29 +0000
Date: Wed, 6 Dec 2023 08:58:26 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <alex.williamson@redhat.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <joro@8bytes.org>,
	<will@kernel.org>, <robin.murphy@arm.com>, <kevin.tian@intel.com>,
	<baolu.lu@linux.intel.com>, <dwmw2@infradead.org>, <yi.l.liu@intel.com>
Subject: Re: [RFC PATCH 12/42] iommufd: Introduce allocation data info and
 flag for KVM managed HWPT
Message-ID: <ZW/HMs23GSR4osoZ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
 <20231202092113.14141-1-yan.y.zhao@intel.com>
 <20231204182928.GL1493156@nvidia.com>
 <ZW7MU4L9vybiDqZt@yzhao56-desk.sh.intel.com>
 <20231205145304.GE2787277@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231205145304.GE2787277@nvidia.com>
X-ClientProxiedBy: SI2PR02CA0023.apcprd02.prod.outlook.com
 (2603:1096:4:195::11) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|LV8PR11MB8697:EE_
X-MS-Office365-Filtering-Correlation-Id: d0e0403a-b796-46b7-65db-08dbf5fa830c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6jq0bVCVw2uATs+DuP4yEzE83QVPODmHxzbGMdIFRvd9RqHaezPSK3mSUjEiq5VEbOh+CM6F+eQ1uqSlKedALRqcfyVtqZyuXS81HYdZ3Znab89lWPmYWUu6q3TSkF8VJroAdHWRINkEDcXEoDaMeYB6wO1GloT1tZYGT4PPCvWZ6TETnopp2AwTu91/Y3f9R/57iq3UMU+uDFvZCPBZVPi/hnAygVxRw7T7x2tJ6O5AuywwadB0RRAZaANZpABCrI9evXJ2cQyVFeKcOhr9J5TFUG8S1giOYD77HDE444dZ7F5auIpdWXoQwA453FwIhx2EVFAuarKP7+68FiSvzyRu30ACA9bG4uGwgY3p+IblAOcQs1/e+xdDrzl7QIWUUsW+SbrvItct7oNJpzrTUbgNyqK1Ck6WfObkrZzFueK+XnaHdxRYDiwKyepi18rSydMFlyxIfGbSJ+7PD6pNIOeQo+GN4gdVxp7Xx94sVYCpNs6SWwwAPH6PyF3orCwLxO5tv6EjboOZfQWGO4GYzDS/4PpxnG/TOr4HVkBuu1rTOHeVvESDugb7me/GP9Gn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(366004)(376002)(396003)(346002)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(2906002)(3450700001)(5660300002)(7416002)(86362001)(41300700001)(38100700002)(82960400001)(6512007)(26005)(6506007)(6666004)(478600001)(6486002)(54906003)(316002)(66556008)(66476007)(66946007)(6916009)(4326008)(8936002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FTPEXarYV6F35j/TMw9NSQWB4oqGWRuwiCIpm3iPeWbLR33XoCFiRrHDF6Yz?=
 =?us-ascii?Q?EwLYlNou30ptGau+9/E3/asKW5icAqIPkVSfQupoN2oTQjUbutICZ6pHqqQY?=
 =?us-ascii?Q?M3GYZ4SFuXTAVvSjvdn4lNT9a8fMpSVYEzFdBhXHaDuzKbGLYYrobFMl6K75?=
 =?us-ascii?Q?WEYKTymvNeZQb+tHevlbG5AWtVGwgpAipv6lJPvWPtLOIPXH+MrCO3K78Edq?=
 =?us-ascii?Q?PeRByDgqsCOWVJbu+TVpOBT0WwX65lJ4pQ/CaU1/uozEGgZ2WbgLNb4xR1pv?=
 =?us-ascii?Q?Q5Nu9uAJzCvAoP3S6un8uB9nQPvmONvqyvO56VqjIjrMOZckspMqHkn0M8AN?=
 =?us-ascii?Q?oVLEwwfwWCx+BOJ8nrzPuI/oz/RWQb13q2R5sfyRqPMlWuiCCpOxK4SkI8ku?=
 =?us-ascii?Q?WKer+KqmlNwr8ijfmJ8Few9pNRHUWmrkmAyvTQbxq2/B00mxZ+c6RG90FuUM?=
 =?us-ascii?Q?mJGkYAP60E6rYUiRC7y0M454zaJ3ucscFfobmSw3Qpac6Snnq0tiCBhsywyC?=
 =?us-ascii?Q?6YahsqTq+8fnlxnKc3NqMXsQqhutwf3PKnMRd0YwRJ3rrbvt9xUQt1bVMice?=
 =?us-ascii?Q?x+VyGXEDZNJrzLDDbogpEUC48eiAfll1dQCSzGp7of7beb8ia9pY7FQ/RfCG?=
 =?us-ascii?Q?XW1SPpkP/coEnJhDyz/YDDgRMxqx+aF4mM/fzCmx0zT+gNEG810PV1Cc6o+B?=
 =?us-ascii?Q?RpnwF9kIeExgP/f8EAnLkR7fYg3aGVSDz5Z77uHiecrTZRf++vgli9v8mXYH?=
 =?us-ascii?Q?DoXBne8o+SWHAf6yr46VFPLQwD4bkHyPpRECzqYFSP4q4pjo3sEONHGMcBhs?=
 =?us-ascii?Q?lGwKVU0j0fBIBoQLhUTCFrdR/l8/BUfTgY3GqZUZY8bBy1YOElix+LRE+tSK?=
 =?us-ascii?Q?5RmA9L6HvjC/BI9+ZcPEkj53KfPkjbm5UHyOWKr+6uVQPzMy45sbk8k6Pr19?=
 =?us-ascii?Q?6iBLhVJ7G1suQg2Y3hOSLPUSiERVfGuJbcbbBSRweW/KqTsjySJzD2kD3ppN?=
 =?us-ascii?Q?fenNTlSckJtsvVUY+ZMzCmMPCT8oFgymu95tyLxPkctJeACby9DCOPPs6MPS?=
 =?us-ascii?Q?T71tlT1MJDkHbNPErtb2Mipbbw8GbXdeAawhXSB4zoMkgonVPYCeSsB5ORQR?=
 =?us-ascii?Q?993V57hfL2Zz/LOmMaL1WtyKeLZ01Ni8SxntGGw5NijPpL0G0jv4bqg98uxl?=
 =?us-ascii?Q?aDwBmkmJVpIuPRIlNfQ22WZZiwZkBq7Sg/dVPN+naISLULxVrpQ8YTpSpdqP?=
 =?us-ascii?Q?oUEQylLJSifQGiE2oTrhuTZfR+D8sAC+CDGH7NqYOGX1l7AtQd8p99Gcsedo?=
 =?us-ascii?Q?btrYayay83SqkjYMbuTQeybV1wm5y1e8C9lyQ7+S7Tb51jRtNMNTfSnoeQwW?=
 =?us-ascii?Q?OSMzkDqbq3xZLrik7k7zoPzLOgWzYUEJQUoyrClb3dtLwKrRYL3ry8EDo+YC?=
 =?us-ascii?Q?tmXRx420+WyA7c/ErsJyn6/qUMocYje1TkJG1dHEMU9Z6pHSkaEehfpo4rD+?=
 =?us-ascii?Q?hiJH8w5POFgXX4+GRYQ2tn1N02qnHXSMk3Pr4CP+WgM/rUQvNPPn92POIQD3?=
 =?us-ascii?Q?2g6nga26xlafdtE90Tz12KazaAU9A3ZkVol6vORM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d0e0403a-b796-46b7-65db-08dbf5fa830c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 01:27:29.3989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eeYKcd7f1BgZx2eztLCzVF1BLLFQUeTHLaHwHeJUCtD9IlIXSTBHgShUqrYanlx4hF0etAHhzZf2KJyKtj62ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8697
X-OriginatorOrg: intel.com

On Tue, Dec 05, 2023 at 10:53:04AM -0400, Jason Gunthorpe wrote:
> On Tue, Dec 05, 2023 at 03:08:03PM +0800, Yan Zhao wrote:
> > On Mon, Dec 04, 2023 at 02:29:28PM -0400, Jason Gunthorpe wrote:
> > > On Sat, Dec 02, 2023 at 05:21:13PM +0800, Yan Zhao wrote:
> > > 
> > > > @@ -413,11 +422,13 @@ struct iommu_hwpt_arm_smmuv3 {
> > > >   * @IOMMU_HWPT_DATA_NONE: no data
> > > >   * @IOMMU_HWPT_DATA_VTD_S1: Intel VT-d stage-1 page table
> > > >   * @IOMMU_HWPT_DATA_ARM_SMMUV3: ARM SMMUv3 Context Descriptor Table
> > > > + * @IOMMU_HWPT_DATA_KVM: KVM managed stage-2 page table
> > > >   */
> > > >  enum iommu_hwpt_data_type {
> > > >  	IOMMU_HWPT_DATA_NONE,
> > > >  	IOMMU_HWPT_DATA_VTD_S1,
> > > >  	IOMMU_HWPT_DATA_ARM_SMMUV3,
> > > > +	IOMMU_HWPT_DATA_KVM,
> > > >  };
> > > 
> > > Definately no, the HWPT_DATA is for the *driver* - it should not be
> > > "kvm".
> > > 
> > > Add the kvm fd to the main structure
> > >
> > Do you mean add a "int kvm_fd" to "struct iommu_hwpt_alloc" ?
> > struct iommu_hwpt_alloc {
> >         __u32 size;
> >         __u32 flags;
> >         __u32 dev_id;
> >         __u32 pt_id;
> >         __u32 out_hwpt_id;
> >         __u32 __reserved;
> >         __u32 data_type;
> >         __u32 data_len;
> >         __aligned_u64 data_uptr;
> > };
> > 
> > Then always create the HWPT as IOMMUFD_OBJ_HWPT_KVM as long as kvm_fd > 0 ?
> 
> Yes, but 0 is a valid FD so you need to add a flag 'kvm_fd valid'

Got it, thanks!

