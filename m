Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E024D4D629A
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 14:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348984AbiCKNxH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 08:53:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348976AbiCKNxG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 08:53:06 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4F01C4B3D;
        Fri, 11 Mar 2022 05:52:02 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22BDTA5g008309;
        Fri, 11 Mar 2022 13:51:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=5TnFPFk+Fu0RsokePgRwyIAazP1IVxZFSs1puHEbDOs=;
 b=Gzk3SsABo7ca5bXDAcL8e7cZgdbieUAghQ6OtEaqbqJJteMUwyQEw8VWgpeLB1IKvASn
 889TDAdx+uOJy1imQ4+iFo4Msu8Fyr2TCLMJK2zMKSAWhuRZDLL1UpWrQCqYskhN0qfJ
 /CST3+2uO1DitdmFBfilYOqkL/HVHx+EYhFCXCGAcxvazSjJ8TNq9nfZH2gcP/ShfHYX
 mV91pZsoLGeAwssfiMtHHZc/+Wj5meAjEClj3aE0vSQdOUugU9Y1LBURWiXh//RrsD8A
 qPo1TYfhOuImfNZjtkLSTBedVYkmATZfq5FcXSNJQeyZ0bkoGFPHgTPAx5VOkA30ZNR2 CQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekx9crms1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 13:51:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22BDlCt2136635;
        Fri, 11 Mar 2022 13:51:42 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2046.outbound.protection.outlook.com [104.47.57.46])
        by userp3020.oracle.com with ESMTP id 3envvp5v0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 13:51:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kk+ySanPQjlaeMyIRa9Fl8OHzUHBFC/2OtpAp0j/HSrclFlKMAjRpm+XAm31UUewT5znI05iyAyGcbLIeD6clR2ffGjqPhMXyNenc57tEdvjO01sUenaJyvJ6Lzxu8yPuWqlmQEQ0UOpYO4d0fK1OH+r18OXiwrpE/mxlPQ9Va1Si1nXxmsNQWBmiGoXLlIc7WZKvLYekyrxh7tMyGUC2dx/1SZ/6EcLzX25pKRJqaOOuiiSTFGbB6fXjBQH6069NtkcfjWKnU7bk8OQAQpsZTyxUiZVkE1pu8inW/oRlw3fAufXpcKhAuQixrGOAtuMzcSzGIyaCqBKlfymu1noHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5TnFPFk+Fu0RsokePgRwyIAazP1IVxZFSs1puHEbDOs=;
 b=UprjKQ4G3q8fgKYEqRiAQqWV7X8O/ntfoZTftR/kC0GbCirHw62/gG8J8xb34dS8/lElwLDFczsI6wdyKedKAFRDjfiCmQaHhZ6vOzv3I38gC03oHUJ7h68xI1S49WkvBAR4Jzi5/vAuiRpwnGSUKK6P3/k045+YRy+tftNqCMuRTTYODhQkIeZtzZRovuH/hyratGlxr1IPvRFsh5NLi2C1Gp6mb55HxLGeJb/FLohkV9YdpCfaDXHiM0agv3T3UtTuQq9SoIjHPEQUL7Fvq2Uwzuk0JGK0eT22U4eFVDJ33Ub4KkY4v50Nw0dG232iZhI87mjbhssWAq7DW3d/Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5TnFPFk+Fu0RsokePgRwyIAazP1IVxZFSs1puHEbDOs=;
 b=pkd9Zpy00Ca8yHYGgkafPwxcnUYImkT1gzp6DQNjoi6aBgyUZvTySZ/emhofVfiXaKZHiOZNTQUx5Z/xwgN3qXkwGBi0Cy6Bfcg2z7x0AxHaR9QP7U3p5S0jLDt81N/k6xSGja7hSizQeg2RkYejFTTGZEphlzlkLYhD6y/EeZQ=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MWHPR1001MB2301.namprd10.prod.outlook.com (2603:10b6:301:2d::38) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Fri, 11 Mar
 2022 13:51:40 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5cee:6897:b292:12d0]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5cee:6897:b292:12d0%6]) with mapi id 15.20.5061.022; Fri, 11 Mar 2022
 13:51:40 +0000
