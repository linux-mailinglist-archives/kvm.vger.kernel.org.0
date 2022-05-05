Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 607DA51BB73
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 11:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345992AbiEEJL0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 05:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351763AbiEEJLY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 05:11:24 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E214BFCE;
        Thu,  5 May 2022 02:07:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P8hYCLq/2EhqOOd80mFyRN36BUwkQfHkUWxYhX6opA+AbI4ByiPjDJ3lYsbMZ9hk2ocDW9eUafr4BlHEkNb9Tp/qUkIPuDGKY8HeOVrKBqKDgWVCcvG1OBigC1wjxNyy0x0KCRoPatl0N5nfHdHYsoiezTSW43VVeOM2Gy4T4JHaDL81iEHEf3EbDeWnI+7ZbQfOsHf0qO47NyIhp8JzDdhvNS3A39aT0e3+1SgwKTBR4WJ8nN2py9+KuDHuzBd4dD086NeFMRgGwoA0coDSyoD1/TxiP9HJPAr/ue8EYen3+3sRd7DipmHSnXcl0rnjV5iZpExgyDrUccZ5pRtoyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=woKPIg/zSWVo2AIAnotHnEjqGoUevKATOldm4gWcxsY=;
 b=Kj8Eu10a8T2I0Yt1OU0bD4Rf8oQbQEiQ0nV+EsuXTo9G2PXb5GjbagdNlLVjlhPYwfLyrMOMvCVNgYoLkjsEka1Krsa2NgGZ/02wGG2c/xITFDG4R4612XuWjSGQmQ6SMbLEjCL29DyVYGIaoH9DvrIUs8NRaAOJBT/7bjTnBnPRSoMW3EZz0goEwRN6hGIlwyGNug0axvZtK/seq3e4AnOeZPT/lIBNDysusgHcwdrGpiEXweARbQKEVDc6vIdKKer1Bz+ehZLOEMI3Tv6htgVgoYp29/YjWHzqw55Vd/yMy1pJcCzIMPXT/wu9xETHmvlefOM9QK/vJgdSPj+wVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=woKPIg/zSWVo2AIAnotHnEjqGoUevKATOldm4gWcxsY=;
 b=B4aQmjyBMrQE0ihwRW+BknwFZN6rPLYYilyOaje1AWZiQJ/0luT1iNxY/lbRUpwVuNVIQJ94JIlKCDRoN02qwBDtTgYoq/duPyOsrBtbnfbvSqCgr7Zigj5HGCU8vldd/RCZj5EHu30yBWincx9YTPrLJKCXJ0WOpOv6NaAMZ2V/e/kf0jk3+LghTgRgitByb++TlBadIbneQm/CPiY8ZLSiEhnJhehDr9z2c27XdATpQZzD51motAAud3XwoLyTHZ+MOWAy48NpImMJRkwp5lS2y09I9ZfVSGfCTC8Zw6jx5iE/qxP1zumlQkMlHFZO+pJB83jCdA0kYIuIzpgpHQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by MN0PR12MB5716.namprd12.prod.outlook.com (2603:10b6:208:373::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Thu, 5 May
 2022 09:07:40 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::a9fa:62ae:bbc8:9d7d]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::a9fa:62ae:bbc8:9d7d%6]) with mapi id 15.20.5206.025; Thu, 5 May 2022
 09:07:40 +0000
Message-ID: <a0db00a2-82df-f471-f96d-1965e659df65@nvidia.com>
Date:   Thu, 5 May 2022 14:37:21 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v3 5/8] vfio/pci: Enable runtime PM for vfio_pci_core
 based drivers
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
References: <20220425092615.10133-1-abhsahu@nvidia.com>
 <20220425092615.10133-6-abhsahu@nvidia.com>
 <20220504134252.6d556d66.alex.williamson@redhat.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220504134252.6d556d66.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR01CA0080.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::20)
 To BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1215c9c1-65ef-447f-287f-08da2e76b4f1
