Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC1465E64B4
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 16:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbiIVOIs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 10:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbiIVOIe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 10:08:34 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2075.outbound.protection.outlook.com [40.107.92.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB121F3F86
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 07:08:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bmo1oyUaxSiBFg5AvdYW3jaqZR4LfmsGk7S5yP3BkXwIyh3PFaToY6zswzmrLwg5aPJWUpD5HAwAdC34Bzzpwv0K9JJTeEslQvRZ4YjslWp4WOtYoOugrb/PhdsWcbexNC1R6Y2hUx1JVO1rhVwmx0f/9uloFO/T+oLGZhXIWFRP4eEJZdUMnvYcTH5y+R7tIiaiDoAmnTY3LfEthVE7EP97royRnCbTW7CSpXOBOp8rwFAShP7CUm1NmqofuxgJhTi8KAFYcmRy1XuUs+ARQvqx0l6IOqxQs04b13ejc3KWPEqW98mwW5S2F4/a6KWfcmBK5y7OBwcBj12xXOndsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2A5VpHIHYfAWeTXGzGQZw1YMLYDO4ufc6PyTNT6TVi0=;
 b=HRFn9vnQjcl0nI5CmNB8XL9O95itIeMbo2nM5L0kGbQXgFkZqjMXz/TIybYnAHp+kVd5bmp2mqB9WAYS0OGVh6e9fWR56QaYn9ffublODfY3qX7f/5HfbINTW+mZ8rBXtYWOY2UfsMEBJiPrR2IPmeJb8dF5cL/qlAfA8WInx7lPd2ZlOASZ48R9OLf84gFSQv92VPNGo2p7+mNm5q33yfoOYG8MRQ573VlLoBygmK5KamzWOcbI5Ohi34QiYAiZsh+54xM+KrniihzD+FyOo6OBJ4f9wc3a4IWAkTjXZJ5lEFY3XZ5Fu1L73q3FNKVfxR3++NFaPe+PAqDxuo/jFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2A5VpHIHYfAWeTXGzGQZw1YMLYDO4ufc6PyTNT6TVi0=;
 b=neSNVPMAPPXET7je5HWiizz381zQr+ExxTWrL0SN7CxOgw4FvWLMvrnPSe38Z2myyIw+OV8TCbCUovE/sAd/wvNspcsECwADDErn2Kiyi0RsB+Xgy3D9Cx69N7D8teS3RwNaC5aapgxqtB0y7YkDjWEGvfMbDDSEgAFeZA29cyCrvGZ9kuJxgeUUJB/JaKG2m7sGaI3Czxq4l7dQY67ifEsMGDLwd6iflwmXaACPv6Ea82vFuJWRJUBv8oiPG+wPZvNgLQrbg/njhU4XfdeEdJHY+/kwWoMMbQ2/F8RfCidmbkXrP6FrvWybzKo9uC3t7yKMQs4x1wdrzUVw6LBbsw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM4PR12MB6328.namprd12.prod.outlook.com (2603:10b6:8:a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 14:08:24 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 14:08:24 +0000
Date:   Thu, 22 Sep 2022 11:08:23 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Farman <farman@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Laine Stump <laine@redhat.com>
Subject: Re: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Message-ID: <YyxsV5SH85YcwKum@nvidia.com>
References: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
 <BN9PR11MB52762909D64C1194F4FCB4528C479@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d5e33ebb-29e6-029d-aef4-af5c4478185a@redhat.com>
 <Yyoa+kAJi2+/YTYn@nvidia.com>
 <20220921120649.5d2ff778.alex.williamson@redhat.com>
 <YytbiCx3CxCnP6fr@nvidia.com>
 <YyxFEpAOC2V1SZwk@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YyxFEpAOC2V1SZwk@redhat.com>
X-ClientProxiedBy: BLAPR03CA0048.namprd03.prod.outlook.com
 (2603:10b6:208:32d::23) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|DM4PR12MB6328:EE_
X-MS-Office365-Filtering-Correlation-Id: c85825c1-6e9e-4f16-dda1-08da9ca3e9f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 60rYI53eR1M0vgXeZkmL6A1JF/mgC6kf4reFpDqG1CtD8oFZ9T36z5rF7ZyYfwFJ7iSt4Ox0f/43SivO9sEp0UWx02Qj7YksTba+UOUDL2GcpUUzth/vADk1AfozeLE08JOpuAUoNEoMzVCwBPLdaJnaq6LMeczMvy+qHvnwrTIYjO9768F+ZHgQt22/O3CUzSn/2rqN0BpibqkbCr8LIf6BJZ0PHBGvjullEzKZCYdEll9pCM9vB0OZOLUrgx149Z4eyUEiuXDlTJK5UmKRP0Dju9xtj5Etismo+2BRpBo4T1n3IBegy1zAW0FN1rtN3Yx/QWO6EqfIzxZvVLor2CKBIOBBQJW1geqHPhranbgUfT6GqhHKcI2nISn/nGVC08yrxjxhEYBaxp6wpQrtVMRKt5rpzJE54hn1JGOgTHFme/8BIgtVHJ9LjP4LMKC/qvdPexRNzj5UG2m7SubVhlGFJMvp8AAoiDIZJRiyeJRB1Km/zjyH9vCdpp6fYLho2zbwz6A4cjTpuH47huXit6kMky4FC7/OE0Iom/qNNbvxWdZL+LDxePfFiDtKW4nBOwqYNCjq6Vv7mgGDx/4HdMjDrRdfgMMkmzSE3z+TTVXYt39/aOLB9AQ78O0DCckXy3BoiwpbNa8nsfmhu4Z9kDwUwL5k6uIUVgvbelnBS3pZpJf4e/MUG2uDtxjZDPDOM2KbZco33D2w1lr5ftxzzUgYyrS0MTQcs3Fc27qR/+0DSI5DshmEmXnO7+uvT1tG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(366004)(376002)(39860400002)(396003)(451199015)(2906002)(86362001)(38100700002)(6506007)(26005)(6512007)(6916009)(54906003)(316002)(8676002)(41300700001)(6486002)(4326008)(478600001)(7416002)(2616005)(8936002)(5660300002)(66476007)(66556008)(186003)(83380400001)(66946007)(36756003)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MDNucThJZzNrTXdtaHJBZXZkV2lmbFI5NzlrUnZhNU9icmRjWkd0OEVzMVdY?=
 =?utf-8?B?eGIzdFFZdFF0U081S01WZXRCV0hsLzJCMUU1MEpnY3Q2ZGhmMDZKT0ExUG9J?=
 =?utf-8?B?VUdtbG5pQTJnREVlTXlvdXpiSXZFZWtzYlJNeUpDWExKZ0ljOU1ONEFrZ0Rq?=
 =?utf-8?B?N3NEQ3R1bHV0VnhMSFh1dmpUdjUwYXlkRUV4eEc4bFhseG9ocUZHd3ovdi8r?=
 =?utf-8?B?bWp5TjZVdGtlU2dQQXdpUXJUblIxRHFXVFBSOXAwTlBwd0FtN2o2MDBJaWFN?=
 =?utf-8?B?Q21nb3RsSlFaMTR6OWk0cUZ2Wk5namZJR2VBTjdJTm5wNndyOFZXbXRCQmpC?=
 =?utf-8?B?VTFKYmhGMWZheGxEMnBYMnNESjJKUXVlS3pRZ3drUUxPYWtWb1F2WmYyWWsr?=
 =?utf-8?B?M3Z5S3NESmViaER2N3hmMG9kdGFzc1hzZVNkOTQ5ZHZoQWNWQUJieG54aTRR?=
 =?utf-8?B?OHp3WURsL0wybCsvbVg4ejlyaHF5MU1hNW84ZEhZZXhkaEw4Rytta1dMWFJr?=
 =?utf-8?B?c0pVT3Y4STRZS2hxb2l4bEFrV2lmNlprMm9WQlA5bGY2U2VWRlVJanhRQ1pW?=
 =?utf-8?B?b1lLVlFTVWRWRHViUkZ4WnNMVmhUTUkwcDJibDArcHRTam5YRDJxdFRFMUYx?=
 =?utf-8?B?UWlGeUxEK2t2ZXZLbGxxK2VONmI0aEZxNnprSGZHRjA3VjFvT1NuZDdvaGVs?=
 =?utf-8?B?WUZDUzdmam9ncGhkV2t6MXRHSzcrZzRaZlFLbi84ZklXc2NDUmxxNlM4ckx6?=
 =?utf-8?B?WnlxS2czREcrZm1jenhkZllkOXIyMnZ3RUdmUWJEZDlWOFhxR2czc3orTkNi?=
 =?utf-8?B?RmFCTFNaSTNpcm1CUTROb0FqYWczbEg2REsvU3QwdzNNekZOdWRrUzlUQ3pY?=
 =?utf-8?B?bk0vQy84OThiK1JIUFVGenpyUXJqYitEbHN5aHp5SG41M1UvQWp0b1d4OTJC?=
 =?utf-8?B?MU5LZ216RDBuT0Z1aDVNNXVkTkgvTWhQSFdtRm83b3Rqa25Balo5SmFkelNJ?=
 =?utf-8?B?Q0Q2eGFBZXc2bE11N2t3TVpyNkU4SUR1bFBUWSs5THNTWHo2ZjBFWDJ5cjdG?=
 =?utf-8?B?Q3AwNjVNYjIvTlQrTktHdUg2bTh3YThkdy9QZUovUzBEdWQzUWVnOU5aM2Rw?=
 =?utf-8?B?Qy8xRTI1RXoyY3N0UXFrZ3E2cXZmVExHNVdaZm8yR0QvR1VFc0E3RTN5ZkRt?=
 =?utf-8?B?dGpSVXdnbDNRTDAwQUw4N3NGUk1FbjhmT1ZRaFEwU1VYT2hUdjF6S2tlODRW?=
 =?utf-8?B?RTF2dG9jdnNKbmpFSWZGQ090M2tZOXRiNFVDSkZqYTNZWXNsblhpTkI4dGZL?=
 =?utf-8?B?RTM1dTdJNjN0TFdzbjR1WFNLUUs4djBKSkpGL3JtcWdGSW1kd25Db1VneE1R?=
 =?utf-8?B?RTdVS2VBWnVobXVMcnlnWWp4Y01tcGorQ3RLL20xdFduZXphTXdWZm5SUUo2?=
 =?utf-8?B?UEhMTW5wUktHZlhvd283RWc4TEFRYUZMckdRb1B6ZkxUZnlreUQ0U2xjMnFy?=
 =?utf-8?B?OXJvWVRXaU1DSzN2bDRudVZyNTcyeU1KNFppTDhVZnlqdUJjV3E4aENRL0pU?=
 =?utf-8?B?Z285Ukw4WVYreGVxUG9tNDk1S0xXbGh5emVjRmhIWU9qQWNoS25xNzVZVS84?=
 =?utf-8?B?VzRJbHRkQ0wwV25WUmcxdGVXS24wK2txb3ZwbXJ6TFhNZ2tKR0ZXbkhQQmwr?=
 =?utf-8?B?QVZpdFpvTUZNaDljelViMXNCUWNULy9UekJXcnVGbEYvQnpoSXFBbmNCSUdZ?=
 =?utf-8?B?K1RjYkt1NUk0ZytOWWNRMmxQcmp6NVNLaCtDa3dEVWJHcW9pZC9BZHRNZ0Zn?=
 =?utf-8?B?SmkvdXRKc2RHclJxRDhCNWFKaGlWQmpmRjZEcmhva0tMUWE0REs5aWZuSmhh?=
 =?utf-8?B?bnYzWmNYelA3VERtcG1KTHQ2bVVEMUhNdThOaExpMjRhQUYyRk1kLzIrU0Ur?=
 =?utf-8?B?Tkk2SGI5UkVCZVhMOU1CcG83eVNFRlBZUHpXUEl0aE85NFlZK1F1c3BPNzUx?=
 =?utf-8?B?MEtBRW5QcmtmSHlyaDkvQm9HK3FqQzhaSkdHRWNUOVlSSk91QzZQaEVHRkVn?=
 =?utf-8?B?UXdlNFdEcE0za085Z09FSDBGOGZ6Ujh0cVdhTmRENFN1eCt1MEtWbVdzdlNS?=
 =?utf-8?Q?6HvDIL+9+t8hfPPuwd3wd6Lvy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c85825c1-6e9e-4f16-dda1-08da9ca3e9f3
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 14:08:24.6408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X6K+9tTchMNoMl8Knv7XOOU034Kd0cZyBhxwDGQBd5WNN8FtT5LKUFkCKmWYOEY8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6328
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022 at 12:20:50PM +0100, Daniel P. Berrangé wrote:
> On Wed, Sep 21, 2022 at 03:44:24PM -0300, Jason Gunthorpe wrote:
> > On Wed, Sep 21, 2022 at 12:06:49PM -0600, Alex Williamson wrote:
> > > The issue is where we account these pinned pages, where accounting is
> > > necessary such that a user cannot lock an arbitrary number of pages
> > > into RAM to generate a DoS attack.  
> > 
> > It is worth pointing out that preventing a DOS attack doesn't actually
> > work because a *task* limit is trivially bypassed by just spawning
> > more tasks. So, as a security feature, this is already very
> > questionable.
> 
> The malicious party on host VM hosts is generally the QEMU process.
> QEMU is normally prevented from spawning more tasks, both by SELinux
> controls and be the seccomp sandbox blocking clone() (except for
> thread creation).  We need to constrain what any individual QEMU can
> do to the host, and the per-task mem locking limits can do that.

Even with syscall limits simple things like execve (enabled eg for
qemu self-upgrade) can corrupt the kernel task-based accounting to the
point that the limits don't work.

Also, you are skipping the fact that since every subsystem does this
differently and wrong a qemu can still go at least 3x over the
allocation using just normal allowed functionalities.

Again, as a security feature this fundamentally does not work. We
cannot account for a FD owned resource inside the task based
mm_struct. There are always going to be exploitable holes.

What you really want is a cgroup based limit that is consistently
applied in the kernel.

Regardless, since this seems pretty well entrenched I continue to
suggest my simpler alternative of making it fd based instead of user
based. At least that doesn't have the unsolvable bugs related to task
accounting.

Jason