Message-ID: <8448d7fb-3808-c4e8-66cf-4a3184c24ec0@oracle.com>
Date:   Fri, 11 Mar 2022 13:51:32 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
Subject: iommufd(+vfio-compat) dirty tracking (Was: Re: [RFC v2 0/4]
 vfio/hisilicon: add acc live migration driver)
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
References: <20220211174933.GQ4160@nvidia.com>
 <34ac016b-000f-d6d6-acf1-f39ca1ca9c54@oracle.com>
 <20220212000117.GS4160@nvidia.com>
 <8338fe24-04ab-130a-1324-ab8f8e14816d@oracle.com>
 <20220214140649.GC4160@nvidia.com>
 <6198d35c-f810-cab1-8b43-2f817de2c1ea@oracle.com>
 <20220215162133.GV4160@nvidia.com>
 <7db79281-e72a-29f8-7192-07b739a63897@oracle.com>
 <20220223010303.GK10061@nvidia.com>
 <e4dba6f8-7f5b-e0d5-8ea8-5588459816f7@oracle.com>
 <20220225204424.GA219866@nvidia.com>
 <30066724-b100-a14e-e3d8-092645298d8a@oracle.com>
Content-Language: en-US
In-Reply-To: <30066724-b100-a14e-e3d8-092645298d8a@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR0P264CA0151.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1b::19) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65e94017-4916-42e4-c486-08da036644a4
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2301:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1001MB230167DB2A7CFDB7E190EEF3BB0C9@MWHPR1001MB2301.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /9WZQ8sIwdH3v210oOWfEY80vKGmE2z2b6uI5zIefDyvDt1KQCOBLtsUsjQSWLlRGyUfXv9v8HCTjp56dL+KCFciRjFGEzWtw1RL2Vh3zD4pPxNysnL19OrnxMN0s9xM9PT4ZvxshQz5JT1NDni2fU8Jlhi17Pg2o8ujSsYDjXLDZcMXUApBrir5nJZTyp/AMKNQFq98ggJ4dGbIhiVFmk34aNDd/kTbtyBYAT29EZoA6XAF8cb/2xOwOBArR0egCASNBYsgyQDTqdonRYxBpGVMZAqm82iBfFMbYOP8pLAi83V2hKY8msLS5u/VbEI0Hm9DCHwCIXoF3MoHwvb2DF82aBYBV3PrclamxnNynCUEyiDSLGI5x/Ivo16JZFaa666G7q3ncQYlJJXKh8iErAe02SYjUXRDWgWcL0T5EoHGbcE3sptfQXJC/5u3Tht4wiPiAJ4+QezuYZev6lCb/Rji4KBrmPxCJHTRMqm/z0MYsDazHBpexcmeQ/UP3b42XgfNxMae1om3cWlErzwwTKehwxfQuN2Hx3v6eL6aY1N4GjfkBmlVVUPII+KrFyYi7XoAWW7CBYufgmoTN63KMV7jpuu7Gdp4VinpkI9q2ggvqyvuvFsSFuih/oVpSFYY8AubgzqZgh8qhGwLU4WtRk/hoOES0u8Pl8Jg3l35BU7xNzkD6DJIm8VOaJcbb8PetX6495AwGOAkP8Eh0mi69+XI7zAsz/HApnOSJjPHConk5cNm163enJGdBeynMF0J3dd2BZnwkyCOY4na0FzkxlKN7a1jPMTQg3PIHzPNfKmVQ6Qkia60ST8mZwGwAIQw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(31696002)(36756003)(966005)(6916009)(54906003)(38100700002)(6486002)(6666004)(6512007)(83380400001)(31686004)(8676002)(66556008)(66476007)(4326008)(86362001)(508600001)(316002)(5660300002)(8936002)(7416002)(26005)(186003)(2906002)(53546011)(6506007)(2616005)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cEZMTDlIVTVmeDN3NHpXZC9GM2dzbzRDMVlmK1FSYXE3dDBzblFlbDZnWC9T?=
 =?utf-8?B?cEpKOGFwVHRaanIrcWIxTktOVElYeUE5ZlJvRmVNMTJqdkNYUk5oNW1ySUdB?=
 =?utf-8?B?Z09HWTlpNDh0Z2RhUEs5NyttcDJKR2MrM255V01sVXNYV0FXVmkxeUMvbEw0?=
 =?utf-8?B?SkhWeCt1cm9pRXE3WmUrVnJHY2xPcHpkcWNEMWhKMjlCUWhLd0xkZkVxdFNL?=
 =?utf-8?B?b3N6dmdMejhrbFJFT0VJaU9NRHpjQTZxVjFHT2ZWUy80and4MzFYUHV4OGV5?=
 =?utf-8?B?S1FnMXBhQml0dUFwNFFzUUlhVGhaa3V1MmN6MTZoVHBBV2dFZ281ZjZNSzBI?=
 =?utf-8?B?SFFab054SlcwNlhVaUdtUVJiRnZHNllXQTFxRXhxN1pja2ZOM01xMkxKSXBP?=
 =?utf-8?B?RXlzZDVEZzZsYVV2VDEvZWJIeHkyTjV2T1BiMmltNVVEbExYUE02M0tKUHk4?=
 =?utf-8?B?WTRZU0xQZkp2SWp0LzBpSDltM1dwbnI3SFVEWS9HYzQ3SGJ1UEdqWWxtUXB0?=
 =?utf-8?B?OS9wNFIwcXRiUVFlSWZXS054bFV2Mkh0RWNiRDQvMWRyc2xUU0FvYUV5MUx4?=
 =?utf-8?B?OGlnYUZkczY0RFQwN1M3dGEweWFoRkhrSDZDRmhXQ01RMTVNL2krOThFbjRz?=
 =?utf-8?B?MmVGdVpGVm5rZjlUZHZ3T3VLNlZ3NGJSekJYWjNmZk8yWEx3cHVPTFJDbWFx?=
 =?utf-8?B?R1FJcE02cUxTUWkvMi9XeVpaUXY1R1RlN0szd29mTkpXZUVrR1RwZUYxbEdj?=
 =?utf-8?B?a1BZRTg4RmhwNmI4cWdINEhObEpONldkaG9MaVdYV0EwODRBa0JVQUI0bFJO?=
 =?utf-8?B?NDkxZ2pydStPTHVtZndKK2NtZXpqKzFzc3M1WDAzQ2dWWFgyMjhEQi9US1FF?=
 =?utf-8?B?UEtXTFViM3Y5SUxRL0JCcWRKcG44K2RXSlFVZkVJSllPUVdyZ1ptcmlTSmRm?=
 =?utf-8?B?QjY0QXB2UVRGNXlHaDdiWW8zVHg2ZmJPSTJBd2U4NDZTRDFZbWdqUDgvOHha?=
 =?utf-8?B?eFQxdmdRNDhXb1ZLVTFCRTIyYUdDRUpPTHNsSExsdk1odWhHSURNUnAxUDNa?=
 =?utf-8?B?Z0NHWkd2ZTV5NU1VWEdROG5yQWV4UUgzL1p0NDNoUXdqR25VL2ZOZ3E2eE1p?=
 =?utf-8?B?eTdPOExJQi80YWt3d1p3TXMxaWlqMS9xRFFtQWZ5Umx1Y3VOV3hVSWtoR1Vw?=
 =?utf-8?B?eEkwdmEvVS8wUnNudms0RVdOMU1nNHRjbjFWZ3d3b1diM3oxYjJneGFTMVZ0?=
 =?utf-8?B?TFh4U2QyRFJYWkgrdFFENHBhOFVCUmMzOUtpaUlmcEhVTVNvWnVuTUxyM2t3?=
 =?utf-8?B?M0NTV1lvaVc5WDZLY1VQNkttank0UTIwM01sZHRnR3RWSVRyN280b2tuZVho?=
 =?utf-8?B?a2FnM0dtZUpyMDlBNEFXOWNZc2VycnNqK29OZFV5SDNhc25yRDZNRGJZSW1G?=
 =?utf-8?B?Sk41eGFsaTFraDBqSkFxbWZ1d2hzV3JFMU5FZkplUTdKdCtQOEZoNzJoTFk2?=
 =?utf-8?B?UDdhUC92QUVrWk9wb0owbW5FdC9UbFlMK3diSFlyTnMvZUM0UGlIU1FHOFN0?=
 =?utf-8?B?NVFQaEdjalptZFI2Vm9PeTcyeE8veXA2SXBMYkE0bzRDN1RleWZobDJna2R1?=
 =?utf-8?B?WGlvamYxTGMxeE41c3F3dFB6anRkSHBkR0ppZnVuQ2FobWh3MjltdDVtdzgz?=
 =?utf-8?B?UlZwaitnNkYra0hzZ0RYcHlKcnZXbzBkcEpZVmQvV2pacG0wNVpLYWF1ZDlR?=
 =?utf-8?B?M2VLQm9ONWVIK2RvaWJsaHR2c1c0VUFyWGZMTlJxMjBNNG9WV3RKSk1wRVh0?=
 =?utf-8?B?alJySzh4NU83dXBHaDVCWUltaWpMMEVGTTdEOVlSdHhvQUxjdVJnQmh0Y1R2?=
 =?utf-8?B?bTZFRVJZZFk2djhmRC9zTmtNL01SUXJ3TW9DM1VQV3pWSlJOTnJYRUh5UTNw?=
 =?utf-8?B?OVoyMmFIQTFCSWY1eE1JY2g0T3ZPNzc1Qi93WGYvWUtLTFpmZ3B1ODVOZ3Uy?=
 =?utf-8?B?d2JOSGJFY3JRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65e94017-4916-42e4-c486-08da036644a4
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 13:51:40.2354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y8c/Epj0orICZcHL/R/coWWIm7VgZwa4UfF+fFH+Gi6cxaprAfEAeK2XyHfb6Cnqa/3qRDqzuL5xRDRKrIiqDHw1ZO4FK+3+blobBp/K5uw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2301
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10282 signatures=692556
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203110067
X-Proofpoint-ORIG-GUID: rzdhJyRe4J4UE5jUs9p1nWPWYh5DwVsi
X-Proofpoint-GUID: rzdhJyRe4J4UE5jUs9p1nWPWYh5DwVsi
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/28/22 13:01, Joao Martins wrote:
> On 2/25/22 20:44, Jason Gunthorpe wrote:
>> On Fri, Feb 25, 2022 at 07:18:37PM +0000, Joao Martins wrote:
>>> On 2/23/22 01:03, Jason Gunthorpe wrote:
>>>> On Tue, Feb 22, 2022 at 11:55:55AM +0000, Joao Martins wrote:
>>> I'll be simplifying the interface in the other type1 series I had and making it
>>> a simple iommu_set_feature(domain, flag, value) behind an ioctl for iommufd that can
>>> enable/disable over a domain. Perhaps same trick could be expanded to other
>>> features to have a bit more control on what userspace is allowed to use. I think
>>> this just needs to set/clear a feature bit in the domain, for VFIO or userspace
>>> to have full control during the different stages of migration of dirty tracking.
>>> In all of the IOMMU implementations/manuals I read it means setting a protection
>>> domain descriptor flag: AMD is a 2-bit field in the DTE, on Intel likewise but on
>>> the PASID table only for scalable-mode PTEs, on SMMUv3.2 there's an equivalent
>>> (albeit past work had also it always-on).
>>>
>>> Provided the iommufd does /separately/ more finer granularity on what we can
>>> do with page tables. Thus the VMM can demote/promote the ioptes to a lower page size
>>> at will as separate operations, before and after migration respectivally. That logic
>>> would probably be better to be in separate iommufd ioctls(), as that it's going to be
>>> expensive.
>>
>> This all sounds right to me
>>
>> Questions I have:
>>  - Do we need ranges for some reason? You mentioned ARM SMMU wants
>>    ranges? how/what/why?
>>
> Ignore that. I got mislead by the implementation and when I read the SDM
> I realized that the implementation was doing the same thing I was doing
> i.e. enabling dirty-bit in the protection domain at start rather than
> dynamic toggling. So ARM is similar to Intel/AMD in which you set CD.HD
> bit in the context descriptor to enable dirty bits or the STE.S2HD in the
> stream table entry for the stage2 equivalent. Nothing here is per-range
> basis. And the ranges was only used by the implementation for the eager
> splitting/merging of IO page table levels.
> 
>>  - What about the unmap and read dirty without races operation that
>>    vfio has?
>>
> I am afraid that might need a new unmap iommu op that reads the dirty bit
> after clearing the page table entry. It's marshalling the bits from
> iopte into a bitmap as opposed to some logic added on top. As far as I
> looked for AMD this isn't difficult to add, (same for Intel) it can
> *I think* reuse all of the unmap code.
> 

OK, made some progress.

It's a WIP (here be dragons!) and still missing things e.g. iommufd selftests,
revising locking, bugs, and more -- works with my emulated qemu patches which
is a good sign. But hopefully starts some sort of skeleton of what we were
talking about in the above thread.

The bigger TODO, though is the equivalent UAPI for IOMMUFD; I started with
the vfio-compat one as it was easier provided there's existing userspace to work
with (Qemu). To be fair the API is not that "far" from what would be IOMMUFD onto
steering the dirty tracking, read-clear the dirty bits, unmap and get dirty. But
as we discussed earlier, the one gap of VFIO dirty API is that it lacks controls
for upgrading/downgrading area/IOPTE sizes which is where IOMMUFD would most
likely shine. When that latter part is done we can probably adopt an eager-split
approach inside vfio-compat.

Additionally I also sort of want to skeleton ARM and Intel to see how it looks.
Some of the commits made notes of some of research I made, so *I think* the APIs
introduced capture h/w semantics for all the three IOMMUs supporting dirty
tracking.

I am storing my dirty-tracking bits here:

	https://github.com/jpemartins/linux	iommufd

It's a version of it rebased on top of your iommufd branch.
