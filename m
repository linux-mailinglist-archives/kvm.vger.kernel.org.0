Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDB74AA082
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 20:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235117AbiBDTxr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 14:53:47 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:14420 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232023AbiBDTxo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 14:53:44 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214GTSGh010693;
        Fri, 4 Feb 2022 19:53:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=MfUj7Wjr5KGKTiORonlddgmKXDpqj16n/87I9PqnZrk=;
 b=IV5B3wteoMtabbY1hEg+GN146s6V7Ko2APrpZzi/guxwuV8y3fM6wrl6kk7aCmZCk9Ed
 17qId0Ng4uPhjeJDzxQck0UVBQUzt+3CbWJdO3OULSwuNRI8Q4Wpg3rF6rf2l57RIgLI
 5MKl72BlFjbv+4KFy8PVu0uyi+ID10BLWpGeUxAzpSMFGD0Lzhj2x0Sw6Sfqm3TeDkqw
 nxKxsHON3xqO0b4RZNCTg4Hnvl+Tzt30TQ5Y/xryVt7Jyxz9DSktsJfwl/o9l+OJPa3k
 hvOQyhS/b6LqHBQSwPP+Nu9xfk8Ufk3+IRuNbRrImO9yL/akQcR6G4CXqpxo6w6AjNhV uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e0hfsukpg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Feb 2022 19:53:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 214Jq2Js067992;
        Fri, 4 Feb 2022 19:53:24 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3020.oracle.com with ESMTP id 3dvy1xuruc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Feb 2022 19:53:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WRfdYBKDb7BoNiaawGGjYY72VWMOPJkkthzMBvFEfvkQLZIxObA/rOGJ0QygV2lFg8nzMeVCZ1Hcuqod5Pr9NaM4DgF+YjFfmQB5IdtTOgS74tW8LGqgX+SJIOVbHb0dzZzAQIUuCM1s5Jb+hR1NBCk3i3aEmS3F5HRT7fSUT9mBOtChXBVkYey2sUIHlblR790CkD+4WsPT4ZhGMtfdCdpjcdf8o5Su8qj1KM9Y0ZuWR2PcxopAQxbTUYKOkgiz3JcvCQqVC+YM3u7tXqYVQzmEgE5tyb62yZ1dYrAggZyc2Z/bPcHJ+vp7HhiMHHvfwWwpI8BRP5acCFBgsWIqtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MfUj7Wjr5KGKTiORonlddgmKXDpqj16n/87I9PqnZrk=;
 b=LR0iZUvfvy5pvJlGpBPjAUIdesItLMHJc6wyCt+n9PsaoTmuHbcLe0rmZTauyY6VinitAJslQ6V/N2UcuzpzTP3m83+CFZDe5YsqgCW0YX4ntsEeShWa0vT074Y8LNnSQytUypdPiql3UuvwLjr3LauKZouSSP/nsyOWRTTe3u3l8W3o6g4Bh0BIghs9fSK2/q8Cyf8mnOkOEzjq0LmmDD2GJwOKSCWuPkyBrGpCoKAQ/6GSe5/AqnYkVVBYMx6UqPRvJ5vIcpPh687/3wOFagzBnG0LYYGViRmzP0cSi83CkyfnJJeaCXxfHVCkUmK+dG7OZdmU8v7oEXL81S9h0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MfUj7Wjr5KGKTiORonlddgmKXDpqj16n/87I9PqnZrk=;
 b=ImWIPld4fGGyhLnmIWHsfyVMx1wxc0iH23dlyMQbeR/kadoBZJkfPi6WjJ3W29qRpWBsimk//bu7c0z+irFSrnPt9LG5jxlEhgjallFlDDVgAzhZ070Qpvv56WikboqB9Kb9fAhb4I/FQneZdeAqPp+w+/7tSMd3NP6c66mf+Z4=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM6PR10MB4377.namprd10.prod.outlook.com (2603:10b6:5:21a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Fri, 4 Feb
 2022 19:53:22 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a%4]) with mapi id 15.20.4951.016; Fri, 4 Feb 2022
 19:53:21 +0000
