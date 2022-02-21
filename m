Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66D624BD810
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 09:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243591AbiBUIMu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 03:12:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237124AbiBUIMq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 03:12:46 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6A21AF21;
        Mon, 21 Feb 2022 00:12:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jbXmgPXkibmT5xErNwJ77ppdQLpt7QBNy4st9wyE7eVt1/6slxdO0+HTEjWWZaO2fb7JchhQRaQCmHRlMn68rTVbC8JB9i8Td0BrVKiGUjm6pdhIo+2qufO5YaPm+puJJPupQ95TFQ8Dh2aXshwDaDLUFg5dYN7CwVu0zZURQYZaL5AJfA8z2Sz6CXaUIKFP2S6Sswwh/3rQHcyeDaV52vyOPWOfQD7oQmi5ozpCdq4YbSg5xSNubUI06wNYS3FUNw2liXVdWBKwEVNZhOEV6PlgUhdZev1HJcDtFWgAoNWA0bO/qm79Buq/s8S6ckrG6BcLmwpdRVRc6BQlf387vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eX4aYD6IcJ++gr7bZLH8boIjwE4SGYoYmEkCIPJ/GO8=;
 b=K4fLcytoeaPPEmeT/vMxshKkHP6x+Rmj+y1cZZt5xNNakQ1olnE9dlVRSxkEe7BlMWFFqQUvz9bYL54/WC5iKS4+6li/lDBNJxJ1FWywRzXWntdu+LqE7+Fvf4bo7UqmCl1Y5wmQPMdhuHzBOHgRvKs0y/p9kGitPKYfe/Sb3L05XATt803pscmnYYRn36g76AdHMfj4W8hssyNvVUGnqvsLG/PxQc5hXVzIPZQAHCJcVCgG6g2+Mb65A8otQ3me2QBUZB669CCddn+Np1cvuSfsbVcplN3EOraww+lV/fwCu8zWz6I58vGcYyX8EIxp7wTJKHVgCq8VlVR/ZNQqjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eX4aYD6IcJ++gr7bZLH8boIjwE4SGYoYmEkCIPJ/GO8=;
 b=B+gGKbaE0x5hssytK7X64a512rMu9Do311QrHoxY9biepkbR4Btt5JvRjCqlJy9v7KRGwGeTait9befvaL7J77VsovABksxq/afTKOHvZpxEUI3QhEAjTT7PpzbMxAiXy5YMVCWo7jSQim4TcuUiZIOwUtlwGeKf2LGYUm+X0gpktwJvCYKYMdR71BZPEcF2XdZQ3DNj/jnY/TBb2UW5+pAnWOntHPMqyF52MJS9wjwgmEZk7+1CeE/I1u2TzMNLj+9hH0t0EHBwmO0LF//Qwop/zftWIbOHfyrjq/J1HJQ+VjZGMKl0GQtFuPqPQ8+5A1wt8uHe+cLjxo6XfWU7KA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by BN7PR12MB2804.namprd12.prod.outlook.com (2603:10b6:408:2f::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Mon, 21 Feb
 2022 08:12:15 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::c1b2:224f:101a:a588]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::c1b2:224f:101a:a588%8]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 08:12:15 +0000
Message-ID: <fb52e3da-4808-ade5-7872-0432e5983c9b@nvidia.com>
Date:   Mon, 21 Feb 2022 13:42:03 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [RFC PATCH v2 4/5] vfio/pci: Invalidate mmaps and block the
 access in D3hot power state
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org
References: <20220124181726.19174-1-abhsahu@nvidia.com>
 <20220124181726.19174-5-abhsahu@nvidia.com>
 <20220217161420.7232eab6.alex.williamson@redhat.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220217161420.7232eab6.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR0101CA0034.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:22::20) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06cc63ea-0c5c-4202-3ae3-08d9f511de94
