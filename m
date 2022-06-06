Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE0B53EE80
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 21:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbiFFTWw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 15:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231372AbiFFTWu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 15:22:50 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2041.outbound.protection.outlook.com [40.107.92.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D9719F8A;
        Mon,  6 Jun 2022 12:22:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n5n2TPyfoc5RpNxefIK5k2iQO4PaLP5qll4gDn9jrRPUz6uwA1ZzwSKrRZT5M4Bwt8uX/UYhz+t2vcirrz8g9kd+p29Nena7mTFPsVgHKYWZ5+97kLUThbTxJczyP6CekKMSBvo30xY4CPDop1HWcnFiqY5QMY59n4pAuwejgyyNsX5IXROAbiKsbWmPcAEJBR39obZiD9Ju3WOfo761dX2h+CfRguTYjKzNiAqvKKVb+1huQ9YIY0HDnqMWRsevzwbA5dPkDyMUpyyEFr+0TDnb6zcY6GKo/Tfs3KpbEw8Rzxv8ocIgNGqwv/0jUFQt0nUR9eQ7lglreYHkPCeM/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jmanQcnC1XEuyw6VpnOj4fcNZSP9OmWzn0tadgYsw18=;
 b=Jg55slwPiYYtYpkO6fQqi2s8lk6RAYka+CN0TxoiuqM0jjWAeGYZUnFvz4lRvQPbPk1roo1swst8dCJ+SLymS9WNwghuhj4xoCrFQVxdCP91dZY5CGhWdl1SCNOQDMI5biO5pvem8JAGIcpluEWWyTxsjjwD4t8pv3jArTer3qFGJZQ3dOXpM+mSbbhVn0rK8jD5rI42bAMICr0vXgUnZ31CUxJEGIVVuUnJf5Uz5YwpAKl8I660rNFM0pnn8D6x8MWbmyKlOYJCm7/tIvBk8ImkS3MwcwtnHZ1A7mOiz711uFB8tp9mxDURShjklr2w0aaBgSUAzRFc90nmlT/JBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jmanQcnC1XEuyw6VpnOj4fcNZSP9OmWzn0tadgYsw18=;
 b=GiDNuXyCVgxXdXwKMF8OMPIj/WIs4VIMaoveahULrzk7tp6jQ2hpYa/LdYivD4qOcHhy+RTqK+6r9q9so2vaomjUP+TWeliD9VrZp+qjMRUIC0AC7GXeMtBK0RLA9iBOCfbnookyyKaTRnWqDn/ZzGYCVc/5xqHf4r20S2+w8BYgUV3KRJhd2gy7zc6iA6xemCnc9iWF/rVCiTrD6qno/YBwpJScifD6eFCzCEg1VNxaJ96I0S6cDuiek0tWT/ic8C15U6EefYB7svWq/OOQRUTYNVhmPhxaioex4JHB5zZ2el7dSn8GHpiXQVUAbYWaMtsZS0ZQH4WjJlD5gaSo7Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18)
 by MWHPR12MB1790.namprd12.prod.outlook.com (2603:10b6:300:109::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Mon, 6 Jun
 2022 19:22:43 +0000
Received: from MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14]) by MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14%6]) with mapi id 15.20.5314.019; Mon, 6 Jun 2022
 19:22:43 +0000
Message-ID: <71e7d9a8-1005-0458-b8cd-147ccc6430d7@nvidia.com>
Date:   Tue, 7 Jun 2022 00:52:30 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 2/8] vfio/mdev: embedd struct mdev_parent in the parent
 data structure
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org, Neo Jia <cjia@nvidia.com>,
        Dheeraj Nigam <dnigam@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
References: <20220603063328.3715-1-hch@lst.de>
 <20220603063328.3715-3-hch@lst.de>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