Message-ID: <e67654ce-5646-8fe7-1230-00bd7ee66ff3@oracle.com>
Date:   Fri, 4 Feb 2022 19:53:12 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
Subject: Re: [RFC v2 0/4] vfio/hisilicon: add acc live migration driver
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
References: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
 <20220202131448.GA2538420@nvidia.com>
 <a29ae3ea51344e18b9659424772a4b42@huawei.com>
 <20220202153945.GT1786498@nvidia.com>
 <c8a0731c589e49068a78afcc73d66bfa@huawei.com>
 <20220202170329.GV1786498@nvidia.com>
 <c6c3007e-3a2e-a376-67a0-b28801bf93aa@oracle.com>
 <20220203151856.GD1786498@nvidia.com>
Content-Language: en-US
In-Reply-To: <20220203151856.GD1786498@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0221.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::17) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75d71054-8337-466d-1211-08d9e817ff44
X-MS-TrafficTypeDiagnostic: DM6PR10MB4377:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB4377620AE9024BCBC4465256BB299@DM6PR10MB4377.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hArzSk/OZRJFEa6P4IY51W1OZtxNG96U1ENmPdu2hlfdHfCP9lGZnkuUF7pP1cwFlaw7QT7fTfY/IW4G29459hGHNlD29C+Z0wQom2w32xYKsO12ebJxTZLTfQcL2IZ132W86Nb7nmTw5QN1FEbqBtjZnsMmpFIKvC8MfSPkBAjOI9VwNU+BBuFGbitdoz6X3H8BQcW5Yp143A5fPYvHo2JcddKLd2s9wzXMGieAlth5llBlM/VNBCqz1MxER1SBjWlZ1Fu2DAmNTj0OMpiO8UknyzYntT9kDTkBrxv9glPzwDqZ9vyqnNYF1QErl9yITlWWz8+B3j+NO6do4dcT2Ps603OPaPAdPhplcuoLFASXnPEkbocf4CPzj6knRVGksDKVbTcgq/DnxuDAXgqpkaTA8xF2AHXBOopsghAYFzyKOvHPCreb9GkYB9kCtD/qaqa99+shlTemjE4BQTFuB1IYvdfzanwZRsY0+SaYg+DHzawyIBrK5GhJZmJTE9+/+CeCzsnMl0Wvc3rrLmMnJo2o0sg0MjQTcEji5XApSJa8a0QLDOM32ES2bBjUWPBQNLwOOGah/IryYG2ZIwvP2l0aA9ZhEMX/1ApCZFb0rKcKZcvnDvZnMNt/5SaMEd7EENDJq+HS+3CHBZbrHJJj9FLmvpWKBdS4rkdbX2eXaFigeSgyENjmN7Nu0kDchM5GUinWKR7JgWVJ8koXsNfZblS89jaV6/oIhTsF1ghjzd8vhD3L3bc2e9KhjAkvU0zyK00ub+2etmModa+xnl0unBgKt/KjB/8DS/NUyBjoeww=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(54906003)(966005)(6916009)(38100700002)(6512007)(26005)(186003)(2616005)(53546011)(508600001)(83380400001)(6506007)(6666004)(86362001)(2906002)(7416002)(5660300002)(31696002)(8676002)(36756003)(66946007)(316002)(31686004)(4326008)(66476007)(8936002)(66556008)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qm5aVXRlVHdzRVBXVG5BR1JBNUVlU2dQMUxHMjE3NlVveGNkN3d6MXFJc2lW?=
 =?utf-8?B?OWR0Z1poY0VjeWpVM2E1cEJCNDRLZXQvWWRMUVBwN1ZCTTcyT1doT3EyU2dn?=
 =?utf-8?B?QkJLb01pemxjRlNzQ2szM0gva05US2JFRUVZdDBQTUdvTzJzdTB2blVjdkdl?=
 =?utf-8?B?dWsxMTJLY0NzdXZKRGZWMnJKdmM0WlpPcjZRL0tRQUlmaUorWG1pSy9Sckho?=
 =?utf-8?B?cDUxK1o4Nk9BUjgySzJSang4c1hxR01EZEd1aXhWS0RUN0ZUWUo1RTR2ak9U?=
 =?utf-8?B?RFlpbVB0bVE5MC9NKzErYnNPQ2JCTFZWUjhxZjQvaGNBWUJjVklEQ3dZV3V4?=
 =?utf-8?B?dTRUOTZqNFhoQndKZ1dqWjJLSVJOalhUM1UwTUw2SmJOM1VBOXI3ZGVybHpF?=
 =?utf-8?B?OTY5MDBDOGFXaXpUWWVIU2dTVFpncHVWSmNsdlRpRUxOVWt0ZzRwbkRqQ3Nk?=
 =?utf-8?B?V0pBYmp2WGYxMTlkOUljY2prKytQN1hSMStsSzBqZDlITjMwb1pWQWsxK0Fj?=
 =?utf-8?B?VDFhVjg0S0NCOHRNWlFqS2NJcUtjaFd6Wng1SWxoTTdON01UYzJ3ZHRpUlFm?=
 =?utf-8?B?Y29hcG5VMWVEMVd0SXd6NXQvT2dvWkF6ZjZpL1NlMU9kOHRzVlJxUWdmcnJH?=
 =?utf-8?B?M1JwNnp3RUU2VzlKUFZjQVRYeVRJd3hCQkRacXd1bEcrNEFnL0I3TGFIc0dL?=
 =?utf-8?B?d2h5Zm16UWdhMGdHT2ppdTIza3B1UXRIeStiOUhFcTZvR0VJQm5wS3A3Wko2?=
 =?utf-8?B?REs4RzFwYmNROG50QVg5VlhHb09OS01HbjZjYlRnOUt6SFRRT1ByWXlkV2Jz?=
 =?utf-8?B?YVV3eGU1SUdpWlNmcHpLdmg3SlRjSFF2L1pHb1Q4RUdBbjBRMEZqZ1U1Z1dw?=
 =?utf-8?B?OGdsTU9SVVgxakFxN2VoTzkwNVRqR3BOUysyaGhOYWdmMkM5N3FiQUxMK2pw?=
 =?utf-8?B?WStRT3JtU2cvR3kvNVA3ZURJQ0pMczR4VDZDT1VNU2NtSmdnN1Z2UnBLNmRr?=
 =?utf-8?B?OHRhSHpuc3VabzRoeGl3V0ZQK1dNU3JER2RFQi9JTTlCd0VIVUpCQkExSG5Q?=
 =?utf-8?B?cW5tMFBuTDlJb2x3QXV2WlVHZ09ocjZHV1g1VmkwQnV0SEE1c29iMWVnck1P?=
 =?utf-8?B?UzVJdW0zUVJrMmRMZWFMOS9uM0ZXRElOcU1wWTAweTVZVDVuNmZvUjA0REZG?=
 =?utf-8?B?T1Ayd3hpWjBiVlZvZ1ppZ2diSm1WWWZlOWdPSVc2YWRWSDFpdll5RXdZTTFP?=
 =?utf-8?B?RWkzVzNVMDZRTmxQa1Nocmo2cGEvVjJHdTRkdmZyQkFKblV6Q0tuemQvaEt2?=
 =?utf-8?B?bFVXS1M4OFNoRTExMXVLQlp4dUdRYTZPN1JJNDVZSnBEZmJaSjFORXdsSFkz?=
 =?utf-8?B?czRrS3RpOG5LUVdKMU5zR3ZHeTZLVDFxS1VvOGE1T3ZMWUR4NUw4TDhvblkr?=
 =?utf-8?B?aTUyazRKL3BjTzFJN1J2UFIxK3N1amM0dFBnd2Rrcm5mQjJBbE13bW5wdHZ2?=
 =?utf-8?B?WWZvQkxldWdQMGZVaUpMUVFpa1pSK0w2MzNydHI1UEQ1RGdlR0gzZGZBMEJo?=
 =?utf-8?B?MVJYMktiYnpkb1BoUWl0bXhVUlhZQUhTY3ZSMmpVd2Yxb2FSYzJkNFZrRjJa?=
 =?utf-8?B?Q0piZEJCd0ZQYTR5alJPb25nZ0FiQ25PTGMwK0JVUzhlWXhmM3RqNFV5MW4w?=
 =?utf-8?B?TGVvcTdNQmd6UkI5ZjBIUU9mZWZXT3RBdG5TMVNKQVVOV3Nlcnd3VzVOTHBX?=
 =?utf-8?B?b1RxWkNzNXM1VkN1a2M4blR3VisxTXdnb1ozQ1MydW00OWxoNUtqOTVMYWdL?=
 =?utf-8?B?Tkh5UnVmVXdYcHhlM3VSendkMkQvcWFiNi85bitQdDQxOGVzWk5yaDFjQU9T?=
 =?utf-8?B?b3czQkR4Zzkxd25SS21WakhUWTR2NkYvR2s4THovcVpMNWlFazUwZ0VHMWpQ?=
 =?utf-8?B?aWY0UGl1YXBjQy9xYThETGUrVEk1b1RGZlVuZHdXaEhCTGs0NnBUeHF5b1Rs?=
 =?utf-8?B?MHVIbWwrZ1E1a3EvemN2UTdHeVdxR1ZwdW10L1dqMjNxUGdFNHk5VkZpTFZ4?=
 =?utf-8?B?elZUWnNwWnQ3S1lVUkhsV2FPUUdjaGVET3dtM05yckh2RVRtTGM0Q24yeThn?=
 =?utf-8?B?eW5VdlVIM2NTM1JoaERLMzFFak11ZllsUkhMaElJRmdIZXRmQndoNUZieGNj?=
 =?utf-8?B?dmluelFHL2EybStybjdXaW4zbi9kY2p3QlBPUEFOTVVrbGlwYzVHQURkOHRa?=
 =?utf-8?B?TWtLNERlcnBPZFBHQ0d4a1djTHVnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75d71054-8337-466d-1211-08d9e817ff44
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2022 19:53:21.7459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Rw7JP4Ldz8Uwfxv4/GyxlWw60rc36gD87EoakAP72w582LJery0Va18EuYvC1lSI9xvZqj/246m5hLeBMTmuFM0nHV6GLB7bnXRw9hdb00=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4377
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10248 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202040109
X-Proofpoint-GUID: zVziY9_ZZN0b0XCv40Hhq2HV1L3z2nPk
X-Proofpoint-ORIG-GUID: zVziY9_ZZN0b0XCv40Hhq2HV1L3z2nPk
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/3/22 15:18, Jason Gunthorpe wrote:
> On Wed, Feb 02, 2022 at 07:05:02PM +0000, Joao Martins wrote:
>> On 2/2/22 17:03, Jason Gunthorpe wrote:
>>> how to integrate that with the iommufd work, which I hope will allow
>>> that series, and the other IOMMU drivers that can support this to be
>>> merged..
>>
>> The iommu-fd thread wasn't particularly obvious on how dirty tracking is done
>> there, but TBH I am not up to speed on iommu-fd yet so I missed something
>> obvious for sure. When you say 'integrate that with the iommufd' can you
>> expand on that?
> 
> The general idea is that iommufd is the place to put all the iommu
> driver uAPI for consumption by userspace. The IOMMU feature of dirty
> tracking would belong there.
> 
> So, some kind of API needs to be designed to meet the needs of the
> IOMMU drivers.
> 
/me nods

