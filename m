Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2CC24C4E83
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 20:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234556AbiBYTTw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 14:19:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233961AbiBYTTt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 14:19:49 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC91A194171;
        Fri, 25 Feb 2022 11:19:15 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21PIiYKp010544;
        Fri, 25 Feb 2022 19:18:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=G66/8SdIIPM5HuZ10obpk+Y6C4FrTuXV7QUV4Ya0FwE=;
 b=C9/6S5iJgR39aOkMKd8PH61oQ0xV4yiiNgXTliigUs0rTah68pDKXFe+Xadtnml617h4
 rIoUNXQzk2kVTlm+aOIlf37epW9dsxnZPkPvqds1B39/SisYYoORNdhpbAUwYx4CmzFv
 CsJJe5VH2UVpcimkLDVnfH9V2SxLMuKkRLeuJ5zOrql1T2XA3ozkWsjtWiFszTfYm9+T
 Mb8TLMr/t/LOlgtsDGOeMMRmL7/5PLJn+bO5Busu+5szlw6kv5d7boEtH7Lzynddu5nl
 QJGa6ZZ4sA0eIlMTniYGELJGNRtybXCn+m+ybGLoVZPzy6QPo85sls9P8rPZOPQp/ius pA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eey5dhnkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Feb 2022 19:18:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21PJ55A8054225;
        Fri, 25 Feb 2022 19:18:52 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by userp3020.oracle.com with ESMTP id 3eat0sd4nn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Feb 2022 19:18:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aHAJEYXDaj2mGS1vZZfrJ90C9EMBSfco8gmaBcDHdd2Ry2jcJMhPZosF/nw95w8HU3EuphxKuhW2YaQY/ho35oLWe7acjzg30lMnlpQYkEqOrlPrvFbOWdLrPwyOH9vzblXrNhnHmMt42LD7e2jhXE5ZyTzRGUJJO3hF5ZDTsDGNcPw09pFrb1zYA3TUyCZp5csCHEnmeNpdiZYetxtf11Ay/cZ3JocAq5fAJNwcryJoslILyFLdq3ebUJwjMOlAYM5Jq/v3RbjH/y6tf8KFB2gx42jx7LIiC4zDZOuT5kX0Xf1HRDOrDrN/VSiehK8FRCizCrf0AjRUBba4PUwL/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G66/8SdIIPM5HuZ10obpk+Y6C4FrTuXV7QUV4Ya0FwE=;
 b=fK7WYfDCJmNlmUU1FUyF4M4dVqbz8oC4Lpn95Y/MIvYH1GcFJrkGN7FgbgbG7P53wFCMzwiV9MnucIt8QqXeqVAjaMnyvBXQmUEe8KrvafBcXseN07KjfRyVJn9lAsUIheO6bmuvLYJ6hEAA+uZwYeKBgIJw9SZLO3TMQFJAlNR1R57nGCveB9dB+MCBiYVY8mJnHzmNLe2pU5zkdHxRLQH37OLUoVWC/jxG7hcDmC6+8KvSf4U39vTMOt0ik4OH5D/1cv4Peh8q5KkmL1R1NXCzFq6jSKOdylvSJT0cNfULfe/XkpwRaTFenXhGxx/mPwMDVykR4CgAYuC99MLDCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G66/8SdIIPM5HuZ10obpk+Y6C4FrTuXV7QUV4Ya0FwE=;
 b=Yjr0L2ikytAQ2DaFNao/bno0PMTunESVdkjJQYZBRiwLTaKv2/BQtvna1U+f5wIaGGNtxufQx42QYnC/lEWT/ZwFm6Uf1UyUWueDoSWkGPrlBiBWGTEC6Fm9ey9z+vIUTGtcJPSMYiYBdZCCmUnvizJoF0+BDMw1+dVoApH1Vtg=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MWHPR10MB1581.namprd10.prod.outlook.com (2603:10b6:300:26::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Fri, 25 Feb
 2022 19:18:47 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::750f:bf1d:1599:3406%6]) with mapi id 15.20.5017.026; Fri, 25 Feb 2022
 19:18:47 +0000
