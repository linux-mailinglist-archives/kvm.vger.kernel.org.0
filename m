Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6101F6D122D
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 00:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbjC3Wcb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 18:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbjC3Wc3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 18:32:29 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A6AC17E;
        Thu, 30 Mar 2023 15:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680215548; x=1711751548;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=I0KWsWruzdJqhCVZGHtkHpz2dePrl/CFmnN44bTdNL4=;
  b=QHspCbeOpPJ3ZXw16zYocM9ZiHQumnc3JJj5afLFjX4EvXs//+Gu3e85
   MrTD6wsPLseIaYDRSSdxiWmRyIPo7bznLVV2VeS8H2K+zd9rqVHp126dV
   uXwZYmfAHA0NBRYgtBAh+cp/zXJd7i9WB3oZkwO85RX4GciX6HAlhT+i6
   r57WWMvYVc6W9sCiXzQYWr4VKpDKT/5RRq6AJfKAGASkOqPlsdroy+Ldx
   I3j2F+Z2gKLPDlhWqHS6WPvChm4yvXmMFhuMZU+SIfYGxU4lH531P5aGn
   2wPfS2qu0Z65sGlYn2qZiZj46MyVDOtJZkPo/LhdUxOBwYPT+HxuwP/ha
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="343804745"
X-IronPort-AV: E=Sophos;i="5.98,306,1673942400"; 
   d="scan'208";a="343804745"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 15:32:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="859069673"
X-IronPort-AV: E=Sophos;i="5.98,306,1673942400"; 
   d="scan'208";a="859069673"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 30 Mar 2023 15:32:27 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 15:32:26 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 15:32:26 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 30 Mar 2023 15:32:26 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 30 Mar 2023 15:32:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mr2xD/8CuW4k66Wj/5P+QBiu0RylhyKi+H1PKBBKXdusiZkc+2mWpoHJifpA51yABraffGWViWB++s+4waLqLD5bso6UbULdw3lrzopC5cm5T0l2eBRrxLbqHJ8w0r0u6B+j/QqMxNZeR/Rxn0lMHZoPawJ3cZrVXSw3vf4dubvx+kIjRYJpYrxBguY5nSgypa3ykGj6nD9g0n/RUpdgeI1G9V7Ww5fKix2EWLE1HtQruXNw0xzr0j7eVSNtNuuCiA2cNo8sG61QSY+wmifKTeK+caLxfJPUlPSL1JJaAiLmO99fckLc+9fedsna0LXFT5cYBujLj27Eu5pENM3MbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x1mjhORKrgufc1/dsLmvGiDdbV0Y+lLwiVhkpSXizzc=;
 b=Fu6suPSQrZgQAJQukRnf+uO3fPn9H0pNszJnlnG1NgckGcJRDQq5/HhkmtDGrigjhZGy3esU09RAzquDtSdCnAXST9DWa4ctuSTpIA+72Lrx+FAYXDur2F97hR33klEZ383tEFgXpS6UsHCDfwf+8VTpHmDigNJ3UupEM2CksKTG1kwe/mn5J5u9ddkp+IZdOCugp+s2X0+r7ex9w2+ycEKSR/fa8oC91dDblxlxG9CsNvnDM0VxKtsu50trIWBqFPmph+2kLn+rt/4BXEEXnQieIo2dKx26YItKNBQhT2TYmY7C+9f8vAofhCadki8+sKwg3qB30cA+kjMWvglnWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
 by SJ0PR11MB7155.namprd11.prod.outlook.com (2603:10b6:a03:48d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Thu, 30 Mar
 2023 22:32:24 +0000
Received: from CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f]) by CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f%12]) with mapi id 15.20.6254.022; Thu, 30 Mar
 2023 22:32:24 +0000
