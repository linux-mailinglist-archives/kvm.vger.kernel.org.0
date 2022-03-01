Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A34B4C8DB2
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 15:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbiCAO3g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 09:29:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbiCAO3e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 09:29:34 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 552F47B55B;
        Tue,  1 Mar 2022 06:28:53 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 221ECsCX027258;
        Tue, 1 Mar 2022 14:27:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ypJmsvl/BWWcP1Xp+afpx/MSwLgeotDsUG/WjtR6gdU=;
 b=TYS4kvRWF9DgH8PbbCb2goc2AtEum1uwaCoLwjsJ3znHPHB7VTLrjbeO6bvaWjc1ziXt
 ImFcmVFOXA0HoUaHN1peDEq3IUK4wxuiGVbdpeRRBoDo1+L/6Pi1XpJiGHr8QJFccdPv
 lPnRw0nmVsBb16u3bgbiGo5PAtRKrsD7upz0yoKocobS6/Ai1RV2TbFBoqkOaqtdxQ/Z
 O41CAaBG1VCIqqBkxoRaAo0fgUFQU6rtAJs+Cdp+y61rVMT3BulMKsQ56hGznwO1vAiq
 LCX9IsQgarAPwfKTrdvD8KVY6nKPzrK4xS27jEc8SeGTfxVGLC3QD8UHOnF4GNfv08KA TA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh15aju4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 14:27:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 221EFxIC102412;
        Tue, 1 Mar 2022 14:27:39 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by userp3030.oracle.com with ESMTP id 3ef9axffd1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 14:27:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TsuARLHGrPry1AEtC/96Qv/iaqlm/gZ5iviwF23Kt3cM8zyY3RFxKL3E1okQNo9FqyhPUj5tUy4rm/zlZthF6o8RSTFDKDGuDbRO/It8Vqll++2S8JZIoNQ2mGjan4V7Nj/b6mzovZlLP/xKwf32HlEFnUUGb9cSOptqNZsFa8iEKPwLrWaWe7Z4ieIUUFPVFszty83fS/4UF57tQ9Rmqel+1aisZNlbM0QmGQNx++rewGEAfnCaA6YddZMl7JPFeLTn3FpW9q+Ened+HnOQHk6URE8St+trkKcsN8JwhercAFXl+QoLA9XGlmQd+1+Ybr+ZVUrV5vAO07zOPGTIdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ypJmsvl/BWWcP1Xp+afpx/MSwLgeotDsUG/WjtR6gdU=;
 b=fBkPWc2VbMUyqpkpd4fu6gAhPM3rySkdhhMNtR3f9qHV46M29Dqw9+y5Bgdfw54RNPw4gKrL/dRt+uf8WyE+V3wnhjgwLL+COzPRJC00Fn3WmcqZrVZRiyndEk0IZbtoQ/Qy23PPfz5jWFSjgKkPFI1E1gGZfuIleijtBFsn2ZS9bkVzMO49MyXh2bnyE1YlYdLpitsBqwtTXprsDxS5EVeI4GKdq1ZsopXYb1m5csxPDDpLqPzqkfnBp/k1sREbUOQLK7tbMpnYYLctkKn7IuNQHSYiV0dN+G9cRSq8QiaIisn+fpqITO4VAXgjITGAP4uEAdnj+I0BxcqdpKU3DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ypJmsvl/BWWcP1Xp+afpx/MSwLgeotDsUG/WjtR6gdU=;
 b=ba5hoUsnpJE7a19ckEDmtultUHIwoqjkXc0zEl3Vtwy6cfslqUeII8JUqDyEg/25wCEAocdRU1OSOSemlr3HkUKloBrh/7zwMdgUoMEZ6gjOwPpjylsF+bDyAxQhL853RZqkHANXe48r1f84Ru7qTS8jpIJkDtnwN5AfAAJA6nY=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BN8PR10MB4082.namprd10.prod.outlook.com (2603:10b6:408:af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Tue, 1 Mar
 2022 14:27:36 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%6]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 14:27:36 +0000