Message-ID: <e4dba6f8-7f5b-e0d5-8ea8-5588459816f7@oracle.com>
Date:   Fri, 25 Feb 2022 19:18:37 +0000
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
References: <20220204230750.GR1786498@nvidia.com>
 <0cd1d33a-39b1-9104-a4f8-ff2338699a41@oracle.com>
 <20220211174933.GQ4160@nvidia.com>
 <34ac016b-000f-d6d6-acf1-f39ca1ca9c54@oracle.com>
 <20220212000117.GS4160@nvidia.com>
 <8338fe24-04ab-130a-1324-ab8f8e14816d@oracle.com>
 <20220214140649.GC4160@nvidia.com>
 <6198d35c-f810-cab1-8b43-2f817de2c1ea@oracle.com>
 <20220215162133.GV4160@nvidia.com>
 <7db79281-e72a-29f8-7192-07b739a63897@oracle.com>
 <20220223010303.GK10061@nvidia.com>
Content-Language: en-US
In-Reply-To: <20220223010303.GK10061@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0075.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16eb4b77-96e3-4c06-1585-08d9f893a55f
X-MS-TrafficTypeDiagnostic: MWHPR10MB1581:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB15813FAD5523D30A154BDF21BB3E9@MWHPR10MB1581.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AAIzRSLZyZaAyaM+SgEQigzPq9z4YgRT6OBJDfIhMTFrZGRkFrVegFD/hOlJIaE70O/ado5WW57dOfT/ynPQ+qZa9rDf1Koq8WNhPAiyHBr1tomiN3jiBryujBryhTPqcGOqzrB7k4hASpOINVlDLJNmmkLokhjndVNfwqsfMAT7jG/NU1YdXEyEOTWo99hBXV2cQzD8LXK8AaUsEI5HMNI8F2HkhpCVHoV15ETxbPCqQhdXNMI8E4GX/Aj/cBlgmUYj7TNR3nQvp/D9jWN/YNqxi57h8AdWhFsAaSqWfzKyqOCdG0dgs3EDbSP884TUraAjIGnNE9KpQnEUT01don4PqyLQl65HXE0K6DmDNNQFRzIBZsbb7GdurNZzCtRP1MXAPGSFpcCJVUS+Iux6gAThQqLYlgiV1dYXHJo5BN5pmnCX7AMSz7heoKHW1Mq35vZyoh2upekNQZVnDZowF2zQJdddv5iNGvwJZl2vS2Nja/QGKig2EvJZtuEUInczg7SM42K9PBhNao/WEKghYngNnED8qrkxLYaXi+0HV2KNHR0u+D59yB8Wza/O6zojNcbABx3BeGCpbYj1Z0LMupAAbnnDpE6MeoOTiFeENyn/Dz7I03JsJzrlGD1jPoZUYVT1cRc1o/vTxA+07iAJc/YlDLMBCJ+bisgNUS5CCJLb72MPrl3X0oJmJe6iFqgyZzTxHzg0aVm8eWwZKZUDRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(8676002)(2616005)(66946007)(66476007)(66556008)(2906002)(508600001)(53546011)(86362001)(6666004)(8936002)(7416002)(31696002)(6506007)(38100700002)(6512007)(5660300002)(6486002)(54906003)(6916009)(31686004)(186003)(26005)(316002)(36756003)(83380400001)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c3BFOXByN1ZvYkNCTHVHY1ljdlJyWmxNL2tBcDlhYzBEcmJGY29NTjNMYlNm?=
 =?utf-8?B?WFRYekJyWm9yMUVVeEZyTVlpalZhdTJ5a21TK1JXK2VOU0RYcjV0QVplZi9N?=
 =?utf-8?B?OWFKaVZhWWc5OU9rWWtqVnBIYkQ4N01abVNhUE1qSk9NNkR0NmVKakZMaENy?=
 =?utf-8?B?dFR5UjhPYlhKangzTDZ0U3ptSFBGbDRuajNkT0FjWG54WTJNN2FYNStaVjN5?=
 =?utf-8?B?WGVpdkRNTDl3ZlhwZkdpMGVGTVQ0bmNwa0x6R1ZPSUhJQnpUNkE5bmZla2Vo?=
 =?utf-8?B?RVlvSTNMYzg4dmo2UkVhU0cyNlIxRzNzYjhCaGNkNWNMbEZZcTdZWE5RdVlt?=
 =?utf-8?B?aWYwOUt1THRFMTB2ZE9FeE9oTzY0MHplWU0rUFo5Yll1NWNRKy85Zm1WZi9K?=
 =?utf-8?B?OWZoTHhwcFUrMzQvdGpqcm8rNWRTZ1B4bkNXemhvNVpkSHdRUUF2dDR6Q0Fz?=
 =?utf-8?B?YU1hVWRxZTRKM2xpb3hUL3krR1lib0x5S0pGTGV0VTZvN1dWUzVBcENtaTNT?=
 =?utf-8?B?dHY4dHgveHJnRFpIZjJ5dkdUakRhSWtZd2phd0lzN2xINDdkd2ljSjRpbjRm?=
 =?utf-8?B?cXNINnJBdHFGcFJ1TDFFdVhJZjQ5SUxEM202YnAxV0d3bmc2MENvQWhvYWU3?=
 =?utf-8?B?YXh4M29mR0Q4R0xLaXdnbW53eDJuNWEyeWpGSGZIc1NISTBVTThsakp5aVUw?=
 =?utf-8?B?S3Nmd2dRUXY2cFkyK1BLdDYyQmg2NEc1TXEreUhyWkNhWWh3RXV6cFRFRXZr?=
 =?utf-8?B?a2dnOUFjcERGN3FiSkdLN20yUTdER3Q3Qi9lblZCS01IRk9pSjFBZkkzSU5S?=
 =?utf-8?B?TUg5TElCSEFuMFlPM2xodS95VDQyU3lYdzVjemRYQ2hhNmlLbjFhc0VOVlhG?=
 =?utf-8?B?V1hiRmJTdkZIQXBQL0NYZUM2MG43dEw3ZmQ4a2FCaXVabFFhOGFqd3FyaG1I?=
 =?utf-8?B?aC9IT3VoUHcyMGVnUDlFU1pqUFJua1hMTDdma1ZLTitIZVQ1MXFKV3NtU3V0?=
 =?utf-8?B?c05iTzR6OUQ0U29CeE4vMzFvcFpUMVRRT0d2b2dQc3NNazJkNVAxYkxOanVn?=
 =?utf-8?B?ZDVOQjlPRDkxWkFQYUtpM0Z2SHJXcjJHTFJnU2hVWWJSZTBSS2RMNDhJVFNJ?=
 =?utf-8?B?ZUR3dzU3SVQ2SDBkclVpdmV4NkVkcWdNZ3RaV0hkU1IvNHQvT1E5RnBPR0hh?=
 =?utf-8?B?Y25QZ2FYQTlzK2toYi9xcCs5ZUd4bUxIV1hrNTZUUWVkaFpvRGJtM2pIMzUr?=
 =?utf-8?B?SkRqY3ZKQWFDeHVjSTlCT1JBNHFXM3NLNCt3VGw2K1k0L0RTRmd5Tzd2akly?=
 =?utf-8?B?VWhRR29TUHJEdTFJdlhsWXNnaGxaaUx3L3pmUXhjNEFUMHo5OTN5RUxsMkZy?=
 =?utf-8?B?VmRqaHJUTGFXd1dkUWdINEdFZUpEZFRRNlJqblZOUk9nVGdoRjRDMlNjMHly?=
 =?utf-8?B?Z0VYR0lOWlFnVzdtNlY3L2RTRCthdTZsTHVYakJLOTFTQmowSjRzS2ZpVExj?=
 =?utf-8?B?SHNsY1N3d1JnQkZ1SWMvcThUOE9BNEdxQ1FVa2dESU5Ga05kaXNXaWZPakd1?=
 =?utf-8?B?cXNoSlZjdi9jLzJBcExmUWFqZFNFLzBIZ0REaTBUWTF0czRSYTFXOVNFRXNE?=
 =?utf-8?B?aVBCMmVkNVBHdmtJZ1hMSG43MWhTNmp5NUZqYU11YVFPdEU3SWZxYWVlTFRL?=
 =?utf-8?B?cER1SnB4b3gwUzBxcnVNQm1ZYXJ4TnlHa25ESWZyWE1VM0VuYTJYaThRRysz?=
 =?utf-8?B?OTJteVBvb1pXZ0pkZDdsa2lLaS9XZ1BBWW9aVFJlNkY0Tyt4cUhBc0ZRZVIw?=
 =?utf-8?B?d3IzRW9SWDJkYUlJYkIwV0oyQUhXZ2NtZFQvUWtFTjFRZkM1Q2NSd0syYXN2?=
 =?utf-8?B?ZjJYbzVZV2JLWWFoUGo0UStoV0IzRG5KTE16b0wzOHYrL1ovenJ5a2Q1dGx5?=
 =?utf-8?B?Vk54Ull1bEZCYjc5OGNSMmwwLzFTNzJGRmIrMGF0Q3ZyYXdMeHpQYlkrenNP?=
 =?utf-8?B?TFBHNmw5U3VSaXdHZjJDbHR0RjRnSHFPQ3RodEF1eXltWGtuZ0k5ZU1uOE5C?=
 =?utf-8?B?bFdGS0ROMFBXQk1heXlVZVM3RWVlVjlvYTJMNUFaWmZ5WGpnMWF5SVRyYTE3?=
 =?utf-8?B?MlRHZjNJMXo2K1lnTkRsTEQ2WnZMRTNYWm9Ka2VOeVgvRmRNTkNoemdTWk9x?=
 =?utf-8?B?OXpyU3dnTHJhK2ZxY2dKM2Fua2N6eFZIblZZanJkb1hKQm51NStqSk9nbW5s?=
 =?utf-8?B?SE1oa2d3RCtLLzlyeUtvSTZYSk9nPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16eb4b77-96e3-4c06-1585-08d9f893a55f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 19:18:47.3925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j8BMmTiK6mjLnh/D9IBltyjbfkyrVv3nd8IMgyuYcZHRiNqvp9zltiQSxOLuNNieWOP5XucIUwbhTi01gciXV349wrEr38lV9riosuL7H3c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1581
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10268 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202250109
X-Proofpoint-GUID: kJfIargiKJ35Itg0dFfYOsVgQuiapZ5R
X-Proofpoint-ORIG-GUID: kJfIargiKJ35Itg0dFfYOsVgQuiapZ5R
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/23/22 01:03, Jason Gunthorpe wrote:
> On Tue, Feb 22, 2022 at 11:55:55AM +0000, Joao Martins wrote:
>>>> If by conclusion you mean the whole thing to be merged, how can the work be
>>>> broken up to pieces if we busy-waiting on the new subsystem? Or maybe you meant
>>>> in terms of direction...
>>>
>>> I think go ahead and build it on top of iommufd, start working out the
>>> API details, etc. I think once the direction is concluded the new APIs
>>> will go forward.
>>>
>> /me nods, will do. Looking at your repository it is looking good.
> 
> I would like to come with some plan for dirty tracking on iommufd and
> combine that with a plan for dirty tracking inside the new migration
> drivers.
> 
I had a few things going on my end over the past weeks, albeit it is
getting a bit better now and I will be coming back to this topic. I hope/want
to give you a more concrete update/feedback over the coming week or two wrt
to dirty-tracking+iommufd+amd.