I am gonna assume below is the most up-to-date to iommufd (as you pointed
out in another thread IIRC):

  https://github.com/jgunthorpe/linux iommufd

Let me know if it's not :)

>> Did you meant to use interface in the link, or perhaps VFIO would use an iommufd
>> /internally/ but still export the same UAPI as VFIO dirty tracking ioctls() (even if it's
>> not that efficient with a lot of bitmap copying). And optionally give a iommu_fd for the
>> VMM to scan iommu pagetables itself and see what was marked dirty or
>> not?
> 
> iommufd and VFIO container's don't co-exist, either iommufd is
> providing the IOMMU interface, or the current type 1 code - not both
> together.
> 
> iommfd current approach presents the same ABI as the type1 container
> as compatability, and it is a possible direction to provide the
> iommu_domain stored dirty bits through that compat API.
> 
> But, as you say, it looks unnatural and inefficient when the domain
> itself is storing the dirty bits inside the IOPTE.
> 
How much is this already represented as the io-pgtable in IOMMU internal kAPI
(if we exclude the UAPI portion of iommufd for now) ? FWIW, that is today
used by the AMD IOMMU and ARM IOMMUs. Albeit, not Intel :(

> It need some study I haven't got into yet :)
> 
Heh :)

Depending on how easy it is to obtain full extent of IO pagetables via iommu_fd
and whether userspace code can scan the dirty bits on its own ... then potentially
VMM/process can more efficiently scan the dirtied set? But if some layer needs to
somehow mediate between the vendor IOPTE representation and an UAPI IOPTE representation,
to be able to make that delegation to userspace ... then maybe both might be inefficient?
I didn't see how iommu-fd would abstract the IOPTEs lookup as far as I glanced through the
code, perhaps that's another ioctl().

