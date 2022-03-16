Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C90774DB988
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 21:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344431AbiCPUjo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 16:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233480AbiCPUjl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 16:39:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D621BE8C;
        Wed, 16 Mar 2022 13:38:25 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22GK0Kjm009569;
        Wed, 16 Mar 2022 20:38:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=zf2X4Ur3EEexJkSCBXQnyP1GK2elhQSqZxl8kHhQ+x4=;
 b=ywwcGlDKrLktZpq+K1ZbGK/ixNIbJ6P9fV/RyCTivmDS3pXSh4zRTet8oQbmnRwvN5kA
 H/iiFjcB8VvCi/MkwaK61AXCt0lg+m3Ugj8ft8ef88aWqhAlisUYBcFgiq3xxph7zYRs
 JRNmQ930QnTnC5HhhQzVH+QtEizki+WmYGiGWLduzwPORwagPQDNT5Ts6aqviEOffd6C
 DK4yHVYSEVUzg9A0ROF8HrLIQjEi488jxTEV853afIRgF8UswV1oEnxtsz2n2tO2CBd5
 e4W4kdTjCLp5lrusJ5GraLAUiOG9447IchxRzvU4iYlXgNay6FGGNq1gaeUf8dJg62nC nQ== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et60rqgak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Mar 2022 20:38:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22GKVB8g096301;
        Wed, 16 Mar 2022 20:38:09 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by aserp3030.oracle.com with ESMTP id 3et64u0nns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Mar 2022 20:38:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kVagDvvBAxEMCmh61ifECmKHiozrhUmbAQHxS4mI71rmCmllLKjzOFuCUe1ELGwHjspZeO8DdOcSfnw3RJyHR3RE0HIxI7kJ5AOwOIScwjVbm+TwUPqtHef/nEsEMsFb5UkwNNZuUdaN7Ip8VxjddIoRp7Y2If8Wp+4LaORuGrAmAmgCJrrdO83rRVZEa1Jkipb/7FHKGTsNZREftbRsxnngKfAB4bGW3swSJhngvUx8dXAr/0zN/e74Q1b8vyklhvQfFe1d/DADu6ulk5x0H1gzX//6dVbQUOVbLCCSJrvgfDTwCOx3lpIrKRHbBKmMo9cZpCshCurpeG8hNieYYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zf2X4Ur3EEexJkSCBXQnyP1GK2elhQSqZxl8kHhQ+x4=;
 b=et5bMdvlD7icaeMi4FbX3KBZ/5OXYzvb5+8KfJbkoT706u2rBCBTjbOh24F+/llw9lF8eAodUdG2mXWw5J0jp0HK7qlsSO5M9LYs8qmJvdiVpLZUeVIF2Z1VCbDv1lJ9KXpu/Pak20RYVs1Ka7vf1GggVQRs9kdR7LFzxYQFDRCCpmnrfLAxx6f8Pmm2OTjjQaHL+KS7y8cvJUT6U8JcWNxk7fsJBA/hsOCscBykbd+hbIN39yM1AspA9aXiZBYl1nefEIkwXR0mFyi95Ub5dTGQ6SborXX+0z1lhmZWUpjuDSQ6npZRIH1XtIihVTRL9ghdNI1mwK7rbc1q0GVt8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zf2X4Ur3EEexJkSCBXQnyP1GK2elhQSqZxl8kHhQ+x4=;
 b=BuX0FmsV4UvSN98EVudkTjd73g7Kv5VLfLh2uLUctIBV2cdEnX0RBUHZnc2HaoVyQv4FNTzdQEh0zxGTqJKvsYEtknTiDoXCP7Gjk6kvMKqQV763LMPwij2ESnBOsAjZ3ZLAIMhpwsGnXiTH88OWQOD/eHCLU6uxKyCtgo/FLGg=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5251.namprd10.prod.outlook.com (2603:10b6:208:332::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Wed, 16 Mar
 2022 20:38:07 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5cee:6897:b292:12d0]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5cee:6897:b292:12d0%7]) with mapi id 15.20.5081.014; Wed, 16 Mar 2022
 20:38:07 +0000
