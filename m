Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D715C5708D9
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 19:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiGKRa3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 13:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiGKRa2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 13:30:28 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2049.outbound.protection.outlook.com [40.107.93.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99418357E5;
        Mon, 11 Jul 2022 10:30:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IjaivAOcTuczqOADCoUglled7i05yQE0pT2ZZhd6TH+Bwc3luUPKelY5uErzpjRXh+rbvXO+x8eoC1q87NBj9NxdfMVSJZsOXztszJRVXNDTBUOfewFoITWm/ru5TpTgEjwmT6bCdAEAQR44MCepFS65XS5Gx8sOLaoZvpCAMxpSig1jzriFeDhmF6BrfeutL6u6Of5w926o+hlH9vIiIlQcp2QqHvEovHMkhKwtb0IiiqU8P4eHZXL+pmqgzzOQA3pOKZnI8LkX4mz+VlDUjLzhNm+WXYiJffnSnh9kzYDnltKWCYIcNcrD5C4UdJCmvsx5ryUxfP/zcDo3onxlKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nuexyMSABsI7i0y6LtJQ6zCk9WVYeplEOiCYIPUXTeA=;
 b=JJissBUYjGNitP4pwtmvJtkEj5LgZEmi7ZOIN4sM6fOEvY4Y+f7I843Ql1yKCBE3QVrl+mjj7hYjB9uO/iYCui3L1dw/BI0jzFSqs4y7GnT4N6awJSBwTL7VU9HN3tF66IshNzcxmeFz3mLSAGz87r/+xtzh2XxUxVOuiVsoLs3fmOoHd+5/7UnW4bDaeVwDJNrd/SDyDy7LAOUmlqMgvKxVZ4t8+PN7DKoL1e2wvGx1RnsSh7MvT1R//HckoKJ8OuswB0M0mb6ghz9UnsYWnuG4XBwDGH6+yDfhh0xW/3yyNF7XPXcK4uYd9gRnftvYNGqqIV2LunXe4HXW4Wn3Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nuexyMSABsI7i0y6LtJQ6zCk9WVYeplEOiCYIPUXTeA=;
 b=hEP3TumCdxGd9jr75yHaEGB1uJoDVd5p47IVN7mD55ysDa8iG5Prt+X/VaDcBQDYgXBZebwDBbkNd1jTi1Tb7XsOz79hPcqiqaPZUK2arIh8IB7hJ/1lmvrG+9oN6JuuOveDw0rAmv1o3P5099nO7evV/qqhKHP9i71HMcwPWxF7MuStkH/bJVshIEzfJu3grVGGvvuWGxodqHvHGN1LXyd8P53QrSsArYChKb+tX8M5cyvnagZehj3Sf3zoRb+B5BTX7Vnj5IQBCvrgpnvSU6XkFvSk9GR0an5VFr/O9iKUTBjjBTMmMu8nuJbgXznQa/pQniydq9yM46OCvF3iUw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by BYAPR12MB2981.namprd12.prod.outlook.com (2603:10b6:a03:de::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.25; Mon, 11 Jul
 2022 17:30:24 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed%8]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 17:30:23 +0000
Message-ID: <99be22e1-db69-1ecf-a739-e4f603c96f6a@nvidia.com>
Date:   Mon, 11 Jul 2022 23:00:10 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v4 2/6] vfio: Add a new device feature for the power
 management
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
References: <20220701110814.7310-1-abhsahu@nvidia.com>
 <20220701110814.7310-3-abhsahu@nvidia.com>
 <20220706093959.3bd2cbbb.alex.williamson@redhat.com>
 <ad80eb14-18a1-8895-ecfb-32687a4ba021@nvidia.com>
 <20220708103612.18285301.alex.williamson@redhat.com>
 <083b39f0-7ebf-cb8f-fc52-f9a29a4f3d3f@nvidia.com>
 <20220711070446.2bd6ac80.alex.williamson@redhat.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220711070446.2bd6ac80.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA1PR01CA0079.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::19)
 To BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db90f352-3822-40dd-d5bd-08da63630925
