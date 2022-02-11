Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 520674B2BBD
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 18:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352173AbiBKR2z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 12:28:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240606AbiBKR2y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 12:28:54 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441B52C0;
        Fri, 11 Feb 2022 09:28:51 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21BGtUFB011225;
        Fri, 11 Feb 2022 17:28:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=G6BFHCie9vTfDNeAFwypGSFG4bD/Odf4/CyXFtL1+pA=;
 b=YjohAcy99q+BSU371L95N2C2gha4k/YR+NpkrzVP1/ObReI455airjwg1fk1CT8Pgs7y
 iG29X1zojHBKCQyJWEK5NT8Y9PMRvB2H4m704XTGAo/9IuZr7KMcfM2bS2qu5/wCnXp/
 1GZ2sKFKNvkZ0tzOfd19eUus2An0cWGaYk/+OUQnrhFGsz6QMTy7o7GE1MT1dvAc3Azp
 qPeC1+Qv9+ZnaV6xS155gL9zlC5CIDT9Ss3NY+fEWaDsLvb+TQr9fAShpi03/i7bucqR
 U8Z006EgfT/ovLJssmMp0TULqINhRFnCt8vbexWtULO2lj8EbcQAMMXlE7U1moxeXzvv Vw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e5njr10vn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 17:28:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21BH60eD072458;
        Fri, 11 Feb 2022 17:28:34 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by userp3030.oracle.com with ESMTP id 3e1ec7s02b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 17:28:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ET6WS832U3oAsUsG7EyIl8MU4S7eL0Wxe8XnVIJQO9fZWZgYxQ3WxKzWGpjmTJaq+h8F0z8uit3HnYB9BqH+C60Obwyw7izyjjaTGu3FeMTMVpbRHcSV8Cu/nCk/JfhZQZ42+yxIv5hFvsqwYg4B4mK+mIjKmSXvaCYbr2UL/Lu1YTUDyaqyvVONEDtizroSqwlB070Xb1PiIwIoxnKgN4CfiYlsoglZZ2PB6Kwm5wTqgqZyK0vvQfJ3EckC4HxkVrzN/nn38dMF46Okq1KVwiO1Eh7+W/7cDDwzFNNvpFvlKo3csNGwGLSfCxPtCSvhl+HK8zxxgnwdk+L9hW3aqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G6BFHCie9vTfDNeAFwypGSFG4bD/Odf4/CyXFtL1+pA=;
 b=QhZ7DLxXVfD6MzzCuWuG50NTaDrxm3SlBZuDfVX98OBxmgPiRoXAeaI99+S5e7D8Zig7ttbYA1vN2+lfuWLWXlJqEtHUu9rAmrKVk8i068WbBmXKgMaoqBmIX6CRSRmdb9bbx6X8rWBO9PZ/oIPGOdnlz557VV0X+5YZeeIL/EoAc/xAv9VnFlWdnlr8GPrEDdUP0137H47R1BTPIIhP3q/lKQEyQTUW0TOujE7PtZ/DOZ1Z3wF5EWJdPH2ftBn8WLKG/FSWjP62JWzAR9DxZS1HgBAC1Bq4JkvWbCnu/pbja4QWkSfn/wUHAzIZ/JYF8w+zSDYq8TGNV+kiMSwE/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G6BFHCie9vTfDNeAFwypGSFG4bD/Odf4/CyXFtL1+pA=;
 b=MchHjdkgycK2+I7rF5Rs0tF0fctv4gYJh+Oa7HkH0jbYUuuwgmYSXSoiOZVv6gNheO4M+r7ZiRjY98AVvBUzWT9vuVBWZrV8b0uhp9/qLAHcyPgSLbszhcTTNvnEPlWHmkC4JoeHsIY2WB6+mRerBRZHMNn923RUitb8pkJUqts=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB3935.namprd10.prod.outlook.com (2603:10b6:208:1bf::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.17; Fri, 11 Feb
 2022 17:28:29 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a%5]) with mapi id 15.20.4975.011; Fri, 11 Feb 2022
 17:28:29 +0000
