Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1ED7454D3
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 07:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbjGCF2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 01:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjGCF2M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 01:28:12 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618281B2
        for <kvm@vger.kernel.org>; Sun,  2 Jul 2023 22:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688362090; x=1719898090;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=g72DUMcoxSzSmOUHVHnHaSHn+lcLRX6/l0UBDir8piU=;
  b=GRZ/fdVbXd2oGc9E297+W75g74B9hzyOZSkTnLYogLikzJczNLfPrj7C
   CdNjZK8onk/jcWcCZBwCJlUrCn6aSYAZnPQ32C8678KIVfLIEIZ5IM8/x
   PZNbfi92EGdiRVv1DmTJvU2VJqT7dCMBgsTAz9F/ML2qdLTGabYdF9naI
   o4WB+a0r79UeB7Vr/k9NtaHOq6dlCXLwhZEcIueMfIsUEMYq5RtTfG7gk
   7BGpUGGqXjs9gVAgoTBCKRl2Jyzv8LHabgINA0E7XwC05NqpS8eAn0tcl
   6OtI0FN0Q7n2qX5XRtBRjhLvU7kQteSkXFPQ5MnAxkK14vlAvtjlNZRMR
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10759"; a="366277879"
X-IronPort-AV: E=Sophos;i="6.01,177,1684825200"; 
   d="scan'208";a="366277879"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2023 22:28:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10759"; a="721646405"
