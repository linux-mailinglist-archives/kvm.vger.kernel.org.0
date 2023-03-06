Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E91B6AB821
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 09:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjCFIWP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 03:22:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjCFIWN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 03:22:13 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2057.outbound.protection.outlook.com [40.107.244.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C971B300
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 00:22:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QFDTzDeeOXsbYw/7PQGHm4biEMJtu5TF/oiRY8n+BXKz5g9RdeX3LaNb+wv7Lwehy2gyyBJL+7i0UIBagKlE/3aj3ZAuiNUqCAJGJZ2yrfIj7nBdjd+JCRFehDkvV3CfbES2WXJscoR1xxXHMO38EoXJPTVVi0jRLFOSDJfxvHLVPueUM1D15Qwjua/q0ov8pNv24xJNRDF2IUHIfIcl8//bh0AK6SohGCwtA2SrbtMWURAi8C24bNCzLM+Hz/4jdudLrxkP623ilMtN/HodY5AvnzXo/Cc4oYDya6Fwc/9mYELhwZKoeNqOEzp4LCLJqE3AAWUGP4VlKT1fpga2YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cHrhkkz2ZiTiWJUrSYVG64Fzfn47wxyZrRSDEvaA6UY=;
 b=jZyxNFLXJhhsW4bSHSogz6wOW/bJ5WwFAeseKhuFrfsjLUB38GD0NHNq0Qkr7rZAVAmfoJLAEmCxeNjd0FUFsvwKTe1dMfndYhKx59yxeYfKv3CUmx9rsA0Uq+5Bt2UHTu62TtvBwWQJwIsySpRstlc6BxfWg4dSx8kMJzIUkyG+kKGNIoFQgMeajLFCCWEl2I9SNkqaq/UKt3VigzGLwjX/D/hNBKc48QBpcAw2CrOT47dZ6C76HvD0E1n8Krej6+29o34MvmPuREaHOzOjGv5yd+MTkes+KeCZxfE+4EfgUtt3NdcTd6DexzdasFJvhFZ4cNOMmHLxwxqOM0BZHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cHrhkkz2ZiTiWJUrSYVG64Fzfn47wxyZrRSDEvaA6UY=;
 b=adBNhMdCj/x03ARbLYS+kJ2Yjez7UTm+/S27HTnTt5e1Rq/5V0U4tMQWkEBFJDba5bVF2MtsN8kesaEwW6YF7UKuvuwg/YfPc+/5ZoMywt66XYEmAST+SCgL4b1BptxhIOh1TDqkO9XXC6QVeEoyEphP08yt9JQwB8rC9jgx6RpJpE8BnshmAdRjVEEVafPO4eAznPknyHUyBuaB+MNHxDKNC7OXxolGKqQoR0gnUStB23AMD9u3GK+oTa3qT35ULvpwnhr90MyjHXZv8gAvpc8vjzt6i0ccldX86+8S4STOdS48AP2GQlB23Hoz65BLJhgRyKRGbU9n3TDWY6nssg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by BL1PR12MB5047.namprd12.prod.outlook.com (2603:10b6:208:31a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 08:22:09 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::aca1:caca:b2d7:35f]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::aca1:caca:b2d7:35f%9]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 08:22:08 +0000
Message-ID: <7375d19f-210f-c5e1-3b06-deca110dd87c@nvidia.com>
Date:   Mon, 6 Mar 2023 13:51:59 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: Bug: Completion-Wait loop timed out with vfio
To:     Alex Williamson <alex.williamson@redhat.com>,
        Tasos Sahanidis <tasos@tasossah.com>
Cc:     kvm@vger.kernel.org
References: <a01fa87d-bd42-e108-606b-78759edcecf8@tasossah.com>
 <bcc9d355-b464-7eaf-238c-e95d2f65c93d@nvidia.com>
 <31c2caf4-57b2-be1a-cf15-146903f7b2a1@tasossah.com>
 <20230228114606.446e8db2.alex.williamson@redhat.com>
 <7c1980ec-d032-11c1-b09d-4db40611f268@tasossah.com>
 <20230301071049.0f8f88ae.alex.williamson@redhat.com>
 <4c079c5a-f8e2-ce4d-a811-dc574f135cff@tasossah.com>
 <20230302133655.2966f2e3.alex.williamson@redhat.com>