Message-ID: <c85a0d65-143e-6246-0d48-dec4e059e51a@oracle.com>
Date:   Wed, 16 Mar 2022 20:37:58 +0000
Subject: Re: iommufd(+vfio-compat) dirty tracking
Content-Language: en-US
From:   Joao Martins <joao.m.martins@oracle.com>
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
References: <8338fe24-04ab-130a-1324-ab8f8e14816d@oracle.com>
 <20220214140649.GC4160@nvidia.com>
 <6198d35c-f810-cab1-8b43-2f817de2c1ea@oracle.com>
 <20220215162133.GV4160@nvidia.com>
 <7db79281-e72a-29f8-7192-07b739a63897@oracle.com>
 <20220223010303.GK10061@nvidia.com>
 <e4dba6f8-7f5b-e0d5-8ea8-5588459816f7@oracle.com>
 <20220225204424.GA219866@nvidia.com>
 <30066724-b100-a14e-e3d8-092645298d8a@oracle.com>
 <8448d7fb-3808-c4e8-66cf-4a3184c24ec0@oracle.com>
 <20220315192952.GN11336@nvidia.com>
 <6fd0bfdc-0918-e191-0170-abce6178ddaa@oracle.com>
In-Reply-To: <6fd0bfdc-0918-e191-0170-abce6178ddaa@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0175.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::18) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6ab4e0b-17e3-4bcb-be81-08da078cdff3
X-MS-TrafficTypeDiagnostic: BLAPR10MB5251:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB5251457766841FB1C5C1DEAFBB119@BLAPR10MB5251.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4QRfjiTUmxxkkKVUVvqPZxPXIE8p+g7Pjo0jia8ESKYu2AQDX63839Kg9PDQIzqtk0BZfrLrggX84+/dV492zz5v1S60/AYTi6Kcdy4hcB+e5e2Amqr3Fa10pBsFece9w1iZPKHFpVT2cpTzUB2KWhYKlkhOWGWk6W8wjn5pY8HnRQ+LXMLEioZ1ErgDDgRvyptNBynx8Ps94DWsHaxalPbtGloDeRH6+deaYsZ4F0RAHAP/dLhe+PkqIb5azCwCNnmgNc75P96ShOcBrn0kp7AM8bnat8+TtXPVVoGe2+X2YU7TmuafioqjIDYgTFhLk85ag3riZpVIrKCfKKBkcQxrO7BlyeSS+XgXTtmpI5TuhtdeOvZNFvY7Xs9cyqliJBqTQc2OJIipOaTB35XvsjQHI9P0Lo0GYj3k17FOzhLfY3JX36uqaApE68ShFL9+03n/Jb4K+Edua244tw9ZzqLLdqKpJ/u/8//L1hRSUMX8gMIYhgbTHKYby5gtIx0h+reK9M0r0xcr8Q+m5vbhZyICkj13ceU5I/ZB7Uw4mBDeCLj4+y5p3FblCeXehvkHH48rRWYjYu57DDsAmtFO3oAbz4ydboS0F7agYd0rK9wa99FbYfEYEy2PgZzaoYuZv/aNmJfH5hkYacVO/DsXET0R8UzkSXXbZ58SxFafqMX3PAI3ElnYHgezYcyUnagKbi4nPAWMEUirMPPYruiqcxWOabEUuAcqgEgP4flYNxorC+fwVIg54mDzx8eqPU4eTI0Ib6qbaBjxVXO1ochJCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(7416002)(5660300002)(6512007)(8936002)(26005)(186003)(2616005)(83380400001)(2906002)(53546011)(6506007)(66556008)(66476007)(66946007)(38100700002)(4326008)(8676002)(36756003)(86362001)(31686004)(31696002)(6916009)(54906003)(316002)(508600001)(6486002)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OWRNSWVmQllzYU92ODh2VzFnS05ibSsxWWVoRSswMGpGeDlIRTJWOFhKSFJv?=
 =?utf-8?B?NUFLQUQ2L3lhVERDTnRkZGYxVndSeVRKdDRvbElrMkFjVWpSQ2NsN1dtQkhS?=
 =?utf-8?B?UVNianB3eVVyeDhiV1VhM3ZFR1RFMFlGcDBIVEtiSXFsVmlERm1heUhmY2xF?=
 =?utf-8?B?MjdWamRvWUhHVVM1czB5eU1iVkxxZFRTc1NRVFV6OUpEZ2QvNTBldkVlVjV3?=
 =?utf-8?B?ait6L3N2SGg5NkZlR3ZGekEwcDRnL2JMaXR3TU93VTgrWi9UMnBoSmczV09G?=
 =?utf-8?B?czBBeVp3d2VheE9sbWJBM0luemJ4MEJaYjNndGJoOWh0V1pncFRvUEgzY2Vr?=
 =?utf-8?B?RXM0aWIwSFZjK3Rha2d2TjVKa2tRa2lvWm5nWU9USGl0aHdpOTRXclhwTm5r?=
 =?utf-8?B?aDZFWkxmS0wySlhwY2ZSWHVwSmNYcUh1YzlHckpZaFhXQ3RzRjZpRm1Pa3lu?=
 =?utf-8?B?Z3l4SW9RQTE4dXFLR1RHYy9JZ1R5bG12VHlsVGFDRThUOUlUMmduSk9xOWJy?=
 =?utf-8?B?K21HdmlXQm1yNml4WjVYOE5nT3lxNitNMkE0YngxYU1vb1JLd0V5ZElvRXZ2?=
 =?utf-8?B?bVdQaVBvOGRTd1N4Z3dUeGlLbDdmS21nVnZVblZPR29PM3JDRnFjV0EzSE4w?=
 =?utf-8?B?OFh2Y1FBR0FQaWMyeWNhbkdiWDEvNVdFVGQrRU9rOGhOUE5hMnl6VjZkQ1pF?=
 =?utf-8?B?WG1TYTNXb21vdlRPdDZHTzlYZ1U5ejRmUFpuZCs0MDUzeDQveXozZnhFN2p3?=
 =?utf-8?B?ZW5lTzBWQzVMQVJqT1RaVUpPSmFzWFpOS2tVQ1dBM0xGV01pNVc4em5yUUpS?=
 =?utf-8?B?RytGVWRTN0IyRm4vbkZ4aHkxQllXUjVEUHhhQnVnbmhDODAxb0xlQWJEck0r?=
 =?utf-8?B?MnFURVNZN00wRUsrTjRGTDVCb1FTYndJQkRkaGhyeXh4UUJBTHVaZ3A1cmZa?=
 =?utf-8?B?WnRBZTlrT3lTUndQdDdUTXVtL0pXZm41bDUzQkRDV1JRbFZKRFJmNFQ3dU8z?=
 =?utf-8?B?RDZxcWhjYlk2L1VZbCtWK0ZSM0JTbVM0QWxtNFBjRUViOWVOMkJFMENieW9C?=
 =?utf-8?B?UE96a2duSlVPRDhxdXRnTUpTNW92MWJiU0pyZUhoaitiRzgvQ3BKclZvQ01Q?=
 =?utf-8?B?S1BRenhRRFRzT1NiejZzdW1nUjNuK3NpOUhUTVlBK0ZIUUdLU0sweWZVR2pR?=
 =?utf-8?B?Wlp2UVNVenJyOVNVYUVCL1Y5UkNpR050cDJveTFqSDhZcjc1eXIvaGdGNlBC?=
 =?utf-8?B?Z3RXZDVrcFp1bVVVRjhkY0JjMHE0ZzYvQk1ETWRDcnQzQkpIdXc5NFp6MWlz?=
 =?utf-8?B?ZXlCQUZmN1dkb3I1b0ZSeENqSnI1cDVDOGxBSGF1bXJTdmtubktoQzlNdFEx?=
 =?utf-8?B?QTdCZStLVjRHaHNVZG1SQmxrUG42TC96RTFxOXB5bTdrSkM1NEtGb2hoZ2lY?=
 =?utf-8?B?V2N4QnJ4T2tDOFlJVzl4VHJxS1R0T21IeHZLUWFXYU1HWFlyeUFISXBuTHhn?=
 =?utf-8?B?cmQrS0JhZHZYanhINktaaTUxdFFwRStMYy90SUd2REJNazRsRi9mVXJiZ2l2?=
 =?utf-8?B?aUtnd0ZDSVU4MGFxS1dZaTNzMlpyNkpVVHIyWEYveXh6ZjNHNzVla1o1VmJS?=
 =?utf-8?B?Zyttc1kwMFd6cnpDN0ViU0I4TTJqdFdLUVZDcmZtbjltYnFxL3FjMWRtd3VN?=
 =?utf-8?B?RHFoNk9pSmNKWW9SYStRZWlrN3NLcnpXTXYrdTNGNWdEazV3cWZKbzA2VFN0?=
 =?utf-8?B?bko1ZWs0aTJHTjk1S0VGZDNSRm14c2pyMkFiR0JRNVg0cEhIeVZzbW11c0wv?=
 =?utf-8?B?c0JOVGFBeHg3UnlaUEwwNkQycHdQcTd2R1pqeWhhZ1hnRnZvQnczUXFKQ3or?=
 =?utf-8?B?S2lTV3BSa0MvN3V2Ynk1Y3VLbitWSExzNWtlYjhPalZReVBnemZMSXRQbFpD?=
 =?utf-8?B?ZXRhNVNNN0dOd2ZtbzdJeGFrTG5iYmZuNjdXV3NlSHBOS1I4UUpEK3hKdlJw?=
 =?utf-8?B?U2pUQ250NFRnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6ab4e0b-17e3-4bcb-be81-08da078cdff3
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2022 20:38:06.9967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JRnfNL2ENcg2VynMuVojMtDypYEtoGU8oBOivyvj8uXIP5pVEmEmeMnF+RZ7hx0l2wCGl6KfDcsSl75DkWvaajNme12iJf/dszbrCUQ5oKs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5251
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10288 signatures=693715
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203160122
X-Proofpoint-ORIG-GUID: xPQQvpPDBAo51ONhUVc2lS4FWwXT_UVf
X-Proofpoint-GUID: xPQQvpPDBAo51ONhUVc2lS4FWwXT_UVf
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/16/22 16:36, Joao Martins wrote:
> On 3/15/22 19:29, Jason Gunthorpe wrote:
>> On Fri, Mar 11, 2022 at 01:51:32PM +0000, Joao Martins wrote:
>>> On 2/28/22 13:01, Joao Martins wrote:
>>>> On 2/25/22 20:44, Jason Gunthorpe wrote:
>>>>> On Fri, Feb 25, 2022 at 07:18:37PM +0000, Joao Martins wrote:
>>>>>> On 2/23/22 01:03, Jason Gunthorpe wrote:
>>>>>>> On Tue, Feb 22, 2022 at 11:55:55AM +0000, Joao Martins wrote:
>>>>> Questions I have:
>>>>>  - Do we need ranges for some reason? You mentioned ARM SMMU wants
>>>>>    ranges? how/what/why?
>>>>>

