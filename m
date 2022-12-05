Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2E48642BC6
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 16:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbiLEPbF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 10:31:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbiLEPam (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 10:30:42 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2066.outbound.protection.outlook.com [40.107.93.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8746CD8
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 07:29:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F/h0Vt/6aYJm5SzkCrKNA56jnGPHmA73Clb1NUYbaoHuVOuu2SS9NvYTgAeGUENNRAEKlwq7f/pXjAwsjRMfh8LaG+ENKuRxq/VjCgL32jsvH0AoSjNYtgY0GWeZyfeWPi/aE4FF5GnNXQbzShfQ5KhbEAaYbkSiqxGxKesMN+umeahlpy+3Xc88GC6irLqScRllqBVqUJQjIbaicklcK0enpLpQBJtB52kjY2D7LdKEvhfs769TlxBnXDT4Fq8wS77vyThg6a0chMQvQh/v9VGser24xIgbSZaZr02pnbtXDZGYsbY8SHbizPkt+MiCebDzx7ZQaz5Lbd3xZUIJ4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CUvJltKzIq61oWK+cNdikLB40r8dWmWPBRyyIq9wIBM=;
 b=V8fd8sJzrXqM4K1mwy6wr2O/cVOAr/VRQy1i+nngoMKskSYtoBWBqqz4YZzPsi6Rp1u78q193QxjGF39t+0UaVooO4ZdpZAKCd+EZowVKgPkY9V2kwBDRnE8PN/cK9++ASC8xC9Y5AvhFMc2YQy/BCi4T5p/8ZfLGOf62OpEo2NjHcFUr6S25qz9aInR/gxFAEVtGf9/XaHVI+4P37CGZ2MRzhmd5/MTUQgGRzmWdcOZjpELSBC79O9GR2L7lmllyTvzcqLOen8Jz50//JfoRhNBzGOzDbGihoqjaP9298xjYe/V8FDfHK10F7YCsDIANeTr2lW3sgDnnDlCdpAQoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CUvJltKzIq61oWK+cNdikLB40r8dWmWPBRyyIq9wIBM=;
 b=hk/P3flPje3dGpCAPgEhBoYF/KPzrZm6z6A0aN8YDkdyRT48FmVzG8JvEt9f65MsLQdeZJuBpX5CW6seG36QxgmtOkz4mApAdr2Ndkk2lxMBbWdrTL1ULiqsmt8sa6KkD8Y9XMTP9EMGpja3WEOi4Eyo4HTgAhK/q6JMel6OiWkenEzh0ysV9p37Yu1DB7qygMrBZE53KbKGY+g7tMxOwye/nwDgBJJQPEbKd0j+G1/FVzb16vtV9JZ3vphlHqojrka3PEpfVa1Wlc77nUmFikmsy7rGYVEcHt/Rpl2ZCrAUFBJtz7gsdsQX857tfqePicq0YHISAx7ZJ7C0E2K8XQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB6662.namprd12.prod.outlook.com (2603:10b6:8:bb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 5 Dec
 2022 15:29:23 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5880.013; Mon, 5 Dec 2022
 15:29:23 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        =?utf-8?q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 0/5] Simplify the module and kconfig structure in vfio
Date:   Mon,  5 Dec 2022 11:29:15 -0400
Message-Id: <0-v5-fc5346cacfd4+4c482-vfio_modules_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR07CA0098.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::39) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB6662:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b5566b4-4267-4735-bfc9-08dad6d57c7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xK+vydOzztLXIKzNdiIvq9eaM3mKDtneZe7aza4WXzfqBD0YihorE7efIZJey+zSWuauVVQMCGkHkw0LpZ+hzeUCIW46eO3pqChIy8XEGsCLOjfjMqJYenX05Rv6k8SRGaIcBenvBJsmx8b1CmhsCjlA7405Ofu2RfqZRCUA7713W+snhl8KFcdxSUuSMnW0izMQ/peAMZtObdMRanNcrhdhy7ucsnZZd3cJnNSXaTeK+TZ4UvqTtLPQXJBsIsOGYdjQNlawlXuyK0wG2NtK1ZeSqLqscXF4yty9BRcXvqzinuJ+RwE4fFHRNe4amzT0wJg47uXXvFXF973LjNviYKci3iErTECtOvaQoFrv46/hSEQl16oUor53Fb1tUi1n9g5gGEJcjOovDyDwoAEl3EuQIOaLvcIuu3fRU12SVctLF0yhejWOlL+073qAby4Ep5XJjscpvr+qxsaXiNxKo4SZhKY/LWi53WMSZwz7NozGos9aRivSgH2m7KGiKt1z1DYBvGeD5K9PWM+p9JSZCBTsCTsQzYY/E1erKL7nszEV5D1qzPhDDBpyCXRMGNxUq4CR8nSbLlwZqcBQChUasUw9BVSCeMMSgqmKFinZ4vE0UIuIc3SrswRtNHZYUqTMSj+WgJKQMc1b4oR2PN64luxGnwcfsD7JS+/xfBwCnKGebLORAanmDHhjpmtg4Gn/y96gEB7YRJgKkTxaQ9H1XCfC37kx6fmqmdq99r/5nZaWao9FVImWDwVu/lG992sryDyNL0JIWexOX2naLTr/VTS+XhT+JF9e5NBB7E5LT/SrXkWxMEWtnM8Wlo0e8616
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(396003)(366004)(136003)(346002)(451199015)(66476007)(36756003)(38100700002)(2906002)(41300700001)(4326008)(5660300002)(8936002)(83380400001)(86362001)(478600001)(6666004)(66556008)(966005)(2616005)(8676002)(54906003)(110136005)(186003)(316002)(6506007)(6486002)(66946007)(6512007)(26005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RS9tam55c1VodysxSURSWERRZE9IN2ZxUERuQjhWcVBSNmt2U2REWXN1Uyt2?=
 =?utf-8?B?NWJvQnhkbDg1Z1l3UXhrYlJtODB2K0FDa2UzVndNT2FiRFNCUE92dGhVSHBa?=
 =?utf-8?B?eS9RVTE4V0l1WVgrUFNSdUt4R3pQalU0Y2hSNlpoZjF1akp6cU55dDEvZjda?=
 =?utf-8?B?REthb3FMN2lsS0h3K25idGt1ZFAzWEN6K1ExWkU4RjkvSVFPcUFJQ2hielNl?=
 =?utf-8?B?MkwxbXd6N05FYmdjY2RSSEVHZ0dZenJYZTZaM0htQTdsaFc2aUZPU2V4bkZ3?=
 =?utf-8?B?UW5vem5DYWp5QmtEeXorM2ZJdVI1T2NBV21iMXRPSjBqYzlVMXJwcmRBR29i?=
 =?utf-8?B?NmlMNDdlVHhOcXgzakxYMkJEUkIvTkVBeDBVeHZUMG9PWHFqZWxaeWZhUEZL?=
 =?utf-8?B?K1lIbmI5UzdCeUZTa0ZaYXI0S2h4ay9FQ3djTnMzK3hnR2N6Um96dS9zbnR0?=
 =?utf-8?B?T0J6MjRHNFJEOERGQ1doYTdTVXFOV3pjZTRDa2ZvMzVtckxFOCtsdStPcmF1?=
 =?utf-8?B?Nkt0eWt4bWZZY1VwSi9QWXFMM1RlalVlQm80WjZBVXJ5c3owWVgvMjA5WnN1?=
 =?utf-8?B?VTdGNXNnT1hOOGg5L1FQL2k2RGVVemVDYm5NWm1ra0NPbEI1YmFLSXBEQ0U3?=
 =?utf-8?B?cCtUOXV3RG5HNkFPRHRXekZxSkxwQk5VMTgxcHNURVBvbmlDbE1CR0lkanpv?=
 =?utf-8?B?NGlYanV4ZlZ5TFFJd3FiVnFPTGVxWnIxOXdnc0RMN1ZKZ2Z5YjRPVEZRQjdN?=
 =?utf-8?B?d2NkbFBlODlWeU5henRwNlVGYk1kMFpLenhNVFBxWE1oT1JsTGVQYjNOSTds?=
 =?utf-8?B?S2xVN1hHR2wzUnlPUkF3VXlaMjlDNlo5RFpyRllLMXM0SW9BUW8wN3pSNU1V?=
 =?utf-8?B?ckdiczZYcjgrY25Gc3oxOWZUam4rZmpMbUExdXBEQUVIc3MzcGZYdUZ3VjJq?=
 =?utf-8?B?MEtZSitZVnJYM0lSNjl4aXNTTmtTYnhhK0ROaS9qOHg3YVVDOVJUODU3d2N3?=
 =?utf-8?B?S1hxQWdXMU1zanIrNFpJallSOVhDVDVOWEp1aG9OWVlQOWhMOFRUSlJ1T0xK?=
 =?utf-8?B?MUM1Vm9CTVhqTm5oV1lDSWZwcjRLSERPNWJlbUR5Qko4SGs1OVB2WW1tbG55?=
 =?utf-8?B?WXo5MWVvOHJWcnpSM3lmdlJaTUNhZVRXdVZHZGJLcEpFcy9BazVEK2Fzekt6?=
 =?utf-8?B?RFlTU1ZJTVBkR2dyUE1DTmh2NktjTnRzR3UyaTBrdlFLYS9HVy94a1JQTHNp?=
 =?utf-8?B?T0ljQmZtcW0vWDB2NTgwNklMQ0xUMkduQ013d2ZxMjJiN2ZLbkRscHFiS2xC?=
 =?utf-8?B?ZmlHUlp4Vm10OGVSRjRDcnF2ZHpOWVZYbW5mMXlnQnJaS0dJaDJFRDUraU5R?=
 =?utf-8?B?K0w0ZmpIa0hkR3FZMEx5Nm5qZ1VLZERHWFJGZlNxdEZ2N3d1S2s3bXJDL3gz?=
 =?utf-8?B?YTBVZUxRZklXVXJYUUVRZlJkbkJGZDA3UTI3SVBZcjdZQXdlL2N2dGJhT3lt?=
 =?utf-8?B?bmFRK2VzNXBsVXpMQldDOHh2S1l0dUhIUm5SSEVQSjFWUkdQQ0I0bHVOdFFF?=
 =?utf-8?B?STJQczFJMTFBeEJXbEZLZXA2YTgxS0NzMjNsdVRsRTI4dlNBS1dyc25wZk42?=
 =?utf-8?B?L096bTkyMlh6NlNzWndUNlFmM2VvczZWRHVsUmhSeWVqc045cGxpdjAxQVRJ?=
 =?utf-8?B?a3c5Uld1V1NKVDVxMDFPR0tudWh2YVV0TklqRTlBbWVjZVRFNmFjS3kxRjhR?=
 =?utf-8?B?NktiZnhPckVxOFhGNlFYRWhUVUg2N0NEMmkyaDBGUkFjc21qS2xhVXhHVjYx?=
 =?utf-8?B?WTBCZjVpd0lzWktiWVZXa3c3eXQ5MTJYT0dPT2N0dkRyOHJhRlAyK3NLVHJs?=
 =?utf-8?B?bDhoNXIwbjRzcEw4OTRjazdEend5ZDdtTVJsR0t0blpjK0VYTWRKTUhabnFl?=
 =?utf-8?B?TjRwbExCeVBGWlBPWWxxQ3BNM3gyWVI1bXhRbEV1RG9UbTRkT3JuRlJva3lX?=
 =?utf-8?B?NGlmcDY0Y0VEOFRWdXArQitNTERGWHhVMHlLc2VzVWdlWW9KbERkSnVTMkRz?=
 =?utf-8?B?T3VMTFVGNUg4VTBoSE9GQUJHOHpzOVM1ekpJaWs5dFdzclV5RmI0MVpvSy84?=
 =?utf-8?Q?9DAQFui+iIsQJYIYXJyK45Te1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b5566b4-4267-4735-bfc9-08dad6d57c7e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 15:29:23.2030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v4qN2lq1OUm6htEsJ8fR92vIpibhPkaCvTiQ9BBtjWRlPKWYoOMPIvaHV5tEmh6V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6662
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series does a little house cleaning to remove the SPAPR exported
symbols, presence in the public header file, and reduce the number of
modules that comprise VFIO.

v5:
 - Reword commit messages
 - Remove whitespace change from drivers/vfio/pci/vfio_pci_priv.h
v4: https://lore.kernel.org/r/0-v4-7993c351e9dc+33a818-vfio_modules_jgg@nvidia.com
 - Copy IBM copyright header to vfio_iommu_spapr_tce.c
 - Use "return" not "ret = " in vfio_spapr_ioctl_eeh_pe_op()
 - Use just "#if IS_ENABLED(CONFIG_EEH)"
v3: https://lore.kernel.org/r/0-v3-8db96837cdf9+784-vfio_modules_jgg@nvidia.com
 - New patch to fold SPAPR VFIO_CHECK_EXTENSION EEH code into the actual ioctl
 - Remove the 'case VFIO_EEH_PE_OP' indenting level
 - Just open code the calls and #ifdefs to eeh_dev_open()/release()
   instead of using inline wrappers
 - Rebase to v6.1-rc1
v2: https://lore.kernel.org/r/0-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com
 - Add stubs for vfio_virqfd_init()/vfio_virqfd_exit() so that linking
   works even if vfio_pci/etc is not selected
v1: https://lore.kernel.org/r/0-v1-10a2dba77915+c23-vfio_modules_jgg@nvidia.com

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (5):
  vfio/pci: Move all the SPAPR PCI specific logic to vfio_pci_core.ko
  vfio/spapr: Move VFIO_CHECK_EXTENSION into tce_iommu_ioctl()
  vfio: Move vfio_spapr_iommu_eeh_ioctl into vfio_iommu_spapr_tce.c
  vfio: Remove CONFIG_VFIO_SPAPR_EEH
  vfio: Fold vfio_virqfd.ko into vfio.ko

 drivers/vfio/Kconfig                |   7 +-
 drivers/vfio/Makefile               |   5 +-
 drivers/vfio/pci/vfio_pci_core.c    |  11 ++-
 drivers/vfio/vfio.h                 |  13 ++++
 drivers/vfio/vfio_iommu_spapr_tce.c |  65 ++++++++++++++---
 drivers/vfio/vfio_main.c            |   7 ++
 drivers/vfio/vfio_spapr_eeh.c       | 107 ----------------------------
 drivers/vfio/virqfd.c               |  17 +----
 include/linux/vfio.h                |  23 ------
 9 files changed, 91 insertions(+), 164 deletions(-)
 delete mode 100644 drivers/vfio/vfio_spapr_eeh.c


base-commit: 9abf2313adc1ca1b6180c508c25f22f9395cc780
-- 
2.38.1