Content-Language: en-US
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20230302133655.2966f2e3.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0077.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ad::18) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5304:EE_|BL1PR12MB5047:EE_
X-MS-Office365-Filtering-Correlation-Id: 65d850c3-893b-4847-26ef-08db1e1be094
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SaHuuujT0NTp9VkUL5qVZ5zgcMmlHewi8xU+9FfAociBTnG0r/Il9CrquBAb0MGQBDk4H0NFuJXOOpKX9i9RcxFXANv1HpufXlH6L/JoFa4xPdxcqWPQ73sgIllw4pJseHmOU5CJi78MtKSQSkRTMb2yI/IBBCDewbAIOhwMZg/jYzKuK5rsD3qq44QuSujIqStOqIh5czu1Zzy853u9w1x75HqdS9huNUbFmxNhp3cLINqR5Nkv6qy+S53np4xWITXiIA93mrKyWUzdbGh1zcqnzVDd413NM+E/5MjnY0Az2M4exxsyYSDNoAiwPrAfQyGEHSe2aLWo3/OpoJSY1V5/e3AdaUmSru4wEz7zeRyv2sVabj36idGs7Tq+y0eFfNmRFEYt2WP21FuMOwwRKIC/jSN1PZ6fIT5+OOl1p921KyCHy0BXNVRfC0JLOwDuPcRoa0RYUK83D4BCdkpOkA+wdGtpjJPOa5BINFU7mUUEOEApL/cg7uiyDfBqUTn3qoTNCq6HR52pk0KXUlQ1q73o47+4RsssUFOb04YydwJ86s3d+IPft9L4+uAjhlRqk/85qg6QdWmrVR7ooNzrQNs3LAkCINxJAM35r0snpO1jr2HW42xILf91XCpL9hubsKTxn//vJeuMTgWQX1csjBauwrENjM0EBfQswuPVE0S741c1j05ZmXbekM7ONA+lqWkzN8Ts92v7KDHFCmz4HEsS2N9CEq6jGTwc18gl5NE+rtp0jLy3RPJqkqUFJJC+qNPLQOpavMTcbCsdVm08FJJrtxgJFYPFVd74LrJGSGRKcIJOXtJw4apn2KliDIBi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(376002)(396003)(366004)(346002)(451199018)(31686004)(83380400001)(36756003)(478600001)(110136005)(316002)(38100700002)(966005)(6486002)(6506007)(6512007)(6666004)(26005)(186003)(53546011)(2616005)(41300700001)(5660300002)(66476007)(66556008)(66946007)(8936002)(2906002)(8676002)(86362001)(4326008)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TWFQbHZxNGRPSld5ZU04S2hmUHVmTFR1NnB2NStDajhLWWZQWUFYOG04M204?=
 =?utf-8?B?aTJYSFJiWGVvNkxlUUVEVCtSNWxxYkprUkxQRFZ5NlJXTXFlaXdkM290Qk1W?=
 =?utf-8?B?SzhwYzRrU0tPc2kxTHlZVzBkZnJiR0lkdndZWFZlSm15MUZCSGZYdlloeUFt?=
 =?utf-8?B?QU1leUFUNHVqZDg2MUtFMTdVODVKSFZiNFlVajhWTysxRzNVTkVwNERlMDVS?=
 =?utf-8?B?VjRBVDlLMk92azlGZTBCdVducjA3VmtUYVlDYjFFZVpQZ21PbGpsTHV3NHVE?=
 =?utf-8?B?eDU0MjJkaWR2ZUo2YlBtRm9SZGdWL3BkazZTUXJzdVBBOWZsL1dLczdrVWZG?=
 =?utf-8?B?WXliRjlpVndTUTZIa3dNTkhUVzRQbklNTTl3ZGY4NGpUS0FTZkxBMXVqcnlT?=
 =?utf-8?B?MThGNDFTZjJ5bmZyZTMrRUNtYzJGVVdvcEY1QjJ5Q1ByUDhXKzg1WlhBT1Vv?=
 =?utf-8?B?VnBjcHdPTncwY2VDL0diTWZTdjgxdVJCZlNodmEwSzBjQ0d4VDBqQnRvUEZF?=
 =?utf-8?B?SUFyY2F5UVVXUHB2RjBhczk0UVFQU1RTQmFsYXlhdnZYenRkcEJBSGhEQmNx?=
 =?utf-8?B?RndOZVJhZVZkekc2dFZRcjNEem9QQlNuTzlFVS9lU3VZYmVUNXFBNlRxTGZK?=
 =?utf-8?B?Mm9YR0laVnRtUFNJNUNaQ3ZSZ0Nsbm9oQjF2akNCMGhHV1dqT0tSc3lXY0hn?=
 =?utf-8?B?TXZTQk03ZlVteExBMzYxU1JNZmpWR0dDZzBkaVdJRHlYbHdselBTU3pKQVRk?=
 =?utf-8?B?T0N6NGIzaDFYOFVGVjR5eEEzWWlhTzRLWXB0ZEo1ZWp0T3dKYVFJUlowWmtu?=
 =?utf-8?B?Z1hxSlhwOFh5em1sc3dQU3hmdFBLbXNuR1oyZm5rbGNVSFVGdkRHQjdVK25k?=
 =?utf-8?B?c2x6a3FuR2N2MmFMWFVESTdZQUh4bGdTS0o2Ylg5MDRNOTFQUyt4WDJPbE5G?=
 =?utf-8?B?YzJVcitjZkRQakxtK1pVSW02VmY4NzZLZWpwOVlCTTBjRDBaSDV4ZjRweDNC?=
 =?utf-8?B?N0tGQzhPNHExUU5ZQ2hRNllzOGpNMmhIQmZVUFRiRVJVaFdyUnl0SjdIMXRK?=
 =?utf-8?B?aVRBTzRkeFdhWTdnQUxNQTdDUmpNczc4Q1cxRDVlWDIxamRJR0pIay8vaXNm?=
 =?utf-8?B?VG5OUUhPaEo1c3l3cEhxYk5YQ2syck1OR2lqbUswRWxBWnBsWHVuTFI1Nngy?=
 =?utf-8?B?SmQ5YVpHWHN1bTNxS21NVndpb1dWY3dENkREa08wbUQ3SFd2VlFjdXg4cXJx?=
 =?utf-8?B?bnByYmlYME16dTA1bmEyVnQzN3VleXoremFmdzBjWFJ0VGI0M04xZnF3ZEVN?=
 =?utf-8?B?Wjg2MUhVUUdqQThvd3FRQW96L1FReVJaVlBkWnBRdnlsZWVKR0gxelBlOG9P?=
 =?utf-8?B?dlJmZkRVWmlqYy9teUlHbVlhc3JTM0wyR2dxaFlWcnpMdjhFbGs4WCsyVkNG?=
 =?utf-8?B?RElNNExaTFh6cGtLYUs0SkJ0Vlo0emt0M2dKc3Y5dFc1UEo2Qkhzb2xJYkRG?=
 =?utf-8?B?TDY0akV0YnNHTVhpYkRQSXVQNENkcXhaWEVhUXpqb0h3cUUzNFQxY2Z1YUZW?=
 =?utf-8?B?UU5MNzNMbndyUGVzMWpOWHI3ZHFHSVBFTU9sWENUVTF6M0RFWEhrV0xhM1cz?=
 =?utf-8?B?Rkp6SnV5aW1vUnJNS29uWkVOM2hXVGtJSFVtenRnakxVOUNRWG5QeU4yc3hJ?=
 =?utf-8?B?VFpMWm1wdUVEdU11aXZzY0Jqc3A3dzJvZTZXVmlQSlZENlNBUFVWK1lEV3JT?=
 =?utf-8?B?dE1zb2QzeGFDQTBKelhzak9sK1QrVDFVY2ViWFFBT3lwa2FSNGdsTXBFSzlv?=
 =?utf-8?B?ZFQrcHBoY0cxR3IvenlTZmg5SmF0WTJON1B6U1Vrbmt5UTFJSWhwNDEreTNX?=
 =?utf-8?B?Uk8vMEk2YW1RRkRsdXZYLzIwZCtvczZYL2JUTStvYUJacU9sS0tUdHN2dzJM?=
 =?utf-8?B?WnAxTVl4YzF1c2pYM0hXNVdDMTdhU0RFMWlIbmJ4b2wzS21aMGNsWHhmSFNk?=
 =?utf-8?B?VnpqZlFXSEwvalBpK1lraDNIY0MvTzR4UTBRQU4zZzBUbGgxZzlpWEVzZmhB?=
 =?utf-8?B?cGVwY3hTcjdYU1lHRUFFZ0k1Zk8rcUtrbElFak1qek5Qa2xDaCsrMENNWHZk?=
 =?utf-8?Q?liuB3GhJQwuX9rdgwYgfJ5SBO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65d850c3-893b-4847-26ef-08db1e1be094
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 08:22:08.7717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9zx3Skj1rVtYfuPIU6Iif2sPdHDmDCQMrNuSFt0wj+C+CfEdQPeDtbAzJQMJP16PK71kE0BdysXN8GMyecoJlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5047
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/3/2023 2:06 AM, Alex Williamson wrote:
> On Thu, 2 Mar 2023 09:40:35 +0200
> Tasos Sahanidis <tasos@tasossah.com> wrote:
> 
>> On 2023-03-01 16:10, Alex Williamson wrote:
>>> 0000:02:00.0 is the upstream port of that switch and 0000:03:02.0 is
>>> the downstream port for the 7790.  0000:03:02.0 is the port that should
>>> also now enter D3hot.
>>>   
>>>> If so, I tested in 5.18, both before and while running the VM, with 6.2
>>>> both with and without disable_idle_d3, and in all cases they stayed at D0.  
>>>
>>> It's possible the switch has a problem with D3hot support and it may
>>> need to be disabled or augmented with a PCI quirk.  In addition to
>>> investigating what power state the downstream port is achieving and
>>> reporting lspci -vvv with and without disable_idle_d3, would you mind
>>> reporting "lspci -nns 2:00.0" and "lspci -nns 3:" to report all the
>>> vendor and device IDs of the switch.  Thanks,
>>>   
>>
>> It seems that way, especially after manually preventing the root port
>> for the graphics card from entering D3hot, however the one for the NIC
>> seems to be doing that just fine, which makes things more confusing.
> 
> Yes, the fact that the NIC works suggests there's not simply a blatant
> chip defect where we should blindly disable D3 power state support for
> this downstream port.  I'm also not seeing any difference in the
> downstream port configuration between the VM running after the port has
> resumed from D3hot and the case where the port never entered D3hot.
> 
> But it suddenly dawns on me that you're assigning a Radeon HD 7790,
> which is one of the many AMD GPUs which is plagued by reset problems.
> I wonder if that's a factor there.  This particular GPU even has
> special handling in QEMU to try to manually reset the device, and which
> likely has never been tested since adding runtime power management
> support.  In fact, I'm surprised anyone is doing regular device
> assignment with an HD 7790 and considers it a normal, acceptable
> experience even with the QEMU workarounds.
> 
> I certainly wouldn't feel comfortable proposing a quirk for the
> downstream port to disable D3hot for an issue only seen when assigning
> a device with such a nefarious background relative to device
> assignment.  It does however seem like there are sufficient options in
> place to work around the issue, either disabling power management at
> the vfio-pci driver, or specifically for the downstream port via sysfs.

  Thanks Tasos and Alex. 

  We can use the udev rules to toggle the sysfs entries automatically.
  The information regarding udev parameters for the downstream or upstream bridge
  can be fetched through 

  # udevadm info <device_path>

  And then create a rules file.
  For nvidia GPU runtime PM, the udev rules are documented in 

  https://download.nvidia.com/XFree86/Linux-x86_64/525.89.02/README/dynamicpowermanagement.html#AutomatedSetup803b0

  We can create similar kind of udev rules, if we want to disable runtime PM only
  for specific device automatically.
 
> I don't really have any better suggestions given our limited ability to
> test and highly suspect target device.  Any other ideas, Abhishek?

 Given that we already tried all the possible isolation steps from the
 user-space side, so nothing new from my side which can be tried easily.
 I checked the lspci dumps and no issues observed with that.
 
 I have written standalone programs by using the example mentioned in
 https://www.kernel.org/doc/html/next/driver-api/vfio.html when I did
 testing for my runtime PM patches to get more coverage. For this issue
 also, if we can try to repro the issue through standalone programs first, then
 the debugging may be easier. But it requires effort and access to register
 manual, so it won't be worth to try at Tasos's end.

 We can go with delay option as you suggested in the latest thread and see if
 that helps.

 Thanks,
 Abhishek