In-Reply-To: <20220603063328.3715-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0064.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ad::6) To MN2PR12MB4206.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce900222-0348-4b94-d7e0-08da47f1ee10
X-MS-TrafficTypeDiagnostic: MWHPR12MB1790:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1790F12DBB24F92B1FA9D9AADCA29@MWHPR12MB1790.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3+tpg44wM/GKEvBOesCaaXl3lrD3lrdo8MJysr4iAWm1eeh7Jh++l7OyBBKUvuv13vI/LXsliE/696O84Zjot6JpVAN/tsBtoVr8LK7LmKhUdzirqvj3rdDOoR8gYlnZ7RmiOCRVU0/3rEcXSHoaddjKLQ6yOIZZuKEjn2MVzUepLjeSoNctOFOg13JueXs1HhWyPlJ4trWShh6g/4sNnNcNb0XZAvhM8yVkX2QP9nl5a41eV7y3W0lL9OFAyGSrSL0n8gtzYBZ4b7Mh98kfVdufktMyvWEchmzU5QTosr7F48zYAy0X6sXL3mgQ7JJ6bZea60+WN8jT5UVmM8nXUnSJmSUpWnCD7ziYp/WDZFnF05jiYYI6cZcAKVMxIzHE4yUb5q8otvjF+elvRanUD27+9EPhPl7EId049hqZKSnjyMUn7jkUWhCAFTZ+kQHcIfthREiVqn3RmYqk1E1qVIgc+vixn2yb+S4EbqD6Y1dGN67Vi9/tL/uKoBkrFMEM6NbxsLiUlXSOnCshRR1GhTzJCG6iQIErpQW4AlXoQ02Z368Ogd5WBmpzIKdx3qv5neaDS7yu/GF1LLB/BMUrYChuNZHH3lf6JfBiDONxP555D4J36cgyo9KuMVUEgbeOZk3d3iFI7d2eyitAxGa09VmA3If4r6ZNb25zqq72v7Xg6jM8qy28jQqTIJKE8ksIlT1ojeWJbUKu4vUhUeNv8hnNbCyNilrvxqUxgwpngo4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4206.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(30864003)(7416002)(5660300002)(508600001)(38100700002)(55236004)(53546011)(6512007)(26005)(86362001)(6486002)(6666004)(186003)(6506007)(31696002)(2616005)(8936002)(107886003)(83380400001)(4326008)(8676002)(316002)(36756003)(66476007)(66556008)(66946007)(31686004)(110136005)(54906003)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGs5dTl2UDJjMEhpaWw5ZHRJZFpzY2hwdzVsVnYwaFd4LzhyYUQwUTE5NDdB?=
 =?utf-8?B?Z0EzT2VZRFRDbytTYXZxcUNIWTk2WEFHMEJaS3lsYS9YUVVMaUdRM2dneGM3?=
 =?utf-8?B?U0xLTUM5L0UyTUJzUkwrUEtGT0RoS2x6emtvL1VFbCtKWmxSdDMwM3gyeFd2?=
 =?utf-8?B?SGFsWXJPZ01NaTI5NE5qMkN0NzZSdk5rVGNFV3cvVm40SFc5YlZPdXJFRkNN?=
 =?utf-8?B?VTB4T1ByTlVRb01GTzAvNitMeU9Ka2pTcnpxTmxFLzBKa1RtWXVHUGlLVEk4?=
 =?utf-8?B?QXdPU1d0bzJ6dy9CcXRrYVh3bExVMW43VW5tS3hxMGk4RmpYNGpvNXZiSGNk?=
 =?utf-8?B?S1NFUm9rNUc3TGtUOTVXVkQyRkJsMjRYSXNPRDZtOGg5ZWtUSjVEUEpZbkxV?=
 =?utf-8?B?NHd1bSswT1JzNVZFR01xMWJIMFZEYzBKYzZRMHhBbWFlbk80OWZHZDdESUlB?=
 =?utf-8?B?MUVHNE1yT1NIcmt0NzFYdTVYaWdBZlo4OG9lQUV5TWpHTDZJUGx2UEdMelVE?=
 =?utf-8?B?UW9ianRUbnhnd3FSRmw3Qjc0TDNlVXlDck9iNnZZTVBHRGlRUUhBWXhKei9F?=
 =?utf-8?B?aDRmSHJsU2pjOGQ4YktYVHpMYTlDMWFPRFk0WTh6Um82dU5GVHlQS0oyekhC?=
 =?utf-8?B?SURiTzZNQi9SUFNrYmdBdEVyZVVSK05VU1dMNU9UbVpxM1lydGkyYVRsWFFI?=
 =?utf-8?B?S3c0K1hkQTFJdnBmSlB4U2cyOUg5T2trYkRBNk1aWEFPTlJNRGxMcWZWYU1a?=
 =?utf-8?B?bWc3MXVORHNVbVlydDJzbU9PNEJsODJDc0RpaXlQdncrc0UwbDBwcU1BVDEw?=
 =?utf-8?B?Yzk4TGpjRjZiWmVrUzJvS21zME9ETVV2M3lINU9KM2tSWGx3bHFGVGV0MVVB?=
 =?utf-8?B?TC9zSTRCR0ZwNGhDOUptNmpmVFBqKzZlWWl3d2ljdWVoanFFL0xuYkIzYW1E?=
 =?utf-8?B?OFRQTFE1TStSUXpSQWJ2b0RZelBWd3hMUkFveWZlVE9mTXFDdmkvOWppdkdy?=
 =?utf-8?B?Rk92TTQrWlZmaVlUNHg2SWlZU1VrSXhOMHpzMVdBUnRkZkJ1T1RIU1VvNThu?=
 =?utf-8?B?ZFdJU01qMzJBMmwzdlpVdHQ4NFpjaHRoQlFrWnNBYndKZTd6eG1wYXd6TDJa?=
 =?utf-8?B?QmJUSHVYa29tcmRNaGYvMW8xQytNV2ZFcWFEK1pjSUNoWENOdXFRc0JCUVFq?=
 =?utf-8?B?cmpXajlTVmJXUDNId0FySlgxekJOKzY0ckNzZUJlOEpXR3MxUXBUeXQwWDlm?=
 =?utf-8?B?L2g5ZkFiZ1BBaDFwTjMrREJMVkdPM0NneWtHM3Fyd0FCZ1JVQjBBclIzRml5?=
 =?utf-8?B?WC9oZ3BVY0IySXM1VDkzUldiWVhIVjMvT2RoaytEaTFqUTN6cHR2L2xsK2p0?=
 =?utf-8?B?dU9Ca3hlMXRsbU9WMWNQSnpPLzRyVlcvdjVzdHRiUjNlUWcvcEFyaWFGdFRO?=
 =?utf-8?B?b2RFUEhpMEgxdEdTSUtuT0JISVg5K1JGRmFWQ0FBenJQZkZmOGF3ZzdZYWFB?=
 =?utf-8?B?MGYwNXVJZUFEcjFXaWNxcjFMVlROREdaekw0TmRuamIyMkdkdU1PS09CeFU2?=
 =?utf-8?B?UzlSUFZId0trb3loZ2pOalNaU1Fubi9pUWl4WlhxeTRzY3UwQWNlMWN0K1NG?=
 =?utf-8?B?ak9ScnFCVkx5RkpraVd3RjNjUWZXSC9KbFRCdnQrenJMWFR1VEloSXpjYS9K?=
 =?utf-8?B?Z0xZTGMxVC9iQkJRSjNUdy9wS0tuODZuUFZ0VzI2bnhnTjdVTVRoT0xGNjVy?=
 =?utf-8?B?clo4bjg0bVp0WHJMNERlM0ZCcE5OcXZWSjgvcGdJdUlSYXNwM1VxRnZmeEpu?=
 =?utf-8?B?YWdKTVpyditLUEZlRmtDM3FQNzBENTM1bXNrbk01MW1Ta0NvTFE5ZzdzSW1a?=
 =?utf-8?B?TUwyQUl0R2FxTllLZjhuTVY5ZTBwUFMyQzAxcEF6QkxCYWcwaGQ3enlOWlI4?=
 =?utf-8?B?dEcrVnp0dkJWTzFjbmtkUVBYME9KQkR3MFlCSm52dXh5RWR1Ums0akJQSGdh?=
 =?utf-8?B?M0tFN3NTUWwzU3JCK01BZEJyUjFZTU4vYThhb2Z1L0pROXVja3BFV05YUmhk?=
 =?utf-8?B?cVNRaWErbkNhc1NvRUgvbitSSElGQTZFaXJ4WFp3R3N6MjhjZ1hzMU1Va2JF?=
 =?utf-8?B?TDhqbERCQjdNS2pFcDhSZU5ER3prRFpaS21LeVpNRGhGck5GSkI2eGtiSk1r?=
 =?utf-8?B?a1pPZHNvQ2hJbnV3MTZ5TWliQ2RJd1lUNytJSlRNaG1OYkU4VVRMQWVsNkkw?=
 =?utf-8?B?ZFpZcDJTdTNNUGFGMUM1RnFLSm02NzByZHJMNHZFS285dWpvNzRrQ29NeE1V?=
 =?utf-8?B?SGg2blFVR0Jja2pKMC9hdXMra0RkTDR0Q0xiNkF0YXJ3bTVEMG9tdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce900222-0348-4b94-d7e0-08da47f1ee10
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4206.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 19:22:43.6242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tm1OqcyYvVkJcTciZvzimhQQ8E3F8XQ85NGy5mEz9NWUPHOwxYVZcsnMPHAk9qLS+cIVJj+7em6llbUH9BnE5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1790
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



