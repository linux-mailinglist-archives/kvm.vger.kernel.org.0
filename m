Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8514A787C
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 20:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346860AbiBBTFc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 14:05:32 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:50646 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230380AbiBBTFa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Feb 2022 14:05:30 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 212IocFA022466;
        Wed, 2 Feb 2022 19:05:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=p0wt9BMQXHZz2HYDWuRMjgilBusNhYbAE5dR5pA6gOc=;
 b=Fpq4n2asUL/SErOWIg6paU9t2E1BRqsoxB6lFbhNLCY2f8/lOt+i22vdbzgHng0u3MuQ
 yXigI9/OfUeU2t2Yx667zlwP73sjYrnENipDaLTPwM+QcaBcYw/wcOgv5k77hI9bwLDU
 /T00suFAiRLflPk5RfhFDGgPLoXoT9oCAGc8zDHFpbjjCzACGQVBLa/GIo2K+o81Nzuw
 ht8VXwAOuyAIqqxsIj87bYg81ptooaSqlcf49mLszPGZGeApBkRjrTPZ0bbjF2wykE5i
 CygHeODaQ2bHRhljthJzmC0WsqNCJZgo0xr3sdOsCe8WmzPrL7+zd4SB61fyLwq0yZRp xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxjac705c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Feb 2022 19:05:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 212IvR6h016334;
        Wed, 2 Feb 2022 19:05:12 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by userp3030.oracle.com with ESMTP id 3dvtq3b6g4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Feb 2022 19:05:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aOIdFRRNjsz3KjzyYPiHpoFwcOlqLEeZk8089daB/ay1HHjdUnvxGN5OOm3f4YfQ2VoRVr0cQVIuQAb3y14DXMngqu/vokD9YGLCjOe/1MfL8pTuiVfXX6LODoOHVw+vSm5e/FCk812bc0B4a8l9HAvjGAXfxhe7MemGd8Oc4upE2eE/DH8UTB0fovlyzrsT+2tfPiv7g0KUxX07BMRnvmSQPKaeK/syL+cr2Hxbhipt86UTT5RZvh/fOdCQZljxLJUTjIoaN0cdi23DVI7prME31lyZvi/QnLUc545fbiCIC4zMLfPQiXZqKLQfual3WdJ7Q7KEOT0OvnwSkcwK+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p0wt9BMQXHZz2HYDWuRMjgilBusNhYbAE5dR5pA6gOc=;
 b=bPppWBB1nIKfV0nfGfJa3UUMMJnq9fMo6/6mk8ltdtWy7K4XdfYWtJgxGBng4E+gXINGPQTtkcUJHDxCSh94UnSkbJ7wJw8GKNbAMCCe5yDJNKj/nCEN90s033IbCMvTtrMJGZhoR7tBPg6HIaoxLRWGWchUc7SApcg9SbdcuUZsjJUS5XmQ3V9VqoD1Ejpv6VRAMee/NwgDTSRbfniJ2x64GtxrOXqM/nFm5jHrFj3zgeBRvaOFQ4rysNtflSMRz8OISN2oNbv2uIJy1z2hstGpSJuqtvwyJwq+TXkah1qLgh7G7gy8cjTBNN7+yX4nClVNeumMYjoC9DwtZmFCsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p0wt9BMQXHZz2HYDWuRMjgilBusNhYbAE5dR5pA6gOc=;
 b=UR5v1UQmAFDJBd4nAOfSdKCaLe7P+/5rMx9VrKwUZ2+ez9v5GDbyq5xeIO3HK9jupJCfz8EfjpUiBHLS79nyxqTElcATkwX2rfiTwNXcbKDFekJVJ/Gvt4ugl5VuewGF8keF7r1hnOkcHOYd9ezFo5c05Qp4gDxa5Csb3VSh9c0=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BYAPR10MB2757.namprd10.prod.outlook.com (2603:10b6:a02:aa::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Wed, 2 Feb
 2022 19:05:09 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a%4]) with mapi id 15.20.4951.012; Wed, 2 Feb 2022
 19:05:09 +0000
Message-ID: <c6c3007e-3a2e-a376-67a0-b28801bf93aa@oracle.com>
Date:   Wed, 2 Feb 2022 19:05:02 +0000
Subject: Re: [RFC v2 0/4] vfio/hisilicon: add acc live migration driver
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
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
References: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
 <20220202131448.GA2538420@nvidia.com>
 <a29ae3ea51344e18b9659424772a4b42@huawei.com>
 <20220202153945.GT1786498@nvidia.com>
 <c8a0731c589e49068a78afcc73d66bfa@huawei.com>
 <20220202170329.GV1786498@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20220202170329.GV1786498@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0371.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10b5f0fd-92aa-48ff-720c-08d9e67eee9a
