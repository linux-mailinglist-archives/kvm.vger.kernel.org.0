Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0074A4B71FD
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 17:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241276AbiBOQBy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 11:01:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241192AbiBOQBn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 11:01:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68204D1097;
        Tue, 15 Feb 2022 08:01:10 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FEi1wA027349;
        Tue, 15 Feb 2022 16:00:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Kc3P29bjIZa5+NzVf50OuitZwWM3RLoIMiMfXhTYpww=;
 b=XUb8Rrcili4MVqmrYr1YLlsOKstW3jZPLAsll2Y/wILqX/hDb/2Y/4anca68b1DaXrXv
 /hFuxU4TEaydQMMhdkJwx2R8d/qKZO0VD+k35YsdUxOKv7sZ3NwtwkN72mKRb2uSpAV4
 XeevA9JAzYk1iK3eC09egvwPYXv4TpuxTsUR41s7VkR4VF5FyiY9va4Bx582PmLo4ALS
 zaaE9ZaCltg1dk6eKfYtmppTLUrYoXq5GAat/sXAEs5G+BzKVyIFzO1rHu2pB4pFt0Ox
 sVas4NzUqIQ8HDw/w26uFgmzHXPX2SGLWopWhfFtJk/A5QOPEwc0FPiGW6DEZSnHFKI5 oQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e820nj6ge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 16:00:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21FFpKWF167500;
        Tue, 15 Feb 2022 16:00:46 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by userp3030.oracle.com with ESMTP id 3e620xatrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 16:00:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OLVMhotk33dPVGvjouI6qduj/Fe7dGEwXWhVXTpKCVdjTh2yCo23sj34cK/wM8jX8q0lYk8FrBfCpiGnw7h/NhZeV1pvU513WN8wSRswKUBrPpozAOKljY5oTgCNdBdmY2Wknet6VOWSCKBNPk0z6dP4t6oNbWuIJ0hMz6wJRQf+z4sywv+OerBefPBxkguqwu00ocFSOmObwCSudQvrJsTWMGkExjvPSZxmnZVFihmqhWMcEnwmKwHTqVLdKH5ZStyqWH08bU0uc/btdPCrtIuVMv5PzFBsXl4yDfLD4/ltc9VZ4zH7TwfXlMeIgBHYBnbdg7dIfYfEgeTTJwrYPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kc3P29bjIZa5+NzVf50OuitZwWM3RLoIMiMfXhTYpww=;
 b=C7GZ81y2PpsEY0INormmX50lBwbIuKc0W0dLiW1WN0G0QvGQtBUwtQ69jpfBEoD3Qf6gixBof8n5EMwAvBlzV2/GxVWVVfIVqIr7dgs2Om2txq2dmOgsGC2n7TcbWSpmUfMkSnZoIAbVLJ02/F0JTChCtlrWOrLNsMPw9x75bYDtMfln6Z/d1Ch3NBgIQZEn28mb//23UjpRiL2n2WEzfhaMY7Rod3cbXzdGVYHVXv+2aD4O9c442BQkEcNwBL5l2YV8WnoAwI30UNHPHqwGd8QgbTIuW1bfE0vsQMnqXEwuHw96p5jM54mDSM2ir0JKlRyyTsXqrw6kMK+SXfTHqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kc3P29bjIZa5+NzVf50OuitZwWM3RLoIMiMfXhTYpww=;
 b=voPUdS1EC9e8qwwsCjc4F7sTslr+s2n6zOurUMWUt32AgEI4WpMRlyKPckrsxy3Pmm7kSjnA1IplxZbYfxkxW5I9yJXsQMjXB1dfA/li1emN4UF3VIrfqQsTskoul6svRvsLNglo+yc4UkVooXW7Hmj4z9m3JFRLbFZHog+qMcI=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BN8PR10MB3460.namprd10.prod.outlook.com (2603:10b6:408:b4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.14; Tue, 15 Feb
 2022 16:00:43 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%4]) with mapi id 15.20.4995.015; Tue, 15 Feb 2022
 16:00:43 +0000
