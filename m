Return-Path: <kvm+bounces-5975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B1028292BB
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 04:15:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC178289220
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 03:15:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30E614689;
	Wed, 10 Jan 2024 03:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ra++eKzx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61261D518;
	Wed, 10 Jan 2024 03:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704856496; x=1736392496;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4w1ZQPNnVxlmjwOgbJTBzyh5z4OM+JdEKU9rTOTdWO4=;
  b=Ra++eKzx2GgcEdsysSzKfKen2YLqVQhy1sFi2ItWaoFQqKqr+S8wxcGB
   vRnvghqVBHWlf+3cg0ecBPxlHnZvKpu0nlqKlHzc7h9IFYZj8DLXoxod3
   S06xxdYHwqo0us1/qOw9pHcBCFLkB68XMoDNU9Pstycgs1BH+VKFfPZjo
   7P4W1tS3DT7S5ZI4MgbouQzQhuc23HIUwR6sWTeqD6pv0MfQFPZCh0AU8
   O+VPF4UHB20BLI+ul5hsDkn9QG8UVkaM1Rw66KmNvxETbp7uSLwf7dB/R
   RV4akHiXZvh8ugp5/QOlGXWhe22W6yai/cYbc8ShMGBsJHUmKD2ck97Ia
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="11881070"
X-IronPort-AV: E=Sophos;i="6.04,184,1695711600"; 
   d="scan'208";a="11881070"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2024 19:14:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,184,1695711600"; 
   d="scan'208";a="24106229"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Jan 2024 19:14:41 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 9 Jan 2024 19:14:40 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 9 Jan 2024 19:14:40 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 9 Jan 2024 19:14:40 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 9 Jan 2024 19:14:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=At9N0mGmKR3vHN1OzwbuBEhoNimz9RKKO5wwYCjxZlZg3zjodWRt2Q0pPGi1clN4UIbYgGL8Uf9nxeya/0nIjktTreD+6WKwFAsnvEqli8uTvN1vDqryFTFqwns4Dm1LtC2C/85+Uiy3H3uZ7+4g+1DS+LzWponmDM3NOfFoG4xW9Uq8uq2+oXRbr5IiEBy/T8JVNtqZCPj6tSw00Z88SEpLTZzfGrkj0QUtegcfOzHfrLRFwdQw++Ia5n2XkdH+54WZZss9QTv5dwMVZIXGgrP/c+FbJ6k8loy/0mxNQLDHB3g1+XvrFwHA0cbVhBveehLa13X8slTqPGl1TRwiNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nPf+xCaUpSXPk/tcRw4M3rKQok9PQGCPMfmGO5tMiFo=;
 b=R2ajKGLDLu/rPxIIV5yszr7I+cOlOW4eqrsX6C8g3v6qn92Y/ge1X9HSIlE6fssMIh82k5cPRLtBm3ShBPKggkeAX2RliJ85XIzBysSSk9aW50O6z6zOigph4sIzPFRkO6YjoP+phU1mko4U+5t6GQXmkpCEuUmE45X5zroQysGfCDvjAtXpMq769/qILZTtuHrcQ9xp9tyRAoO0StDUGjr/9+MDH4am4Gs1zBxEySuVxE2lH5/u6Spb6jatZUZi5e1qOFmXdSRBwaNMS2+KgwT65hOswZNzZ10qzpEGMAle8Dfkb4goguIxeV6Gr/gIDT/eGKhiuvjO4Yf7O8J2yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6392.namprd11.prod.outlook.com (2603:10b6:930:37::15)
 by DM4PR11MB7376.namprd11.prod.outlook.com (2603:10b6:8:100::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.23; Wed, 10 Jan
 2024 03:14:32 +0000
Received: from CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::b99c:f603:f176:aca]) by CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::b99c:f603:f176:aca%5]) with mapi id 15.20.7159.020; Wed, 10 Jan 2024
 03:14:31 +0000
Date: Wed, 10 Jan 2024 11:10:13 +0800
From: Yujie Liu <yujie.liu@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Vitaly Kuznetsov <vkuznets@redhat.com>, kernel test robot <lkp@intel.com>,
	<oe-kbuild-all@lists.linux.dev>, <linux-kernel@vger.kernel.org>, "Paolo
 Bonzini" <pbonzini@redhat.com>, <kvm@vger.kernel.org>
Subject: Re: arch/x86/kvm/vmx/hyperv.h:79:30: sparse: sparse: cast truncates
 bits from constant value (1b009b becomes 9b)
Message-ID: <ZZ4KlYj+IrDb09FW@yujie-X299>
References: <202311302231.sinLrAig-lkp@intel.com>
 <87v89jmc3q.fsf@redhat.com>
 <ZWjLN3As3vz5lXcK@google.com>
 <ZWl466DIxhF7uRnP@yujie-X299>
 <ZWoCEUvk3Nlmlb9v@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZWoCEUvk3Nlmlb9v@google.com>