Message-ID: <0cd1d33a-39b1-9104-a4f8-ff2338699a41@oracle.com>
Date:   Fri, 11 Feb 2022 17:28:22 +0000
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
References: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
 <20220202131448.GA2538420@nvidia.com>
 <a29ae3ea51344e18b9659424772a4b42@huawei.com>
 <20220202153945.GT1786498@nvidia.com>
 <c8a0731c589e49068a78afcc73d66bfa@huawei.com>
 <20220202170329.GV1786498@nvidia.com>
 <c6c3007e-3a2e-a376-67a0-b28801bf93aa@oracle.com>
 <20220203151856.GD1786498@nvidia.com>
 <e67654ce-5646-8fe7-1230-00bd7ee66ff3@oracle.com>
 <20220204230750.GR1786498@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20220204230750.GR1786498@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR0P264CA0222.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1e::18) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b0670c8-8a9b-4945-b673-08d9ed83eb15
X-MS-TrafficTypeDiagnostic: MN2PR10MB3935:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB39357A5D788B6B91D7E60B7EBB309@MN2PR10MB3935.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4+LMRJikzvJDIuNPzfAYVgxQreEAn73nofh9nh8X8uLe3Id9z1fDYnrkAZmq8cmJsCseuAdgEUScNcCdxc6I8SexwelELCM+6fPNvC5Phh3pGEUNo7AW571BBQwvgtlsdcYD8GuUj5dC+AkmC/xl2BOGDpUfGsOqoZfeuXYgY35o/us6jBe6gYrLPczbBmA6L3tgl/4KBbY9ALqmGvyYCa5f1B7pnSCBcMhoi/mMIq3ODsg3Lw+3HiNh7hETO7PZY4dA91pc2hRYT4ZijAstSU3OICTgrMpP0gMgbPz9ly2vo1UpkxEEKd1PIQ7RVtrL/8PrOedazNM3rWzT5SwHJraqRu/UQyVXFoUXGsisvWJ6PTf2xUBCcweunCFmZ+kesehuma7GmvwirdAmtqf/+dO5t2MkZ05FjxZ4XqUgdwk5lJgJVzOc1pV5i/TqBd+nUjZB/dGdyvgVIMENGljpo8WMn0jZ43YFUsdS6QLGCgncWzC01tneSrCu5KPXrmtp+mw8Slp6ihDaOpWPBAaMlMWHnuFfrOMGHLR7v39Z2N+YTExCCLLxfQXcgkk9LYUwfcgHqxtCRg8kbswIOFHuaJdJRJ6K9Pi2/weOLVAnfRJf1Mx/PF0Zll4NIIg5aIFRIA4LKPsbn5WMmdMAztl3JsO8JDXkbaKM01WQc6nkb2lWuezs3X8oD65Q+D8N+hNDnZKOKejOAnvZBkuR+eBXI9GGrw4T1pv3NJpMTvNknnDG5opnAcifOQRd2LST6HcG28dyp6Drdh9t3CvV3XUlMgfRMzqzjyoWfZCuPYUXotQLUan02ZVKB0Md2rFt68LLuF2qUgCXLQ7PjDQGyQrI5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(8676002)(31686004)(966005)(6916009)(31696002)(6486002)(8936002)(66556008)(36756003)(54906003)(316002)(66946007)(508600001)(83380400001)(66476007)(26005)(186003)(5660300002)(2906002)(53546011)(6512007)(6666004)(6506007)(38100700002)(7416002)(30864003)(2616005)(86362001)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ekppMkUxbmxCMXRJY2ROUXZSUkVVZGcvbzJyYS9xMzI1Uzc2aFBiWHpOb1Ev?=
 =?utf-8?B?ZDF2dmJ5bkNFL0tyOVpEc24vb3prYk5ZVDFSL1lxeUlEayt5WHFGVWlNVmtT?=
 =?utf-8?B?RFY2T2Zqa3dwQWRCa01LNEZ3UEVRQ2hmZGJYaEdGRnVqNi9Yd2wyajhHbC9p?=
 =?utf-8?B?TFdKRGc2S0p5MmtiUldHdHV0ZDdiNzlRWTd5V0ozUHFjejhCR1VKUWVWL1hi?=
 =?utf-8?B?U0ZjSlRwQXpweWhXeVBRZFFibG9kUndONjk3RERRR0tiWkVnTXhGUm93bzQw?=
 =?utf-8?B?RHJxTVdRUHlsMVdKS1ljVEdUdUZqMmhLSUdXWkZwZmVSVDFsYkRPWW9seWh5?=
 =?utf-8?B?RUdmOENkVWwyM3NLcUJSK05kZnlhTW9YSk9RTmhiZDJveUh3cFFSdnY0U1E1?=
 =?utf-8?B?UHFsNGFjVDh0K3RiS3BlSTVpcW8yNUpTa3BxS3BwZGlCVGFMc05yemZUb2dv?=
 =?utf-8?B?RW1tYWEydkxLckwzVUZxVTV2N0JSMjVtMVg4Z1hPYzZaMXIyanN2dTE4UzRG?=
 =?utf-8?B?UmlZWmoyS2E4Q2NYZGdVNkpQLzY1bmh0NFYyM3F4aW5JeGJvVFRSdUZuOGIy?=
 =?utf-8?B?YlJoUDNHUzhLc2JkTmovM1hJL000NzIrQld0WmtMY2Vla0QzcElHQWxlNXh2?=
 =?utf-8?B?dGxSME9wSkt3YjRJL2szUkt5UHZKcTJoby9wUk1HU1lSRDhpbGVFRjdUMGI5?=
 =?utf-8?B?QVYvRWJ5Vk9FRU1UdjhoV1hiR2JWcHUxd0psUUhYZG52dlBCRHFJMFJ3YW1j?=
 =?utf-8?B?U1pRYlc3UVZJd3lpTlVLYUdjaWpNUHZnYlhJV2xHM3RSditQbThPZFBXSXYr?=
 =?utf-8?B?clRaYVFLVWZyaHJZQzBkSTd4MmcwcnU5aDFPMERaMEV3TlA1ejRoTXNPSXFn?=
 =?utf-8?B?dXRGalREYnVoNllRZGJ0cm9ud3M2cE9KRVRWSFdxY1J5NXA4RHRmUzNpZnM1?=
 =?utf-8?B?blBDMEk2TnZsdnE4UzR1VEUrbUVRLzFnUUZlNkoxSDBsR1ZvaU92ZXlDQk8v?=
 =?utf-8?B?b3lJZFpGcSs3Y0hEdzY4V3h5WVRhdWVvZDBQcjFhUnVnejlkRWhEMjJkbkJz?=
 =?utf-8?B?eEE4OURVNk9RQkMrTmlLSFhiMHRPenhXbVo1M2wzYXR5WG1hMU5DaExMVmUz?=
 =?utf-8?B?VVVDVTJNNHRpUE1EMXNDcEc5TjRkazU3WStmcmF2YlpPeTBpVzNMZGVIaWVG?=
 =?utf-8?B?UFF1MFlVWFJ2MkJCMHNIRTVsendCMHpBOGxDRlBMUEJPNVQ5anIvMWoyQS9F?=
 =?utf-8?B?Z1pIb0xJTXVmRURIRGQwZ0RhRWsyV3JiNlBnZVhWVGY3dW1sS01NU3NZTkd6?=
 =?utf-8?B?ZHlWd0gxaVZSTmdNMHF3dG80ZWVxdFROTkdxd05HOTFJR3lPQ1dUNURjY3FN?=
 =?utf-8?B?UnZlMnhBR3NNQkRsTHl2a3dQRjhZUGJEUzk1Wk1lY3NNa2NTeTY4VFlDRjBi?=
 =?utf-8?B?K0dSbVp2RWRtdGpwUXBveW51WVhtajIrMDhDUUxuUkgxaWZtWjAzLzZ6Njly?=
 =?utf-8?B?czhtM2RXclVCdDlYN29RblE0RTlLdzA5WEZYTEhyaFo3NGQ1L2lyNVB6aER1?=
 =?utf-8?B?WmJKSDJXeW5ucUdTWXRKVnk2K2l0TExjSnJBak82dVNLL3hLZ1JFYlozdEZT?=
 =?utf-8?B?b2ZrRU5LY2lwZU1NM0VPM1lvOWRDNG52bGlweWhMRnF3THVheEtYQ1o3bGJT?=
 =?utf-8?B?aEJJZVVGcWVUVXQ3d0t1UEVMbGxpbEprVEZQbkZPVi9qYjIyT3BhZXVtcG9h?=
 =?utf-8?B?RnplMW4yZTg4N25iQUU2K0ZNS09Md1ZJUmE4eDJPZFZNcFRFYlFHZEc3SXZr?=
 =?utf-8?B?UTM2d0JNYlRoN3ZFYkl0Z3ZDVzhLaUtWdGFnQldUcndtbHBwTENRZS9xWjgx?=
 =?utf-8?B?RGhJY2FwQ0FEdFRzcFpSVXMyUzRyclRzUW5RZERUb0ZON0dtV0hRTktVb0dP?=
 =?utf-8?B?YnhlQ05IYUVKc2E1Y0Z5S0U0eDZ0S3JzUE5Dc2hoWDJqWERzbE9uS21Fd3k2?=
 =?utf-8?B?cHNKYWJ1SEp3cWQvNnNCWWwzYXRsNVlrZ0I5S0N2RVUxTDhsZVlENCtCa1lv?=
 =?utf-8?B?NE9oZEpiRU5KN2pvUEpxbDl3MFhjUUV4OXFaYWdBUzJTRW0xcS9yRkhqZ2xy?=
 =?utf-8?B?YjNLTmJwbUkrTzhsaFBaamcxMGIxbDlpQXVwUmRONHJ6ZlVDOTErVHNScHRR?=
 =?utf-8?B?N0phZ3dJK1dVUEdQWHNhV1BwNGxVWXkwc2M4QU0yek1VUTNJR2wrRCtNNy9w?=
 =?utf-8?B?TWxseEdsdE5EczdlMHhySTRpdG5BPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b0670c8-8a9b-4945-b673-08d9ed83eb15
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 17:28:29.3796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bf00ZGPGL4EYJ1GsumTliFBGRJne3baMtuHZ+PBR78AacZ6rL+wcD7zrL8OToyekH6MDi4Gj6Vz8JnGG7g6xI0JJ0kNwrd4VHCQ1E9UgxO0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3935
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10255 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202110093
X-Proofpoint-GUID: az4sq0lLLMl2qg9S-2w11rUkx2MFzdCG
X-Proofpoint-ORIG-GUID: az4sq0lLLMl2qg9S-2w11rUkx2MFzdCG
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/4/22 23:07, Jason Gunthorpe wrote:
> On Fri, Feb 04, 2022 at 07:53:12PM +0000, Joao Martins wrote:
>> On 2/3/22 15:18, Jason Gunthorpe wrote:
>>> On Wed, Feb 02, 2022 at 07:05:02PM +0000, Joao Martins wrote:
>>>> On 2/2/22 17:03, Jason Gunthorpe wrote:
>>>>> how to integrate that with the iommufd work, which I hope will allow
>>>>> that series, and the other IOMMU drivers that can support this to be
>>>>> merged..
>>>>
>>>> The iommu-fd thread wasn't particularly obvious on how dirty tracking is done
>>>> there, but TBH I am not up to speed on iommu-fd yet so I missed something
>>>> obvious for sure. When you say 'integrate that with the iommufd' can you
>>>> expand on that?
>>>
>>> The general idea is that iommufd is the place to put all the iommu
>>> driver uAPI for consumption by userspace. The IOMMU feature of dirty
>>> tracking would belong there.
>>>
>>> So, some kind of API needs to be designed to meet the needs of the
>>> IOMMU drivers.
>>>
>> /me nods
>>
>> I am gonna assume below is the most up-to-date to iommufd (as you pointed
>> out in another thread IIRC):
>>
>>   https://github.com/jgunthorpe/linux iommufd
>>
>> Let me know if it's not :)
> 
> The iommufd part is pretty good, but there is hacky patch to hook it
> into vfio that isn't there, if you want to actually try it.
> 
OK -- Thanks for the heads up.

