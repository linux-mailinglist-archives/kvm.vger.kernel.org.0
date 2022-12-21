Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD6D652D23
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 08:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbiLUHD6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 02:03:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234423AbiLUHDy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 02:03:54 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2DB20365
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 23:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671606231; x=1703142231;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=g4q0zXpf34afc09WSeD5KCd2tdDSXHperZUY5Bxi34Y=;
  b=KSvq7qhB09REIpWhpJcBRdMO+/+W7E99ZfznTLubZHgDKpgADduTP/P4
   ngHTNbSc1JwxTdan7WgHQC8H80lnOtJdB2Lut+tYD8vI6DglV6RA7OR4W
   CLYQ3gMBCGWsq17zuCB8wF53zuTntd1SZqwKfi3/+D/DOjyFzLVNcR0o8
   xP5PgG2hF1r1rF8GasBCoKessaa9Po8ObQFHswLZhmcYTSQTTKk8JRTmM
   DJC3r/CAM4ZdBdULUHSMr+EGnYSJwK9/YtfWb35lWmT5sk+8nJZ6gHUot
   ddrx5lMP2RBJN6j46AVfpfZ885cWiHB45ygCFO9eM2hUNb8zvgqIHZIyY
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="317438919"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="317438919"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 23:03:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="653402819"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="653402819"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 20 Dec 2022 23:03:40 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 20 Dec 2022 23:03:40 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 20 Dec 2022 23:03:39 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 20 Dec 2022 23:03:39 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 20 Dec 2022 23:03:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=boezAZJgV563MRoPphLexIPnd7ONe7V05Rvh+Uqnhu6dy4FeOskbXrlmrwOZWG4eEK+mfcRth9ygeyzp85B6nxmg1rn/wNDXXdDrwj24A1LQFavbBLGnysA8ACEvaz+37GMm4yfea02Pod+eB0E6cBZuw5uEGvxusZ/fAJX/CNkqDH+2wrvielsL8I27qdt4s1QbVzbH77ifhKogiFIzsPVfmwSLE4a8hIUTtYQWDn61/t+ohyLQpqD2brhLI8FWQ6hdBJGeuY2g09P9hCFQhFMM4VZexGhVafY3RTfcVkJqbw9MbbWDGJR/uhd96SvC5edx078tlrE4tjWNZZiw/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qBazJo/RwDlfVsvZ1pjcPetwr0kBPvt7qUoFhFH0rdg=;
 b=mM4a3nxvaB/A8Yr6ta9dr2ud3tW37TneIFB7pp+1cZhUlJw0AaHiSu1ifF5c59VQ8XufbES/V7tnCfwuBGiPeRxhAgw74hvGX0KnKodKlPenj1/dhSQFfQifw553SqmdvKAk9uLQcwOXCUmD4f2arD5ORlLyuSyGFXTamqri8uzIuqt0aAunT6Xf7yHt1sCbapDHsReao1yAEeMb0LTI8RREUlWHyTryQB6hN9O1TnH7EzNry1RuL578woOZ024UslK0ZtVXcbZDIstNwE7AoLpJtOH2sxwuoCZnd4ev1SZzSEaJSgUttibifcUZCLS25CSb0jzALTCiJyFC180vJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CY8PR11MB7361.namprd11.prod.outlook.com (2603:10b6:930:84::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Wed, 21 Dec
 2022 07:03:38 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::991e:f94d:f7ac:4f8]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::991e:f94d:f7ac:4f8%8]) with mapi id 15.20.5924.016; Wed, 21 Dec 2022
 07:03:38 +0000
Message-ID: <924cfb40-4443-7b81-cfe6-ac0978f58be3@intel.com>
Date:   Wed, 21 Dec 2022 15:04:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [RFC 06/12] vfio: Pass struct vfio_device_file * to
 vfio_device_open/close()
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
 <20221219084718.9342-7-yi.l.liu@intel.com>
 <BN9PR11MB5276DF71950E708BA18619C08CEB9@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB5276DF71950E708BA18619C08CEB9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0007.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::6) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CY8PR11MB7361:EE_
