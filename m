Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAC086A4085
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 12:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjB0LYt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 06:24:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjB0LYr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 06:24:47 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2911E5D1
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 03:24:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cDHvj/OJhjvlf9JpO/t+UnOYMz3NnN96Ym0WJxQYXIL/zadwgR3onGwm3iLcoowBRmqk+UdIMYaE6c6aXG/fxpUrGZZMbsDL+cYb5Pkjbme3Vayaxva7HuDrYd71Oyw0+Dywp9SiPciw1nIyxsVyj/i7XUmjst99TycqP18wTQf/Or7bHGihIe79wbq+MqL1uRvvU2bsOqxHu42tbjcG8mFspj0gJe7MW8PHfu3VVn0V+fp5LXobkx7NjNQxlniCJormtXxWe+fHz7/GVX1S6vjWMPKFfCHgdXFnv/Xgpkx4dYQ8XCrMk4ogWFqtp/aAIF2pb1RAzvK6DPBZlG07tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ob1lTMj72MDc2451QFusINWngynTjbCukPTOjHGs9I8=;
 b=gUQN0USczkHus88yF8+FU4h2KeeFgLK4nPxqdkevVnrWKkxPBnvzrInNhZErxwUQFFBnBcj5Z5u/4/GOqCH4NVBKr42P6LBy10pjku7IyZiFanj/YUZzoRIexsFRLK3JC1NlwXqqFOtMM56DzGwdPk8OszpMYaLlhC7uWuiv1ED6fNvjwWDll/padNsxtT7B3Od8gApn6n7Yq3vNHPheTw41g/SdEFLm1MDCCC0vjbUATXYQR4erTZ0OkGp/bQf+r66Us963W+7MExT2aizcr0D8zZutLvlodAZhkkYRcoBN5sSuB45q0uu8mmoYIL7caIGjwtEQz7xQ2pdI17/D3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ob1lTMj72MDc2451QFusINWngynTjbCukPTOjHGs9I8=;
 b=Mr/usE8hcR0kCsbUKdpECRaiMRqrbttvz2c61Z6qNBIj+RsjPuqz2yNuPM4u57LzivqXENcYqPV2WCCZPj8y0j1QQHvNYJ85t6AW0gUMMgJM4DdwEsOk/B/AH/Vsls45O7gPjGRmZYZ86F4NITQo7k4j7JoItCbKZyWoVBQ254I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 CY5PR12MB6598.namprd12.prod.outlook.com (2603:10b6:930:42::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6134.19; Mon, 27 Feb 2023 11:24:43 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::1185:1d60:8b6e:89d3]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::1185:1d60:8b6e:89d3%7]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 11:24:43 +0000
Message-ID: <d933aca3-03bc-4731-8f36-62bf6cef5ff3@amd.com>
Date:   Mon, 27 Feb 2023 22:24:34 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [bug report] KVM: Don't null dereference ops->destroy
Content-Language: en-US
To:     Dan Carpenter <error27@gmail.com>, aik@ozlabs.ru
Cc:     kvm@vger.kernel.org
References: <Y/yNsYDY9/7v14vG@kili>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <Y/yNsYDY9/7v14vG@kili>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5PR01CA0026.ausprd01.prod.outlook.com
 (2603:10c6:10:1f9::19) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|CY5PR12MB6598:EE_
