Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFF64EC5BB
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 15:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345630AbiC3NiP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 09:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237223AbiC3NiM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 09:38:12 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 241BB3B548
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 06:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648647387; x=1680183387;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XlOrzMjIgjga9Qogp/sf4WoZdQBlzvyEx62qpd/HivA=;
  b=nQp7yL+te7z5X4+vr3YAjFUdt6G0kNFFo6tnotBnfA+wfxBnTdFOLP8D
   2oxiadHSu5NeEtQAFWUxaT8sl2cD1gzfjJzQOBMFswAv9m67i4z16rYGT
   01x8LHgLklHTUcdpzmpTE81NH9GUnPPISeFUYuuwGQcENyBSZJmYLAxcY
   Z4Sbwwy5Ksr0T44moTb3yvqVp3Lb2kInz7v61IG3FyYIELEc5BFRbh8MM
   +JDbdaAT0H5BNPuwSZ4ht88f2jpnFwFN+vgmVLWNgKVZJBB0L98qin6zY
   5jlhpoPl2tRFx7W+zDt+DqiQn03xF+kBAgrNosFbJLRhc1yIN0WIxbVbK
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10301"; a="259516399"
X-IronPort-AV: E=Sophos;i="5.90,222,1643702400"; 
   d="scan'208";a="259516399"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 06:36:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,222,1643702400"; 
   d="scan'208";a="719977304"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 30 Mar 2022 06:36:26 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 30 Mar 2022 06:36:25 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 30 Mar 2022 06:36:25 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 30 Mar 2022 06:36:25 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 30 Mar 2022 06:36:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jc7NNTcxNUhPH9PGG3JID5E3SvXke7luZ2S+65qsV7R7COj1hgh44RxkDwN4WWiL0QiTlXQTFuQ10XDxFaYZS6TbIvT8cI9dYA+Duervkpg44hwb/pS014V/FsaCjHHjQei30ZXNqX4zsDp87OnowwZvx3CWZrrS7rcQFuX5o7NnsWue+fsvmPKWvAa4ZNexG9tA39MY2jIplf3/ccBgBY/K/e/sjwmmAYz52eX6s8EcGWjYtCsEapQ30JEWjgEZP40OhlJdgfVUqpvU1Me7rpRIGfk53QcAxu+xldj2qh6pSZjbB1g2BZVhVPnq2UDzbTT4FSRYiZdeqipwWVLBnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=txIBlilEltMW8RqivGs/wPvKlZgViV+oBKB1v0A9HVo=;
 b=BzuN2Fe8jwhT1QvXUVu3feeM5iAesjhn40PKzqQtT3uieKoZU9+BGs2jhG7oaRQNUN0IJvVTJc++AaH2or6YMWzLCStg/zISy+YXVbCG18QniDliAL9FJ8FQVo9aEfVkJNbx7vFOjLNRaxEr7DtVAygBKRIEci8OO131RQnivpziCD1r+lGmbo4SWAfbHbJ6er5z3hdsZFWhls1kqYF51T4jhyh40R5veWv+ZQTUsMi7hG2silh8DP9qRnAidr4Cfy7225/e770273RaSNOr4YBPIf5vdc3rfoXooZ13TnGY1Rx+VaRrpfGDHyFynOhQ8V5rnww1gZQ7MXkzof5lBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by PH0PR11MB4904.namprd11.prod.outlook.com (2603:10b6:510:40::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Wed, 30 Mar
 2022 13:36:19 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::bc9d:6f72:8bb1:ca36]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::bc9d:6f72:8bb1:ca36%8]) with mapi id 15.20.5123.019; Wed, 30 Mar 2022
 13:36:19 +0000
Message-ID: <cf303486-fd80-591c-f9a4-d39591c7d0b8@intel.com>
Date:   Wed, 30 Mar 2022 21:35:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [PATCH RFC 08/12] iommufd: IOCTLs for the io_pagetable
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        <iommu@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        "Kevin Tian" <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        "Shameerali Kolothum Thodi" <shameerali.kolothum.thodi@huawei.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
References: <8-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <8-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR02CA0170.apcprd02.prod.outlook.com
 (2603:1096:201:1f::30) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15a29cba-35e6-444a-0beb-08da125245eb
