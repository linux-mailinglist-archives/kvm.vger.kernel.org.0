Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C37BD7CAC26
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 16:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233624AbjJPOuE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 10:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232959AbjJPOuC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 10:50:02 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2085.outbound.protection.outlook.com [40.107.212.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88AF2E1;
        Mon, 16 Oct 2023 07:50:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nA/SHM9GwNpuGiQMv2LS3Er8tWbgwt7cWkagr7GZ1rq1eysaMa2ftDMbvqGx52ke0xVwBDalBxU6oYnEnsbSg1Rg0m6GmY6s9DB96IRjhs93AlTuS4CkkkNN4dGZXb6tuxsbOKXBHECnhU8EOiE3WPTDzRF418qFYrUTwdRxZAep6fg0Li2DCt2oQJyl/YBfNzI1PdIXL+m+YrJk2+jV2m96voBwKyTQnsAWQJplZHZUambLFLusDtGi5qa6UxnIdZw5Rql+YFnl6Ys7txsIeD4MQ16E6ookx9Q0rNyxoUZiLJ31mQ7wa8b2JQWFCYYaopJJHq5mXnlrNDv/aNvX1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DJnSQ7kV7qNbfJSS9/zX7KAo+oj4Il8d7u9MFAfd2lI=;
 b=JV+S9pDAZ0M4/iNe5vjRNgGep3LDrX+45dYs8JUItd0p3TnxDxcJqnjTab6GJ+O2/Y1ynzqr30otf9uqkQN+OmNxj3+TTozmwna0ib+xVz/Cmv/9yrLotaiLRybc2/fO9XOlPvUG+kN4zY+sqt1AhixnmdSSHAd/QrSBXOeA72ttkP5LmU+OsRJ/9dV5T02dI28rxvYg2/rewFJ2Hh+zunHT31lZ3Yl9aFzKRjrvLSy46pFHh1/R59wksdzWVy9DKOGn09iXusbkRuFAB8q2wDFEzBcFRkB1/JNLNth0J5NIuzGzVxqdOZjWaJT1P/7G+WrkPcInYF5NgYNo3qsNng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJnSQ7kV7qNbfJSS9/zX7KAo+oj4Il8d7u9MFAfd2lI=;
 b=0olcSJy0XW3P3GAPcQmFnn1wWtigns1Q3X8TvgfEtfl8ozC7zaZhSqqUKJTExGEm9vY0yZBPwWrW5VHCxfHUhjtBPZ32grqMoeRi+79mktBrVcNMh55kPW6MRU7EP3UQGSxAWjZp4m5arDulpY44zJ/zLOpb/p5JqnVn8WwtPsQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by BN9PR12MB5242.namprd12.prod.outlook.com (2603:10b6:408:11f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Mon, 16 Oct
 2023 14:49:57 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::8859:6c1d:e46c:c1b2]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::8859:6c1d:e46c:c1b2%4]) with mapi id 15.20.6886.034; Mon, 16 Oct 2023
 14:49:57 +0000
Message-ID: <2cd89c2c-96fc-8395-2c44-5804fe5c6594@amd.com>
Date:   Mon, 16 Oct 2023 07:49:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 vfio 0/3] pds/vfio: Fixes for locking bugs
To:     Alex Williamson <alex.williamson@redhat.com>,
        Brett Creeley <brett.creeley@amd.com>
Cc:     jgg@ziepe.ca, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        dan.carpenter@linaro.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shannon.nelson@amd.com
References: <20231011230115.35719-1-brett.creeley@amd.com>
 <20231013150940.50804350.alex.williamson@redhat.com>