On 6/3/2022 12:03 PM, Christoph Hellwig wrote:
> Simplify mdev_{un}register_device by requiring the caller to pass in
> a structure allocate as part of the parent device structure.  This
> removes the need for a list of parents and the separate mdev_parent
> refcount as we can simplify rely on the reference to the parent device.
> 

By removing this list, there is no way to know if parent device is 
registered repeatedly? What will happen if same parent device is 
registered twice? will it fail somewhere else?

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   .../driver-api/vfio-mediated-device.rst       |  12 +-
>   Documentation/s390/vfio-ap.rst                |   2 +-
>   Documentation/s390/vfio-ccw.rst               |   2 +-
>   drivers/gpu/drm/i915/gvt/kvmgt.c              |   5 +-
>   drivers/gpu/drm/i915/i915_drv.h               |   2 +
>   drivers/s390/cio/cio.h                        |   2 +
>   drivers/s390/cio/vfio_ccw_ops.c               |   6 +-
>   drivers/s390/crypto/vfio_ap_ops.c             |   5 +-
>   drivers/s390/crypto/vfio_ap_private.h         |   1 +
>   drivers/vfio/mdev/mdev_core.c                 | 116 +++---------------
>   drivers/vfio/mdev/mdev_private.h              |  23 ----
>   drivers/vfio/mdev/mdev_sysfs.c                |   4 +-
>   include/linux/mdev.h                          |  15 ++-
>   samples/vfio-mdev/mbochs.c                    |   5 +-
>   samples/vfio-mdev/mdpy.c                      |   5 +-
>   samples/vfio-mdev/mtty.c                      |   6 +-
>   16 files changed, 65 insertions(+), 146 deletions(-)
> 
> diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
> index eded8719180fb..3749f59c855fa 100644
> --- a/Documentation/driver-api/vfio-mediated-device.rst
> +++ b/Documentation/driver-api/vfio-mediated-device.rst
> @@ -60,19 +60,19 @@ devices as examples, as these devices are the first devices to use this module::
>        |  MDEV CORE    |
>        |   MODULE      |
>        |   mdev.ko     |
> -     | +-----------+ |  mdev_register_device() +--------------+
> +     | +-----------+ |  mdev_register_parent() +--------------+
>        | |           | +<------------------------+              |
>        | |           | |                         |  nvidia.ko   |<-> physical
>        | |           | +------------------------>+              |    device
>        | |           | |        callbacks        +--------------+
>        | | Physical  | |
> -     | |  device   | |  mdev_register_device() +--------------+
> +     | |  device   | |  mdev_register_parent() +--------------+
>        | | interface | |<------------------------+              |
>        | |           | |                         |  i915.ko     |<-> physical
>        | |           | +------------------------>+              |    device
>        | |           | |        callbacks        +--------------+
>        | |           | |
> -     | |           | |  mdev_register_device() +--------------+
> +     | |           | |  mdev_register_parent() +--------------+
>        | |           | +<------------------------+              |
>        | |           | |                         | ccw_device.ko|<-> physical
>        | |           | +------------------------>+              |    device
> @@ -127,8 +127,8 @@ vfio_device_ops.
>   When a driver wants to add the GUID creation sysfs to an existing device it has
>   probe'd to then it should call::
>   
> -	extern int  mdev_register_device(struct device *dev,
> -	                                 struct mdev_driver *mdev_driver);
> +	int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
> +			struct mdev_driver *mdev_driver);
>