Message-ID: <460fdc5f-7613-5164-0247-254939cedc71@intel.com>
Date:   Thu, 30 Mar 2023 15:32:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [PATCH V2 2/8] vfio/pci: Remove negative check on unsigned vector
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <tglx@linutronix.de>, <darwi@linutronix.de>, <kvm@vger.kernel.org>,
        <dave.jiang@intel.com>, <jing2.liu@intel.com>,
        <ashok.raj@intel.com>, <fenghua.yu@intel.com>,
        <tom.zanussi@linux.intel.com>, <linux-kernel@vger.kernel.org>
References: <cover.1680038771.git.reinette.chatre@intel.com>
 <0dc2a0c8e25b13a3a41db75ab192f387a1548c80.1680038771.git.reinette.chatre@intel.com>
 <20230330142657.3930c68b.alex.williamson@redhat.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20230330142657.3930c68b.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0122.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::7) To CY4PR11MB1862.namprd11.prod.outlook.com
 (2603:10b6:903:124::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR11MB1862:EE_|SJ0PR11MB7155:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ca94087-516f-4f4c-c98f-08db316ea1f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lFVrGMjuIxqV7df/tVDXxsiyEiYcGF7g8cJSDQANi7MJ0kOrSpdeR4h+w82dsDyAn3Yr2FIrVEklMXtUA/4YNuiEuPIKN2aCEFIPc9wecDv7SI4cGt/syTUHVfFe8GPAerb730aOYxSPcv2Ji7aeEhg1+JEq3VAOxScLIv0GXeO9jUook0jeFmH2N0jLqgPvNM2XayozPFAGPKKIzPdqca4Lb6r2/k5tXAIqhqEic2cb0cItJ7ljg4+x9EPN7w4/9xI/wo4HlRXfU/1g7SDr+QkKAo1vUisow8J242NCSzabTSU37swPKibQAuj15AemEDolyrs6NR6++euQs1mNLVKdYOChvwwcRoDKa2cU17u5oZTWOnV4AMn//CIy7d/uDuD7BHu0tm7t4xEgjy+zC6sRPacFGsco/hMqSM/SwcpGQgIDDGeRqmN7cdxBDtMfW//3XdCTb3LHrIiSADr31Y9WWDJmJ9bJjIl/W+itWqdkdP4BJ086H5ramTGva4/1jwQ+/dkboB2oftgZn9iqX+DyEqLH7IA9krvXY2TdsYBjsm2heV2raN5rLNApWH4LwGxUChSKLnLUqnIkz7euE1rtIOsD6rtlQt2Uyqqq6bEn69S2hwrzU9w3UfKAgVTAq0Ugb4FMo8RYVbggS7P/ug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1862.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(396003)(346002)(136003)(366004)(451199021)(6666004)(31686004)(38100700002)(82960400001)(478600001)(4326008)(5660300002)(6916009)(31696002)(66946007)(66476007)(44832011)(66556008)(86362001)(2906002)(316002)(41300700001)(53546011)(26005)(6512007)(6506007)(36756003)(83380400001)(2616005)(6486002)(8676002)(8936002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U3dMZjFCa1FmSFlHSFlGRHFzRUVyRVJqbmZ0cGRQWVVhQVNvbDhJYVdabldo?=
 =?utf-8?B?ZlExQ05Fd0RBdzBqOGxkS21vdkkrTksva1J3MmNZeVRSQ204Y0VjNDVKS2VC?=
 =?utf-8?B?NDVWU1hLdVZiOHY3Qlc0OEVncmx3djRYWGdDNVoxUVg0OG52TGM1UUh1OWJq?=
 =?utf-8?B?SmJNcFo5dk1mcGorVG9rVDl5ekprVmVIQU5YRFFsUkc3b2Z4NUhUdlk5ZTBM?=
 =?utf-8?B?QWg2TzAxUTZlV1lVYWpYY3NmdFVjRnhpclRmZWRncVJOMFhjTnI5WlNGWWlh?=
 =?utf-8?B?T1JvcDA4SnA5Ylg2MkVKRHFrNlJ4Qk1LQVJMcXdJUlhMQ0VSYkZpRzhQR3A5?=
 =?utf-8?B?UE1FSlBPcFB5cXdPeFpSQ1VRWE1GMzBtMExsL0dXREY2a1VEbm5BWXlCc0hs?=
 =?utf-8?B?Z1ljOGJ5YUZzbVN0ZzFDMW1ua3psWXBMQjhyU0I2RVQ4K3I4ZjRSMXdPczd2?=
 =?utf-8?B?aGFpaG9aaktrTk9LbnY1cTE0UVVpREY0eFg5Tm92dUN5N1dMTkxJenB2MkhI?=
 =?utf-8?B?dlZsem9jc2VPTVFqSDBiM2wvYnEvb0REZGVYWHlrdGNhQzZ6czNzT0t1Mitx?=
 =?utf-8?B?YW9rdXdNWGtZci9LUjJjci9hbXM1WGxsVStGc2xsTmpiL1kyRExGU2pYRG9B?=
 =?utf-8?B?ZnJkMHduUlhUcEdja3IxVWlMTUpHcWpMaldjMTNTWnNZVytZNFJFZzVCUXVn?=
 =?utf-8?B?UTdkbXdQcE05blhRUjFYSTdPaDBDb2lpY2Z0Mzh3V0RLSWFXZDZ3cEZKR0g2?=
 =?utf-8?B?QWdaRVRkLzZ3YTBlRHdScFZESytpNmd4YjRlZXRNaE93WkV6NnltV1pFTS9h?=
 =?utf-8?B?UEc5UlIyRW1hdUNRRGdxSmJkRUhMV0liTVlad2F5NkVqSENLeFp1Yi9kRTMx?=
 =?utf-8?B?U3BTUnhSV0RNNU51RXM5TGxXRXJiNG1ER2tHVC9WU0tDU0hidEI3aTZhdEo3?=
 =?utf-8?B?U0RrdjV3aVZiTU9EOWo5aW4wbWxSMGVWczN6N3RabDUrOUVDWW83RlEwMWlo?=
 =?utf-8?B?emFwNUVPMEMweDJ2MjZTVTVkalQ5OWlYQlc5aXMxbDgrRmFLUm5lMUJndzE5?=
 =?utf-8?B?ak5URUFCTnFFL3JoZGZTb0xNekpFREMvRG80RzJrclZEMFNkRjhFQU4zRDUy?=
 =?utf-8?B?Z0R1OGtJNE9vUlBOQWZDNmIrQWxDWWhUUENUNW5wL1cwckxaVVplQUp3SjVp?=
 =?utf-8?B?S1ZRM1ZwNkwweUo2ZlZKQk1LNk8vWnJyUDcxTFo5bzBwSWU0NWZoSkRmWi9Q?=
 =?utf-8?B?c1crZklBbzdtN3pjcHc2UVFnVXhuZ0pRS2I4WnpSb2ovR1ZZZjRWWDkzTU5n?=
 =?utf-8?B?ZW9YWVNwazMwd3pCUkhYZitzeHRVQTh3ZHp6N3pBem43aTl4Y0hCaXhMN0hp?=
 =?utf-8?B?Nk5jZ2VmZUVvaDd2Y0xVKzk2Vy9xTjZ4bnlUa3dPQllMZXl6ZEdwS213QTZ1?=
 =?utf-8?B?bDZHZ2UyTW9QYnZ6NEdUSVo3KyswL0RESkNoZ2ZXcEo1OEVGWGZ2dmJXOFNO?=
 =?utf-8?B?alFOa1IrZ05TMDJpSi9POWUzdXZRYWZESW5SVTdpOThmZGxrQ0RQbFlpR1RZ?=
 =?utf-8?B?S2tTYVRIRWRaWnNxZlQ2K2lQUUZtNzN4WEh4NFRveFZzRDBIMjFuRERuZXNO?=
 =?utf-8?B?NlZyczJLOXJ1VWpkaU01aGZpY2FTRklXMmJzcFA5Zm9iQTZzYTFBMThCaEdV?=
 =?utf-8?B?Y2NTbjJwZUVDZFBMQlFZVmxUR09SOFVmdnR3WHE4R2toR1k1c1dJdXB5OHRI?=
 =?utf-8?B?ZkxYTXl2U25HcGNFK3ZsMVlJMUdURTM1VHhEcVlLZTNHdlp3aGxWcXBFVmlm?=
 =?utf-8?B?VlEzK1g1TVBHTVF3VkxiZjliUE9xdW43Ulk1Vm8wNTdmYk9yV0FzaEQyV09T?=
 =?utf-8?B?eCtRVmVwamV6bUlWYUhkbng3WDR2Q0tIaFF4VkZwOG05Y0I0WWgvRDdiOEFm?=
 =?utf-8?B?T3ZsV2RxZjlreGg0L1NkQ29HbFNiaHI0L2FtOGpDR1Fjc1BlNDdiTi9CVGtn?=
 =?utf-8?B?T0JZbVh1T2Q2ZUVxcHdUMTl0V0g3T0pwVU5uZFdsRXI5OHZGb0ZCQk9KazhX?=
 =?utf-8?B?TzdDQkRLWldnb3Q5OFdUOVltNjlyOTlGeXV5VFQ5KytwazVUZjlkYjI0RUtK?=
 =?utf-8?B?YTJVYXBKZjhkWFdjbjNQc2dERnd3Yk1NNWIydC9vRUY2ODdFbE5weGVTaUhK?=
 =?utf-8?B?SHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ca94087-516f-4f4c-c98f-08db316ea1f1
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1862.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 22:32:23.8540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O0ycH1GBH0QtoNlcWxAcQj9iH9N1KLish1LHYsO4/2oqJXsRBeX04LNe0b4nZKS9OYGsqDcqbP6lHT0KUwC4n3o+hXPO210oP9ax30wOxc8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB7155
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 3/30/2023 1:26 PM, Alex Williamson wrote:
> On Tue, 28 Mar 2023 14:53:29 -0700
> Reinette Chatre <reinette.chatre@intel.com> wrote:
...

>> @@ -399,7 +399,8 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
>>  static int vfio_msi_set_block(struct vfio_pci_core_device *vdev, unsigned start,
>>  			      unsigned count, int32_t *fds, bool msix)
>>  {
>> -	int i, j, ret = 0;
>> +	int i, ret = 0;
>> +	unsigned int j;
>>  
>>  	if (start >= vdev->num_ctx || start + count > vdev->num_ctx)
>>  		return -EINVAL;
> 
> Unfortunately this turns the unwind portion of the function into an
> infinite loop in the common case when @start is zero:
> 
>                 for (--j; j >= (int)start; j--)
>                         vfio_msi_set_vector_signal(vdev, j, -1, msix);
> 
> 

Thank you very much for catching this. It is not clear to me how you
would prefer to resolve this. Would you prefer that the vector parameter
in vfio_msi_set_vector_signal() continue to be an int and this patch be
dropped and the "if (vector < 0)" check remains (option A)? Or, alternatively,
I see two other possible solutions where the vector parameter in
vfio_msi_set_vector_signal() becomes an unsigned int and the above snippet
could be one of:

option B:
vfio_msi_set_block()
{
	int i, j, ret = 0;

	...
		for (--j; j >= (int)start; j--)
			vfio_msi_set_vector_signal(vdev, (unsigned int)j, -1, msix);
}

option C:
vfio_msi_set_block()
{
	int i, ret = 0;
	unsigned int j;

	...
		for (--j; j >= start && j < start + count; j--)
			vfio_msi_set_vector_signal(vdev, j, -1, msix);
}

What would you prefer?

Reinette