An amend here.

Sigh, ARM turns out is slightly more unique compared to x86. As I am re-reviewing
the ARM side. Apparently you have two controls: one is a 'feature bit'
just like x86 and another is a modifier (arm-only).

The Context descriptor (CD) equivalent to AMD DTEs or Intel context descriptor
equivalent for second-level. That's the top-level enabler to actually a *second*
modifier bit per-PTE (or per-TTD for more accurate terminology) which is the so
called DBM (dirty-bit-modifier). The latter when set, changes the meaning of
read/write access-flags of the PTE AP[2].

If you have CD.HD enabled (aka HTTU is enabled) *and* PTE.DBM set, then a
transition in the SMMU from "writable Clean" to "written" means that the the
access bits go from "read-only" (AP[2] = 1) to "read/write" (AP[2] = 0)
if-and-only-if PTE.DBM = 1 (and does not generate a permission IO page fault
like it normally would be with DBM = 0). Same thing for stage-2, except that
the access-bits are reversed (S2AP[1] is set when "written" and it's cleared
when it's "writable" (when DBM is also set).

Now you could say that this allows you to control on a per-range basis.
Gah, no, more like a per-PTE basis is more accurate.

And in practice I suppose that means that dynamically switching on/off SMMU
dirty-tracking *dynamically* means not only setting CD.HD but also walking the
page tables, and atomically setting/clearing both the DBM and AP[2].

References:

DDI0487H, Table D5-30 Data access permissions
SMMU 3.2 spec, 3.13.3 Dirty flag hardware update