Message-ID: <6198d35c-f810-cab1-8b43-2f817de2c1ea@oracle.com>
Date:   Tue, 15 Feb 2022 16:00:35 +0000
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
References: <20220202170329.GV1786498@nvidia.com>
 <c6c3007e-3a2e-a376-67a0-b28801bf93aa@oracle.com>
 <20220203151856.GD1786498@nvidia.com>
 <e67654ce-5646-8fe7-1230-00bd7ee66ff3@oracle.com>
 <20220204230750.GR1786498@nvidia.com>
 <0cd1d33a-39b1-9104-a4f8-ff2338699a41@oracle.com>
 <20220211174933.GQ4160@nvidia.com>
 <34ac016b-000f-d6d6-acf1-f39ca1ca9c54@oracle.com>
 <20220212000117.GS4160@nvidia.com>
 <8338fe24-04ab-130a-1324-ab8f8e14816d@oracle.com>
 <20220214140649.GC4160@nvidia.com>
Content-Language: en-US
In-Reply-To: <20220214140649.GC4160@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR07CA0063.eurprd07.prod.outlook.com
 (2603:10a6:207:4::21) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0d92eb8-4951-4dec-fb20-08d9f09c5240
X-MS-TrafficTypeDiagnostic: BN8PR10MB3460:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3460B0844DF3773D73CE9F5ABB349@BN8PR10MB3460.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5EfjL+DHQNrFLa1z2pkRWDdAaTiwC35nWkHulmb+hNcTByJCLmgk0m33n7hVeKZDWH31bcewc+wwFihPscqaDVSXDefoInFDQrUcDVAvW5Ihkcurr65sabciCNVM0tk2LOHZuiE8U5gW0AI14ocX/+mcOXSJvvaoptxF4zBj1TV5h6E1ff2oa8+4aO/KKFfn/ZA1mzz1ZgqS2NG+cP3UKO3vXEwVu7sXZxyMe6bvY14AtB+/nTJTfsqtuIVQsp3PK6HYv5qlmCK47Mi+nnn4j/NJ41T5Dj0ExGEYOHj/WYSRmsaxRTsx9MLl6xwCYgdaWzmI+H8h8VfRKs1VpoKuLXBerXkgJYq2z/F3qZqkiMQW37+dYKI0pUaR/1ShZR92eUS3IjIhpc7uUcOBEiWS64kHfWkC4M+Y6QrfQc6DnfEqXT+yfRR68fpMpVAHp5Met5dTxqVbxcfgi08njyaOgX7LJWB1toa/t8OIlIae9rEYCqDPyQpGhbkR9sTKrQ6vqoCgAbMQ0GefshC16p3xrFpaLZNiVB2lt/iU5CqnE97s7ofMcsvM6Mv++syBXEoG84+Kq+/QCwdV5Go0hOP+lJj/tG7S0kLGxo/R2wbR/Fd5ks9DYGYUbgFxUfU3JmBJSOLFVYkfaruOQtGhap7NqoG7nVz53OSYL6mSOUPstPAzr3jYvqP8uOXODANZuB8sX3h1d2lUmpBYPwKgZ12vAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(26005)(2906002)(6666004)(8936002)(6506007)(6512007)(186003)(66476007)(83380400001)(53546011)(7416002)(5660300002)(508600001)(66556008)(66946007)(6486002)(38100700002)(4326008)(8676002)(316002)(6916009)(86362001)(36756003)(54906003)(31696002)(31686004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWE5VXVnbWdIWjlpRVh3Y0JtUVlKeVpURDZkK2gxZ3FlcUYzZzhqbkRURWlu?=
 =?utf-8?B?WTVqaU5nYy9FNzAxUjVMYU5OeFBKOGNLMXEyM3VPa3lIaEYrUEhtVnErbVZl?=
 =?utf-8?B?a0JhQkMvUGt3d29yM1RGUEFEaGtLdzZxNlhHSlkwajYrWTdqdVBEa2o3ZGtG?=
 =?utf-8?B?VDQ2Wmc0ckR4TUVnK1NleENxUWR4V2d3bERNL1JNK1dsOWdMY2ZzVHJCNDlu?=
 =?utf-8?B?TUE3eDczekJvbnp6alpGNS9LMnBrcUFGcXAxSnNkeWVxUHZiZ1h0VXZ5QjdN?=
 =?utf-8?B?bTJkR0NTYWJsUE82bDIyNXR6eXZZM29CY3NVNzV1WWtMNjJ1Y2QxWWlRcFc3?=
 =?utf-8?B?UTcwRWlHNjF4b3ZzdEd5dXdqNDVXUUZndzlGcXBpNVpERTVpR2xuTkdha1dn?=
 =?utf-8?B?d2Uwbm55dC9NT1ZyN3krY3BqcHhlaFdDSThqRFdnMlhjalB2ZkgwTkpXZjRG?=
 =?utf-8?B?MmZQOVVRUkZyV1gxYUU3ZXl4ejBKd0V0aXJxeElDVjVGbjFzNzMrc05uMVJ2?=
 =?utf-8?B?ZVRqVHpQNEV3WWFydm9CL2Y4ZnZ4eUQ5ZlZXajRyWVM3RGwwcWNtMVpDdUFs?=
 =?utf-8?B?ZmUzWmNzRWc5K1lYdGVlek1YMDRLelhtU2JUMFVwT3c4b3hWL1BWOFJrb2Fs?=
 =?utf-8?B?aGQ3TGROd29pQmk4TFNzc2FtdWZPZzNZdTI0TVhKV1NGdVF6bnd3L3J1KzN5?=
 =?utf-8?B?dE1SZGZNU1ZibnQyaVk5bjFFTkJaclRlYmc2SmtsNm9VbnpjWXQwOTNFVnEz?=
 =?utf-8?B?cWJKVkd6Rk50RVAzU3pTc2laVFNhQ1BpdW5rL2t6YVphMFVhQ3N1UUZIZlJP?=
 =?utf-8?B?U2FjNEpISThBVVhoa2lubkFYTzNYL05QTG1UV0FyM3ZpSkdiR3hPZk1sS1BH?=
 =?utf-8?B?UnpSSnd0ck5jRHVOL3U2NTc4dTQ5YmQ5ZWhDa1MxdTAzUUIweElseEMvblZi?=
 =?utf-8?B?VlBZVThtcjZYNWRiZGl2bWxQdmZ6bzFwOHE1eHhsK0pDeWQ3ckIzaVo3eFJw?=
 =?utf-8?B?ZS8zTG5jSWR5VTZVLzBzM1czOHVvdFUrdkFyOGkxcExxem1BMXRBS3ZnNlBR?=
 =?utf-8?B?UXNQWHh5TFpUYms2WU9sbDBDM2lzOFIxSlpRby91UkJYMjBPYkVieHNpVURZ?=
 =?utf-8?B?ZlgxYWJuRy9ubk9iNzcvbStzY2JFdk5ZY2tJaTgvSjNEZXM3TE9RT1ZmeXNM?=
 =?utf-8?B?alBSM0pwTHJrTStSTUVTNEJya2tFOVlnOFdZa2gxd3Z6dkNSaU5GVFVCTE5B?=
 =?utf-8?B?SHZUNks3ellHb2duZHVMU1lKcHIvZXNid1Nrc1F2eDhVamRHbGtvZWRZT2pH?=
 =?utf-8?B?VTF5NWdUUDZ0SlFQL3BIY2J3VnhPSllMaWJCMkNXUkx2bWtCWU5seW5ybGw0?=
 =?utf-8?B?T09zTGpkdFdtQnhvMUpxa3RyZThib1RzNC9TQXkvOVdQdXVleFhYT21HK0p6?=
 =?utf-8?B?NEgvYWVGaGxMbVFDYkhxSHRxWTByU01lK0x5MFQzNS9hR1dlSUp5MVVLU2lS?=
 =?utf-8?B?MUg4TG0wWkgwTm1qcFVzaHYxaUFLZzRkWFdxMmhZZG9CR3dkVld4eWdVcXlB?=
 =?utf-8?B?ME9CeVhQTFF1bnRIS2EyMGk4SDNqSjJmSkJMMmRvckY3MEZFT2hzY0FLZmpM?=
 =?utf-8?B?ZHZha0NsT0o5WU9neDJDeTNNRHFmS2pWeW9uM0JDZ1NPeVB4WFR1K1Fpc2tp?=
 =?utf-8?B?U2ZzVkwwV1dMWDgxTHNlK1IrTlRzS05TT2pTaWp3dmZ1ZE83bHRyYlpaUDdK?=
 =?utf-8?B?Vk1FVk91RDFRemp4Y1J0MGwzdkFUY3liZ2g2R0syWDJnLzE1RGdWMFIrM2FO?=
 =?utf-8?B?SXptSitsdmhVU1Y0Sk9LOEc2anVGWXFWcUJtYUFvSjZyRmhVK1ZEeUxGQTJG?=
 =?utf-8?B?MGQxVTdFN201T0tFYndka1NKdkI5YWZrSHlSZmJlSk1FQkhONzZtOVdjdURj?=
 =?utf-8?B?d1BjdlVDZDRycnYxWGNLcDI5dTFwSHNVeUVRYXVocmE1RFlQK28zSGFZaDFW?=
 =?utf-8?B?aFVxeWFFV1pMQnBEYjRkeFo5dlQ2NzNpN0phcEtVbEdLRTJiNU4vYTNwMm1s?=
 =?utf-8?B?K3NFMDlaM0h2MEFBdUxCOVduTWFKNG45L3JWelhZdFhSem5iOVZlbzBvaS8y?=
 =?utf-8?B?T0F2TkJyN1MvV0h2VGs5dTVJYU0rU2FwTFl3ZStZblozVjdoYzE4dnVHRGdT?=
 =?utf-8?B?a1N0UE94SGlTT3BhYlhjdnAxa2ZVVjMxOEp4aGhaUUF2S1F5UXgvM0ZxQTda?=
 =?utf-8?B?WkVmWHBYRWtQRHBpQ1pLK2pRdnJRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0d92eb8-4951-4dec-fb20-08d9f09c5240
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 16:00:43.7221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UUXcP3wrclo4WEB+WK1PsWsDtYQNmmyMZ7o+M7XH2qmYKg2jK7fjZZsi7rfLptgxOVrj29HN2DKVJ5xH9Codkmj0GVLW29+jDCQPM64Ms4k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3460
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10258 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202150093
X-Proofpoint-ORIG-GUID: aVv7FXsiRttlgkiL8xa7WzX8348GKnI9
X-Proofpoint-GUID: aVv7FXsiRttlgkiL8xa7WzX8348GKnI9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/14/22 14:06, Jason Gunthorpe wrote:
> On Mon, Feb 14, 2022 at 01:34:15PM +0000, Joao Martins wrote:
> 
>> [*] apparently we need to write an invalid entry first, invalidate the {IO}TLB
>> and then write the new valid entry. Not sure I understood correctly that this
>> is the 'break-before-make' thingie.
> 
> Doesn't that explode if the invalid entry is DMA'd to?
> 
Yes, IIUC. Also, the manual has this note:

"Note: For example, to split a block into constituent granules
(or to merge a span of granules into an equivalent block), VMSA
requires the region to be made invalid, a TLB invalidate
performed, then to make the region take the new configuration.

Note: The requirement for a break-before-make sequence can cause
problems for unrelated I/O streams that might use addresses
overlapping a region of interest, because the I/O streams cannot
always be conveniently stopped and might not tolerate translation
faults. It is advantageous to perform live update of a block into
smaller translations, or a set of translations into a larger block
size."

Probably why the original SMMUv3.2 dirty track series requires FEAT_BBM
as it had to do in-place atomic updates to split/collapse IO pgtables.
Not enterily clear if HTTU Dirty access requires the same.

>>>> I wonder if we could start progressing the dirty tracking as a first initial series and
>>>> then have the split + collapse handling as a second part? That would be quite
>>>> nice to get me going! :D
>>>
>>> I think so, and I think we should. It is such a big problem space, it
>>> needs to get broken up.
>>
>> OK, cool! I'll stick with the same (slimmed down) IOMMU+VFIO interface as proposed in the
>> past except with the x86 support only[*]. And we poke holes there I guess.
>>
>> [*] I might include Intel too, albeit emulated only.
> 
> Like I said, I'd prefer we not build more on the VFIO type 1 code
> until we have a conclusion for iommufd..
> 

I didn't quite understand what you mean by conclusion.

If by conclusion you mean the whole thing to be merged, how can the work be
broken up to pieces if we busy-waiting on the new subsystem? Or maybe you meant
in terms of direction...

I can build on top of iommufd -- Just trying to understand how this is
going to work out.

> While returning the dirty data looks straight forward, it is hard to
> see an obvious path to enabling and controlling the system iommu the
> way vfio is now.

It seems strange to have a whole UAPI for userspace [*] meant to
return dirty data to userspace, when dirty right now means the whole
pinned page set and so copying the whole guest ... and the guest is
running so we might be racing with the device changing guest pages with the
VMM/CPU unaware of it. Even with no dwelling of IOMMU pagetables (i.e. split/collapse
IO base pages) it would still help greatly the current status quo of copying
the entire thing :(

Hence my thinking was that the patches /if small/ would let us see how dirty
tracking might work for iommu kAPI (and iommufd) too.

Would it be better to do more iterative steps (when possible) as opposed to
scratch and rebuild VFIO type1 IOMMU handling?

	Joao

[*] VFIO_IOMMU_DIRTY_PAGES{_FLAG_START,_FLAG_STOP,_FLAG_GET_BITMAP}