So far, I am not particularly concerned that this will affect overall iommufd
design. The main thing is really lookups to get vendor iopte, upon on what might
be a iommu_sync_dirty_bitmap(domain, iova, size) API. For toggling the tracking,
I'll be simplifying the interface in the other type1 series I had and making it
a simple iommu_set_feature(domain, flag, value) behind an ioctl for iommufd that can
enable/disable over a domain. Perhaps same trick could be expanded to other
features to have a bit more control on what userspace is allowed to use. I think
this just needs to set/clear a feature bit in the domain, for VFIO or userspace
to have full control during the different stages of migration of dirty tracking.
In all of the IOMMU implementations/manuals I read it means setting a protection
domain descriptor flag: AMD is a 2-bit field in the DTE, on Intel likewise but on
the PASID table only for scalable-mode PTEs, on SMMUv3.2 there's an equivalent
(albeit past work had also it always-on).

Provided the iommufd does /separately/ more finer granularity on what we can
do with page tables. Thus the VMM can demote/promote the ioptes to a lower page size
at will as separate operations, before and after migration respectivally. That logic
would probably be better to be in separate iommufd ioctls(), as that it's going to be
expensive.


>> I, too, have been wondering what that is going to look like -- and how do we
>> convey the setup of dirty tracking versus the steering of it.
> 
> What I suggested was to just split them.
> 
> Some ioctl toward IOMMUFD will turn on the system iommu tracker - this
> would be on a per-domain basis, not on the ioas.
> 
> Some ioctl toward the vfio device will turn on the device's tracker.
> 
In the activation/fetching-data of either trackers I see some things in common in
terms of UAPI with the difference that whether a device or a list of devices are passed on
as an argument of exiting dirty-track vfio ioctls(). (At least that's how I am reading
your suggestion)