No need to change API name as it still registers 'struct device *dev', 
it could be 'mdev_register_device' but with new argument list.

>   This will provide the 'mdev_supported_types/XX/create' files which can then be
>   used to trigger the creation of a mdev_device. The created mdev_device will be
> @@ -136,7 +136,7 @@ attached to the specified driver.
>   
>   When the driver needs to remove itself it calls::
>   
> -	extern void mdev_unregister_device(struct device *dev);
> +	void mdev_unregister_parent(struct mdev_parent *parent);
>   

Same as above.

>   Which will unbind and destroy all the created mdevs and remove the sysfs files.
>   
> diff --git a/Documentation/s390/vfio-ap.rst b/Documentation/s390/vfio-ap.rst
> index f57ae621f33e8..37e16158c7fbf 100644
> --- a/Documentation/s390/vfio-ap.rst
> +++ b/Documentation/s390/vfio-ap.rst
> @@ -299,7 +299,7 @@ of the VFIO AP mediated matrix device driver::
>      |  MDEV CORE  |
>      |   MODULE    |
>      |   mdev.ko   |
> -   | +---------+ | mdev_register_device() +--------------+
> +   | +---------+ | mdev_register_parent() +--------------+
>      | |Physical | +<-----------------------+              |
>      | | device  | |                        |  vfio_ap.ko  |<-> matrix
>      | |interface| +----------------------->+              |    device
> diff --git a/Documentation/s390/vfio-ccw.rst b/Documentation/s390/vfio-ccw.rst
> index 8aad08a8b8a50..ea928a3806f43 100644
> --- a/Documentation/s390/vfio-ccw.rst
> +++ b/Documentation/s390/vfio-ccw.rst
> @@ -156,7 +156,7 @@ Below is a high Level block diagram::
>    |  MDEV CORE  |
>    |   MODULE    |
>    |   mdev.ko   |
> - | +---------+ | mdev_register_device() +--------------+
> + | +---------+ | mdev_register_parent() +--------------+
>    | |Physical | +<-----------------------+              |
>    | | device  | |                        |  vfio_ccw.ko |<-> subchannel
>    | |interface| +----------------------->+              |     device
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index e2f6c56ab3420..37bda01c1bb97 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -1960,7 +1960,7 @@ static void intel_gvt_clean_device(struct drm_i915_private *i915)
>   	if (drm_WARN_ON(&i915->drm, !gvt))
>   		return;
>   
> -	mdev_unregister_device(i915->drm.dev);
> +	mdev_unregister_parent(&i915->vgpu.parent);

