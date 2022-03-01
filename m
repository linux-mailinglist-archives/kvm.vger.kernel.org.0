Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3181D4C8C4D
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 14:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234931AbiCANMq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 08:12:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiCANMn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 08:12:43 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C682F4BB8D;
        Tue,  1 Mar 2022 05:12:01 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 221BJjm2024485;
        Tue, 1 Mar 2022 13:06:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=XZK6ARsmIkMhnsoTsu26eg7MyReYxVhkJfPzIiJP/xM=;
 b=ibRppqQHs9NST2P8FZ0qdXFlpGPvJsMI1GRKf+rsfmqe+5eBF72ChxaMLG3rRymixxR4
 H3bB4odU2tDhlCJhEZoy7qVJE02eHlfy9eiVuVMDh2ORvyUhm5fTqa/Drm21FeciymOD
 sWVcl3tSCgBK3E8eeo3WBsfAbixhkCwEcyHTVyDYUTN584ch5Qn05RagbAv0CrawjeVx
 puU6pj12tPC7qz5h0iaKIVUouFr64IW526gnxSQo542je+ls1cJ0Z4Ds0rX5NCo/BFI9
 eFZA2Lhe4ATglab/heH5wwND3eDNhQa47HnMjHa53AtUt8BpHE3lQi6x4vTU9WMLao2g Qg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ehbk996tw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 13:06:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 221D1wAi134711;
        Tue, 1 Mar 2022 13:06:41 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by userp3030.oracle.com with ESMTP id 3ef9axag43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 13:06:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gFD6xugtMhlatG7gXYcqk6HSSWlDC1L6RJjTZy72MbQi7fnqEFILI1we0lIWEQaEhFD3U8yNlEH/8TvmWnoN59w/EVYw1mBgsHzCwYwVRda44lcB0sWkQTKTIbBSNjhtmPDUzrROGZXgdfoTVtPZNKOyDGjOUqYayVRcAuBFhpC18e6FVdVhcAIvkTwZs9l/mZRDVL900X9z0RlyThiT00mmJIrTqtgM9DK+JNRrKyaPqVDImosFvOkgxvrjxG0xtpKKJyaph8xw1lr38DCDS5B3XQgCw36hDtHqGQjNRsK24tIWop69vpNLu66/hnEg27COSFQ9wrnVpERooe5Gbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XZK6ARsmIkMhnsoTsu26eg7MyReYxVhkJfPzIiJP/xM=;
 b=XxKUpruUHpct/+YEVRqFSg65JdU/Co+Tju8JYfSex3QsvZoeHUYIbRHTrvV7EUWcmzJeBkHKnwiOM7DxiG41q7+F/09No8xSc6kTTPufyzruz2OxDAIw297rDKaCAf07TRu7vhgKqOhvYECHB21/uGBql7ryH4eijxLjrfJCr6v3XlFWIzaFbvurtkbvwihIxSbMC11XZw4Nc1I7VKJCJKx4GZDFJiEl6y/+skOq2/FZSmD/K55mhxJMu9LM+j9t0CPRx5d42MhT5PI08+EFAVvCRE2vJOa2pWvCpPaunJXr2Pw+AyWZ3UzaJ4lYfcHdB9R8fU/SJjp7k8Z5ClePaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XZK6ARsmIkMhnsoTsu26eg7MyReYxVhkJfPzIiJP/xM=;
 b=ibpUYOgMISNMBFOWfstLsncCjcEbEohccoIlJRv89mg75mUVclIz2VmjIrI3IiZIfpgfq6Qdf/NQuIZDr6r8+xAGT3tL8ZuH0pzYmWxKdBtMat3azUMs7fN6OzFQeWWIYiyzjvygEY+6Zwk+AlB81T2deshLpZqDu5QZ7/PbrvY=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SA2PR10MB4602.namprd10.prod.outlook.com (2603:10b6:806:f8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Tue, 1 Mar
 2022 13:06:38 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%6]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 13:06:38 +0000
