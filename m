Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2565E772CF3
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 19:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbjHGR3S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 13:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbjHGR3N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 13:29:13 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3F619AF;
        Mon,  7 Aug 2023 10:29:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ibo7U31RHF+IeebAWo6ggSVQlXBqD3zbDi6x8qP6z6d84gxGzQS1vmQd6emSiXDYVVk2OLiOudBSz0ndk+u5CO+IuashExCVkBpW3O6/qLZLRHlBAIIQF6gQjPFp5x6SzlJsrUozBe5Nj5VPAg2yEk7oUikB+EfJ+/6RwyHPfPZf4du20wEotFn247my4fDHgtr8RMiKf/pzz2humjYWLxtRLk0zfNZ6Xtu5tgFwqzlCkI0b7sVpkGLM3YDRwhU77bXXQ/TJEVPwCUFbUmtMjcQgAuc3C0/rSSe2WqTT3K1biRhBXlN4vz2A+f9JuaidNzAagJctR0tOGaQY3dMIkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EFUjQXXYfUvAi/3QuNG2iH19psAztW1LSlDfNtLTBd8=;
 b=HdeHo3pgONr0zJlRu2nuNgxxu2bOzqkB1DQ3/voNIc3vhACTw2U6Ju2kVji9ohHrBf+AomX61CqORwJCM+uN3qewc7I8maDIHjkM1bm4nJeO8ZCYILjlxvVkc2R1rUU07oFOPc69bAxTrVSqtIpqAejlTN8GSo2gKxFjFGN3M6UxdNr+BSA/PK+Pyd+RNv1bS64xpfhnzSjd0Q074r26QiPYorCbkwHFuvduJ3g40VskmMcwXKPbzomQcKNLAIW0Kr9bkZhw7HDCwto44aIhqfHBuWUbpQPRMcRABPvJswfHqIifItiShvC9ZqDHmgoP6X2o6SKIJ7pUFc3SVkG24g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EFUjQXXYfUvAi/3QuNG2iH19psAztW1LSlDfNtLTBd8=;
 b=T3gXmqG0TsOrFG9FrSaV2n7JH+a11h+5n3th41UeJ6xkgO2UmjAD0HsbsHX41zVHvJapMbBwFehquAaapQLlvwfvKiGMhUxc8vDKUo0Bad10BqWcWeMGo4qgIADRb9vpC5RipogZVV7G8Dy3BD09Fq/Y0E3bqZahqaMD9Oawjxs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by PH7PR12MB7871.namprd12.prod.outlook.com (2603:10b6:510:27d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.26; Mon, 7 Aug
 2023 17:29:00 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2%4]) with mapi id 15.20.6652.026; Mon, 7 Aug 2023
 17:28:56 +0000
Message-ID: <cf353f24-6c18-7d2d-b797-d81646fd3bed@amd.com>
Date:   Mon, 7 Aug 2023 10:28:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v13 vfio 3/7] vfio/pds: register with the pds_core PF
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Brett Creeley <brett.creeley@amd.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, alex.williamson@redhat.com,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com, simon.horman@corigine.com,
        shannon.nelson@amd.com
References: <20230725214025.9288-1-brett.creeley@amd.com>
 <20230725214025.9288-4-brett.creeley@amd.com> <ZM0vTlNQnglE7Pjy@nvidia.com>
 <44535ea4-9886-a33a-7ee2-99514f04b53c@amd.com>
 <afdd5231-cd7b-c940-7c51-c522b4cb5b90@amd.com> <ZM1+48h9EcqqXrZI@nvidia.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <ZM1+48h9EcqqXrZI@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8PR07CA0026.namprd07.prod.outlook.com
 (2603:10b6:510:2cf::21) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|PH7PR12MB7871:EE_
