Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF8E053EED0
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 21:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbiFFToC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 15:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232917AbiFFTnz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 15:43:55 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2082.outbound.protection.outlook.com [40.107.100.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CAB0181;
        Mon,  6 Jun 2022 12:43:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QQ9z9Vi8yvM3nh8K+U/fQCRWV3f9grTCJrJ9bQMfYqXGRzE6D7Q2kyH844TjfeF1nv27M5krwppHn7Fw37Y3geH5ZCjXnYA2jbQ8A40mt86inlTh0s2OxSIWKifAq+ZDF38SFD9V1Lo+e+urbG2hJSkdI8OnkDAfDi2oWpbFp9jeOMemXv8V/Osof4CJRZJx/6dpAWo+voivTMbKn60WNqifZ+1gFK8KQgDE4vPX4Ao0Ai524F+TgM3TfOAPlAKBZN2BV/8ar6NhmYKFMF0bpjI2/EQ8hBmmW369pnndOlkOdFc3vPY2RR9Afx85+qo7hIrHJwgu9mnotJcmkZ37Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MCeocr8XW4ejpuP8yXb+pOh49Qf9wcWXxlFQenSMiRs=;
 b=j1qfivBdAtjm6WukCaDau2xOw720auHAlouq6s5kkDhbEXb26Jy+QJOwocXzXPBsf+URtc81Z9+ZusvfPHN4DJ1BcVYkpuEFyfVpEDdUmawvBWyzLUcj7SyMspd70cz3AozB2WHxaeA1kitiAt7kh21cQdNQuPibzMPHzQFfQ9M2OmpXz/+DMdiq4hEbIzDdXm0nvCR5AboVaaq14MFlgT6T2IEmkVWDYVhKoFtazDZdsE1zSzPnaSM+1/W5MkGtfPt+VwmOXZnJFWtsw52Elq6RC464/qEa5rsp5LBfXbnKoQIRt9TA5EXeRqSgJP8wIWIA75ZxgM168j/X6FHU+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MCeocr8XW4ejpuP8yXb+pOh49Qf9wcWXxlFQenSMiRs=;
 b=P+6sGRAyEuIbaLnMsiPab0PlmNzC1CU1YGBIk/c3+lH44J2kj5vvlWbz5tAIa8qR0pWAk7oN158bfP6cEAVlkK+ofvtXoHoH/VRIRX5j0Hh/zSTrAE8KoQV4YuQSdh8He8ZfwMjSrB8j7kg0/XT05XnQ9pcbCV3Gx6L4Y54uUx2UuRK/hRfJF4oXd62RZxLUGPlHM7jaZOPGrFwrVxoIuBPglur6VYLLn5RPf0uQaextZW0X5dHoA/88VTno/HiyPnH6PsbGjUE1EbPVNphP+KZKufFVsaqQnztag0wvbRLpxkwmk3d45ic7rx9Amup5WyWe6PAPsUrJ0t5OnJBSZQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18)
 by DM6PR12MB2889.namprd12.prod.outlook.com (2603:10b6:5:18a::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Mon, 6 Jun
 2022 19:43:47 +0000
Received: from MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14]) by MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14%6]) with mapi id 15.20.5314.019; Mon, 6 Jun 2022
 19:43:47 +0000
Message-ID: <6a8e7d00-0e7b-dc0c-2662-8aadd3930d8c@nvidia.com>
Date:   Tue, 7 Jun 2022 01:13:34 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v1 13/18] vfio/mdev: Consolidate all the device_api sysfs
 into the core code
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        intel-gvt-dev@lists.freedesktop.org
References: <20220602171948.2790690-1-farman@linux.ibm.com>
 <20220602171948.2790690-14-farman@linux.ibm.com>