X-MS-TrafficTypeDiagnostic: MN0PR12MB5716:EE_
X-Microsoft-Antispam-PRVS: <MN0PR12MB571692D8784FB9F906210787CCC29@MN0PR12MB5716.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2CYuD+S4VZ3SHoSOv2hMzMzos1eKOMEPdUCm6oSkiuTw6BqVgkejOOqQW/90j8F3wGevDJTzbRSZpIuVOgib6B8JDZCEbSJ7Bm303MUlx1n7meoQxC4JaALcLeqZYYNV84qxVk2mIGk9lYIC62tPMqOoQHHY67VEI4+uZGzKC/rbgCf1KWO4TbOLOXMvK9yTFTHJw0UHRrOuLmA7Gdl5UrYko7bL1KiZCdBjWQaBBYDO4LqowoTXlTX/SaAAC9/xeSK6l0GNfDq6ZTCUPM7hnSwSbmL0n1HyL+EIxAGYM4lYSHjDpGNA2JvARNE1KI/2rkV4EfdSBjKlm3zOd6wygbm6lIzXnCHlKG2cerF36JKv81VB/mV4pRBnQkmUEIL8nrYGDqED3WJPablSsL0+FZ6nNjrKrQOLuG9f0q5bo9s61JYEUVo8X0wZptBFbePyPvpKpKsIIgQyiJ7G3uPOBfLVCsF1YdlDJca/gVjDRzeqfmk9uhsqAeAbVb/58pndxVDvzK1TNpxm/dSsA+89eEwlVA1q6U9RQIf7F0EzfRFcADSk9gY4quoWVAklVh1Iqoht4+rERTn6CeA6D+vDDeDJoAzfuscQwHGPE5xlQfbC5wJ1XJmHvdWOWLYJmVsWRqA9pkZOCTnnwi9oeUD9GdXiAG+56OPiAHNNV6FOYttO2iA9X7jYcs9RcNxPadolarZ0nYINpWriFnfx1NfYOIyET47gr64OI8H0berb5PA7J7gaYL7eK+Zdd8ClZqnO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(30864003)(316002)(7416002)(31686004)(508600001)(5660300002)(8936002)(54906003)(186003)(6916009)(2616005)(6666004)(6506007)(53546011)(36756003)(6486002)(6512007)(55236004)(26005)(83380400001)(31696002)(4326008)(8676002)(66556008)(86362001)(66476007)(66946007)(2906002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cnNvcktxRFF3UmlaaEdsYjJQTHBlbnVUV0U1SXhsZ0J3aitwbEJWelBFZVpK?=
 =?utf-8?B?eVk2a2hOQWNMa05oS0orSGZrTjJ3ZG94aTU4bGR4Wmp1c1Q5TFFLdWJwdDk4?=
 =?utf-8?B?bUVHckZwZTh5Sk1FZzluTTBEQVFMVkw4eFBjeGd0YXJia2hUK2Y5czN1Ulpn?=
 =?utf-8?B?MTVHYlpKVmFhcUtiRUJEQ0NIbkN0ZWpPa3RzcmlZN2F2K2ZRTmVmZWN3dTE5?=
 =?utf-8?B?NG82WnRLZEFQTUI2enB0TVY2eURtbmY5M0l5ZjM5b014Rkd2NnpkY054T1du?=
 =?utf-8?B?blJValR6ZmpuWVljdkpJSEVtcndvbVFlblFqcU9XVE93Q25PTEZDcXQ3RHFQ?=
 =?utf-8?B?R1R2eWNQUWlJRVVaK3FrZU9tb3FhWmdGSXI5M3JOT2hxL0JUR1VTRnVrdE5t?=
 =?utf-8?B?VXRmbWIvbHlmdUp5d2RmSXJWSWZMd3pCRjQ2TExGUTFRenhla2RNcmVWM21m?=
 =?utf-8?B?ZmUrbTV5aVp4NXA2VENCWG9LanBORng1MFYxMnF3UW90Z2t1YVJpcC9BTGhz?=
 =?utf-8?B?ZTJ2aGFmMkVMNlJWWW9XRmlGVC9kSFVZV0lORzdzRHloTmR3NldTT0pJTjRq?=
 =?utf-8?B?aGphTTFDUDEra2h0amVKWHRBaE81N3dKZ1AzbWVYU2R3K2gwZDJlSE1DY3Bp?=
 =?utf-8?B?S0R1czgrcUVDWlZEZlR2YlZqcDJISDBaMm1rNjY1cUluM2lyZTc1aWZGQVlN?=
 =?utf-8?B?TzMwQVo1N2NXYTBZWnM2RUtzMWt2MnhNMEg3NHQ5TzRxcGY4ays3NmdwYUpN?=
 =?utf-8?B?aHpqUjIwRjlTVlpZQi82ZmFKelZUZ2RVa1ArSVFxYnpEUjQ4TTBNYTVlaTh4?=
 =?utf-8?B?c0tsWHNKOHZRNmVGckhJbGtCVWg2RnpYQnVsbGdJVlNQVjFIdFlET2pPMUxP?=
 =?utf-8?B?b3ZINnpkWW9kVnIydHllZ1Z5V21OaitWSy85RlVWaFJLR01FRCsrL0xCbmgr?=
 =?utf-8?B?bGduYVdOWXQrSm9kR0NMZUtZU3p2bnVzN3JvUDlGUnNYSllMa2llSUNpUmVj?=
 =?utf-8?B?amhqY1ZMSFNISnpwcUdEN2pmVDNjRDBWMkJxYzVUSnhKYm52WGxlNisvd1dH?=
 =?utf-8?B?NWtoeFUwb3pkTGJISzFML2R2ZDN3eE1pSjI4ek1oN1FUeVR1Y3poMWJFK05E?=
 =?utf-8?B?cnNRRE44d1NObDIvR1ZLbFhYY0UwWDlYWXV3N1pFcit3VFE0KzhLNmltdlo0?=
 =?utf-8?B?dVpPcHVidWpoSGZQU1dESFZyQUlobEdSejVaODlSNEcxNzQ2SXZhTmxPS0gr?=
 =?utf-8?B?VXBuYUM4UGpad21IZWxIWjVneGUvYzB0aUl6R2E4NTVUaG1Tb1lKWEhOdVdV?=
 =?utf-8?B?bFFlMUpBek5QdVFBQTRCMDlPTG1sSWNLM3YrcVFLMGFEdHNKMTl0OEpWLzk0?=
 =?utf-8?B?dUhiYTZ3NGtZSjRONG1DUmtUWUdzNEZlQkpnSm9rbk9XYTBVQ3FpWXFqT01a?=
 =?utf-8?B?Z1F1ZGNGb3NBVjhGVlJEYlREWDVHSEcwSUF1Tm9RVm9PSXJtSHp3enl6S0xC?=
 =?utf-8?B?NktXR3U2V21EUFppYW9Zek5vem9mdEZGU0FkS1FqYTRYWDlNbzh4V1R5a0F5?=
 =?utf-8?B?cnoyM1g4VUVzTGpkSktWdENhUDRlcjVZUHU2TXVyc1RYN0FMcktIL21vc1Q1?=
 =?utf-8?B?cmN5MFRiR09PVkZxdFovdlgrUE52NEU2anBsckZnWlk4QTM0aEtIRitKVGlx?=
 =?utf-8?B?Z1F5Rld6K2RqN1lsV3hQNDJXRVp1cmthS2xsOHVBeGQyd1ZoaVh6QWwxZGVZ?=
 =?utf-8?B?bUNjYmxxRkw2Q2dJM1ovMkYzUlJDWm1DZW96QnZRR3kzMWlRWmxQNTRDU2Rk?=
 =?utf-8?B?RHVZSzBwaTZqT0ZRTkp4a0NqQUVvQ2VQb1cxNWV6VkJjQkJLa296eVkwQmg3?=
 =?utf-8?B?SGNiZ3Y5NVFPQzBtRkNoUjdMaUsyaEdCOVBPUG1uTlI5WjZTeHMxMHg5bCtP?=
 =?utf-8?B?U3g0MnNQMUhEcFdscGI3ZElmQmNneUcvWVZPWkdTYWpxYllVZTRQTWdQTkRB?=
 =?utf-8?B?MUxMMFlscVJST3gzdndyd1EzalJ3a2N4elhNQlROZXFERkpTc1dpYjZlZVlG?=
 =?utf-8?B?eUFVdk5HbU05Y2JKRUhCUmZwRUp2cXQxamJVdzNNdnFEWDdyakZBSkFjN05T?=
 =?utf-8?B?VTZQOEJUTFY1WGFsKzRxbStjOXlNZCtzcnRhRzYyMy9sV0xlN0tBdlRLTENX?=
 =?utf-8?B?dEhLRzlCQ2pqY1k4NERNck1XOEZlcVZJQkNMY2pROEpnaUhlcFlXdW9paTRI?=
 =?utf-8?B?L3hrSzk5amJoWE1JRkFPUXhkeU1ySEVKSzMvQmY4ZEo4c0trWS92VFliNllH?=
 =?utf-8?B?U1RoQys5YWFkejUzUmZHcWtIb3U3YUlwSmV5VVdpVUc1UWprTkpWdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1215c9c1-65ef-447f-287f-08da2e76b4f1
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 09:07:40.6973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A3OTGE1CIrYUpPXIhbjl70oR11wUobSbiHg1X+/Eck/CN0TalE3MTzl+OoFgmK+iihT/CjVf+YzD0EntwiWiJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5716
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/5/2022 1:12 AM, Alex Williamson wrote:
> On Mon, 25 Apr 2022 14:56:12 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> 
>> Currently, there is very limited power management support
>> available in the upstream vfio_pci_core based drivers. If there
>> are no users of the device, then the PCI device will be moved into
>> D3hot state by writing directly into PCI PM registers. This D3hot
>> state help in saving power but we can achieve zero power consumption
>> if we go into the D3cold state. The D3cold state cannot be possible
>> with native PCI PM. It requires interaction with platform firmware
>> which is system-specific. To go into low power states (including D3cold),
>> the runtime PM framework can be used which internally interacts with PCI
>> and platform firmware and puts the device into the lowest possible
>> D-States.
>>
>> This patch registers vfio_pci_core based drivers with the
>> runtime PM framework.
>>
>> 1. The PCI core framework takes care of most of the runtime PM
>>    related things. For enabling the runtime PM, the PCI driver needs to
>>    decrement the usage count and needs to provide 'struct dev_pm_ops'
>>    at least. The runtime suspend/resume callbacks are optional and needed
>>    only if we need to do any extra handling. Now there are multiple
>>    vfio_pci_core based drivers. Instead of assigning the
>>    'struct dev_pm_ops' in individual parent driver, the vfio_pci_core
>>    itself assigns the 'struct dev_pm_ops'. There are other drivers where
>>    the 'struct dev_pm_ops' is being assigned inside core layer
>>    (For example, wlcore_probe() and some sound based driver, etc.).
>>
>> 2. This patch provides the stub implementation of 'struct dev_pm_ops'.
>>    The subsequent patch will provide the runtime suspend/resume
>>    callbacks. All the config state saving, and PCI power management
>>    related things will be done by PCI core framework itself inside its
>>    runtime suspend/resume callbacks (pci_pm_runtime_suspend() and
>>    pci_pm_runtime_resume()).
>>
>> 3. Inside pci_reset_bus(), all the devices in dev_set needs to be
>>    runtime resumed. vfio_pci_dev_set_pm_runtime_get() will take
>>    care of the runtime resume and its error handling.
>>
>> 4. Inside vfio_pci_core_disable(), the device usage count always needs
>>    to be decremented which was incremented in vfio_pci_core_enable().
>>
>> 5. Since the runtime PM framework will provide the same functionality,
>>    so directly writing into PCI PM config register can be replaced with
>>    the use of runtime PM routines. Also, the use of runtime PM can help
>>    us in more power saving.
>>
>>    In the systems which do not support D3cold,
>>
>>    With the existing implementation:
>>
>>    // PCI device
>>    # cat /sys/bus/pci/devices/0000\:01\:00.0/power_state
>>    D3hot
>>    // upstream bridge
>>    # cat /sys/bus/pci/devices/0000\:00\:01.0/power_state
>>    D0
>>
>>    With runtime PM:
>>
>>    // PCI device
>>    # cat /sys/bus/pci/devices/0000\:01\:00.0/power_state
>>    D3hot
>>    // upstream bridge
>>    # cat /sys/bus/pci/devices/0000\:00\:01.0/power_state
>>    D3hot
>>
>>    So, with runtime PM, the upstream bridge or root port will also go
>>    into lower power state which is not possible with existing
>>    implementation.
>>
>>    In the systems which support D3cold,
>>
>>    // PCI device
>>    # cat /sys/bus/pci/devices/0000\:01\:00.0/power_state
>>    D3hot
>>    // upstream bridge
>>    # cat /sys/bus/pci/devices/0000\:00\:01.0/power_state
>>    D0
>>
>>    With runtime PM:
>>
>>    // PCI device
>>    # cat /sys/bus/pci/devices/0000\:01\:00.0/power_state
>>    D3cold
>>    // upstream bridge
>>    # cat /sys/bus/pci/devices/0000\:00\:01.0/power_state
>>    D3cold
>>
>>    So, with runtime PM, both the PCI device and upstream bridge will
>>    go into D3cold state.
>>
>> 6. If 'disable_idle_d3' module parameter is set, then also the runtime
>>    PM will be enabled, but in this case, the usage count should not be
>>    decremented.
>>
>> 7. vfio_pci_dev_set_try_reset() return value is unused now, so this
>>    function return type can be changed to void.
>>
>> 8. Use the runtime PM API's in vfio_pci_core_sriov_configure().
>>    For preventing any runtime usage mismatch, pci_num_vf() has been
>>    called explicitly during disable.
>>
>> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
>> ---
>>  drivers/vfio/pci/vfio_pci_core.c | 169 +++++++++++++++++++++----------
>>  1 file changed, 114 insertions(+), 55 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index 953ac33b2f5f..aee5e0cd6137 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -156,7 +156,7 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
>>  }
>>  
>>  struct vfio_pci_group_info;
>> -static bool vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
>> +static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
>>  static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>>  				      struct vfio_pci_group_info *groups);
>>  
>> @@ -261,6 +261,19 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
>>  	return ret;
>>  }
>>  
>> +#ifdef CONFIG_PM
>> +/*
>> + * The dev_pm_ops needs to be provided to make pci-driver runtime PM working,
>> + * so use structure without any callbacks.
>> + *
>> + * The pci-driver core runtime PM routines always save the device state
>> + * before going into suspended state. If the device is going into low power
>> + * state with only with runtime PM ops, then no explicit handling is needed
>> + * for the devices which have NoSoftRst-.
>> + */
>> +static const struct dev_pm_ops vfio_pci_core_pm_ops = { };
>> +#endif
>> +
>>  int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
>>  {
>>  	struct pci_dev *pdev = vdev->pdev;
>> @@ -268,21 +281,23 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
>>  	u16 cmd;
>>  	u8 msix_pos;
>>  
>> -	vfio_pci_set_power_state(vdev, PCI_D0);
>> +	if (!disable_idle_d3) {
>> +		ret = pm_runtime_resume_and_get(&pdev->dev);
>> +		if (ret < 0)
>> +			return ret;
>> +	}
>>  
>>  	/* Don't allow our initial saved state to include busmaster */
>>  	pci_clear_master(pdev);
>>  
>>  	ret = pci_enable_device(pdev);
>>  	if (ret)
>> -		return ret;
>> +		goto out_power;
>>  
>>  	/* If reset fails because of the device lock, fail this path entirely */
>>  	ret = pci_try_reset_function(pdev);
>> -	if (ret == -EAGAIN) {
>> -		pci_disable_device(pdev);
>> -		return ret;
>> -	}
>> +	if (ret == -EAGAIN)
>> +		goto out_disable_device;
>>  
>>  	vdev->reset_works = !ret;
>>  	pci_save_state(pdev);
>> @@ -306,12 +321,8 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
>>  	}
>>  
>>  	ret = vfio_config_init(vdev);
>> -	if (ret) {
>> -		kfree(vdev->pci_saved_state);
>> -		vdev->pci_saved_state = NULL;
>> -		pci_disable_device(pdev);
>> -		return ret;
>> -	}
>> +	if (ret)
>> +		goto out_free_state;
>>  
>>  	msix_pos = pdev->msix_cap;
>>  	if (msix_pos) {
>> @@ -332,6 +343,16 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
>>  
>>  
>>  	return 0;
>> +
>> +out_free_state:
>> +	kfree(vdev->pci_saved_state);
>> +	vdev->pci_saved_state = NULL;
>> +out_disable_device:
>> +	pci_disable_device(pdev);
>> +out_power:
>> +	if (!disable_idle_d3)
>> +		pm_runtime_put(&pdev->dev);
>> +	return ret;
>>  }
>>  EXPORT_SYMBOL_GPL(vfio_pci_core_enable);
>>  
>> @@ -439,8 +460,11 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>>  out:
>>  	pci_disable_device(pdev);
>>  
>> -	if (!vfio_pci_dev_set_try_reset(vdev->vdev.dev_set) && !disable_idle_d3)
>> -		vfio_pci_set_power_state(vdev, PCI_D3hot);
>> +	vfio_pci_dev_set_try_reset(vdev->vdev.dev_set);
>> +
>> +	/* Put the pm-runtime usage counter acquired during enable */
>> +	if (!disable_idle_d3)
>> +		pm_runtime_put(&pdev->dev);
>>  }
>>  EXPORT_SYMBOL_GPL(vfio_pci_core_disable);
>>  
>> @@ -1879,19 +1903,24 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev,
>>  
>>  	vfio_pci_probe_power_state(vdev);
>>  
>> -	if (!disable_idle_d3) {
>> -		/*
>> -		 * pci-core sets the device power state to an unknown value at
>> -		 * bootup and after being removed from a driver.  The only
>> -		 * transition it allows from this unknown state is to D0, which
>> -		 * typically happens when a driver calls pci_enable_device().
>> -		 * We're not ready to enable the device yet, but we do want to
>> -		 * be able to get to D3.  Therefore first do a D0 transition
>> -		 * before going to D3.
>> -		 */
>> -		vfio_pci_set_power_state(vdev, PCI_D0);
>> -		vfio_pci_set_power_state(vdev, PCI_D3hot);
>> -	}
>> +	/*
>> +	 * pci-core sets the device power state to an unknown value at
>> +	 * bootup and after being removed from a driver.  The only
>> +	 * transition it allows from this unknown state is to D0, which
>> +	 * typically happens when a driver calls pci_enable_device().
>> +	 * We're not ready to enable the device yet, but we do want to
>> +	 * be able to get to D3.  Therefore first do a D0 transition
>> +	 * before enabling runtime PM.
>> +	 */
>> +	vfio_pci_set_power_state(vdev, PCI_D0);
>> +
>> +#if defined(CONFIG_PM)
>> +	dev->driver->pm = &vfio_pci_core_pm_ops,
>> +#endif
>> +
>> +	pm_runtime_allow(dev);
>> +	if (!disable_idle_d3)
>> +		pm_runtime_put(dev);
>>  
>>  	ret = vfio_register_group_dev(&vdev->vdev);
>>  	if (ret)
>> @@ -1900,7 +1929,9 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev,
>>  
>>  out_power:
>>  	if (!disable_idle_d3)
>> -		vfio_pci_set_power_state(vdev, PCI_D0);
>> +		pm_runtime_get_noresume(dev);
>> +
>> +	pm_runtime_forbid(dev);
>>  out_vf:
>>  	vfio_pci_vf_uninit(vdev);
>>  out_drvdata:
>> @@ -1922,8 +1953,9 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
>>  	vfio_pci_vga_uninit(vdev);
>>  
>>  	if (!disable_idle_d3)
>> -		vfio_pci_set_power_state(vdev, PCI_D0);
>> +		pm_runtime_get_noresume(dev);
>>  
>> +	pm_runtime_forbid(dev);
>>  	dev_set_drvdata(dev, NULL);
>>  }
>>  EXPORT_SYMBOL_GPL(vfio_pci_core_unregister_device);
>> @@ -1984,18 +2016,26 @@ int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
>>  
>>  		/*
>>  		 * The PF power state should always be higher than the VF power
>> -		 * state. If PF is in the low power state, then change the
>> -		 * power state to D0 first before enabling SR-IOV.
>> +		 * state. If PF is in the runtime suspended state, then resume
>> +		 * it first before enabling SR-IOV.
>>  		 */
>> -		vfio_pci_set_power_state(vdev, PCI_D0);
>> -		ret = pci_enable_sriov(pdev, nr_virtfn);
>> +		ret = pm_runtime_resume_and_get(&pdev->dev);
>>  		if (ret)
>>  			goto out_del;
>> +
>> +		ret = pci_enable_sriov(pdev, nr_virtfn);
>> +		if (ret) {
>> +			pm_runtime_put(&pdev->dev);
>> +			goto out_del;
>> +		}
>>  		ret = nr_virtfn;
>>  		goto out_put;
>>  	}
>>  
>> -	pci_disable_sriov(pdev);
>> +	if (pci_num_vf(pdev)) {
>> +		pci_disable_sriov(pdev);
>> +		pm_runtime_put(&pdev->dev);
>> +	}
>>  
>>  out_del:
>>  	mutex_lock(&vfio_pci_sriov_pfs_mutex);
>> @@ -2072,6 +2112,30 @@ vfio_pci_dev_set_resettable(struct vfio_device_set *dev_set)
>>  	return pdev;
>>  }
>>  
>> +static int vfio_pci_dev_set_pm_runtime_get(struct vfio_device_set *dev_set)
>> +{
>> +	struct vfio_pci_core_device *cur_pm;
>> +	struct vfio_pci_core_device *cur;
>> +	int ret = 0;
>> +
>> +	list_for_each_entry(cur_pm, &dev_set->device_list, vdev.dev_set_list) {
>> +		ret = pm_runtime_resume_and_get(&cur_pm->pdev->dev);
>> +		if (ret < 0)
>> +			break;
>> +	}
>> +
>> +	if (!ret)
>> +		return 0;
>> +
>> +	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
>> +		if (cur == cur_pm)
>> +			break;
>> +		pm_runtime_put(&cur->pdev->dev);
>> +	}
>> +
>> +	return ret;
>> +}
> 
> The above works, but maybe could be a little cleaner taking advantage
> of list_for_each_entry_continue_reverse as:
> 
> {
> 	struct vfio_pci_core_device *cur;
> 	int ret;
> 
> 	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
> 		ret = pm_runtime_resume_and_get(&cur->pdev->dev);
> 		if (ret)
> 			goto unwind;
> 	}
> 
> 	return 0;
> 
> unwind:
> 	list_for_each_entry_continue_reverse(cur, &dev_set->device_list, vdev.dev_set_list)
> 		pm_runtime_put(&cur->pdev->dev);
> 
> 	return ret;
> }
> 
> Thanks,
> Alex
> 

 Thanks Alex.
 I will make this change.

 Regards,
 Abhishek