X-MS-Office365-Filtering-Correlation-Id: b24ca7ab-ebc8-41bb-a6bd-08db976bc770
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zVJZY5xH5jH48TSYPlcpeu/as07BIzGZkNP/zJ8Ak/SF54Z6AZefCF1JG3y9e0iyOfU85FS9Sm1eWOPJ5mrjtoylwb0x1EkrHMMBnmYhqbJEzIXf9A756Ywroph1dVQ7y6J07jmHz0IW5ywlDaBznP83SAHhYRtPNZsC1e4tIA8rckZX0EH4R9wMpILvwRjtt0QT8e0HKkp/SNdDx9K+bcHUFceBC+uRDuEnbAlpo3q3x5X2Gf3UFthf2Apad5aO6aHOZaeO+LxpJHxgtjFExYdaV3QtCZZX31EsQMa6aDH1GHtH9hXLBcD1cJlMObet1n3nszXtBBF5E51X8pUDZ2hPZEW83jKQuhAlNN56F8Lrc1O59vVdwkFOhJoaKUDYk9LyFFNEafj3WbNzRGvY0OuLWD1da0XgG2631kBoaBHPaffUwzgbRwaspNnRGGRx6IMF9PBsdt2fJ5or/bcXpje56+rBSzHV/eeI6GDB8175LlvOxW+jEpDRUg5u76aKwKGRY/+1n6N01hSAAcMQJeIUYRAm9ubQXNRO0t7m0eWYVLa2eAkWk/4mleQxpSM1wjIjtDFHtdB+0+2o7cBoA0pi1z7FW18IDK3L/aqYYcT4PxkMCrT9FcBdc1xHCHZvK3BiaQ7/szfuZ4lJViUZNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(396003)(366004)(39860400002)(451199021)(186006)(1800799003)(31696002)(41300700001)(478600001)(53546011)(6506007)(8936002)(8676002)(26005)(38100700002)(6486002)(2616005)(5660300002)(83380400001)(36756003)(2906002)(31686004)(316002)(66556008)(66476007)(66946007)(6916009)(4326008)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ull0R0RSVmpDenhDSGpiYWw2YTRpKyttaTJCdjl5MmU2SzdZeitxbUpCOHVQ?=
 =?utf-8?B?OVF3QUc1aWFoUk9kZWRlUlBJUjh5YkNZM2VMWTFjRHdkdmplYUl6Mko0cjY3?=
 =?utf-8?B?TkFyMHFndHV5cnE5VHZnRWtCSzF6VnJRN1BVakpKUk82dXYrOEcxRXZGd0l6?=
 =?utf-8?B?amZsVFJ3MGxtaVVGejJySFhqNFg1cTN3RnR0alNVWXBJVGdjeGtYWXpRRzFD?=
 =?utf-8?B?ektNaTNSOHdPNFFJVjVtdWZYR25pUER2N1R4Zy9pT2tEMGl2SWQ0Y3BMWFRU?=
 =?utf-8?B?OVlUbHFWMUorYjBzNkV5dzQvS3N5ZW5HQmd6b0FjNFY1MTFrUUZYbVpHZXd4?=
 =?utf-8?B?ODJUUGFsaXNCZTliYU1wS0J5d3lTdTE1ZWY1N0N4MXFUbnpRcGtoaTZGN3FJ?=
 =?utf-8?B?aHh2S2p2L3JYVWpLSnBtT3BEN01oRkJCYW0yOFpQMkJTcXVFWmxXeTVpdExL?=
 =?utf-8?B?a3VTL3BsdjlpWkpFUHRzRURUUEFSbjZzSmFSdE5lMWlvR0RRaDFMZit1anJG?=
 =?utf-8?B?VjJSTVRlWDJLWWc3SmU2ZzlMUjhUdGNNb2VibW1VTkdzYzhlNitlV3B5S0hw?=
 =?utf-8?B?Rlo4c1NlQjVLWGdnK0FZR3hlYUFBNHZXWS9NQ3Y5bEh3QW43TmVNNHRSLzBG?=
 =?utf-8?B?YWYvcGRPdy8rbm1mUDd3TjhFbDNGVDBEL2UzRjNiV2Z6akhIdjFwUkthaVRq?=
 =?utf-8?B?UWg0UFpIaCtxRFc0RDZlY0VCamdLWDJTd1VCQlpId3pNV0J2UFc3Rk0zdENh?=
 =?utf-8?B?dEUrQlBOWVB0M2R2SGhzWndoYnF3aHNIb05pbFdsbzdoMGVQT3RkNHBGODN6?=
 =?utf-8?B?c3VLRTRRbzlNNkFNM1JZcmhRMEZybnUySy85d09waFR2eGN5RGN6UzV3U2I2?=
 =?utf-8?B?SU5JMXdxU1pOdWd2eFAxekFZVlNrbk5GeEs5S3l3NjI4ZGVnc0ljd0RkZ0li?=
 =?utf-8?B?VUNKVHZWVEpPVnpsOEFkUG1tNy8vM3lqMUVPaXZuQTJMYjdsZU03bXZ0RGpZ?=
 =?utf-8?B?THowUzA1WHNiLzhmMTNVdzJwZ2xwWm5sYXMzM3FYcTZzQ2tKNEVrKy9ReGlR?=
 =?utf-8?B?T3htTW94SUJWdmJzdEsrRzRNRlhFRFhjVnUvWkEvMm5tZTNtbmJCeGlTb1hX?=
 =?utf-8?B?Y09Senp6QUQ3NGJ4NmxFNGdsNHV3VEZOR1JYbEEyVnAzZkcvN1NleUVDRFVs?=
 =?utf-8?B?VWZ1SERpTC93UjdYNDNTbFVSTEF0V2xyZ2RwL2Y5aThtZDNSUUJpYmVLRTZ0?=
 =?utf-8?B?RGsxYjQvRzJwTENsY0drbFJEa0xtYW9nbTJCMUJMMmpucDVGZVBnYlVodWNR?=
 =?utf-8?B?anlEK3JqbVJ5QS9jcmRsM2ZMSGtXQlVqMGtpZW43eHdHZjFYVHJlOHBydGNx?=
 =?utf-8?B?R3dyV0hHbitPT1gvaXVaY2NtQmJlUnlhdkJYdHQvTnE5emc2a0Q4SWhnL0xW?=
 =?utf-8?B?V25VQ0FJd3E0Ym1WTDRrUUpCc0V2V2xPQ2l0eXJ5NHZ6azFuZDNwQTVJdXdj?=
 =?utf-8?B?QmtiUHlob3JYcHAwampBcGlaWmxHUnoxNzIwUE5Wb0QzZFNtcHRidWtpSjBq?=
 =?utf-8?B?NjdRY3pHYUhTRDNjV3l0NmtIV0RLY0pvM2EzZVV0U3dwejJrU2U5UVBaNXhp?=
 =?utf-8?B?ZW5VMEJBbGhoS1hCQTVDSHFjREwrVy9qS0x5TGhTcFZvRjNKRWl6QUFRNCty?=
 =?utf-8?B?NVhYVi9OMStGODlMd0E0M0lZZWxMZXVFVEpmQkUrRWxpdXpYNzZzSm5jRkRk?=
 =?utf-8?B?TE5VOUFMdkhINjhBREtkR0NKWGhzYkJSWG0rRUwxOTNDOHphZmwrNDY2ejNF?=
 =?utf-8?B?UUtVKzUvWFJYUG9ES25xeGFMR0JQTCsvbHRURDlCSVRvWDJLdG5abG1iWHVO?=
 =?utf-8?B?VGJia1ZJRVR6TnBSZHR0cXAra0kvbjlSWXNhTWtybTc2MDArbHJ3RDZuTEVI?=
 =?utf-8?B?TUZHSVc3Q0lpdlRkSm9iZy94SmNaaDZ5K29ZU2tNNWJMSVBBYXdyV21tWXEx?=
 =?utf-8?B?eHJWVEpyeWNFOXVWRWIxem9LWm5Pb3lWVVdlOU5mYmhTZ2tzQmpibGNhWWhj?=
 =?utf-8?B?NVo1YTA2RHZEa1ZRRngvMkw1bGpGR0x6aWdybnZVZ3UxMnhOVnNheGFmTnFP?=
 =?utf-8?Q?p6z3ktl3YuzqEbL9fP7qKXj8g?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b24ca7ab-ebc8-41bb-a6bd-08db976bc770
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2023 17:28:56.8318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e1BjA5EeSKVVL5/PbF7oXcqUNXa4YsiHFgDBAc1tralO0cPQ1x8jqZrwOu6mOmV7QhueDo5bi0rzXYVn5CksPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7871
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/4/2023 3:42 PM, Jason Gunthorpe wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Fri, Aug 04, 2023 at 12:21:21PM -0700, Brett Creeley wrote:
>>>>> +int pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio)
>>>>> +{
>>>>> +     struct pci_dev *pdev = pds_vfio_to_pci_dev(pds_vfio);
>>>>> +     char devname[PDS_DEVNAME_LEN];
>>>>> +     int ci;
>>>>> +
>>>>> +     snprintf(devname, sizeof(devname), "%s.%d-%u",
>>>>> PDS_VFIO_LM_DEV_NAME,
>>>>> +              pci_domain_nr(pdev->bus),
>>>>> +              PCI_DEVID(pdev->bus->number, pdev->devfn));
>>>>> +
>>>>> +     ci = pds_client_register(pci_physfn(pdev), devname);
>>>>> +     if (ci < 0)
>>>>> +             return ci;
>>>>
>>>> This is not the right way to get the drvdata of a PCI PF from a VF,
>>>> you must call pci_iov_get_pf_drvdata().
>>>>
>>>> Jason
>>>
>>> Okay, I will look at this and fix it up on the next version.
>>
>> After taking another look this was intentional. I'm getting the PF pci_dev,
>> not the PF's drvdata.
> 
> pds_client_register() gets the drvdata from the passed PCI function,
> you have to use pci_iov_get_pf_drvdata() to do this. You can't
> shortcut it like this.
> 
> This is all nonsensical, the existing callers start with aa pdsc:
> 
> int pdsc_auxbus_dev_add(struct pdsc *cf, struct pdsc *pf)
> 
> Then they call
> 
>          client_id = pds_client_register(pf->pdev, devname);
> 
> Which then does
> 
>          struct pdsc *pf;
>          pf = pci_get_drvdata(pf_pdev);
> 
> Just pass in the pdsc you already had
> 
> Add another wrapper to get the pdsc from a VF using
> pci_iov_get_pf_drvdata() like you are supposed to.
> 
> Jason

Yeah this makes sense. Thanks for pointing this out. We will rework this 
in pds_core and I will add another small patch to the series that 
handles this. Then I can rework this patch to align. Good catch. I 
should have a v14 out later today with this update and other pending 
review comments.

Thanks for the review,

Brett