X-MS-TrafficTypeDiagnostic: BN7PR12MB2804:EE_
X-Microsoft-Antispam-PRVS: <BN7PR12MB2804B281F2BA33BAC6C765FECC3A9@BN7PR12MB2804.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cL77Cs+qa0amfp4BodDNpqOWLVyTN7y8IwCbyoIwEc/zmhpDRb+Og3dTWy54adHz8JsmaJueRyPxpPhr7uzh5wpO/0svmSXReDyaeC+6albULJJHAraL+9Q6M6ymNLlCF/rf+is4nBdVskNUKfvWdjm+Cj9mnT5E3s5ufnWipaoIQQZXdliBSuJY+bqUP8QXSUsgA2JrdWodoTBQ1cYCrA/6muH5RkthL3qMps/Mp7KqaOFG3FYSwZnNbxX/KcBoElXSqVDfmIw9EpiT3un/rwVc4G+bpO8IXuVmLylJGCKpEeIiSchibag3DhNWlHLFiV0/2KnoutJha/GNQ2C0qtiHJWm810Q/5Sq+DtVL0tvJgvhAZS2UKxqdEr/fvrJSmxdBmM2sN0OI1PH3cTwjcDMHsoXOkB28LH8BrVrTCU7tciqpqpcLhqZbj+bdf76B6tU6z2kUxd+C6czODjgpruOU/mNgKj9e+lW27qhEp6dhNlEd++/iQSVkBRDO15iqqlCNJaDWWeP2J493KVR7yqtjrrKN69DIC2ZQzzZ0dxmm/a3kiqXQy2IMEgUCPSU4PfmVsA5An67ox5x7tftFT75BqWr7UwUPccyvoADoz4H+I/jGfH33H8yEfKk4F6ft2E+hgsPB35+pOyYPsaIEQHbwVg5GxvEvpqc52oEoZRK2fpjcOgCUcyljRnRmQXWlkyH4sdmbOvw1dkKnL+a4h/cG+R2vaKoGbzkGlwFmKQPONcJDlD2eZzv9iqkqvQwDiADhWcutK9HUsSBi+HHL4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(55236004)(186003)(26005)(6506007)(53546011)(2616005)(66556008)(6512007)(66946007)(8676002)(6916009)(54906003)(66476007)(6486002)(6666004)(31696002)(86362001)(508600001)(316002)(83380400001)(4326008)(38100700002)(5660300002)(36756003)(8936002)(2906002)(31686004)(32563001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NEh4TTVwcEtiTkVwWFhiM29pbTB2cmtxT1JJTjIzQk9HYk5PZXdnMWgxbkZM?=
 =?utf-8?B?dXRCMHdQYjFva0tCR0tSQ21Jekt2bWQwSnM0V3Q5TnlwRDcyOUlsaWVsbGQz?=
 =?utf-8?B?ZmpjUm9IN2U0cWZkQWs1Q0RwQUM0ekNjeDZtek04bVl5TnQ0NVlXRUVsTVFj?=
 =?utf-8?B?RU94R0dkb3VwbjBoaVkxVEZwRmUwaEVqN1VpS3EvUEluV1NpeXRqWUtYbGNO?=
 =?utf-8?B?QlBMNjI0eFJvK3lYNzlZMWEwQndvbHF4aVpHbDVndVRldVBDenduVE5ieXZm?=
 =?utf-8?B?Yi8zZldvY3lpS1RFekwxZ3BXeDBHdFo2dmNDQTVyRmpPc2dtcys1Nmp3eS90?=
 =?utf-8?B?em42WFJwQ1dXNitNa3RKcmtySDdCeHVabnZMTTJBbkl5dDZjcG5FNjJiSGdm?=
 =?utf-8?B?dklrZ09uZWFhNXZKeDQ0VlIyd09ydGphbGw2WlNBRGRmTk4xKzlzWVNPN0E0?=
 =?utf-8?B?SGlpbmcyam1jY3V0U0t2Y01iQ0ZtdTF3QXIrN2pnRDlMK2FDd3lsSkFMeG52?=
 =?utf-8?B?VDJIODNrM2FZZTc5bFkyNE9XdjJHUndFc24wYUJFdVhPZGpmMDlqQ0piOFZ4?=
 =?utf-8?B?aTNydDUvL0kvK2QvNkxmenhGR3I3MWtRNTRsS1BKR3MwU29aU2FraG5nemZZ?=
 =?utf-8?B?TlkvbjJVRGNCd3g3UVk4Q2lpSE1sTk1Gd3hCR3h2RndveGwreEZTcjBmVEE4?=
 =?utf-8?B?bDBGSzMvWDZSWkdPemcvVlFreDRma3dEYXdEeExRelZ2b2ZGUU1ES3o2UlFl?=
 =?utf-8?B?VlpucktvMGR6Zk05TnZyQVlCS0FwMU9jemVrb1RsKzNwdTl4cUUxbVBwaUxZ?=
 =?utf-8?B?M2V3UC9XR2EycFVsNFVsYjhaSkRaMFNmWi9QVGpmUUtFb2NDSnRnaXNiR2Z1?=
 =?utf-8?B?ZWpGbWw0MktFL01oTmZVRGIxWFVCUlVXcVcxQUlOajlNcDNBN2lmYjJnZ3du?=
 =?utf-8?B?eTJ4T1BXQmhPMXZKeGgrS2gzcVUvOWh1S3BXaGFaRnFvVVpvM01EdGFSTlZY?=
 =?utf-8?B?VXVKdVpvQkF5Nk83bEVCR1pJOCszUURlZjZCMThsdDFBbVBJdFVoYmViV3BP?=
 =?utf-8?B?Vzc1bm51cTJubjEwSlp1M0Y1K3BHSElkaDIrd0Y4MXhZdGhXQVM3YS9rT0tR?=
 =?utf-8?B?dTZNL1BZZk9lWjUxWHFXL3E0OHBSNlNyMURGY0tkdVIzUG9PREJXK250bHdz?=
 =?utf-8?B?eSt1VGhWaWt5Mm50WVl2akh4ZEIydUZyYW9RTjd0RjZ4R2FWeGNJTHpnUFFC?=
 =?utf-8?B?Mnp3Q01pOVZYQWlORWJFaHNiQW9iamt5MDEyTmgxN0dqdlhlRTNnS3d3R2Uv?=
 =?utf-8?B?VWQvY0VsYVZraUZqTmw2bjNucFZ4RHhFWmJBVEN3V2pGaXI5OUgySmUzbkNs?=
 =?utf-8?B?ZmZOUEVtQTg3di9tUGtzcW9xWkhFenJaSHJIbkNmcW1oZ0Z5NTYyZ1lab3dU?=
 =?utf-8?B?b2VSOWJ0QytDWk0rQm9UVlFEVG1DQ3Ntc2t2bjJyaGtMMnZheGlQUUk0Z1VY?=
 =?utf-8?B?QjM2ci80R3RMaEtvVE1ET2FqSUNiN0Y4azVSczJCMWFWVU5MUytpS0tjbkRj?=
 =?utf-8?B?MTVBSnZmM085RllaM042ZlBzekduL0dFdGYvdmUvSkxOMFVyVjlGZlZFb0V3?=
 =?utf-8?B?eDVTM1d0WXd5SW9McGdISHAxTUVsVDBoWDVuOEdkQWlnWDF4K0dTQm1IQTNZ?=
 =?utf-8?B?Z2E3ZFVDL1NpeHdYSnFScFpSOEEzd2JDWlpRbGdXeVJ2ZG5JWkVaSnVNRysw?=
 =?utf-8?B?TXdudFZsOXVSamxmM0MxOENOV05vazNRVDV0aGF4QTlOL3EyQ010d3B0dWRr?=
 =?utf-8?B?VGtuSWJBVWR0dC9od1BlWWhXeTNUa0hhaTV2aTRrWnZScjJDazFkenhVa2V2?=
 =?utf-8?B?ZEY5SXNYbm1GbG9VUzZreTcrMUZDSlg0dXBNdmdSQUNWZUttNnJHV3ptQk00?=
 =?utf-8?B?RllaM3FhQzlDYWRkNVk2QXJkbE1YQTRmT2xTbExTWEVnaWMxelp6b29ERkxC?=
 =?utf-8?B?dzU4SG95Z1F2bUVSWTdDeWZnd3hLaW1kQ21yNStsM2QrWlAxZlVwNWdZQ0FD?=
 =?utf-8?B?azVDQlZiN2tUMFBRcjFBWUtwMTdxRW5uNWUrbFNoOWcyb1RDWFlabmhwWm1q?=
 =?utf-8?B?ZURqZSs2RVR2b2Fnc3g4dU1lWFJVem01UGV5VUJqbTBSd0ZtVWZoeFVMS25n?=
 =?utf-8?Q?baiFZAngWQcKnnZvHIbL0CQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06cc63ea-0c5c-4202-3ae3-08d9f511de94
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 08:12:15.0902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /v66My/dlGpcSombE8H5FlnvtgEf5yUjxP/TJgPYsR19lxWaZ73PrJF8eU4i2Grk4UhZ5GDCzBFgr8C9dh13wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2804
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/18/2022 4:44 AM, Alex Williamson wrote:
> On Mon, 24 Jan 2022 23:47:25 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> 
>> According to [PCIe v5 5.3.1.4.1] for D3hot state
>>
>>  "Configuration and Message requests are the only TLPs accepted by a
>>   Function in the D3Hot state. All other received Requests must be
>>   handled as Unsupported Requests, and all received Completions may
>>   optionally be handled as Unexpected Completions."
>>
>> Currently, if the vfio PCI device has been put into D3hot state and if
>> user makes non-config related read/write request in D3hot state, these
>> requests will be forwarded to the host and this access may cause
>> issues on a few systems.
>>
>> This patch leverages the memory-disable support added in commit
>> 'abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO access on
>> disabled memory")' to generate page fault on mmap access and
>> return error for the direct read/write. If the device is D3hot state,
>> then the error needs to be returned for all kinds of BAR
>> related access (memory, IO and ROM). Also, the power related structure
>> fields need to be protected so we can use the same 'memory_lock' to
>> protect these fields also. For the few cases, this 'memory_lock' will be
>> already acquired by callers so introduce a separate function
>> vfio_pci_set_power_state_locked(). The original
>> vfio_pci_set_power_state() now contains the code to do the locking
>> related operations.
>>
>> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
>> ---
>>  drivers/vfio/pci/vfio_pci_core.c | 47 +++++++++++++++++++++++++-------
>>  drivers/vfio/pci/vfio_pci_rdwr.c | 20 ++++++++++----
>>  2 files changed, 51 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index ee2fb8af57fa..38440d48973f 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -201,11 +201,12 @@ static void vfio_pci_probe_power_state(struct vfio_pci_core_device *vdev)
>>  }
>>
>>  /*
>> - * pci_set_power_state() wrapper handling devices which perform a soft reset on
>> - * D3->D0 transition.  Save state prior to D0/1/2->D3, stash it on the vdev,
>> - * restore when returned to D0.  Saved separately from pci_saved_state for use
>> - * by PM capability emulation and separately from pci_dev internal saved state
>> - * to avoid it being overwritten and consumed around other resets.
>> + * vfio_pci_set_power_state_locked() wrapper handling devices which perform a
>> + * soft reset on D3->D0 transition.  Save state prior to D0/1/2->D3, stash it
>> + * on the vdev, restore when returned to D0.  Saved separately from
>> + * pci_saved_state for use by PM capability emulation and separately from
>> + * pci_dev internal saved state to avoid it being overwritten and consumed
>> + * around other resets.
>>   *
>>   * There are few cases where the PCI power state can be changed to D0
>>   * without the involvement of this API. So, cache the power state locally
>> @@ -215,7 +216,8 @@ static void vfio_pci_probe_power_state(struct vfio_pci_core_device *vdev)
>>   * The memory taken for saving this PCI state needs to be freed to
>>   * prevent memory leak.
>>   */
>> -int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t state)
>> +static int vfio_pci_set_power_state_locked(struct vfio_pci_core_device *vdev,
>> +                                        pci_power_t state)
>>  {
>>       struct pci_dev *pdev = vdev->pdev;
>>       bool needs_restore = false, needs_save = false;
>> @@ -260,6 +262,26 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
>>       return ret;
>>  }
>>
>> +/*
>> + * vfio_pci_set_power_state() takes all the required locks to protect
>> + * the access of power related variables and then invokes
>> + * vfio_pci_set_power_state_locked().
>> + */
>> +int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev,
>> +                          pci_power_t state)
>> +{
>> +     int ret;
>> +
>> +     if (state >= PCI_D3hot)
>> +             vfio_pci_zap_and_down_write_memory_lock(vdev);
>> +     else
>> +             down_write(&vdev->memory_lock);
>> +
>> +     ret = vfio_pci_set_power_state_locked(vdev, state);
>> +     up_write(&vdev->memory_lock);
>> +     return ret;
>> +}
>> +
>>  int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
>>  {
>>       struct pci_dev *pdev = vdev->pdev;
>> @@ -354,7 +376,7 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>>        * in running the logic needed for D0 power state. The subsequent
>>        * runtime PM API's will put the device into the low power state again.
>>        */
>> -     vfio_pci_set_power_state(vdev, PCI_D0);
>> +     vfio_pci_set_power_state_locked(vdev, PCI_D0);
>>
>>       /* Stop the device from further DMA */
>>       pci_clear_master(pdev);
>> @@ -967,7 +989,7 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>>                * interaction. Update the power state in vfio driver to perform
>>                * the logic needed for D0 power state.
>>                */
>> -             vfio_pci_set_power_state(vdev, PCI_D0);
>> +             vfio_pci_set_power_state_locked(vdev, PCI_D0);
>>               up_write(&vdev->memory_lock);
>>
>>               return ret;
>> @@ -1453,6 +1475,11 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
>>               goto up_out;
>>       }
>>
>> +     if (vdev->power_state >= PCI_D3hot) {
>> +             ret = VM_FAULT_SIGBUS;
>> +             goto up_out;
>> +     }
>> +
>>       /*
>>        * We populate the whole vma on fault, so we need to test whether
>>        * the vma has already been mapped, such as for concurrent faults
>> @@ -1902,7 +1929,7 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
>>        * be able to get to D3.  Therefore first do a D0 transition
>>        * before enabling runtime PM.
>>        */
>> -     vfio_pci_set_power_state(vdev, PCI_D0);
>> +     vfio_pci_set_power_state_locked(vdev, PCI_D0);
>>       pm_runtime_allow(&pdev->dev);
>>
>>       if (!disable_idle_d3)
>> @@ -2117,7 +2144,7 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>>                * interaction. Update the power state in vfio driver to perform
>>                * the logic needed for D0 power state.
>>                */
>> -             vfio_pci_set_power_state(cur, PCI_D0);
>> +             vfio_pci_set_power_state_locked(cur, PCI_D0);
>>               if (cur == cur_mem)
>>                       is_mem = false;
>>               if (cur == cur_vma)
>> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
>> index 57d3b2cbbd8e..e97ba14c4aa0 100644
>> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
>> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
>> @@ -41,8 +41,13 @@
>>  static int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,         \
>>                       bool test_mem, u##size val, void __iomem *io)   \
>>  {                                                                    \
>> +     down_read(&vdev->memory_lock);                                  \
>> +     if (vdev->power_state >= PCI_D3hot) {                           \
>> +             up_read(&vdev->memory_lock);                            \
>> +             return -EIO;                                            \
>> +     }                                                               \
>> +                                                                     \
> 
> The reason that we only set test_mem for MMIO BARs is that systems are
> generally more lenient about probing unresponsive I/O port space to
> support legacy use cases.  Have you found cases where access to an I/O
> port BAR when the device is either in D3hot+ or I/O port is disabled in
> the command register triggers a system fault?  If not it seems we could
> roll the power_state check into __vfio_pci_memory_enabled(), if so then
> we probably need to improve our coverage of access to disabled I/O port
> BARs beyond only the power_state check.  Thanks,
> 
> Alex
> 

 I have not seen any system unresponsive in the systems which I am using 
 for testing these patches. If I try to access MMIO BAR or IO port while
 the device is in D3hot+, then I am getting all 0xff. Since I was not
 sure regarding the behaviour in other systems while the device is in
 D3hot+, so I did power_state check outside.

 We can start with power_state check under __vfio_pci_memory_enabled()
 and improve coverage later-on if any issue arises.

 Thanks,
 Abhishek

>>       if (test_mem) {                                                 \
>> -             down_read(&vdev->memory_lock);                          \
>>               if (!__vfio_pci_memory_enabled(vdev)) {                 \
>>                       up_read(&vdev->memory_lock);                    \
>>                       return -EIO;                                    \
>> @@ -51,8 +56,7 @@ static int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,                \
>>                                                                       \
>>       vfio_iowrite##size(val, io);                                    \
>>                                                                       \
>> -     if (test_mem)                                                   \
>> -             up_read(&vdev->memory_lock);                            \
>> +     up_read(&vdev->memory_lock);                                    \
>>                                                                       \
>>       return 0;                                                       \
>>  }
>> @@ -68,8 +72,13 @@ VFIO_IOWRITE(64)
>>  static int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,          \
>>                       bool test_mem, u##size *val, void __iomem *io)  \
>>  {                                                                    \
>> +     down_read(&vdev->memory_lock);                                  \
>> +     if (vdev->power_state >= PCI_D3hot) {                           \
>> +             up_read(&vdev->memory_lock);                            \
>> +             return -EIO;                                            \
>> +     }                                                               \
>> +                                                                     \
>>       if (test_mem) {                                                 \
>> -             down_read(&vdev->memory_lock);                          \
>>               if (!__vfio_pci_memory_enabled(vdev)) {                 \
>>                       up_read(&vdev->memory_lock);                    \
>>                       return -EIO;                                    \
>> @@ -78,8 +87,7 @@ static int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,         \
>>                                                                       \
>>       *val = vfio_ioread##size(io);                                   \
>>                                                                       \
>> -     if (test_mem)                                                   \
>> -             up_read(&vdev->memory_lock);                            \
>> +     up_read(&vdev->memory_lock);                                    \
>>                                                                       \
>>       return 0;                                                       \
>>  }
> 