>> My over-simplistic/naive view was that the proposal in the link
>> above sounded a lot simpler. While iommu-fd had more longevity for
>> many other usecases outside dirty tracking, no?
> 
> I'd prefer we don't continue to hack on the type1 code if iommufd is
> expected to take over in this role - especially for a multi-vendor
> feature like dirty tracking.
> 
But what strikes /specifically/ on the dirty bit feature is that it looks
simpler with the current VFIO, the heavy lifting seems to be
mostly on the IOMMU vendor. The proposed API above for VFIO looking at
the container (small changes), and IOMMU vendor would do most of it:

* Toggling API for start/stop dirty tracking
* API to get the IOVAs dirtied
* API to clear the IOVAs dirtied
[this last one I am not sure it is needed as the clear could be done as we scan
 the ones, thus minimize TLB flush cost if these are separate]

At the same time, what particularly scares me perf-wise (for the device being migrated)
... is the fact that we need to dynamically split and collapse page tables to
increase the granularity of which we track. In the above interface it splits/collapses
when you turn on/off the dirty tracking (respectively). That's *probably* where we
need more flexibility, not sure.

> It is actually a pretty complicated topic because migration capable
> PCI devices are also include their own dirty tracking HW, all this
> needs to be harmonized somehow. 

Do you have thoughts on what such device-dirty interface could look like?
(Perhaps too early to poke while the FSM/UAPI is being worked out)

