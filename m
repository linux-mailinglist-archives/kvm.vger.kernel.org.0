Return-Path: <kvm+bounces-161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 804C27DC82A
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 09:31:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4EBEEB2103A
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 08:31:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DFE019BB1;
	Tue, 31 Oct 2023 08:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GwNgadZt"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1D0199A3
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 08:31:44 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CBCCC1
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 01:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698741103; x=1730277103;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8kQExUYCUXVSgDVSVNuoujkjtj7iJyfhO5bEzVxKOt4=;
  b=GwNgadZtJPwRsfAo3IvI52sJe7sHezDX67PKSqRIg+I+QFyvXM++YqOl
   CcfCF5KGrBJciQO2fDcPzcPFQBbLu+BEunOd5LFlCNE4ln/6FJ+qIKEBz
   Evc+aE2MlFW2Pyeq4ZbGVN9kBZlQpsL7VK1zlGJ3WFyeEZ6PtKdKqBapM
   nsEWKvu/y0U/qtOtaiP/wutJcat2FTYNIB0573sqLZQiF5Ki2lY+WHaOQ
   jpFj7kUAxJW6EsbvGg6vZBI8FL+cXHaen35WkcNPeS9XHoYUaT+L3u9aO
   I7drYOHBN89ryhdyJXD1r7CnqNJwM25TGGtAf2oDYAeJkl2WsnxfHd85P
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="373290207"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="373290207"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 01:31:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="764162050"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="764162050"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Oct 2023 01:31:42 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 31 Oct 2023 01:31:42 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 31 Oct 2023 01:31:41 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 31 Oct 2023 01:31:41 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 31 Oct 2023 01:31:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J4YexoL6KzviNTGbKk7RQuOEHyMRwzCMFBZhFb7Tg0Z7BVfpT62Qu8IQ7WPqjSGkIcZM8Gckukj8qcKv5ZkNYvoWWHc7PbIBvzzwUh7/j12U68TORgQiExkEXaiVIqClVNGDj17YCeTo0dR0MJpGDS403+EgtH82VagYGLxjvbk9oFOt3A4r2ek6/isM6nKCuw2V1vDC0fAGVdeU2Mu+nAT9Q8Wc26kCbFRrL7+9LMTPxFMsUASzCLF+fNUQdGQJ6SvUFnxctdXU8mySPWpKsfbjQn1xi99AdCvE1XFkaB1hkgd9u71QNoOH24dxYrbRIbCh5L4lz+6Avbi75TfroA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uFZkKp1ZXgZNgQiS7E+9n5aBZiJNEr2yLtSgSQS1OnM=;
 b=OuCs5JKiFkVIE1QE473ektvQOCFZ9N0FAzHvvh9LbwckF/0QzRceW0wcHLHAh+VKgfrbCJ20iEpH02YGwbnur0/BWs4NUhrM+6yUp90eGe9FQKJiOJkUJRlSWRNrJwkRxKQUViSSddNILaC91nSteYZA48mjMTCYJy3YmxtWOXB8hvsAnMYmIoHcph0rQex9mv1vAOBGnmvYVx22N9IX9SR2MC2ATv7NUdERl6DuBXO++Q+EggeKpluO6wztcB5W8UqCqV2+gO8V+4m9KZwTPGAAQlZ6I1xZdqciAOTyKwn/m8tyWPLH0hzC59vj1M/lQ/S3WLGcUgq9gGZsbTXEcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB5626.namprd11.prod.outlook.com (2603:10b6:510:ee::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.29; Tue, 31 Oct
 2023 08:31:37 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e4ae:3948:1f55:547d]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e4ae:3948:1f55:547d%4]) with mapi id 15.20.6933.024; Tue, 31 Oct 2023
 08:31:37 +0000
Message-ID: <99949d96-5fbc-4a27-9aa2-841a5bd167c5@intel.com>
Date: Tue, 31 Oct 2023 16:34:05 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Yishai Hadas <yishaih@nvidia.com>, <alex.williamson@redhat.com>,
	<jasowang@redhat.com>, <jgg@nvidia.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <parav@nvidia.com>,
	<feliu@nvidia.com>, <jiri@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>, <leonro@nvidia.com>,
	<maorg@nvidia.com>
References: <20231029155952.67686-1-yishaih@nvidia.com>
 <20231029155952.67686-10-yishaih@nvidia.com>
 <4a5ab8d6-1138-4f4f-bb61-9ec0309d46e6@intel.com>
 <20231031042235-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20231031042235-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0013.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::12) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH0PR11MB5626:EE_
