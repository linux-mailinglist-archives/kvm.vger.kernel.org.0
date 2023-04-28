Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 144E66F1DEF
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 20:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346192AbjD1SYV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 14:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjD1SYT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 14:24:19 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019C23AB6;
        Fri, 28 Apr 2023 11:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682706259; x=1714242259;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=c8zgfVTn+MdON8tu8VHvNHZ8p33ZFn9NWwF55xrDXJw=;
  b=DYi4vhKSDOJr27+PrQPCTY91o3xexslfUGAVdCbx36c7lcEqs8RJ4o23
   ATEq6cjYPHRnOmFjhatFwSmmfi7VAZRdZecuMoahu+VoVysjZlk/k1s5q
   QE69iUBOQbxQpn5AS3+c4nNIeTwdBoAwfd7sUlkOjYTlrZNW4465eV7ew
   6DKs02juVaNX+of0kx2P+za2Q3AEjCdIp5zjOkYjd6Ygg584PhlofJAYB
   IdTv4JjP0BHh726C/0CH6TKvuuMXg2is8E/C1WPKGMyFYWOhYIA9IpDt9
   b9L9VWi8zeoLt3DlQKpAmci8rSRlDZOstFA1BW8NUNsu863WDL0YPdWC7
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="375819227"
X-IronPort-AV: E=Sophos;i="5.99,235,1677571200"; 
   d="scan'208";a="375819227"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 11:24:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="688925479"
X-IronPort-AV: E=Sophos;i="5.99,235,1677571200"; 
   d="scan'208";a="688925479"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 28 Apr 2023 11:24:08 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 28 Apr 2023 11:24:07 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 28 Apr 2023 11:24:07 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 28 Apr 2023 11:24:07 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 28 Apr 2023 11:24:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=be9415jjOAvNP9xxyELHqsf0lrbQXnq8BO76FUaw69ZwPJcoRBU3pa/eeGQ3Ww0mjq6V9GnY9zBJLGfO5o8wJtgtnL6OzSWy6A3TZuVwXLTcUXLJWffi7jud+phfJfRRrN0KgAuq1N2gc6z0soBRz2bUaiQeXV09XcMNPPVP9fRUwP5gtAM00ZSefvEgfcdkdrwzFWcpObz7O2ENOOkRbRCb/0IQKu1/U4yR7cGXxXAyIOGQg5iOKQZWp03AMeAObSiam7Kr9b0mBfrkcwvzexIxet9LOYEgdI4V9wmllJOii2OyiOoZKAzkpadUpVbClMnGDN1RDgk1pmM15bbtOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w6kJjHYa2tsxaHnVE4Pm2XEvDnHMUR3azUOGskNcTu0=;
 b=Rny61DgZWmtAtJkrANFLYzBMo662IOj30Y+W+tYL1xUjLZR0HGgDk8rpEf9nEuW7Az+uwVRPgsPW3OjUT4WtxcN8yV8yzqvr+AMUChg3CAReyfpfvE331Ob+FO0CX7wUdW0VKwNv6WTW4aRj4pMd84unLFVY4fLI7x7M1pXxzWkr7CWKjgLBLXUfwzLN9yWzDuJqtmqKvqC22hf/0lvauL+MYm3MQ15kJT23VycQg9nYs+tk1goTLnNo+pWUcml1uIrr/TyHwpwRAU0XV4FJ0Vnr7YnM5/C9f8FEuWwX9U/+cqAsB6R5RjcDaQxtyUfjMZIU5w33WJvJJ86oGQXJQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM4PR11MB7400.namprd11.prod.outlook.com (2603:10b6:8:100::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Fri, 28 Apr
 2023 18:24:05 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::591f:4873:fd80:9a6d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::591f:4873:fd80:9a6d%6]) with mapi id 15.20.6340.022; Fri, 28 Apr 2023
 18:24:05 +0000