>>> But, as you say, it looks unnatural and inefficient when the domain
>>> itself is storing the dirty bits inside the IOPTE.
>>
>> How much is this already represented as the io-pgtable in IOMMU internal kAPI
>> (if we exclude the UAPI portion of iommufd for now) ? FWIW, that is today
>> used by the AMD IOMMU and ARM IOMMUs. Albeit, not Intel :(
> 
> Which are you looking at? AFACIT there is no diry page support in
> iommu_ops ?
> 
There is not, indeed. But how you manage IO page tables felt *somewhat
hinting* to io-pgtable -- but maybe it's a stretch. The dirty
page support builds on top of that, as ARM IOMMUs use iommu io-pgtable.

In the series in the link, it pretty much boils down to
essentially 3 iommu_ops introduced:

* support_dirty_log(domain)
  - Checks whether a given IOMMU domain supports dirty tracking
* switch_dirty_log(domain, enable, iova, size, prot)
  - Enables/Disables IOMMU dirty tracking on an IOVA range
  (The range I suppose it's because ARM supports range tracking, contrary
   to Intel and AMD which affect all the protection domain pg tables)
* sync_dirty_log(domain, iova, size, &bitmap, ...)

The IO pgtables, have an interesting set of APIs strictly for page table
manipulation, and they are sort of optional (so far ARM and AMD). Those
include, map, unmap, iova_to_pfn translation. So, the dirty log supports
for ARM builds on that and adds split, merge (for splitting and collapsing
IO pagtables), and finally sync_dirty_log() which is where we get the
bitmap of dirtied pages *updated*.

But well, at the end of the day for an IOMMU driver the domain ops are
the important stuff, maybe IO pgtable framework isn't as critical
(Intel for example, doesn't use that at all).

>> then potentially VMM/process can more efficiently scan the dirtied
>> set? But if some layer needs to somehow mediate between the vendor
>> IOPTE representation and an UAPI IOPTE representation, to be able to
>> make that delegation to userspace ... then maybe both might be
>> inefficient?  I didn't see how iommu-fd would abstract the IOPTEs
>> lookup as far as I glanced through the code, perhaps that's another
>> ioctl().
> 
> It is based around the same model as VFIO container - map/unmap of
> user address space into the IOPTEs and the user space doesn't see
> anything resembling a 'pte' - at least for kernel owned IO page
> tables.
> 
Ah! I misinterpreted what you were saying.

> User space page tables will not be abstracted and the userspace must
> know the direct HW format of the IOMMU they is being used.
> 
That's countering earlier sentence? Because hw format (for me at least)
means PTE and protection domain config format too. And if iommufd
abstracts the HW format, modelling after the IOMMU domain and its ops,
then it's abstracting userspace from those details e.g. it works over
IOVAs, but not over its vendor representation of how that IOVA is set up.

I am probably being dense.

>> But what strikes /specifically/ on the dirty bit feature is that it looks
>> simpler with the current VFIO, the heavy lifting seems to be
>> mostly on the IOMMU vendor. The proposed API above for VFIO looking at
>> the container (small changes), and IOMMU vendor would do most of it:
> 
> It is basically the same, almost certainly the user API in iommufd
> will be some 'get dirty bits' and 'unmap and give me the dirty bits'
> just like vfio has.
> 

The 'unmap and give dirty bits' looks to be something TBD even in a VFIO
migration flow. Considering that we pause vCPUs, and we quiesce the
VFs, I guess we are mostly supposed to have a guarantee that no DMA is
supposed to be happening (excluding P2P)? So perhaps the unmap is
unneeded after quiescing the VF. Which probably is important
migration-wise considering the unmap is really what's expensive (e.g.
needs IOTLB flush) and that would add up between stop copy and the time it
would resume on the destination, if we need to wait to unmap the whole IOVA
from source.

> The tricky details are around how do you manage this when the system
> may have multiple things invovled capable, or not, of actualy doing
> dirty tracking.
> 
Yeap.

>> At the same time, what particularly scares me perf-wise (for the
>> device being migrated) ... is the fact that we need to dynamically
>> split and collapse page tables to increase the granularity of which
>> we track. In the above interface it splits/collapses when you turn
>> on/off the dirty tracking (respectively). That's *probably* where we
>> need more flexibility, not sure.
> 
> For sure that is a particularly big adventure in the iommu driver..
> 
Yeah.

Me playing around was with VFIO IOMMU hugepages disabled, and this
was something I am planning on working when I get back to this.

>> Do you have thoughts on what such device-dirty interface could look like?
>> (Perhaps too early to poke while the FSM/UAPI is being worked out)
> 
> I've been thinking the same general read-and-clear of a dirty
> bitmap. It matches nicely the the KVM interface.
> 

A bitmap I think it is a good start.

We have a bitmap based interface in KVM, but there's also a recent ring
interface for dirty tracking, which has some probably more determinism than
a big bitmap. And if we look at hardware, AMD needs to scan NPT pagetables
and breaking its entries on-demand IIRC, whereas Intel resembles something
closer to a 512 entries 'ring' with VMX PML, which tells what has been
dirtied.

>> I was wondering if container has a dirty scan/sync callback funnelled
>> by a vendor IOMMU ops implemented (as Shameerali patches proposed), 
> 
> Yes, this is almost certainly how the in-kernel parts will look
> 
/me nods

>> and vfio vendor driver provides one per device. 
> 
> But this is less clear..
> 
>> Or propagate the dirty tracking API to vendor vfio driver[*]. 
>> [*] considering the device may choose where to place its tracking storage, and
>> which scheme (bitmap, ring, etc) it might be.
> 
> This has been my thinking, yes
> 
/me nods

>> The reporting of the dirtying, though, looks hazzy to achieve if you
>> try to make it uniform even to userspace. Perhaps with iommu-fd
>> you're thinking to mmap() the dirty region back to userspace, or an
>> iommu-fd ioctl() updates the PTEs, while letting the kernel clear
>> the dirty status via the mmap() object. And that would be the common
>> API regardless of dirty-hw scheme. Anyway, just thinking out loud.
> 
> My general thinking has be that iommufd would control only the system
> IOMMU hardware. The FD interface directly exposes the iommu_domain as
> a manipulable object, so I'd imagine making userspace have a simple
> 1:1 connection to the iommu_ops of a single iommu_domain.
> 
> Doing this avoids all the weirdo questions about what do you do if
> there is non-uniformity in the iommu_domain's.
> 
> Keeping with that theme the vfio_device would provide a similar
> interface, on its own device FD.
> 
> I don't know if mmap should be involed here, the dirty bitmaps are not
> so big, I suspect a simple get_user_pages_fast() would be entirely OK.
> 
Considering that is 32MB of a bitmap per TB maybe it is cheap.

>>> VFIO proposed to squash everything
>>> into the container code, but I've been mulling about having iommufd
>>> only do system iommu and push the PCI device internal tracking over to
>>> VFIO.
>>>
>>
>> Seems to me that the juicy part falls mostly in IOMMU vendor code, I am
>> not sure yet how much one can we 'offload' to a generic layer, at least
>> compared with this other proposal.
> 
> Yes, I expect there is very little generic code here if we go this
> way. The generic layer is just marshalling the ioctl(s) to the iommu
> drivers. Certainly not providing storage or anything/
> 
Gotcha. Perhaps I need to sort out how this would work with iommufd.

But I guess we can hash out how the iommu ops would look like?

We seem to be on the same page, at least that's the feeling I get.

>> Give me some time (few days only, as I gotta sort some things) and I'll
>> respond here as follow up with link to a branch with the WIP/PoC patches.
> 
> Great!
>
Here it is. "A few days" turn into a week sorry :/

https://github.com/jpemartins/qemu  amd-iommu-hdsup-wip
https://github.com/jpemartins/linux  amd-vfio-iommu-hdsup-wip

Note, it is an early PoC. I still need to get the split/collapse thing going,
and fix the FIXMEs there, and have a second good look at the iommu page tables.

The Qemu link above has one patch to get device-dirty bitmaps via HMP to be able to
measure the rate by hw dirties and another patch for emulated amd iommu support too,
should you lack the hardware to play (I usually do on both, more for people to be
able to coverage test it). I sadly cannot do the end-to-end migration test.

>> 3) Dirty bit is sticky, hardware never clears it. Reading the access/dirty
>> bit is cheap, clearing them is 'expensive' because one needs to flush
>> IOTLB as the IOMMU hardware may cache the bits in the IOTLB as a result
>> of an address-translation/io-page-walk. Even though the IOMMU uses interlocked
>> operations to actually update the Access/Dirty bit in concurrency with
>> the CPU. The AMD manuals are a tad misleading as they talk about marking
>> non-present, but that would be catastrophic for migration as it would
>> mean a DMA target abort for the PCI device, unless I missed something obvious.
>> In any case, this means that the dirty bit *clearing* needs to be
>> batched as much as possible, to amortize the cost of flushing the IOTLB.
>> This is the same for Intel *IIUC*.
> 
> You have to mark it as non-present to do the final read out if
> something unmaps while the tracker is on - eg emulating a viommu or
> something. Then you mark non-present, flush the iotlb and read back
> the dirty bit.
> 
You would be surprised that AMD IOMMUs have also an accelerated vIOMMU
too :) without needing VMM intervention (that's also not supported
in Linux).