Message-ID: <5df75ba7-5c24-6a32-4f47-3d48d217868b@oracle.com>
Date:   Tue, 1 Mar 2022 13:06:30 +0000
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
References: <20220212000117.GS4160@nvidia.com>
 <8338fe24-04ab-130a-1324-ab8f8e14816d@oracle.com>
 <20220214140649.GC4160@nvidia.com>
 <6198d35c-f810-cab1-8b43-2f817de2c1ea@oracle.com>
 <20220215162133.GV4160@nvidia.com>
 <7db79281-e72a-29f8-7192-07b739a63897@oracle.com>
 <20220223010303.GK10061@nvidia.com>
 <e4dba6f8-7f5b-e0d5-8ea8-5588459816f7@oracle.com>
 <20220225204424.GA219866@nvidia.com>
 <30066724-b100-a14e-e3d8-092645298d8a@oracle.com>
 <20220228210132.GT219866@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20220228210132.GT219866@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM8P251CA0005.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::10) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c07435ff-5389-4000-79c0-08d9fb84522a
X-MS-TrafficTypeDiagnostic: SA2PR10MB4602:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB4602D799DA478B559A5A6AF4BB029@SA2PR10MB4602.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xrav/lMp18b29L9Wo6+KOvb3tTwcZBrccMEC986j4wM+qta8bGi5owdUshYbQ2ntTCRSLS13RpqGr2P8puvQR0HaPMgiJLS5FzASPZbDFYrV6YiTTN5uqZZVNxx0hjrQ4ZJ24WT0PqYjnsqrtKFKWd/FSmb66KcEoJckns2e70lEYghRKbpu+MKfBr7tuMAl/1noVEBkX+Xw7g6APTAkFTGJKfH6KyMPD6F1znhCUbwCL17fJhMsIfRAy4NlnZ507av9Giqdn7URr9+XFVQFYcn2BxGUG8Nb09JfsxCuLffD3ZGjfWVHyaClQUhGUGpR7vLsvRi6AHtEGbOpvF6fnyK9OuC2Cj0jyBhTI6oqmx0x0JpaWl/N37LempQE9WjtzTTdbkGs5bLBsAclpvgP6OaVcKvfVwsKfbcPYZaWt6u0IHqdgqlDPwrJLr6Kc7BZxQo2bDZlRzNOxQCPqrx0ski1E+rbT2BR6rL7Ht1Dhs+boLFPlzqtGWu7sUYrPN2R/Sv1O6OGC1+RbIlo1Th2DK4EcVb+dvMZAcNoCaVPQ40wroThAWfJbNRpXuVpiEkNQBHdrbpP+5cTi0tXOmWHcNekYpkjEdPg58IPOrK4DQdo/X094c0UM08ukUVE9m2IJizpUkEsq4YcKuOHMC8fiPjO4Hu0DWjHOMzhs2ntLI9bXO2+eh/N8pLnQL5G1dM4xpifIJIZUThd0kBDH6x04Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(38100700002)(83380400001)(2616005)(186003)(8936002)(36756003)(7416002)(5660300002)(31686004)(2906002)(66946007)(6512007)(6486002)(6506007)(508600001)(53546011)(6916009)(54906003)(316002)(31696002)(86362001)(8676002)(4326008)(66476007)(66556008)(6666004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SEJKZlYrcml1NWdNUStQUVYwVFlkRmNuZ3BHeWtiWlh4LzJMWjNZZnRoczIw?=
 =?utf-8?B?MGNlcENrSFJkdW05MnRNUHhKTkU2RVorUDRSTmdCc2xEZnN0Mk9VS0kzN0RP?=
 =?utf-8?B?dmRIalFVNURPUjFOaUhSd3BPUDBQRm9HYm14MnhvaVFXM2FpUk8wZ242V2hF?=
 =?utf-8?B?bk1aQWJLbGRoQjJ5OVM2QVhTSm56MDNudmZmVXgwelBpcjR4akRQR3FiL3hT?=
 =?utf-8?B?cjFjUTRsMHo3clYzam9GYlJSaUlJdFhJVG5TR25ZZFY2aHNQT1Vpd0xJcUpF?=
 =?utf-8?B?MnBOZENnbmx0RU1VRHU0QlZIdVRxYUY1NlcrbXNMYUFtSVlmbnFKQk1lbHVM?=
 =?utf-8?B?YzNRUVUwRmtRdjI0YTltbWVUeThlMmVIYU55TDdzeWpOZGZpMWZGVHNkL2Vl?=
 =?utf-8?B?bDhtUlNlQ3pUT1NKNlBubzg0VHVPYmwwb09oTHhjL0k1aXNCeGNvNjFhZnMw?=
 =?utf-8?B?dGxmMklQQXYrb3Z0OCtvamx4TUpmRUo1OEVIdUNPWWJYRjVwc0xyc1p6OGp3?=
 =?utf-8?B?ZWVROHh4K2hvb0Jkbkt5VmltYzRDZkVYK2tudVhqMHk2enZLeEptQ2lLSGdS?=
 =?utf-8?B?cFpUUi93TlRmNURRVXhFemNJN2hsWldzUFNhTUVVVXJGS1NjRlRlNEQwbFFp?=
 =?utf-8?B?cW1aWlNSN2lIVHRBenFtMVFyVW5UdFVqNGxndy9kYzVrVHBkeGJIbjJCNVpu?=
 =?utf-8?B?ZWZCL1BTUkhsMDV4TndqOUhrQTIvVFp2N1hHMDN6d091WDhzQ3NDSXNHMWtT?=
 =?utf-8?B?UGZBVGNua2dmL0tMNDFBZ1gvUDY1bDQ1ckZ3YlQ4cCs0YUdZNFl0b0VhME1B?=
 =?utf-8?B?ek52TUVTdDg3R3pkOEhtdkFOVkNxSzZiTGFxc0pvT2NvUEdSN3g4d1RWVWpp?=
 =?utf-8?B?bzlHSCtLWFZ2b0NicDRpZFVpZTNNbUNCSm8zbmNZZmhlWk9lRDU4ektCbFha?=
 =?utf-8?B?ZEE3bm5nUXNEd2pOZ2hOaHVvTmRZM3VzZUlEQlRlOUpGZEU2K1I5MHM4bURy?=
 =?utf-8?B?L3ZPTFNpZUhHeTg3cnJyblpSaGRvRnEzMENxNmg5MG9YRDAvZGoxZVVxaEpV?=
 =?utf-8?B?cHhTejdKNXZobTVaU0U5Um5wSnJsUld6dHd4ZzE5Vi9CUWo0SUJlelg5bFJq?=
 =?utf-8?B?RzAzUGI0eCttNjBSSlJTdUFFZTdDZG5qS2ZKOW1hN0JPWTI4R3BEdVYyL25C?=
 =?utf-8?B?V0wrZ2tKREV4Wkt3czVtd2xKajJZaXRxeXFGdUFGTTk4TU1FUHYycldYMW5a?=
 =?utf-8?B?dGc4RFZZVVMzcC8rMEtuMlc5UmJDZktHK3BrN1dlMXRNY1k2d2tZajRjMGEw?=
 =?utf-8?B?ekRCT3dMcWxROXdsMTl0L3B4dzFtYTdzV2hEN3FNYjNjWjNoc0ZVUlN2U0xE?=
 =?utf-8?B?YmUzc2Uva1VmaEE3aWoyRnJUQmQ4bGdNTXorT0s2MVN5cEJSaFZjUFZSQlZu?=
 =?utf-8?B?V0hxNUI0Q0JLSFpWMTZrb1YycER2ekR5Nm8yN3Z0SkhJdlBYYVFXTGdvNEN1?=
 =?utf-8?B?aVRRY0lyU3NrUDUvb2RHUGI4Q2Y0SU5ZOWFvNkE0b1JFMXg0anYvYVUrbjIw?=
 =?utf-8?B?eTE2TmJjNm9CZ04xd3RwcmZXMHlVUEc3RkQ5NkxKQVJMNHRzK0pEeDRodWJz?=
 =?utf-8?B?cm5GYzR2L3E4RXk1NEVjeWJQMFNMUXBLZzgvaHIyNHJjTG1MQzFxeUJ0RTlV?=
 =?utf-8?B?ZHV0NklTOTNjMGRLSHQ2R3BLYy9oV210K2FiTjFNbzYxcWZRRVRkb2tXY3hn?=
 =?utf-8?B?Z1huTFphSlhheEVmVVpCbDVyTnFXUDI1dWlRdng2aVk1R0xqNVc3YU4wMjdo?=
 =?utf-8?B?eERvbFptUmQ5SGRwRnFpL0UxWGp2N2M4VVNpU2cyZjdaWjZ6UDVkRGFiS2Js?=
 =?utf-8?B?VDlNeGduVFdFbllVNk9UaWVuWE8yT0E2d2hUejdvVFpqNnczV2dFRmV3b29B?=
 =?utf-8?B?blBUMGxrU3JXaG04emoybmF1TXh0cFNRbVVOelhvS01OMnlqRy9wSUE4WGVh?=
 =?utf-8?B?S2JyV3hMSGdZaGc4TnlGUTdTekEwc3BCN01mS1F5ZktKVkZXSEtIWnZWMDFB?=
 =?utf-8?B?UTNqYnRUdi8wUU9FUysveitWYXdSOUhBMERqcHhMd3AxazFoOGE1Y09sNkFa?=
 =?utf-8?B?c2ppend4TUkyV0FTR0pJQUMvSldxU2RvNlA2cVFRQWRvWi90K0dqTVN6NXg3?=
 =?utf-8?B?ekJTVnVVTHp1V3AvZnoxRXpaemVFd25NOS84SysyRkpac2wvYk9IN0N3MGx3?=
 =?utf-8?B?ZWxyaDh6VVNHakliTWF4M0hIYTBnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c07435ff-5389-4000-79c0-08d9fb84522a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 13:06:38.4593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gfal0gTcG1UZw5Vnfbq4cpOB00K8eWc1JN2rd3lJg/gBqm2bqmesNGWXGCSsQ0wrAMYstmy6cvlYj77l25FBySTkNxXx1fTocOFbmAHAL1g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4602
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203010071
X-Proofpoint-GUID: m1G_EiZJnk-_KKYDB71DgwRyRvaORN76
X-Proofpoint-ORIG-GUID: m1G_EiZJnk-_KKYDB71DgwRyRvaORN76
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/28/22 21:01, Jason Gunthorpe wrote:
> On Mon, Feb 28, 2022 at 01:01:39PM +0000, Joao Martins wrote:
>> On 2/25/22 20:44, Jason Gunthorpe wrote:
>>> On Fri, Feb 25, 2022 at 07:18:37PM +0000, Joao Martins wrote:
>>>> On 2/23/22 01:03, Jason Gunthorpe wrote:
>>>>> On Tue, Feb 22, 2022 at 11:55:55AM +0000, Joao Martins wrote:
>>>>>>>> If by conclusion you mean the whole thing to be merged, how can the work be
>>>>>>>> broken up to pieces if we busy-waiting on the new subsystem? Or maybe you meant
>>>>>>>> in terms of direction...
>>>>>>>
>>>>>>> I think go ahead and build it on top of iommufd, start working out the
>>>>>>> API details, etc. I think once the direction is concluded the new APIs
>>>>>>> will go forward.
>>>>>>>
>>>>>> /me nods, will do. Looking at your repository it is looking good.
>>>>>
>>>>> I would like to come with some plan for dirty tracking on iommufd and
>>>>> combine that with a plan for dirty tracking inside the new migration
>>>>> drivers.
>>>>>
>>>> I had a few things going on my end over the past weeks, albeit it is
>>>> getting a bit better now and I will be coming back to this topic. I hope/want
>>>> to give you a more concrete update/feedback over the coming week or two wrt
>>>> to dirty-tracking+iommufd+amd.
>>>>
>>>> So far, I am not particularly concerned that this will affect overall iommufd
>>>> design. The main thing is really lookups to get vendor iopte, upon on what might
>>>> be a iommu_sync_dirty_bitmap(domain, iova, size) API. For toggling
>>>> the tracking,
>>>
>>> I'm not very keen on these multiplexer interfaces. I think you should
>>> just add a new ops to the new iommu_domain_ops 'set_dirty_tracking'
>>> 'read_dirty_bits'
>>>
>>> NULL op means not supported.
>>>
>>> IMHO we don't need a kapi wrapper if only iommufd is going to call the
>>> op.
>>>
>>
>> OK, good point.
>>
>> Even without a kapi wrapper I am still wondering whether the iommu op needs to
>> be something like a generic iommu feature toggling (e.g. .set_feature()), rather
>> than one that sits "hardcoded" as set_dirty(). Unless dirty right now is about
>> the only feature we will change out-of-band in the protection-domain.
>> I guess I can stay with set_ad_tracking/set_dirty_tracking and if should
>> need arise we will expand with a generic .set_feature(dom, IOMMU_DIRTY | IOMMU_ACCESS).
> 
> I just generally dislike multiplexers like this. We are already
> calling through a function pointer struct, why should the driver
> implement another switch/case just to find out which function pointer
> the caller really ment to use? It doesn't make things faster, it
> doesn't make things smaller, it doesn't use less LOC. Why do it?
> 
I concur with you in the above but I don't mean it like a multiplexer.
Rather, mimicking the general nature of feature bits in the protection domain
(or the hw pagetable abstraction). So hypothetically for every bit ... if you
wanted to create yet another op that just flips a bit of the
DTEs/PASID-table/CD it would be an excessive use of callbacks to get
to in the iommu_domain_ops if they all set do the same thing.
Right now it's only Dirty (Access bit I don't see immediate use for it
right now) bits, but could there be more? Perhaps this is something to
think about.

