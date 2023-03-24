Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE206C7CE8
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 11:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbjCXKzL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 06:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbjCXKzJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 06:55:09 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11olkn2014.outbound.protection.outlook.com [40.92.18.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503582471A
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 03:55:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PqEbZoWBm6Gulh6+RO80DLGFVv/sjscYMO5zHaucuCpD1wmoCpuvhZ2uyPB4T9K536Ky2vHBS1fBNWJKSWpJH1/w8Du8OjQT3A9lfwbyPum35hgoeqEqiGCY9DUYTwFnyjE4Gy0XjcoTVceV/rnZQQpeMAWiMg/gLv4dhjDRsLkLgUcwqQFkOXlzyIbyHr+P/YGYRzR9VMG4wXRgcbKVI4pZfBFoSWWJxgLScMTFj9CY7fQA8ukyyyHS83QYkJM5L5PAQfML2eOJ7MLbARM/dycPCH3k8gcEodtcbXqioSX+F2isrZO2mjxMkaZHn8EbS3b8571VGw+uQ6hnURHMWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cD7ZSVWnjZ02anPvv2hQrvM14qhVjy7ivPCm7wwIlKs=;
 b=DkL6lnbXoZ8SKrTRCbS/mjbShpBEf/dtXaHh30JSfGmxjOqi95kPakUZu5Ar9oJQwfkBypNeAUv3ApFfdTT4Cz7MmICavkQrrm8if9PZm0AkhIrIpazpFf+kuX0L0GOAeNcJGIMv6GXsCh5zv+IqxvKapZgZpCXzBPaAK2SUJhFEVpDhNrabXZt4Fcpl9npgZaiychoSLl41otVYVFGY9/zuSCiYSiSW/d0inA0Ihkr0PkOwQX4c2HCEZ3NG/30B9z7GlneZLrYsSHF47o60DJgEhj+g9wAFPIvzjbMGHoBw8AgaUw/bpFENuc6idEX1wV4/Ogk8ht8orJWW4yxm+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cD7ZSVWnjZ02anPvv2hQrvM14qhVjy7ivPCm7wwIlKs=;
 b=FKbB4NgOlyGBJrZLUXzesVNMqCnPbTHhlnlmX5ccktfJnhI4hqVSVkyX2jWQWaAOeeTkRzCY+n7uJj1ZRlSWiDW+fLc8+58uGjn9hZGVLdsUZH5XCdcLwqaHX1VJv8auI1uFd95VEpn5tKgyqOMfzvQGSmrF50liv7pa5DFic/xJ+CNHq19keszLOa8Y4wdfYqSPwtIzVoCix4KIWO6ClTOAa7ZL9Zz2UiaXNLf218noEX/7RMXvvVkUUWD9/6GwZNmR2zaMiNc1O/AvleQ7pB8UVXzdaiFb5ru+2vEy+5V5pvCF7TsUowBUUiUnOneAcNjeM+e+S1xNQ1vJlANauA==
Received: from MN2PR12MB3023.namprd12.prod.outlook.com (2603:10b6:208:c8::26)
 by DM4PR12MB6038.namprd12.prod.outlook.com (2603:10b6:8:ab::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Fri, 24 Mar
 2023 10:55:04 +0000
Received: from MN2PR12MB3023.namprd12.prod.outlook.com
 ([fe80::af4a:1da1:aace:38fa]) by MN2PR12MB3023.namprd12.prod.outlook.com
 ([fe80::af4a:1da1:aace:38fa%7]) with mapi id 15.20.6178.038; Fri, 24 Mar 2023
 10:55:04 +0000
Message-ID: <MN2PR12MB3023F67FF37889AB3E8885F2A0849@MN2PR12MB3023.namprd12.prod.outlook.com>
Date:   Fri, 24 Mar 2023 11:55:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US
To:     kvm@vger.kernel.org
From:   =?UTF-8?Q?Micha=c5=82_Zegan?= <webczat@outlook.com>
Subject: Nested virtualization not working with hyperv guest/windows 11
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TMN:  [OIq97OalzzWqn/gqkKeHJBhEHLE4+Yjp]
X-ClientProxiedBy: BE1P281CA0063.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:26::8) To MN2PR12MB3023.namprd12.prod.outlook.com
 (2603:10b6:208:c8::26)
X-Microsoft-Original-Message-ID: <f0afb47a-66d1-8519-4119-c67d3d6106be@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3023:EE_|DM4PR12MB6038:EE_
X-MS-Office365-Filtering-Correlation-Id: ce5d0021-fc30-4259-da99-08db2c563940
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zSeaFA8vErOBH7+4+wykSnaDpXisxxaqtcwv32HdyxT1bNWpMYC5MVgV1H8oK56FdHqPYHsSASrUHYTbN5AFWGRMd6a3lwlrG0LH8lXCbT71jLmt5KF0E24ekbhjYeWjtvaoqockbYg9kWufWoPtUgqQl+ROL+jLoaOO94lQc2PPPRdoIBiRUVhnkHQiSiZq7DxjT684bMlllEr2nl3ixzhjhtwSt52dGP7q10gN9UJGB515oXT+flfg5pnaxOvvz6AmhI9sPSjYf5OA4bhMUnV643GSVeBID09YBn0JGxTqafcqzJ22DLdlk5OMpP/fjercYoipOcLXNpZMMuJW7fbzwkI67/XJILRybpwlLo1096f2WkxSFMKOKADNeMJN/f30GKhEToFjOT3yS95szNwinYyCzZCwIPfTmeSF3o6e5+2LtmPCXLVrCnKQrR+r9QfZgfVA+1Z1bXdJNsJZcW/FBFs9+qjq6q+rfmm64L6LnzGvMsr6e4fagt+MJ+ud6aTRWdr9CD4YWs20Q3V4jm/U3+IMdh8yozEvBX6sQNYWgv8TOfh2m9KyxVkgIoDwa4CbygU5RFCr+maCsvEXPE7Xwu98vsqaJM/CV4H5M+M=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZmphSFNQeHhkc2phZjJFTmw2dFcvVG5pditaY2YzR09lZEpBSjNhT1c4Q2dq?=
 =?utf-8?B?Ny8vZDd6eU5ISmxSMlVvVE9ZUDdwVFFkVjdnZlJkMmpvKzVHSUdYTjBmZDRi?=
 =?utf-8?B?b3M1N1A4K1l0K1ZYbzZpc1FYSE83SkZmUGZQVjhJV2VPVm02YXU3cDBXaGZh?=
 =?utf-8?B?NUpXQmwvY1IxWDZwZzlBVEdLUDJNOG9rRkpqa05TajB1VTQ1d0pobVkyc0oz?=
 =?utf-8?B?Q1lUWUlqYnpGYjQ1OWpRa3BKOEZybHpUM0xzYlJ4L0VUK1dqT1RMZDM2RXd1?=
 =?utf-8?B?TlpScm13OFUxZzNKK1JSQTBzb093M2UvRVFJMVlFamMvemFpT2lwQVd6azUy?=
 =?utf-8?B?SXFZRlFQb3dtaTdYdExmeWVzcUF5ejNIU2JKVDZQeExtNkllWGlFRjg3K1FW?=
 =?utf-8?B?LzVtRmoxRlFVTUc1MG5KQW4xYyt3WTJxYSsvRkRPYXU5UzRMMXpBWmJLTEFG?=
 =?utf-8?B?L0JTTnlkTTdWK0lJRlJxMWhvcTgvdW5GaGtBSEQrZEp1aDJYNzZERFZCWU5P?=
 =?utf-8?B?QWllUzRzWk5CL0xRZ3IraU9QTG1xU0lsb05BYURZU0V2L0xaNFA0NVVjTHVK?=
 =?utf-8?B?ZzBLMkJqSitwaDhKZkhZQjRSZnowYlZZMVZYQjlFQmZ4cWxJMmRQYndqeXBw?=
 =?utf-8?B?QVVVWXVBclF0YTFyK3FCK24wZkk3cFp0RjE2TlE4WWIweHBvYVN4bExtRlpy?=
 =?utf-8?B?VmVFNi91N2RiUWpxNVFKWGdLV1d4QXNJMnhUMjJxUEFHYkJDOXJQdXRTNkRZ?=
 =?utf-8?B?cFpGV2VsSjZnRnlkbXFHMU90UDRyMWFNWUJ0VmVsREFqbFdEVEJldDIzbXdS?=
 =?utf-8?B?V0FiOE1FT08yVGRpL2lDY2N3ZWxndXVFU055c1lnRlpLdDEweUVEM3FoTXUz?=
 =?utf-8?B?a0JXY0hMVzR3ZzFPdEVVbzZnTEh3eTRHb0Z2NkxUS0ZxUnljdGl3YUgvNm1l?=
 =?utf-8?B?YXVjNmVyODBEMkx5WS9EWHY2ZURZTGZnVnIvbTNwdnRQZTJDdEJxN2cwa0xP?=
 =?utf-8?B?eE1CSTB4S0VELy9DVFVabnVtV0pGa0hNcVZKaTBiQW1VK0hwVG1YWGxrQ0VI?=
 =?utf-8?B?QyszMTVUalpHYXNYWFN1N2RRdVBVZEVsTXlBbEpJMHZ1bVhVYWJtSXMwUGhH?=
 =?utf-8?B?QmFDdld4OFQvSHZWT2RyOE45cllJM2VldDZ2MkU2WDFoWVRqVG5QdHhHRWtS?=
 =?utf-8?B?OWRrWU8wUlN0WkJxaTVNb29OSXpQblJ3MzkvMm9Da3YzL1dwM2c5S2NWMWdW?=
 =?utf-8?B?VXNMTk9RUWI2Rko4aUN1TVJSWCthR2dyZ0JtdEd1QXdxV3RuWWlnS2t2Q2d5?=
 =?utf-8?B?UG13QnE1TzAyajRtL1JrWXZTb0xQRXBDdUZGaDFkZ1JBQ2lBcFIrZXNLMG55?=
 =?utf-8?B?MkV0WGp3NUY1NWM0dnFYMndYYmJWdDBRZ2VYSDdnT1Z2QWkvOVczVnc2c1la?=
 =?utf-8?B?Wk44em5RK3d5NlNsUFFqUm9Gb0lReFhJdmxZbDlMN1FZOG1pcXN5NW8yMUtY?=
 =?utf-8?B?U20rZWhDNWc4dk5zK3NKa3FNV3ZqaVFIQU0xMFQrVFE4cFJqQmZqYlJ1eE93?=
 =?utf-8?B?eWE0NUo0alU3bEpZM1R5Y1pTcy9nSDhpZW5SREtvZFlrdllMWkJaMkV0YnFL?=
 =?utf-8?B?Zk1KamhPeFZaS1doRmVOWGcyMEVmVnNRTS8ycWg1eXVaWWxIa0JzS2w1aTNZ?=
 =?utf-8?B?TFFqTExzK3NRVDA2ZzB3bUhFL3pxVXFmZjRtdjZqQnNUOXNkL2dLZEtBPT0=?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce5d0021-fc30-4259-da99-08db2c563940
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3023.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 10:55:04.5543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6038
X-Spam-Status: No, score=1.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I've sent this some time ago, but was not subscribed here, so unsure if 
I didn't get a reply or maybe missed it, so repeating:

I have a linux host with cpu intel core i7 12700h, kernel currently 6.2, 
fedora37.

I have a kvm/qemu/libvirt virtual machine, cpu model set to host, 
machine type q35, uefi with secureboot enabled, smm on.

The kvm_intel module has nested=y set in parameters so nested 
virtualization is enabled on host.

The virtual machine has windows11 pro guest installed.

When I install hyperv/virtualization platform/other similar functions, 
after reboot, the windows does not boot. Namely it reboots three times 
and then goes to recovery.

The only way to fix the problem is disabling nested virtualization or 
vmx cpu feature, or uninstalling hyperv. However I wanted nested 
virtualization to be working.

Any clue what might be going on and how to fix it or even see the problem?