X-MS-TrafficTypeDiagnostic: PH0PR11MB4904:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <PH0PR11MB4904981A908CDFAC475D24E9C31F9@PH0PR11MB4904.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UMAkcNFmpn9xoyu7GCZ5BAMRjSs9lIfjmAVTTR7iq4Gx647K9QluehHhyyyV9pYhkJGZ9fHqpXt4nNE58bhKme+5O7QJ6jrLoMhbyvVZahMKjTx3+PYXQwyJuNsVh0Eu6kateCZpoN22pic8/FP+h39H7hv9u3uMFt3tCJbYI+fnSB5xO80ianJZM3G7jRvChLtIg4TA88BhbyosbIx6s+D4imp5w9UJQn6U6VMGpMyPeuTgT7X/tLkrGoDZjK8kyaQU2+9UmLpKUK2YrCmnLJphrD/NgfU/BgaIFsIFLjTvEJw9uAipKDqdSKYIraq7hQDVMkI1odmtdcbtnPh+k/zEc+hPiELwud4n+4DdMoKZvHLyGu3DrFqJn5H4mGw3XJuWYBERnyTIbpT9KsyubHpZ7Z2GX9dXn7DJKGX+6HpgEAiWEIFB/ral0ndeB92AhUd7gx0QcQ99RgfkTNY6XGsXiDZH6W9wFpeMJMvFt8TBlW9vE1fNZ1aoD5uxnoZK46PWkDlCVJknZHNNj7F8GlWdrBkv/axBVoPNsBhchVjGRvICi40BL4NU/BKfjXY3meAzPWnZGFmWjmJXhyW/KtjVMAM23lfxVsM3f1WtpaQYACXsOa9wVSWHOf2LA+LPepjfzGwKUlwgpcD35AzSnmBaymLVaCM734GM5zjDXfr08Cw9GjOJmB9Lo0LpUjGya4nWeXlw/ZY8o60UTGLkOW5SRKvRcYpX4xzoSQZ9UXqYNBh63ibR/WekBj14YSrg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7416002)(30864003)(54906003)(53546011)(5660300002)(508600001)(6506007)(66556008)(6666004)(66476007)(66946007)(6486002)(8936002)(6916009)(316002)(36756003)(6512007)(82960400001)(26005)(86362001)(83380400001)(186003)(4326008)(2906002)(31696002)(8676002)(31686004)(38100700002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q2IrM040Ri9kaEt1dzBoVEh4M2ZBTWp1RDR4ZTQrY2trenp4bVcxTEdLZjlR?=
 =?utf-8?B?VjdiZFhaRmE2QXQxM1Z0THFsZ01rU2hZa2thUFJBUys1d1VLRXdRSHRjUnRj?=
 =?utf-8?B?eWFPOW14bjZEa3RkaGVlSzdhWWpwWkx3eHB4MUROZVhYQkJkU2ZqejN0L1ZV?=
 =?utf-8?B?R216aFBpZ3UrRWFVMWQySUNYdytPd0VlMENMaXBvZ2E2NjgxbGlCZXNvWnpi?=
 =?utf-8?B?WXpuYlZRczhTdW9ZVkFEamZhakpONU9sYU1XbEZ2S3pXeUovUUpxd1lOYjR4?=
 =?utf-8?B?N1YxUkhQbHlMdUhCVldkczRLMEdaMm82eUdoeEVWd0xqMi96UEs0aDg3Slh6?=
 =?utf-8?B?MUJ1em41V0pubk1QSWsrbHJQRHdpSmU2SGo3TTNqcEZZelg2WVFKdHV0WGFo?=
 =?utf-8?B?WjA0QUd2Q2o1V0hEUkw1aGZsbiszdFFmcVM0aFJoUGYxM0NYUFJjd3JVZEhn?=
 =?utf-8?B?cGtvaXkxM0VmVjFHSXZCQjhUcmVyVjZOdUVLVVZHUjlLTWZvQTc5MEUyNzdw?=
 =?utf-8?B?bGJCaFQ2OUNubldmd2RwZEhiK1Zwa0ZGWERxZEFodnFIMytvUy9acTdOYlR1?=
 =?utf-8?B?TWVuWVZ6L1FwcnpxVEpsN0c0ZHIwQlBLUFdtTHNqTXpIWjlCRHFvb0RUN1ZQ?=
 =?utf-8?B?TXVMUU9oUWJ3c0tVeTVjT1RtelE3MXlicWlvV1Y1bnFDVndqWDQzWS81dDVF?=
 =?utf-8?B?RXVrSXl0L05LRi9kaEgxbG4vT2lOZEd3WVFnbFZpTDhWR2txTkIrc3ZmSXRq?=
 =?utf-8?B?V3Z0S0pUREExWkxxTjdRZGRUbmkrV2RaaVN2cERkL0s5Rndwamx4YkhFUXhV?=
 =?utf-8?B?R1RJaXVJeWhBQXRob3FWQnpKVFlhVGJ3TUxHcHgyejRRaVVTL2thWW1iQ3FZ?=
 =?utf-8?B?RUFyamtmL0lrQm5TVnlHdVpDVmJ0ZmpyQ0V4VWMyVUEya3Uya2kvU0ZoL00x?=
 =?utf-8?B?YXNvMWd0Rit3a3VTYTkyREtPOTUzME9COENLeUZwd1VSK21qUTk0WWJPZVp1?=
 =?utf-8?B?QUNQN3IxSzZaZDlpYXovVlozRUkrbjJtV0FzRzVxRmZrMzhSNEVvR0l4M05w?=
 =?utf-8?B?SEtETHd6Mjd0WXV1REwzemZEcVdMNTg2djFERy9peTQwZTFIbDkyKzFsa21h?=
 =?utf-8?B?bGR0b3AxSjhLUHpQK0kreXhxNTBiWWRtZDg4UElneU1CMEdNeVdqbHJnY3Fu?=
 =?utf-8?B?V3pYYWtUam5SUHhkVEJ1TkcxYXUwUCtYcENXSWNyZjZ4R0FUdCsyaWx0dlgz?=
 =?utf-8?B?Y3ltYWs3QWFJcUsxS3dQOHlPaWZQRnZ5OCtKaS9LOGZTc2E3RE1ZVmIvUzgr?=
 =?utf-8?B?dlRqOUtBaktncEQzVHJUV1lOd3R4YXczSktYZ0lDTlZxRUdrcENpYmhZK0Vo?=
 =?utf-8?B?S0ZPQ1daZkV1L2U0cWlIeFNVaFpRQVZRcG1PcUs2WndoSFRxT1FLTURGNDNY?=
 =?utf-8?B?NCsrWTRPaWxoT2h6bTE5TFlyUnl3OWI5Qy9GUHJYdldUancrRW5ZM1FYQ0ZD?=
 =?utf-8?B?ZmRRa09mMjBuUXVIZ1JFZWNtQVBnVVhBbjNlcmZpemRtWlh5ZUVyVXh0SUMx?=
 =?utf-8?B?d0IwY3pBT01NK25qTE9EVHVwZXBzS2VsL1NoS3FLVHdjMm5ZbUlFWkUvMEI2?=
 =?utf-8?B?NHZ0akZQM3dFb2RKWmhlT2JQUHdYN2xheGUvdEswamxmL1NhQ0wxeEtvUnVl?=
 =?utf-8?B?akhUdlRncGxIWEJiRERTOTNFWm8xYkRMdFB1ZXpLNnlNQWxoUDZ6RDhaMlU1?=
 =?utf-8?B?bkx5RDd4R2UyMmNKbjBaejBZaWZleXAxUlBXelNYSXQvZ0NaN1c1NE5UbzE3?=
 =?utf-8?B?SllkYUlDbU9ZTFFNY2FySnBaVjZhamJDT2xsYjR1VVc5d29sVmNQOEttcTNa?=
 =?utf-8?B?cm0yYXI3bGxCKytiN3N0bjlVWmp2WjBwdGlEMHlPL2dTZmI1QTd4S1pmNEFh?=
 =?utf-8?B?K0tWVUpsN2w4VUZjQ056OWFRd1ZIWFd1bTRoeFVhRldTTzZ5U05wdGJvTU5G?=
 =?utf-8?B?aituUmxqYmlCT3dwTXJlcXJOQTdTdFdERmpqajh6d1N4SVVoUDExbHV6bEQy?=
 =?utf-8?B?RDNLU3ZMMnVrcjB1NUhpSFZQblY1eXB2TTJGa3ZNWVpXbXVlcFhPRGI2MW9x?=
 =?utf-8?B?RWVRcXFEWU9jYmxudFJ2MURVdGFhbUpmWGtpVGhUam9paFBwaEVzaTkzdUw3?=
 =?utf-8?B?Q2hYcnpsR3lKS0hIMDJXeEU4akU2dVFMWXE5aUhCNDRXYTFJS2RxendodXlk?=
 =?utf-8?B?SkxtN3c1emxsSHlTNlZ1dXRsSnVXdEVvbEU5dG1sVWZwYTZnd0dpaDl2WU8z?=
 =?utf-8?B?RnFwZkhKWk5KWnJBZ25mSFI5WEZUMXJMdUNPNkJLVTRqZnRGYU9lZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 15a29cba-35e6-444a-0beb-08da125245eb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 13:36:19.7403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fz4v5GigqERd06BcL3n1Uxw5atShnFxTRFBFGaP+hxw158qYL8u7ABc57OHP2CNqE+G+aD+9zAqnQ95FN+PO0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4904
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 2022/3/19 01:27, Jason Gunthorpe wrote:
> Connect the IOAS to its IOCTL interface. This exposes most of the
> functionality in the io_pagetable to userspace.
> 
> This is intended to be the core of the generic interface that IOMMUFD will
> provide. Every IOMMU driver should be able to implement an iommu_domain
> that is compatible with this generic mechanism.
> 
> It is also designed to be easy to use for simple non virtual machine
> monitor users, like DPDK:
>   - Universal simple support for all IOMMUs (no PPC special path)
>   - An IOVA allocator that considerds the aperture and the reserved ranges
>   - io_pagetable allows any number of iommu_domains to be connected to the
>     IOAS
> 
> Along with room in the design to add non-generic features to cater to
> specific HW functionality.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/iommufd/Makefile          |   1 +
>   drivers/iommu/iommufd/ioas.c            | 248 ++++++++++++++++++++++++
>   drivers/iommu/iommufd/iommufd_private.h |  27 +++
>   drivers/iommu/iommufd/main.c            |  17 ++
>   include/uapi/linux/iommufd.h            | 132 +++++++++++++
>   5 files changed, 425 insertions(+)
>   create mode 100644 drivers/iommu/iommufd/ioas.c
> 
> diff --git a/drivers/iommu/iommufd/Makefile b/drivers/iommu/iommufd/Makefile
> index b66a8c47ff55ec..2b4f36f1b72f9d 100644
> --- a/drivers/iommu/iommufd/Makefile
> +++ b/drivers/iommu/iommufd/Makefile
> @@ -1,6 +1,7 @@
>   # SPDX-License-Identifier: GPL-2.0-only
>   iommufd-y := \
>   	io_pagetable.o \
> +	ioas.o \
>   	main.o \
>   	pages.o
>   
> diff --git a/drivers/iommu/iommufd/ioas.c b/drivers/iommu/iommufd/ioas.c
> new file mode 100644
> index 00000000000000..c530b2ba74b06b
> --- /dev/null
> +++ b/drivers/iommu/iommufd/ioas.c
> @@ -0,0 +1,248 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES
> + */
> +#include <linux/interval_tree.h>
> +#include <linux/iommufd.h>
> +#include <linux/iommu.h>
> +#include <uapi/linux/iommufd.h>
> +
> +#include "io_pagetable.h"
> +
> +void iommufd_ioas_destroy(struct iommufd_object *obj)
> +{
> +	struct iommufd_ioas *ioas = container_of(obj, struct iommufd_ioas, obj);
> +	int rc;
> +
> +	rc = iopt_unmap_all(&ioas->iopt);
> +	WARN_ON(rc);
> +	iopt_destroy_table(&ioas->iopt);
> +}
> +
> +struct iommufd_ioas *iommufd_ioas_alloc(struct iommufd_ctx *ictx)
> +{
> +	struct iommufd_ioas *ioas;
> +	int rc;
> +
> +	ioas = iommufd_object_alloc(ictx, ioas, IOMMUFD_OBJ_IOAS);
> +	if (IS_ERR(ioas))
> +		return ioas;
> +
> +	rc = iopt_init_table(&ioas->iopt);
> +	if (rc)
> +		goto out_abort;
> +	return ioas;
> +
> +out_abort:
> +	iommufd_object_abort(ictx, &ioas->obj);
> +	return ERR_PTR(rc);
> +}
> +
> +int iommufd_ioas_alloc_ioctl(struct iommufd_ucmd *ucmd)
> +{
> +	struct iommu_ioas_alloc *cmd = ucmd->cmd;
> +	struct iommufd_ioas *ioas;
> +	int rc;
> +
> +	if (cmd->flags)
> +		return -EOPNOTSUPP;
> +
> +	ioas = iommufd_ioas_alloc(ucmd->ictx);
> +	if (IS_ERR(ioas))
> +		return PTR_ERR(ioas);
> +
> +	cmd->out_ioas_id = ioas->obj.id;
> +	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
> +	if (rc)
> +		goto out_table;
> +	iommufd_object_finalize(ucmd->ictx, &ioas->obj);
> +	return 0;
> +
> +out_table:
> +	iommufd_ioas_destroy(&ioas->obj);
> +	return rc;
> +}
> +
> +int iommufd_ioas_iova_ranges(struct iommufd_ucmd *ucmd)
> +{
> +	struct iommu_ioas_iova_ranges __user *uptr = ucmd->ubuffer;
> +	struct iommu_ioas_iova_ranges *cmd = ucmd->cmd;
> +	struct iommufd_ioas *ioas;
> +	struct interval_tree_span_iter span;
> +	u32 max_iovas;
> +	int rc;
> +
> +	if (cmd->__reserved)
> +		return -EOPNOTSUPP;
> +
> +	max_iovas = cmd->size - sizeof(*cmd);
> +	if (max_iovas % sizeof(cmd->out_valid_iovas[0]))
> +		return -EINVAL;
> +	max_iovas /= sizeof(cmd->out_valid_iovas[0]);
> +
> +	ioas = iommufd_get_ioas(ucmd, cmd->ioas_id);
> +	if (IS_ERR(ioas))
> +		return PTR_ERR(ioas);
> +
> +	down_read(&ioas->iopt.iova_rwsem);
> +	cmd->out_num_iovas = 0;
> +	for (interval_tree_span_iter_first(
> +		     &span, &ioas->iopt.reserved_iova_itree, 0, ULONG_MAX);
> +	     !interval_tree_span_iter_done(&span);
> +	     interval_tree_span_iter_next(&span)) {
> +		if (!span.is_hole)
> +			continue;
> +		if (cmd->out_num_iovas < max_iovas) {
> +			rc = put_user((u64)span.start_hole,
> +				      &uptr->out_valid_iovas[cmd->out_num_iovas]
> +					       .start);
> +			if (rc)
> +				goto out_put;
> +			rc = put_user(
> +				(u64)span.last_hole,
> +				&uptr->out_valid_iovas[cmd->out_num_iovas].last);
> +			if (rc)
> +				goto out_put;
> +		}
> +		cmd->out_num_iovas++;
> +	}
> +	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
> +	if (rc)
> +		goto out_put;
> +	if (cmd->out_num_iovas > max_iovas)
> +		rc = -EMSGSIZE;
> +out_put:
> +	up_read(&ioas->iopt.iova_rwsem);
> +	iommufd_put_object(&ioas->obj);
> +	return rc;
> +}
> +
> +static int conv_iommu_prot(u32 map_flags)
> +{
> +	int iommu_prot;
> +
> +	/*
> +	 * We provide no manual cache coherency ioctls to userspace and most
> +	 * architectures make the CPU ops for cache flushing privileged.
> +	 * Therefore we require the underlying IOMMU to support CPU coherent
> +	 * operation.
> +	 */
> +	iommu_prot = IOMMU_CACHE;
> +	if (map_flags & IOMMU_IOAS_MAP_WRITEABLE)
> +		iommu_prot |= IOMMU_WRITE;
> +	if (map_flags & IOMMU_IOAS_MAP_READABLE)
> +		iommu_prot |= IOMMU_READ;
> +	return iommu_prot;
> +}
> +
> +int iommufd_ioas_map(struct iommufd_ucmd *ucmd)
> +{
> +	struct iommu_ioas_map *cmd = ucmd->cmd;
> +	struct iommufd_ioas *ioas;
> +	unsigned int flags = 0;
> +	unsigned long iova;
> +	int rc;
> +
> +	if ((cmd->flags &
> +	     ~(IOMMU_IOAS_MAP_FIXED_IOVA | IOMMU_IOAS_MAP_WRITEABLE |
> +	       IOMMU_IOAS_MAP_READABLE)) ||
> +	    cmd->__reserved)
> +		return -EOPNOTSUPP;
> +	if (cmd->iova >= ULONG_MAX || cmd->length >= ULONG_MAX)
> +		return -EOVERFLOW;
> +
> +	ioas = iommufd_get_ioas(ucmd, cmd->ioas_id);
> +	if (IS_ERR(ioas))
> +		return PTR_ERR(ioas);
> +
> +	if (!(cmd->flags & IOMMU_IOAS_MAP_FIXED_IOVA))
> +		flags = IOPT_ALLOC_IOVA;
> +	iova = cmd->iova;
> +	rc = iopt_map_user_pages(&ioas->iopt, &iova,
> +				 u64_to_user_ptr(cmd->user_va), cmd->length,
> +				 conv_iommu_prot(cmd->flags), flags);
> +	if (rc)
> +		goto out_put;
> +
> +	cmd->iova = iova;
> +	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
> +out_put:
> +	iommufd_put_object(&ioas->obj);
> +	return rc;
> +}
> +
> +int iommufd_ioas_copy(struct iommufd_ucmd *ucmd)
> +{
> +	struct iommu_ioas_copy *cmd = ucmd->cmd;
> +	struct iommufd_ioas *src_ioas;
> +	struct iommufd_ioas *dst_ioas;
> +	struct iopt_pages *pages;
> +	unsigned int flags = 0;
> +	unsigned long iova;
> +	unsigned long start_byte;
> +	int rc;
> +
> +	if ((cmd->flags &
> +	     ~(IOMMU_IOAS_MAP_FIXED_IOVA | IOMMU_IOAS_MAP_WRITEABLE |
> +	       IOMMU_IOAS_MAP_READABLE)))
> +		return -EOPNOTSUPP;
> +	if (cmd->length >= ULONG_MAX)
> +		return -EOVERFLOW;
> +
> +	src_ioas = iommufd_get_ioas(ucmd, cmd->src_ioas_id);
> +	if (IS_ERR(src_ioas))
> +		return PTR_ERR(src_ioas);
> +	/* FIXME: copy is not limited to an exact match anymore */
> +	pages = iopt_get_pages(&src_ioas->iopt, cmd->src_iova, &start_byte,
> +			       cmd->length);
> +	iommufd_put_object(&src_ioas->obj);
> +	if (IS_ERR(pages))
> +		return PTR_ERR(pages);
> +
> +	dst_ioas = iommufd_get_ioas(ucmd, cmd->dst_ioas_id);
> +	if (IS_ERR(dst_ioas)) {
> +		iopt_put_pages(pages);
> +		return PTR_ERR(dst_ioas);
> +	}
> +
> +	if (!(cmd->flags & IOMMU_IOAS_MAP_FIXED_IOVA))
> +		flags = IOPT_ALLOC_IOVA;
> +	iova = cmd->dst_iova;
> +	rc = iopt_map_pages(&dst_ioas->iopt, pages, &iova, start_byte,
> +			    cmd->length, conv_iommu_prot(cmd->flags), flags);
> +	if (rc) {
> +		iopt_put_pages(pages);
> +		goto out_put_dst;
> +	}
> +
> +	cmd->dst_iova = iova;
> +	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
> +out_put_dst:
> +	iommufd_put_object(&dst_ioas->obj);
> +	return rc;
> +}
> +
> +int iommufd_ioas_unmap(struct iommufd_ucmd *ucmd)
> +{
> +	struct iommu_ioas_unmap *cmd = ucmd->cmd;
> +	struct iommufd_ioas *ioas;
> +	int rc;
> +
> +	ioas = iommufd_get_ioas(ucmd, cmd->ioas_id);
> +	if (IS_ERR(ioas))
> +		return PTR_ERR(ioas);
> +
> +	if (cmd->iova == 0 && cmd->length == U64_MAX) {
> +		rc = iopt_unmap_all(&ioas->iopt);
> +	} else {
> +		if (cmd->iova >= ULONG_MAX || cmd->length >= ULONG_MAX) {
> +			rc = -EOVERFLOW;
> +			goto out_put;
> +		}
> +		rc = iopt_unmap_iova(&ioas->iopt, cmd->iova, cmd->length);
> +	}
> +
> +out_put:
> +	iommufd_put_object(&ioas->obj);
> +	return rc;
> +}
> diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
> index bcf08e61bc87e9..d24c9dac5a82a9 100644
> --- a/drivers/iommu/iommufd/iommufd_private.h
> +++ b/drivers/iommu/iommufd/iommufd_private.h
> @@ -96,6 +96,7 @@ static inline int iommufd_ucmd_respond(struct iommufd_ucmd *ucmd,
>   enum iommufd_object_type {
>   	IOMMUFD_OBJ_NONE,
>   	IOMMUFD_OBJ_ANY = IOMMUFD_OBJ_NONE,
> +	IOMMUFD_OBJ_IOAS,
>   	IOMMUFD_OBJ_MAX,
>   };
>   
> @@ -147,4 +148,30 @@ struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
>   			     type),                                            \
>   		     typeof(*(ptr)), obj)
>   
> +/*
> + * The IO Address Space (IOAS) pagetable is a virtual page table backed by the
> + * io_pagetable object. It is a user controlled mapping of IOVA -> PFNs. The
> + * mapping is copied into all of the associated domains and made available to
> + * in-kernel users.
> + */
> +struct iommufd_ioas {
> +	struct iommufd_object obj;
> +	struct io_pagetable iopt;
> +};
> +
> +static inline struct iommufd_ioas *iommufd_get_ioas(struct iommufd_ucmd *ucmd,
> +						    u32 id)
> +{
> +	return container_of(iommufd_get_object(ucmd->ictx, id,
> +					       IOMMUFD_OBJ_IOAS),
> +			    struct iommufd_ioas, obj);
> +}
> +
> +struct iommufd_ioas *iommufd_ioas_alloc(struct iommufd_ctx *ictx);
> +int iommufd_ioas_alloc_ioctl(struct iommufd_ucmd *ucmd);
> +void iommufd_ioas_destroy(struct iommufd_object *obj);
> +int iommufd_ioas_iova_ranges(struct iommufd_ucmd *ucmd);
> +int iommufd_ioas_map(struct iommufd_ucmd *ucmd);
> +int iommufd_ioas_copy(struct iommufd_ucmd *ucmd);
> +int iommufd_ioas_unmap(struct iommufd_ucmd *ucmd);
>   #endif
> diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
> index ae8db2f663004f..e506f493b54cfe 100644
> --- a/drivers/iommu/iommufd/main.c
> +++ b/drivers/iommu/iommufd/main.c
> @@ -184,6 +184,10 @@ static int iommufd_fops_release(struct inode *inode, struct file *filp)
>   }
>   
>   union ucmd_buffer {
> +	struct iommu_ioas_alloc alloc;
> +	struct iommu_ioas_iova_ranges iova_ranges;
> +	struct iommu_ioas_map map;
> +	struct iommu_ioas_unmap unmap;
>   	struct iommu_destroy destroy;
>   };
>   
> @@ -205,6 +209,16 @@ struct iommufd_ioctl_op {
>   	}
>   static struct iommufd_ioctl_op iommufd_ioctl_ops[] = {
>   	IOCTL_OP(IOMMU_DESTROY, iommufd_destroy, struct iommu_destroy, id),
> +	IOCTL_OP(IOMMU_IOAS_ALLOC, iommufd_ioas_alloc_ioctl,
> +		 struct iommu_ioas_alloc, out_ioas_id),
> +	IOCTL_OP(IOMMU_IOAS_COPY, iommufd_ioas_copy, struct iommu_ioas_copy,
> +		 src_iova),
> +	IOCTL_OP(IOMMU_IOAS_IOVA_RANGES, iommufd_ioas_iova_ranges,
> +		 struct iommu_ioas_iova_ranges, __reserved),
> +	IOCTL_OP(IOMMU_IOAS_MAP, iommufd_ioas_map, struct iommu_ioas_map,
> +		 __reserved),
> +	IOCTL_OP(IOMMU_IOAS_UNMAP, iommufd_ioas_unmap, struct iommu_ioas_unmap,
> +		 length),
>   };
>   
>   static long iommufd_fops_ioctl(struct file *filp, unsigned int cmd,
> @@ -270,6 +284,9 @@ struct iommufd_ctx *iommufd_fget(int fd)
>   }
>   
>   static struct iommufd_object_ops iommufd_object_ops[] = {
> +	[IOMMUFD_OBJ_IOAS] = {
> +		.destroy = iommufd_ioas_destroy,
> +	},
>   };
>   
>   static struct miscdevice iommu_misc_dev = {
> diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
> index 2f7f76ec6db4cb..ba7b17ec3002e3 100644
> --- a/include/uapi/linux/iommufd.h
> +++ b/include/uapi/linux/iommufd.h
> @@ -37,6 +37,11 @@
>   enum {
>   	IOMMUFD_CMD_BASE = 0x80,
>   	IOMMUFD_CMD_DESTROY = IOMMUFD_CMD_BASE,
> +	IOMMUFD_CMD_IOAS_ALLOC,
> +	IOMMUFD_CMD_IOAS_IOVA_RANGES,
> +	IOMMUFD_CMD_IOAS_MAP,
> +	IOMMUFD_CMD_IOAS_COPY,
> +	IOMMUFD_CMD_IOAS_UNMAP,
>   };
>   
>   /**
> @@ -52,4 +57,131 @@ struct iommu_destroy {
>   };
>   #define IOMMU_DESTROY _IO(IOMMUFD_TYPE, IOMMUFD_CMD_DESTROY)
>   
> +/**
> + * struct iommu_ioas_alloc - ioctl(IOMMU_IOAS_ALLOC)
> + * @size: sizeof(struct iommu_ioas_alloc)
> + * @flags: Must be 0
> + * @out_ioas_id: Output IOAS ID for the allocated object
> + *
> + * Allocate an IO Address Space (IOAS) which holds an IO Virtual Address (IOVA)
> + * to memory mapping.
> + */
> +struct iommu_ioas_alloc {
> +	__u32 size;
> +	__u32 flags;
> +	__u32 out_ioas_id;
> +};
> +#define IOMMU_IOAS_ALLOC _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_ALLOC)
> +
> +/**
> + * struct iommu_ioas_iova_ranges - ioctl(IOMMU_IOAS_IOVA_RANGES)
> + * @size: sizeof(struct iommu_ioas_iova_ranges)
> + * @ioas_id: IOAS ID to read ranges from
> + * @out_num_iovas: Output total number of ranges in the IOAS
> + * @__reserved: Must be 0
> + * @out_valid_iovas: Array of valid IOVA ranges. The array length is the smaller
> + *                   of out_num_iovas or the length implied by size.
> + * @out_valid_iovas.start: First IOVA in the allowed range
> + * @out_valid_iovas.last: Inclusive last IOVA in the allowed range
> + *
> + * Query an IOAS for ranges of allowed IOVAs. Operation outside these ranges is
> + * not allowed. out_num_iovas will be set to the total number of iovas
> + * and the out_valid_iovas[] will be filled in as space permits.
> + * size should include the allocated flex array.
> + */
> +struct iommu_ioas_iova_ranges {
> +	__u32 size;
> +	__u32 ioas_id;
> +	__u32 out_num_iovas;
> +	__u32 __reserved;
> +	struct iommu_valid_iovas {
> +		__aligned_u64 start;
> +		__aligned_u64 last;
> +	} out_valid_iovas[];
> +};
> +#define IOMMU_IOAS_IOVA_RANGES _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_IOVA_RANGES)
> +
> +/**
> + * enum iommufd_ioas_map_flags - Flags for map and copy
> + * @IOMMU_IOAS_MAP_FIXED_IOVA: If clear the kernel will compute an appropriate
> + *                             IOVA to place the mapping at
> + * @IOMMU_IOAS_MAP_WRITEABLE: DMA is allowed to write to this mapping
> + * @IOMMU_IOAS_MAP_READABLE: DMA is allowed to read from this mapping
> + */
> +enum iommufd_ioas_map_flags {
> +	IOMMU_IOAS_MAP_FIXED_IOVA = 1 << 0,
> +	IOMMU_IOAS_MAP_WRITEABLE = 1 << 1,
> +	IOMMU_IOAS_MAP_READABLE = 1 << 2,
> +};
> +
> +/**
> + * struct iommu_ioas_map - ioctl(IOMMU_IOAS_MAP)
> + * @size: sizeof(struct iommu_ioas_map)
> + * @flags: Combination of enum iommufd_ioas_map_flags
> + * @ioas_id: IOAS ID to change the mapping of
> + * @__reserved: Must be 0
> + * @user_va: Userspace pointer to start mapping from
> + * @length: Number of bytes to map
> + * @iova: IOVA the mapping was placed at. If IOMMU_IOAS_MAP_FIXED_IOVA is set
> + *        then this must be provided as input.
> + *
> + * Set an IOVA mapping from a user pointer. If FIXED_IOVA is specified then the
> + * mapping will be established at iova, otherwise a suitable location will be
> + * automatically selected and returned in iova.
> + */
> +struct iommu_ioas_map {
> +	__u32 size;
> +	__u32 flags;
> +	__u32 ioas_id;
> +	__u32 __reserved;
> +	__aligned_u64 user_va;
> +	__aligned_u64 length;
> +	__aligned_u64 iova;
> +};
> +#define IOMMU_IOAS_MAP _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_MAP)
> +
> +/**
> + * struct iommu_ioas_copy - ioctl(IOMMU_IOAS_COPY)
> + * @size: sizeof(struct iommu_ioas_copy)
> + * @flags: Combination of enum iommufd_ioas_map_flags
> + * @dst_ioas_id: IOAS ID to change the mapping of
> + * @src_ioas_id: IOAS ID to copy from

so the dst and src ioas_id are allocated via the same iommufd.
right? just out of curious, do you think it is possible that
the srs/dst ioas_ids are from different iommufds? In that case
may need to add src/dst iommufd. It's not needed today, just to
see if any blocker in kernel to support such copy. :-)

> + * @length: Number of bytes to copy and map
> + * @dst_iova: IOVA the mapping was placed at. If IOMMU_IOAS_MAP_FIXED_IOVA is
> + *            set then this must be provided as input.
> + * @src_iova: IOVA to start the copy
> + *
> + * Copy an already existing mapping from src_ioas_id and establish it in
> + * dst_ioas_id. The src iova/length must exactly match a range used with
> + * IOMMU_IOAS_MAP.
> + */
> +struct iommu_ioas_copy {
> +	__u32 size;
> +	__u32 flags;
> +	__u32 dst_ioas_id;
> +	__u32 src_ioas_id;
> +	__aligned_u64 length;
> +	__aligned_u64 dst_iova;
> +	__aligned_u64 src_iova;
> +};
> +#define IOMMU_IOAS_COPY _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_COPY)
> +
> +/**
> + * struct iommu_ioas_unmap - ioctl(IOMMU_IOAS_UNMAP)
> + * @size: sizeof(struct iommu_ioas_copy)
> + * @ioas_id: IOAS ID to change the mapping of
> + * @iova: IOVA to start the unmapping at
> + * @length: Number of bytes to unmap
> + *
> + * Unmap an IOVA range. The iova/length must exactly match a range
> + * used with IOMMU_IOAS_PAGETABLE_MAP, or be the values 0 & U64_MAX.
> + * In the latter case all IOVAs will be unmaped.
> + */
> +struct iommu_ioas_unmap {
> +	__u32 size;
> +	__u32 ioas_id;
> +	__aligned_u64 iova;
> +	__aligned_u64 length;
> +};
> +#define IOMMU_IOAS_UNMAP _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_UNMAP)
>   #endif

-- 
Regards,
Yi Liu