X-MS-TrafficTypeDiagnostic: BYAPR12MB2981:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dJyqs1A42E0BJmWZyl0Lm9WVzq7ByZdbl1veq6yHaTCND9PNP987oILyAx68qxiLVusUoUoO/gYII9ZUbIDz8vtRgfxSyL/I9NY3B+dN+YIX939JPVE8XM2wF147YQ3cULzFWX+JMlRFqR9Z4A32vOmiDvtUPYAfVqK6WJEVoHlAlBv28eOr1NryBk/jVeUJRyMWlJzf3LNJCnLaTUeuW1YWS7O5Hgo2xHtlDrloFTv74dgzPJylZJ17biR88MXb9at/4dR5Pa2C56Mxgt7lzX92Q7eksG6Tbs/Ntsu09Mw6wllEkYg5vXc+Uo2ytOMfgxEWwc7XMwq/ND7fs7tkPvrHLF4T7n6I74aoWdD/7s8czb3AUrKHuKv+40maqSWuOBEmOU+w7CkYOT3jQUsf0nZVexoHyPwbcHsQaU/R66Lq2ebjJ1jM4tgHaqpgNPiFPw5boxtMCNYpm1YihdKJKCeu8maw6JeZKgHc5hETvbc2yapO6tyzI1r/tbTP/uf6xtCM/sUPuI4OLrU0zDrD+Ip5Y0Uem50I3iu/Rb7bdIUeGb4laIWsaHQZWjMRDsluV8Vj587eYFt7KcbK2tF7etHEg5tSeiTU1rkbvip9sVXWzNyeJO2vgr9EDv8qdg+otb7fPgzMcYvP9cQF/Sn86uL25QkEuAdurbmUCN4mKq8rS4Jw/O0dsyW1xB9JmGz4QzE9NHwj68dGnO1BmQALujZt42kYITyk9lZt5/hFhBPpritT4+un/QnXBMUsxGSe7aYacymmhEvyxi/prdgMJFRjFuyYZKFkS1M9Co8Fe5BwhikaRVPu/RauzL+8sZFa8ndVjNodZL3WVffJskj5wB1nLg9q10H0okhyg2KT0v8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(366004)(39860400002)(136003)(376002)(84040400005)(2616005)(66946007)(66476007)(66556008)(186003)(8676002)(31696002)(83380400001)(6666004)(316002)(6486002)(4326008)(478600001)(53546011)(55236004)(38100700002)(31686004)(6506007)(86362001)(26005)(6512007)(6916009)(54906003)(41300700001)(8936002)(2906002)(36756003)(7416002)(5660300002)(30864003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?KzREMWNXS0MwamhGRzlIY0tZTmlnRWQzcWVnY05HRjVaSE1EUVBDTDJOclp3?=
 =?utf-8?B?cWU3UmxKSHloUEMrTGxYQ3RDb2JKUHZ5WkRvVG55ZlQwTmVpMFQwMXVLZkM2?=
 =?utf-8?B?aDRreDh4MDNuK3M2U0dNb0p3UXFRQUtMOEVjMVpESWMxZmZCK1FsOVhlb2ZZ?=
 =?utf-8?B?MlVxUm5neTc1MFM1RWFZeUVWTEc3NStPSEJuUmI4bERvMDhSSnFZaytHOEJv?=
 =?utf-8?B?K3pVcEpPY045VndGWi9nRzVzUVB2dEtORVZ6MmZlL3JodUFHUTVJSG5adnYz?=
 =?utf-8?B?QWhlNFhGaWxRaDJ6N0NmSkdXNEFXdExpMXE2MlZPRFVCN3YvM0N0eG02YXJJ?=
 =?utf-8?B?YmVGNSszTHVUd0tWYWFuZFM2YjUreHZxRmtGYXZwajhObVZsdDVzVVcxU2lT?=
 =?utf-8?B?Zy9oNjlDKyszTlZVZ3ZjVWQxME1BMXRtajdvNzMveXpsdm9QdVowcWxoeGlW?=
 =?utf-8?B?bkFRL3hYQ1VUUXE3blJQOHhMUXJ5ckRCdHk1M1dRQm5NdENCbUw0QUNIWnUy?=
 =?utf-8?B?NWtRVkNXYm03VEYwU3g5UHpGWVllZXFTaUVhay92cmNuYS8wOFJkcWZQWHJh?=
 =?utf-8?B?dGlVa05WK0lpMmNzdUx6VlFmYTliU2J4aHlWTzRTNTVJZzNZUVZVQVBreWVt?=
 =?utf-8?B?WExMNVlWR2E5ZGZWTW5pZGZ3dVRKVTlaK3BxekluN0p3bVpMWmRJdjkzUHBa?=
 =?utf-8?B?aVRHYUs2VzZmTEFPTUJsWG1uZHZwTnpXajZ3YjJORUFISkRSVk5RWkExMnY0?=
 =?utf-8?B?T203OHdpVExXUnNSV2JjQTljaGRVaEtoMnZjQnJHWXdUNWRKY0VtdExRSHF6?=
 =?utf-8?B?eG1IT0xpaklweSs1Y3hRRnFPelRXdUdFNDN1V3diaXg0c2xwOENQV0hYZUxx?=
 =?utf-8?B?Vlo4Y2VmTzN3U2kybXlkcFBJRkJ0TWkyNXBYSXhNRDhpVG54bWpHcWZ4YTJz?=
 =?utf-8?B?RTdHSEw1Q0VVRkR3TytUTlBSSGVrS214N3diWGphUmQ3SExGZndLWFAwZGV4?=
 =?utf-8?B?NW16cHNZd1BHNnh6YjdEcDVqQ0VkV1p6dEN4SlhFZEw3ay9RQ3YwMXhubllN?=
 =?utf-8?B?OGI4SkNZWW10ZTB1M0c3a0N5L2ZzVGNTVDFaUmFKazhRZkdvb0F6UXVCS2hw?=
 =?utf-8?B?WGZTREF0TTdDclFDYVA2d004d29vRU12dVh1V2RtNEdUYTcxT255Q0p1YmV1?=
 =?utf-8?B?dG02ck9HaFFQS2hEMENNcFhMaFg0YmduNUpibXNiNWg0YkNHSFpkUDNQZEFy?=
 =?utf-8?B?WnBkNkxNcVhUcU5RRXordng4Mkw0bWNoSzQyMFFDWGloUDVrMXloVjVjMlox?=
 =?utf-8?B?R0c2bVpUc1VxMEFEQm1uRDMvWXJpd3dqVjhaY053TExtKzhybk9Tb3l4QUFi?=
 =?utf-8?B?Vnh5QjBiODBYNkZseUxjZHVZb0Y1bTAxUTZreVVjb0dDbHV6aXBKRUNiUjhX?=
 =?utf-8?B?UlVYT2M4czdyV1plcnJndCtYSmFibnl4enRsckVGK2liTmlUNWI1ZkNONSs3?=
 =?utf-8?B?eW43SGhrUVhLdWRPbno3bHFQY0t0NVJvL0ZwQXJqZVZuYWtNYjRiUHZPWnpN?=
 =?utf-8?B?WlVBRUk2cHQ3bmJoNEZBS3hQQ0RTNFh3d00zKzdLVzA1S0lmNGs0am00QUpZ?=
 =?utf-8?B?dFcxZ2hQQWZWWC9ocTR0eXVPVDlVTmw1NlJKb0pFdlJPQmt4OUxWK0pSSVRI?=
 =?utf-8?B?V01FUHliRW1aNlBWcmlMa0xQWGkvZEZIc3BCamJQZFNrYjdxd1JHY2F1aUlo?=
 =?utf-8?B?YWF0c0dCc2tMcEJwZzNPWXJEWmdqd2dFZE5Db2lta2xTSW03NzBhaTZ1Q0Ev?=
 =?utf-8?B?c1VsNWg3Wk15MkVCVmQycnoxL0dUYThSUE10RjlzUVVNb0NSbXlhTFRpTnA2?=
 =?utf-8?B?NEEzNUNmYTg0anB1Z1RIa3dPVGNwZE9GVG90NmcyYnNVYURvZG56Ukl1R216?=
 =?utf-8?B?OEI4RHo5QXgxdFc3R0hIUFlGV3h2aWk0MlZaR2FUQVZHREdJSWhIaTBWVW93?=
 =?utf-8?B?MHJkTGNxeGxma1Jpd0xXWU5PRlF1cHdlVUdFeWRXcU1rSFhISTdidEFyNVE2?=
 =?utf-8?B?emd4M01naUdwWG9nWWY1SmNHZ1NDcGtyR2hsNVZQMHJ2MWIrMmlDYTdxRndv?=
 =?utf-8?Q?1JD1ncWjv+UMNIQQobcRx3uyi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db90f352-3822-40dd-d5bd-08da63630925
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 17:30:23.6325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BjyZXPRSEomHOvXUARTtVLLFYiDSKviosDWpX7mEyIJE7+pfD56mTPrcrnr0qhUhgDqLmk+R6QsDIcj+Rrsp2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2981
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/11/2022 6:34 PM, Alex Williamson wrote:
> On Mon, 11 Jul 2022 15:13:13 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> 
>> On 7/8/2022 10:06 PM, Alex Williamson wrote:
>>> On Fri, 8 Jul 2022 15:09:22 +0530
>>> Abhishek Sahu <abhsahu@nvidia.com> wrote:
>>>   
>>>> On 7/6/2022 9:09 PM, Alex Williamson wrote:  
>>>>> On Fri, 1 Jul 2022 16:38:10 +0530
>>>>> Abhishek Sahu <abhsahu@nvidia.com> wrote:
>>>>>     
>>>>>> This patch adds the new feature VFIO_DEVICE_FEATURE_POWER_MANAGEMENT
>>>>>> for the power management in the header file. The implementation for the
>>>>>> same will be added in the subsequent patches.
>>>>>>
>>>>>> With the standard registers, all power states cannot be achieved. The
>>>>>> platform-based power management needs to be involved to go into the
>>>>>> lowest power state. For all the platform-based power management, this
>>>>>> device feature can be used.
>>>>>>
>>>>>> This device feature uses flags to specify the different operations. In
>>>>>> the future, if any more power management functionality is needed then
>>>>>> a new flag can be added to it. It supports both GET and SET operations.
>>>>>>
>>>>>> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
>>>>>> ---
>>>>>>  include/uapi/linux/vfio.h | 55 +++++++++++++++++++++++++++++++++++++++
>>>>>>  1 file changed, 55 insertions(+)
>>>>>>
>>>>>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>>>>>> index 733a1cddde30..7e00de5c21ea 100644
>>>>>> --- a/include/uapi/linux/vfio.h
>>>>>> +++ b/include/uapi/linux/vfio.h
>>>>>> @@ -986,6 +986,61 @@ enum vfio_device_mig_state {
>>>>>>  	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
>>>>>>  };
>>>>>>  
>>>>>> +/*
>>>>>> + * Perform power management-related operations for the VFIO device.
>>>>>> + *
>>>>>> + * The low power feature uses platform-based power management to move the
>>>>>> + * device into the low power state.  This low power state is device-specific.
>>>>>> + *
>>>>>> + * This device feature uses flags to specify the different operations.
>>>>>> + * It supports both the GET and SET operations.
>>>>>> + *
>>>>>> + * - VFIO_PM_LOW_POWER_ENTER flag moves the VFIO device into the low power
>>>>>> + *   state with platform-based power management.  This low power state will be
>>>>>> + *   internal to the VFIO driver and the user will not come to know which power
>>>>>> + *   state is chosen.  Once the user has moved the VFIO device into the low
>>>>>> + *   power state, then the user should not do any device access without moving
>>>>>> + *   the device out of the low power state.    
>>>>>
>>>>> Except we're wrapping device accesses to make this possible.  This
>>>>> should probably describe how any discrete access will wake the device
>>>>> but ongoing access through mmaps will generate user faults.
>>>>>     
>>>>
>>>>  Sure. I will add that details also.
>>>>  
>>>>>> + *
>>>>>> + * - VFIO_PM_LOW_POWER_EXIT flag moves the VFIO device out of the low power
>>>>>> + *    state.  This flag should only be set if the user has previously put the
>>>>>> + *    device into low power state with the VFIO_PM_LOW_POWER_ENTER flag.    
>>>>>
>>>>> Indenting.
>>>>>     
>>>>  
>>>>  I will fix this.
>>>>  
>>>>>> + *
>>>>>> + * - VFIO_PM_LOW_POWER_ENTER and VFIO_PM_LOW_POWER_EXIT are mutually exclusive.
>>>>>> + *
>>>>>> + * - VFIO_PM_LOW_POWER_REENTERY_DISABLE flag is only valid with
>>>>>> + *   VFIO_PM_LOW_POWER_ENTER.  If there is any access for the VFIO device on
>>>>>> + *   the host side, then the device will be moved out of the low power state
>>>>>> + *   without the user's guest driver involvement.  Some devices require the
>>>>>> + *   user's guest driver involvement for each low-power entry.  If this flag is
>>>>>> + *   set, then the re-entry to the low power state will be disabled, and the
>>>>>> + *   host kernel will not move the device again into the low power state.
>>>>>> + *   The VFIO driver internally maintains a list of devices for which low
>>>>>> + *   power re-entry is disabled by default and for those devices, the
>>>>>> + *   re-entry will be disabled even if the user has not set this flag
>>>>>> + *   explicitly.    
>>>>>
>>>>> Wrong polarity.  The kernel should not maintain the policy.  By default
>>>>> every wakeup, whether from host kernel accesses or via user accesses
>>>>> that do a pm-get should signal a wakeup to userspace.  Userspace needs
>>>>> to opt-out of that wakeup to let the kernel automatically re-enter low
>>>>> power and userspace needs to maintain the policy for which devices it
>>>>> wants that to occur.
>>>>>     
>>>>  
>>>>  Okay. So that means, in the kernel side, we don’t have to maintain
>>>>  the list which currently contains NVIDIA device ID. Also, in our
>>>>  updated approach, this opt-out of that wake-up means that user
>>>>  has not provided eventfd in the feature SET ioctl. Correct ?  
>>>
>>> Yes, I'm imagining that if the user hasn't provided a one-shot wake-up
>>> eventfd, that's the opt-out for being notified of device wakes.  For
>>> example, pm-resume would have something like:
>>>
>>> 	
>>> 	if (vdev->pm_wake_eventfd) {
>>> 		eventfd_signal(vdev->pm_wake_eventfd, 1);
>>> 		vdev->pm_wake_eventfd = NULL;
>>> 		pm_runtime_get_noresume(dev);
>>> 	}
>>>
>>> (eventfd pseudo handling substantially simplified)
>>>
>>> So w/o a wake-up eventfd, the user would need to call the pm feature
>>> exit ioctl to elevate the pm reference to prevent it going back to low
>>> power.  The pm feature exit ioctl would be optional if a wake eventfd is
>>> provided, so some piece of the eventfd context would need to remain to
>>> determine whether a pm-get is necessary.
>>>   
>>>>>> + *
>>>>>> + * For the IOCTL call with VFIO_DEVICE_FEATURE_GET:
>>>>>> + *
>>>>>> + * - VFIO_PM_LOW_POWER_ENTER will be set if the user has put the device into
>>>>>> + *   the low power state, otherwise, VFIO_PM_LOW_POWER_EXIT will be set.
>>>>>> + *
>>>>>> + * - If the device is in a normal power state currently, then
>>>>>> + *   VFIO_PM_LOW_POWER_REENTERY_DISABLE will be set for the devices where low
>>>>>> + *   power re-entry is disabled by default.  If the device is in the low power
>>>>>> + *   state currently, then VFIO_PM_LOW_POWER_REENTERY_DISABLE will be set
>>>>>> + *   according to the current transition.    
>>>>>
>>>>> Very confusing semantics.
>>>>>
>>>>> What if the feature SET ioctl took an eventfd and that eventfd was one
>>>>> time use.  Calling the ioctl would setup the eventfd to notify the user
>>>>> on wakeup and call pm-put.  Any access to the device via host, ioctl,
>>>>> or region would be wrapped in pm-get/put and the pm-resume handler
>>>>> would perform the matching pm-get to balance the feature SET and signal
>>>>> the eventfd.     
>>>>
>>>>  This seems a better option. It will help in making the ioctl simpler
>>>>  and we don’t have to add a separate index for PME which I added in
>>>>  patch 6. 
>>>>  
>>>>> If the user opts-out by not providing a wakeup eventfd,
>>>>> then the pm-resume handler does not perform a pm-get. Possibly we
>>>>> could even allow mmap access if a wake-up eventfd is provided.    
>>>>
>>>>  Sorry. I am not clear on this mmap part. We currently invalidates
>>>>  mapping before going into runtime-suspend. Now, if use tries do
>>>>  mmap then do we need some extra handling in the fault handler ?
>>>>  Need your help in understanding this part.  
>>>
>>> The option that I'm thinking about is if the mmap fault handler is
>>> wrapped in a pm-get/put then we could actually populate the mmap.  In
>>> the case where the pm-get triggers the wake-eventfd in pm-resume, the
>>> device doesn't return to low power when the mmap fault handler calls
>>> pm-put.  This possibly allows that we could actually invalidate mmaps on
>>> pm-suspend rather than in the pm feature enter ioctl, essentially the
>>> same as we're doing for intx.  I wonder though if this allows the
>>> possibility that we just bounce between mmap fault and pm-suspend.  So
>>> long as some work can be done, for instance the pm-suspend occurs
>>> asynchronously to the pm-put, this might be ok.
>>>   
>>
>>  We can do this. But in the normal use case, the situation should
>>  never arise where user should access any mmaped region when user has
>>  already put the device into D3 (D3hot or D3cold). This can only happen
>>  if there is some bug in the guest driver or user is doing wrong
>>  sequence. Do we need to add handling to officially support this part ?
> 
> We cannot rely on userspace drivers to be bug free or non-malicious,
> but if we want to impose that an mmap access while low power is
> enabled always triggers a fault, that's ok.
> 
>>  pm-get can take more than a second for resume for some devices and
>>  will doing this in fault handler be safe ?
>>
>>  Also, we will add this support only when wake-eventfd is provided so
>>  still w/o wake-eventfd case, the mmap access will still generate fault.
>>  So, we will have different behavior. Will that be acceptable ?
> 
> Let's keep it simple, generate a fault for all cases.
> 

 Thanks Alex for confirmation.

>>>>> The
>>>>> feature GET ioctl would be used to exit low power behavior and would be
>>>>> a no-op if the wakeup eventfd had already been signaled.  Thanks,
>>>>>    
>>>>  
>>>>  I will use the GET ioctl for low power exit instead of returning the
>>>>  current status.  
>>>
>>> Note that Yishai is proposing a device DMA dirty logging feature where
>>> the stop and start are exposed via SET on separate features, rather
>>> than SET/GET.  We should probably maintain some consistency between
>>> these use cases.  Possibly we might even want two separate pm enter
>>> ioctls, one with the wake eventfd and one without.  I think this is the
>>> sort of thing Jason is describing for future expansion of the dirty
>>> tracking uAPI.  Thanks,
>>>
>>> Alex
>>>   
>>
>>  Okay. So, we need to add 3 device features in total.
>>
>>  VFIO_DEVICE_FEATURE_PM_ENTRY
>>  VFIO_DEVICE_FEATURE_PM_ENTRY_WITH_WAKEUP
>>  VFIO_DEVICE_FEATURE_PM_EXIT
>>
>>  And only the second one need structure which will have only one field
>>  for eventfd and we need to return error if wakeup-eventfd is not
>>  provided in the second feature ?
> 
> Yes, we'd use eventfd_ctx and fail on a bad fileget.
> 
>>  Do we need to support GET operation also for these ?
>>  We can skip GET operation since that won’t be very useful.
> 
> What would they do?  Thanks,
> 
> Alex
> 

 If we implement GET operation then it can return the
 current status. For example, for VFIO_DEVICE_FEATURE_PM_ENTRY
 can return the information whether user has put the device into
 low power previously. But this information is not much useful as such
 and it requires to add a structure where this information needs to
 be filled. Also, the GET will again cause the device wake-up.
 So, for these device features, we can support only SET operation.

 I checked the Yishai DMA logging patches and there start
 and stop seems to be supporting only SET operation and there is
 separate feature which supports only GET operation.

 Regards,
 Abhishek
