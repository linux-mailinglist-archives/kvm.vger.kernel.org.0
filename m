Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B515F4E27F7
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 14:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348053AbiCUNon (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 09:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245016AbiCUNol (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 09:44:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0D61A3B7;
        Mon, 21 Mar 2022 06:43:14 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22LCw7ns006208;
        Mon, 21 Mar 2022 13:42:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Vghy5j8qYXk7E7XwNZ8tivIyMOs3+ZzdyNFQ/4VLCGo=;
 b=sdMGF+r7A1EOs7z46z0uMCQ5hlq8kFa7+FhPye0Tyzy24f0Hh9a+PlAzLZno688ACzG+
 AQgpVoEyxZtkxlTL7w/iNVkqCL0cPHJhmgIoePTp56VPn4ZJDJwikbjrh2YAFbmkUEx8
 cV3jdXPt41DKDJzvdHt8np4ss3YZ0MoST2Oru3Ln3V6rFND6DD92kSPhQtQgGp+sOpdT
 hatDfIqgpkc+5jLD/6OveMm6HPR8C76JPvcjPYFcbWNgxiPMefrNvVU9gCTeC3HJPxXu
 xtdpbox/YU8uNt1MJrlr+nzXswa7zBinjEe2vHK8QWXlaw3LA6MOVJcpz4GnsnItjYPa xA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew6ss3a0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 13:42:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22LDVkBR177065;
        Mon, 21 Mar 2022 13:42:41 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by userp3020.oracle.com with ESMTP id 3exawgrwcx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 13:42:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h4Vtp7yoGZdElExdyhADJv7MaoUwm5kmMEkJjnSB4ROP6cG9mGL2GFBgpQnj/i2CuMejDZLYTT7oILRdBw6gDU7/0//yE5uKduaFOuiv8cWug5YTFLSX3DHy9Ja0p3u1Q39krCZdMsCtEpWZAaRUb72WlZtQuwAVtHwKaB6hScNKdqf1q4qmf27Zh6/gwSnDN7QxtmDcB10UwjC5WLbMZkO95L7bWX7CXV+xcbqiOm1F837hpuKtB1gJuMFezcmL1mdBHwxRSMRnTIRtM3gqO/iM2sa0DicIV637cwvJa2QXZm+7BPTljGAj8/jJ8lRnlneUWPZmno0B2QesIxSqsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vghy5j8qYXk7E7XwNZ8tivIyMOs3+ZzdyNFQ/4VLCGo=;
 b=jIAKTIdWdeqcK/zkR0B86OorN1KpWlM5NNNq9S1edIvp0KUshNtUQm5f9lTkL/Opos3qtrvC8nvIv+cJKx2SxkcSux//Oou7Z5CrViaUre/Vv5gtT9Sr7sIP2lfH0rEMUuOzSiclBoze640tjs20l4AGBwWPt1k3DazguMtf1GzmPQxO+5s72HotSA09Kml8p5THP0PlJZV+7Aq6w/X6BDRZOhoHQhiQoWTIP8kwyF6a/x6ysMipKjr/lJ0zDaamsFzUZbEB1hqKXRWdT370k5G1zD4rFQ8R3Jwnqsmr8rlT6RNM+d2ukolCsw1+Ylsdv5tdVT95RuvXurCzxy5eXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vghy5j8qYXk7E7XwNZ8tivIyMOs3+ZzdyNFQ/4VLCGo=;
 b=voDZv6s6fP/OaEyK9H6Gf1tviZeWq7qICN1kdIx0TxfDHGjNDaIgVLGe7C0YXNs6bR93ZSkCtmlApDndIGLvvI4Ygrq75TIkO5rqZYg59LRlyT0zJDtaFJgICEMkBao+IDgLbw8cldcmxTqipWgDwdZSaMomwPwvFSSNbBCz6Y4=
Received: from CH2PR10MB4008.namprd10.prod.outlook.com (2603:10b6:610:c::22)
 by DM5PR1001MB2410.namprd10.prod.outlook.com (2603:10b6:4:2e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Mon, 21 Mar
 2022 13:42:38 +0000
Received: from CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::301a:502a:1f46:64cd]) by CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::301a:502a:1f46:64cd%6]) with mapi id 15.20.5081.023; Mon, 21 Mar 2022
 13:42:38 +0000