X-ClientProxiedBy: SG2PR02CA0078.apcprd02.prod.outlook.com
 (2603:1096:4:90::18) To CY5PR11MB6392.namprd11.prod.outlook.com
 (2603:10b6:930:37::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6392:EE_|DM4PR11MB7376:EE_
X-MS-Office365-Filtering-Correlation-Id: d691c4d3-7db9-4131-d851-08dc118a439f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bio4ysZTFwYQnuOY4ou1CZIdVQ4goRvMjaifKgpMghrtAkgJiq3A5FRWOSO1/3sMUwXIAHobbBRg9XHGnhnnqzAfSpXNHqN4YuP93v0yvTzyHDDRiQv1hxDq7orbVma6U9pXBAouIc0o8PQ235zvWfKxQ8SrPCqLfG30fCjJBjnjGA0BWRHpJq5pqstcFnsrfLf6hSnHiYRt+s7uYxdyupTbvf2TeC6pMVYJAP+rUhFX+KwMsxk7fG0usYohcBK/Kk5xXbv/U0nC/CFOUDuSLWfRMwbXCI0iZi+J1BEMgTF80z2SrCUT6sW2TrYmQJcAnkKTAWdHagiQiMIZXSokDr+nXTWrOlfsJXDKSZOMlrwHq3MNKk/zK7D/D1Cv2r8IAXPiqrD6IJkWp7Uxe6g4ewqaLT2GG1zIip4AKyMrJG4raA1OdLlb8Kt+qJIunK3cYjvdkUEOtZgiDu7qxwMplEvgpZ2viMfPw0UekMpUgJ+xwDLqrQesU9Dj6BLnizFQsOZiNXReUjbADOLnZnFWwUTxhJDwzzDjg1sMS41mbHeJ3ammDDJ/R1KjiT1iOZa3+MSkHEhQ4M1wkG4yBsEh3ZtyS3XLtF+941Z7qA6vA7u/b04Gc/Wz0Vs6fWkiF/fl8dVM6s9KFb3hTXTsEko1sg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6392.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(346002)(376002)(136003)(39860400002)(366004)(396003)(230922051799003)(230273577357003)(230173577357003)(451199024)(1800799012)(186009)(64100799003)(83380400001)(26005)(33716001)(38100700002)(2906002)(5660300002)(4326008)(8676002)(8936002)(44832011)(478600001)(9686003)(6512007)(6506007)(6666004)(66476007)(966005)(54906003)(6486002)(6916009)(66946007)(66556008)(316002)(41300700001)(82960400001)(86362001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZHNVuzsnr9DmxGiteLWOYpM5RYwAgXs828ZcrWqIswJ0mfhfkAVrPGuL+W1T?=
 =?us-ascii?Q?qmRaPoV1zPlSOHrV/m845X4jjZDRAFfcTLRM8QapyG3OtTIFoCEVQ13HpSVY?=
 =?us-ascii?Q?sP57geSNNRyhuzIkn4NAB1cEQAEqUPPjhZK4yq1sT/TvBTXzaWYglNh/JOrx?=
 =?us-ascii?Q?X40LUyEZkdQNkS9m9YJyGsCBw6L/cEzzuAC+jElYESxeJwQCmUXPBJID3gbf?=
 =?us-ascii?Q?OeCHtuFqETPkADTdwL43x1tPwiAhHyuAgEBFCX+ARBZ7V5HAH6BBmbhT/wSd?=
 =?us-ascii?Q?au+msp3R10x5bM2heMkX/ZRTs428v6C2RQhbLnsnCJ/RRCGzc01dt9/VGIeE?=
 =?us-ascii?Q?QQdkbniWLVPI/L7qRTTXdnRw9e31nTFJEc6q6zms0WNzgcwmUtQios9c/7EV?=
 =?us-ascii?Q?KHVYTuxo43eFYwk6pqceLu7QyfraqpdvlQfIA4OGT4d4DbESxBm13lb+lz0e?=
 =?us-ascii?Q?aptWuj853i9oqr43gT5lGfARSuB0fRKp5hriaWLuTo0Z2ixefVVuJ0lhRfQ2?=
 =?us-ascii?Q?6a6ixPw59Kf24dSCsSoBGpQVteM5rAUGcwthmUoBlgpJTkRl/mdnoqMaFgDn?=
 =?us-ascii?Q?kA0gjw2OwY1HyeYsxYqymzmWhr15c0RTRBST/o5c6AN4/oITuxilfhWw7CoK?=
 =?us-ascii?Q?kA0bLIvivqSC3twEzdSXi0JbzrHA0C1/seMavCXkLmgIIhN0d6rw4Jgbr4cz?=
 =?us-ascii?Q?oaqWRtBtB5JXhvc5WGW826VrgI+LosXsgjFl04Ju/Gxbi08P/87miroA1iTW?=
 =?us-ascii?Q?xfQPeAOmFCD5+ICzNeF7wXhQwgswzDhOoJmStgpZzfchfsPCo4zUxL72ZMqC?=
 =?us-ascii?Q?zdsE5KZTrkNOjKY83gkbFeO1M2RI5jAuEDw2Wlz8VWPldr46G/cVmX1gwLh8?=
 =?us-ascii?Q?VfBdH63QRr/x92dGY+WbFTvudrA9VPu0caN2L9j16i8snVlxHXzNMwQCuR4m?=
 =?us-ascii?Q?jinX+OOSCkqiiWU9H0BBGXKfByncocp98PKBNUNvcTxizkAAMPICeSaRs8vd?=
 =?us-ascii?Q?POcCr4rbB0FSdHovKX0tDJ1wvdk4n2rbc2JO58JdcsKQtylVNGPJoWRff6bf?=
 =?us-ascii?Q?L5gAX3b9Psw77YsKUyFoHUpwpaM1TJwYtyT3qPHdZ7uQiKrvmGVhOR4ILX2C?=
 =?us-ascii?Q?gnVG5f11FE+YOWxQu1IMjQaqcW7Qe4oDH8Q+Bs3/Vh7h1IdjtcCUIoHgUFau?=
 =?us-ascii?Q?4YlboVbbzfc6KsOkxDm826dw45dAZpua0rg6Rrir1l+Xi/zM/vL2eBIUdXUe?=
 =?us-ascii?Q?3bunDmW83I20Hzid/na/08YR5DrHdfIE+eSP8bHtBrknwA6mG63fWQW+WKP0?=
 =?us-ascii?Q?zYa7QFe/zAC5SpWzL71VBQ1oyjO54LRO6TAlugfYdWJqBTrtt/cT7RCt6SEa?=
 =?us-ascii?Q?shSdKhhJUhcfEsR0Sx87lyT65ZsuAcbAUJecOhZp3YIS2VNnvifyabjJ70w5?=
 =?us-ascii?Q?XwcQS68BGmMEIBhGP78egT5un8hOO902Txd5SUKSEeZQeBHEkOtI6+C4huaX?=
 =?us-ascii?Q?r3edVY4HMyKNMFXhM70CTXiEn6W2MKYdjaOE9ayotQQgxluG4kOh/WGMpHtb?=
 =?us-ascii?Q?a3XUw9c2QB0zjzRAmsnGd/iAl5U7SMe3dojJa3hA?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d691c4d3-7db9-4131-d851-08dc118a439f
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6392.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2024 03:14:31.9100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UAVsUKU4PfA8jivJnT1ys4RbzfGPOeNQBdHQDVJTk7U30cIbLbtd8oAhB+aYUxxKIzdOXOukVMNFMa/FF7zarw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7376
X-OriginatorOrg: intel.com

Hi Sean,

On Fri, Dec 01, 2023 at 07:56:01AM -0800, Sean Christopherson wrote:
> On Fri, Dec 01, 2023, Yujie Liu wrote:
> > On Thu, Nov 30, 2023 at 09:49:43AM -0800, Sean Christopherson wrote:
> > > On Thu, Nov 30, 2023, Vitaly Kuznetsov wrote:
> > > > kernel test robot <lkp@intel.com> writes:
> > > > 
> > > > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> > > > > head:   3b47bc037bd44f142ac09848e8d3ecccc726be99
> > > > > commit: a789aeba419647c44d7e7320de20fea037c211d0 KVM: VMX: Rename "vmx/evmcs.{ch}" to "vmx/hyperv.{ch}"
> > > > > date:   1 year ago
> > > > > config: x86_64-randconfig-123-20231130 (https://download.01.org/0day-ci/archive/20231130/202311302231.sinLrAig-lkp@intel.com/config)
> > > > > compiler: clang version 16.0.4 (https://github.com/llvm/llvm-project.git ae42196bc493ffe877a7e3dff8be32035dea4d07)
> > > > > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231130/202311302231.sinLrAig-lkp@intel.com/reproduce)
> > > > >
> > > > > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > > > > the same patch/commit), kindly add following tags
> > > > > | Reported-by: kernel test robot <lkp@intel.com>
> > > > > | Closes: https://lore.kernel.org/oe-kbuild-all/202311302231.sinLrAig-lkp@intel.com/
> > > > >
> > > > > sparse warnings: (new ones prefixed by >>)
> > > > >    arch/x86/kvm/vmx/hyperv.h:79:30: sparse: sparse: cast truncates bits from constant value (a000a becomes a)
> > > > 
> > > > This is what ROL16() macro does but the thing is: we actually want to
> > > > truncate bits by doing an explicit (u16) cast. We can probably replace
> > > > this with '& 0xffff':
> > > > 
> > > > #define ROL16(val, n) ((((u16)(val) << (n)) | ((u16)(val) >> (16 - (n)))) & 0xffff)
> > > > 
> > > > but honestly I don't see much point...
> > > 
> > > Yeah, just ignore 'em, we get the exact same sparse complaints in vmcs12.c and
> > > have had great success ignoring those too :-)
> > 
> > Thanks for the information. We've disabled this warning in the bot to
> > avoid sending reports against other files with similar code.
> 
> I would probably recommend keeping the sparse warning enabled, IIRC it does find
> legitimate bugs from time to time.
> 
> Or are you able to disable just the ROL16() warning?  If so, super cool!

FYI, we've added new logic in kernel test robot to ignore this sparse warning
for ROL16 macro.

Best Regards,
Yujie