But the mark as NP for viommu is something I haven't investigated.

> Otherwise AFIAK, you flush the IOTLB to get the latest dirty bits and
> then read and clear them.
> 
It's the other way around AIUI. The dirty bits are sticky, so you flush
the IOTLB after clearing as means to notify the IOMMU to set the dirty bits
again on the next memory transaction (or ATS translation).

I am not entirely sure we need to unmap + mark non-present for non-viommu
That would actually mean something is not properly quiscieing the VF DMA.
Maybe we should .. to gate whether if we should actually continue with LM
if something kept doing DMA when it shouldn't have.

Also, considering the dirty-bitmap check happens on very-very long IOVA extents --
some measurements over how long the scans need to be done. Mostly
validated how much a much NIC was dirtying with traditional networking tools.

>> 4) Adjust the granularity of pagetables in place:
>> [This item wasn't done, but it is generic to any IOMMU because it
>> is mostly the ability to split existing IO pages in place.]
> 
> This seems like it would be some interesting amount of driver work,
> but yes it could be a generic new iommu_domina op.
> 
I am slightly at odds that .split and .collapse at .switch() are enough.
But, with iommu if we are working on top of an IOMMU domain object and
.split and .collapse are iommu_ops perhaps that looks to be enough
flexibility to give userspace the ability to decide what it wants to
split, if it starts eargerly/warming-up tracking dirty pages.