Message-ID: <78ee17b6-36fe-8585-2edb-1b708effe2fd@oracle.com>
Date:   Tue, 1 Mar 2022 14:27:27 +0000
Subject: Re: [RFC v2 0/4] vfio/hisilicon: add acc live migration driver
Content-Language: en-US
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
References: <20220214140649.GC4160@nvidia.com>
 <6198d35c-f810-cab1-8b43-2f817de2c1ea@oracle.com>
 <20220215162133.GV4160@nvidia.com>
 <7db79281-e72a-29f8-7192-07b739a63897@oracle.com>
 <20220223010303.GK10061@nvidia.com>
 <e4dba6f8-7f5b-e0d5-8ea8-5588459816f7@oracle.com>
 <20220225204424.GA219866@nvidia.com>
 <30066724-b100-a14e-e3d8-092645298d8a@oracle.com>
 <20220228210132.GT219866@nvidia.com>
 <5df75ba7-5c24-6a32-4f47-3d48d217868b@oracle.com>
 <20220301135441.GX219866@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20220301135441.GX219866@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0485.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::22) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 558b051d-7ef1-47b9-b7e8-08d9fb8fa18c
X-MS-TrafficTypeDiagnostic: BN8PR10MB4082:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB40822F4D4AF54F7F0D66E808BB029@BN8PR10MB4082.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ocRyDrep3lv5zWfVMtqPSjFEzE5ESgq88Ung3Xb/+9mvqjOpVHQL4plSfujNK8zeYhbdXWwk5P8nmRHwHloz6WHlwwkzodLSypWg9LGfRzOgYHfJ0iHB5p96DPM/R979LCcgCV0YKMU2I+SaE/hv/6sVrwO2NEXvb0j/mGbACn6BBf+qocjiHRVEt9AU2JnPoONw9+pbRr4rtatSx3L5CN4KvEiIwyX11455Q4Cqlgs80B1zCApyc8FCCbJ7L3YtyNXb0eC5SFil9ciiQHoItfyJE4HLK6pjIkbeMnYrViLnusAZy8fQGBFeMQicnSr9Wcc1GxjvznOy2vjWUsmztYsBRphYW7hJLpToRyUOkGlMkgzMevqMM8LXn9mikOiShXTyRD/ZTZua5WpzNbMDmoFa2uZuvyP7ZWhaYN0c9+afQZy1TFoqwEp1qtwG8D70D8d0QEK5pjhehxvx+jM7N2X4axnMaZR2+WHlBlmxmduvXcij82AQw4yneGmGfNiXU5V3Zk3eyPB8Xo8l0MsxngIg7IW5BduR/CO7FwDmZuCUt6l4jNfmSvvybfYgtGQ25mz8ZheL9CWKB6Kjyt37a7DnsTCU7a/kYudR3VTrIowdS6aHAPKrQ6PxgsXxqHkpgVhg9DUS3DH6h4vfgr/N4nB6oiJ3Ll/WVbQzZobW8LtPxcWh85X+oTEIwX6mMrMtt1ddj7DoCx8n7vFsLvzRow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7416002)(53546011)(38100700002)(2616005)(6506007)(6666004)(2906002)(86362001)(31696002)(6512007)(83380400001)(4326008)(316002)(8676002)(66556008)(66476007)(66946007)(6916009)(54906003)(5660300002)(186003)(26005)(8936002)(508600001)(6486002)(36756003)(31686004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q0R5cFNmWS9qQzZ0YkE0enIxcUNPN1lpazA3bk8zaDNRVmFsSVFKMXNjRitO?=
 =?utf-8?B?ckhZVjE3N1l0TTFmNkRnMHBoeUdWMGZqVjZkRzNKdHZobnpHNjU2QWphMVpL?=
 =?utf-8?B?dWgxbFFFOXEvUGNZZnFmQ015OUZJcUtEbVlFSDhZSDBsSWptY3BPQVBQem80?=
 =?utf-8?B?VU56ZCtBbU0wczF0NmV5c3BPL2hRTlZaVkZXZkpkemV4Q0dNQ01GYm1JbTIx?=
 =?utf-8?B?TEJ3WGxuZDVzYnRtbTBoZy9Zam5mOTlRczJqRGZBNkJDYnV0QkRNWUdWdU1o?=
 =?utf-8?B?R0gwY3h2N2E1aEdvUFdueGhydzJ6cU5uS29ERWJ1LzlFZzRidlpRcHc1MzVP?=
 =?utf-8?B?bU8wQjV1cmxKcG9EOWl4WFRZVVVBSHM1RGhPQVVDNlhuUFVZNVVLdm4zVWxx?=
 =?utf-8?B?VTFmSjdGRnY4eXVnZmxJZy9TSkJTMGM0dlZFMDBrR2drRmcrcExSSUpKckhn?=
 =?utf-8?B?b2pBVnFwNThvN1crcURIeDNtZ25ZanJ2aEcvUmdQTE9ha1JHbjc1aGdhSFdM?=
 =?utf-8?B?d3RDaTJQR1ZSSnlaSnNQS0o1cG9MT0RoaTF2WWxhNXNyZ0tNZEZFaU5qQnEv?=
 =?utf-8?B?QVhGNG5KWWZPdkRsbXR3djJSU0l6cjJmK3IxZU1hSXdrZ1BYYi85R2VJc05R?=
 =?utf-8?B?eVl0UGlhcWFEaml0YmFmN0Q0Q21kK3FPZFBoUk1FMXN4bUFwWmlERy9OUVdC?=
 =?utf-8?B?cXBiZk9MRTh3ZnR0RFpqcS9QaG1oT09LcGFFRnVoNENLQUV5dVRXeUl6M1BS?=
 =?utf-8?B?Yjd1anNEMVpNb0czK1pyc2hTSDV4aWhsL0pMRkw0YWZFbzBzRmVTN0EyTGJG?=
 =?utf-8?B?aG5DQVEwWitUdjVLSEJ5OTUyaVlFUEE5L0h2eU5xZDRlNi9NaExrRE9EODY5?=
 =?utf-8?B?c2x3Uy9kMWo2NStqRFBYL3dmVkVadk9ZdzFNN1VqY0Z3TDJMOEZKR1U1OUdV?=
 =?utf-8?B?cktLMnlsNU5TSEU4UmlhNlc3Smcwb3F2Mk00QjRPelBuZ3Azc0toNGpSYWFQ?=
 =?utf-8?B?ODJodEF6cHVFdnBJdG5PS3RXb2VSczNNUy9ubStrWHFrWVJOeFlLTzh0R3dT?=
 =?utf-8?B?NWdGOTBmOTZUcnVwUW5zTi9aZTI5ZmEzOHBEVUd4ODA2U2V1NkZsc2Z4cHdn?=
 =?utf-8?B?TS9rNjBLUnRzK1orYkMyRnVnSDhBTzkyWlZKYzJJZXQ1RWd4TElsTnVZTmtw?=
 =?utf-8?B?aFJUSnBqVzJpNGJ1Z3EyWnlnT0Z3WWJ6UkpKcTBWeitvMU00enhxK2lyejNp?=
 =?utf-8?B?cC9YRDFEUzN0NkZDblJnUmFiZm9jUi80Z1pGKzExVlF2aUdyOEdjanVtOTc5?=
 =?utf-8?B?YlVIejA2cHIvWDNFbW1IMmlZRjVmQ0pGWHptc3oxeDR1OGFlQnRSMWFaV09w?=
 =?utf-8?B?YkhhVHMwRS8rMFFhanV5T2FHMzhLZTJXNjdaUnkyM3BCYjJtMkxDcXYrRWhE?=
 =?utf-8?B?MnE0TXQ2Vis5VTcydzczMjBHZjdUZi9JM2lJUTFEbjE2L0hvV0x2Z0lCRlh4?=
 =?utf-8?B?MGlmSEExMTh0REdIcDZDbEx1VkNpTnNNWFlvUXRuTXc3ak9wOC9zVWo3cmgv?=
 =?utf-8?B?T1hlbFBwRTJTaHZlUU8yS1ViRUc4UGhsYVZHVFM0b2N5Ky9Lck5HYUVML0kx?=
 =?utf-8?B?b2xBNTgvTE03TjZVY09CeU5sQzcyaThRbkgxUTN2aHRUVGRoZVViNGhoK2FM?=
 =?utf-8?B?cGxKaUVRK09FZHQzaUpWVGFYazFUeG42VEZoV01KS1A0K0czNHNraUEvSUJ3?=
 =?utf-8?B?MlBldXpFMkZ3cDBpblFvYXNWTnNJTDR1TFdVcjdMQTE2Q2h6bUdsUCtzTDFX?=
 =?utf-8?B?eDE1UDhHSjRvTHRRZ3piUmN3alNlTS9HajNPWFhFN0k2QWZMTEp1NzA4Ymtw?=
 =?utf-8?B?VGE4RTM4ZHE1K3Q1YmI0bHBldXhzaEwydkcrc1h5OWlKS2RwOGNUenRKQ04v?=
 =?utf-8?B?VWhkUHgzS29zTGZqbVJQa1p1V2NMV3RtOUwvNXlGVGttWmpOZFpZd1QyK0xm?=
 =?utf-8?B?di9tc0JtMWZ6ZEFvZmRTRUN3ZThkOTJEaGgzWDFyNGRxVDRiTXlLUWZPbmdv?=
 =?utf-8?B?VHBaQTZmcWlXV0FySllkd2N6QU9DT1RVQlF0dzduc1c2LzRHQURONE5vZS8r?=
 =?utf-8?B?YXlpQkFvMUZCcWhtTkV1RXdQcjhyYnBMS1JhaGlqbTZ1ZitKcUJHU3NMb2Rz?=
 =?utf-8?B?dUpkeFg0QkxBTXBWRkoyblhlV0NsREthTlcxV1JFNkozN2Z2dERZZUxqeXhB?=
 =?utf-8?B?QVpKcDhhQzVSaVdpQk5tSDI3Wkx3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 558b051d-7ef1-47b9-b7e8-08d9fb8fa18c
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 14:27:36.2154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P5mz8SYQDfA791S9Mp0uhOsQuJnBVngH88BqXtRzAbZfAs1oN75LWqIv6Tmh1xt61jnHh4PeXo/yF4zTcNYsbXAgpbNv/X9PVb7/h8tYqyY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB4082
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=733
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203010079
X-Proofpoint-ORIG-GUID: Q299-2eMasWnIUvochdq64rPZ-uTmta-
X-Proofpoint-GUID: Q299-2eMasWnIUvochdq64rPZ-uTmta-
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/1/22 13:54, Jason Gunthorpe wrote:
> On Tue, Mar 01, 2022 at 01:06:30PM +0000, Joao Martins wrote:
> 
>> I concur with you in the above but I don't mean it like a multiplexer.
>> Rather, mimicking the general nature of feature bits in the protection domain
>> (or the hw pagetable abstraction). So hypothetically for every bit ... if you
>> wanted to create yet another op that just flips a bit of the
>> DTEs/PASID-table/CD it would be an excessive use of callbacks to get
>> to in the iommu_domain_ops if they all set do the same thing.
>> Right now it's only Dirty (Access bit I don't see immediate use for it
>> right now) bits, but could there be more? Perhaps this is something to
>> think about.
> 
> Not sure it matters :)
> 
Hehe, most likely it doesn't :)

>>> One problem with this is that devices that don't support dynamic
>>> tracking are stuck in vIOMMU cases where the IOAS will have some tiny
>>> set of all memory mapped. 
>>>
>> Sorry to be pedantic, when you say 'dynamic tracking' for you it just means
>> that you have no limitation of ranges and fw/hw can cope with being fed of
>> 'new-ranges' to enable dirty-tracking. 
> 
> Yes, the ranges can change once the tracking starts, like the normal
> IOMMU can do
> 
> We are looking at devices where the HW can track a range at the start
> of tracking and that range cannot change over time.
> 
> So, we need to track the whole guest memory and some extra for memory
> hot plug, not just the currently viommu mapped things.

I'm aware of the guest memmap accounting foo, so I was already factoring
that in the equation. I was just mainly grokking at hardware limitations
you are coming from to be captured in these future VFIO extensions.

Tracking the max possible GPA (as you hinted earlier) could solve the two natures
of write-tracking, also given that the IOMMU ultimately protects what's really
allowed to be DMA-written to. Unless such tracking-bitmap is placed on device
memory, where space probably needs to be more carefully managed.

Anyways, thanks for the insights!