X-Nvconfidentiality: Public
From:   Kirti Wankhede <kwankhede@nvidia.com>
In-Reply-To: <20220602171948.2790690-14-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0074.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ad::7) To MN2PR12MB4206.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: abf6be6a-5397-48d3-eebd-08da47f4df8a
X-MS-TrafficTypeDiagnostic: DM6PR12MB2889:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB2889F50994A6C6232E0B5305DCA29@DM6PR12MB2889.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 79srm63ELDUu8YnOVzRxFY/7qGuFAuWj8AgKaU9VIMUnfQIzyGMOPeUIPA2Hxc+IJb0pORbFAO70WBaM394ZnkHdTFFVE5EQiTbrLrKDEZnVfTvmgBSNx82DkcQZE+Fa63pIIqnojw6lvi6kH50NHjlvLRlDB9dfR1tngN3QfNGfBemZSmZjYYgTlEtyltoVVc78pAPby91nSveQM5M32K2cypbpOgjL/fsHsQ+CifsSuRW+9gCqLQAHG+cfsUIebk68Q8ekm69msYRL40jDLQWlThhzrUpdIhmKA/UIqKv0RdwHUjdYKvL1PzK58t0XQ8s+Qb05aNADA6XiXseUIB8G7wJAka+q25hxl5IfNJZA5NjVq9ELUW/22y3mzc5ynuFIV4JtMX96qur//qr/OGGN2jswZoZ34Tf0uDud9P9695UsQ4Hbz2eVLCUZcfdFnt/uGkgl0R5/MaqK0q0LkLcm1oVu41m6Or9YTjmC+VNG3cvgiLCoCvOwGKo6weoMWaPpqZX2ue5FgH2H5ImJthip/MCOK4P9dpxIPIBsd7cfjNe4bI8R7KG9PVdpBPyegfiK6VWppaQ+8bDfAC/2ErJn4ixEJOSxfh7AP1K3AtCE803bstFnTA+tSF07TaDY4Iqx+0+75FDPyjoZIvgqWoXcxrqlJ5fRTjU0HxuNSTS4Qvky4IRqjyNWvHN+bxJGJplnqT9tE7ru6gWEVMKoBzde5kQuDejV3GSFM6Ht1mTSJywLR8qT0m70c0s7JmaUWU2+5BmkBABQtIADErHrP6DtYUvKwzYauopYQ/do/EEVc6YqBLYCupFexUmI11Gi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4206.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(31696002)(38100700002)(83380400001)(6666004)(86362001)(966005)(508600001)(6486002)(2906002)(316002)(2616005)(186003)(110136005)(53546011)(54906003)(55236004)(6512007)(26005)(6506007)(5660300002)(36756003)(30864003)(8676002)(8936002)(4326008)(66946007)(66476007)(66556008)(31686004)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Zk1FZWxRTE5EZHpHVlBxRHd2WmtkQUJHQzU1V1FTMDNSREtoT01uK2p2Skpx?=
 =?utf-8?B?MWZDVERubzdNekRYT2UxQVlxeGxuQ2xGYjRyUkhzVHhkblBKdXF0eFNLZnJm?=
 =?utf-8?B?WkpWUWJ0UUNDZW1rclV6Sjh4K3BUMnpOWTRheFFoN3lLSUFySFQ3UnNzdmJO?=
 =?utf-8?B?ak92Sm4zK0YwSkZkdWJ0SWQ0bkZWYW9vWjVpUkhEbzEydkxSc056dTZBKzBF?=
 =?utf-8?B?SjNuNG9JYzBJZ1p0cmx6SjBCdUcxdStnNnJlZWlCTXVvckwxU09Ia29HVVR0?=
 =?utf-8?B?S3ZucGQ1N2NCMi9WN0pOT1JrSVlhUklsMmE0OEVnbkcvaEswYytDL1lGbXl1?=
 =?utf-8?B?VXhDaHpNTUxvM1RITUlzYktCajc1YkNSTll3QStReEZDZWJYdzBlcUdoaFpj?=
 =?utf-8?B?WG5HRk9KRzJOZUtCOFpGek14NHpidHZQRkx5MjZBWUp0T2JZaE0yaEZTanlp?=
 =?utf-8?B?ZHRHUFpkbnJKQTNEL1dkN2REY2ZwKzZDcjE3ZGlJN0Vpc2FQQ2dvYU9uaGMv?=
 =?utf-8?B?dUNCbnFRWmhZS0J1UnMxaFlkVldZZUxQTWJTUkFWa2xTb05FZmwyT2VaZC80?=
 =?utf-8?B?SFhRS0ZMZXRFeGUrTnN4WEpzRVcwdUV5WlFxYUt3ZFE5NjZtcTNIbEUzcnZB?=
 =?utf-8?B?VVdGQWlrU0hPMDVZbFVBZ0NwYnlkV1BPS1pmYnh3dHdtS2lxcDJMSFVMSjhr?=
 =?utf-8?B?TnM1ODNHdGpMS1puVisydlRLaTNwTEVJR0JqU1JwTzkrcVllcDRmNEhDQnYx?=
 =?utf-8?B?WFRXL3QzdEhjbmVCd3VaVmpPSkZWTU1hNWZvUDJyakRScmdjRWdUN3ZSalJ3?=
 =?utf-8?B?c2FuNGR2OE9UeElJZFdvamg4dHB3WHBwdjRvTkgyWmNBWXBFYmorN2RndUxI?=
 =?utf-8?B?dGRkWFVhdFZIdTN4RW5KZlZRTmM0Y29sS0pQWmVxUFZvdjBqRzdDUE5LNDVi?=
 =?utf-8?B?UEl1eUc5dWNqamhjRU9lUEFVMGF2UEtiTEhaa2JxSnd6eldPOWhjZGVBVFlQ?=
 =?utf-8?B?ZGt2ei9iZTZGVE5ySjFPcENUTU1xb09RbCtwVU92V2VWYytvYkRHZXVjWVc3?=
 =?utf-8?B?VDl6Ym10ZmlIRmYxM3JtMDNiRG5pOW5Zb2NkUlQwT2NiclV5a2FOYmxGbzhD?=
 =?utf-8?B?MFoxN05IWjE1RkVTL2ZGbmtRaFd1Z1lsOStaY0l3YlZBWTljeXprM3BFamhk?=
 =?utf-8?B?OVFIZmhJNGlub2tsOWF1REtTOThOMnB2cEdTdGdpY1d6TldDY3NuYW9oQndr?=
 =?utf-8?B?QktFMXVwTkxFUEt0SXRiVWRhYnRGeEdod1lPdmdpYkVTZ1RaLzhWQnNQZGFU?=
 =?utf-8?B?eldibGhJU2luWkUrREtWcmJuYlNBSnYwUWkyQ1FXZlhxSkl0Q0JGVHBIS1JR?=
 =?utf-8?B?TUpETU1aU2RLRWVPREZEVXY0M1Q2czZhVHl5Z09qazkvVU1jdnFoT0llc3Nz?=
 =?utf-8?B?WEhiWkhUVXdYUXk2TzhzQzNscThudEtTK0Y5eHV0MkNOT0hFRHduOG9DU1cr?=
 =?utf-8?B?Tzc0SmsyZ0dFcndISDFqKytON0w5RWl2dDd4Ti96ZkR6ejVRRFdzSjkrZzdE?=
 =?utf-8?B?a3NJVjBla2Z5YkowNXIwRWN2WmhpRXpybUVORmEvdXBUQUJBcUhxazkyU0Ji?=
 =?utf-8?B?R0tSZjNtVkJJcDdRNS93MVdEQ0dwdktXYzBrSHFlUzdyS2lYc1VFeHo1YnBJ?=
 =?utf-8?B?Y3MzREsvYkwyUUZSeWhrcmIrd0Y1MCtiNHJuSk9udXAwanFOZlJzazY1M285?=
 =?utf-8?B?WFc2cERIT0FEeE5TMEZVWWRzYzBsSmx1eitVWjdaMUNXUTV4aXNDck9KNXZX?=
 =?utf-8?B?Q05RUVRSd2pwV3JFY1RyaFl4VU1YdUNUa2NmaU9PODRraGhKdXRRaUliSWZi?=
 =?utf-8?B?d1M1RlltOWlHSEdiZFFBUjh3amlSZlhGMFNhZklHY0YzcXBDZ296NzZuMEox?=
 =?utf-8?B?TjhHaStESjQ1bXNQdFp6OWI3WUxUcnZaYU91WHdSN09NcDhQdlA2MHhjdE9E?=
 =?utf-8?B?UU0vNERLOUF5VjVHTFE4VjdnNHNRSUlxQUhveC9HWGRGWWVEcUpSZ3o4RzFs?=
 =?utf-8?B?WjUvYkRkMFI2c1pzc2l0bi81SEZIMVpJMnNSM2R3NHlOZkhDUzhYd0hDVWdy?=
 =?utf-8?B?VW80SXhFc1JPYzV5dS8rSGNmcUNYZFFBTWs2UUVybENZVFBEbk5FbC8vN3BZ?=
 =?utf-8?B?UDdCdXlBdGRiQVczc0pSN2k1dGdHR2crMkROTUcveVRYS2U0N3pFcXVBQTdF?=
 =?utf-8?B?U1QwSkFFZE5FejBmeFZ3Z1pwZ1B2WmdMamlwSlhrY0dnZWN6Y1hGSXpUbUYr?=
 =?utf-8?B?UFR5OWlvTGRpd1lWV0ZXVGllSmFVWU1La3N6TUFsa3hiWjdIWnltZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abf6be6a-5397-48d3-eebd-08da47f4df8a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4206.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 19:43:47.7487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KxuExR9h2liqCjQSf4u3X/f5qbkQjJrzIYq7QbTBUpkrpokp6WI7ZheHvkgWwYO/AXWaimdbN9Orzxqst+G6wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2889
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Reviewed By: Kirti Wankhede <kwankhede@nvidia.com>