Message-ID: <6730ea89-8d85-bf30-28e5-01ca7ebdacea@oracle.com>
Date:   Mon, 21 Mar 2022 14:42:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [syzbot] WARNING in kvm_mmu_notifier_invalidate_range_start (2)
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     syzbot <syzbot+6bde52d89cfdf9f61425@syzkaller.appspotmail.com>,
        david@redhat.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanjc@google.com, syzkaller-bugs@googlegroups.com,
        vkuznets@redhat.com, wanpengli@tencent.com, will@kernel.org,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <000000000000b6df0f05dab7e92c@google.com>
 <33b6fb1d-b35c-faab-4737-01427c48d09d@redhat.com>
Content-Language: en-US
In-Reply-To: <33b6fb1d-b35c-faab-4737-01427c48d09d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM6P191CA0029.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8b::42) To CH2PR10MB4008.namprd10.prod.outlook.com
 (2603:10b6:610:c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5713e924-545c-4513-0614-08da0b40a9c7
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2410:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2410794CAF1B0AAC972DAEFFFF169@DM5PR1001MB2410.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zPizwUe46rB0UBajaZDyo/X4p8zlJN5/vVQZAxyQBce3w5KvkM+QnrBOvvZwQpLkm9BeAc5lAoDKR59PHXOGytXpB9+rhhwDsFHaf56c/DDu1BzaowmjUeerAZmqvQ6EbvtCvzzEJ3m8uJrPqz2nXrJtE+Qw4SqMVh+2bY3AGAkGqEkM6mBqP1x1wqWRLAkHiETC+4smjQw7cnxZ8peDgErYMkHF9n3jDx7hgYPA1NZURJTFLuZ4GYoKTDodLn8Y7U32MmCOh1G4X4pIANAdBrA/IVe92wVQwism6eW2661Nq8mZ05qzvRw83xCBkeSnQ896LGizp+PE6PA55nt4SwswFEAy623ihLlY9zF/BFeVqRrKA+NN9YoTiE9w/Xt3OuNBr09f+0mGZZNLiQOZBhW7Jbzu5xC3U4ofPRZoSkLXb96jJKZg/ggq5CN5cImmBXK4TuN2q2yvw3KGKwOy+7OSMdgvDAOmVsz58EPwaiN9Laynndxu9urW/3wuV0YWlaBhMf1/3Ef7ZgHXqaBXK7a4ayT+Q+8tnCquG3qNQ9A2ortOMuv4Ajxj32Zc+/PW9q/hz8z2HabMwINkwakY52l3bqgDzsiAiGKTpKA+PHn1Mx2dEQR1O4GMLvyQtx3+Ay+GoxlJ6rQM86qR031AnkuRMTip8wZVOXs8org6sKLiBUA5oJK3R2YSUNejAiKmYDZpVbbVV4Oz77t6Hu9z59wTjZaaBI/CfhEf4Khk+NESMCzC5oLl7m9bFDrTcvtgfIpAf8nN/38VAKS9rhaFeAshps30kRYIRvAU7nyj+B1gY6DyGrwygnjet3HhGQKyVny7jRX6fEe/VRTT4Kjy1HfDqLSBF00zx/b4F+V32Y2WfO43++JzTlRgwlGcavgt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4008.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(8676002)(66946007)(4326008)(66476007)(6486002)(5660300002)(86362001)(31696002)(508600001)(83380400001)(38100700002)(31686004)(26005)(2616005)(186003)(2906002)(8936002)(53546011)(7416002)(6506007)(6512007)(966005)(316002)(54906003)(6916009)(36756003)(99710200001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OEwxeW81RWRYVWljbFBJM210SVJGLysrTzZucHEweVpaRi8wNFRPNGI4TDhv?=
 =?utf-8?B?cTBjbWZNK2xNVHdCYngxLys5b205UG5tNkVIV093Z0twaEgrRWJ5VWpwSysw?=
 =?utf-8?B?MnZxeUhCbHQySElVRFdpUmhsaTdSNWN6QkZCMDlVcDVMa3U1cWRDL0J1R3FC?=
 =?utf-8?B?YWxZYzNzbDdVZDRZN2FiNWtTVUNLZnBJbi9EbEZiazA4Wm50TjVxZEhIMmtr?=
 =?utf-8?B?c1oyTVJiVi9HL3YvbXVtRWp2MHBDeDh2ZWlCN1J1MEdZcTFTQlozL1dxQWZV?=
 =?utf-8?B?bUxGRTVuMlVyY0x0OHlVYTRQcjNqWXMwcFhMZU1HeXY5Z005a0svOEQyL1pB?=
 =?utf-8?B?UGxlMzdMZmRDK1c1RE95bDB0eFk5YkhWSlNNMGRrT05WYlNieUptUUE2Tmhi?=
 =?utf-8?B?SFhwUmNaSDBFbGxFRWRYQ21VUkhka2dlSWpIejdDcCtsZEp1NTZPNElyMWpM?=
 =?utf-8?B?RjJLMUd0clhWMithU1Nhbng5WXErdjdtNzRFYmFWQ0lvbk5SVW8yV2pqSVdC?=
 =?utf-8?B?WkVZUkQ4cE0yRGUyOFJXU1pERDFoMHhZSkEyYVhWbVBBTHRqZXZkU293aVE1?=
 =?utf-8?B?L1BSQjNhcFNJdDIvYkRoS2ZUTkJwYzJ0TUNvQ05oNWY1TzFKL3RhakxDSy8x?=
 =?utf-8?B?OVhFK1R0VS9pdnBSS1RURERybWZoS203Y3h5T1c1S0E0cUo3c21tWXlrOURr?=
 =?utf-8?B?aFpnSXpJSS9LYXFlbnVLTjhac1JGd1pheXhRb1FIRHp6WWplZEIxL0ZwTFdy?=
 =?utf-8?B?RjBObGtIbVplcWNQODlJTEFtMW9Ca3RzeDdmLzlkbzA0N0hUT0J0NUZVZDJw?=
 =?utf-8?B?cHR1VzF5eVRjRDBhZkNvczZEL0t4cGlBa3pMR3BCc1NMMHhIVVBGRDR1L1p3?=
 =?utf-8?B?TXhtQlcyQWtHbG9NRUtuVGQxTmxROFRhaWZ1QnZ0QUJnUE5FVVBFVTVNRm82?=
 =?utf-8?B?U1crdmhvNmt2T24yTFEzUDZRQ3R2RkNpbFE0VUFGVHlMbnBTdGNTREU4a3pp?=
 =?utf-8?B?aUJZbWlJbFlkWGRSbUJWSGlZYUtZSmJDUGxlYUU4Wjd3b0NPWXpLcjdYZjZN?=
 =?utf-8?B?c2ppVlQ5dGM2OXdQWEZMNGFlMFJtZUorNjlxOXRkWkhNeFRjQjAxT3FlcldR?=
 =?utf-8?B?Z0FhMU80Y3dlY0F3OUNITnRRcjFUbUFGRWhkM2RaaEVwVU51ejBjd3hLeS9F?=
 =?utf-8?B?U1FkdWUvMUlQNTVvMXlFeGJaY3I3b0VHODNVNzdqbmVaLytudWpiQm92amV6?=
 =?utf-8?B?dU1LRC9ySlVhdmpBdjROaDFNdThxTzBhUGwzT01LcnpFMXRGWjJWYUdqZ0lK?=
 =?utf-8?B?TjVzaHBaQTdsLzZnRTRDYmdLaHdjZnpaYVl0V0drSnM2YjdBdkhLSTluZXVE?=
 =?utf-8?B?a2lIa1dpdTJLQ1Q1R1Nid1hWTTJRY3B2TzRzTDNTUUpKU1czQWNmUkxYR25R?=
 =?utf-8?B?TFBpY0tUSnhZYWl4bGNEY2NVd1dzVXJqSy9SdnM0OXFCY2FqNTQxVi9iTW5n?=
 =?utf-8?B?RmpDVGxORDJpOTl0cktJQkdHZHNHTG1nazBWbm45MXBCZnZUeE5lZ24rZTBo?=
 =?utf-8?B?OEd5Ymd1d0JzMjVuS1piR2g1RnRMemNyNWFnQ0FFcnQ4U1c0S0pidkFSSTdQ?=
 =?utf-8?B?TjZtbUlmVE9HOTFXOWpxTFhMc1NKTWdMTFdVQ010MHpGZ3JIOGw4N0srcUJ1?=
 =?utf-8?B?cjI4Q2p4cmt2aFZxUStPQS90SVEwNWRldU5Gek1xOURGSEtPOFBNNnJzb2ZQ?=
 =?utf-8?B?Vk1TMHVOSllIdHdINEw0a09wMGZhazhFNTVTMGhhS0RHSjhnRk9KazRPcWZl?=
 =?utf-8?B?dDhwL2dkb0M1TjFlSzl0c1J3bTh6eHUvYWRYdXF6V3JpMzlWVG52Z0RVK3E4?=
 =?utf-8?B?Z2picDRCMUMyUkZUNXF6V3pFbXg1Q3Y0SjBFeHRHOHl2MDQ2MXQ2ZzR4T3lV?=
 =?utf-8?B?S1FTWW9SZzB6VENCOFBIZjRXb0FFS1owWEtRS0c1c0prT0pJdHVGSnMxbG1W?=
 =?utf-8?B?MjgvMTM5Q0JBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5713e924-545c-4513-0614-08da0b40a9c7
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4008.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 13:42:38.3207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nY5gRMWVG5OZj0/vxx5456b8lRHjU4vx+9fNM5KHoTTZ/lBAxsyH1RihdY2bXaMxdG2Toa3g2JOt6VdxPcy8I6/8AfXrEEn1CgcEPM8n7yI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2410
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210087
X-Proofpoint-ORIG-GUID: 7-Q8V2b2Ie5ic9HxrcQxzBvMf_pPiMQs
X-Proofpoint-GUID: 7-Q8V2b2Ie5ic9HxrcQxzBvMf_pPiMQs
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21.03.2022 12:01, Paolo Bonzini wrote:
> On 3/21/22 11:25, syzbot wrote:
>> syz repro:      https://urldefense.com/v3/__https://syzkaller.appspot.com/x/repro.syz?x=12a2d0a9700000__;!!ACWV5N9M2RV99hQ!bJGc10O9acwj6GeDIyIdP0zHAuWUpAyb7E4gom6naJO0VKxLGw2oijJnPqByG7ye0Uq2ZA$ C reproducer:   https://urldefense.com/v3/__https://syzkaller.appspot.com/x/repro.c?x=13d34fd9700000__;!!ACWV5N9M2RV99hQ!bJGc10O9acwj6GeDIyIdP0zHAuWUpAyb7E4gom6naJO0VKxLGw2oijJnPqByG7xoEv26SQ$
>> The issue was bisected to:
>>
>> commit ed922739c9199bf515a3e7fec3e319ce1edeef2a
>> Author: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>> Date:   Mon Dec 6 19:54:28 2021 +0000
>>
>>      KVM: Use interval tree to do fast hva lookup in memslots
>>
>> bisection log:  https://urldefense.com/v3/__https://syzkaller.appspot.com/x/bisect.txt?x=142aa59d700000__;!!ACWV5N9M2RV99hQ!bJGc10O9acwj6GeDIyIdP0zHAuWUpAyb7E4gom6naJO0VKxLGw2oijJnPqByG7xEhtZ-FQ$ final oops:     https://urldefense.com/v3/__https://syzkaller.appspot.com/x/report.txt?x=162aa59d700000__;!!ACWV5N9M2RV99hQ!bJGc10O9acwj6GeDIyIdP0zHAuWUpAyb7E4gom6naJO0VKxLGw2oijJnPqByG7zcn2K3LQ$ console output: https://urldefense.com/v3/__https://syzkaller.appspot.com/x/log.txt?x=122aa59d700000__;!!ACWV5N9M2RV99hQ!bJGc10O9acwj6GeDIyIdP0zHAuWUpAyb7E4gom6naJO0VKxLGw2oijJnPqByG7wzducgVQ$ 
> 
> It bisects here just because the patch introduces the warning; the issue is a mmu_notifier_invalidate_range_start with an empty range.  The offending system call
> 
> mremap(&(0x7f000000d000/0x2000)=nil, 0xfffffffffffffe74, 0x1000, 0x3, &(0x7f0000007000/0x1000)=nil)
> 
> really means old_len == 0 (it's page-aligned at the beginning of sys_mremap), and flags includes MREMAP_FIXED so it goes down to mremap_to and from there to move_page_tables.  No function on this path attempts to special case old_len == 0, the immediate fix would be
> 
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 002eec83e91e..0e175aef536e 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -486,6 +486,9 @@ unsigned long move_page_tables(struct vm_area_struct
>       pmd_t *old_pmd, *new_pmd;
>       pud_t *old_pud, *new_pud;
> 
> +    if (!len)
> +        return 0;
> +
>       old_end = old_addr + len;
>       flush_cache_range(vma, old_addr, old_end);
> 
> but there are several other ways to fix this elsewhere in the call chain:
> 
> - check for old_len == 0 somewhere in mremap_to
> 
> - skip the call in __mmu_notifier_invalidate_range_start and __mmu_notifier_invalidate_range_end, if people agree not to play whack-a-mole with the callers of mmu_notifier_invalidate_range_*.
> 
> - remove the warning in KVM

This probably depends whether it is actually legal to call MMU notifiers
with a zero range, the first time this warning triggered it was the caller
that was fixed [1].

By the way, the warning-on-zero-range was added during memslots patch set
review process [2], but I think it ultimately does make sense.

> Thanks,
> 
> Paolo
> 

Thanks,
Maciej

[1]: https://lore.kernel.org/kvm/20211228234257.1926057-1-seanjc@google.com/
[2]: https://lore.kernel.org/kvm/YKWaFwgMNSaQQuQP@google.com/