Ideally, parent should be member of gvt. There could be multiple vgpus 
created on one physical device. Intel folks would be better reviewer though.

>   	intel_gvt_cleanup_vgpu_type_groups(gvt);
>   	intel_gvt_destroy_idle_vgpu(gvt->idle_vgpu);
>   	intel_gvt_clean_vgpu_types(gvt);
> @@ -2065,7 +2065,8 @@ static int intel_gvt_init_device(struct drm_i915_private *i915)
>   	if (ret)
>   		goto out_destroy_idle_vgpu;
>   
> -	ret = mdev_register_device(i915->drm.dev, &intel_vgpu_mdev_driver);
> +	ret = mdev_register_parent(&i915->vgpu.parent, i915->drm.dev,
> +				   &intel_vgpu_mdev_driver);
>   	if (ret)
>   		goto out_cleanup_vgpu_type_groups;
>   
> diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
> index 00d7eeae33bd3..7d62cc9a57e4e 100644
> --- a/drivers/gpu/drm/i915/i915_drv.h
> +++ b/drivers/gpu/drm/i915/i915_drv.h
> @@ -32,6 +32,7 @@
>   
>   #include <uapi/drm/i915_drm.h>
>   
> +#include <linux/mdev.h>
>   #include <linux/pm_qos.h>
>   
>   #include <drm/drm_connector.h>
> @@ -400,6 +401,7 @@ struct i915_frontbuffer_tracking {
>   
>   struct i915_virtual_gpu {
>   	struct mutex lock; /* serialises sending of g2v_notify command pkts */
> +	struct mdev_parent parent;
>   	bool active;
>   	u32 caps;
>   	u32 *initial_mmio;
> diff --git a/drivers/s390/cio/cio.h b/drivers/s390/cio/cio.h
> index 1cb9daf9c6450..4ae462da7b45b 100644
> --- a/drivers/s390/cio/cio.h
> +++ b/drivers/s390/cio/cio.h
> @@ -5,6 +5,7 @@
>   #include <linux/mutex.h>
>   #include <linux/device.h>
>   #include <linux/mod_devicetable.h>
> +#include <linux/mdev.h>
>   #include <asm/chpid.h>
>   #include <asm/cio.h>
>   #include <asm/fcx.h>
> @@ -104,6 +105,7 @@ struct subchannel {
>   	struct schib_config config;
>   	u64 dma_mask;
>   	char *driver_override; /* Driver name to force a match */
> +	struct mdev_parent parent;
>   } __attribute__ ((aligned(8)));
>   
>   DECLARE_PER_CPU_ALIGNED(struct irb, cio_irb);
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index b49e2e9db2dc6..9192a21085ce4 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -11,7 +11,6 @@
>    */
>   
>   #include <linux/vfio.h>
> -#include <linux/mdev.h>
>   #include <linux/nospec.h>
>   #include <linux/slab.h>
>   
> @@ -660,10 +659,11 @@ struct mdev_driver vfio_ccw_mdev_driver = {
>   
>   int vfio_ccw_mdev_reg(struct subchannel *sch)
>   {
> -	return mdev_register_device(&sch->dev, &vfio_ccw_mdev_driver);
> +	return mdev_register_parent(&sch->parent, &sch->dev,
> +				    &vfio_ccw_mdev_driver);
>   }
>   
>   void vfio_ccw_mdev_unreg(struct subchannel *sch)
>   {
> -	mdev_unregister_device(&sch->dev);
> +	mdev_unregister_parent(&sch->parent);
>   }
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index a7d2a95796d36..834945150dc9f 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1485,7 +1485,8 @@ int vfio_ap_mdev_register(void)
>   	if (ret)
>   		return ret;
>   
> -	ret = mdev_register_device(&matrix_dev->device, &vfio_ap_matrix_driver);
> +	ret = mdev_register_parent(&matrix_dev->parent, &matrix_dev->device,
> +				   &vfio_ap_matrix_driver);
>   	if (ret)
>   		goto err_driver;
>   	return 0;
> @@ -1497,6 +1498,6 @@ int vfio_ap_mdev_register(void)
>   
>   void vfio_ap_mdev_unregister(void)
>   {
> -	mdev_unregister_device(&matrix_dev->device);
> +	mdev_unregister_parent(&matrix_dev->parent);
>   	mdev_unregister_driver(&vfio_ap_matrix_driver);
>   }
> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index a26efd804d0df..b97dc548a7c95 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -46,6 +46,7 @@ struct ap_matrix_dev {
>   	struct list_head mdev_list;
>   	struct mutex lock;
>   	struct ap_driver  *vfio_ap_drv;
> +	struct mdev_parent parent;
>   };
>   
>   extern struct ap_matrix_dev *matrix_dev;
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index b8b9e7911e559..8b5a2b3f0c882 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -20,8 +20,6 @@
>   #define DRIVER_AUTHOR		"NVIDIA Corporation"
>   #define DRIVER_DESC		"Mediated device Core Driver"
>   
> -static LIST_HEAD(parent_list);
> -static DEFINE_MUTEX(parent_list_lock);
>   static struct class_compat *mdev_bus_compat_class;
>   
>   static LIST_HEAD(mdev_list);
> @@ -63,28 +61,6 @@ struct device *mtype_get_parent_dev(struct mdev_type *mtype)
>   }
>   EXPORT_SYMBOL(mtype_get_parent_dev);
>   
> -/* Should be called holding parent_list_lock */
> -static struct mdev_parent *__find_parent_device(struct device *dev)
> -{
> -	struct mdev_parent *parent;
> -
> -	list_for_each_entry(parent, &parent_list, next) {
> -		if (parent->dev == dev)
> -			return parent;
> -	}
> -	return NULL;
> -}
> -
> -void mdev_release_parent(struct kref *kref)
> -{
> -	struct mdev_parent *parent = container_of(kref, struct mdev_parent,
> -						  ref);
> -	struct device *dev = parent->dev;
> -
> -	kfree(parent);
> -	put_device(dev);
> -}
> -
>   /* Caller must hold parent unreg_sem read or write lock */
>   static void mdev_device_remove_common(struct mdev_device *mdev)
>   {
> @@ -107,125 +83,69 @@ static int mdev_device_remove_cb(struct device *dev, void *data)
>   }
>   
>   /*
> - * mdev_register_device : Register a device
> + * mdev_register_parent: Register a device as parent for mdevs
> + * @parent: parent structure registered
>    * @dev: device structure representing parent device.
>    * @mdev_driver: Device driver to bind to the newly created mdev
>    *
> - * Add device to list of registered parent devices.
>    * Returns a negative value on error, otherwise 0.
>    */
> -int mdev_register_device(struct device *dev, struct mdev_driver *mdev_driver)
> +int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
> +		struct mdev_driver *mdev_driver)
>   {
> -	int ret;
> -	struct mdev_parent *parent;
>   	char *env_string = "MDEV_STATE=registered";
>   	char *envp[] = { env_string, NULL };
> +	int ret;
>   
>   	/* check for mandatory ops */
>   	if (!mdev_driver->supported_type_groups)
>   		return -EINVAL;
>   
> -	dev = get_device(dev);
> -	if (!dev)
> -		return -EINVAL;
> -

Why not held device here? What if some driver miss behave where it 
registers device to mdev, but unloads without unregistering from mdev?

Thanks,
Kirti

> -	mutex_lock(&parent_list_lock);
> -
> -	/* Check for duplicate */
> -	parent = __find_parent_device(dev);
> -	if (parent) {
> -		parent = NULL;
> -		ret = -EEXIST;
> -		goto add_dev_err;
> -	}
> -
> -	parent = kzalloc(sizeof(*parent), GFP_KERNEL);
> -	if (!parent) {
> -		ret = -ENOMEM;
> -		goto add_dev_err;
> -	}
> -
> -	kref_init(&parent->ref);
> +	memset(parent, 0, sizeof(*parent));
>   	init_rwsem(&parent->unreg_sem);
> -
>   	parent->dev = dev;
>   	parent->mdev_driver = mdev_driver;
>   
>   	if (!mdev_bus_compat_class) {
>   		mdev_bus_compat_class = class_compat_register("mdev_bus");
> -		if (!mdev_bus_compat_class) {
> -			ret = -ENOMEM;
> -			goto add_dev_err;
> -		}
> +		if (!mdev_bus_compat_class)
> +			return -ENOMEM;
>   	}
>   
>   	ret = parent_create_sysfs_files(parent);
>   	if (ret)
> -		goto add_dev_err;
> +		return ret;
>   
>   	ret = class_compat_create_link(mdev_bus_compat_class, dev, NULL);
>   	if (ret)
>   		dev_warn(dev, "Failed to create compatibility class link\n");
>   
> -	list_add(&parent->next, &parent_list);
> -	mutex_unlock(&parent_list_lock);
> -
>   	dev_info(dev, "MDEV: Registered\n");
>   	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
> -
>   	return 0;
> -
> -add_dev_err:
> -	mutex_unlock(&parent_list_lock);
> -	if (parent)
> -		mdev_put_parent(parent);
> -	else
> -		put_device(dev);
> -	return ret;
>   }
> -EXPORT_SYMBOL(mdev_register_device);
> +EXPORT_SYMBOL(mdev_register_parent);
>   
>   /*
> - * mdev_unregister_device : Unregister a parent device
> - * @dev: device structure representing parent device.
> - *
> - * Remove device from list of registered parent devices. Give a chance to free
> - * existing mediated devices for given device.
> + * mdev_unregister_parent : Unregister a parent device
> + * @parent: parent structure to unregister
>    */
> -
> -void mdev_unregister_device(struct device *dev)
> +void mdev_unregister_parent(struct mdev_parent *parent)
>   {
> -	struct mdev_parent *parent;
>   	char *env_string = "MDEV_STATE=unregistered";
>   	char *envp[] = { env_string, NULL };
>   
> -	mutex_lock(&parent_list_lock);
> -	parent = __find_parent_device(dev);
> -
> -	if (!parent) {
> -		mutex_unlock(&parent_list_lock);
> -		return;
> -	}
> -	dev_info(dev, "MDEV: Unregistering\n");
> -
> -	list_del(&parent->next);
> -	mutex_unlock(&parent_list_lock);
> +	dev_info(parent->dev, "MDEV: Unregistering\n");
>   
>   	down_write(&parent->unreg_sem);
> -
> -	class_compat_remove_link(mdev_bus_compat_class, dev, NULL);
> -
> -	device_for_each_child(dev, NULL, mdev_device_remove_cb);
> -
> +	class_compat_remove_link(mdev_bus_compat_class, parent->dev, NULL);
> +	device_for_each_child(parent->dev, NULL, mdev_device_remove_cb);
>   	parent_remove_sysfs_files(parent);
>   	up_write(&parent->unreg_sem);
>   
> -	mdev_put_parent(parent);
> -
> -	/* We still have the caller's reference to use for the uevent */
> -	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
> +	kobject_uevent_env(&parent->dev->kobj, KOBJ_CHANGE, envp);
>   }
> -EXPORT_SYMBOL(mdev_unregister_device);
> +EXPORT_SYMBOL(mdev_unregister_parent);
>   
>   static void mdev_device_release(struct device *dev)
>   {
> diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
> index 7c9fc79f3d838..297f911fdc890 100644
> --- a/drivers/vfio/mdev/mdev_private.h
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -13,17 +13,6 @@
>   int  mdev_bus_register(void);
>   void mdev_bus_unregister(void);
>   
> -struct mdev_parent {
> -	struct device *dev;
> -	struct mdev_driver *mdev_driver;
> -	struct kref ref;
> -	struct list_head next;
> -	struct kset *mdev_types_kset;
> -	struct list_head type_list;
> -	/* Synchronize device creation/removal with parent unregistration */
> -	struct rw_semaphore unreg_sem;
> -};
> -
>   struct mdev_type {
>   	struct kobject kobj;
>   	struct kobject *devices_kobj;
> @@ -48,16 +37,4 @@ void mdev_remove_sysfs_files(struct mdev_device *mdev);
>   int mdev_device_create(struct mdev_type *kobj, const guid_t *uuid);
>   int  mdev_device_remove(struct mdev_device *dev);
>   
> -void mdev_release_parent(struct kref *kref);
> -
> -static inline void mdev_get_parent(struct mdev_parent *parent)
> -{
> -	kref_get(&parent->ref);
> -}
> -
> -static inline void mdev_put_parent(struct mdev_parent *parent)
> -{
> -	kref_put(&parent->ref, mdev_release_parent);
> -}
> -
>   #endif /* MDEV_PRIVATE_H */
> diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
> index 0ccfeb3dda245..becce814aabfb 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -83,7 +83,7 @@ static void mdev_type_release(struct kobject *kobj)
>   
>   	pr_debug("Releasing group %s\n", kobj->name);
>   	/* Pairs with the get in add_mdev_supported_type() */
> -	mdev_put_parent(type->parent);
> +	put_device(type->parent->dev);
>   	kfree(type);
>   }
>   
> @@ -112,7 +112,7 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
>   	type->kobj.kset = parent->mdev_types_kset;
>   	type->parent = parent;
>   	/* Pairs with the put in mdev_type_release() */
> -	mdev_get_parent(parent);
> +	get_device(parent->dev);
>   	type->type_group_id = type_group_id;
>   
>   	ret = kobject_init_and_add(&type->kobj, &mdev_type_ktype, NULL,
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 555c1d015b5f0..327ce3e5c6b5f 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -23,6 +23,16 @@ struct mdev_device {
>   	bool active;
>   };
>   
> +/* embedded into the struct device that the mdev devices hang off */
> +struct mdev_parent {
> +	struct device *dev;
> +	struct mdev_driver *mdev_driver;
> +	struct kset *mdev_types_kset;
> +	struct list_head type_list;
> +	/* Synchronize device creation/removal with parent unregistration */
> +	struct rw_semaphore unreg_sem;
> +};
> +
>   static inline struct mdev_device *to_mdev_device(struct device *dev)
>   {
>   	return container_of(dev, struct mdev_device, dev);
> @@ -75,8 +85,9 @@ static inline const guid_t *mdev_uuid(struct mdev_device *mdev)
>   
>   extern struct bus_type mdev_bus_type;
>   
> -int mdev_register_device(struct device *dev, struct mdev_driver *mdev_driver);
> -void mdev_unregister_device(struct device *dev);
> +int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
> +		struct mdev_driver *mdev_driver);
> +void mdev_unregister_parent(struct mdev_parent *parent);
>   
>   int mdev_register_driver(struct mdev_driver *drv);
>   void mdev_unregister_driver(struct mdev_driver *drv);
> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
> index 344c2901a82bf..f0967a81eabe7 100644
> --- a/samples/vfio-mdev/mbochs.c
> +++ b/samples/vfio-mdev/mbochs.c
> @@ -129,6 +129,7 @@ static dev_t		mbochs_devt;
>   static struct class	*mbochs_class;
>   static struct cdev	mbochs_cdev;
>   static struct device	mbochs_dev;
> +static struct mdev_parent mbochs_parent;
>   static atomic_t mbochs_avail_mbytes;
>   static const struct vfio_device_ops mbochs_dev_ops;
>   
> @@ -1457,7 +1458,7 @@ static int __init mbochs_dev_init(void)
>   	if (ret)
>   		goto err_class;
>   
> -	ret = mdev_register_device(&mbochs_dev, &mbochs_driver);
> +	ret = mdev_register_parent(&mbochs_parent, &mbochs_dev, &mbochs_driver);
>   	if (ret)
>   		goto err_device;
>   
> @@ -1478,7 +1479,7 @@ static int __init mbochs_dev_init(void)
>   static void __exit mbochs_dev_exit(void)
>   {
>   	mbochs_dev.bus = NULL;
> -	mdev_unregister_device(&mbochs_dev);
> +	mdev_unregister_parent(&mbochs_parent);
>   
>   	device_unregister(&mbochs_dev);
>   	mdev_unregister_driver(&mbochs_driver);
> diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
> index e8c46eb2e2468..8ab88a1d149cb 100644
> --- a/samples/vfio-mdev/mdpy.c
> +++ b/samples/vfio-mdev/mdpy.c
> @@ -84,6 +84,7 @@ static dev_t		mdpy_devt;
>   static struct class	*mdpy_class;
>   static struct cdev	mdpy_cdev;
>   static struct device	mdpy_dev;
> +static struct mdev_parent mdpy_parent;
>   static u32		mdpy_count;
>   static const struct vfio_device_ops mdpy_dev_ops;
>   
> @@ -766,7 +767,7 @@ static int __init mdpy_dev_init(void)
>   	if (ret)
>   		goto err_class;
>   
> -	ret = mdev_register_device(&mdpy_dev, &mdpy_driver);
> +	ret = mdev_register_parent(&mdpy_parent, &mdpy_dev, &mdpy_driver);
>   	if (ret)
>   		goto err_device;
>   
> @@ -787,7 +788,7 @@ static int __init mdpy_dev_init(void)
>   static void __exit mdpy_dev_exit(void)
>   {
>   	mdpy_dev.bus = NULL;
> -	mdev_unregister_device(&mdpy_dev);
> +	mdev_unregister_parent(&mdpy_parent);
>   
>   	device_unregister(&mdpy_dev);
>   	mdev_unregister_driver(&mdpy_driver);
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index f42a59ed2e3fe..20136def93fdb 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -74,6 +74,7 @@ static struct mtty_dev {
>   	struct cdev	vd_cdev;
>   	struct idr	vd_idr;
>   	struct device	dev;
> +	struct mdev_parent parent;
>   } mtty_dev;
>   
>   struct mdev_region_info {
> @@ -1352,7 +1353,8 @@ static int __init mtty_dev_init(void)
>   	if (ret)
>   		goto err_class;
>   
> -	ret = mdev_register_device(&mtty_dev.dev, &mtty_driver);
> +	ret = mdev_register_parent(&mtty_dev.parent, &mtty_dev.dev,
> +				   &mtty_driver);
>   	if (ret)
>   		goto err_device;
>   	return 0;
> @@ -1372,7 +1374,7 @@ static int __init mtty_dev_init(void)
>   static void __exit mtty_dev_exit(void)
>   {
>   	mtty_dev.dev.bus = NULL;
> -	mdev_unregister_device(&mtty_dev.dev);
> +	mdev_unregister_parent(&mtty_dev.parent);
>   
>   	device_unregister(&mtty_dev.dev);
>   	idr_destroy(&mtty_dev.vd_idr);
