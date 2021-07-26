Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4B93D66F9
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 20:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbhGZSNB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 14:13:01 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:4260 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231640AbhGZSM6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Jul 2021 14:12:58 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16QIl9TO007005;
        Mon, 26 Jul 2021 18:52:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=Mu6XEWDYl1X/brBoTUhAAFuQkCWXvuqacFkkF9V0ZZM=;
 b=bei+PUoGtpLhF1vHlTXo65BQCztyZqqAj1ZpbRp8fdb275v5AdUeGqMbgi/sb9VQoqXG
 1mJt6OvhLTdU3/k6rVRNnqj3wnk9HyQVCBZUuUSqhqf1HQJQht0LaKbMKOAOt8l4BxUZ
 ZuyeQu3WQjUZUOcdQ8BL5dImNHuX1S0nZIZjTitxut2UoVt9Db/vpX2ro8eAaGwv4U+6
 2gXt80Ji7wpPeKRGsujYCj7HLEJhm7TjNf5IQkTqspyJNXBbwar9wms4/readASODudC
 W/0BpMOAAMaTbAcYCq302C9aG9wMGFzDox/GC/uS7iKhFGtDsfbUTJaQqrXRUTimAICY Rg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=Mu6XEWDYl1X/brBoTUhAAFuQkCWXvuqacFkkF9V0ZZM=;
 b=iU4ij/ZVjcQ7htK2o81onlGXvWj4gsTrQc1/D7txCUS41lGyzDJ5vvxbBsH67pBXTJX2
 M2B2TkFSxrgZXffYckAJZTIcZ0mHAwgXUQPJl4WwcM770tP8jlROPJ0LCTCLsntKwg1a
 N7dnBFSiHagWa0DTVNdzagd4U1/ng6XSXY3ofyyhit0Vex7W+HZRiZr1D+Vk9b8Jt5/w
 jl/XZqKVrajDKPpgDqp1MQRGRv5Ot/fbb/p8RdPbE0ZN95xUVq1zS3qnsVdCk9Xz5mi5
 8y7w+2HLBLY5khoZZlXLzXU0VxbqsLmvvpjPzmTH1Gylyr8M67fMMjZDsS3qLlnayODZ 4g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a1up6s6v2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Jul 2021 18:52:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16QIonhJ066804;
        Mon, 26 Jul 2021 18:52:50 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by userp3030.oracle.com with ESMTP id 3a07yw1y8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Jul 2021 18:52:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MW63BMT7voC+UuTtfkZf9I51YWzhpa8eTB/NVGq3Sc7scQkEFQOqx4smwp8paji8K1t0WqAGsikRcdbPvGVPQ0+qtAZE1jNm2T5LiBb8F6JVCgpIfbgTK3oz+nj4f37BZQt0vVqXYPb0IciGkBrOlAr9vWDXFw9EXsntpEIB/0tmaBUD0hFJt/Pren6VIPNBl0mZ3KFMI5QBfFCrQSKCowXIFgHyFre7u64ZGNAauaYAmX92DhdHj6lvMx1K69IXAW6RghSU4qz84azmSARdm+q28trs13A6Dp8w6mlqwf+7flLq9qzKmpL6ZGwm4Q20YD7/I9EBDamkPBk8BZp20g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mu6XEWDYl1X/brBoTUhAAFuQkCWXvuqacFkkF9V0ZZM=;
 b=npq85du3H8Xw1TTwbtpY2Lr7AgTaVTJxtaRDWlR3TR+9I5nBZx58/qmAt09YI56WSU+vcJNIJpWKdGvFaqeU6zKZFYgs+j3oGQmvBW4JYrFnrXBp3AT8YG4LazO1rht8vdosi4VQ21SZOQ8+m2xxwJC6Aqxt1h75Yr1hA5F86e4vE+v8i/Jqy9HsSoXvFIhSOJ09diEeURaNLf7ss8qc88oRzSf3YEBl0VO7cL+H3h8j2tMTka6ZfUUYiz2fqPPaQFb0Eik6r4+4ruDYzeSU99uNkqpdPfOKSy4yjqadAlvJjvq6A+y2UOUXX6VtY7ikGlw/Nu0Uerw7yWO4XR7HGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mu6XEWDYl1X/brBoTUhAAFuQkCWXvuqacFkkF9V0ZZM=;
 b=zMp06ZeNGm8sgBeR3RVoOB3ZE9p/dqxRKeCku4+x3fukpx8huI9fXuvAPoB07Lty/Cay4RjyMHsbn91YbZeShUAJI1oyHrbstr7IKHwq9if2MqV+RezD6SDWp56SmOq1v1Bq5guG1AtjlSOB/tWG80dfVk6CUwKildMJS/CO3Ik=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2765.namprd10.prod.outlook.com (2603:10b6:805:41::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Mon, 26 Jul
 2021 18:52:47 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107%7]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 18:52:47 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        thomas.lendacky@amd.com