X-MS-Office365-Filtering-Correlation-Id: 26afec92-70fb-4548-3130-08dae3217bec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0pCpZx/DvVQkLwv0daN7Y4n7D7RAHTsnsGOyQv5Grz92ZgRS7GxKfztRE0nDCHyKCnWBA6xi1xgfe8SPDvblngWiv0gLmNS3Q/W1CjtszbvpQk4Rjg3yskZDUvrDesuSVwVQubXyI61Mre0mZ049+4+f/Py0RDsd6srxSuoUZ57vAhzaAj2il6rgjqaQbTwFU/xnbZoFrd5UpoHXVkM6tz3Dhzl8SpFhlQWk7j0Cqo3mJmqapZRoIw1Edq8qdAZDOCzR3PxwRJheh02WiWLP0Q/tRJ/regUdlO+5RBdCIRpASqOBLn8EqlW/CzVgul28a6DphtGwh3Df/UGpTx12+kNo0tBa9+ha9KNbudCNqrYbXsYonLvBnYxnMq00ITEPH37/63NxF+15NxQs4BL+5dpX7I0ufZBxhY3pQEitbp+itGOD7Sikp5PGqOrYgsl0DZR2KcG8pSey+7S3jZYAPaLJTbrPSdXGmsTNa+/iFRdiIRdHwLeqEs+JrHPBJFjdiDobHhRsUGKTWRs3+IMcL8z8lCPCe/W//Q/Dx9W6c/6dI2GceTA9bZGF5MJMdsFJn93zsreOQfInZb4EWnTOXcpPXfScYSr5if9eN0oGBhCauwN2Cq5k+TYQ+fszm6GpIUTe1fFFdugK15sKD8v32MZwfOb0MPk8biu5FmFxvlP8Hnt+YY8Agf9A26R4SrPu5oim6AARKZ8ngElwYVOjCVsQzHMILB8pXdBFwXGb03U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(346002)(376002)(396003)(366004)(451199015)(26005)(31686004)(6512007)(6486002)(2616005)(186003)(6506007)(478600001)(66946007)(4326008)(66556008)(66476007)(8676002)(41300700001)(8936002)(5660300002)(6666004)(83380400001)(2906002)(7416002)(36756003)(110136005)(38100700002)(86362001)(54906003)(31696002)(53546011)(82960400001)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qm5vRDBFQ0xpOGRBelM2MkVldlFoWTNZQStwSW5oNnhTaFU0YmVMakdoMzFz?=
 =?utf-8?B?ZVBzNm5KWXdVYXBhRlFLM1hYUmVNS0paekp6bzIvYWlUdEp2cEdFYkduRnVo?=
 =?utf-8?B?ZlZ1SU44dUZXNVo2MnFEZWNJdWVlNkcrN0VCRWxUZFVza0R4dVhndWRFSTZu?=
 =?utf-8?B?TDlqMzJKZlRHNXJCMmxSSk9oSFhwdERxVkhpdTNJNDFFaHpybXBheENJdDZE?=
 =?utf-8?B?OUl3eU5WSGhiL0dIQVVYVFJ1T1ZNdS9YTnhXcDZFSmpwUjVvTkxWTjk5QTc4?=
 =?utf-8?B?Ty9SN1htNXFEZG4xM2ZxMVlWQUUyYmdhK1dCQUhwMmk2QUVRTkx1cGthcVFS?=
 =?utf-8?B?S1pCYkRnQmtDd1AyN1YrRnpJdGpHZU43NHJIZUpnWlpWUlJ2Z3QrdENaTlFR?=
 =?utf-8?B?MWsyam1KOG9sTW4vWlFSdVZOTU50U1d4Y3dpRGwvN2ViWlBudUdubDRXR2Zo?=
 =?utf-8?B?bDg4UFhYcVF2Sk5vYi9sd2ViU05YY0E5MzFGaFI2TkNJc29wc1pIVmpuUW0w?=
 =?utf-8?B?OW1YMUhSYWRvSWFVOStzOFJaMXVjRTNtQlFkY01wWllnaDFBSE03UjRQZktW?=
 =?utf-8?B?a2QyWWdZOTk4dUJ5V29TOHZsZUFFR1k5WFJJTXp2bm5mNFVmTVczcnd4ZVdL?=
 =?utf-8?B?L2RIZEtJUTNCTzQ3Nkd6L3JlcFFJUWprek9pS3ArUExkdGZVT1ZIcWQ1VmJh?=
 =?utf-8?B?cWhiTDFydzAwZ3hnOEtCQkEzZUNJWGllMkpwZUJqM0hrZWdMNVRRVCtvUmlF?=
 =?utf-8?B?NzdJLzI1WWlIckQydzFNeHB5WHZnbzQxMjFqbHMvL3gvR3VLUTZjQkxUUGFD?=
 =?utf-8?B?TytpNk5xam92TUt6enA2eDlRVlRvci9hNU1PWkZkeUQxYjZrTlMwVy9tUHFi?=
 =?utf-8?B?OWFsRkVTWTR0RXhKVGdSYzlmSC9tVnZsdjUybDlTRm5xTnlWUHJmQlNaUTA3?=
 =?utf-8?B?VjdPVTByanJlWnFPNXRWVnU4by90REh1WSs1VVd0U1U1SlBOczA5aStlNXp4?=
 =?utf-8?B?ckMwSCtXMVNzRTNxQjY0ajJEUi9IRlh3UTU4eXRaQTBGRytwK2k5SHRGNjVE?=
 =?utf-8?B?Zzg0eVp4S0plelZOTnJZdDMydDJGSk9FK2J1Q2lBc0lGMFduTnY4SVZYVXd3?=
 =?utf-8?B?aXkvNVFxUDFuaFVwV2dOdDVLOTRFaGhXN1l2QWRlUDJONHhzbDdQK2RXR1Br?=
 =?utf-8?B?Y09rV0p3ZkZZOElhY1pJekgwaElhQUpzT2N0SW5aMnBpcVFHeUlRTlhhSGNE?=
 =?utf-8?B?RkxybzZVdzhVMlBuQ3dpcHFwck8xYmIyOU1Rb2xveS9mN2Nhdk43aWwydmwx?=
 =?utf-8?B?MGtCRWxQM1llNFN1TFdUTGJoOWNMYU5NWlJEK1dLMlVHRWxBUWMxeDZDa2dl?=
 =?utf-8?B?QVJmL1RaWlVteEF4SmtHbitZbmh3bWI4aWtyN0xhVko4MEFEMGtsMUt3Wkky?=
 =?utf-8?B?REdnV2RTelBUOXJKd1h6aUtwUTJYOWN3RW1PSkp2NUowNnh2aElFQ2NTVW10?=
 =?utf-8?B?OGtseDU3WXZyeGZBWDRkaGpIbnhsRzB2VkJ5NDFGYjErbEFXSGlKc3E1dkdZ?=
 =?utf-8?B?U0xsVkRVYno3L3dsQ29Md3hlNDdlVkg2RjE3eVkrVU9xcVUwbzVLdUZwUEd0?=
 =?utf-8?B?VDJhcVdOTVoyY0s4Q3hkdkJkTGNlSFNvNGtPeGs5N1k3SWYvWERRMjQ3S3RC?=
 =?utf-8?B?bURnZ1h5Z0ZURnpGdndLOUJiN1RRS1lsbkx1WWhVWTJtYXM2Um91ZXB5dXZ1?=
 =?utf-8?B?NUZlRW1CUWdTQ3Q2WXAxcVhkNy9lVUpMTWMzVlE2d2VEOHE1ZmQ4d3ZYSnRL?=
 =?utf-8?B?QlN2RHk5RmUxL2FXSC9jQ3FIdTY0aFk5WDU3V0tuazhuc0IwOXJwMEpwdkN1?=
 =?utf-8?B?QXVETzdpYkpXU2xqNTFTTXQzMEFIaEoxSENmc3lXdldQdXdHZysyVW92OC9j?=
 =?utf-8?B?NndYZmZNUThJL2FQQlFSTUs3SFhoSWRiRFZWUXZsY3NPaGd1bmlGYXFCNWRG?=
 =?utf-8?B?aERodFJucnRSak1LaGhJRHFhU05la3FFcDEvUDB5VDZ3TXEvR0NUQ0pTQVlJ?=
 =?utf-8?B?MWxKc05iWWlkZmplQTRKWE9veEQ5aEowcFFxaVM2WFRPWGloUFhhaHJLYUFw?=
 =?utf-8?Q?2z1OMjv6GvrZc+y6tmmBAw1F9?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 26afec92-70fb-4548-3130-08dae3217bec
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2022 07:03:38.1348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UBAdgbA70BpPBYsCM0/+KFi9kkhv7LsDhu2b/WkpTUoFc+4rUV4fZ3v7C5UnfTUQOFLX+0zNXMdfkgmynlDa8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7361
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2022/12/21 12:10, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Monday, December 19, 2022 4:47 PM
>>
>> This avoids passing struct kvm * and struct iommufd_ctx * in multiple
>> functions. vfio_device_open() becomes to be a locked helper, while
>> vfio_device_open() still holds device->dev_set->lock itself.
> 
> Not sure what the words after 'while' intend to explain.

yeah, may remove it.

>> -int vfio_device_open(struct vfio_device *device,
>> -		     struct iommufd_ctx *iommufd, struct kvm *kvm)
>> +int vfio_device_open(struct vfio_device_file *df)
>>   {
>> -	int ret = 0;
>> +	struct vfio_device *device = df->device;
>> +
>> +	lockdep_assert_held(&device->dev_set->lock);
>>
>> -	mutex_lock(&device->dev_set->lock);
>>   	device->open_count++;
>>   	if (device->open_count == 1) {
>> -		ret = vfio_device_first_open(device, iommufd, kvm);
>> -		if (ret)
>> +		int ret;
>> +
>> +		ret = vfio_device_first_open(df);
>> +		if (ret) {
>>   			device->open_count--;
>> +			return ret;
>> +		}
>>   	}
>> -	mutex_unlock(&device->dev_set->lock);
>>
>> -	return ret;
>> +	return 0;
>>   }
> 
> I don't see the point of moving 'ret' into the inner block.

just want to make the function success oriented. :-)

-- 
Regards,
Yi Liu