The split and collapsing is something I wanted to work on next, to get
to a stage closer to that of an RFC on the AMD side.

>> 4.b) Optionally starting dirtying earlier (at provisioning) and let
>> userspace dynamically split pages. This is to hopefully minimize the
>> IOTLB miss we induce ourselves in item 4.a) if we were to do eagerly.
>> So dirty tracking would be enabled at creation of the protection domain
>> after the vfio container is set up, and we would use pages dirtied
>> as a indication of what needs to be splited. Problem is for IO page
>> sizes bigger than 1G, which might unnecessarily lead to marking too
>> much as dirty early on; but at least it's better than transferring the
>> whole set.
> 
> I'm not sure running with dirty tracking permanently on would be good
> for guest performance either.
> 
Hmmm, judging how the IOMMU works I am not sure this is particularly
affecting DMA performance (not sure yet about RDMA, it's something I
curious to see how it gets to perform with 4K IOPTEs, and with dirty
tracking always enabled). Considering how the bits are sticky, and
unless CPU clears it, it's short of a nop? Unless of course the checking
for A^D during an atomic memory transaction is expensive. Needs some
performance testing nonetheless.

The IOTLB flushes pre/after clearing, tough, would visibly hurt DMA
performance :(

I forgot to mention, but the early enablement of IOMMU dirty tracking
was also meant to fully know since guest creation what needs to be
sent to the destination. Otherwise, wouldn't we need to send the whole
pinned set to destination, if we only start tracking dirty pages during
migration?

> I'd suspect you'd be better to have a warm up period where you track
> dirtys and split down pages.
> 
Yeah, but right now the splitting is done when switching on and off
dirty tracking, for the entirety of page tables.

And well at least on AMD, the flag is attached to a protection domain.
For SMMUv3. it appears that it's per IOVA range if I read the original code
correctly (which is interesting contrast to AMD/Intel)

Also, this is probably a differentiator for iommufd, if we were to provide
split and collapse semantics to IOMMU domain objects that userspace can use.
That would get more freedom, to switch dirty-tracking, and then do the warm
up thingie and piggy back on what it wants to split before migration.
perhaps the switch() should get some flag to pick where to split, I guess.


> It is interesting, this is a possible reason why device dirty tracking
> might actually perfom better because it can operate at a different
> granularity from the system iommu without disrupting the guest DMA
> performance.

I agree -- and the other advantage is that you don't depend on platform
support for dirty tracking, which is largely nonexistent.

Albeit I personally like to have the IOMMU support because it also
frees endpoints to do rather expensive dirty tracking, which is a rather
even more exclusive feature to have. It's trading off max performance for
LM commodity over, where DMA performance can be less (momentarily).

	Joao