Subject: [PATCH 2/3] Test: x86: Add a #define for the RF bit in EFLAGS register
Date:   Mon, 26 Jul 2021 14:02:25 -0400
Message-Id: <20210726180226.253738-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210726180226.253738-1-krish.sadhukhan@oracle.com>
References: <20210726180226.253738-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0025.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::35) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BY5PR04CA0025.namprd04.prod.outlook.com (2603:10b6:a03:1d0::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Mon, 26 Jul 2021 18:52:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13798288-abd3-4914-bcfe-08d950668f5b
X-MS-TrafficTypeDiagnostic: SN6PR10MB2765:
X-Microsoft-Antispam-PRVS: <SN6PR10MB27656A69E21FD6AE9AF5528481E89@SN6PR10MB2765.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:168;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y0VF+Az6kIUi+3XICmwY3UsJERVo9TqMU2DOaf1YVifndnrYQY9aJubSZfghk+IDrxnu/BkikzpCxg+Es6PbvPiLb8eQ9ijaLLydXbhZeegiAxhtsgY776jy32HUPZ7IDpDHU/kiixf1MgO08wHb0/RyM0T5KUdTdhIiu19OWmEQHFZsWbZ5VFAXz85P7QfROubksoYu79zWFjG7vPeLYZdnX4YvAZ4Xf7Z5KlZMdQbzwP6QPKtfYmsYI8o60RHWw1a6/QrUkEycd2HVRmo10j76+7AyBxZIHilh5uiNQQ0KEMthHhhS+9KJ2XKcwjxu5+YHlAjBIyKqiPLa24cmVkRfegVE5ZZPzqLsS9TSxOx/Uv7I6ALVZanq6dFc0+PFSO7tY5uFAKIxE6X1rUe3GHBqf9NwobuUl0fxDYLp5p1eHEeXB5cuoz1NZHACefxF/b1xoLBcJfdZVHIAf0xUfXZocu8CzY2F3bsvGS6Pp7ARIfhj4wwCproziNbMDxJ9mfsaaTDGKz1eWK3VDNh9iVFup9pxoFqrmVZRGrp/LZirlKFXi0+dajBBwDAHPgPAXc+nq/apO26eXHYw0FoyJklcZthhu/ngzYi22BsP+ADqBPwWJZXYkNmFHKBveNKTdd0GvDSi9X1Gh5rHdA1CHoND9jBkizPAmlluox/UU2NhkxcHiQZoODgZgafSkzR9QymfJ3YD64CcXYlCAYm0dg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(366004)(39860400002)(396003)(86362001)(8676002)(26005)(316002)(956004)(66946007)(66556008)(66476007)(2616005)(478600001)(4326008)(186003)(2906002)(7696005)(52116002)(36756003)(8936002)(6666004)(6916009)(44832011)(38100700002)(4744005)(38350700002)(6486002)(1076003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fGRDiBj5Zo95Mg9khcB2ipxIuo5rhylKg3bUjQ+x4TFZqhtVdxp+Whx8TPe3?=
 =?us-ascii?Q?fmdbuWTcEfo2KlS0toqIm42i5vVdIE2fnYcLj8trGHbpRSgs0531AH48GMu7?=
 =?us-ascii?Q?zgWMfwc3X3MwoeAIWput3WVF4/r7YeGcACQXFVTwZKzBYLWZddBy1uH4wst1?=
 =?us-ascii?Q?ou+Ao+ISMIf5Q25TOCOKkrYzlu3cRO/s0JgDqa0maAod10ov0ksnUtAmEMku?=
 =?us-ascii?Q?ZQeqsCgA5oN5ow5J9CUtdwGgpWRWRJHUt6bDxqdfVMLPRB+iiCjgAUR0mSFS?=
 =?us-ascii?Q?mpnbPcKZadByUawmwaIQ0iZiBNhG7FzkOfwGMlcwlSJGWWF8QUBqI4qmOdjD?=
 =?us-ascii?Q?hM6bFlPGlm0Qj1VPKk2HeM/3sb8EMtADbJgD9jT60uBdeoQYrxDJaMD/YukR?=
 =?us-ascii?Q?qrjp15XFOZxiECaApKtSfQ0UYeioNm0Oih9BD/Pmv4OXgb6utXkYBmzPAcOM?=
 =?us-ascii?Q?3V5o3w2OU+Nq5p4EYJqGE5EBDi3efP3jG9ifFvrfXD3f+xxF6yUMBpp7pAob?=
 =?us-ascii?Q?1FmYcIeN0EoJ+jPlho9HAyzeGt/yr7N2W69SaETTcycJM5lQVl/HYHUY2KZb?=
 =?us-ascii?Q?g5w6vaWGNaDiqxSHN1eCyyk+m4X5C/psF8fiIlBirKNAb+IbY9dqd9pGb3Eq?=
 =?us-ascii?Q?mng1x0YbafH83BJ3mtO7B52DsiQZ3GQX//xW1yrmCii624LqxwVGzEzNglVt?=
 =?us-ascii?Q?C7rTo7sULozqa7R4rzDWYFeHQXbIHbOsYXlKjMIBEZGqr6nc0KvsKHyWaaKC?=
 =?us-ascii?Q?Y0piW5U4RaLahbUWCDI+hi53f2I1HQPIrtDa86y2mdCFNf+IeOcPqdozzil2?=
 =?us-ascii?Q?KZ8jHIyTMorDvABd9UZFVW+bjMA7Rw9qqlqDAuo9JtXGxdXwOYnHXoGreHyV?=
 =?us-ascii?Q?RKpxKyXRF6GFMRW+svYnqxe8q7YrNASzFdV/J3jaknvl/MC0A5pxAoMj8MBx?=
 =?us-ascii?Q?9OXIH3QuTMmU5deJyhOrXDHS3EwU5UYxe6eqTeC1amNYbEq79cWr1d8KKT87?=
 =?us-ascii?Q?N1DM9U1thTdzioHddtsbXopEYD0hO5Ci2WRQp6oJPf/Oj01WGq7zTFnTh+0x?=
 =?us-ascii?Q?UJ3p3si/Q0cu9DtiNJ0dyf27hI8FXDyuIFSdvssQyKp7cSQL8aURcm5dYa1O?=
 =?us-ascii?Q?h/lQ7FlInVcpYGlztY2XHOGjsXESM4ALKEZQlJadyudSyCapwUfHpGh4M2vQ?=
 =?us-ascii?Q?8iXd+bvXUOGh3HM+Ga+L7YEx2lVRBQdQG46ai2pRIIEMSauGoG5/D7U09CVO?=
 =?us-ascii?Q?w6J/BL1wo1/TCG2USUkZI1hZCOIxkX6YH+4lHEtX5tNHzS8+e27ACfWFVJLq?=
 =?us-ascii?Q?qck0LU1Gb2zwdpMSXqDh/G2t?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13798288-abd3-4914-bcfe-08d950668f5b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2021 18:52:47.3954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6fkxcckAMR/l4m62pTUe0iLFfga1WM/fMPXnlhvTBxIX8OzeSUOPiGL9j8WGZiZI1OuIIL4Xx1pj/N5+P+uAXx7q1esOGCE8IPxcc9gGEus=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2765
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107260110
X-Proofpoint-GUID: dn_ff-Qm9BS5d2ZrLVbT3EmGVHLhQOvy
X-Proofpoint-ORIG-GUID: dn_ff-Qm9BS5d2ZrLVbT3EmGVHLhQOvy
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 lib/x86/processor.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index ec2e508..33ddd50 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -70,6 +70,7 @@
 #define X86_EFLAGS_OF    0x00000800
 #define X86_EFLAGS_IOPL  0x00003000
 #define X86_EFLAGS_NT    0x00004000
+#define X86_EFLAGS_RF    0x00010000
 #define X86_EFLAGS_VM    0x00020000
 #define X86_EFLAGS_AC    0x00040000
 
-- 
2.27.0

