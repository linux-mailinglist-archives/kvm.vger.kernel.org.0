Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D692D649415
	for <lists+kvm@lfdr.de>; Sun, 11 Dec 2022 13:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiLKMFU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Dec 2022 07:05:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiLKMFS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Dec 2022 07:05:18 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2071.outbound.protection.outlook.com [40.107.101.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5048CC47;
        Sun, 11 Dec 2022 04:05:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lQNVBuH086EX96WXWRd1jBtfVXHN9Dxt8pwOfOeB++j3dY/tkBIJYorPYxZRhtAhMi89OjoFaZtPE1QRvPrtcLgNG01zt5Le8eZ43eupsV53ddyeNIvAGabLuDZ3IdO2nTx/3HoxdTi0r7eeeym3sCemGIpgQfIRdc2N/EpgBI0Qp1WhcXoaMdwYmZr88MtX6uicm6OeLOSVycrIPtPOBXtStZKVGijFKwXtmjjVUMW64d2A8IsyFgN2dV6w6ZPWwuX+k1KGrSs8gCFf+hFV7zyKENgZ7zrpt5ekVJUaW5NWPaklGZVYDgZ1bpFt2nAYxY5NxnJAY8yy2V8u8QWJVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kv7g7sf9afLZlqc+/la3k4fLfmuOGUWpKkUl+1WJECU=;
 b=PuaiO8NNU0HlptHGIQpxzQa1s37WOaprehmmDOg3JovLsWk9Eb5LKir2OZ5ihTdpZpSblJaIRm/ShQtam6JZY3aSERaSChpOkHcU/GXuRophSFt+QTBPeF6X+id4XJ31m1Fw5AZ4alyoIo0MDu+Y7/fcaPX407XfNlFTeWklBQGm2sbRezzwZrWoS7cgp1wfI1pF44k6vUshfidxLVnHHoEndvZ7lB0R28YJjDAmipv+rmCMdFLm9++9XMmzyj9tNLObkRYI9J8jBLrqA1LsptnPsS1LNL+zhRYu4baIpJbJImf+sBRooMRQOgc9V37JAK02z6KVNYWbt/TS7Zpggg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kv7g7sf9afLZlqc+/la3k4fLfmuOGUWpKkUl+1WJECU=;
 b=i/AZbFzL2c8DQLuW6S5Yc5MzvPe8yNvOeq3xjA4yb0VA94tAqDMt4LpIDoABkEhyJkonnEFySq/MmD0rp16U8N4Rlg2TPdDOuocV+PCaGolq+A2HwFwW+fMM3ZK7z/9eopqBj/spy2W7cuMyE4HlZKf+MRd+PcaVgYBnv+BQKByMDWg9+MlywZw5GJTmCFhLzQsSdxyUSUUZRjTS0Ki9HBKXPcaN8nH12Ap0+vetr3PPQ+QX/oTEP1vp2A8pvjG+fJx1YeGsWK8Ut2eADIsMti/WbDg3DnFVoodQN8Jc6M0MivgsK4GrgQOxgsBtDvBA8khOEqGTlDqOTSvuQNC0sA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5040.namprd12.prod.outlook.com (2603:10b6:5:38b::19)
 by CH2PR12MB4102.namprd12.prod.outlook.com (2603:10b6:610:a9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sun, 11 Dec
 2022 12:05:15 +0000
Received: from DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::3fb9:3266:7937:44fc]) by DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::3fb9:3266:7937:44fc%8]) with mapi id 15.20.5880.019; Sun, 11 Dec 2022
 12:05:15 +0000