X-MS-TrafficTypeDiagnostic: BYAPR10MB2757:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2757EC39395933BD05D0BA48BB279@BYAPR10MB2757.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6VwXEKUPkCPfu/CLW/rD9c7iWV0XVOv95wD00B7LsRtOmKNoEyFPCVIl3ezqsTDaWPF5764DM9039HCyi58xlLorsbYuvVJx1q6gYHCLVnxV0H1P/Pq89bZk9H4kwW9VxXbBKAZcDTC219aVbpMgaSg8MfbqFiU0gFl5z2QoK0G1wYRjb1JqjTd07GWIati049LOWl/phsipqfT0nqGxDgyS1Ja4xzm6ijZL8MHyJrAc4RzG8psdnUfnwbjRqFNUDbwN4ElWpOLlgQWbL88F0mBXDoAxovHTJjB6WBcY69grSd+41iI1sljDYA0dkjBT+nUjz+V+dPHmoYUL2JueTtQ2gIkiBflsBGykDwIQwtmm3ymAjcZGd93jQXSNH/AmOwQOk9FkywB8FExOWyELbQLwyEFM1idjmeCOQo0k82Y1TAtp+ur9VPE397s9zH0FFv47kK+E1eDbhrj4DvKEl74NYWmIh7tkzoEl/x15cucyoaOiFyDJx/zFj8eBDktWqIHW7nZngE5q0COtHWMSZ1c6r1cswKI7RlbGRYofNHaN7pqlmR3leCgVJHhN7JnNa6Otap170TfZDmQI46r4OuXZh5Vq/Er89h8UT3tCHQxglHh1iIIQlevNYAHD6amHrO77B2yQDJzqnYtrx0h5XG8u6mzI+XEBebUQ2gnEI0b4h171h/UiZ4xN3F62l4iOkxnVTZvZ2ta5MHLhaKSydsk3RzVZV9uACas+LJkCmZIiRiPNlJrin/0Yk4HcM20QdYA2Q0ZfauEsPLOPsJyWorkCESfmyJT5Xyf4CiUgv2g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(5660300002)(31686004)(316002)(2616005)(508600001)(54906003)(31696002)(186003)(7416002)(110136005)(86362001)(36756003)(53546011)(6486002)(66476007)(38100700002)(8676002)(966005)(4326008)(66946007)(66556008)(6506007)(6666004)(6512007)(8936002)(2906002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cVA3SC9vSklhU3pqd0xneUQyYkpEWXVweHBKTmhLenF1T2JUenZRaFI3VG1p?=
 =?utf-8?B?akRLWUxMM211NmVXZVkzR2pvbHM2Sk4wTUpqSEdYd0xtVG1jVW5LV016RG53?=
 =?utf-8?B?KzFkTU43TmpvSTA2Q3NSekVvUlV1d3BMbXYxTVZBTnlOMktGWnVQbTZzbEc2?=
 =?utf-8?B?L2ZmeHdUdFlOanhBTCtVQjZNMis2UjV5SlI1bjFrOG1LcTBmbVhyU09zRG9H?=
 =?utf-8?B?djA3ZDdqOUh0STd5dDUvWCt2c0svQ0IxK0pOQ3ZBMTViV25TbU1yaEp1bTFa?=
 =?utf-8?B?ODA1WjR5Nlh5UEh0b2V5MUx3cVI0UmdPZDhlOEJjajM4dWpPdE84N01haUZ6?=
 =?utf-8?B?QkN4YU1KaGNINWd3OVAxU2NKVUJhcEJIbE5XL3VOOWxUaElBNmVaNTlMREYr?=
 =?utf-8?B?Z2k1N3ZRemN6WmxLMmc1azcxdW41S3ZqK3pEM3AxZzFtRUl5Tkg5emlqY2Vx?=
 =?utf-8?B?SlR2Tkx5ckl0bis5STJvbFVFVnIyaFBwOHBVc0JyUkQxcmlTTUcvWFR0ZWFo?=
 =?utf-8?B?UWFwbFcwRDB4bGJhdDVWd3BKaW1OYUc5UU82UU05WEVPeVNqdUpKbEp6SlZa?=
 =?utf-8?B?NDN6aUlQZUZvZmZqNUtza3BjWlowKzZmWkdxdkRlZ2gvMXNRQjNWb0FLUGFq?=
 =?utf-8?B?OFNidEdXUElNQ085NEsvaHpKS3hhc1M5aUQ2OGhoZkJIVEFCOVNoTXJoTFF1?=
 =?utf-8?B?eXdkK3lQZG0wcHBka01ZdjJYZjhyTWV3Y21UZWFlMEVvMEdMNllwVmRjRzB0?=
 =?utf-8?B?alF4Zk9QaWVUUmNKVU93L0dKUitteThlbnc0TVkxZUZtZDM5Ulgxamxhbm9K?=
 =?utf-8?B?Q0RaU1ZIVWdzb3gvV3A2M0c3Yk5YY045VmtjN1I2cWFxOG5JaDZLWXlkWnFT?=
 =?utf-8?B?K3ZRU2xIVlhkTHZnR0VyYk9LYURnWW5tdjJxL1ljK0tpN1NwSlRBQmRlZ2hz?=
 =?utf-8?B?MmNVZ1pRMm1GQVhwNE1sdnd0Rzl6WUJqeVBEcUppeHZSYUlxRkxtYlpZYzZn?=
 =?utf-8?B?UGE2VHc2RldjeXd6Y0M2aWxNS05haTdIZ0VhOXZVTUhIelh2SnhDQU5BSWVk?=
 =?utf-8?B?N2JVQ3hRSXk2ODdmVFFKWHhJeUlDbkQyMnMzd05wYUlOZEdmM0dZZ0FGa0pv?=
 =?utf-8?B?ZUdkbGtSSE1OeTEzVVp5RWFDZldWRzRKVVZxM0E2VUpmMkJQS1hNbVlBQUJn?=
 =?utf-8?B?UFZNL2lzZnFMd0pzOUp1SkliM0d3VThqOWxVSFdsS3dkQURTVlZtQkJKMWJE?=
 =?utf-8?B?eFpDTjJBSVZvL0dkZEVlUlVoVUVvNGdlOUMyRnZvTlk0Mm1uUThBRnVsV3Ba?=
 =?utf-8?B?RzQvQ01wMjlZNHdnb2VZVnhnL21BeUNEeFFMVXZ1aFpFY0FrMEsxT0xqQ1Vi?=
 =?utf-8?B?VjFsR2hrblZma05STCtMTVlQMm5Bb3BmNVFicFdGajRrY1Avdys5ZkkrQXpN?=
 =?utf-8?B?cXlnc1VoZmhkMzNQYjZvU05sUHlZakVtdUl5bXE3OVJqRzVwM1pyVmVZUHFL?=
 =?utf-8?B?MzVMS3pERHp4THR3aWJMNXNMeGNFRHcwRm51ZTNHV0h3TG1tMm84RFFtRkhp?=
 =?utf-8?B?REtyTXIxazFtYWdPL1JRRjVZK3lsUkZ1LzJmWXhpM0NXdVF4Y1dVeThXMlJy?=
 =?utf-8?B?UExIbTlKdXZCdDZ1aFhZRUpaTGFWMlg2R3piQ0ZOWmdiWVlmcGM5NzdzZy9u?=
 =?utf-8?B?d3FSa1RBaGM2OEpMUHptT1JlbVc3UjNzRzVNcS8rWWJlL3AvWFpUSU44SUhQ?=
 =?utf-8?B?SndOOWRoZDU3TW1XTTFvV2M5cDRnYzMwajRucUVUeHhvQUVmQllOV3RCSFZ4?=
 =?utf-8?B?TWNiazRBZDliRW5ZeU1MbVBqWG1VZkM4WVp4Um5EcXMwcVJDN0tNdlJxRUFx?=
 =?utf-8?B?L00xKysvL2RrbmFCSXdHTXhJK2JUdzlhN25UeHpvUnZuZGVVKy9rNWVhb3pH?=
 =?utf-8?B?OUFYYVUxVkdlRnZGd1ZFRlQrSnJMWWNBZ1FibHRaSFpRTVJlVmV2ajIxakcy?=
 =?utf-8?B?QmUwVUdQaTFTazVPQ1dFeUFmY0RMT0dQVWtCTGtmdk8wSUhtcVN1OXY4RUJ5?=
 =?utf-8?B?VU5xZFUxWGxQa0hoa0trRlVTdlIxMFRhQTljdEswVWdkalg0S3RsZHNaazJp?=
 =?utf-8?B?K3Bwdk5Hd0YweDBtM1lPcmVTaDF0eGF4WUYrSU0rKytyZlYvSzNmQ1B1cUQ5?=
 =?utf-8?B?WHFSbVFhZ05CSkxCWGtmMG5aUzFjQnRJSUE2cTNrQjYva0hicVVBZHl0TUJW?=
 =?utf-8?B?UHl3Lzc1MjY2VEFZc0hhd3BKTDdBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10b5f0fd-92aa-48ff-720c-08d9e67eee9a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 19:05:09.5328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PQajCMSss3GOAgmDg5B97MAIhW4kp4Sq+vQSs/W+RMa3MPskh2vrstZChTuTUM3mJQEhIyLohZu2IrF/bFzCno8dIl73oygcXIVbYz+z994=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2757
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10246 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202020106
X-Proofpoint-GUID: Zwk4dNZLU05IqzP5rcgJI_RGcO2x-C4B
X-Proofpoint-ORIG-GUID: Zwk4dNZLU05IqzP5rcgJI_RGcO2x-C4B
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/2/22 17:03, Jason Gunthorpe wrote:
> On Wed, Feb 02, 2022 at 04:10:06PM +0000, Shameerali Kolothum Thodi wrote:
>>> From: Jason Gunthorpe [mailto:jgg@nvidia.com]
>>> Sent: 02 February 2022 15:40
>>> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
>>> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>>> linux-crypto@vger.kernel.org; alex.williamson@redhat.com;
>>> mgurtovoy@nvidia.com; Linuxarm <linuxarm@huawei.com>; liulongfang
>>> <liulongfang@huawei.com>; Zengtao (B) <prime.zeng@hisilicon.com>;
>>> yuzenghui <yuzenghui@huawei.com>; Jonathan Cameron
>>> <jonathan.cameron@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>
>>> Subject: Re: [RFC v2 0/4] vfio/hisilicon: add acc live migration driver
>>>
>>> On Wed, Feb 02, 2022 at 02:34:52PM +0000, Shameerali Kolothum Thodi
>>> wrote:
>>>
>>>>> There are few topics to consider:
>>>>>  - Which of the three feature sets (STOP_COPY, P2P and PRECOPY) make
>>>>>    sense for this driver?
>>>>
>>>> I think it will be STOP_COPY only for now. We might have PRECOPY
>>>> feature once we have the SMMUv3 HTTU support in future.
>>>
>>> HTTU is the dirty tracking feature? To be clear VFIO migration support for
>>> PRECOPY has nothing to do with IOMMU based dirty page tracking.
>>
>> Yes, it is based on the IOMMU hardware dirty bit management support.
>> A RFC was posted sometime back,
>> https://lore.kernel.org/kvm/20210507103608.39440-1-zhukeqian1@huawei.com/
> 
> Yes, I saw that. I was hoping to have a discussion on this soon about

Sorry to snatch the thread, I was thinking in doing the same this week,
as I was playing around that area, and wanted to ask the community... but
since you mentioned it :D

> how to integrate that with the iommufd work, which I hope will allow
> that series, and the other IOMMU drivers that can support this to be
> merged..

The iommu-fd thread wasn't particularly obvious on how dirty tracking is done
there, but TBH I am not up to speed on iommu-fd yet so I missed something
obvious for sure. When you say 'integrate that with the iommufd' can you
expand on that?

Did you meant to use interface in the link, or perhaps VFIO would use an iommufd
/internally/ but still export the same UAPI as VFIO dirty tracking ioctls() (even if it's
not that efficient with a lot of bitmap copying). And optionally give a iommu_fd for the
VMM to scan iommu pagetables itself and see what was marked dirty or not?

My over-simplistic/naive view was that the proposal in the link above sounded a lot
simpler. While iommu-fd had more longevity for many other usecases outside dirty tracking, no?

I have a PoC-ish using the interface in the link, with AMD IOMMU dirty bit supported
(including Qemu emulated amd-iommu for folks lacking the hardware). Albeit the
eager-spliting + collapsing of IOMMU hugepages is not yet done there, and I wanted to play
around the emulated intel-iommu SLADS from specs looks quite similar. Happy to join
existing effort anyways.
