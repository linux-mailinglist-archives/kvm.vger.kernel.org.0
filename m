Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6A0877BFE9
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 20:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbjHNSmS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 14:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbjHNSlp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 14:41:45 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B831E6E;
        Mon, 14 Aug 2023 11:41:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eHzNvWCMo9aOfmc+K7EbWl1NOa6Bu5wVfUK06Nl3stlTgqHe1zd2NQZdSSAKcvc7MWD98SxvNwFxrKqL9Bsy0jicl9YDOWMJuqclpjB7VkF+oDvlRON2P36ER0j29Y+ZZCIdAqeUniAdPbvPmH7+gX8O2QbNcus5ReAmpOZGzFYzf7svrVsi7/iy0cRGfzHObZOI0qt6kh+80MSmG3tn/APLcv0VbqxNmxeL3QIOWTDIa10oNVo0o2UngszNEerskJvv7uZQjsf4vUeAFF9X+3DM2RGCXnYujTm1i1+XGR32J8MbGDY70QyfAIMjDyS5NQccX+60E6AN5YBaMKD9xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sx8vgVQpTPAvwDCt7QmTSnBzFHjYsD4GFbJvA6HNPfg=;
 b=fXtzVud78irkKGvbbLeiZpeUNfzkeRoX2hgCBhFGnWch9cFrTJB6fR3ihZe90/gJkhwCXBQz3DE0uHZ11rapQ19OV9/Lfj+/QkFQ0ZVu8T/RaO7/DFedAHUeuqcPcwGMu0Xh5ECS7eCVdlKZ3IelfS2BSJzWDvFIyu7j6aXjlY5IcCJCZPfhDt025c8Mxlm+3ySAGbWR0w3/uiQQ9yTSyLE0IMK3+xoljv6wYi9yXhcULvQLTNJAhz5fh7Ym3fjQlKAO+EpwgLQSBAVw4sBVhwL6AXz1IzjZFkfS6tFdXP5L0iqmGHzERgC+Ih0g/2LEjRQTjOWIo1Q+OJliQ5qVXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sx8vgVQpTPAvwDCt7QmTSnBzFHjYsD4GFbJvA6HNPfg=;
 b=tX0ebfaRnzYwK5xcWRJH/pLiXt9V2T7F8068BPy2kFrOa9hwgmB+HZVeEQy7N1nMZN6mjGT/EjN9V/pabYIKxCaDpf6DY8ZcXjpXwhrmCVX7VaecbW7xUBr5NkwALNm8tyQ5jJ9HOi6t0USZCN1sJV3QqRU5HPSvsa+2Y5qxwwM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by IA1PR12MB6555.namprd12.prod.outlook.com (2603:10b6:208:3a1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.24; Mon, 14 Aug
 2023 18:41:39 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2%5]) with mapi id 15.20.6678.025; Mon, 14 Aug 2023
 18:41:38 +0000
Message-ID: <26f50be4-1195-ae7f-844f-5babff158bee@amd.com>
Date:   Mon, 14 Aug 2023 11:41:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v14 vfio 6/8] vfio/pds: Add support for dirty page
 tracking
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "horms@kernel.org" <horms@kernel.org>,
        "shannon.nelson@amd.com" <shannon.nelson@amd.com>
References: <20230808162718.2151e175.alex.williamson@redhat.com>
 <01a8ee12-7a95-7245-3a00-2745aa846fca@amd.com>
 <20230809113300.2c4b0888.alex.williamson@redhat.com>
 <ZNPVmaolrI0XJG7Q@nvidia.com>
 <BN9PR11MB5276F32CC5791B3D91C62A468C13A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230810104734.74fbe148.alex.williamson@redhat.com>
 <ZNUcLM/oRaCd7Ig2@nvidia.com>
 <20230810114008.6b038d2a.alex.williamson@redhat.com>
 <ZNUhqEYeT7us5SV/@nvidia.com>
 <20230810115444.21364456.alex.williamson@redhat.com>
 <ZNUoX77mXBTHJHVJ@nvidia.com>
 <BN9PR11MB5276884693015FE95A0939AF8C10A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <BN9PR11MB5276884693015FE95A0939AF8C10A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0142.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::27) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|IA1PR12MB6555:EE_