Message-ID: <9bc8e614-a687-e419-f9fd-e3177cfb41dd@nvidia.com>
Date:   Sun, 11 Dec 2022 14:05:04 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC PATCH 5/5] nvme-vfio: Add a document for the NVMe device
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Lei Rao <lei.rao@intel.com>, kbusch@kernel.org, axboe@fb.com,
        kch@nvidia.com, sagi@grimberg.me, alex.williamson@redhat.com,
        cohuck@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        mjrosato@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, kvm@vger.kernel.org,
        eddie.dong@intel.com, yadong.li@intel.com, yi.l.liu@intel.com,
        Konrad.wilk@oracle.com, stephen@eideticom.com, hang.yuan@intel.com,
        Oren Duer <oren@nvidia.com>
References: <20221206055816.292304-1-lei.rao@intel.com>
 <20221206055816.292304-6-lei.rao@intel.com> <20221206062604.GB6595@lst.de>
 <Y48+AaG5rSCviIhl@ziepe.ca> <20221206130901.GB24358@lst.de>
 <Y49JNvdmRPNWw26q@ziepe.ca> <20221206140002.GB27689@lst.de>
 <Y49PqoAhZOeraLVa@ziepe.ca> <20221206143126.GB30297@lst.de>
 <Y49WNo7XWZ2aFfds@ziepe.ca> <20221206150131.GA32365@lst.de>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <20221206150131.GA32365@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0214.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::9) To DM4PR12MB5040.namprd12.prod.outlook.com
 (2603:10b6:5:38b::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5040:EE_|CH2PR12MB4102:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c026b45-515e-4763-5689-08dadb6ff65c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kv1AYbNoKSIHbUT1IlUmfUGUzkLOvOX4k59y4Pg1x5T8THrKwzE8dUTPk4mtYff2WwhdiZXezK7Uxsdwl+2SNFYtXAoXS+KCe9JYP3PQgW9kRxx+SC6iqiUxDsi/iBS1OhZisNt2t3PWxuCnKqTiwd5/kw2AUhxcNYjnWrEWD505c+iwvOEYiWP1rLr79ubV0ILD4HycTmAT0S4Hhtic2Dwu3fnvrXruXAy58XBPlrHszKYwk8T/s4wcJ+l5j++cJBDfqW18i58jZ5p5EjAbxSJc0XG1V01KhNGmmc21VIcuglyOTJcGdm3MpYa9QY2Ja3fKIYp6SjSB+nV0WQ3i5ov6lPdLScsRVgAMsa4gW6GBgcB8I08kr0aYOMYthP1hiUfsKgOpiRXdW62a2VVlEb4lzK0LNpXgQ71hrQXVOpk9ARi81qgnZ6+KqZAPxOamAv4iGtf+HR16W4jVKlbMEG9bZuaeCSl0esaM1NaOlmuKZXVl8SRh22ouYd53Js7IhQjSTvCVlaGfG3zIqAmhnIUuxWPm3wSD31EqwXi7an4RjOOr4HoY8z+u2pLl1zn4A4sAtkR9MLKA/wN2aciWUv7mD+e/Ul5ivvSCUIFvPsTWX2UndCBV1RXrxtlIBs4/Jx8nYc5FU8EW5de35eagafKCDPUPza0MaSGvhVX/fCV32FK7wUT5mXUqkDJSYJibHTL3l2/xWuXRSHasL0yaD8cdlKLgSGGPuLuUhB34rTo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5040.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(366004)(376002)(396003)(39860400002)(451199015)(41300700001)(26005)(31696002)(86362001)(8936002)(36756003)(7416002)(5660300002)(6512007)(6486002)(478600001)(66946007)(6506007)(66556008)(8676002)(4326008)(53546011)(66476007)(6666004)(316002)(110136005)(54906003)(107886003)(31686004)(83380400001)(38100700002)(2616005)(186003)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YWFlMGR4dlNHbTdjYytQVEJob3ZQakFuREV0YUxieXI1dUt0MWowWHR1NEdJ?=
 =?utf-8?B?WnIyQ3JoZjNqK3laSDFWdjBPUW11K0d3UTd0RzMrTTJmZEduMjRqUzlNZFBU?=
 =?utf-8?B?clk5Y28xTFIyYmdhcjNoWnNSVlg0d3M0UFVNektnazJQcUU0RUkzUzdNVU42?=
 =?utf-8?B?OVdJQXpjbEIwSDFhMHBmMXBSTEVRak9zRGt4OW9Ka2s5Sld0eFZJd2s1MmJQ?=
 =?utf-8?B?Mi92V1IxTzBRSEovN2poOWxFdGNhVGJaRDBpREh0WGJzelVlTUJTdzVRWXNp?=
 =?utf-8?B?bUFyTE5EaGZaTFlIMVNJekJrT0JjdWR1WmhoZkxoZmxsSFJPajZmVS91TUpR?=
 =?utf-8?B?VHZzTk4xQ0pZMkhQLy9ma1dCU3dMcnNycnhMYjlpV0crS2ppNFFwRzdlaVZy?=
 =?utf-8?B?Zm5wT0Z3bThnc0pZT0ZMTEJiNVFHUUhoTS9hK1o0YzJIL3FIQWNTbHBSVXkw?=
 =?utf-8?B?S2xYT1FzN1YxMVRXaDc1bUY0UUNObmJKeGE5NmZ6b0x2MGIybmRYV3IxeUtp?=
 =?utf-8?B?QkJRUXNqOFI2SDdnUWFJaFg1OW5QQVhNUklCelIxK1dwZDV5OFB1SnhjVzNr?=
 =?utf-8?B?a2xucFUrYVRvRUNGV1ZNNiswZHZIdGpYRWFkc2plaHJiZkxaUEcrNCtGWXE0?=
 =?utf-8?B?UFpyWUVmRlZaMXN5S3dpVDlYNGg1Ni8yT1JpUHdRUmF2cU0xWnlsRWNDTnBs?=
 =?utf-8?B?c1hReE1LNTJVS1BhQXZTZ3JNZ0pmMkFGS2ltOG5lMjd6OUR3dWIrMWhhNktX?=
 =?utf-8?B?UThlVFJOR29YTnRLdDIxcUcydVNDZlRhb0hITVdkZ0tVSVFJTVlPV1gyUHRx?=
 =?utf-8?B?UVpzMW9uRnBkdXErWU4xNWh6UE5oVWtGQnZnVGJNb2NpcDU2TDRnbG5jdGxT?=
 =?utf-8?B?aUs5Yit2YkFvRDdvUWFJMnpsMVZ6ZDVmRTRmbm5yRGVTZk8yN3NCMC9KWUU2?=
 =?utf-8?B?c2lrUjI3WkFBSnJBQjJyenQyR0MyeUk1SFg1YmtUL1lMR1pYa2VzWHlwbWho?=
 =?utf-8?B?ZVJMaEV5RUo1eHNocXIzM3Z2a3kwRmpwZG5RT0RQeXZGV3gyMEZSejV4K3dZ?=
 =?utf-8?B?V1NkOXNtQWgxOURNU3p2TG9FdHhNWkFQdVNnVWpiczlxSVhGeDlKV2FZbGhX?=
 =?utf-8?B?LzhQZzIxaTBCTm5tN2lCam1yOGlTa2xSSHVZRDdhUXV4MnhmbFVWRnNvVUdw?=
 =?utf-8?B?MUQvSDJXbkFINWU0UUVUbmpuaWZ1RTBWNGVocENnUnprOGtEcGQ4bTA2UGY1?=
 =?utf-8?B?RjBMWTAzem9ya2dmYVI1UGxBbzRXYjgzN2Z3dlZBZWhrcHdZTllxRTg3SjVC?=
 =?utf-8?B?QXRocG5FbFFxTE9CMTB6NE9VZjM3SE9GUU5MWTRQMmhvQTRsSHNzSzEzMFpD?=
 =?utf-8?B?RDhhUVlYelVFV0UyYVIxbXhFbTN2NUxmTWs1TkpPbHJBZXhrcXQvaFZld2RY?=
 =?utf-8?B?alZVdnNPem91VHgyU3J2MC95Nk80OHB2azF5cnpxS3craHNHTDB5dTE0Q3VM?=
 =?utf-8?B?Q2RFTmZDblRQcnpqY0pWemYwRlhYM1JNZXFyL2cyWXcwcFU0WVFZOTlUbDl6?=
 =?utf-8?B?ODNSbjdqazZXbzdrVTFFNDEvT3JoSVlFaTZJNms3QjFnQTZkOEtIRXBvdlJy?=
 =?utf-8?B?ODBYM2RBMjdOT0lQVENEV0s5VFMwdVR5RUhyZUl2QklZNWpRQ2VZWFZacjBT?=
 =?utf-8?B?aFYxdDdjeitoZUlSQWxvbjQxZW8xalR4czVyTDMzYkNMeElldGxlbDlId2pC?=
 =?utf-8?B?dUQ4ZGQ1RkxRdDZTeDZnekVMREVER2FzOHdwbkVUaDJpQTkzYk54Q0xRRFNw?=
 =?utf-8?B?bFNxZFpuYXNPeC9aWmt0UEplSFhicGdzQUoxWkJYdzl1ZVdyalpHQWI3OEJZ?=
 =?utf-8?B?TmR0WEJRUnN6Mm0wYVBSYWx4bjN4OU5wUlBTZkp4eC9wWG50UDR5R0xxc2dp?=
 =?utf-8?B?S1lmTFV6T1hweUNYQUF6Ui9vQXZGVlgxcjFwVDB6N1RoOS9QUEZ2dGg3b1hu?=
 =?utf-8?B?R0VOc3cwcmh3K0ZwNFpOalozekpSUm1kMEo4VkEyTEg5MkN2NHFqcWJjMmhF?=
 =?utf-8?B?bmhRZGdZVWp0bHQ5NVRidG53QldIeHFwT1NYcGE5THhXaU1CY0dEdkI5QWNk?=
 =?utf-8?B?TWQyWkN5MVBNQmkxWVNjQU5SWnRsOUNWeXoxUWVrZUtINitMT2FZMFN4eTlu?=
 =?utf-8?B?N1E9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c026b45-515e-4763-5689-08dadb6ff65c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5040.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2022 12:05:15.0414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nyh3NmwxsaiMnEUKCyuve930lsT+m6LLaan1ylUupdQ9VRvR2qGzW6oME+qkstLHzmOUnehst9P6S1TEqUdsrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4102
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/6/2022 5:01 PM, Christoph Hellwig wrote:
> On Tue, Dec 06, 2022 at 10:48:22AM -0400, Jason Gunthorpe wrote:
>> Sadly in Linux we don't have a SRIOV VF lifecycle model that is any
>> use.
> Beward:  The secondary function might as well be a physical function
> as well.  In fact one of the major customers for "smart" multifunction
> nvme devices prefers multi-PF devices over SR-IOV VFs. (and all the
> symmetric dual ported devices are multi-PF as well).
>
> So this isn't really about a VF live cycle, but how to manage life
> migration, especially on the receive / restore side.  And restoring
> the entire controller state is extremely invasive and can't be done
> on a controller that is in any classic form live.  In fact a lot
> of the state is subsystem-wide, so without some kind of virtualization
> of the subsystem it is impossible to actually restore the state.

ohh, great !

I read this subsystem virtualization proposal of yours after I sent my 
proposal for subsystem virtualization in patch 1/5 thread.
I guess this means that this is the right way to go.
Lets continue brainstorming this idea. I think this can be the way to 
migrate NVMe controllers in a standard way.

>
> To cycle back to the hardware that is posted here, I'm really confused
> how it actually has any chance to work and no one has even tried
> to explain how it is supposed to work.

I guess in vendor specific implementation you can assume some things 
that we are discussing now for making it as a standard.