>> +
>>  /*
>>   * We need to get memory_lock for each device, but devices can share mmap_lock,
>>   * therefore we need to zap and hold the vma_lock for each device, and only then
>> @@ -2178,43 +2242,38 @@ static bool vfio_pci_dev_set_needs_reset(struct vfio_device_set *dev_set)
>>   *  - At least one of the affected devices is marked dirty via
>>   *    needs_reset (such as by lack of FLR support)
>>   * Then attempt to perform that bus or slot reset.
>> - * Returns true if the dev_set was reset.
>>   */
>> -static bool vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set)
>> +static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set)
>>  {
>>  	struct vfio_pci_core_device *cur;
>>  	struct pci_dev *pdev;
>> -	int ret;
>> +	bool reset_done = false;
>>  
>>  	if (!vfio_pci_dev_set_needs_reset(dev_set))
>> -		return false;
>> +		return;
>>  
>>  	pdev = vfio_pci_dev_set_resettable(dev_set);
>>  	if (!pdev)
>> -		return false;
>> +		return;
>>  
>>  	/*
>> -	 * The pci_reset_bus() will reset all the devices in the bus.
>> -	 * The power state can be non-D0 for some of the devices in the bus.
>> -	 * For these devices, the pci_reset_bus() will internally set
>> -	 * the power state to D0 without vfio driver involvement.
>> -	 * For the devices which have NoSoftRst-, the reset function can
>> -	 * cause the PCI config space reset without restoring the original
>> -	 * state (saved locally in 'vdev->pm_save').
>> +	 * Some of the devices in the bus can be in the runtime suspended
>> +	 * state. Increment the usage count for all the devices in the dev_set
>> +	 * before reset and decrement the same after reset.
>>  	 */
>> -	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list)
>> -		vfio_pci_set_power_state(cur, PCI_D0);
>> +	if (!disable_idle_d3 && vfio_pci_dev_set_pm_runtime_get(dev_set))
>> +		return;
>>  
>> -	ret = pci_reset_bus(pdev);
>> -	if (ret)
>> -		return false;
>> +	if (!pci_reset_bus(pdev))
>> +		reset_done = true;
>>  
>>  	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
>> -		cur->needs_reset = false;
>> +		if (reset_done)
>> +			cur->needs_reset = false;
>> +
>>  		if (!disable_idle_d3)
>> -			vfio_pci_set_power_state(cur, PCI_D3hot);
>> +			pm_runtime_put(&cur->pdev->dev);
>>  	}
>> -	return true;
>>  }
>>  
>>  void vfio_pci_core_set_params(bool is_nointxmask, bool is_disable_vga,
> 