Anyways, I am anyways sticking with plain ops function.

>> Regarding the dirty 'data' that's one that I am wondering about. I called it 'sync'
>> because the sync() doesn't only read, but also "writes" to root pagetable to update
>> the dirty bit (and then IOTLB flush). And that's about what VFIO current interface
>> does (i.e. there's only a GET_BITMAP in the ioctl) and no explicit interface to clear.
> 
> 'read and clear' is what I'd suggest
> 
/me nods


>>>  - What about the unmap and read dirty without races operation that
>>>    vfio has?
>>>
>> I am afraid that might need a new unmap iommu op that reads the dirty bit
>> after clearing the page table entry. It's marshalling the bits from
>> iopte into a bitmap as opposed to some logic added on top. As far as I
>> looked for AMD this isn't difficult to add, (same for Intel) it can
>> *I think* reuse all of the unmap code.
> 
> Ok. It feels necessary to be complete
> 
Yes, I guess it's mandatory if we want to fully implement vfio-compat dirty
tracking IOCTLs, too.

>>> Yes, this is a point that needs some answering. One option is to pass
>>> in the tracking range list from userspace. Another is to query it in
>>> the driver from the currently mapped areas in IOAS.
>>>
>> I sort of like the second given that we de-duplicate info that is already
>> tracked by IOAS -- it would be mostly internal and then it would be a
>> matter of when does this device tracker is set up, and whether we should
>> differentiate tracker "start"/"stop" vs "setup"/"teardown".
> 
> One problem with this is that devices that don't support dynamic
> tracking are stuck in vIOMMU cases where the IOAS will have some tiny
> set of all memory mapped. 
> 
Sorry to be pedantic, when you say 'dynamic tracking' for you it just means
that you have no limitation of ranges and fw/hw can cope with being fed of
'new-ranges' to enable dirty-tracking. Or does it mean something else at
hw level? Like dirty bitmap being pulled out of device memory, and hw keeps
its own state of dirtying and sw 'just' needs to sync the bitmap every scan.