X-MS-Office365-Filtering-Correlation-Id: 11cda73c-aadc-436e-6395-08dbd9ebcbd8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VMhQwzQWvP715vNvu+fwKDC+nHUsGBB2VpjWXB1I5oqUXdQCS0Bom3y6oUOHZPdhYPRS4hJGZ7Y6nUCesFctFG7mfEbanawmvngdmJ+5yosnYq2aI3MnleGpDGqspBeaCVLmO6yo2SgSSdqS0Kqh8eNiHeqTlYP2rcew6fG95yH5T1mNbrHc325nAzkg8/zjPAocB+millOrVLE8jpUQDKt1tc58N3Jg6g5ehKjc9a06cYGTFIOWXhAzP+Pwvx6HA1XBXdj5yje6Z0kV34P0qacOD29vs2IQ9tjn4QY3S5VTsoGNIizMruN3Z9ertSQ19PTGEZZxZs5rrbNYLzU/1O7ogRSDKhmcEy/3K3hlGiqiEXBTGQeXcmgjkl4pCvWsZDjmK7hT1KJw2rEoAxIT4yupLqIXtSbStw28rPUxiRjMORT4IjUVKMq6W1UXU4JY4QEQcBjXr1vIGDWaSS0KMK7pTf/RwLlo8SLTaqvpfGWEf7vy22ROF+2/oEbbWgCZohVf9/uygjgfEOpPh0cavDGLnMZ0dxsKIfGV2NcpZPE1pgti46BW8LqK7qtrg/rSR63Il+BZzGFF95xjUOcJ6fRNzm+/8sJIW0G5//DAF35kF6NvlgFB9zV1zJMX1wvfdUpneeyiwIKPpGSsXQk7GQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(366004)(39860400002)(136003)(376002)(230922051799003)(451199024)(1800799009)(186009)(64100799003)(2906002)(8936002)(8676002)(4326008)(31686004)(4744005)(6666004)(6486002)(41300700001)(478600001)(6916009)(316002)(66476007)(5660300002)(7416002)(66556008)(66946007)(6506007)(53546011)(2616005)(26005)(82960400001)(6512007)(36756003)(86362001)(31696002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bUppVzBFNlgyL0RRdG8wR29oNGNkRFRVU3lnQ3dqN1VkdytaUkc5SFdMc1Q3?=
 =?utf-8?B?U0NwSW1aOFBZRFpUYzBuNSszMHhSMERrYnZTUGhFNHQ4VjVxZkt0bTBEcjdp?=
 =?utf-8?B?VTZqYWRqQW9waGRaTW94UmtuZTJaendMUkltRHhpZzNBdUdudzE0bVBnSnJS?=
 =?utf-8?B?WlB1Mk5CdjEyL0dmaThhcEZtczI5dUh6Wjg2RlZhNnlWbWZiSFR0ZzJtSlA1?=
 =?utf-8?B?OVRLc1hMb1ZYRnpXaXQwazRvRWVrRTBDcW55M1R0WWpwSDc1UXR1SE8yY0xI?=
 =?utf-8?B?MHRWYU50Yk9Fb1J2S1F5cmRzMC9aZmtGZ0xqS04xTjRxLzZOcEJuV1BjZUZJ?=
 =?utf-8?B?aUhTTTZjWW5Bck1sSmx2OXBKcUJleGFEaXQ3b2RDUjVUUnRITWF5UW8zYjlw?=
 =?utf-8?B?dzBvVWQvZTdsNUhPU1hwZ2NOZXFQc1MyL3JxM1plSVphMnFiRzZ0TE9MTjQ5?=
 =?utf-8?B?MGVNZWVLZnZOUndDVmNVcXlpTEZ1WE9vMVpBSmFJVEEvcU1TRlIzODlQT2NY?=
 =?utf-8?B?dkhFS2hkajRDRXdKQ1JYREdLU3I0ZEpEZDE1b3BQTW56Mm82U3l4WXRPc00r?=
 =?utf-8?B?NGlvdlRJL1FJWEw1K0RoTWRBS2MzUUt6bGRnTnllTEE0YlA5blpzUlVKNnBr?=
 =?utf-8?B?Z1RnUUxrSW9YRDBIWEFvc0JoQjBGdnJEaWRTN3l1akZJNzIvajVRVnhNRFNP?=
 =?utf-8?B?RkN0WGsrMkVGQ0tEcXlHbzhIYjFjZTBMNnZJNHlPdCtLM3Z4dGZHS3VNTEFF?=
 =?utf-8?B?N1piNkNKdk03VEpXODdwcWdML3N4RGc1SS8vMEFyb1NsSkViUHVreFdCL1hR?=
 =?utf-8?B?bnJzZjBTN25yeUpoU0E0dlB2ZkdBN3grbkhQMUljVDdZMC9VZkZIdXpMOU9L?=
 =?utf-8?B?U2FHeHlYMGJqMTEwbkp2NlJUenFBT0hKL2E2OWdUSWZXOExoZXZzbDJmS0RT?=
 =?utf-8?B?UWp3Q1BySWFBOTgxakowcWhFdVRPeEIvMkdGdE1kNkpKSmZ4UjFzeHVWeWht?=
 =?utf-8?B?K3ZhaHE4cFNndlQ3T2RVSWZwd2JiVlcxemtWZFBoaldZZzIrcXZMV3NCZDdL?=
 =?utf-8?B?TzFKeldKUjlFQ0J1WFBGbElPbHdQandFdEwrRmdGbktXcnJLUlVuSjErcnVO?=
 =?utf-8?B?bk9XazJId3B4Y2hCSGlSUm1iUmFhWHBNcDRFaXR3RjQ0cTJkc1p5Ri9wZld5?=
 =?utf-8?B?MXlERG9qR1hSZkt2YTduNitPYWIrQmVtOU82eThqamxuUUJUajQ0eHowYm05?=
 =?utf-8?B?SlRVVjdhbXMrRG5XMC9vOExuZ2RMcmtqWFA1VDR5cmpmL0VRemExS05KdDFK?=
 =?utf-8?B?K05TaVVGbnREY3dGaU92UnFCbzFJeWxCVnJKQjRJc3pxb3dlMTRQQjZ1OVVS?=
 =?utf-8?B?K1I1NUc4aVc1ak8yb3FjbVlFbXhmN3JCR3A3bHo1K3lHazFhQVIvU214b2cx?=
 =?utf-8?B?bit0U0Vla2JzR0xsWVVGY1dpdUg1UTQ2K0tReFFSVFRaQW1QQWVhUGpEKysx?=
 =?utf-8?B?c0RwRjZiUW9zRnhqTE8wNnFjQWx0VTJZclNUU3pSMCtjNEdrQ1NncnFhVFdz?=
 =?utf-8?B?RnNGREgzWU1HVTJQc1VmOW45OFNjTXQxN3NaYlBidHc0UzNBbnV2UUp2M1pT?=
 =?utf-8?B?dDg5WkVnZmc3RjVJcU5TVjRvQytNWjRlVzM2K0pldWtxZmM3cHNxUU9oUkh4?=
 =?utf-8?B?SXlhVjhvdjJESk5IMW5NTDUwZjNXMmtrTDFmbWNSY0lqMFkya21VdWpwRU02?=
 =?utf-8?B?bHNhZHJWS1lwQURSQXFSQmNjVnpYajB2eWtCRWEzenNDd0xyMzRjNGFyWXhH?=
 =?utf-8?B?QVczYVA5Sk1rMXZyT3h3SmdubVNRUHdnTVFrb1hOaE1VS0Q5RGRsQkZWOGpQ?=
 =?utf-8?B?eDlQUDFHZUt2a00zVG9jVFdIdXRNa0NsRFl2Mkh6b09xUFNBKzZZTTFRcjVh?=
 =?utf-8?B?NnAxeGdEeUlUVXdJMDNlTXBVczc5ck9BclpBN01pVGROb2ZrWWRSQ0JyaFNh?=
 =?utf-8?B?WTlMelpRME8yV3N1dzdmWXhGYVNRMVA1dm9xVVdSUnlXZlBPQ0pUWUs2WTNH?=
 =?utf-8?B?c0JSQjkvM2NSbmtTSnNNWm1hWDFGNEp5S2tTc21sUGZuTXE3MkJ2VnZjT3ZL?=
 =?utf-8?Q?lR/GzEEuIBObaKE0OXeBn+E8e?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 11cda73c-aadc-436e-6395-08dbd9ebcbd8
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2023 08:31:36.7126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +LFozDl4+MkOlw5qaM89I0K+iw1hJWZhLlCjuOChxhrytz+lZaooYyd/JPD/mFeMOBR0rBokU95YQDdi0ZWGjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5626
X-OriginatorOrg: intel.com

On 2023/10/31 16:23, Michael S. Tsirkin wrote:
> On Tue, Oct 31, 2023 at 04:17:45PM +0800, Yi Liu wrote:
>> a dumb question. Is it common between all virtio devices that the legay
>> interface is in BAR0?
> 
> It has to be, that is where the legacy driver is looking for it.

sure. this makes sense.

-- 
Regards,
Yi Liu