I was wondering if container has a dirty scan/sync callback funnelled
by a vendor IOMMU ops implemented (as Shameerali patches proposed), and vfio vendor driver
provides one per device. Or propagate the dirty tracking API to vendor vfio driver[*]. The
reporting of the dirtying, though, looks hazzy to achieve if you try to make
it uniform even to userspace. Perhaps with iommu-fd you're thinking to mmap()
the dirty region back to userspace, or an iommu-fd ioctl() updates the PTEs,
while letting the kernel clear the dirty status via the mmap() object. And that
would be the common API regardless of dirty-hw scheme. Anyway, just thinking
out loud.

[*] considering the device may choose where to place its tracking storage, and
which scheme (bitmap, ring, etc) it might be.

> VFIO proposed to squash everything
> into the container code, but I've been mulling about having iommufd
> only do system iommu and push the PCI device internal tracking over to
> VFIO.
> 

Seems to me that the juicy part falls mostly in IOMMU vendor code, I am
not sure yet how much one can we 'offload' to a generic layer, at least
compared with this other proposal.

>> I have a PoC-ish using the interface in the link, with AMD IOMMU
>> dirty bit supported (including Qemu emulated amd-iommu for folks
>> lacking the hardware). Albeit the eager-spliting + collapsing of
>> IOMMU hugepages is not yet done there, and I wanted to play around
>> the emulated intel-iommu SLADS from specs looks quite similar. Happy
>> to join existing effort anyways.
> 
> This sounds great, I would love to bring the AMD IOMMU along with a
> dirty tracking implementation! Can you share some patches so we can
> see what the HW implementation looks like?