Message-ID: <07a693e9-b926-6c25-ea55-8465410e214c@intel.com>
Date:   Fri, 28 Apr 2023 11:24:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH V4 03/11] vfio/pci: Prepare for dynamic interrupt context
 storage
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "darwi@linutronix.de" <darwi@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <cover.1682615447.git.reinette.chatre@intel.com>
 <6fcd4019e22931a97d962b6e657e74d6fd1049ba.1682615447.git.reinette.chatre@intel.com>
 <BN9PR11MB5276242E8D9F4C082E6D2CB68C6B9@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <BN9PR11MB5276242E8D9F4C082E6D2CB68C6B9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0278.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::13) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM4PR11MB7400:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d85a01a-66e7-42d4-a046-08db4815bfaf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PgD749iHdfBfSNYUOMq/C7OC567Jo6GnTrEQe/OxGesbcrGPr6AidVSacwu1SmxMBY3uG6d5PmdijW86Mr1EqUYdM4OiOGCo3Xq5JPcQ262+u1n2LX5gMS+dEP3gRnM+pbpUyvE5YHJk9T/wy7I5bW9TUNObS8qXYOvwYATHohWA0UBhHlWkiWFvb88eD3HZLqqqcL2Zyg7YxkLvUC5yzoj9nRZyZZave6qYplqnx7p++UvOqObO6hu7QqnU4gBuVnl3XvvpMvt4n/y2cqMGZgPqeJGnUcOEEqGFx+np9X4oSdVuV31uDWm5jtUzBFTxDDidKBJzAMgmpxNN2z5bCOdoBJCDWI6cTJ9/8XdeiSxdZiJXlvC//raMG6A9NLHn8Vt2+zB62Jtem7p2NUBqHjXhfH79iRIObqlKPsr61cMEfJ1t6TXMUxBeYQYZ5OXduOn03e/sfstQK15iHn79Q+n6TKHuoTmr9Lh25yC5peSdcQaDvfmS8rj9Zkz4EF0pWsJFEi9PSXJ7NfWTsFg3wuLf7KyBq/G9hKTrplCIqYiw+IP1lUL1alYIzJIV+VVkK7sV/MRnI0yhky+EOcVXuVDnfvWe1JOS6y2hqoKnCRFOTQjumEi6jEclWMATCHM1EbX+gK6eDacWnbgxi1IUcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(396003)(376002)(136003)(451199021)(41300700001)(2616005)(26005)(6506007)(53546011)(6512007)(5660300002)(82960400001)(8936002)(31686004)(83380400001)(44832011)(38100700002)(2906002)(4326008)(316002)(66556008)(66476007)(66946007)(54906003)(478600001)(86362001)(8676002)(36756003)(31696002)(186003)(110136005)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a09uZlBwdjdneXNmSjNlaGhmWkVzcUI0UHFFaWsvd3EydEVJWnRQN0R4UlhJ?=
 =?utf-8?B?cGFGRzJWYmc5M3pxSTcyYTR4MVhlY05uYnIwUlFuQm1PRUZRYkJ2SW1sclQz?=
 =?utf-8?B?K1cra3lKVzRsUm1GUkNBLzhlNGJKUTJVWDFRWWRqM1liZ1pGRFA3bzlHVnE5?=
 =?utf-8?B?ODdjQXJNY0V0S3ZpZWRRQWxpTVIvREwvRlhaMktmMGNZMGY3dW1FMkFjTm5W?=
 =?utf-8?B?cS9UaFB6QUlxQ09tQkdTeFJsc21kNDBNRk5Zb0VnbGdMeUl2cHcvU1ZIU3lx?=
 =?utf-8?B?dEhqVXZSckFKM0k0K2JTc1Bnb3N4TnAxcEJlV015VEoxSGF5Y0kzNHkwSEtL?=
 =?utf-8?B?S2g3dC9SMDlBZEhRVDdIZXUwaHNXRDBldzREemVLZHA3Y04yMElSc2ZCWkNU?=
 =?utf-8?B?Y01SeVR1VU1PdzBUS1NiWXpVditLSGJoa0hJd3ZPMVowTmpzNnpvVnZqcm9i?=
 =?utf-8?B?SmFwc2NsWjVXTDd1QkpoYUdzZG83TGFlempLRzhhdVM1UEdHK21WUytXOElk?=
 =?utf-8?B?T1VJR1J0VlMxUENETHNFODhQNURqd2orS1prVDZ0N2wvWUFSQUFHcFg2MlhV?=
 =?utf-8?B?dGxUMmxsZi9WTFpIKzN1dlZWTjk1d1Vaa2ZURFI2VDd2TVJadi8zQ0NjV1VJ?=
 =?utf-8?B?b2hsMWJ4YWNPTEdUQXNwQXFHTkFEc25wMEZIc0J6cW5HM1F0WWkzUHdjNGFB?=
 =?utf-8?B?SlVEdEM5YXBHNGtzaG93d1Z2eGVQSUEwQy90WjV1VnZjbllDeFZnZU5FMXZX?=
 =?utf-8?B?bzRkVEVjS0JJeXBZQ3pkZnZqYTgxOU1abWxhYjJnNStsQWRLYTJHdWU3SEpJ?=
 =?utf-8?B?L2RmMG9GU3J1VkhNWGhtbU9ST01qKzJWT2FsRDBES045OTBLUXpHakplRHox?=
 =?utf-8?B?dldtbmJQTHZBUG9Ya3RMWDdzL0NCVTB1RUlIVm1qenlTS05mekRoTGxwYVZE?=
 =?utf-8?B?WUQ2MjhBUW0wLzZHaVJTaGZNbVJFNzRWZ3l3NGdiWU1jUE5BMjNMdGN5a3VB?=
 =?utf-8?B?NVNRRm5yT2wvUWdkYUVSLzdmcjkyd1FjMmFqc2FUNHl4Z0JZSlJSVW1mZEFK?=
 =?utf-8?B?dGtzR04wZGFIbFJZaDgwdW9rWlhkeDRjRitJQkFKN1FiMlFvM3ZRUkhvQWxT?=
 =?utf-8?B?QmQxRjJwQmFkeXZmRkFJS2wvK014aGZOemVqMTNaZ1kySDUrdlg5TWtlS2V6?=
 =?utf-8?B?TU1wM0hxSGtsVTU5T1UxYm1Hbk5BRHd6Y2ZFS1cxSDh1TmkyamUyaWd4VGQz?=
 =?utf-8?B?YmpmemFobHBSSFlibFVTMEhHUm11T1QydTJqTk1PUVJNaCtlc3UybnZ1RFlM?=
 =?utf-8?B?eDJyS2RqcnA4M3Znd0ZRS3orMUZGNnFkQXAzNElGVE9EeFNOUmV6cllxQkV1?=
 =?utf-8?B?RS81RHRxY0RsKzBrL1B2Q25Ubkxvd3MxK0ZKeFRKMlBNQy96V1pNSnF3MXpk?=
 =?utf-8?B?VG1YN240bVdZcGpCQVlob21rQ0VjNVNqdkowS0Nmd0tTRnNsT1lYYkhKVlNp?=
 =?utf-8?B?TVNmNmxSQWNyeldLN0gwMU5WVFVUcXpxUVBwQjRsUTNJb0RvbU1JZ0svRFJR?=
 =?utf-8?B?YUdoeElBQUE5ay8xMEpsOFFlaEZXT1RFQzdIQi96N1VYaGREencwaldVc0hV?=
 =?utf-8?B?b3hYajVQMUpSd2lsRUxWYmdEV0FRaW9HN291a3ZUdXIwK3VTWGpCb3N6UmMz?=
 =?utf-8?B?ZFYwbHNKYUdXZVhaQm5QSHd6SlAzZGRBMGFVb1FNaTJZU0h3U3JZT2Eva2xK?=
 =?utf-8?B?NGNIbmlKbjBKK08rT1FNd0w2bWZHeG9wVkE2a1hqSHhqdVQ4ZVIxRmV6WTdl?=
 =?utf-8?B?VHpIRlIvT1Z2V1ozWFg2V3NoUTF4NDVnVWJUYW9Pc0ptT2owbFQ5THJSSERT?=
 =?utf-8?B?Wm4zYXlNdGQ1UXNFMklHYTlvcUU3ZWxsSDl0c0dTeEV4VjdscGJJSDczNDlL?=
 =?utf-8?B?NG1HeGhlZDJ3UHRjajlpZnA1MGFvYjRDUnZhRGNDUE14NW0wemh4R0gzUXJE?=
 =?utf-8?B?cUFlWUl3Wjc0OW1NakJNQmpHWnFVY0VEejY1UXNnd1NIblpBbFYzQWg0SlQv?=
 =?utf-8?B?Rk1TWEttbHUwUXdCOFJhUTR3QVloQW9mR0ZDbHhSTlFKQWN5aE1Ua2w4Y04z?=
 =?utf-8?B?U1Q4T2NidHpoVWVUbHRCd20xRW5GS2YvWDV5bkh5OENLam1lTFhzZk1MVkhR?=
 =?utf-8?B?Nmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d85a01a-66e7-42d4-a046-08db4815bfaf
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 18:24:05.4092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QthtavMVamdw2BHFIr5nLNvlIFLm2f6XQFOWkdJuD1I/4AD+5Hno4IqngYfi+0eMQl02oeI6FnXoX9sQDrtgflqCkZIynrSHVflc3wCT3Vc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7400
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kevin,