On 6/2/2022 10:49 PM, Eric Farman wrote:
> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> Every driver just emits a static string, simply feed it through the ops
> and provide a standard sysfs show function.
> 
> Cc: Kirti Wankhede <kwankhede@nvidia.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Cc: Zhi Wang <zhi.a.wang@intel.com>
> Cc: Tony Krowiak <akrowiak@linux.ibm.com>
> Cc: Jason Herne <jjherne@linux.ibm.com>
> Cc: intel-gvt-dev@lists.freedesktop.org
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Link: https://lore.kernel.org/r/6-v3-57c1502c62fd+2190-ccw_mdev_jgg@nvidia.com/
> [farman: added Cc: tags]
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>   .../driver-api/vfio-mediated-device.rst       |  4 ++-
>   drivers/gpu/drm/i915/gvt/kvmgt.c              |  9 +------
>   drivers/s390/cio/vfio_ccw_ops.c               |  9 +------
>   drivers/s390/crypto/vfio_ap_ops.c             |  9 +------
>   drivers/vfio/mdev/mdev_core.c                 |  2 +-
>   drivers/vfio/mdev/mdev_sysfs.c                | 27 ++++++++++++++++---
>   include/linux/mdev.h                          |  7 ++---
>   samples/vfio-mdev/mbochs.c                    |  9 +------
>   samples/vfio-mdev/mdpy.c                      |  9 +------
>   samples/vfio-mdev/mtty.c                      | 10 +------
>   10 files changed, 36 insertions(+), 59 deletions(-)
> 
> diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
> index 9f26079cacae..f410a1cd98bb 100644
> --- a/Documentation/driver-api/vfio-mediated-device.rst
> +++ b/Documentation/driver-api/vfio-mediated-device.rst
> @@ -137,6 +137,7 @@ The structures in the mdev_parent_ops structure are as follows:
>   * mdev_attr_groups: attributes of the mediated device
>   * supported_config: attributes to define supported configurations
>   * device_driver: device driver to bind for mediated device instances
> +* device_api: String to pass through the sysfs file below
>   
>   The mdev_parent_ops also still has various functions pointers.  Theses exist
>   for historical reasons only and shall not be used for new drivers.
> @@ -225,7 +226,8 @@ Directories and files under the sysfs for Each Physical Device
>   * device_api
>   
>     This attribute should show which device API is being created, for example,
> -  "vfio-pci" for a PCI device.
> +  "vfio-pci" for a PCI device. The core code maintins this sysfs using the
> +  device_api member of mdev_parent_ops.
>   
>   * available_instances
>   
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 057ec4490104..752d7a1211e6 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -163,12 +163,6 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   	return sprintf(buf, "%u\n", num);
>   }
>   
> -static ssize_t device_api_show(struct mdev_type *mtype,
> -			       struct mdev_type_attribute *attr, char *buf)
> -{
> -	return sprintf(buf, "%s\n", VFIO_DEVICE_API_PCI_STRING);
> -}
> -
>   static ssize_t description_show(struct mdev_type *mtype,
>   				struct mdev_type_attribute *attr, char *buf)
>   {
> @@ -202,13 +196,11 @@ static ssize_t name_show(struct mdev_type *mtype,
>   }
>   
>   static MDEV_TYPE_ATTR_RO(available_instances);
> -static MDEV_TYPE_ATTR_RO(device_api);
>   static MDEV_TYPE_ATTR_RO(description);
>   static MDEV_TYPE_ATTR_RO(name);
>   
>   static struct attribute *gvt_type_attrs[] = {
>   	&mdev_type_attr_available_instances.attr,
> -	&mdev_type_attr_device_api.attr,
>   	&mdev_type_attr_description.attr,
>   	&mdev_type_attr_name.attr,
>   	NULL,
> @@ -1767,6 +1759,7 @@ static const struct attribute_group *intel_vgpu_groups[] = {
>   
>   static struct mdev_parent_ops intel_vgpu_ops = {
>   	.mdev_attr_groups       = intel_vgpu_groups,
> +	.device_api		= VFIO_DEVICE_API_PCI_STRING,
>   	.create			= intel_vgpu_create,
>   	.remove			= intel_vgpu_remove,
>   
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index 2afb8f13739f..6793c8b3c58b 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -66,13 +66,6 @@ static ssize_t name_show(struct mdev_type *mtype,
>   }
>   static MDEV_TYPE_ATTR_RO(name);
>   
> -static ssize_t device_api_show(struct mdev_type *mtype,
> -			       struct mdev_type_attribute *attr, char *buf)
> -{
> -	return sprintf(buf, "%s\n", VFIO_DEVICE_API_CCW_STRING);
> -}
> -static MDEV_TYPE_ATTR_RO(device_api);
> -
>   static ssize_t available_instances_show(struct mdev_type *mtype,
>   					struct mdev_type_attribute *attr,
>   					char *buf)
> @@ -86,7 +79,6 @@ static MDEV_TYPE_ATTR_RO(available_instances);
>   
>   static struct attribute *mdev_types_attrs[] = {
>   	&mdev_type_attr_name.attr,
> -	&mdev_type_attr_device_api.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
> @@ -644,5 +636,6 @@ struct mdev_driver vfio_ccw_mdev_driver = {
>   const struct mdev_parent_ops vfio_ccw_mdev_ops = {
>   	.owner			= THIS_MODULE,
>   	.device_driver		= &vfio_ccw_mdev_driver,
> +	.device_api		= VFIO_DEVICE_API_CCW_STRING,
>   	.supported_type_groups  = mdev_type_groups,
>   };
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 6e08d04b605d..838b1a3eac8a 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -530,17 +530,9 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   
>   static MDEV_TYPE_ATTR_RO(available_instances);
>   
> -static ssize_t device_api_show(struct mdev_type *mtype,
> -			       struct mdev_type_attribute *attr, char *buf)
> -{
> -	return sprintf(buf, "%s\n", VFIO_DEVICE_API_AP_STRING);
> -}
> -
> -static MDEV_TYPE_ATTR_RO(device_api);
>   
>   static struct attribute *vfio_ap_mdev_type_attrs[] = {
>   	&mdev_type_attr_name.attr,
> -	&mdev_type_attr_device_api.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
> @@ -1501,6 +1493,7 @@ static struct mdev_driver vfio_ap_matrix_driver = {
>   static const struct mdev_parent_ops vfio_ap_matrix_ops = {
>   	.owner			= THIS_MODULE,
>   	.device_driver		= &vfio_ap_matrix_driver,
> +	.device_api		= VFIO_DEVICE_API_AP_STRING,
>   	.supported_type_groups	= vfio_ap_mdev_type_groups,
>   };
>   
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index b314101237fe..c3018e8e6d32 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -129,7 +129,7 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
>   	char *envp[] = { env_string, NULL };
>   
>   	/* check for mandatory ops */
> -	if (!ops || !ops->supported_type_groups)
> +	if (!ops || !ops->supported_type_groups || !ops->device_api)
>   		return -EINVAL;
>   	if (!ops->device_driver && (!ops->create || !ops->remove))
>   		return -EINVAL;
> diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
> index f5cf1931c54e..d4b99440d19e 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -74,9 +74,30 @@ static ssize_t create_store(struct mdev_type *mtype,
>   
>   	return count;
>   }
> -
>   static MDEV_TYPE_ATTR_WO(create);
>   
> +static ssize_t device_api_show(struct mdev_type *mtype,
> +			       struct mdev_type_attribute *attr, char *buf)
> +{
> +	return sysfs_emit(buf, "%s\n", mtype->parent->ops->device_api);
> +}
> +static MDEV_TYPE_ATTR_RO(device_api);
> +
> +static struct attribute *mdev_types_std_attrs[] = {
> +	&mdev_type_attr_create.attr,
> +	&mdev_type_attr_device_api.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group mdev_type_std_group = {
> +	.attrs = mdev_types_std_attrs,
> +};
> +
> +static const struct attribute_group *mdev_type_groups[] = {
> +	&mdev_type_std_group,
> +	NULL,
> +};
> +
>   static void mdev_type_release(struct kobject *kobj)
>   {
>   	struct mdev_type *type = to_mdev_type(kobj);
> @@ -123,7 +144,7 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
>   		return ERR_PTR(ret);
>   	}
>   
> -	ret = sysfs_create_file(&type->kobj, &mdev_type_attr_create.attr);
> +	ret = sysfs_create_groups(&type->kobj, mdev_type_groups);
>   	if (ret)
>   		goto attr_create_failed;
>   
> @@ -144,7 +165,7 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
>   attrs_failed:
>   	kobject_put(type->devices_kobj);
>   attr_devices_failed:
> -	sysfs_remove_file(&type->kobj, &mdev_type_attr_create.attr);
> +	sysfs_remove_groups(&type->kobj, mdev_type_groups);
>   attr_create_failed:
>   	kobject_del(&type->kobj);
>   	kobject_put(&type->kobj);
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index a5788f592817..14655215417b 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -36,6 +36,7 @@ struct device *mtype_get_parent_dev(struct mdev_type *mtype);
>    *
>    * @owner:		The module owner.
>    * @device_driver:	Which device driver to probe() on newly created devices
> + * @device_api:		String to return for the device_api sysfs
>    * @dev_attr_groups:	Attributes of the parent device.
>    * @mdev_attr_groups:	Attributes of the mediated device.
>    * @supported_type_groups: Attributes to define supported types. It is mandatory
> @@ -80,6 +81,7 @@ struct device *mtype_get_parent_dev(struct mdev_type *mtype);
>   struct mdev_parent_ops {
>   	struct module   *owner;
>   	struct mdev_driver *device_driver;
> +	const char *device_api;
>   	const struct attribute_group **dev_attr_groups;
>   	const struct attribute_group **mdev_attr_groups;
>   	struct attribute_group **supported_type_groups;
> @@ -108,11 +110,6 @@ struct mdev_type_attribute {
>   			 size_t count);
>   };
>   
> -#define MDEV_TYPE_ATTR(_name, _mode, _show, _store)		\
> -struct mdev_type_attribute mdev_type_attr_##_name =		\
> -	__ATTR(_name, _mode, _show, _store)
> -#define MDEV_TYPE_ATTR_RW(_name) \
> -	struct mdev_type_attribute mdev_type_attr_##_name = __ATTR_RW(_name)
>   #define MDEV_TYPE_ATTR_RO(_name) \
>   	struct mdev_type_attribute mdev_type_attr_##_name = __ATTR_RO(_name)
>   #define MDEV_TYPE_ATTR_WO(_name) \
> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
> index e90c8552cc31..8d3ae97d9d6e 100644
> --- a/samples/vfio-mdev/mbochs.c
> +++ b/samples/vfio-mdev/mbochs.c
> @@ -1358,17 +1358,9 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   }
>   static MDEV_TYPE_ATTR_RO(available_instances);
>   
> -static ssize_t device_api_show(struct mdev_type *mtype,
> -			       struct mdev_type_attribute *attr, char *buf)
> -{
> -	return sprintf(buf, "%s\n", VFIO_DEVICE_API_PCI_STRING);
> -}
> -static MDEV_TYPE_ATTR_RO(device_api);
> -
>   static struct attribute *mdev_types_attrs[] = {
>   	&mdev_type_attr_name.attr,
>   	&mdev_type_attr_description.attr,
> -	&mdev_type_attr_device_api.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
> @@ -1417,6 +1409,7 @@ static struct mdev_driver mbochs_driver = {
>   static const struct mdev_parent_ops mdev_fops = {
>   	.owner			= THIS_MODULE,
>   	.device_driver		= &mbochs_driver,
> +	.device_api		= VFIO_DEVICE_API_PCI_STRING,
>   	.supported_type_groups	= mdev_type_groups,
>   };
>   
> diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
> index fe5d43e797b6..402a7ebe6563 100644
> --- a/samples/vfio-mdev/mdpy.c
> +++ b/samples/vfio-mdev/mdpy.c
> @@ -670,17 +670,9 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   }
>   static MDEV_TYPE_ATTR_RO(available_instances);
>   
> -static ssize_t device_api_show(struct mdev_type *mtype,
> -			       struct mdev_type_attribute *attr, char *buf)
> -{
> -	return sprintf(buf, "%s\n", VFIO_DEVICE_API_PCI_STRING);
> -}
> -static MDEV_TYPE_ATTR_RO(device_api);
> -
>   static struct attribute *mdev_types_attrs[] = {
>   	&mdev_type_attr_name.attr,
>   	&mdev_type_attr_description.attr,
> -	&mdev_type_attr_device_api.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
> @@ -728,6 +720,7 @@ static struct mdev_driver mdpy_driver = {
>   static const struct mdev_parent_ops mdev_fops = {
>   	.owner			= THIS_MODULE,
>   	.device_driver          = &mdpy_driver,
> +	.device_api		= VFIO_DEVICE_API_PCI_STRING,
>   	.supported_type_groups	= mdev_type_groups,
>   };
>   
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index a0e1a469bd47..5dc1b6a4c02c 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -1281,17 +1281,8 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   
>   static MDEV_TYPE_ATTR_RO(available_instances);
>   
> -static ssize_t device_api_show(struct mdev_type *mtype,
> -			       struct mdev_type_attribute *attr, char *buf)
> -{
> -	return sprintf(buf, "%s\n", VFIO_DEVICE_API_PCI_STRING);
> -}
> -
> -static MDEV_TYPE_ATTR_RO(device_api);
> -
>   static struct attribute *mdev_types_attrs[] = {
>   	&mdev_type_attr_name.attr,
> -	&mdev_type_attr_device_api.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
> @@ -1333,6 +1324,7 @@ static struct mdev_driver mtty_driver = {
>   static const struct mdev_parent_ops mdev_fops = {
>   	.owner                  = THIS_MODULE,
>   	.device_driver		= &mtty_driver,
> +	.device_api		= VFIO_DEVICE_API_PCI_STRING,
>   	.dev_attr_groups        = mtty_dev_groups,
>   	.supported_type_groups  = mdev_type_groups,
>   };