Albeit perhaps the main difference is going to be that one needs to setup with
hardware interface with the device tracker and how we carry the regions of memory that
want to be tracked i.e. GPA/IOVA ranges that the device should track. The tracking-GPA
space is not linear GPA space sadly. But at the same point perhaps the internal VFIO API
between core-VFIO and vendor-VFIO is just reading the @dma ranges we mapped.

In IOMMU this is sort of cheap and 'stateless', but on the setup of the
device tracker might mean giving all the IOVA ranges to the PF (once?).
Perhaps leaving to the vendor driver to pick when to register the IOVA space to
be tracked, or perhaps when you turn on the device's tracker. But on all cases,
the driver needs some form of awareness of and convey that to the PF for
tracking purposes.

> Userspace has to iterate and query each enabled tracker. This is not
> so bad because the time to make the system call is going to be tiny
> compared to the time to marshal XXGB of dirty bits.
> 
Yeap. The high cost is scanning vendor-iommu ioptes and marshaling to a bitmap,
following by a smaller cost copying back to userspace (which KVM does too, when it's using
a bitmap, same as VFIO today). Maybe could be optimized to either avoid the copy
(gup as you mentioned earlier in the thread), or just copying based on the input bitmap
(from PF) number of leading zeroes within some threshold.

> This makes qemu more complicated because it has to decide what
> trackers to turn on, but that is also the point because we do want
> userspace to be able to decide.
> 
If the interface wants extending to pass a device or an array of devices (if I understood
you correctly), it would free/simplify VFIO from having to concatenate potentially
different devices bitmaps into one. Albeit would require optimizing the marshalling a bit
more to avoid performing too much copying.

> The other idea that has some possible interest is to allow the
> trackers to dump their dirty bits into the existing kvm tracker, then
> userspace just does a single kvm centric dirty pass.

That would probably limit certain more modern options of ring based dirty tracking,
as that kvm dirty bitmap is mutually exclusive with kvm dirty ring. Or at least,
would require KVM to always use a bitmap during migration/dirty-rate-estimation with
the presence of vfio/vdpa devices. It's a nice idea, though. It would require making
core-iommu aware of bitmap as external storage for tracking (that is not iommufd as
it's a module).

Although, perhaps IOMMU sharing pgtables with CPUs would probably better align with
reusing KVM existing dirty bitmap interface. But I haven't given much thought on that one.
I just remember reading something on the IOMMU manual about this (ISTR that iommu_v2 was
made for that purpose).