X-MS-Office365-Filtering-Correlation-Id: dc29d5d7-fab1-414b-e14d-08db18b53922
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MBURC9MTPEbjYzpsZxDi6X95nRKKkkxRv4yXGbxDAR/xI881oUYdQawbLRx2Vgdxx/Q8ry8EcU17XS4/UKwONSsIdXdnKhIbOIZv5jpTONCG5GD2VrVFncTJgKUUmU8g2C4caJaIlvDs/oQJIX+iVR83BVLxNfMmIetVZtHuX1l+mvE/IlZvl2DpvwrlCW2/eWY8+gEwIJ+WtOEIYXUKftA1ZjYxemi05OaZ5f2WPoUUXifVV3AQlOnONimncXD6sxtPhc/6i63UvBLyeHnoN4AZM1ZwVGbeQdTEZiR8L71wve7xRoTS6r55pqhFAcjjeUspd0xKaljFCk2ELkV8BlMaOMJgaYEivoT1mZYZ+7XNTXArLUzRTFMaGedqoMcKhjEoIGKpq/YhqcpUIabhNjdfpaTnKey2eNRE2IMQfrJ/H8X6qBDWPBhxbQ1yQyo2b95+KLjwAJFlgeUa7OkmdgsHxTfn+/Bn9/kXJY5OQf+gtJhRceV7oKbbbOtdmCrySkCL0NR13+P9M06B4tBLQxwPw1TW+GjPYSFUdAVYn33WY6YLeE/49/mYv+/bwuoVHfVuSMInfvflvDoECiAMR9kx9ElxUrPowMhwGtiMi48vVKfo7LHl5NHKIh49pDLTs1jyvUGb8ariAMZ5kJy4Y3IAIgkyjwfhGXSe0i4F6Jy9kWTwCcJvSg6boyOs2N4SU/ADYaKp/iYxHSNwdou9KDBMvTiKxbg8ec+dbE3gNBo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(366004)(396003)(136003)(346002)(451199018)(83380400001)(26005)(316002)(36756003)(6486002)(6512007)(6506007)(6666004)(2616005)(186003)(478600001)(53546011)(8936002)(38100700002)(31686004)(5660300002)(2906002)(31696002)(66556008)(8676002)(41300700001)(66946007)(66476007)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SGRUeDdZOFpwZTgrZGpuQTJGK201czh2VlgycmFzSUsyZnBrUVNKVnJXM2hT?=
 =?utf-8?B?VjVHM0xuQ2UzTDBzWVpjNlFLa1RndnFoU2orUi9xaFBxTW53UnkyemZxZmI1?=
 =?utf-8?B?SVkvVGhGMHgxSFRJVDRmZDdaQTNYYXhRTUw5cDhxRHpOMXk2NXRRQ3JLTGU5?=
 =?utf-8?B?SkRZc1RlcFNFUStTN05Ta3RQQ3NMUnZ4TWdURnZScVpIV3VVQVZmYUhVT2dL?=
 =?utf-8?B?VUNPZEFCYnNlZ0I4UUl3VFIrZ0JxTHBjSlEzVWpDY0ZNOFBaZnBrbHJHcWRw?=
 =?utf-8?B?SENVTHl4c3U2NnJMeHlvZ29JODVWTll5Q3pXQ3FBM0pQZlFaUUhENXFIYmd1?=
 =?utf-8?B?SW80U1BNS0oxbEt4V2ZzOHdmOEdsVlNOL0xKYUlsWlkzUE9xUWhEOURZZU14?=
 =?utf-8?B?TG9IRFQyOWt2VlFYc0pPczNoM0p2MGRtSXhjVHpKTGYzSExVNWdESlZ6MUJy?=
 =?utf-8?B?dGJUVmZuV0hZMEJvYjEzNUFnekhjYWVkYVdHT3lIMjlSK2dRcE1jKy8wVVpS?=
 =?utf-8?B?bm9qZEdZbDJOVWtrcGdVQzFtSWJFWjVBenBwSHgyaVdyWExQYTlkZU9OR2dk?=
 =?utf-8?B?ck1OdEQ2WXBzVWhaUTAxZllLd1lFRzVURDZsNFVlTHdEUjlhR0FTVWJqS2lB?=
 =?utf-8?B?WmQycVYwQ0pnZU9VdTFPS052YS9BdWlsQTA2UjVjM1JMdjBsb0VWdDRHWCs4?=
 =?utf-8?B?R3FDQWZwVXhiTS8raktyZlNuRUhFZzh2Y1Z1S1dPcU14RDR1VEJDRFk2WWda?=
 =?utf-8?B?L3BUYnBUWmJNK3pGWDVER1Y4UHordWI4VVk0eWhvenBQMXFNSG1aSzVlVkVF?=
 =?utf-8?B?czJLNUNPZXgvaDRVSXM3VW04YUxFdEVRUUNQV1k2Y0VoVE1xKys0QVc0elFZ?=
 =?utf-8?B?cFZ5VXdsdjhGOTVOVWQ0Nmljam1CVlNTMWlRbXExYWJmcHgwSjhwQ0FveWtC?=
 =?utf-8?B?ZmRKaVJvNXZGamt6YStrUk03MU1xdEt4Q2Raem93cGdkNUo3STlwckNaSmg0?=
 =?utf-8?B?RHpMQTZRT3hEcXdFSHFkWVRVcEMvendMd2llL3AzL0w2TVQxbGFqaTQ3K2pm?=
 =?utf-8?B?cC9tTCtwcHdrcDJHc0NjaVJ3ak1FN0xHZ3BFcFFSbjI1SVgrUmdLQmNUYzZn?=
 =?utf-8?B?eHI4YVlkZTBFK09hOTkxN0p4b2pmaFlFWVpZRjlOZlZ4aE00eFVnbUFld3p5?=
 =?utf-8?B?dGwwWGNBQ1JuaXhEcE1jYWdIek9oZFExamZDY0VubFhKL0tDdUlmR25jOVFJ?=
 =?utf-8?B?QlpqSDNaaUtCMGV2bU4zVGFCelFiR0J0UnRiVjlOMFdwZXBuZWlvSURNUk1t?=
 =?utf-8?B?QzcvMUl5bVJXNUtta2x5Tld4ZTFpRmdmbnZRY3BVQmdmSzEyS0REcnJpUHhW?=
 =?utf-8?B?THp0eVFROXI5R0FKeVhUUExXWEdJK3k1VDk5dlRCN3VHazhJS01qUzd4STdX?=
 =?utf-8?B?UDRhczVVRTU1aUNXUEE5TU9Rb0dRMFJuMFc0NzhSNjg2OFVTek1VS21jVjEz?=
 =?utf-8?B?QWE3azIvN1JaWWcrNlJzRU0xL2MvTktvNGdXVDVWc3RkNjFaRWQvWE91ajhw?=
 =?utf-8?B?clRXZU0zTSt4K2tHaDd1NDl4cERvMmdwMHVhKysrbVBFcVZ4YzJHeTQyNVN5?=
 =?utf-8?B?a0dYTVorNXM3eno5d0dsbUhZWEVjVXlyOVdPUzVyeEhaT2kwNFRnQjVOTjRL?=
 =?utf-8?B?d3ZQMjY4MWRhVGNKUndqVWlJend5TEJPMHpZVnBKMVlEL29lbnRzdGJldjFr?=
 =?utf-8?B?dzVOQTEvS0JXYnU0TjBiZmhIb3dEbzdwUGhsY1QwalUxMTlHMlU5N1dONDlk?=
 =?utf-8?B?Y0x1UTdTUXlIUk4yY1NuV05pNmtYbzlXSmR4MnJKemNhdzVwSjhJTmh2Yklq?=
 =?utf-8?B?bVo4ZmIrWGtXZ1B2UUFwM3poeXVULzVaVmhON2pDTVZjb0ZDZzJsZ0p3Y2JE?=
 =?utf-8?B?ZmNCcUtFZzYvcnVucm5xTGIyWEEyS2wwZzdHUXEvTjArMXhQWUkvdzBRSWdz?=
 =?utf-8?B?MUNFdWMwdnRRMC9BRXBPMlRjTTRubjdrWUFReTRNMFNtcXE2UkhMb0dnQVAr?=
 =?utf-8?B?bWhnNzl6MSs5bFNOV2VFWk5xNnBoUkViem5IRDJLQytlY1FRS2svcFZjZ0Mw?=
 =?utf-8?Q?LPel9oCQgOr1LUyM0y2tEL7Q0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc29d5d7-fab1-414b-e14d-08db18b53922
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 11:24:43.4478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bvQTt4LpHlNMouBCsWgRplOMfolR4eJz86Swkwde1IH9+SI9HQ3L+PQra3xLu0laNYtmh2TnX1DVaVj9ZQk20Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6598
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/2/23 22:02, Dan Carpenter wrote:
> Hello Alexey Kardashevskiy,
> 
> The patch e8bc24270188: "KVM: Don't null dereference ops->destroy"
> from Jun 1, 2022, leads to the following Smatch static checker
> warning:
> 
> 	arch/x86/kvm/../../../virt/kvm/kvm_main.c:4462 kvm_ioctl_create_device()
> 	warn: 'dev' was already freed.
> 
> arch/x86/kvm/../../../virt/kvm/kvm_main.c
>      4449         if (ops->init)
>      4450                 ops->init(dev);
>      4451
>      4452         kvm_get_kvm(kvm);
>      4453         ret = anon_inode_getfd(ops->name, &kvm_device_fops, dev, O_RDWR | O_CLOEXEC);
>      4454         if (ret < 0) {
>      4455                 kvm_put_kvm_no_destroy(kvm);
>      4456                 mutex_lock(&kvm->lock);
>      4457                 list_del(&dev->vm_node);
>      4458                 if (ops->release)
>      4459                         ops->release(dev);
>                                                ^^^
> The kvm_vfio_release() frees "dev".
> 
> 
>      4460                 mutex_unlock(&kvm->lock);
>      4461                 if (ops->destroy)
> --> 4462                         ops->destroy(dev);
>                                                ^^^
> Use after free.

Nope, only one of these two callbacks is supposed to be defined - either 
destroy() or release() but never both. Has it changed? It is not 
extremely intuitive though. Thanks,


> 
>      4463                 return ret;
>      4464         }
>      4465
>      4466         cd->fd = ret;
>      4467         return 0;
>      4468 }
> 
> regards,
> dan carpenter

-- 
Alexey