Content-Language: en-US
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20231013150940.50804350.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0016.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::29) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|BN9PR12MB5242:EE_
X-MS-Office365-Filtering-Correlation-Id: 4086bb57-19b1-4587-6891-08dbce572a85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0VUAiJ66g2f6/KHbGgla3+dATie3OO/IhUigmjXVtC7ggBugySxVQRPJQjXqhOv+ul5UpHMQYG644NjgtdCZIacPnYb2wThFsC9wXuuCoI4icx2YHI08ZsrlsW3n0H4eqaMvT5G+THF7sPoRLL4J/dcjKJxAvEekGAQ29JtvkinL9/ZfQl5XdnJ0nql3AyVo+EtVKcZku09fwbjWOA/h8yG7mKGMUIR99sRd5Ea9niKlO73gBABjqxi82EQqCXlXrRD5nnev4yeyEinL4IbR7YmOrnXCWdP7lOE4JljNMI2BR47mzHFpUYTf60Vl4+iWnlmkyPq3D+rcWxyg/MLoOhJ44YSfoXBEyBJR0hdo7eLgLdiqMCTwEu4x20jZbHDzAjOr8oGFqv/5maEbWbwftIycTIbopcXGUo7bKfn0/6qeBNoqpLPwHEnaXiVqiJsUqqNgH/QYaC2Lf6ul8DIGT5oR+xkGGW2aveDG7JfmY51qJa0GzhlXpaFVnlJqoqlYhTeOJaMuD8QOJqbKG8kL0dE8OR+6s4De+FXbveKjPbikYqcI6FS7ANBVdwk8HSkimbf4DzgBuNxk41czwxZPisOAGBBHuFiTd8lmiCr6HV8EmlxKcgdD8Zpm34lrRox3OXx3yI8U745Tc2/kVbXeKttaWDEYiiwb3GHOYchMgpjIQykLq9uGkzPoRhYkKHM1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(396003)(136003)(39860400002)(346002)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(26005)(2616005)(8676002)(8936002)(4326008)(5660300002)(38100700002)(83380400001)(31686004)(41300700001)(478600001)(31696002)(6486002)(966005)(110136005)(2906002)(316002)(6636002)(6666004)(6506007)(6512007)(53546011)(66946007)(36756003)(66556008)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VTJQYWRQUk05OUczZzdvTTRPcm9wdUROaTFtdXN3TUozaXc3NHFJTitPKzZz?=
 =?utf-8?B?ckFOeUNRMmlsbk5JTWt6ZjBNSUVhcEtZRi9COUtCU3d0TXF4ZEdKZmlHMnRP?=
 =?utf-8?B?SGdZVHgwbk05dHdTMlI5T3NTVXNTeWE4dFhhOStYQVEwN2p0VHFoeS8vd2Zk?=
 =?utf-8?B?QjBuem5udVlGaEhHYXpUN0lvQ0kzWjZKUmpHbWdIb2RDNDU1L0NqYzg3ZnRw?=
 =?utf-8?B?c3VrclFXZkw3Tm9Pa1ozY0x1U0lQRk10K1ZxbEdpVEJJMHp6UXZjYlZJd1p5?=
 =?utf-8?B?WEpiUlllTURzR09pZTFZZXplMmVISndsMUYvRXFPQmNvSkJMTzZFcHVrWjVO?=
 =?utf-8?B?WGl4RnNOME5xS0ZaSmlXUUNjeUl5TmExN0c3YVZOYVFvNmh5TnBsTjl0cEZQ?=
 =?utf-8?B?RHgxcXl3VXVtTmxQcnFtTG1KYUdaMUVyY3g0Y0tqYU1lSnJ0SzUxNGJFeFV1?=
 =?utf-8?B?TkM4Z0t2VjZmV1h0YlBGMXJmaEF2Y0J3NFpiSlplMXdsdllPNWN5bmZGdWZu?=
 =?utf-8?B?TlRKUkwvVEQ0QW9JeXE0NzdmS3hXTEM2azdYUDMrenVxbHR3U1Y0dnVzR3hq?=
 =?utf-8?B?SGtNQm1WOUUrbC9YaDF0YjNGQmJPZXRUb2tqMDZVc1lNYTRYWEQ3dmdORm41?=
 =?utf-8?B?SUVlTlNaMUo3MGsvNHZKbmkxaDRzbWRnbTluVGdieEpzSWcrL3U4Z3cyempl?=
 =?utf-8?B?djdBc3VSemo0ck1tTERmSUxNZmVsNEZ3R0ZFT0tvVXZ4enB4RGdDWE4xQjEz?=
 =?utf-8?B?OGNZVVcyeWJKVmo3SjVkTGVGRVgrMkFyd1dWTmlVeDZFS1VPb0VTdFpIM2RK?=
 =?utf-8?B?T0hVSkFsWEMzUDE2YzMwa2ZMaVUyZHBIbmdPclcyL0YwSEZUbDhsT09FUEds?=
 =?utf-8?B?ZzFxQXZVa2xnYVorSFEyWTNrUk92RlZHWVpDUW9qMk5wSnpmNktpT0c1bmJR?=
 =?utf-8?B?WUdmRG1ObzJ3TS93Y3RNekR4bEtkTGdtMUNWS05uenAxYkh1ZHRnL1BvMXoy?=
 =?utf-8?B?aEg3bUtlOVZONkdOaXJGOG80dkIyNHNsSUdKVGJvUGMwVVNCeTh6UElPdzVX?=
 =?utf-8?B?cXpFYlNFTGRpelFlOEhMeFlRV0FlSVRla2U4Nm9TenJjK2todWhkQUErRTJC?=
 =?utf-8?B?Ym1yYUJ0QzZyYzdFQ3lidVlrSUpaNkRNL0lJQktXS25hSlN2VWVMQm9RN1RF?=
 =?utf-8?B?TDNjenUyUndkaEo0Zlk3NjZLTlhQUGZGNXhUQU9wRjN3OEo2MUdicTNMZ3lS?=
 =?utf-8?B?YnpESXErSUwwWCtYaE8ycCtxSGlXeklxbWVZdldJTllyYjRyODBUaUFwTmE3?=
 =?utf-8?B?Sm9ha0RvS20yOUxBRi83OTBVbEgrK1dLVUFLeDMyOEVVcEV2eFA5OTN3R3Jn?=
 =?utf-8?B?c3NKYzdLa1piaWFGd2xrUXUrSCtwNm9OQ1dKV3d0SkhFelIxem01MjBFNVhX?=
 =?utf-8?B?WUQ4b05aVFAzd1RPZ1JrWk9nTEhwRHdKRkVTMjAyRkN4VVE2cXRCaVY2eTVG?=
 =?utf-8?B?aXU0RFJPbGRtSFV1dTRYaXRxZGZVT1dtTTJEc3U2Sm83Z2o5RXJ6WDFTYTVL?=
 =?utf-8?B?TXVjaDBuMXllcFdxMG9UOG1UMzBFNGJjb0R4eSs3Ni9OMml0d2ttSTFoeXJq?=
 =?utf-8?B?YmlpY2ZkS1Q4VFQ0Q2xhYXBsK0tUYUVIYzZyQWZzQzdzVCtlK0t5cTZMM3ht?=
 =?utf-8?B?b0hOZWlUbXRwNTJiVXJ1WmhiYVZWM3VkWlQzVHN2MFhLbHNUVDNyVFRkT3hD?=
 =?utf-8?B?SkFQeEhiMlpFZllLNW8yb1ZoUTRGek9UampQK085V0IxN1lvdm5rV0R4eWU0?=
 =?utf-8?B?Rk5zWjlYSnhXZTRZZVZnV2NkY0JRRUg2L0haOGxSNy9Henc1eDM5NlFWVlQ5?=
 =?utf-8?B?QkJsMFJ6Z2N6K0N1WTJwVHRDanRlcTlPSHo0UmMvekZnZjBNekVHOWVMakdJ?=
 =?utf-8?B?NGpDZG42cWRJNDkzN2psV2dZYms5MDhvQ3ZuTUJvOEw3S3ZTaWpTejYvL2Jq?=
 =?utf-8?B?UitNbldWeEU0SS9TNjJpSFk2L21QYnE3Nmt2cHRIQlJmVDBNb2RvZ2dsNktq?=
 =?utf-8?B?VEROVHRlRGpieFhMQ01oMWh3M2F2bFgzWEF0QmRvWHVsc3pISHZXdnJPc0xh?=
 =?utf-8?Q?u3RhnPYKQi43KZ1vSD6+HME31?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4086bb57-19b1-4587-6891-08dbce572a85
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 14:49:57.5161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IJwdOj1UPOh3a34yS5MyEkhxFaesHJWcAXoYp7SD6QPduWaTqYEbkMypx0F6SMhZnE4TGUXRrUwWyRnHI7mLrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5242
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/13/2023 2:09 PM, Alex Williamson wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Wed, 11 Oct 2023 16:01:12 -0700
> Brett Creeley <brett.creeley@amd.com> wrote:
> 
>> This series contains fixes for locking bugs in the recently introduced
>> pds-vfio-pci driver. There was an initial bug reported by Dan Carpenter
>> at:
>>
>> https://lore.kernel.org/kvm/1f9bc27b-3de9-4891-9687-ba2820c1b390@moroto.mountain/
>>
>> However, more locking bugs were found when looking into the previously
>> mentioned issue. So, all fixes are included in this series.
>>
>> v2:
>> https://lore.kernel.org/kvm/20230914191540.54946-1-brett.creeley@amd.com/
>> - Trim the OOPs in the patch commit messages
>> - Rework patch 3/3 to only unlock the spinlock once
> 
> I thought we determined the spinlock, and thus the atomic context, was
> an arbitrary choice.  I would have figured we simply convert it to a
> mutex.  Why didn't we take that route?  Thanks,
> 
> Alex

Hmm. I guess it wasn't completely clear that was the expected solution 
even after Jason's response. However, I can resubmit a v3 with that change.

Thanks,

Brett
> 
>> - Destroy the state_mutex in the driver specific vfio_device_ops.release
>>    callback
>>
>> Brett Creeley (3):
>>    pds/vfio: Fix spinlock bad magic BUG
>>    pds/vfio: Fix mutex lock->magic != lock warning
>>    pds/vfio: Fix possible sleep while in atomic context
>>
>>   drivers/vfio/pci/pds/vfio_dev.c | 27 ++++++++++++++++++++-------
>>   1 file changed, 20 insertions(+), 7 deletions(-)
>>
> 