On 4/27/2023 11:33 PM, Tian, Kevin wrote:
>> From: Chatre, Reinette <reinette.chatre@intel.com>
>> Sent: Friday, April 28, 2023 1:36 AM
>>
>> @@ -55,17 +80,28 @@ static void vfio_send_intx_eventfd(void *opaque,
>> void *unused)
>>  {
>>  	struct vfio_pci_core_device *vdev = opaque;
>>
>> -	if (likely(is_intx(vdev) && !vdev->virq_disabled))
>> -		eventfd_signal(vdev->ctx[0].trigger, 1);
>> +	if (likely(is_intx(vdev) && !vdev->virq_disabled)) {
>> +		struct vfio_pci_irq_ctx *ctx;
>> +
>> +		ctx = vfio_irq_ctx_get(vdev, 0);
>> +		if (!ctx)
>> +			return;
> 
> if this error happens it implies a kernel bug since the same check
> has been done in vfio_intx_enable(). Then should be a WARN_ON().

Sure. Considering that if these are triggered it may result
in many instances, so perhaps WARN_ON_ONCE()?
 
> ditto for other intx functions which can be called only after intx
> is enabled.

It seems the instances in this category can be identified as the places
where the array contents is currently used without any checks.

I am planning on the following changes:

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index d8dae99cf6d9..b549f5c97cb8 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -92,7 +92,7 @@ static void vfio_send_intx_eventfd(void *opaque, void *unused)
 		struct vfio_pci_irq_ctx *ctx;
 
 		ctx = vfio_irq_ctx_get(vdev, 0);
-		if (!ctx)
+		if (WARN_ON_ONCE(!ctx))
 			return;
 		eventfd_signal(ctx->trigger, 1);
 	}
@@ -107,7 +107,7 @@ bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
 	bool masked_changed = false;
 
 	ctx = vfio_irq_ctx_get(vdev, 0);
-	if (!ctx)
+	if (WARN_ON_ONCE(!ctx))
 		return masked_changed;
 
 	spin_lock_irqsave(&vdev->irqlock, flags);
@@ -154,7 +154,7 @@ static int vfio_pci_intx_unmask_handler(void *opaque, void *unused)
 	int ret = 0;
 
 	ctx = vfio_irq_ctx_get(vdev, 0);
-	if (!ctx)
+	if (WARN_ON_ONCE(!ctx))
 		return ret;
 
 	spin_lock_irqsave(&vdev->irqlock, flags);
@@ -200,7 +200,7 @@ static irqreturn_t vfio_intx_handler(int irq, void *dev_id)
 	int ret = IRQ_NONE;
 
 	ctx = vfio_irq_ctx_get(vdev, 0);
-	if (!ctx)
+	if (WARN_ON_ONCE(!ctx))
 		return ret;
 
 	spin_lock_irqsave(&vdev->irqlock, flags);
@@ -264,7 +264,7 @@ static int vfio_intx_set_signal(struct vfio_pci_core_device *vdev, int fd)
 	int ret;
 
 	ctx = vfio_irq_ctx_get(vdev, 0);
-	if (!ctx)
+	if (WARN_ON_ONCE(!ctx))
 		return -EINVAL;
 
 	if (ctx->trigger) {
@@ -320,6 +320,7 @@ static void vfio_intx_disable(struct vfio_pci_core_device *vdev)
 
 	dev_dbg(&vdev->pdev->dev, "%s:%d Disabling INTx\n", __func__, __LINE__);
 	ctx = vfio_irq_ctx_get(vdev, 0);
+	WARN_ON_ONCE(!ctx);
 	if (ctx) {
 		vfio_virqfd_disable(&ctx->unmask);
 		vfio_virqfd_disable(&ctx->mask);
@@ -586,7 +587,7 @@ static int vfio_pci_set_intx_unmask(struct vfio_pci_core_device *vdev,
 		struct vfio_pci_irq_ctx *ctx = vfio_irq_ctx_get(vdev, 0);
 		int32_t fd = *(int32_t *)data;
 
-		if (!ctx)
+		if (WARN_ON_ONCE(!ctx))
 			return -EINVAL;
 		if (fd >= 0)
 			return vfio_virqfd_enable((void *) vdev,