X-IronPort-AV: E=Sophos;i="6.01,177,1684825200"; 
   d="scan'208";a="721646405"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 02 Jul 2023 22:28:09 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sun, 2 Jul 2023 22:28:08 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sun, 2 Jul 2023 22:28:08 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Sun, 2 Jul 2023 22:28:08 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Sun, 2 Jul 2023 22:28:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hUNhc0zprNLAx1rpjAg0C1680+NsYqIcDugwvUUxwcBydrRS+uZe98WBYQLx9u8OYW0XwnDfqiDZAHVt+bDTZ2tia2y7WcKaaKQEOogoHBzFjDKf2pG+r6ZGEZtD8DA1CUmYp0TjvfDGO+38qK7QlEn6C2MrPUpNvC7ce1JKM/XbDQOWg8KiBtt+SvC7JGIcWxeaiyjiVe72IuUZO5fMZ2tqxomJy8u0N+2dqd3m2dpUqLU6x++5ELcHxg9vd/W8fr/P5aPuN7fJQVlqPBXAVa5/a8YXFCNMRe8ZfPz4RkhhPe8b62wNQfzOFeuwQKDA3XBnc82OI1gYiZ5BqSnPDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RH0Tbv6LwvtghFNhwwdMNE+MiB5zSUcUrVjIh6EetzE=;
 b=obWISLaCMx1ViEn7NJwusHVle45Nx0vq4MbWpPCOM2r5TNZ5qXs2sPqVn/5gyQ3gMjm5XAvh6ysKZJIKEtRg7IKoxLyc4hfNkAAzFbADzhbDB7QiI11vTfYpcQa3/aQLiMvSChO5uo5iiYTy7zAt8ye+lZDqqs6VYLdhsD1eHw54HxvkKNKQPrFduEo+sBBypT2rL0DdKaAeD92M2UXGV1vPSbiHDydP7slX9VATDLxuKsYofv3sEzDU1ZcjzIH5M49lselVZgh5oD+TsLDqRmySj9UUhM2dH1aDXd6AfGDuGT/JkIow0pB+9VJefBRjpBTV61A4YXGauzbhecBqfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA0PR11MB7838.namprd11.prod.outlook.com (2603:10b6:208:402::12)
 by SJ0PR11MB4863.namprd11.prod.outlook.com (2603:10b6:a03:2ae::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Mon, 3 Jul
 2023 05:28:01 +0000
Received: from IA0PR11MB7838.namprd11.prod.outlook.com
 ([fe80::6d31:14e5:d786:8329]) by IA0PR11MB7838.namprd11.prod.outlook.com
 ([fe80::6d31:14e5:d786:8329%5]) with mapi id 15.20.6544.024; Mon, 3 Jul 2023
 05:28:00 +0000
Message-ID: <ba8ccf89-6045-4fd7-02b9-308d50226251@intel.com>
Date:   Mon, 3 Jul 2023 13:27:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.12.0
Subject: Re: [Intel-wired-lan] [PATCH iwl-next V2 10/15] ice: save and restore
 TX queue head
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Liu, Lingyu" <lingyu.liu@intel.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20230621091112.44945-1-lingyu.liu@intel.com>
 <20230621091112.44945-11-lingyu.liu@intel.com> <ZJMLHSq9rjGIVS4V@nvidia.com>
 <BN9PR11MB5276EAA78AD4E3B7B7A93B168C27A@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   "Cao, Yahui" <yahui.cao@intel.com>
In-Reply-To: <BN9PR11MB5276EAA78AD4E3B7B7A93B168C27A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0034.apcprd02.prod.outlook.com
 (2603:1096:4:195::9) To IA0PR11MB7838.namprd11.prod.outlook.com
 (2603:10b6:208:402::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR11MB7838:EE_|SJ0PR11MB4863:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e322e60-4feb-4d4a-f347-08db7b86442a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ljIMqpGuT5P1BayE462pRw6dP+jeXmNkJH64BlkwR/cNIsykdGG3sTEtKfdCgDPncN3NYuImri7z1LblkHVLIlz4Cs+Da4jfAW/T+Bq+NTXccrY20nHt9bFEdr60JJmIqE/r2yd/Y4bxoRiWe44IgwFdjBhN/OiYkFCRTfF4WNbWDnNgAbVKXUOP28zT07svzC1o2eSKD1g/nbmtU1T4GoKTu8qA25+rzFnMw5p0+umXB31dktq7kIJKQEc0ozkXGDB+MGdMhMDqjbsdGyMh3/A4y/Vl1QBG9ZvnfI5J3L1BPBYC97v/mEjjLWc/JmYXCgZ5jUdycx+ZMQusa58Py7thZLDdhHQkCxyoVmB6Bqu0zWQjCGTLnPDLLFuo4D2SX7vWtP0PbzqeZ7yU/jIT/56VdbwoqXO0V+JaWkZS+N9uW2dm/mUuuhiJsEEMvMI6xINPFEfPsuFt0AW2WDUUA8KYEUp2ghjLRx2YTjdRWvH6+nRJ94DggeF9W8BXXpVSG5ptx05LqWxAs5xOZgNgR1vAbBKwB3V4Irq4Q+Dhvt2Rtn6WQOtth/C4IcpLGTVcjPrXck9SbSnDp8bcFaiPOtHtJNbx3hCwzN2GEKOafiet5nKyCh8qINSh++2W/eVDrlzTWamg3LWZojkCaMNi0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR11MB7838.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(39860400002)(136003)(396003)(451199021)(82960400001)(6506007)(53546011)(6512007)(316002)(66556008)(66476007)(66946007)(6636002)(4326008)(38100700002)(2616005)(83380400001)(186003)(26005)(478600001)(110136005)(54906003)(8936002)(8676002)(31686004)(5660300002)(2906002)(6486002)(31696002)(86362001)(41300700001)(6666004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TkZEVlRTWTVuSWEwU0YvU3JaZHhpWmZRajJGRFNJb0ZXZ0l4S3ZEU0MzUy9O?=
 =?utf-8?B?SFBvM0VuV1dudE0vNkxUbWVtdk9RVWlEWk9XUzd2OWJMbWhORVpsWFQ4bk45?=
 =?utf-8?B?VC84SWdwOGRWdlJjcHZtMTFrSGYwOERKQmxOSHl0WXVKa0hxcEd1RUlQamhC?=
 =?utf-8?B?d0xZMCs5ZFhMM2NnWlBUbXl1bm5CR2hpTmJOS0d0ZE9URnJXSmZBbGhyQnhF?=
 =?utf-8?B?Zlk2b3hHemd3Rmk4ajkzSFIrR2VMcGxVK3FxbG8zQ1Iyd2QxZTlpQVNKTFBS?=
 =?utf-8?B?d0JGN2ZRRzJtZHlEaXE1VUVwOGJBYTAvTHp5TjAvM3dhZUR3TFRvVmpCcW10?=
 =?utf-8?B?dWVQUE1UUHBmcGNFTXd1dWt0Ly9kN2Z4ODZvWTRLNVJrOExoUWV1M3B3VFJL?=
 =?utf-8?B?clpjVVNZUk94UmpMN0FkenYvUDUraVIwZVRzZlY4bTE4dEU0RS82U25qSlNi?=
 =?utf-8?B?VEQ4UllDZDJtcTM4Z245SDVBL3N5N1BpVXluNC9mbG9rNlBQcitZNGZVVUlj?=
 =?utf-8?B?S09SUVl2eU1MYmlTWHRUUTdxc3NVemJFU01Tc3laZVROb2tqZlhJbWdlWUwy?=
 =?utf-8?B?SFArSXdGTXZRclNBQ0o3VmF4b213TXZYVkNCZ2RqY3BESFRrOHpHZGRlUGFy?=
 =?utf-8?B?b3ZvOURXazN3ejdoVFFPeE5zQnJyYU5xcHBKNFNNMy9lejlIMlRkenVaNkUx?=
 =?utf-8?B?T0ZpSGtRTWJtcDgxRXBLaG8yY2tJdGRjWmtId0p6Mm45WmtvdHpJR3B3eVlz?=
 =?utf-8?B?OTB4NVptVVdBK21GRG5qdW95NHRrTkRxTGowSHhGQzRpaklPQnljNFRLbXJ5?=
 =?utf-8?B?RUxVbHpHUklwRVhQWHVDV1cxRVo0dmZCYmVEMGxpRUpOMTV0VHZNUkhrdkIw?=
 =?utf-8?B?QnI3dVQySkpEUnBLLzVqMWsrbm1jMDl2VXhnQkpYT0grWHRydUNWZUxqSjFT?=
 =?utf-8?B?eU81ZzF0TDhlZytVMmx1T2tBdGpuQWprZTczL0NnOEVUVjBsSHRhYXhVNW8z?=
 =?utf-8?B?cXlaUVpaQnBPalZIbjloN0JweDJZeUJiWGpYVmJlRjNSTm9KR2VicVBxc3Fx?=
 =?utf-8?B?OVZIYXBUSElpMlNoVlpVdk5KaG1ZTnVxclJjK2ludEd4SDR6eERsYndaY3NG?=
 =?utf-8?B?WjVuZW54ckRVZFk4b1IvSWRnOWQraWF3c0VGclE2QTJnai9TR3FUcjhTY2E5?=
 =?utf-8?B?bUlvTXJNMCtqT2czOU1IUFc2ek81VmdtbTcyQXcvMml4bEFTYk1mcWRTQWhL?=
 =?utf-8?B?RkRHbVpjUUVFSWQyai8xMjNZSTRWbGVNSUx0OVFLNFdkNnZCM3o3QXUyTG5G?=
 =?utf-8?B?ZEJ6a3ZpZGR3TU5VdEVGVUQ2SFlibEI5VXNuVDVyQ2VnQlB1S241TFdpWnNx?=
 =?utf-8?B?aWZtc3hjcnJVbFlqZFAxWlA2TkJpazNqMGZyN0MxOG94ekNKRjNHckN6dS9O?=
 =?utf-8?B?K2VFVGcrTGk0eGFUR2liWGxSNW5wNlUwS3kwYUlycFFySWxNYWhiTnNGdlBp?=
 =?utf-8?B?YmpLNHVRUGMvNk96ajRwcDJQTm1hUmtnRDNUQjRBZ0JxOHVBQjJ3eTBRV1Mv?=
 =?utf-8?B?ajhKR0NqLzBjcnMxNTdETGRiOS9Id2cwdFNZcjVvYVpZL1VJemZYZHlQZUZ4?=
 =?utf-8?B?K01XNFJya2VCeDBDMExHU0kxaE42M0pLNVZOdzg3dU9GWGJHeHE4amZpLy9X?=
 =?utf-8?B?ekFSN01wekltUm9xeHUwOE5hWUlybzdJOEc4SmpLZk9IYTF6Uk82RXBvbkZq?=
 =?utf-8?B?cmRyeUQ3ODFxRjdxVTAwWkRyOUg3WnE5U2JlZ0l5Nk9PNGI4dFNiNGY2cnFw?=
 =?utf-8?B?Zy9iOVNiYmxXdi9BSkZvRlM4aTM5dHpBS2NEaHFiakk2YjRBL2xidHpySmpT?=
 =?utf-8?B?cHlzSWZZL1RaUE9tRXNNYncxem44MVJvaUNWRzd5eCtlN0RCd0l1SUpQYktw?=
 =?utf-8?B?MW1CZnlsWjRVMU02OHp6MmNwd2NFdXhqS2JtMzAyOXFibWFWQkdKSDE4cTlH?=
 =?utf-8?B?ZVZubytUcUV4enplSmRPdjM1Qzgwek5hUkNLMmRaUm1lNG9ZQXl5My91WVNR?=
 =?utf-8?B?ajRUbEFuc1dTdElMVHVQcWE2Z3VIU3ltSGUxWTVOL0N4QjZENDc1Z0wrZEVn?=
 =?utf-8?Q?iax9+wbS5bslfUCdPtl6+O7vX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e322e60-4feb-4d4a-f347-08db7b86442a
X-MS-Exchange-CrossTenant-AuthSource: IA0PR11MB7838.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2023 05:28:00.6144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FTtb/j0a03v1/9/3t/2G6fSsOP8tCpiYkqeIONcUxVTamLKlFI0wEs6OrGLNTJhnu6DG//VdqiK1IYouYBycng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4863
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason & Kevin,

On 6/27/2023 2:55 PM, Tian, Kevin wrote:
>> From: Jason Gunthorpe <jgg@nvidia.com>
>> Sent: Wednesday, June 21, 2023 10:37 PM
>>
>> On Wed, Jun 21, 2023 at 09:11:07AM +0000, Lingyu Liu wrote:
>>> diff --git a/drivers/net/ethernet/intel/ice/ice_migration.c
>> b/drivers/net/ethernet/intel/ice/ice_migration.c
>>> index 2579bc0bd193..c2a83a97af05 100644
>>> --- a/drivers/net/ethernet/intel/ice/ice_migration.c
>>> +++ b/drivers/net/ethernet/intel/ice/ice_migration.c
>>> +static int
>>> +ice_migration_restore_tx_head(struct ice_vf *vf,
>>> +			      struct ice_migration_dev_state *devstate,
>>> +			      struct vfio_device *vdev)
>>> +{
>>> +	struct ice_tx_desc *tx_desc_dummy, *tx_desc;
>>> +	struct ice_vsi *vsi = ice_get_vf_vsi(vf);
>>> +	struct ice_pf *pf = vf->pf;
>>> +	u16 max_ring_len = 0;
>>> +	struct device *dev;
>>> +	int ret = 0;
>>> +	int i = 0;
>>> +
>>> +	dev = ice_pf_to_dev(vf->pf);
>>> +
>>> +	if (!vsi) {
>>> +		dev_err(dev, "VF %d VSI is NULL\n", vf->vf_id);
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	ice_for_each_txq(vsi, i) {
>>> +		if (!test_bit(i, vf->txq_ena))
>>> +			continue;
>>> +
>>> +		max_ring_len = max(vsi->tx_rings[i]->count, max_ring_len);
>>> +	}
>>> +
>>> +	if (max_ring_len == 0)
>>> +		return 0;
>>> +
>>> +	tx_desc = (struct ice_tx_desc *)kcalloc
>>> +		  (max_ring_len, sizeof(struct ice_tx_desc), GFP_KERNEL);
>>> +	tx_desc_dummy = (struct ice_tx_desc *)kcalloc
>>> +			(max_ring_len, sizeof(struct ice_tx_desc),
>> GFP_KERNEL);
>>> +	if (!tx_desc || !tx_desc_dummy) {
>>> +		dev_err(dev, "VF %d failed to allocate memory for tx
>> descriptors to restore tx head\n",
>>> +			vf->vf_id);
>>> +		ret = -ENOMEM;
>>> +		goto err;
>>> +	}
>>> +
>>> +	for (i = 0; i < max_ring_len; i++) {
>>> +		u32 td_cmd;
>>> +
>>> +		td_cmd = ICE_TXD_LAST_DESC_CMD |
>> ICE_TX_DESC_CMD_DUMMY;
>>> +		tx_desc_dummy[i].cmd_type_offset_bsz =
>>> +					ice_build_ctob(td_cmd, 0, SZ_256, 0);
>>> +	}
>>> +
>>> +	/* For each tx queue, we restore the tx head following below steps:
>>> +	 * 1. backup original tx ring descriptor memory
>>> +	 * 2. overwrite the tx ring descriptor with dummy packets
>>> +	 * 3. kick doorbell register to trigger descriptor writeback,
>>> +	 *    then tx head will move from 0 to tail - 1 and tx head is restored
>>> +	 *    to the place we expect.
>>> +	 * 4. restore the tx ring with original tx ring descriptor memory in
>>> +	 *    order not to corrupt the ring context.
>>> +	 */
>>> +	ice_for_each_txq(vsi, i) {
>>> +		struct ice_tx_ring *tx_ring = vsi->tx_rings[i];
>>> +		u16 *tx_heads = devstate->tx_head;
>>> +		u32 tx_head;
>>> +		int j;
>>> +
>>> +		if (!test_bit(i, vf->txq_ena) || tx_heads[i] == 0)
>>> +			continue;
>>> +
>>> +		if (tx_heads[i] >= tx_ring->count) {
>>> +			dev_err(dev, "saved tx ring head exceeds tx ring
>> count\n");
>>> +			ret = -EINVAL;
>>> +			goto err;
>>> +		}
>>> +		ret = vfio_dma_rw(vdev, tx_ring->dma, (void *)tx_desc,
>>> +				  tx_ring->count * sizeof(tx_desc[0]), false);
>>> +		if (ret) {
>>> +			dev_err(dev, "kvm read guest tx ring error: %d\n",
>>> +				ret);
>>> +			goto err;
>> You can't call VFIO functions from a netdev driver. All this code
>> needs to be moved into the varient driver.


Will move vfio_dma_rw() into vfio driver and passing callback function 
into netdev driver


>>
>> This design seems pretty wild to me, it doesn't seem too robust
>> against a hostile VM - eg these DMAs can all fail under guest control,
>> and then what?
> Yeah that sounds fragile.
>
> at least the range which will be overwritten in the resuming path should
> be verified in the src side. If inaccessible then the driver should fail the
> state transition immediately instead of letting it identified in the resuming
> path which is unrecoverable.
>
> btw I don't know how its spec describes the hw behavior in such situation.
> If the behavior is undefined when a hostile software deliberately causes
> DMA failures to TX queue then not restoring the queue head could also be
> an option to continue the migration in such scenario.


Thanks for the advice. Will check the vfio_dma_rw() correctness on the 
source side and
fail the state transition once function return failure.

When a hostile software deliberately causes DMA failure to TX queue, TX 
queue head will
remain to be the original value, which is 0 on destination side cases. 
In this case, I'll let
VM resumes by letting TX HEAD to stay with original value.


>
>> We also don't have any guarentees defined for the VFIO protocol about
>> what state the vIOMMU will be in prior to reaching RUNNING.
> This is a good point. Actually it's not just a gap on vIOMMU. it's kind
> of a dependency on IOMMUFD no matter the IOAS which the migrated
> device is currently attached to is GPA or GIOVA. The device state can
> be restored only after IOMMUFD is fully recovered and the device is
> re-attached to the IOAS.
>
> Need a way for migration driver to advocate such dependency to the user.


Since this part is new to me, may need further guidance on how to 
resolve the dependency from you and other community experts.

Thanks.


>
>> IDK, all of this looks like it is trying really hard to hackily force
>> HW that was never ment to support live migration to somehow do
>> something that looks like it.
>>
>> You really need to present an explanation in the VFIO driver comments
>> about how this whole scheme actually works and is secure and
>> functional against a hostile guest.
>>
> Agree. And please post the next version to the VFIO community to gain
> more attention.


I'll add more comments about the whole scheme and post next version to 
VFIO community.

Thank you Jason and Kevin for the valuable feedback.

Thanks.
Yahui.