X-MS-Office365-Filtering-Correlation-Id: d21db151-f77d-41ed-7529-08db9cf61823
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DSRmN/u/30eKO5s9RjaM6jcxzHce9nMwC/hf/gXolupEtJE/dqlXMkAFW/FBiDkabh6s+KmCpWEPR6WvIjrvPKphD55bEpyNgbrxawlg90WYFkXiS5Muyx7RWyWaHBfpeox5ooo/OEK1KURXkeJ9rWsFKkdYIjBdYFKRWRbvIsc9+EMtaD7TmDaNCRnuPkOpO2lgSa2AngeXNSINz8gWMvs4vkUeckhPg7sDs7nJ9iYab9vB8DwrmbWQ84gyONRLUwMRkJT8eI49PovzCLnaspkGKOOnzaH7i0Ekz/kVXPxn3tXZK9Se5B8l6RUBJ1+Et2sntHI02zIxFrBjIej0spNbCS8B8BdWXVxPL+sHbshjFdWxSV3XFpU+5CJXe5mu5PLvBiXlhfDLicsFZ7+cDZk/I1jvI37IpGeUe1CclcQwUrNO0vYp9QPEt1kkhVEcuOWzn0/6B0zVrs+XvWibGMagPUeEuVFh0SPDiiiGCRRqt0cH8ZoKjjDu8zRN2MQdsTMncEZ2L2ysql3HHr9HxfIZRmHMFGlSwNKTFmfGUxBx/fI8QE1JNXKRstb/ZnagEN1bfZxJfnwko12GML3C1nOHRZjubvm2lxOR0r3kKySwK2PlUnBRWflzKHQEjkEMRk/7HKpP4X0trHOqteEhoJm4CQDDKzgh059NTqtuWbk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(346002)(396003)(136003)(39860400002)(451199021)(186006)(1800799006)(36756003)(5660300002)(31696002)(2906002)(31686004)(83380400001)(66946007)(66556008)(4326008)(66476007)(54906003)(38100700002)(110136005)(316002)(41300700001)(26005)(2616005)(6512007)(6486002)(53546011)(6506007)(8936002)(8676002)(478600001)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VkN2TzU4ZDIvL0xNb2JHbXpHanh3ZDVSYld6dDUyelJQcThpZ3RuSnRMcGk1?=
 =?utf-8?B?cmRwZlpZZ2VObHJEZngzbE81bFUwY1Q4Ly9jV3orT2NudG1RYmYwMnNQQ000?=
 =?utf-8?B?MjFrVmtZbzRqby9qemdSQUdodCszdUtITjJtZmsyMnhrNHZmd1ZpYVZhR0xD?=
 =?utf-8?B?K0t3cnoxTmRodnQyWmZmZXh6aHVodUJJeTk2Mk9UZWMrTmxjcnAvaUJJcXN5?=
 =?utf-8?B?UGFtYXZEQUNBcnNOa3NTMzlwbmRCWU5nRnRQZ1BWRjBGVGhwRkYvcGN4dmFL?=
 =?utf-8?B?UEt3dCtpM3BoQm1IWXRSVTBPdUhjNVYydGZSeVF6Z1JvSHhEbHFOUXprL3lo?=
 =?utf-8?B?Tk1kZmVaL2JvanJtT09hSkhPN0ovNTVHbC9NOFg1VUFaTE5RK2pHeTl1NnhL?=
 =?utf-8?B?UU9oUzhnQ091MjdLS0hLV1ZBY1V2WWVDRnVoMzVxaWhOWWZ4L1FSR05iUTJa?=
 =?utf-8?B?NkhBNEZxY2RWd25PUXZjN3J1dlJhSEE0OURHcFQvMWoyb1cwNkJMQUVTN28z?=
 =?utf-8?B?S2NaeU9rNi9VZkZlUWZDanNndjM1WUNldjJJRWxoZkYzbGNhQmovcC9WSm51?=
 =?utf-8?B?ZVFPd1A3cVhSeHpaNUJWQ1dsSXlPZDd5THFDcEw3WGxiV2dpdlFCOXZWUjhP?=
 =?utf-8?B?REZIeFh4amNCTGxpK0cwM3BLWVZXdHZNazh4SXRjQm14UVJjQnNyMEpjdzBE?=
 =?utf-8?B?dTdUUjVkb0p6dTZsYW53MWtlSFNQWjl6NDFFTHpYWWowU1dOYzQyT3RlYzFF?=
 =?utf-8?B?V3NJamJub2xKeitBeU0wZ3RmUGIwMklsMStsRkxLUUZnZStRaDdsNE9wWFpn?=
 =?utf-8?B?ZUtwR2xMTWNuQXVvM3MweVVwdXFCRHordEpKOFcybUdoNDBUVGZsTDFDa3oz?=
 =?utf-8?B?L1FTTGZVMmQvd0svcGNlanFodnBmMkg3SVllQTk5SmxZcFNGdFhva1l6ZHA3?=
 =?utf-8?B?NG5GMEI2YzVrdUZWNWdHV2dhVm5iTDJHUnhXWGZaSnorUDA3MFlxU1lOQWxX?=
 =?utf-8?B?ODhuT3k0eVNYT2xmRXRRaXhWSXlrbndndjlLUmkyVHZ6QjZnZExFMStWTFU5?=
 =?utf-8?B?OU9vcWw3ckFzaitNTnpUQ0tjTVZTUVE5VjA2K243OERnWWgxMWlsZWx4QXdt?=
 =?utf-8?B?a2VFWEI0eDNNQlZXTys5dVU2K2RkNmhRWlE1SGVtdHk5THJmNUEwZUE5VnhJ?=
 =?utf-8?B?SG9STkg1Vng0ZStnQnk3dmFzWTNxZHgwelYvbitPaDk4TlVONVI3NlgxbVdW?=
 =?utf-8?B?L2FVQndYeTRZS1ZhR0xpY3FqT3hCQUpJTGh6RUthYmpoNUZFSE5MZUl4aS8x?=
 =?utf-8?B?WXhpMVo1dlVrYWJMTnF2M3hkZVNpWHpTZlQwWlZNQWcxUlFUZ0NzM2FBbG4w?=
 =?utf-8?B?TFdPOFhsYjBzNzN2TVZhNitSdXVZdmdKSFY0a3Yzb1djZDBRNmpWMmIxK1hY?=
 =?utf-8?B?c2hITWtOZjJDU1c1QWNYZ2tsZU5PeEkvam5qQ0dOK2d3QU9NTmJNWVpIaW9T?=
 =?utf-8?B?Ty9yOUVLd1hUalYyemZxUG1hM3BSOUtqaXhYbUtGeEVPMmxIak5aQUJqNXdN?=
 =?utf-8?B?TDVYQ1I2UUJYNWRZdHNvbitwLzgrS3V5WGN1QzUrcGlxVE0vbWFyTTVnODZu?=
 =?utf-8?B?MXgzZVRNS08renhrSGZ4V1VtbHdGQnpaUjBRZEpLZzVTeHpLVUFTNWthaWpv?=
 =?utf-8?B?U05IWWtMTTRaeU1NUGFWK1E2M05BemRPdGZCMmJRTVdTOUFBSFFJL05JYXBT?=
 =?utf-8?B?ZEFRVHRIKzFjU0NFN1VKQ3NlOVI2RklTcnB6dDU0bVdGUTNrb3ZxZ1haeVZm?=
 =?utf-8?B?aE5TM2k2YnVSbGlwQkkvY25waFdMZXZ2WjZkS2ltcnpLeXNydXVLMVVwaVc4?=
 =?utf-8?B?dmZFTTJKYUZoZkw4SytuSkJjZjA4YzVPcjFHbS9YY295SDd6WVB4RVhHRWhE?=
 =?utf-8?B?dWhLM096aW02U1RWSjh0aUFkcW8vUDhiSEh2dDlQWks0S0FSbCtycHpNZThi?=
 =?utf-8?B?STh6UUpiRUdDbzRQMjFBMW12MTViYzgwaGZWYm5qMFQ5YUJidlZXTzlEVUdi?=
 =?utf-8?B?T3Fobjl1cWlTVEhEZzVWTGF0ZFBHQTF3QlRYTlRnZmNxOGNiNlJtUHAxY2JT?=
 =?utf-8?Q?e+nNvQe0ErDiGe/RVqxJynnES?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d21db151-f77d-41ed-7529-08db9cf61823
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2023 18:41:38.5786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vbl/Tx0oxI8+w2l5Nf3tmuAFNeL8wCgXOzmMgxEVuGJ0dobXUy3FZx4Pc3+UMWSBNlFFSOrJj5lJQ7Y6061aVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6555
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/10/2023 8:25 PM, Tian, Kevin wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
>> From: Jason Gunthorpe <jgg@nvidia.com>
>> Sent: Friday, August 11, 2023 2:12 AM
>>
>> On Thu, Aug 10, 2023 at 11:54:44AM -0600, Alex Williamson wrote:
>>> On Thu, 10 Aug 2023 14:43:04 -0300
>>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>>
>>>> On Thu, Aug 10, 2023 at 11:40:08AM -0600, Alex Williamson wrote:
>>>>
>>>>> PCI Express® Base Specification Revision 6.0.1, pg 1461:
>>>>>
>>>>>    9.3.3.11 VF Device ID (Offset 1Ah)
>>>>>
>>>>>    This field contains the Device ID that should be presented for every VF
>> to the SI.
>>>>>
>>>>>    VF Device ID may be different from the PF Device ID...
>>>>>
>>>>> That?  Thanks,
>>>>
>>>> NVMe matches using the class code, IIRC there is language requiring
>>>> the class code to be the same.
>>>
>>> Ok, yes:
>>>
>>>    7.5.1.1.6 Class Code Register (Offset 09h)
>>>    ...
>>>    The field in a PF and its associated VFs must return the same value
>>>    when read.
>>>
>>> Seems limiting, but it's indeed there.  We've got a lot of cleanup to
>>> do if we're going to start rejecting drivers for devices with PCI
>>> spec violations though ;)  Thanks,
>>
>> Well.. If we defacto say that Linux is endorsing ignoring this part of
>> the spec then I predict we will see more vendors follow this approach.
>>
> 
> Looks PCI core assumes the class code must be same across VFs (though
> not cross PF/VF). And it even violates the spec to require Revision ID
> and Subsystem ID must be same too:
> 
> static void pci_read_vf_config_common(struct pci_dev *virtfn)
> {
>          struct pci_dev *physfn = virtfn->physfn;
> 
>          /*
>           * Some config registers are the same across all associated VFs.
>           * Read them once from VF0 so we can skip reading them from the
>           * other VFs.
>           *
>           * PCIe r4.0, sec 9.3.4.1, technically doesn't require all VFs to
>           * have the same Revision ID and Subsystem ID, but we assume they
>           * do.
>           */
>          pci_read_config_dword(virtfn, PCI_CLASS_REVISION,
>                                &physfn->sriov->class);
>          pci_read_config_byte(virtfn, PCI_HEADER_TYPE,
>                               &physfn->sriov->hdr_type);
>          pci_read_config_word(virtfn, PCI_SUBSYSTEM_VENDOR_ID,
>                               &physfn->sriov->subsystem_vendor);
>          pci_read_config_word(virtfn, PCI_SUBSYSTEM_ID,
>                               &physfn->sriov->subsystem_device);
> }
> 
> Does AMD distributed card provide multiple PF's each for a class of
> VF's or a single PF for all VF's?

Hey Kevin,

The AMD Pensando DSC provides multiple PFs for each class of VFs.
All of our production devices will meet the assumptions of the pci core 
function above that all VFs match VF0 for those common fields.

I've been out for a few days so apologies for the delayed response.

Thanks,

Brett