Oh yes for sure! As I said I'm happy to help&implement along.
I would really love to leverage the IOMMU feature, as that relieves the
migrateable PCI device having to do the dirty tracking themselves.

And well, we seem to be getting there -- spec-wise everybody has that
feature *at least* documented :)

Give me some time (few days only, as I gotta sort some things) and I'll
respond here as follow up with link to a branch with the WIP/PoC patches.

Summing up a couple of remarks on hw, hopefully they enlight:

1) On AMD the feature is advertised by their extended feature register
as supported or not. On Intel, same in its equivalent (ECAP). On course
different bits on different IOMMUs registers. If it is supported, the
IOMMU updates (when activated) two bits per page table entry to indicate
'access' and 'dirty'. Slightly different page table format bit-wise on
where access/dirty is located (between the two vendors).

2) Change protection domain flags to enable the dirty/access tracking.
On AMD, it's the DTE flags (a new flag for dirty tracking).
[Intel does this in the PASID table entry]

3) Dirty bit is sticky, hardware never clears it. Reading the access/dirty
bit is cheap, clearing them is 'expensive' because one needs to flush
IOTLB as the IOMMU hardware may cache the bits in the IOTLB as a result
of an address-translation/io-page-walk. Even though the IOMMU uses interlocked
operations to actually update the Access/Dirty bit in concurrency with
the CPU. The AMD manuals are a tad misleading as they talk about marking
non-present, but that would be catastrophic for migration as it would
mean a DMA target abort for the PCI device, unless I missed something obvious.
In any case, this means that the dirty bit *clearing* needs to be
batched as much as possible, to amortize the cost of flushing the IOTLB.
This is the same for Intel *IIUC*.

4) Adjust the granularity of pagetables in place:
[This item wasn't done, but it is generic to any IOMMU because it
is mostly the ability to split existing IO pages in place.]

4.a) Eager splitting and late collapsing IO hugepages -- essentially
to have tracking at finer granularity. as you know generally the
IOMMU map is generally done on the biggest IO page size, specially on
guests. We sadly can't write-protect or anything fancier that we
usually do so otherwise the PCI device gets a DMA target-abort :(
So splitting, when we start dirty tracking (what I mean by eager), and
do for the whole IO page table. When finished tracking, collapse the
pages (which should probably be deemed optional in the common case of
succeeding the migration). Guest expected to have higher IOTLB miss.
This part is particularly worrying for the IO guest performance, but
hopefully it doesn't turn out to be too bad.

4.b) Optionally starting dirtying earlier (at provisioning) and let
userspace dynamically split pages. This is to hopefully minimize the
IOTLB miss we induce ourselves in item 4.a) if we were to do eagerly.
So dirty tracking would be enabled at creation of the protection domain
after the vfio container is set up, and we would use pages dirtied
as a indication of what needs to be splited. Problem is for IO page
sizes bigger than 1G, which might unnecessarily lead to marking too
much as dirty early on; but at least it's better than transferring the
whole set.

	Joao
